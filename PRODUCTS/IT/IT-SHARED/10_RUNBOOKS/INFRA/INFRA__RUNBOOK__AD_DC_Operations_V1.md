# RUNBOOK — Active Directory : Opérations Domain Controller
**ID :** RUNBOOK__AD_DC_Operations_V1
**Version :** 1.0 | **Agents :** IT-AssistanTI_N3, IT-MaintenanceMaster
**Domaine :** INFRA — Active Directory Infrastructure
**Mis à jour :** 2026-03-20

---

## 1. HEALTH CHECK DC — PROCÉDURE COMPLÈTE

```powershell
$OutDir = "C:\IT_LOGS\AUDIT\DC_$(Get-Date -Format 'yyyyMMdd_HHmm')"
New-Item -ItemType Directory -Path $OutDir -Force | Out-Null
Start-Transcript -Path "$OutDir\DC_HealthCheck.log"

# 1. Services critiques
Write-Host "=== SERVICES ===" -ForegroundColor Cyan
Get-Service NTDS,DNS,Netlogon,KDC,W32Time |
    Select-Object Name, Status, StartType | Format-Table -AutoSize

# 2. Partages SYSVOL et NETLOGON
Write-Host "=== SYSVOL / NETLOGON ===" -ForegroundColor Cyan
net share | Select-String -Pattern "SYSVOL|NETLOGON"

# 3. Réplication AD
Write-Host "=== RÉPLICATION ===" -ForegroundColor Cyan
repadmin /replsummary
repadmin /showrepl

# 4. Rôles FSMO
Write-Host "=== RÔLES FSMO ===" -ForegroundColor Cyan
netdom query fsmo

# 5. DCdiag rapide
Write-Host "=== DCDIAG ===" -ForegroundColor Cyan
dcdiag /q

# 6. Événements critiques (24h)
Write-Host "=== ÉVÉNEMENTS CRITIQUES ===" -ForegroundColor Cyan
$start = (Get-Date).AddHours(-24)
Get-WinEvent -FilterHashtable @{LogName='Directory Service'; StartTime=$start} |
    Where-Object {$_.LevelDisplayName -in 'Error','Critical'} |
    Select-Object -First 20 TimeCreated, Id, Message | Format-Table -Wrap

Stop-Transcript
```

---

## 2. VÉRIFICATION RÉPLICATION AD

```powershell
# Résumé réplication (vue globale)
repadmin /replsummary

# Forcer synchronisation depuis tous les partenaires
repadmin /syncall /AdeP

# Vérifier les objets en attente (lingering objects)
repadmin /removelingeringobjects [DC_cible] [DC_source] [Partition] /Advisory_Mode

# Diagnostique erreurs réplication
repadmin /showrepl * /errorsonly

# Si erreur de réplication — vérifier la topologie
repadmin /showconn
```

### Erreurs courantes réplication

| Code erreur | Cause | Action |
|---|---|---|
| 1256 | DC inaccessible réseau | Vérifier connectivité + DNS |
| 1722 | RPC server unavailable | Vérifier service RPC + firewall |
| 8453 | Accès refusé réplication | Vérifier permissions DSACLS |
| 8606 | Lingering objects | repadmin /removelingeringobjects |
| -2146893022 | Problème Kerberos/heure | Synchroniser W32Time |

---

## 3. SYNCHRONISATION HEURE (W32Time)

```powershell
# Vérifier l'état de la synchronisation
w32tm /query /status
w32tm /query /peers

# Forcer synchronisation
net stop w32time
net start w32time
w32tm /resync /force

# Sur le PDC emulator — configurer source NTP externe
w32tm /config /manualpeerlist:"time.windows.com,0x8 pool.ntp.org,0x8" /syncfromflags:manual /reliable:YES /update
```

---

## 4. VÉRIFICATION DNS SUR DC

```powershell
# Zones DNS hébergées sur ce DC
Get-DnsServerZone | Select-Object ZoneName, ZoneType, IsAutoCreated | Format-Table

# Enregistrements SRV critiques AD
Resolve-DnsName -Name "_ldap._tcp.dc._msdcs.domaine.com" -Type SRV
Resolve-DnsName -Name "_kerberos._tcp.dc._msdcs.domaine.com" -Type SRV

# Ré-enregistrer les enregistrements DNS du DC
ipconfig /registerdns
nltest /dsregdns

# Test résolution interne
Resolve-DnsName "NOM_DC" -Type A
Resolve-DnsName "domaine.com" -Type SOA
```

---

## 5. PRE/POST REBOOT DC

### PRECHECK avant reboot DC
```powershell
# ⚠️ NE JAMAIS reboôter le seul DC de l'environnement sans plan de contingence
# ⚠️ S'assurer qu'un DC secondaire est opérationnel AVANT le reboot

# Vérifier rôles FSMO sur CE DC
netdom query fsmo

# Vérifier réplication OK
repadmin /replsummary

# Vérifier sessions actives
query session /server:$(hostname)

# Vérifier pas de job batch en cours
Get-ScheduledTask | Where-Object {$_.State -eq 'Running'}
```

### POSTCHECK après reboot DC
```powershell
# Attendre 2-3 minutes après le démarrage avant de valider

# Services démarrés
Get-Service NTDS,DNS,Netlogon,KDC,W32Time |
    Select-Object Name, Status | Format-Table

# SYSVOL partagé
net share | Select-String "SYSVOL|NETLOGON"

# Réplication reprise
repadmin /replsummary

# Authentification fonctionnelle
nltest /sc_verify:domaine.com
```

---

## 6. GESTION RÔLES FSMO

```powershell
# Voir les 5 rôles FSMO
netdom query fsmo

# Transfert FSMO vers un autre DC (normal, planifié)
# Sur le DC qui reçoit les rôles :
Move-ADDirectoryServerOperationMasterRole -Identity "NOM_DC_CIBLE" `
    -OperationMasterRole SchemaMaster, DomainNamingMaster, RIDMaster, PDCEmulator, InfrastructureMaster

# ⚠️ Saisie de rôle FSMO (urgence — DC source inaccessible)
# ntdsutil → roles → connections → connect to server [DC_cible] → quit
# → seize [role] → quit → quit
# ⛔ NE SAISIR les rôles QUE si le DC source est définitivement HS
```

---

## 7. NE PAS FAIRE

```
⛔ NE JAMAIS reboôter tous les DCs en même temps
⛔ NE JAMAIS modifier le schéma AD sans approbation et backup
⛔ NE JAMAIS baisser le niveau fonctionnel du domaine/forêt
⛔ NE JAMAIS saisir les rôles FSMO si le DC source est récupérable
⛔ NE JAMAIS désactiver le compte krbtgt directement
⛔ NE JAMAIS supprimer un DC avec ntdsutil sans nettoyage des métadonnées
```

---

## 8. ESCALADE

| Situation | Département | Délai |
|---|---|---|
| Réplication bloquée depuis > 1h | NOC | 30 min |
| DC unique tombé, auth impossible | NOC + INFRA | Immédiat |
| Compromission compte domain admin | SOC | Immédiat |
| Modification schéma AD requise | TECH (approbation) | Planifié |
