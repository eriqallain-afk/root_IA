<#
Run-Validation.ps1
Runner: refs + naming.
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory=$false)]
  [string]$RootPath = "C:\Intranet_EA\EA_IA\GPT-Enterprise\root_IA\FACTORY"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$here = $PSScriptRoot

Write-Host "=== EA_IA Validation Runner ==="
Write-Host ("RootPath = {0}" -f $RootPath)
Write-Host ""

$ec = 0

& (Join-Path $here "Validate-Refs.ps1") -RootPath $RootPath
if ($LASTEXITCODE -ne 0) { $ec = 1 }

Write-Host ""
& (Join-Path $here "Validate-Naming.ps1") -RootPath $RootPath
if ($LASTEXITCODE -ne 0) { $ec = 1 }

Write-Host ""
if ($ec -eq 0) {
  Write-Host "[OK]  Tout est conforme."
  exit 0
} else {
  Write-Host "[ERR] Validations en echec. Corrige, puis relance."
  exit 1
}
