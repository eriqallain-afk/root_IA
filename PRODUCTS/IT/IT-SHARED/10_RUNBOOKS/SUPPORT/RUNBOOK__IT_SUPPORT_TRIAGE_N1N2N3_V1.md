# RUNBOOK — Triage Support TI N1/N2/N3 MSP
**ID :** RUNBOOK__IT_SUPPORT_TRIAGE_N1N2N3_V1  
**Version :** 1.0 | **Agent :** IT-SupportMaster  
**Applicable :** Tout ticket support entrant (NOC / SOC / Support / Autre)

---

## ARBRE DE DÉCISION INITIAL

```
TICKET ENTRANT (via CW / email / téléphone)
│
├─ Sécurité (virus, ransomware, phishing, accès non autorisé)
│   └─ → P1/P2 → @IT-SecurityMaster + @IT-Commandare-NOC
│
├─ Infrastructure critique down (DC, réseau principal, backup)
│   └─ → P1/P2 → @IT-Commandare-NOC → @IT-InfrastructureMaster
│
├─ Cloud/M365 inaccessible (Exchange, SharePoint, Teams)
│   └─ → P2 → @IT-CloudMaster
│
├─ Réseau (connectivité site, VPN, WiFi)
│   └─ → P2/P3 → @IT-NetworkMaster
│
├─ Serveur non critique (lent, service arrêté)
│   └─ → P2/P3 → @IT-InfrastructureMaster
│
├─ Backup en échec
│   └─ → P2/P3 → @IT-BackupDRMaster
│
├─ Téléphonie (VoIP coupure)
│   └─ → P2/P3 → @IT-VoIPMaster
│
├─ Logiciel métier (ERP, CRM)
│   └─ → P3 → N2 ou fournisseur applicatif
│
└─ Workstation / utilisateur (PC, imprimante, compte)
    └─ → P3/P4 → N1 direct
```

---

## NIVEAU 1 — WORKSTATION & UTILISATEUR

### 1.1 Réinitialisation mot de passe AD
```powershell
# ⚠️ Validation identité utilisateur requise avant exécution
Set-ADAccountPassword -Identity "username" -Reset -NewPassword (Read-Host -AsSecureString "Nouveau MDP")
Set-ADUser -Identity "username" -ChangePasswordAtLogon $true
Unlock-ADAccount -Identity "username"
```

### 1.2 PC lent / gelé
Checklist N1 :
1. Redémarrage simple → résout 40% des cas
2. Task Manager : CPU/RAM usage élevé ? Identifier processus
3. Espace disque < 10% → nettoyer (Disk Cleanup, dossier TEMP)
4. Windows Update en cours silencieusement ?
5. Event Viewer → erreurs récentes Application/System
6. Si > 30 min non résolu : escalader N2

### 1.3 Problème imprimante
Checklist N1 :
1. Câble/WiFi connecté ? PC voit l'imprimante ?
2. Redémarrer spooler : `Restart-Service Spooler`
3. File d'attente : supprimer jobs bloqués
4. Réinstaller driver si nécessaire
5. Si imprimante réseau : ping l'IP de l'imprimante

### 1.4 Outlook / email ne fonctionne pas
1. Tester webmail (OWA / outlook.com) — isole client vs serveur
2. Outlook en mode Safe (`outlook.exe /safe`)
3. Rebuild profil Outlook si corrompu
4. Si tous les utilisateurs affectés → P2 escalade IT-CloudMaster

---

## NIVEAU 2 — RÉSEAU LOCAL & SERVEURS NON CRITIQUES

### 2.1 Connectivité réseau partielle
```powershell
# Tests de base
Test-NetConnection -ComputerName "8.8.8.8" -InformationLevel Detailed
Test-NetConnection -ComputerName "gateway_ip" -Port 80
ipconfig /all
tracert gateway_ip
# DNS
Resolve-DnsName google.com
```

### 2.2 Service Windows arrêté
```powershell
# Vérifier état + redémarrer
Get-Service -Name "ServiceName" | Select-Object Name, Status, StartType
Start-Service -Name "ServiceName"
# Si échec — consulter Event Viewer
Get-EventLog -LogName System -Source "*ServiceName*" -Newest 20
```

### 2.3 Espace disque critique
```powershell
# Identifier les gros fichiers/dossiers
Get-ChildItem -Path "C:\" -Recurse -ErrorAction SilentlyContinue |
    Sort-Object Length -Descending | 
    Select-Object -First 20 FullName, @{N='SizeMB';E={[math]::Round($_.Length/1MB,2)}}
```

---

## NIVEAU 3 — INFRASTRUCTURE CRITIQUE

**Toujours via @IT-Commandare-TECH ou spécialiste dédié.**

Checklist N3 minimum avant escalade :
- [ ] Symptôme précis documenté
- [ ] Heure de début
- [ ] Assets affectés listés
- [ ] Actions N1/N2 déjà tentées documentées
- [ ] Impact business évalué
- [ ] Bloc POUR COPILOT préparé pour @IT-InterventionCopilot

---

## PROCÉDURE ESCALADE

```yaml
# Bloc POUR COPILOT (à transmettre à @IT-InterventionCopilot)
/obs [ticket_id] | [catégorie] | P[1/2/3/4]
/contexte: [description complète]
/fait:
  - [action 1 effectuée]
  - [action 2 effectuée]
/validations:
  - [test 1 à effectuer]
/escalade: @[Agent] — raison: [motif]
```

---

## SLA CIBLES MSP

| Priorité | Temps réponse | Temps résolution | Escalade auto |
|----------|--------------|-----------------|---------------|
| P1 | 15 min | 4h | 30 min → Senior |
| P2 | 30 min | 8h | 2h → Senior |
| P3 | 2h | 24h | 4h → N2 |
| P4 | 4h | 72h | 24h → N2 |
