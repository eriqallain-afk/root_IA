<#
.SYNOPSIS
    Fix-03-SchemaVersion.ps1 - Ajoute schema_version manquant sur 3 agents META
.DESCRIPTION
    PROBLEME : META-PromptMaster, META-PlaybookBuilder, META-ArchitecteChoix
    n ont pas de schema_version -> CTL-WatchdogIA les marque non conformes.
.PARAMETER FactoryPath
    Chemin racine FACTORY (auto-detecte)
.PARAMETER DryRun
    Voir les actions sans modifier
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
Write-Host "=== Fix-03-SchemaVersion.ps1 - Ajout schema_version manquant ===" -ForegroundColor Cyan
Write-Host "  Mode    : $modeLabel"
Write-Host "  FACTORY : $FactoryPath"
Write-Host ""

$targets = @("META-PromptMaster","META-PlaybookBuilder","META-ArchitecteChoix")
$fixedCount = 0

foreach ($agent in $targets) {
    $path = Join-Path $FactoryPath "20_AGENTS\META\$agent\agent.yaml"
    Write-Host "  -> $agent" -ForegroundColor White
    if (-not (Test-Path $path)) {
        Write-Host "     [SKIP] agent.yaml introuvable" -ForegroundColor Yellow
        continue
    }
    $bytes   = [System.IO.File]::ReadAllBytes($path)
    $content = [System.Text.Encoding]::UTF8.GetString($bytes)
    if ($content -match "schema_version") {
        Write-Host "     [SKIP] schema_version deja present." -ForegroundColor DarkGray
        continue
    }
    $newContent = ("schema_version: `"1.0`"`n" + $content) -replace "`r`n","`n"
    if (-not $DryRun) {
        [System.IO.File]::WriteAllBytes($path, [System.Text.Encoding]::UTF8.GetBytes($newContent))
        Write-Host "     [OK] schema_version: `"1.0`" ajoute" -ForegroundColor Green
    } else {
        Write-Host "     [DRY] Ajouterait schema_version: `"1.0`" en ligne 1" -ForegroundColor Yellow
    }
    $fixedCount++
}

Write-Host ""
if ($DryRun) {
    Write-Host "[DRY-RUN] $fixedCount agent(s) seraient corriges. Relancer sans -DryRun." -ForegroundColor Yellow
} else {
    Write-Host "[OK] Fix-03 termine - $fixedCount agent(s) corrige(s)." -ForegroundColor Green
}
