# PENDING-REBOOT DIAG - SQL02
Write-Host "=== Pending Reboot Deep Check ===" -ForegroundColor Cyan
$keys = [ordered]@{
  "CBS_RebootPending"      = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending"
  "WU_RebootRequired"      = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired"
  "CCM_RebootPending"      = "HKLM:\SOFTWARE\Microsoft\CCM\RebootPending"
  "UpdateExeVolatile"      = "HKLM:\SOFTWARE\Microsoft\Updates\UpdateExeVolatile"
  "Installer_InProgress"   = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\InProgress"
  "Installer_RebootReq"    = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\RebootRequired"
}

$result = [ordered]@{}
foreach ($k in $keys.Keys) { $result[$k] = Test-Path $keys[$k] }

# PendingFileRenameOperations
$pfr = $null
try {
  $p = Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name PendingFileRenameOperations -ErrorAction SilentlyContinue
  if ($p) { $pfr = $p.PendingFileRenameOperations }
} catch {}

$pendingXml = Test-Path "C:\Windows\WinSxS\pending.xml"

[pscustomobject]@{
  CBS_RebootPending    = $result["CBS_RebootPending"]
  WU_RebootRequired    = $result["WU_RebootRequired"]
  CCM_RebootPending    = $result["CCM_RebootPending"]
  PendingFileRenameOps = [bool]$pfr
  pending_xml_exists   = $pendingXml
  UpdateExeVolatile    = $result["UpdateExeVolatile"]
  Installer_InProgress = $result["Installer_InProgress"]
  Installer_RebootReq  = $result["Installer_RebootReq"]
} | Format-List

Write-Host "`n=== PendingFileRenameOperations (sample) ===" -ForegroundColor Cyan
if ($pfr) {
  $maxPairs = [Math]::Min([int]($pfr.Count/2), 15)
  for ($i=0; $i -lt ($maxPairs*2); $i+=2) {
    [pscustomobject]@{ Source=$pfr[$i]; Target=$pfr[$i+1] }
  } | Format-Table -Wrap
  if (($pfr.Count/2) -gt 15) { Write-Host "... ($([int]($pfr.Count/2)) opérations au total)" -ForegroundColor Yellow }
} else {
  Write-Host "None"
}

Write-Host "`n=== Windows Update recent failures (last 4h) ===" -ForegroundColor Cyan
$start=(Get-Date).AddHours(-4)
Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Microsoft-Windows-WindowsUpdateClient'; StartTime=$start} -ErrorAction SilentlyContinue |
  Where-Object {$_.LevelDisplayName -in 'Error','Critical'} |
  Select-Object -First 10 TimeCreated,Id,Message | Format-Table -Wrap

Write-Host "`n=== SUMMARY ===" -ForegroundColor Cyan
$flags = @(
  "CBS_RebootPending","WU_RebootRequired","CCM_RebootPending","PendingFileRenameOps","pending_xml_exists",
  "UpdateExeVolatile","Installer_InProgress","Installer_RebootReq"
)
$summary = [ordered]@{}
foreach($f in $flags){ $summary[$f] = (Get-Variable -Name result -ErrorAction SilentlyContinue) | Out-Null }