<# scripts/rebuild_indexes.ps1
Entry point (PowerShell) to rebuild indexes using Python.
#>
[CmdletBinding()]
param(
  [switch]$Bundles = $false,
  [switch]$MirrorSchemas = $false,
  [switch]$Force = $false
)

$ErrorActionPreference = "Stop"
$repo = Split-Path -Parent $PSScriptRoot

if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
  Write-Host "ERREUR: Python introuvable dans PATH." -ForegroundColor Red
  exit 1
}

& python (Join-Path $PSScriptRoot "rebuild_indexes.py")
exit $LASTEXITCODE
