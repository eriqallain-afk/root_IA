<#
.SYNOPSIS
    Fix-04-SyncOPS.ps1 - Migre et synchronise les agents OPS dans tous les produits

.DESCRIPTION
    OPERATION EN 2 PHASES :

    PHASE 1 - MIGRATION (si necessaire)
      Detecte les agents OPS encore dans 20_Agents\ et les deplace vers OPS\
      Avant : PRODUCTS\<produit>\20_Agents\OPS-RouterIA\
      Apres  : PRODUCTS\<produit>\OPS\OPS-RouterIA\

    PHASE 2 - SYNCHRONISATION
      Copie les agents OPS canoniques depuis FACTORY\20_AGENTS\OPS\
      vers PRODUCTS\<produit>\OPS\ dans chaque produit

    STRUCTURE CIBLE :
      PRODUCTS\
        IT\
          OPS\                  <- runtime infra (miroir FACTORY\20_AGENTS\OPS\)
            OPS-RouterIA\
            OPS-PlaybookRunner\
            OPS-DossierIA\
          20_Agents\            <- agents metier IT uniquement
            IT-OrchestratorMSP\
            IT-ScriptMaster\
            ...
        DAM\
          OPS\
          20_Agents\
        ...

    AVANTAGES :
      - Miroir exact de la FACTORY (FACTORY\20_AGENTS\OPS\)
      - OPS clairement separes des agents metier
      - Sync script toujours le meme chemin relatif OPS\
      - Visibilite immediate : infra vs domaine

.PARAMETER FactoryPath
    Chemin racine FACTORY (auto-detecte depuis Scripts\)
.PARAMETER ProductsPath
    Chemin racine PRODUCTS (auto-detecte depuis Scripts\)
.PARAMETER SourceSubDir
    Sous-dossier agents actuel dans chaque produit (defaut: 20_Agents)
.PARAMETER DryRun
    Voir les actions sans modifier
.PARAMETER SkipMigration
    Ignorer la Phase 1 (migration) et faire seulement la sync
.PARAMETER SkipSync
    Ignorer la Phase 2 (sync) et faire seulement la migration

.EXAMPLE
    .\Fix-04-SyncOPS.ps1 -DryRun          # Preview complet
    .\Fix-04-SyncOPS.ps1                   # Migration + Sync
    .\Fix-04-SyncOPS.ps1 -SkipMigration   # Sync seulement
    .\Fix-04-SyncOPS.ps1 -SkipSync        # Migration seulement
#>
param(
    [string]$FactoryPath  = "",
    [string]$ProductsPath = "",
    [string]$SourceSubDir = "20_Agents",
    [switch]$DryRun,
    [switch]$SkipMigration,
    [switch]$SkipSync
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$rootIA = Split-Path $PSScriptRoot -Parent
if (-not $FactoryPath)  { $FactoryPath  = Join-Path $rootIA "FACTORY"  }
if (-not $ProductsPath) { $ProductsPath = Join-Path $rootIA "PRODUCTS" }

if (-not (Test-Path $FactoryPath)) {
    Write-Host "[ERREUR] FACTORY introuvable : $FactoryPath" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path $ProductsPath)) {
    Write-Host "[ERREUR] PRODUCTS introuvable : $ProductsPath" -ForegroundColor Red
    exit 1
}

if ($DryRun) { $modeLabel = "DRY-RUN" } else { $modeLabel = "EXECUTION" }

Write-Host ""
Write-Host "=== Fix-04-SyncOPS.ps1 - Migration + Synchronisation OPS ===" -ForegroundColor Cyan
Write-Host "  Mode     : $modeLabel"
Write-Host "  FACTORY  : $FactoryPath"
Write-Host "  PRODUCTS : $ProductsPath"
Write-Host ""

$opsAgents  = @("OPS-RouterIA","OPS-PlaybookRunner","OPS-DossierIA")
$sourceBase = Join-Path $FactoryPath "20_AGENTS\OPS"

foreach ($agent in $opsAgents) {
    if (-not (Test-Path (Join-Path $sourceBase $agent))) {
        Write-Host "[ERREUR] Source FACTORY manquante : 20_AGENTS\OPS\$agent\" -ForegroundColor Red
        exit 1
    }
}

$versionYaml = Join-Path $sourceBase "OPS-RouterIA\agent.yaml"
if (Test-Path $versionYaml) {
    $vLine = (Get-Content $versionYaml | Select-String "^version:") -replace "version:\s*[`"']?","" -replace "[`"']",""
    Write-Host "  Version OPS canonique : $vLine" -ForegroundColor Cyan
}

$products = Get-ChildItem -Path $ProductsPath -Directory

