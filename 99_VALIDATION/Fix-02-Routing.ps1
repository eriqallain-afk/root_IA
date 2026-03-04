<#
.SYNOPSIS
    Fix-02-Routing.ps1 - Consolide les 4 copies de hub_routing.yaml
.DESCRIPTION
    Les 4 fichiers NE SONT PAS de simples doublons - 2 routers differents :

    FACTORY\40_ROUTING\hub_routing.yaml    -> HUB-Router    -> agents FACTORY
      ACTION : CONSERVER - Source verite FACTORY

    FACTORY\80_MACHINES\hub_routing.yaml   -> OPS-RouterIA  -> orchestrateurs PRODUCTS
      ACTION : RENOMMER -> products_routing.yaml (nom plus clair)

    FACTORY\40_RUNBOOKS\hub_routing.yaml   -> Ancien doublon partiel (87L vs 113L)
      ACTION : SUPPRIMER

    FACTORY\90_KNOWLEDGE\LEGACY_MO-HUB\hub_routing.yaml -> Archive historique v1
      ACTION : CONSERVER (ne pas modifier)

.PARAMETER FactoryPath
    Chemin racine FACTORY (auto-detecte depuis Scripts\)
.PARAMETER DryRun
    Voir les actions sans modifier
.EXAMPLE
    .\Fix-02-Routing.ps1 -DryRun
    .\Fix-02-Routing.ps1
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
Write-Host "=== Fix-02-Routing.ps1 - Consolidation hub_routing.yaml ===" -ForegroundColor Cyan
Write-Host "  Mode    : $modeLabel"
Write-Host "  FACTORY : $FactoryPath"
Write-Host ""

$canonical   = Join-Path $FactoryPath "40_ROUTING\hub_routing.yaml"
$machines    = Join-Path $FactoryPath "80_MACHINES\hub_routing.yaml"
$machinesNew = Join-Path $FactoryPath "80_MACHINES\products_routing.yaml"
$runbooks    = Join-Path $FactoryPath "40_RUNBOOKS\hub_routing.yaml"
$orchestrV2  = Join-Path $FactoryPath "80_MACHINES\META_ORCHESTRATOR_V2.yaml"
$backupDir   = Join-Path $FactoryPath "90_KNOWLEDGE\BACKUPS_ROUTING"

