# RUNBOOK — Configuration et Diagnostic Réseau
**ID :** RUNBOOK__Network_Setup | **Version :** 2.0
**Agent owner :** IT-NetworkMaster | **Équipe :** TEAM__IT
**Domaine :** INFRA — Réseau
**Date révision :** 2026-03-13

---

## ⚠️ GARDE-FOUS — OBLIGATOIRES
> Référence : `00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md`

**Scope :** Cet agent traite uniquement la configuration réseau liée au billet actif.
Questions générales IT non liées au ticket → refus et redirection.

**Données sensibles :**
- ❌ JAMAIS : adresses IP dans les livrables client (note interne : toujours masquées aussi)
- ❌ JAMAIS : community strings SNMP, mots de passe switch/routeur, clés VPN
- Remplacer par `[IP MASQUÉE]`, `[CREDENTIALS RÉSEAU MASQUÉS]`
- Note de principe : les IPs sont exclues de TOUS les outputs, même internes

**Actions à risque :**
- Modification VLAN → `⚠️ Impact : interruption réseau potentielle`
- Modification règle firewall → `⚠️ Impact : coupure accès possible` + ticket dédié + approbation

---

## 1. Objectif
Procédures de configuration et de diagnostic réseau MSP :
- Configuration VLAN et switchs gérés
- Diagnostic connectivité LAN/WAN/VPN
- Configuration DNS/DHCP
- Dépannage Firewall (Fortinet, SonicWall, pfSense, Cisco)

---

## 2. Déclencheurs
- Nouveau VLAN à créer pour un client
- Problème de connectivité signalé (ticket support / alerte NOC)
- Onboarding réseau nouveau site
- Modification architecture (ajout équipement, changement ISP)

---

## 3. Diagnostic réseau — Lecture seule (prioritaire)

### 3.1 Tests de base depuis un poste Windows
```powershell
# Collecte complète (lecture seule — aucun impact)
$OutDir = "$env:TEMP\NET_DIAG"; New-Item -ItemType Directory $OutDir -Force | Out-Null

"=== Configuration réseau ===" | Tee-Object "$OutDir\net_config.txt"
ipconfig /all | Tee-Object -Append "$OutDir\net_config.txt"

"=== Table de routage ===" | Tee-Object "$OutDir\routing.txt"
route print | Tee-Object -Append "$OutDir\routing.txt"

"=== Résolution DNS ===" | Tee-Object "$OutDir\dns.txt"
Resolve-DnsName "google.com" -Type A -ErrorAction SilentlyContinue | Tee-Object -Append "$OutDir\dns.txt"
nslookup google.com | Tee-Object -Append "$OutDir\dns.txt"

"=== Test connectivité externe ===" | Tee-Object "$OutDir\connectivity.txt"
Test-NetConnection "8.8.8.8" -InformationLevel Detailed | Tee-Object -Append "$OutDir\connectivity.txt"
Test-NetConnection "1.1.1.1" -Port 443 | Tee-Object -Append "$OutDir\connectivity.txt"

"Diagnostics sauvegardés dans : $OutDir"
```

### 3.2 Diagnostic DNS/DHCP (serveur)
```powershell
# Services DNS et DHCP
Get-Service -Name DNS, DHCPServer -ErrorAction SilentlyContinue |
  Select-Object Name, Status, StartType | Format-Table -Auto

# Événements DNS (2 dernières heures, erreurs seulement)
$Start = (Get-Date).AddHours(-2)
Get-WinEvent -FilterHashtable @{LogName='DNS Server'; StartTime=$Start} -ErrorAction SilentlyContinue |
  Where-Object {$_.LevelDisplayName -in 'Error','Critical','Warning'} |
  Select-Object -First 20 TimeCreated, Id, Message | Format-Table -Wrap

# Baux DHCP actifs (lecture seule)
Get-DhcpServerv4Scope -ErrorAction SilentlyContinue |
  Select-Object ScopeId, Name, State,
    @{n='Utilisés';e={(Get-DhcpServerv4ScopeStatistics -ScopeId $_.ScopeId).InUse}},
    @{n='Libres';e={  (Get-DhcpServerv4ScopeStatistics -ScopeId $_.ScopeId).Free}} |
  Format-Table -Auto
```

---

## 4. Configuration standard

### 4.1 VLAN — Checklist configuration
- [ ] Numéro VLAN défini et documenté (ex: VLAN 10 = Data, VLAN 20 = Voice, VLAN 99 = Mgmt)
- [ ] Switch(es) : VLAN créé, ports trunk/access configurés
- [ ] Routeur/Firewall : interface sous-interface ou L3 switch configuré
- [ ] DHCP scope créé pour le VLAN (plage, passerelle, DNS)
- [ ] Test de connectivité depuis un poste dans le VLAN

### 4.2 Configuration DNS statique (bonnes pratiques)
```powershell
# Ajouter un enregistrement A (lecture documentation — modifier via console DNS recommandé)
# Validation : tester la résolution après ajout
Resolve-DnsName "[FQDN]" -Server "[SERVEUR-DNS]" -Type A -ErrorAction SilentlyContinue
```

### 4.3 Checklist Firewall (générique)
- [ ] Règle créée avec scope minimal (principe du moindre privilège)
- [ ] Source/destination explicites (pas de ANY/ANY en production)
- [ ] Log activé sur la règle (traçabilité)
- [ ] Test après création (validation que le flux souhaité passe)
- [ ] Documentation dans CW : numéro de règle, objet, durée si temporaire

---

## 5. Dépannage — Arbres de décision

### Problème : site sans Internet

```
Étape 1 → Ping gateway locale  →  KO : problème LAN/switch/VLAN
                                →  OK : continuer
Étape 2 → Ping IP ISP          →  KO : contacter ISP
                                →  OK : continuer
Étape 3 → Résolution DNS        →  KO : DNS en panne ou MAL configuré
                                →  OK : problème applicatif
```

### Problème : VPN ne se connecte pas

```
1. Vérifier statut du service VPN (client et serveur)
2. Vérifier logs VPN (événements d'authentification)
3. Tester depuis réseau externe différent (exclure restriction ISP)
4. Vérifier certificat VPN (expiration ?)
5. Si MFA : vérifier que les codes sont acceptés (synchronisation temps)
→ Escalader IT-SecurityMaster si credentials compromis suspectés
```

---

## 6. Livrables CW

### Note interne
```
Prendre connaissance de la demande et connexion à la documentation de l'entreprise.

Symptôme : [description]
Tests effectués : [liste des commandes — résultats synthétiques, IPs masquées]
Cause identifiée : [description] / [À CONFIRMER]
Action corrective : [FAIT / SUGGESTION]
Résultat : [OK / [À CONFIRMER]]
Prochaines étapes : [surveillance / test utilisateur / [aucune]]
```

### Discussion client (client-safe)
```
- Analyse de la demande et diagnostic de l'environnement réseau.
- [Action effectuée : ex: Reconfiguration du service DNS / correction du VLAN].
- Validation de la connectivité : [OK / en cours].
- Prochaine étape : [surveillance / test utilisateur / aucune action requise].
```

---

## 7. Escalade
- Incident réseau P1 (site down) → `IT-Commandare-NOC` immédiat
- Architecture complexe (SD-WAN, BGP, multi-sites) → `IT-NetworkMaster` + `IT-CTOMaster`
- Suspicion intrusion réseau → `IT-SecurityMaster` immédiat
