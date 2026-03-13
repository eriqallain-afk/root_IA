<#
Run-Validation.ps1
Runner principal : Validate-Refs + Validate-Naming.
Corrections 2026-03-13:
  - RootPath default corrige (EA4A -> EA4AI)
  - Unblock-File automatique (evite PSSecurityException)
  - 100% ASCII (compatible PS5.1 ANSI)
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory=$false)]
  [string]$RootPath = "C:\Intranet_EA\EA4AI\GPT-Enterprise\root_IA\FACTORY"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$here = $PSScriptRoot

# Auto-deblocage des scripts du dossier (evite signature requise)
Get-ChildItem -Path $here -Filter "*.ps1" -ErrorAction SilentlyContinue |
  ForEach-Object { Unblock-File -Path $_.FullName -ErrorAction SilentlyContinue }
Get-ChildItem -Path (Join-Path $here "_lib") -Filter "*.ps1" -ErrorAction SilentlyContinue |
  ForEach-Object { Unblock-File -Path $_.FullName -ErrorAction SilentlyContinue }

Write-Host "=== EA4AI Validation Runner ===" -ForegroundColor Cyan
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
  Write-Host "[OK]  Tout est conforme." -ForegroundColor Green
  exit 0
} else {
  Write-Host "[ERR] Validations en echec. Corrige, puis relance." -ForegroundColor Red
  exit 1
}