# ===================================================================
# PHASE 1 - MIGRATION : 20_Agents\OPS-* -> OPS\OPS-*
# ===================================================================
if (-not $SkipMigration) {
    Write-Host ""
    Write-Host "====== PHASE 1 - MIGRATION ===============================" -ForegroundColor Yellow
    Write-Host "  Deplacement OPS de $SourceSubDir\ vers OPS\"
    Write-Host ""

    $migratedProducts = 0
    $migratedAgents   = 0

    foreach ($product in $products) {
        $srcAgentsDir = Join-Path $product.FullName $SourceSubDir
        $destOpsDir   = Join-Path $product.FullName "OPS"

        $foundAny = $false

        foreach ($agent in $opsAgents) {
            $srcAgent = Join-Path $srcAgentsDir $agent

            if (-not (Test-Path $srcAgent)) { continue }

            $foundAny   = $true
            $destAgent  = Join-Path $destOpsDir $agent

            if (Test-Path $destAgent) {
                Write-Host "  [SKIP] $($product.Name)\OPS\$agent deja present (cible existe)" -ForegroundColor DarkGray
                continue
            }

            Write-Host "  -> $($product.Name)" -ForegroundColor White
            Write-Host "     [MOVE] $SourceSubDir\$agent -> OPS\$agent" -ForegroundColor Green

            if (-not $DryRun) {
                if (-not (Test-Path $destOpsDir)) {
                    New-Item -ItemType Directory -Path $destOpsDir -Force | Out-Null
                }
                Move-Item $srcAgent $destAgent
            }
            $migratedAgents++
        }

        if ($foundAny) { $migratedProducts++ }
    }

    Write-Host ""
    if ($migratedAgents -eq 0) {
        Write-Host "  [OK] Aucun agent OPS a migrer - $SourceSubDir\ est deja propre." -ForegroundColor DarkGray
    } else {
        if ($DryRun) {
            Write-Host "  [DRY] $migratedAgents agent(s) seraient deplaces dans $migratedProducts produit(s)." -ForegroundColor Yellow
        } else {
            Write-Host "  [OK] $migratedAgents agent(s) deplaces dans $migratedProducts produit(s)." -ForegroundColor Green
        }
    }
}

# ===================================================================
# PHASE 2 - SYNCHRONISATION : FACTORY\OPS -> PRODUCTS\<produit>\OPS\
# ===================================================================
if (-not $SkipSync) {
    Write-Host ""
    Write-Host "====== PHASE 2 - SYNCHRONISATION =========================" -ForegroundColor Cyan
    Write-Host "  Source : FACTORY\20_AGENTS\OPS\"
    Write-Host "  Cible  : PRODUCTS\<produit>\OPS\"
    Write-Host ""

    $syncCount  = 0
    $skipCount  = 0
    $totalFiles = 0

    foreach ($product in $products) {
        $destOpsDir = Join-Path $product.FullName "OPS"

        if (-not (Test-Path $destOpsDir)) {
            Write-Host "  [SKIP] $($product.Name) - pas de dossier OPS\" -ForegroundColor DarkGray
            $skipCount++
            continue
        }

        Write-Host "  -> $($product.Name)" -ForegroundColor White
        $agentsSynced = 0

        foreach ($agent in $opsAgents) {
            $destAgent = Join-Path $destOpsDir $agent

            if (-not (Test-Path $destAgent)) {
                Write-Host "     [SKIP] $agent absent dans OPS\" -ForegroundColor DarkGray
                continue
            }

            $srcDir = Join-Path $sourceBase $agent
            $files  = Get-ChildItem -Path $srcDir -Recurse -File

            foreach ($file in $files) {
                $rel      = $file.FullName.Substring($srcDir.Length).TrimStart('\')
                $destFile = Join-Path $destAgent $rel
                $destD    = Split-Path $destFile -Parent
                if (-not $DryRun) {
                    if (-not (Test-Path $destD)) { New-Item -ItemType Directory -Path $destD -Force | Out-Null }
                    Copy-Item $file.FullName $destFile -Force
                }
                $totalFiles++
            }

            if ($DryRun) { $verb = "Synchro" } else { $verb = "Synchronise" }
            Write-Host "     [$verb] OPS\$agent - $($files.Count) fichiers" -ForegroundColor Green
            $agentsSynced++
        }

        if ($agentsSynced -gt 0) { $syncCount++ } else { $skipCount++ }
    }

    Write-Host ""
    Write-Host "--- Resultat Phase 2 ---" -ForegroundColor Cyan
    Write-Host "  Produits synchronises : $syncCount"
    Write-Host "  Produits ignores      : $skipCount"
    Write-Host "  Fichiers synchronises : $totalFiles"
}

# ===================================================================
# CONCLUSION
# ===================================================================
Write-Host ""
Write-Host "====== STRUCTURE CIBLE ====================================" -ForegroundColor Cyan
Write-Host "  PRODUCTS\"
Write-Host "    <produit>\"
Write-Host "      OPS\                 <- agents runtime (sync depuis FACTORY)"
Write-Host "        OPS-RouterIA\"
Write-Host "        OPS-PlaybookRunner\"
Write-Host "        OPS-DossierIA\"
Write-Host "      20_Agents\           <- agents metier uniquement"
Write-Host "        <IT-xxx>\"
Write-Host "        ..."
Write-Host ""

if ($DryRun) {
    Write-Host "[DRY-RUN] Aucune modification. Relancer sans -DryRun pour appliquer." -ForegroundColor Yellow
} else {
    Write-Host "[OK] Fix-04 termine." -ForegroundColor Green
    Write-Host ""
    Write-Host "  RAPPEL : Relancer ce script apres chaque modification" -ForegroundColor DarkGray
    Write-Host "           dans FACTORY\20_AGENTS\OPS\" -ForegroundColor DarkGray
}
