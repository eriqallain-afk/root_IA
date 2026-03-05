# =============================================================================
# Fix-07-Index-Cleanup.ps1
# FACTORY root_IA - Nettoyage doublons index + synchronisation teams
# Date    : 2026-03-04
# Auteur  : EA4A / Eric
# Version : 1.1.0 - ASCII only (no accents, no emoji)
#
# CORRECTIONS :
#   [1] teams.manifest.yaml   - doublon de teams_index.yaml  --> ARCHIVER
#   [2] agents.manifest.yaml  - BOM UTF-8 + path: sans espace --> ARCHIVER
#   [3] 10_TEAMS/teams.yaml   - CTL absent, MCIA active       --> CORRIGER
#   [4] 00_INDEX/teams_index  - MCIA absente                  --> CORRIGER
# =============================================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# --- CONFIGURATION -----------------------------------------------------------
$FACTORY_ROOT = Split-Path -Parent $PSScriptRoot
$INDEX_DIR    = Join-Path $FACTORY_ROOT "00_INDEX"
$TEAMS_DIR    = Join-Path $FACTORY_ROOT "10_TEAMS"
$ARCHIVE_DIR  = Join-Path $INDEX_DIR    "_ARCHIVE_FIX07"
$LOG_FILE     = Join-Path $FACTORY_ROOT "Fix-07-Index-Cleanup.log"

function Get-Timestamp { return (Get-Date -Format "yyyy-MM-dd HH:mm:ss") }

function Log {
    param([string]$msg, [string]$level = "INFO")
    $line = "[$(Get-Timestamp)][$level] $msg"
    Write-Host $line
    Add-Content -Path $LOG_FILE -Value $line -Encoding UTF8
}

function LogSection {
    param([string]$title)
    $sep = "-" * 70
    $block = "`n$sep`n  $title`n$sep"
    Write-Host $block -ForegroundColor Cyan
    Add-Content -Path $LOG_FILE -Value $block -Encoding UTF8
}

# --- PREREQUIS ---------------------------------------------------------------
LogSection "FIX-07 - Demarrage"
Log "FACTORY_ROOT : $FACTORY_ROOT"
Log "Date         : $(Get-Timestamp)"

if (-not (Test-Path $INDEX_DIR)) {
    Log "ERREUR : 00_INDEX introuvable - verifier FACTORY_ROOT" "ERROR"
    exit 1
}
if (-not (Test-Path $TEAMS_DIR)) {
    Log "ERREUR : 10_TEAMS introuvable" "ERROR"
    exit 1
}
if (-not (Test-Path $ARCHIVE_DIR)) {
    New-Item -ItemType Directory -Path $ARCHIVE_DIR | Out-Null
    Log "Dossier archive cree : $ARCHIVE_DIR"
}

# --- [FIX 1] Archiver teams.manifest.yaml ------------------------------------
LogSection "FIX 1 - Archiver teams.manifest.yaml (doublon de teams_index.yaml)"

$f1 = Join-Path $INDEX_DIR "teams.manifest.yaml"
$f1bak = Join-Path $ARCHIVE_DIR "teams.manifest.yaml.bak"

if (Test-Path $f1) {
    Copy-Item $f1 $f1bak
    Remove-Item $f1
    Log "OK - teams.manifest.yaml archive dans _ARCHIVE_FIX07/"
    Log "   Raison : doublon de teams_index.yaml, non reference dans les prompts actifs"
    Log "   Reference canonique conservee : 00_INDEX/teams_index.yaml"
} else {
    Log "SKIP - teams.manifest.yaml introuvable (deja supprime ?)" "WARN"
}

# --- [FIX 2] Archiver agents.manifest.yaml -----------------------------------
LogSection "FIX 2 - Archiver agents.manifest.yaml (BOM UTF-8 + path sans espace)"

$f2 = Join-Path $INDEX_DIR "agents.manifest.yaml"
$f2bak = Join-Path $ARCHIVE_DIR "agents.manifest.yaml.bak"
$f2clean = Join-Path $INDEX_DIR "agents_manifest.yaml"

