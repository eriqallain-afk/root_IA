# RUNBOOK — Hyper-V : Opérations & Maintenance
**ID :** RUNBOOK__HyperV_Operations_V1
**Version :** 1.0 | **Agents :** IT-AssistanTI_N3, IT-MaintenanceMaster
**Domaine :** INFRA — Virtualisation Hyper-V
**Mis à jour :** 2026-03-20

---

## 1. HEALTH CHECK HÔTE HYPER-V

```powershell
Start-Transcript -Path "C:\IT_LOGS\AUDIT\HyperV_HealthCheck_$(Get-Date -Format 'yyyyMMdd_HHmm').log"

# Ressources hôte
Write-Host "=== RESSOURCES HÔTE ===" -ForegroundColor Cyan
$os = Get-CimInstance Win32_OperatingSystem
Get-VMHost | Select-Object Name,
    @{N='CPU_LogicalProc';E={$_.LogicalProcessorCount}},
    @{N='RAM_Total_GB';E={[math]::Round($_.MemoryCapacity/1GB,1)}} | Format-List

# RAM disponible hôte
[pscustomobject]@{
    RAM_Free_GB = [math]::Round($os.FreePhysicalMemory/1MB,1)
    RAM_Total_GB = [math]::Round($os.TotalVisibleMemorySize/1MB,1)
} | Format-List

# État de toutes les VMs
Write-Host "=== ÉTAT DES VMs ===" -ForegroundColor Cyan
Get-VM | Select-Object Name, State, CPUUsage,
    @{N='MemAssigned_GB';E={[math]::Round($_.MemoryAssigned/1GB,2)}},
    @{N='MemDemand_GB';E={[math]::Round($_.MemoryDemand/1GB,2)}},
    Uptime | Format-Table -AutoSize

# Snapshots existants (attention aux snapshots anciens)
Write-Host "=== SNAPSHOTS ===" -ForegroundColor Cyan
Get-VMSnapshot -VMName * | Select-Object VMName, Name, CreationTime,
    @{N='Age_Jours';E={((Get-Date)-$_.CreationTime).Days}} |
    Sort-Object Age_Jours -Descending | Format-Table -AutoSize

# Stockage datastores
Write-Host "=== STOCKAGE ===" -ForegroundColor Cyan
Get-VMHost | Select-Object -ExpandProperty HostHardDiskDrives |
    Get-Disk | Get-Partition | Get-Volume |
    Where-Object {$_.DriveLetter} |
    Select-Object DriveLetter,
        @{N='Size_GB';E={[math]::Round($_.Size/1GB,1)}},
        @{N='Free_GB';E={[math]::Round($_.SizeRemaining/1GB,1)}},
        @{N='Free_%';E={[math]::Round($_.SizeRemaining/$_.Size*100,0)}} |
    Format-Table -AutoSize

# Services Hyper-V
Write-Host "=== SERVICES ===" -ForegroundColor Cyan
Get-Service -Name vmms,vmcompute,vhdsvc,vmicheartbeat |
    Select-Object Name, Status, StartType | Format-Table -AutoSize

Stop-Transcript
```

---

## 2. GESTION DES SNAPSHOTS

```
⚠️ RÈGLE FONDAMENTALE SUR LES SNAPSHOTS :
   - Snapshot AVANT maintenance → supprimer dans les 72h
   - Snapshot APRÈS validation → supprimer immédiatement
   - Snapshot > 7 jours = problème → investiguer immédiatement
   - Snapshot sur DC = dangereux (USN rollback) → éviter, utiliser Windows Server Backup
```

### Convention de nommage (conforme NAMING_STANDARDS)
```
@T12345_Preboot_SRV-APP01_SNAP_20260320_2145
@T12345_Postpatch_SRV-APP01_SNAP_20260320_2230
```

### Créer un snapshot
```powershell
# ⚠️ Confirmer que la VM n'est pas un DC avant de créer un snapshot
$VMName = "SRV-APP01"
$Ticket = "T12345"
$Phase = "Preboot"
$SnapName = "@$Ticket`_$Phase`_$VMName`_SNAP_$(Get-Date -Format 'yyyyMMdd_HHmm')"

