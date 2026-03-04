<#
.SYNOPSIS
    Fix-05-HUBOrchestrator.ps1 - Resoudre ambiguite HUB-Orchestrator vs HUB-AgentMO
.DESCRIPTION
    PROBLEME : Deux orchestrateurs coexistent dans HUB.

    HUB-Orchestrator (LEGACY)
      Declare dans : teams.yaml uniquement
      Prompt       : Version simple

    HUB-AgentMO-MasterOrchestrator (ACTUEL - plus complet)
      Declare dans : hub_routing.yaml seulement (absent de teams.yaml)
      Prompt       : Le plus complet de HUB

    HUB-AgentMO2-DeputyOrchestrator (ADJOINT QA)
      Declare dans : Aucune source de verite (orphelin)

    OPTION A (defaut) - Migration propre :
      HUB-AgentMO  = orchestrateur principal -> teams.yaml
      HUB-AgentMO2 = adjoint QA -> teams.yaml
      HUB-Orchestrator = DEPRECATED

    OPTION B - Conservation avec roles distincts :
      Guide manuel affiche, aucune modification faite

.PARAMETER FactoryPath
    Chemin racine FACTORY (auto-detecte)
.PARAMETER Option
    "A" migration propre (defaut) ou "B" conservation differenciee
.PARAMETER DryRun
    Voir les actions sans modifier
.EXAMPLE
    .\Fix-05-HUBOrchestrator.ps1
    .\Fix-05-HUBOrchestrator.ps1 -DryRun
    .\Fix-05-HUBOrchestrator.ps1 -Option B
