# RUNBOOK — Configuration et Validation Backup/DR
**ID :** RUNBOOK__Backup_Configuration | **Version :** 2.0
**Agent owner :** IT-BackupDRMaster | **Équipe :** TEAM__IT
**Domaine :** INFRA — Backup & Disaster Recovery
**Date révision :** 2026-03-13

---

## ⚠️ GARDE-FOUS — OBLIGATOIRES
> Référence : `00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md`

**Scope :** Cet agent répond uniquement sur la configuration backup du billet actif.
Toute demande hors périmètre backup/DR/stockage est refusée et redirigée.

**Données sensibles :**
- ❌ Jamais : credentials de backup, tokens de chiffrement, clés de déduplication
- ❌ Dans livrables client : aucun chemin UNC, aucun nom de repo sensible
- Remplacer par `[REPO MASQUÉ]` / `[CREDENTIALS MASQUÉS]` dans les outputs

**Actions :**
- Avant toute restauration → `⚠️ Impact : restauration écrasera les données actuelles` + validation
- Avant modification config backup → `⚠️ Impact : interruption possible de la fenêtre de sauvegarde`

---

## 1. Objectif
Configurer, valider et dépanner les solutions de backup MSP :
- **Veeam Backup & Replication** (on-prem / cloud)
- **Windows Server Backup** (natif)
- **BackupRadar** (supervision)
- **Azure Backup / Recovery Services Vault**

---

## 2. Déclencheurs
- Nouveau client ou nouveau serveur à protéger
- Backup en échec (alerte BackupRadar / NOC)
- Validation mensuelle / test DR planifié
- Changement infra nécessitant mise à jour de la politique

---

## 3. Périmètre inclus / exclus

| Inclus ✅ | Exclus ❌ |
|-----------|----------|
| Configuration jobs Veeam | Projets DR complets multi-sites |
| Validation et test de restauration | Configuration SAN/NAS primaire |
| Supervision BackupRadar | Gestion des licences Veeam |
| Azure Backup policies | Architecture cloud (→ IT-CloudMaster) |

---

## 4. Préparation (avant configuration)

### 4.1 Informations requises (inputs)
```yaml
client         : [nom client]
ticket_id      : [CW-XXXXXX]
serveurs_scope : [liste des serveurs / VMs]
solution       : [Veeam / WSB / Azure / BackupRadar]
fréquence      : [quotidienne / hebdo / etc.]
rétention      : [jours / semaines]
destination    : [NAS local / Cloud / Azure]
fenetre        : [ex: 22h-04h]
```

### 4.2 Pré-checks obligatoires
```powershell
# Espace disponible sur destination (lecture seule)
Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{n='LibreGB';e={[math]::Round($_.Free/1GB,1)}} | Format-Table -Auto

# Services Veeam (si applicable)
Get-Service | Where-Object {$_.Name -like 'Veeam*'} | Format-Table Name, Status, StartType

# Dernière exécution backup (Windows Server Backup)
$wbs = Get-WBSummary -ErrorAction SilentlyContinue
if ($wbs) {
  [pscustomobject]@{
    LastSuccessful = $wbs.LastSuccessfulBackupTime
    LastFailed     = $wbs.LastFailedBackupTime
    NextScheduled  = $wbs.NextBackupTime
  }
}
```

---

## 5. Configuration standard

### 5.1 Politique backup MSP recommandée

| Type | Fréquence | Rétention | Destination |
|------|-----------|-----------|-------------|
| Backup complet | Hebdo (dim) | 4 semaines | NAS + Cloud |
| Incrémental | Quotidien | 14 jours | NAS local |
| Copie hors site | Hebdo | 3 mois | Cloud / Azure |
| Test restauration | Mensuel | N/A | Environnement test |

### 5.2 Checklist configuration Veeam
- [ ] Job créé avec nom conforme : `BACKUP_[CLIENT]_[SCOPE]_[FRÉQUENCE]`
- [ ] Fenêtre de maintenance respectée
- [ ] Compression : `Optimal` | Déduplification : `Activée`
- [ ] Chiffrement : activé (clé gérée hors CW — `[CREDENTIALS MASQUÉS]`)
- [ ] Notification email configurée (alertes succès + échec)
- [ ] Immutabilité activée si destination Azure/S3 compatible
- [ ] Test de restauration planifié (mensuel)

### 5.3 Checklist configuration Azure Backup
- [ ] Recovery Services Vault créé : région = même que la VM
- [ ] Politique de sauvegarde : fréquence + rétention selon SLA client
- [ ] Agent MARS installé (si serveurs physiques)
- [ ] Alertes Azure Monitor configurées
- [ ] Test de restauration en sandbox documenté

---

## 6. Validation post-configuration

### 6.1 Vérification jobs (lecture seule)
```powershell
# État des jobs Veeam via PowerShell (si module dispo)
if (Get-Module -ListAvailable -Name Veeam.Backup.PowerShell) {
    Import-Module Veeam.Backup.PowerShell -WarningAction SilentlyContinue
    Get-VBRJob | Select-Object Name, IsScheduleEnabled,
        @{n='DernierStatut';e={$_.GetLastResult()}},
        @{n='DernièreExec';e={$_.LatestRunLocal}} |
        Format-Table -AutoSize
} else {
    "Module Veeam PS non disponible — vérifier via console Veeam"
}
```

### 6.2 Checklist validation finale
- [ ] Backup exécuté avec succès (statut `Success` ou `Warning`)
- [ ] Durée dans la fenêtre de maintenance
- [ ] Taille cohérente (ni trop petite = données manquantes, ni trop grande = anomalie)
- [ ] Alerte BackupRadar configurée et active
- [ ] Documentation CW mise à jour

---

## 7. Dépannage — Problèmes fréquents

| Symptôme | Cause probable | Action |
|----------|---------------|--------|
| `Error: Cannot connect to repository` | Réseau ou credentials expirés | Vérifier connectivité + re-tester credentials (sans les noter) |
| `Warning: Some VMs were excluded` | VM éteinte ou snapshot lock | Vérifier état VM + forcer snapshot release |
| `Backup size = 0 KB` | Source vide ou filtre trop restrictif | Revoir scope du job |
| Job planifié ne démarre pas | Service Veeam arrêté | `Start-Service VeeamBackupSvc` (après validation) |
| Restauration échoue | Point de restauration corrompu | Tester un point différent + escalader si systématique |

---

## 8. Livrables CW

### Note interne (détaillée)
```
Prendre connaissance de la demande et connexion à la documentation de l'entreprise.

Configuration backup effectuée pour : [scope]
Solution : [Veeam/WSB/Azure]
Fenêtre : [horaire]
Rétention : [valeur]
Destination : [type général — chemin UNC masqué]
Test de restauration : [FAIT / PLANIFIÉ / [À CONFIRMER]]
Résultat validation : [OK / WARNING — détails]
Prochaine étape : [surveillance / test mensuel planifié]
```

### Discussion client (client-safe)
```
- Analyse de la demande et vérification de l'environnement de sauvegarde.
- Configuration de la politique backup selon les exigences convenues.
- Validation du bon fonctionnement : premier backup exécuté avec succès.
- Prochaine étape : [test de restauration planifié / surveillance automatique active].
```

---

## 9. Escalade
- Backup systématiquement en échec > 3 jours → `IT-Commandare-NOC`
- Perte de données confirmée → `IT-Commandare-NOC` + `IT-BackupDRMaster` + Senior immédiat
- Problème Azure Backup → `IT-CloudMaster`
