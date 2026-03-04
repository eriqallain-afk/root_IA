<#
.SYNOPSIS
    Fix-01-CRLF.ps1 - Convertit les fichiers YAML de CRLF vers LF
.DESCRIPTION
    PROBLEME : 42 fichiers YAML en encodage CRLF causent des erreurs
    silencieuses sur Linux/Mac et des echecs CI/CD.
    SOLUTION  : Conversion vers LF + creation .gitattributes.
.PARAMETER FactoryPath
    Chemin racine FACTORY (auto-detecte depuis Scripts\)
.PARAMETER DryRun
    Voir les actions sans modifier
.EXAMPLE
    .\Fix-01-CRLF.ps1
    .\Fix-01-CRLF.ps1 -DryRun
#>
param(
    [string]$FactoryPath = "",
    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not $FactoryPath) {
    $FactoryPath = Join-Path (Split-Path $PSScriptRoot -Parent) "FACTORY"
}

if (-not (Test-Path $FactoryPath)) {
    Write-Host "[ERREUR] FACTORY introuvable : $FactoryPath" -ForegroundColor Red
    exit 1
}

if ($DryRun) { $modeLabel = "DRY-RUN" } else { $modeLabel = "EXECUTION" }
Write-Host ""
Write-Host "=== Fix-01-CRLF.ps1 - Normalisation encodage YAML ===" -ForegroundColor Cyan
Write-Host "  Mode    : $modeLabel"
Write-Host "  FACTORY : $FactoryPath"
Write-Host ""

$fixedCount   = 0
$skippedCount = 0
$errorCount   = 0

$targetDirs = @("20_AGENTS","00_CONTROL","10_TEAMS","30_PLAYBOOKS","40_ROUTING","50_POLICIES","80_MACHINES")

foreach ($dir in $targetDirs) {
    $fullDir = Join-Path $FactoryPath $dir
    if (-not (Test-Path $fullDir)) {
        Write-Host "  [SKIP] Dossier absent : $dir" -ForegroundColor DarkGray
        continue
    }
    $files = Get-ChildItem -Path $fullDir -Recurse -Filter "*.yaml" -File
    foreach ($file in $files) {
        try {
            $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
            $text  = [System.Text.Encoding]::UTF8.GetString($bytes)
            if ($text.Contains("`r`n")) {
                $fixed = $text -replace "`r`n", "`n"
                $rel   = $file.FullName.Replace($FactoryPath + "\", "")
                if (-not $DryRun) {
                    $fixedBytes = [System.Text.Encoding]::UTF8.GetBytes($fixed)
                    [System.IO.File]::WriteAllBytes($file.FullName, $fixedBytes)
                    Write-Host "  [FIX] $rel" -ForegroundColor Green
                } else {
                    Write-Host "  [DRY] Serait corrige : $rel" -ForegroundColor Yellow
                }
                $fixedCount++
            } else {
                $skippedCount++
            }
        } catch {
            Write-Host "  [ERR] $($file.Name) - $($_.Exception.Message)" -ForegroundColor Red
            $errorCount++
        }
    }
}

$rootIA      = Split-Path $FactoryPath -Parent
$gitAttrPath = Join-Path $rootIA ".gitattributes"

if (-not $DryRun) {
    if (Test-Path $gitAttrPath) {
        Write-Host ""
        Write-Host "  [EXIST] .gitattributes deja present." -ForegroundColor DarkGray
    } else {
        $ga = "* text=auto`n*.yaml text eol=lf`n*.yml  text eol=lf`n*.md   text eol=lf`n*.py   text eol=lf`n*.json text eol=lf`n*.ps1  text eol=crlf`n*.png  binary`n*.zip  binary`n"
        [System.IO.File]::WriteAllText($gitAttrPath, $ga, [System.Text.Encoding]::ASCII)
        Write-Host ""
        Write-Host "  [NEW] .gitattributes cree dans : $rootIA" -ForegroundColor Green
    }
} else {
    Write-Host ""
    Write-Host "  [DRY] .gitattributes serait cree dans : $rootIA" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "--- Resultat ---" -ForegroundColor Cyan
Write-Host "  Corriges : $fixedCount fichiers" -ForegroundColor $(if ($fixedCount -gt 0) { "Green" } else { "White" })
Write-Host "  Deja OK  : $skippedCount fichiers"
Write-Host "  Erreurs  : $errorCount fichiers" -ForegroundColor $(if ($errorCount -gt 0) { "Red" } else { "White" })
Write-Host ""
if ($DryRun) {
    Write-Host "[DRY-RUN] Relancer sans -DryRun pour appliquer." -ForegroundColor Yellow
} elseif ($errorCount -eq 0) {
    Write-Host "[OK] Fix-01 termine." -ForegroundColor Green
} else {
    Write-Host "[WARN] Fix-01 termine avec $errorCount erreur(s)." -ForegroundColor Yellow
}
