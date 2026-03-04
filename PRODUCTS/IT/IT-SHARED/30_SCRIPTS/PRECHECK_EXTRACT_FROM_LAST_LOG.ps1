$folder = "C:\Users\eallain\OneDrive - Ited Solutions\Bureau\TEMP\.LOG"
Get-ChildItem $folder -Filter "*.log" | Sort-Object LastWriteTime -Descending |
  Select-Object LastWriteTime, Name, FullName

$log = (Get-ChildItem $folder -Filter "*.log" | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
$log
Test-Path $log

$patterns = @(
  "HOST / OS / UPTIME",
  "PATCH CONTEXT",
  "RESOURCES \(CPU/RAM\) \+ DISKS",
  "NETWORK",
  "PENDING REBOOT",
  "SERVICES \(AUTO but NOT RUNNING\)",
  "EVENT LOGS",
  "ROLE: DOMAIN CONTROLLER",
  "ROLE: FILE/GENERIC",
  "repadmin",
  "DCDIAG",
  "QUICK FLAGS"
)

$patterns | ForEach-Object {
  "`n===== MATCH: $_ ====="
  Select-String -Path $log -Pattern $_ -Context 0,80 |
    ForEach-Object { $_.Context.DisplayPostContext -join "`n" }
}

$log = "C:\Users\eallain\OneDrive - Ited Solutions\Bureau\TEMP\.log"
Test-Path $log
Test-Path $log