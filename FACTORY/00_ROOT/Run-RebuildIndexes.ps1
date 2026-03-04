<#
Run-RebuildIndexes.ps1
Double-click friendly launcher for rebuilding indexes & bundles in this repo.

Usage (double-click): runs with defaults (-Bundles -MirrorSchemas)
Usage (PowerShell):   .\Run-RebuildIndexes.ps1 -Force -Bundles -MirrorSchemas

Notes:
- If PowerShell blocks scripts, use the provided Run-RebuildIndexes.cmd (it uses ExecutionPolicy Bypass).
#>

[CmdletBinding()]
param(
  [switch]$Bundles = $true,
  [switch]$MirrorSchemas = $true,
  [switch]$Force = $false,
  [switch]$NoPause = $false
)

$ErrorActionPreference = "Stop"

function Pause-IfNeeded {
  param([switch]$NoPause)
  if (-not $NoPause) {
    Write-Host ""
    Write-Host "Appuie sur une touche pour fermer..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
  }
}

try {
  # Repo root = folder containing this launcher
  $repo = $PSScriptRoot
  if (-not (Test-Path (Join-Path $repo "scripts\rebuild_indexes.ps1"))) {
    throw "Impossible de trouver scripts\rebuild_indexes.ps1. Assure-toi que ce fichier est placé à la racine du repo root_IA."
  }

  # Basic checks
  if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "ERREUR: Python n'est pas trouvé dans PATH." -ForegroundColor Red
    Write-Host "Installe Python 3.x puis relance. (Ou utilise 'py' si tu l'as — on peut ajuster le script.)" -ForegroundColor Red
    Pause-IfNeeded -NoPause:$NoPause
    exit 1
  }

  Write-Host "Repo: $repo" -ForegroundColor Cyan
  Write-Host "Options: Bundles=$Bundles MirrorSchemas=$MirrorSchemas Force=$Force" -ForegroundColor Cyan

  Push-Location $repo
  try {
    $args = @()
    if ($Bundles) { $args += "-Bundles" }
    if ($MirrorSchemas) { $args += "-MirrorSchemas" }
    if ($Force) { $args += "-Force" }

    # Call the main script
    & (Join-Path $repo "scripts\rebuild_indexes.ps1") @args
    $code = $LASTEXITCODE
    if ($code -ne 0) {
      throw "La commande a retourné un code d'erreur: $code"
    }

    Write-Host ""
    Write-Host "✅ Terminé: indexes/bundles régénérés." -ForegroundColor Green
  }
  finally {
    Pop-Location
  }

  Pause-IfNeeded -NoPause:$NoPause
  exit 0
}
catch {
  Write-Host ""
  Write-Host "❌ Échec: $($_.Exception.Message)" -ForegroundColor Red
  Write-Host $_.Exception.ToString() -ForegroundColor DarkGray
  Pause-IfNeeded -NoPause:$NoPause
  exit 1
}
