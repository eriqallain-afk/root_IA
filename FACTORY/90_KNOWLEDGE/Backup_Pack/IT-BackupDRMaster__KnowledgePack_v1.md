# IT-BackupDRMaster — Knowledge Pack v1

> Pack complet Backup & DR MSP : Veeam, Datto, procédures RPO/RTO, tests.

---

## 1. RÉFÉRENCE RPO/RTO — Standards MSP

| Criticité | RPO max | RTO max | Solution recommandée |
|-----------|---------|---------|---------------------|
| **Critique** (DC, ERP, Exchange) | 1h | 4h | Datto BCDR + Veeam local + réplication offsite |
| **Important** (File Server, SQL secondaire) | 4h | 8h | Veeam local + backup cloud |
| **Standard** (serveurs non critiques) | 24h | 24h | Veeam daily + backup cloud |
| **Postes** (si contractuel) | 24h | 48h | Backup agent postes |

> **RPO** = Recovery Point Objective — perte de données maximale acceptable  
> **RTO** = Recovery Time Objective — délai de restauration maximal acceptable

---

## 2. CHECKLIST — Configuration Backup Nouveau Client

```
SETUP BACKUP MSP — Nouveau client
─────────────────────────────────────
VEEAM BACKUP & REPLICATION
[ ] Veeam B&R installé + licence activée
[ ] Repository configuré (local + offsite)
[ ] Jobs configurés pour tous les serveurs critiques
[ ] Schedule : quotidien (serveurs critiques), hebdo (standards)
[ ] Rétention configurée : 30 jours minimum (90 jours recommandé)
[ ] Email notifications configurées (succès + échec)
[ ] Test restauration planifié (< 30 jours post-setup)

DATTO BCDR (si inclus)
[ ] Agent Datto installé sur serveurs critiques
[ ] Backup schedule vérifié (toutes les heures recommandé)
[ ] Vérification screenshot VM (virtualisation locale)
[ ] Cloud backup activé et validé
[ ] Rapport Datto configuré vers NOC

DOCUMENTATION
[ ] Plan DR documenté (quels serveurs, quel ordre de restauration)
[ ] Contact urgence client documenté (DR)
[ ] Procédure restauration testée et documentée
[ ] RPO/RTO documentés dans contrat + CMDB
```

---

## 3. PLAYBOOK — Restauration Veeam

```
RESTAURATION VEEAM — Procédure standard
─────────────────────────────────────
AVANT DE COMMENCER
[ ] Confirmer le scope : fichiers / serveur complet / VM ?
[ ] Confirmer le point de restauration à utiliser (date/heure)
[ ] Notifier client (OPR) : début restauration + ETA
[ ] RFC Light si restauration prod majeure

RESTAURATION FICHIERS/DOSSIERS
1. Veeam B&R → Home → Restores
2. Guest File Recovery → Windows
3. Sélectionner VM + point de restauration
4. Parcourir arborescence → sélectionner fichiers
5. Restore → Keep (garder original) ou Overwrite
6. Valider intégrité fichiers restaurés avec client

RESTAURATION VM COMPLÈTE (Instant Recovery)
1. Veeam B&R → Home → Instant VM Recovery
2. Sélectionner backup + point de restauration
3. Sélectionner datastore destination + réseau
4. Démarrer VM depuis backup (accès immédiat < 5 min)
5. Valider services + connectivité
6. Migrer vers stockage production (Storage vMotion ou Quick Migration)
7. Valider CMDB + informer client

RESTAURATION BARE METAL (Physical)
1. Booter depuis Veeam Recovery Media (USB/ISO)
2. Bare Metal Recovery → Network → Sélectionner backup
3. Sélectionner disque destination
4. Restaurer + redémarrer
5. Valider drivers + réseau + services
```

---

## 4. RUNBOOK — Test DR (trimestriel)