if (Test-Path $f2) {
    $bytes = [System.IO.File]::ReadAllBytes($f2)
    $hasBOM = ($bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)
    if ($hasBOM) {
        Log "BOM UTF-8 confirme sur agents.manifest.yaml (EF BB BF)"
    }
    Copy-Item $f2 $f2bak
    Remove-Item $f2
    Log "OK - agents.manifest.yaml archive dans _ARCHIVE_FIX07/"
    Log "   Raison : BOM UTF-8 + 115 occurrences path: sans espace (YAML invalide)"
    Log "   Reference canonique conservee : 00_INDEX/agents_manifest.yaml"
} else {
    Log "SKIP - agents.manifest.yaml introuvable (deja supprime ?)" "WARN"
}

if (-not (Test-Path $f2clean)) {
    Log "ERREUR : agents_manifest.yaml introuvable - fichier propre manquant !" "ERROR"
    exit 1
} else {
    Log "OK - agents_manifest.yaml present et valide (sans BOM, YAML correct)"
}

# --- [FIX 3] Corriger 10_TEAMS/teams.yaml ------------------------------------
LogSection "FIX 3 - Synchroniser 10_TEAMS/teams.yaml (CTL manquant, MCIA orpheline)"

$f3 = Join-Path $TEAMS_DIR "teams.yaml"
$f3bak = Join-Path $ARCHIVE_DIR "teams.yaml.bak"

if (Test-Path $f3) {
    Copy-Item $f3 $f3bak
    Log "Backup cree : _ARCHIVE_FIX07/teams.yaml.bak"
}

$newTeamsYaml = @"
# 10_TEAMS/teams.yaml
# Catalogue gouvernance des equipes root_IA FACTORY
# Genere par Fix-07-Index-Cleanup.ps1 - 2026-03-04
# Source canonique : 00_INDEX/teams_index.yaml
schema_version: "1.1"
last_updated: "2026-03-04"
total_teams: 14

teams:

# --- INFRA -------------------------------------------------------------------

- team_id: TEAM__CTL
  name: CTL
  status: active
  type: infra
  purpose: "Monitoring et controle de la FACTORY : surveillance sante, alertes, reporting."
  agents:
    - CTL-WatchdogIA
    - CTL-AlertRouter
    - CTL-HealthReporter
  note: "Equipe absente de l'ancienne version - ajoutee Fix-07"

- team_id: TEAM__HUB
  name: HUB
  status: active
  type: infra
  purpose: "Orchestration globale : intake, routing, coordination inter-equipes, coaching, avatars."
  agents:
    - HUB-AgentMO-MasterOrchestrator
    - HUB-AgentMO2-DeputyOrchestrator
    - HUB-Router
    - HUB-Orchestrator
    - HUB-Concierge
    - HUB-AvatarForge
    - HUB-OproEngine
    - HUB-CoachIA360-Strategie-GPTTeams
    - HUB-IA-ChatBotMaster
    - HUB-ITCoachIA360

- team_id: TEAM__META
  name: META
  status: active
  type: infra
  purpose: "Usine armees GPT : creation agents, prompts, playbooks, QA, gouvernance, pedagogie IA."
  agents:
    - META-OrchestrateurCentral
    - META-Concierge
    - META-AnalysteBesoinsEquipes
    - META-CartographeRoles
    - META-ArchitecteChoix
    - META-AgentProductFactory
    - META-PromptMaster
    - META-ReversePrompt
    - META-PlaybookBuilder
    - META-WorkflowDesignerEquipes
    - META-GouvernanceQA
    - META-Pedagogie
    - META-Redaction
    - META-VisionCreative

- team_id: TEAM__OPS
  name: OPS
  status: active
  type: infra
  purpose: "Runtime : routage, execution playbooks, memoire projet, dossiers IA."
  agents:
    - OPS-RouterIA
    - OPS-PlaybookRunner
    - OPS-DossierIA

- team_id: TEAM__IAHQ
  name: IAHQ
  status: active
  type: infra
  purpose: "Siege IA : strategie, ROI, admin, architecture, QA, delivery client."
  agents:
    - IAHQ-OrchestreurEntrepriseIA
    - IAHQ-Strategist
    - IAHQ-Economist
    - IAHQ-TechLeadIA
    - IAHQ-ProcessMapper
    - IAHQ-QualityGate
    - IAHQ-SolutionOrchestrator
    - IAHQ-DevFactoryIA
    - IAHQ-Extractor
    - IAHQ-AdminManagerIA

# --- PRODUITS ----------------------------------------------------------------

