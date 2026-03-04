# Script d'application — Fusion META (10 → 8 agents)
# Date: 2026-02-01
# PowerShell version

Write-Host "=== FUSION META — Application du package ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Ce script va :"
Write-Host "  1. Créer 2 nouveaux agents (META-PromptMaster, META-GouvernanceQA)"
Write-Host "  2. Marquer 4 agents comme deprecated"
Write-Host "  3. Patcher agents_index.yaml et playbooks.yaml"
Write-Host ""

# Vérifier qu'on est dans root_IA
if (-not (Test-Path "VERSION") -or -not (Test-Path "20_AGENTS\META")) {
    Write-Host "ERREUR: Ce script doit être exécuté depuis la racine de root_IA" -ForegroundColor Red
    exit 1
}

# Backup
Write-Host "[1/5] Création backup..." -ForegroundColor Yellow
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupDir = "BACKUP_FUSION_META_$timestamp"
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
Copy-Item -Path "20_AGENTS\META" -Destination "$backupDir\" -Recurse
Copy-Item -Path "00_INDEX\agents_index.yaml" -Destination "$backupDir\"
Copy-Item -Path "40_RUNBOOKS\playbooks.yaml" -Destination "$backupDir\"
Write-Host "✓ Backup créé: $backupDir" -ForegroundColor Green

# Copier nouveaux agents
Write-Host "[2/5] Copie des nouveaux agents..." -ForegroundColor Yellow
Copy-Item -Path "FUSION_META_PACKAGE\20_AGENTS_META_NEW\META-PromptMaster" -Destination "20_AGENTS\META\" -Recurse
Copy-Item -Path "FUSION_META_PACKAGE\20_AGENTS_META_NEW\META-GouvernanceQA" -Destination "20_AGENTS\META\" -Recurse
Write-Host "✓ META-PromptMaster créé" -ForegroundColor Green
Write-Host "✓ META-GouvernanceQA créé" -ForegroundColor Green

# Marquer anciens agents comme deprecated
Write-Host "[3/5] Dépréciation des anciens agents..." -ForegroundColor Yellow
$agents = @("META-Opromptimizer", "META-PromptArchitectEquipes", "META-SuperviseurInvisible", "META-GouvernanceEtRisques")
foreach ($agent in $agents) {
    $agentFile = "20_AGENTS\META\$agent\agent.yaml"
    $content = Get-Content $agentFile -Raw
    
    if ($content -notmatch "status: deprecated") {
        Add-Content -Path $agentFile -Value "status: deprecated"
        Add-Content -Path $agentFile -Value "deprecated_date: '2026-02-01'"
        
        if ($agent -in @("META-Opromptimizer", "META-PromptArchitectEquipes")) {
            Add-Content -Path $agentFile -Value "replaced_by: META-PromptMaster"
        } else {
            Add-Content -Path $agentFile -Value "replaced_by: META-GouvernanceQA"
        }
        Write-Host "✓ $agent deprecated" -ForegroundColor Green
    } else {
        Write-Host "⚠ $agent déjà deprecated (skip)" -ForegroundColor Yellow
    }
}

# Appliquer patches
Write-Host "[4/5] Application des patches..." -ForegroundColor Yellow
Copy-Item -Path "FUSION_META_PACKAGE\PATCHES\agents_index.yaml" -Destination "00_INDEX\agents_index.yaml" -Force
Copy-Item -Path "FUSION_META_PACKAGE\PATCHES\playbooks.yaml" -Destination "40_RUNBOOKS\playbooks.yaml" -Force
Write-Host "✓ agents_index.yaml patché" -ForegroundColor Green
Write-Host "✓ playbooks.yaml patché" -ForegroundColor Green

# Validation (si scripts disponibles)
Write-Host "[5/5] Validation..." -ForegroundColor Yellow
if (Test-Path "scripts\validate_schemas.py") {
    Write-Host "Running validate_schemas.py..."
    try {
        python scripts\validate_schemas.py
    } catch {
        Write-Host "⚠ Validation schemas failed (non-blocking)" -ForegroundColor Yellow
    }
}
if (Test-Path "validate_root_IA.sh") {
    Write-Host "Running validate_root_IA.sh (via WSL/Git Bash si disponible)..."
    Write-Host "⚠ Utilisez Git Bash ou WSL pour exécuter validate_root_IA.sh" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== FUSION META APPLIQUÉE AVEC SUCCÈS ===" -ForegroundColor Green
Write-Host ""
Write-Host "Changements effectués :"
Write-Host "  + META-PromptMaster (20_AGENTS\META\)"
Write-Host "  + META-GouvernanceQA (20_AGENTS\META\)"
Write-Host "  ~ 4 agents marqués deprecated"
Write-Host "  ~ agents_index.yaml mis à jour"
Write-Host "  ~ playbooks.yaml mis à jour (BUILD_ARMY_FACTORY)"
Write-Host ""
Write-Host "Backup : $backupDir" -ForegroundColor Cyan
Write-Host ""
Write-Host "Prochaines étapes :"
Write-Host "  1. Tester BUILD_ARMY_FACTORY avec nouveaux agents"
Write-Host "  2. Commit changes: git add . && git commit -m 'FUSION: META 10→8 agents'"
Write-Host "  3. Monitor 1 semaine"
Write-Host ""
Write-Host "Rollback (si nécessaire) :"
Write-Host "  Copy-Item -Path '$backupDir\META' -Destination '20_AGENTS\' -Recurse -Force"
Write-Host "  Copy-Item -Path '$backupDir\agents_index.yaml' -Destination '00_INDEX\' -Force"
Write-Host "  Copy-Item -Path '$backupDir\playbooks.yaml' -Destination '40_RUNBOOKS\' -Force"
Write-Host ""
