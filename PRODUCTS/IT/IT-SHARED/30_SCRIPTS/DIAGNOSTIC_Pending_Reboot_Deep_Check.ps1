# Pending Reboot Deep Check (FIXED) - SQL02
Write-Host "=== Pending Reboot Deep Check (SQL02) ===" -ForegroundColor Cyan

$keys = [ordered]@{
  CBS_RebootPending    = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending'
  WU_RebootRequired    = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired'
  CCM_RebootPending    = 'HKLM:\SOFTWARE\Microsoft\CCM\RebootPending'
  UpdateExeVolatile    = 'HKLM:\SOFTWARE\Microsoft\Updates\UpdateExeVolatile'
  Installer_InProgress = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\InProgress'
  Installer_RebootReq  = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\RebootRequired'
}

# PendingFileRenameOperations
$pfr = $null
try {
  $p = Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name PendingFileRenameOperations -ErrorAction SilentlyContinue
  if ($p) { $pfr = $p.PendingFileRenameOperations }
} catch {}

$pendingXml = Test-Path 'C:\Windows\WinSxS\pending.xml'

$flags = [ordered]@{}
foreach ($k in $keys.Keys) { $flags[$k] = (Test-Path $keys[$k]) }
$flags['PendingFileRenameOps'] = [bool]$pfr
$flags['pending_xml_exists']   = $pendingXml

Write-Host "`n=== FLAGS (what keeps pending reboot TRUE) ===" -ForegroundColor Cyan
$flags.GetEnumerator() | Sort-Object Name | Format-Table Name,Value -Auto

Write-Host "`n=== PendingFileRenameOperations (first 15) ===" -ForegroundColor Cyan
if ($pfr) {
  $pairs = [int]($pfr.Count/2)
  $maxPairs = [Math]::Min($pairs, 15)
  for ($i=0; $i -lt ($maxPairs*2); $i+=2) {
    [pscustomobject]@{ Source=$pfr[$i]; Target=$pfr[$i+1] }
  } | Format-Table -Wrap
  if ($pairs -gt 15) { Write-Host "... ($pairs opérations au total)" -ForegroundColor Yellow }
} else {
  Write-Host "None"
}

Write-Host "`n=== Windows Update recent failures (last 6h) ===" -ForegroundColor Cyan
$start=(Get-Date).AddHours(-6)
Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Microsoft-Windows-WindowsUpdateClient'; StartTime=$start} -ErrorAction SilentlyContinue |
  Where-Object {$_.LevelDisplayName -in 'Error','Critical'} |
  Select-Object -First 10 TimeCreated,Id,Message | Format-Table -Wrap