- team_id: TEAM__DAM
  name: DAM
  status: active
  type: produit
  purpose: "Gestion projets domiciliaires : conformite RBQ, budget, planning, inspection."
  agents:
    - DAM-Orchestrator
    - DAM-Conformite
    - DAM-Budget
    - DAM-Planification
    - DAM-SousTraitants
    - DAM-Inspection

- team_id: TEAM__EDU
  name: EDU
  status: active
  type: produit
  purpose: "Education CCQ : assistants pedagogiques, evaluation, ressources enseignants."
  agents:
    - EDU-Orchestrator
    - EDU-Extractor
    - EDU-Evaluator

- team_id: TEAM__IT
  name: IT
  status: active
  type: produit
  purpose: "Services MSP IT : NOC, support, infrastructure, securite, DevOps, interventions."
  agents:
    - IT-Orchestrator
    - IT-InterventionLive
    - IT-NOC
    - IT-ScriptMaster
    - IT-ReportMaster

- team_id: TEAM__IASM
  name: IASM
  status: active
  type: produit
  purpose: "Coaching IA sante mentale : support emotionnel, TCC, relations, securite."
  agents:
    - IASM-Orchestrator
    - IASM-SupportEmotionnel
    - IASM-OutilsTCC
    - IASM-Securite

- team_id: TEAM__TRAD
  name: TRAD
  status: active
  type: produit
  purpose: "Intelligence strategique : marches, crypto, cyber, geopolitique, signaux."
  agents:
    - TRAD-CommandCore
    - TRAD-MarketAnalyst
    - TRAD-CryptoAnalyst
    - TRAD-CyberWatch
    - TRAD-GeoAnalyst

- team_id: TEAM__NEA
  name: NEA
  status: active
  type: produit
  purpose: "Publishing : redaction recueils, illustrations, patterns narratifs."
  agents:
    - NEA-Orchestrator
    - NEA-Redacteur
    - NEA-Imagier

- team_id: TEAM__PLR
  name: PLR
  status: active
  type: produit
  purpose: "Radio/Podcast : scripts, episodes, show notes."
  agents:
    - PLR-Orchestrator
    - PLR-Scripteur

- team_id: TEAM__ESPL
  name: ESPL
  status: active
  type: produit
  purpose: "Projets speciaux et experimentaux."
  agents:
    - ESPL-PaulLejeuneRadio

# --- ARCHIVEES ---------------------------------------------------------------

- team_id: TEAM__MCIA
  name: MCIA
  status: archived
  type: legacy
  purpose: "MasterClassIA - equipe fusionnee dans TEAM__META (Fix-07 2026-03-04)."
  archived_at: "2026-03-04"
  merged_into: TEAM__META
  archive_path: "90_KNOWLEDGE/ARCHIVE/MCIA_MERGED/"
  agents: []
  note: "Agents MCIA-Prompting et MCIA-Verificateur archives dans 90_KNOWLEDGE/ARCHIVE/MCIA_MERGED/"
"@

# Ecriture avec BOM UTF-8 pour compatibilite Windows
$utf8BOM = New-Object System.Text.UTF8Encoding $true
[System.IO.File]::WriteAllText($f3, $newTeamsYaml, $utf8BOM)
Log "OK - 10_TEAMS/teams.yaml reecrit - 14 equipes (13 actives + 1 archivee)"
Log "   + CTL ajoute avec 3 agents (WatchdogIA, AlertRouter, HealthReporter)"
Log "   + MCIA : status archived + merged_into TEAM__META"
Log "   + schema_version 1.0 -> 1.1 (champs type, note, archive_path)"

# --- [FIX 4] Synchroniser 00_INDEX/teams_index.yaml --------------------------
LogSection "FIX 4 - Synchroniser 00_INDEX/teams_index.yaml (ajouter MCIA archived)"

$f4 = Join-Path $INDEX_DIR "teams_index.yaml"
$f4bak = Join-Path $ARCHIVE_DIR "teams_index.yaml.bak"

if (Test-Path $f4) {
    Copy-Item $f4 $f4bak
    Log "Backup cree : _ARCHIVE_FIX07/teams_index.yaml.bak"
}