Write-Host "ACTION 0 - Backup" -ForegroundColor White
if (-not $DryRun) {
    if (-not (Test-Path $backupDir)) { New-Item -ItemType Directory -Path $backupDir -Force | Out-Null }
    $ts = Get-Date -Format "yyyyMMdd_HHmmss"
    foreach ($f in @($canonical, $machines, $runbooks)) {
        if (Test-Path $f) {
            Copy-Item $f (Join-Path $backupDir ("$(Split-Path $f -Leaf)_$ts"))
            Write-Host "  [BACKUP] $(Split-Path $f -Leaf)" -ForegroundColor DarkGray
        }
    }
    Write-Host "  [OK] Backups dans : FACTORY\90_KNOWLEDGE\BACKUPS_ROUTING\" -ForegroundColor Green
} else {
    Write-Host "  [DRY] Backups seraient crees dans FACTORY\90_KNOWLEDGE\BACKUPS_ROUTING\" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "ACTION 1 - Renommer 80_MACHINES\hub_routing.yaml -> products_routing.yaml" -ForegroundColor White
if (Test-Path $machines) {
    if (Test-Path $machinesNew) {
        Write-Host "  [SKIP] products_routing.yaml existe deja." -ForegroundColor DarkGray
    } else {
        $hdr  = "# products_routing.yaml - Routing PRODUCTS root_IA`n"
        $hdr += "# Router  : OPS-RouterIA`n"
        $hdr += "# Scope   : Orchestrateurs PRODUCTS (IT, DAM, EDU, IASM, TRAD, NEA, PLR)`n"
        $hdr += "# DIFF    : 40_ROUTING\hub_routing.yaml -> HUB-Router -> agents FACTORY`n"
        $hdr += "#           80_MACHINES\products_routing.yaml -> OPS-RouterIA -> PRODUCTS`n`n"
        $content = Get-Content $machines -Raw -Encoding UTF8
        if (-not $DryRun) {
            $cleaned = $content -replace "(?s)^(#[^\n]*\n)+", ""
            $nc = ($hdr + $cleaned) -replace "`r`n", "`n"
            [System.IO.File]::WriteAllBytes($machinesNew, [System.Text.Encoding]::UTF8.GetBytes($nc))
            Remove-Item $machines
            Write-Host "  [OK] Renomme -> products_routing.yaml" -ForegroundColor Green
        } else {
            Write-Host "  [DRY] Renommerait hub_routing.yaml -> products_routing.yaml" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "  [SKIP] 80_MACHINES\hub_routing.yaml introuvable." -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "ACTION 2 - Supprimer 40_RUNBOOKS\hub_routing.yaml" -ForegroundColor White
if (Test-Path $runbooks) {
    if (-not $DryRun) {
        Remove-Item $runbooks
        Write-Host "  [OK] Supprime." -ForegroundColor Green
    } else {
        Write-Host "  [DRY] Supprimerait 40_RUNBOOKS\hub_routing.yaml" -ForegroundColor Yellow
    }
} else {
    Write-Host "  [SKIP] Deja absent." -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "ACTION 3 - Documenter 40_ROUTING\hub_routing.yaml (source verite)" -ForegroundColor White
if (Test-Path $canonical) {
    $cc = Get-Content $canonical -Raw -Encoding UTF8
    if ($cc -match "SOURCE DE VERITE") {
        Write-Host "  [SKIP] Header deja present." -ForegroundColor DarkGray
    } else {
        $hdr2  = "# hub_routing.yaml - Routing FACTORY root_IA [SOURCE DE VERITE]`n"
        $hdr2 += "# Router  : HUB-Router`n"
        $hdr2 += "# Scope   : Agents FACTORY (CTL, HUB, META, OPS, IAHQ) + agents PRODUCTS directs`n"
        $hdr2 += "# DIFF    : Ce fichier -> HUB-Router -> agents granulaires FACTORY`n"
        $hdr2 += "#           80_MACHINES\products_routing.yaml -> OPS-RouterIA -> PRODUCTS`n`n"
        if (-not $DryRun) {
            $cleaned2 = $cc -replace "(?s)^(#[^\n]*\n)+", ""
            $nc2 = ($hdr2 + $cleaned2) -replace "`r`n", "`n"
            [System.IO.File]::WriteAllBytes($canonical, [System.Text.Encoding]::UTF8.GetBytes($nc2))
            Write-Host "  [OK] Header ajoute dans 40_ROUTING\hub_routing.yaml" -ForegroundColor Green
        } else {
            Write-Host "  [DRY] Ajouterait header dans 40_ROUTING\hub_routing.yaml" -ForegroundColor Yellow
        }
    }
}

Write-Host ""
Write-Host "ACTION 4 - Mettre a jour META_ORCHESTRATOR_V2.yaml" -ForegroundColor White
if (Test-Path $orchestrV2) {
    $oc = Get-Content $orchestrV2 -Raw -Encoding UTF8
    if ($oc -match "hub_routing\.yaml") {
        if (-not $DryRun) {
            $of = $oc -replace "80_MACHINES/hub_routing\.yaml","80_MACHINES/products_routing.yaml"
            $of = $of -replace "80_MACHINES\\hub_routing\.yaml","80_MACHINES\products_routing.yaml"
            $of = $of -replace "`r`n","`n"
            [System.IO.File]::WriteAllBytes($orchestrV2, [System.Text.Encoding]::UTF8.GetBytes($of))
            Write-Host "  [OK] hub_routing -> products_routing dans META_ORCHESTRATOR_V2.yaml" -ForegroundColor Green
        } else {
            Write-Host "  [DRY] Mettrait a jour dans META_ORCHESTRATOR_V2.yaml" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  [SKIP] Aucune reference hub_routing dans META_ORCHESTRATOR_V2.yaml" -ForegroundColor DarkGray
    }
} else {
    Write-Host "  [SKIP] META_ORCHESTRATOR_V2.yaml introuvable" -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "--- Sources de verite apres fix ---" -ForegroundColor Cyan
Write-Host "  FACTORY  : FACTORY\40_ROUTING\hub_routing.yaml       (HUB-Router)"
Write-Host "  PRODUCTS : FACTORY\80_MACHINES\products_routing.yaml  (OPS-RouterIA)"
Write-Host "  ARCHIVE  : FACTORY\90_KNOWLEDGE\LEGACY_MO-HUB\        (ne pas modifier)"
Write-Host ""
if ($DryRun) { Write-Host "[DRY-RUN] Relancer sans -DryRun pour appliquer." -ForegroundColor Yellow }
else { Write-Host "[OK] Fix-02 termine." -ForegroundColor Green }
