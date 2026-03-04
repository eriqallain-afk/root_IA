$log = "C:\Users\eallain\OneDrive - Ited Solutions\Bureau\TEMP\.log"
$patterns = @(
  "HOST / OS / UPTIME",
  "PENDING REBOOT",
  "DISKS",
  "SERVICES \(AUTO but NOT RUNNING\)",
  "EVENT LOGS",
  "ROLE: DOMAIN CONTROLLER",
  "repadmin",
  "DCDIAG",
  "QUICK FLAGS"
)
$patterns | ForEach-Object {
  "`n===== MATCH: $_ ====="
  Select-String -Path $log -Pattern $_ -Context 0,60 | ForEach-Object { $_.Context.DisplayPostContext -join "`n" }
}