# RUNBOOK — Déploiement Infrastructure (Serveur / VM / Service)
**ID :** RUNBOOK__Deployment | **Version :** 2.0
**Agent owner :** IT-InfrastructureMaster | **Équipe :** TEAM__IT
**Domaine :** INFRA — Déploiement
**Date révision :** 2026-03-13

---

## ⚠️ GARDE-FOUS — OBLIGATOIRES
> Référence : `00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md`

**Scope :** Cet agent traite uniquement le déploiement lié au billet actif.
Demandes hors déploiement infra → refus et redirection.

**Données sensibles :**
- ❌ Jamais : credentials de déploiement, clés SSH, certificats privés, IPs dans livrables client
- ❌ Dans livrables client : noms de domaine internes, chemins de configuration
- Remplacer par `[CONFIG MASQUÉE]` dans outputs client-safe

**Actions destructrices :**
- Avant déploiement PROD → `⚠️ Impact : modification de l'environnement de production` + validation
- Rollback planifié obligatoire documenté avant exécution

---

## 1. Objectif
Standardiser le déploiement de nouveaux serveurs, VMs ou services dans l'environnement client :
- Serveurs Windows Server (physiques ou virtuels)
- VMs Hyper-V ou VMware
- Rôles Windows (AD DS, DNS, DHCP, IIS, RDS, Print)
- Services Cloud (Azure IaaS/PaaS)

---

## 2. Déclencheurs
- Nouveau serveur commandé pour un client
- Migration vers virtualisation
- Ajout d'un rôle sur un serveur existant
- Onboarding client complet (infrastructure initiale)

---

## 3. Phase 1 — Pré-déploiement (T-48h minimum)

### 3.1 Collecte des exigences
```yaml
client         : [nom]
ticket_id      : [CW-XXXXXX]
type_serveur   : [physique / VM / cloud]
os             : [Windows Server 2019 / 2022]
rôles          : [DC / DNS / DHCP / IIS / RDS / Print / File / SQL]
ressources     : [vCPU, RAM, disques — tailles]
réseau         : [VLAN, IPs statiques — [À CONFIRMER]]
domaine        : [workgroup / domaine existant / nouveau domaine]
backup         : [politique backup à créer après déploiement]
fenetre        : [date / horaire approuvé]
```

### 3.2 Pré-checks environnement
```powershell
# Ressources disponibles sur l'hôte Hyper-V (lecture seule)
Get-VM | Select-Object Name, State, @{n='RAM_GB';e={$_.MemoryAssigned/1GB}} | Format-Table -Auto
Get-VMHost | Select-Object Name, @{n='RAM_Dispo_GB';e={[math]::Round($_.MemoryAvailable/1GB,1)}} | Format-Table

# Espace datastore
Get-Volume | Select-Object DriveLetter, FileSystemLabel,
  @{n='Total_GB';e={[math]::Round($_.Size/1GB,1)}},
  @{n='Libre_GB';e={[math]::Round($_.SizeRemaining/1GB,1)}} |
  Format-Table -Auto
```

---

## 4. Phase 2 — Déploiement

### 4.1 Checklist déploiement VM Windows Server

**Création de la VM :**
- [ ] Nom conforme au standard : `[SITE]-SVR-[RÔLE][NUM]` (ex: `CLT-SVR-DC01`)
- [ ] Génération 2 (UEFI) si OS >= 2016
- [ ] vCPU / RAM selon spécifications validées
- [ ] Disque OS : minimum 80 GB | disques données séparés
- [ ] Snapshot pre-déploiement créé : `@[BILLET]_PreDeployment_[SERVEUR]_SNAP_[DATE]`

**Installation OS :**
- [ ] ISO Windows Server (version approuvée)
- [ ] Partition système : 60 GB min | reste sur D:
- [ ] Activation Windows (KMS ou MAK selon client)
- [ ] Windows Update : niveau CU courant appliqué

**Configuration post-installation :**
```powershell
# Renommer le serveur (⚠️ Impact : redémarrage requis)
Rename-Computer -NewName "NOM-SERVEUR" -Force
# Configurer fuseau horaire
Set-TimeZone -Name "Eastern Standard Time"
# Vérifier activation Windows
(Get-WmiObject -Class SoftwareLicensingProduct -Filter "Name like 'Windows%'" |
  Where-Object {$_.LicenseStatus -eq 1}).Name
```

**Jonction au domaine :**
```powershell
# ⚠️ Impact : redémarrage requis — validation obligatoire avant
Add-Computer -DomainName "[DOMAINE]" -Restart
```

### 4.2 Installation des rôles
```powershell
# Exemple : installer le rôle DNS + RSAT
# ⚠️ Impact : redémarrage possible selon la configuration
Install-WindowsFeature -Name DNS -IncludeManagementTools -Restart:$false
Install-WindowsFeature -Name RSAT-DNS-Server
```

### 4.3 Snapshot post-déploiement
```
Nom obligatoire : @[BILLET]_PostDeployment_[SERVEUR]_SNAP_[YYYYMMDD_HHMM]
À créer AVANT de configurer les rôles
```

---

## 5. Phase 3 — Validation post-déploiement

```powershell
# Health check complet (lecture seule)
[pscustomobject]@{
  Hostname    = $env:COMPUTERNAME
  OS          = (Get-CimInstance Win32_OperatingSystem).Caption
  RAM_GB      = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1GB,1)
  Uptime      = (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
  Domaine     = (Get-CimInstance Win32_ComputerSystem).Domain
  Activation  = if ((Get-CimInstance SoftwareLicensingProduct -Filter "Name like 'Windows%'" |
                  Where-Object LicenseStatus -eq 1)) {'Activé'} else {'Non activé'}
}
# Disques
Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{n='Libre_GB';e={[math]::Round($_.Free/1GB,1)}} | Format-Table
# Services auto non démarrés
Get-Service | Where-Object {$_.StartType -eq 'Automatic' -and $_.Status -ne 'Running'} | Format-Table Name, Status
```

### Checklist validation finale
- [ ] Serveur joignable depuis les postes clients
- [ ] Nom DNS résolu correctement
- [ ] Jonction domaine confirmée (`whoami /fqdn`)
- [ ] Rôles installés et fonctionnels
- [ ] Backup configuré (ticket séparé si nécessaire)
- [ ] Agent RMM/EDR installé et actif
- [ ] Monitoring configuré dans ConnectWise RMM
- [ ] Documentation CW complète

---

## 6. Livrables CW

### Note interne
```
Prendre connaissance de la demande et connexion à la documentation de l'entreprise.

Déploiement : [nom serveur — sans IP]
Rôles installés : [liste]
Jonction domaine : [FAIT / [À CONFIRMER]]
Snapshot post-déploiement : [nom snapshot]
Agent RMM/EDR : [FAIT / [À CONFIRMER]]
Backup : [configuré / ticket à créer]
Anomalies : [aucune / détails]
```

### Discussion client (client-safe)
```
- Analyse de la demande et préparation de l'environnement.
- Déploiement du nouveau serveur selon les spécifications convenues.
- Installation des rôles requis et validation du bon fonctionnement.
- Protection et supervision activées.
- Prochaine étape : [formation / configuration applicative / surveillance].
```

---

## 7. Escalade
- Problème jonction domaine persistant → `IT-Commandare-TECH`
- Déploiement Azure / hybride → `IT-CloudMaster`
- Architecture complexe multi-sites → `IT-CTOMaster`