```
TEST DR MSP — Procédure trimestrielle
─────────────────────────────────────
PRÉPARATION
[ ] Planifier fenêtre test (hors heures si possible)
[ ] Notifier client (OPR)
[ ] Préparer template rapport DR test

TEST 1 — Restauration fichier aléatoire (5 min)
  1. Sélectionner fichier récent dans backup
  2. Restaurer vers emplacement alternatif
  3. Valider intégrité : hash ou ouverture fichier
  4. Documenter : ✅ RPO atteint / ❌ Échec

TEST 2 — Démarrage VM depuis backup Datto (15 min)
  1. Datto Portal → Virtualize (local)
  2. Démarrer VM depuis dernier point de backup
  3. Valider : login OS + services principaux
  4. Mesurer temps démarrage → valider vs RTO
  5. Éteindre VM test
  6. Documenter : ✅ RTO atteint / ❌ Dépassement

TEST 3 — Restauration SQL (30 min, si applicable)
  1. Restaurer base SQL test vers SQL instance test
  2. Valider intégrité base (DBCC CHECKDB)
  3. Test requête sur données récentes
  4. Documenter

RAPPORT DR TEST
[ ] Date + durée test
[ ] Résultats par test (✅/❌)
[ ] RPO mesuré vs RPO contractuel
[ ] RTO mesuré vs RTO contractuel
[ ] Anomalies constatées
[ ] Actions correctives si échec
[ ] Signature technicien + date prochain test
```

---

## 5. CHECKLIST — Diagnostic Backup en Échec

```
BACKUP EN ÉCHEC — Diagnostic
─────────────────────────────────────
[ ] Lire le message d'erreur exact dans Veeam/Datto
[ ] Vérifier espace disque repository backup
[ ] Vérifier connectivité réseau vers repository
[ ] Vérifier que VM/serveur source est online
[ ] Vérifier que les services Veeam sont démarrés
[ ] Vérifier logs Veeam (C:\ProgramData\Veeam\Backup\)
[ ] Vérifier les snapshot VMware/Hyper-V (stuck snapshots ?)
[ ] Vérifier exclusions antivirus (Veeam doit être exclu)
[ ] Tester backup manuel immédiat

ERREURS FRÉQUENTES VEEAM
"Unable to truncate SQL logs" → Vérifier mode de récupération SQL + permissions
"Failed to create snapshot" → Snapshots VMware bloqués → supprimer manuellement
"The semaphore timeout" → Problème réseau → vérifier MTU + bande passante
"Access is denied" → Permissions service Veeam → reconfigurer credentials
"Not enough space" → Repository plein → nettoyer ou étendre
```

---

## 6. COMMANDES POWERSHELL — Backup

```powershell
# Veeam PowerShell Toolkit
Add-PSSnapin VeeamPSSnapIn

# Lister tous les jobs backup
Get-VBRJob | Select Name, JobType, LastRun, LastResult

# Dernière session d'un job
Get-VBRJob -Name "Backup-ClientXYZ-DC01" | Get-VBRJobObject

# Lister les points de restauration disponibles
Get-VBRRestorePoint | Where {$_.Name -like "*DC01*"} | Select Name, CreationTime

# Démarrer un job manuellement
Start-VBRJob -Job (Get-VBRJob -Name "Backup-ClientXYZ-DC01")

# Vérifier espace repository
Get-VBRBackupRepository | Select Name, FriendlyPath, TotalSpace, FreeSpace

# Windows Server Backup (WSB) - état
Get-WBSummary                         # Résumé dernière sauvegarde
Get-WBJob -Previous 5                  # 5 derniers jobs
```

---

## 7. KPIs BACKUP MSP

| KPI | Définition | Cible |
|-----|-----------|-------|
| **Backup Success Rate** | % jobs backup réussis | ≥ 99% |
| **RPO Compliance** | % clients avec backup dans RPO contractuel | 100% |
| **RTO Test Compliance** | % clients avec test DR réussi < RTO | 100% |
| **Test DR Frequency** | Fréquence tests DR validés | Trimestriel min |
| **Backup Coverage** | % serveurs critiques avec backup actif | 100% |
| **Recovery Test Success** | % tests restauration réussis | ≥ 95% |

---

> Voir aussi : RUNBOOK__IT_BACKUP_DR_TEST_V1.md | IT__Severity_Matrix.md (S0 = DR requis)