Checkpoint-VM -Name $VMName -SnapshotName $SnapName
Write-Host "Snapshot créé : $SnapName"
```

### Supprimer un snapshot (après validation)
```powershell
# Lister les snapshots d'une VM
Get-VMSnapshot -VMName "SRV-APP01" | Select-Object Name, CreationTime

# Supprimer un snapshot spécifique
Remove-VMSnapshot -VMName "SRV-APP01" -Name "@T12345_Preboot_SRV-APP01_SNAP_20260320_2145"

# ⚠️ La suppression fusionne les deltas — peut prendre du temps sur gros disques
# Surveiller l'espace disque pendant l'opération
```

### Supprimer TOUS les snapshots d'une VM (attention)
```powershell
# ⚠️ Valider les changements AVANT de supprimer tous les checkpoints
Get-VMSnapshot -VMName "SRV-APP01" | Remove-VMSnapshot
```

---

## 3. MIGRATION VM À CHAUD (LIVE MIGRATION)

```powershell
# Prérequis : Hyper-V cluster ou Live Migration configurée
# ⚠️ Vérifier l'espace disponible sur l'hôte de destination

# Migrer une VM vers un autre hôte
Move-VM -Name "SRV-APP01" -DestinationHost "NOM_HOTE_DESTINATION" -IncludeStorage `
    -DestinationStoragePath "D:\Hyper-V\VMs"

# Vérifier la progression
Get-VM -Name "SRV-APP01" | Select-Object Name, State, ComputerName
```

---

## 4. DÉPANNAGE VM NE DÉMARRE PAS

```powershell
# Vérifier l'état de la VM
Get-VM "SRV-APP01" | Select-Object Name, State, Status, CPUUsage

# Voir les événements Hyper-V liés à cette VM
Get-WinEvent -FilterHashtable @{
    LogName='Microsoft-Windows-Hyper-V-Worker-Admin'
    StartTime=(Get-Date).AddHours(-2)
} | Where-Object {$_.Message -match "SRV-APP01"} |
    Select-Object TimeCreated, Message | Format-List
```

### États courants et actions

| État VM | Signification | Action |
|---|---|---|
| `Off` | Arrêtée normalement | Démarrer si planifié |
| `Saved` | Hibernée | `Resume-VM` ou `Start-VM` |
| `Paused` | Suspendue | `Resume-VM` |
| `Critical` | Ressources insuffisantes | Vérifier RAM/CPU/stockage hôte |
| `Running` mais figée | Problème OS invité | Vérifier l'intégration Hyper-V |

---

## 5. PRECHECK AVANT REBOOT DE L'HÔTE HYPER-V

```powershell
# ⚠️ AVANT de reboôter l'hôte :
# 1. Migrer ou éteindre TOUTES les VMs
# 2. Vérifier qu'il n'y a plus de VMs en état Running

# Sauvegarder toutes les VMs (Saved State)
Get-VM | Where-Object {$_.State -eq 'Running'} | Save-VM
# OU les éteindre proprement
Get-VM | Where-Object {$_.State -eq 'Running'} | Stop-VM -Force

# Vérifier qu'aucune VM ne tourne
Get-VM | Select-Object Name, State | Where-Object {$_.State -ne 'Off'}
```

---

## 6. NE PAS FAIRE

```
⛔ NE JAMAIS créer un snapshot sur un DC (risque USN rollback, corruption AD)
   → Utiliser Windows Server Backup pour les DCs
⛔ NE JAMAIS laisser un snapshot > 72h en production
⛔ NE JAMAIS supprimer les fichiers .AVHD/.AVHDX manuellement — utiliser Hyper-V Manager
⛔ NE JAMAIS déplacer des VHD/VHDX manuellement pendant que la VM tourne
⛔ NE JAMAIS augmenter la RAM dynamique maximum au-delà de la RAM physique disponible
⛔ NE JAMAIS configurer les VMs avec plus de vCPU que le ratio recommandé (4:1 max)
```

---

## 7. ESCALADE

| Situation | Département | Délai |
|---|---|---|
| Hôte Hyper-V inaccessible (VMs down) | NOC | Immédiat |
| Espace datastore < 10% | NOC + INFRA | Dans l'heure |
| Corruption VHDX détectée | INFRA + BackupDR | Immédiat |
| Migration Live en échec répété | INFRA | Dans la journée |