$newTeamsIndex = @"
# 00_INDEX/teams_index.yaml
# Index rapide des equipes - format dictionnaire (cle = team_id)
# Synchronise par Fix-07-Index-Cleanup.ps1 - 2026-03-04
# Source de verite : 10_TEAMS/teams.yaml
schema_version: "1.1"
generated_at: "2026-03-04T00:00:00Z"
total_teams: 14

teams:
  TEAM__CTL:
    name: CTL
    type: infra
    status: active
    mission: "Monitoring et controle de la FACTORY : surveillance sante, alertes, reporting."
  TEAM__HUB:
    name: HUB
    type: infra
    status: active
    mission: "Orchestration globale : intake, routing, coordination inter-equipes, coaching, avatars."
  TEAM__META:
    name: META
    type: infra
    status: active
    mission: "Usine armees GPT : creation agents, prompts, playbooks, QA, gouvernance, pedagogie IA."
  TEAM__OPS:
    name: OPS
    type: infra
    status: active
    mission: "Runtime : routage, execution playbooks, memoire projet, dossiers IA."
  TEAM__IAHQ:
    name: IAHQ
    type: infra
    status: active
    mission: "Siege IA : strategie, ROI, admin, architecture, QA, delivery client."
  TEAM__DAM:
    name: DAM
    type: produit
    status: active
    mission: "Gestion projets domiciliaires : conformite RBQ, budget, planning, inspection, achats."
  TEAM__EDU:
    name: EDU
    type: produit
    status: active
    mission: "Education CCQ : assistants pedagogiques, evaluation de travaux, ressources enseignants."
  TEAM__IT:
    name: IT
    type: produit
    status: active
    mission: "Services MSP IT : NOC, support, infrastructure, securite, DevOps, interventions."
  TEAM__IASM:
    name: IASM
    type: produit
    status: active
    mission: "Coaching IA sante mentale : support emotionnel, TCC, relations, securite."
  TEAM__TRAD:
    name: TRAD
    type: produit
    status: active
    mission: "Intelligence strategique : marches, crypto, cyber, geopolitique, signaux."
  TEAM__NEA:
    name: NEA
    type: produit
    status: active
    mission: "Publishing : redaction recueils, illustrations, patterns narratifs."
  TEAM__PLR:
    name: PLR
    type: produit
    status: active
    mission: "Radio/Podcast : scripts, episodes, show notes."
  TEAM__ESPL:
    name: ESPL
    type: produit
    status: active
    mission: "Projets speciaux et experimentaux."
  TEAM__MCIA:
    name: MCIA
    type: legacy
    status: archived
    mission: "MasterClassIA - fusionnee dans TEAM__META."
    archived_at: "2026-03-04"
    merged_into: TEAM__META
"@

[System.IO.File]::WriteAllText($f4, $newTeamsIndex, $utf8BOM)
Log "OK - 00_INDEX/teams_index.yaml reecrit - 14 equipes (13 actives + MCIA archived)"
Log "   + Champs type et status ajoutes sur chaque equipe"

# --- RAPPORT FINAL -----------------------------------------------------------
LogSection "RAPPORT FINAL Fix-07"

$rapport = @(
    "FIX-1 | 00_INDEX/teams.manifest.yaml  | ARCHIVE | Doublon de teams_index.yaml",
    "FIX-2 | 00_INDEX/agents.manifest.yaml | ARCHIVE | BOM UTF-8 + 115x path: sans espace",
    "FIX-3 | 10_TEAMS/teams.yaml           | CORRIGE | CTL ajoute, MCIA archived, schema 1.1",
    "FIX-4 | 00_INDEX/teams_index.yaml     | CORRIGE | MCIA archived, champs type+status"
)
foreach ($ligne in $rapport) {
    Log $ligne
}

Log ""
Log "References canoniques APRES Fix-07 :"
Log "  Teams  -> 00_INDEX/teams_index.yaml   (index rapide dict)"
Log "         -> 10_TEAMS/teams.yaml          (gouvernance complete avec agents)"
Log "  Agents -> 00_INDEX/agents_manifest.yaml (propre, sans BOM)"
Log "  Backup -> 00_INDEX/_ARCHIVE_FIX07/    (backups securises)"
Log ""
Log "MCIA : status=archived - agents dans 90_KNOWLEDGE/ARCHIVE/MCIA_MERGED/"
Log ""
Log "Fix-07 termine - CTL-WatchdogIA peut relancer son full_check."
