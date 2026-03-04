Write-Host "=== FLAGS Pending Reboot (SQL02) ==="

$flags = [ordered]@{
  CBS_RebootPending    = (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending')
  WU_RebootRequired    = (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired')
  CCM_RebootPending    = (Test-Path 'HKLM:\SOFTWARE\Microsoft\CCM\RebootPending')
  UpdateExeVolatile    = (Test-Path 'HKLM:\SOFTWARE\Microsoft\Updates\UpdateExeVolatile')
  Installer_InProgress = (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\InProgress')
  Installer_RebootReq  = (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\RebootRequired')
  pending_xml_exists   = (Test-Path 'C:\Windows\WinSxS\pending.xml')
}

$pfr = $null
try {
  $pfr = (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name PendingFileRenameOperations -ErrorAction SilentlyContinue).PendingFileRenameOperations
} catch {}

$flags['PendingFileRenameOps'] = [bool]$pfr

$flags.GetEnumerator() | Sort-Object Name | Format-Table Name,Value -Auto

Write-Host "`n=== PendingFileRenameOperations (first 20 pairs) ==="
if ($pfr) {
  $pairs = [int]($pfr.Count/2)
  $maxPairs = [Math]::Min($pairs, 20)
  for ($i=0; $i -lt ($maxPairs*2); $i+=2) {
    "{0}  =>  {1}" -f $pfr[$i], $pfr[$i+1]
  }
  if ($pairs -gt 20) { Write-Host "... ($pairs opérations au total)" }
} else {
  Write-Host "None"
}

Write-Host "`n=== Windows Update errors (last 6h) ==="
$start=(Get-Date).AddHours(-6)
Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Microsoft-Windows-WindowsUpdateClient'; StartTime=$start} -ErrorAction SilentlyContinue |
  Where-Object {$_.LevelDisplayName -in 'Error','Critical'} |
  Select-Object -First 10 TimeCreated,Id,Message |
  Format-Table -Wrap