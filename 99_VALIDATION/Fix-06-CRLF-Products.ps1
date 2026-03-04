<#
.SYNOPSIS
    Fix-06-CRLF-Products.ps1 - Convertit les fichiers YAML de CRLF vers LF dans PRODUCTS\
.DESCRIPTION
    PROBLEME : 986 fichiers YAML dans PRODUCTS\ ont des fins de ligne CRLF (Windows).
               Fix-01-CRLF.ps1 ne ciblait que FACTORY\. Ce script complete la correction.
    SOLUTION  : Conversion LF sur tous les .yaml et .yml de PRODUCTS\
               Exclusion automatique des dossiers WIP non-actifs (DAM_ConstructionOS, DAM_OS, DAM_standalone)
.PARAMETER ProductsPath
    Chemin racine PRODUCTS (auto-detecte depuis Scripts\)
.PARAMETER IncludeWIP
    Inclure aussi les dossiers WIP (DAM_ConstructionOS, DAM_OS, DAM_standalone)
    Attention : DAM_ConstructionOS contient 761 fichiers CRLF - peut etre long
.PARAMETER DryRun
    Voir les actions sans modifier aucun fichier
.PARAMETER Product
    Cibler un seul produit (ex: -Product IASM)
.EXAMPLE
    .\Fix-06-CRLF-Products.ps1
    .\Fix-06-CRLF-Products.ps1 -DryRun
    .\Fix-06-CRLF-Products.ps1 -Product IASM
    .\Fix-06-CRLF-Products.ps1 -IncludeWIP
    .\Fix-06-CRLF-Products.ps1 -IncludeWIP -DryRun
#>
param(
    [string]$ProductsPath = "",
    [string]$Product      = "",
    [switch]$IncludeWIP,
    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ── Auto-detection du chemin PRODUCTS ────────────────────────────────────────
if (-not $ProductsPath) {
    $ProductsPath = Join-Path (Split-Path $PSScriptRoot -Parent) "PRODUCTS"
}

if (-not (Test-Path $ProductsPath)) {
    Write-Host "[ERREUR] PRODUCTS introuvable : $ProductsPath" -ForegroundColor Red
    Write-Host "         Verifier que le script est dans le dossier Scripts\ du repo." -ForegroundColor Red
    exit 1
}

# ── Dossiers WIP exclus par defaut ───────────────────────────────────────────
$wipFolders = @("DAM_ConstructionOS", "DAM_OS", "DAM_standalone")

# ── Mode ─────────────────────────────────────────────────────────────────────
if ($DryRun) { $modeLabel = "DRY-RUN" } else { $modeLabel = "EXECUTION" }

Write-Host ""
Write-Host "=== Fix-06-CRLF-Products.ps1 - Normalisation YAML dans PRODUCTS\ ===" -ForegroundColor Cyan
Write-Host "  Mode     : $modeLabel"
Write-Host "  PRODUCTS : $ProductsPath"
if ($Product)    { Write-Host "  Produit  : $Product (mode cible unique)" -ForegroundColor Yellow }
if ($IncludeWIP) { Write-Host "  WIP      : INCLUS (DAM_ConstructionOS + DAM_OS + DAM_standalone)" -ForegroundColor Yellow }
else             { Write-Host "  WIP      : exclus (relancer avec -IncludeWIP pour les inclure)" -ForegroundColor DarkGray }
Write-Host ""

$fixedCount   = 0
$skippedCount = 0
$errorCount   = 0
$reportLines  = @()

# ── Selectionner les dossiers produits a traiter ──────────────────────────────
if ($Product) {
    $productDirs = @(Get-Item (Join-Path $ProductsPath $Product) -ErrorAction SilentlyContinue)
    if (-not $productDirs) {
        Write-Host "[ERREUR] Produit introuvable : $Product" -ForegroundColor Red
        exit 1
    }
} else {
    $productDirs = Get-ChildItem -Path $ProductsPath -Directory
}

# ── Traitement par produit ────────────────────────────────────────────────────
foreach ($prodDir in $productDirs) {
    $prodName = $prodDir.Name

    # Exclusion WIP sauf -IncludeWIP
    if (-not $IncludeWIP -and $wipFolders -contains $prodName) {
        Write-Host "  [SKIP-WIP] $prodName" -ForegroundColor DarkGray
        continue
    }

    $files = Get-ChildItem -Path $prodDir.FullName -Recurse -Include "*.yaml","*.yml" -File
    $prodFixed   = 0
    $prodSkipped = 0
    $prodErrors  = 0

    foreach ($file in $files) {
        try {
            $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
            $text  = [System.Text.Encoding]::UTF8.GetString($bytes)

            if ($text.Contains("`r`n")) {
                $fixed = $text -replace "`r`n", "`n"
                $rel   = $file.FullName.Replace($ProductsPath + "\", "")

                if (-not $DryRun) {
                    $fixedBytes = [System.Text.Encoding]::UTF8.GetBytes($fixed)
                    [System.IO.File]::WriteAllBytes($file.FullName, $fixedBytes)
                    Write-Host "  [FIX] $rel" -ForegroundColor Green
                } else {
                    Write-Host "  [DRY] Serait corrige : $rel" -ForegroundColor Yellow
                }
                $prodFixed++
                $fixedCount++
            } else {
                $prodSkipped++
                $skippedCount++
            }
        } catch {
            Write-Host "  [ERR] $($file.FullName) - $($_.Exception.Message)" -ForegroundColor Red
            $prodErrors++
            $errorCount++
        }
    }

    # Ligne de rapport par produit
    $status = if ($prodErrors -gt 0) { "ERREUR" } elseif ($prodFixed -gt 0) { "CORRIGE" } else { "CLEAN" }
    $color  = if ($prodErrors -gt 0) { "Red" } elseif ($prodFixed -gt 0) { "Green" } else { "DarkGray" }
    Write-Host "  [$status] $prodName : $prodFixed corriges, $prodSkipped deja OK" -ForegroundColor $color
    $reportLines += "  $prodName : $prodFixed corriges | $prodSkipped OK | $prodErrors erreurs"
}

# ── Rapport final ─────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "─────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host " RAPPORT PAR PRODUIT" -ForegroundColor Cyan
foreach ($line in $reportLines) { Write-Host $line }
Write-Host ""
Write-Host "─────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host " TOTAL" -ForegroundColor Cyan
Write-Host "  Corriges : $fixedCount fichiers" -ForegroundColor $(if ($fixedCount -gt 0) { "Green" } else { "White" })
Write-Host "  Deja OK  : $skippedCount fichiers"
Write-Host "  Erreurs  : $errorCount fichiers"  -ForegroundColor $(if ($errorCount -gt 0) { "Red" } else { "White" })
Write-Host ""

if ($DryRun) {
    Write-Host "[DRY-RUN] Aucun fichier modifie. Relancer sans -DryRun pour appliquer." -ForegroundColor Yellow
} elseif ($errorCount -eq 0 -and $fixedCount -gt 0) {
    Write-Host "[OK] Fix-06 termine. $fixedCount fichiers corriges." -ForegroundColor Green
} elseif ($errorCount -eq 0 -and $fixedCount -eq 0) {
    Write-Host "[OK] Fix-06 termine. Aucun CRLF detecte - PRODUCTS deja propre." -ForegroundColor Green
} else {
    Write-Host "[WARN] Fix-06 termine avec $errorCount erreur(s)." -ForegroundColor Yellow
}
Write-Host ""