#>
param(
    [string]$FactoryPath = "",
    [string]$Option      = "A",
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
Write-Host "=== Fix-05-HUBOrchestrator.ps1 - Double orchestrateur HUB ===" -ForegroundColor Cyan
Write-Host "  Mode    : $modeLabel"
Write-Host "  Option  : $Option"
Write-Host "  FACTORY : $FactoryPath"
Write-Host ""

$teamsYaml   = Join-Path $FactoryPath "10_TEAMS\teams.yaml"
$agentYaml   = Join-Path $FactoryPath "20_AGENTS\HUB\HUB-Orchestrator\agent.yaml"
$routingYaml = Join-Path $FactoryPath "40_ROUTING\hub_routing.yaml"

if ($Option -eq "A") {
    Write-Host "-- OPTION A : Migration propre --" -ForegroundColor Yellow
    Write-Host ""

    Write-Host "ACTION 1 - Marquer HUB-Orchestrator comme deprecated" -ForegroundColor White
    if (Test-Path $agentYaml) {
        $content = Get-Content $agentYaml -Raw -Encoding UTF8
        if ($content -match 'status:\s*"?active"?') {
            if (-not $DryRun) {
                $updated = $content -replace 'status:\s*"?active"?','status: "deprecated"'
                $updated = $updated -replace "`r`n","`n"
                [System.IO.File]::WriteAllBytes($agentYaml, [System.Text.Encoding]::UTF8.GetBytes($updated))
                Write-Host "  [OK] HUB-Orchestrator -> status: deprecated" -ForegroundColor Green
            } else {
                Write-Host "  [DRY] HUB-Orchestrator serait marque deprecated" -ForegroundColor Yellow
            }
        } else {
            Write-Host "  [SKIP] Deja non-actif." -ForegroundColor DarkGray
        }
    } else {
        Write-Host "  [SKIP] HUB-Orchestrator\agent.yaml introuvable." -ForegroundColor DarkGray
    }

    Write-Host ""
    Write-Host "ACTION 2 - Mettre a jour 10_TEAMS\teams.yaml" -ForegroundColor White
    if (Test-Path $teamsYaml) {
        $teams = Get-Content $teamsYaml -Raw -Encoding UTF8
        if ($teams -match "HUB-AgentMO-MasterOrchestrator") {
            Write-Host "  [SKIP] HUB-AgentMO-MasterOrchestrator deja dans teams.yaml." -ForegroundColor DarkGray
        } else {
            Write-Host "  [INFO] Mettre a jour MANUELLEMENT la section TEAM__HUB dans teams.yaml :" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "    agents:" -ForegroundColor DarkGray
            Write-Host "      - HUB-Router" -ForegroundColor DarkGray
            Write-Host "      - HUB-Concierge" -ForegroundColor DarkGray
            Write-Host "      - HUB-AgentMO-MasterOrchestrator" -ForegroundColor DarkGray
            Write-Host "      - HUB-AgentMO2-DeputyOrchestrator" -ForegroundColor DarkGray
            Write-Host "      - HUB-OproEngine" -ForegroundColor DarkGray
            Write-Host "      - HUB-AvatarForge" -ForegroundColor DarkGray
            Write-Host "      - HUB-CoachIA360-Strategie-GPTTeams" -ForegroundColor DarkGray
            Write-Host "      - HUB-IA-ChatBotMaster" -ForegroundColor DarkGray
            Write-Host "      - HUB-ITCoachIA360" -ForegroundColor DarkGray
            Write-Host "      - HUB-Orchestrator  # DEPRECATED" -ForegroundColor DarkGray
            Write-Host ""
        }
    } else {
        Write-Host "  [SKIP] teams.yaml introuvable." -ForegroundColor DarkGray
    }

    Write-Host ""
    Write-Host "ACTION 3 - Verifier routing HUB-AgentMO" -ForegroundColor White
    if (Test-Path $routingYaml) {
        $routing = Get-Content $routingYaml -Raw -Encoding UTF8
        if ($routing -match "HUB-AgentMO-MasterOrchestrator") {
            Write-Host "  [OK] HUB-AgentMO deja dans hub_routing.yaml." -ForegroundColor Green
        } else {
            Write-Host "  [INFO] Ajouter MANUELLEMENT dans 40_ROUTING\hub_routing.yaml :" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "    - intents: [orchestrate, intake, dispatch, complex_request]" -ForegroundColor DarkGray
            Write-Host "      agent: HUB-AgentMO-MasterOrchestrator" -ForegroundColor DarkGray
            Write-Host ""
            Write-Host "    - intents: [qa_plan, validate_plan, review_mo]" -ForegroundColor DarkGray
            Write-Host "      agent: HUB-AgentMO2-DeputyOrchestrator" -ForegroundColor DarkGray
            Write-Host ""
        }
    }

} elseif ($Option -eq "B") {
    Write-Host "-- OPTION B : Conservation avec roles distincts --" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Actions MANUELLES requises :"
    Write-Host ""
    Write-Host "  1. Dans HUB-Orchestrator\prompt.md - Ajouter en tete :"
    Write-Host "     Je suis un EXECUTEUR MECANIQUE de playbooks." -ForegroundColor DarkGray
    Write-Host "     Pour orchestration strategique -> @HUB-AgentMO" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  2. Dans HUB-AgentMO\prompt.md - Ajouter en tete :"
    Write-Host "     Je suis l ORCHESTRATEUR STRATEGIQUE." -ForegroundColor DarkGray
    Write-Host "     Pour execution mecanique playbook -> @HUB-Orchestrator" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  3. Mettre a jour teams.yaml (voir Option A action 2)"
    Write-Host ""
    Write-Host "  4. Dans hub_routing.yaml - Differencier les intents :"
    Write-Host "     run_playbook, execute_playbook -> HUB-Orchestrator" -ForegroundColor DarkGray
    Write-Host "     orchestrate, dispatch, complex -> HUB-AgentMO" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  Ce script ne modifie rien pour l Option B." -ForegroundColor Yellow
} else {
    Write-Host "[ERREUR] Option invalide : $Option. Utiliser A ou B." -ForegroundColor Red
    exit 1
}

Write-Host ""
if ($DryRun) {
    Write-Host "[DRY-RUN] Relancer sans -DryRun pour appliquer." -ForegroundColor Yellow
} else {
    Write-Host "[OK] Fix-05 termine (Option $Option)." -ForegroundColor Green
}
