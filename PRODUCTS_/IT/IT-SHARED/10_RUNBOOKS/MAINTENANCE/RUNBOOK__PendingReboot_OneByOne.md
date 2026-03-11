# RUNBOOK — Pending Reboot (Windows) — Validation + reboot 1 serveur à la fois

## Objectif
- Confirmer **pourquoi** le pending reboot est levé (CBS/WU/PendingFileRename/CCM).
- Appliquer un reboot **contrôlé** (si approuvé) et **re-valider**.

## PRECHECK — identifie la source
```powershell
"=== Pending reboot flags ==="
$CBS = Test-Path 'HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Component Based Servicing\\RebootPending'
$WU  = Test-Path 'HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\WindowsUpdate\\Auto Update\\RebootRequired'
$PFR = (Get-ItemProperty 'HKLM:\\SYSTEM\\CurrentControlSet\\Control\\Session Manager' -Name PendingFileRenameOperations -ErrorAction SilentlyContinue) -ne $null
$CCM = Test-Path 'HKLM:\\SOFTWARE\\Microsoft\\CCM\\RebootPending'
[pscustomobject]@{CBS_RebootPending=$CBS; WU_RebootRequired=$WU; PendingFileRenameOperations=$PFR; CCMClientRebootPending=$CCM; PendingReboot=($CBS -or $WU -or $PFR -or $CCM)}

"=== Last boot ==="; (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
"=== Sessions (RDS) ==="; query user
"=== Disks ==="; Get-PSDrive -PSProvider FileSystem | Select Name,Free,@{n='FreeGB';e={[math]::Round($_.Free/1GB,2)}} | ft -Auto
```

## Décision
- Si **prod/critique** : valider fenêtre + dépendances + approbation.
- Si DC : exécuter le runbook DC avant et après.

## REBOOT (manuel)
> Faire **uniquement** après approbation.

```powershell
# Option 1: depuis le serveur
Restart-Computer -Force

# Option 2: depuis un poste admin
Restart-Computer -ComputerName "SRV-NAME" -Force
```

## POSTCHECK
Rejouer le PRECHECK + valider les services critiques.

## Si pending reboot reste TRUE
- Noter quel flag reste TRUE.
- Vérifier :
  - Windows Update en attente (re-scan / redémarrage additionnel)
  - Installer/rollback en cours
  - Software distribution corruption
- Escalader si 2 reboots n'éteignent pas le flag **CBS**.

