# ==========================================
# GPT-TeamManager.ps1  (v2.6 - SANS ACCENTS)
# Application PowerShell interactive pour:
# - Creer/completer la structure documentaire GPT-Enterprise
# - Ajouter une nouvelle equipe + ses agents (FACTORY ou PRODUCTS)
# - Ajouter des agents a une equipe existante
# - Persister la liste dans un registry JSON
#
# Chemins equipes:
#   FACTORY  -> 03_WorkShop-GPT\FACTORY\[equipe]
#   PRODUCTS -> 03_WorkShop-GPT\PRODUCTS\[equipe]
#
# Regles fichiers .md:
#   Crees seulement s ils n existent PAS (jamais ecrases)
#
# Compatible Windows PowerShell ISE / PowerShell 5.1+ / PowerShell 7+
# ==========================================

# ---------------------------
# CONFIG (adapte si besoin)
# ---------------------------
$BasePath = "C:\Intranet_EA\EA4A\"
$RootName = "TEST"

# ---------------------------
# Paths
# ---------------------------
$Root              = Join-Path $BasePath $RootName
$TeamsRoot         = Join-Path $Root "03_WorkShop-GPT"
$FactoryTeamsRoot  = Join-Path $Root "03_WorkShop-GPT\FACTORY"
$ProductsTeamsRoot = Join-Path $Root "03_WorkShop-GPT\PRODUCTS"
$AdminRoot         = Join-Path $Root "00_Administration"
$RegistryPath      = Join-Path $AdminRoot "registry_teams_agents.json"

# ---------------------------
# Helpers
# ---------------------------
function Ensure-Dir([string]$Path) {
  if (-not (Test-Path -LiteralPath $Path)) {
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
  }
}

function Ensure-File([string]$Path, [string]$Content = "") {
  if (-not (Test-Path -LiteralPath $Path)) {
    $parent = Split-Path -Path $Path -Parent
    if ($parent) { Ensure-Dir $parent }
    New-Item -ItemType File -Path $Path -Force | Out-Null
    if ($Content) { Set-Content -LiteralPath $Path -Value $Content -Encoding UTF8 }
  }
}

function Safe-FolderName([string]$Name) {
  if ($null -eq $Name) { throw "Nom invalide: null." }
  $Name = $Name.Trim()
  $invalid = [System.IO.Path]::GetInvalidFileNameChars()
  foreach ($c in $invalid) { $Name = $Name.Replace($c, '-') }
  $reserved = @("CON","PRN","AUX","NUL","COM1","COM2","COM3","COM4","COM5","COM6","COM7","COM8","COM9","LPT1","LPT2","LPT3","LPT4","LPT5","LPT6","LPT7","LPT8","LPT9")
  if ($reserved -contains $Name.ToUpperInvariant()) { $Name = "$Name-" }
  $Name = $Name.Trim().TrimEnd(".")
  if ([string]::IsNullOrWhiteSpace($Name)) { throw "Nom invalide (vide apres nettoyage)." }
  return $Name
}

function Get-ObjectPropertyNames($obj) {
  if ($null -eq $obj) { return @() }
  return @($obj.PSObject.Properties | ForEach-Object { $_.Name })
}

# ---------------------------
# Demande FACTORY ou PRODUCTS
# Retourne [PSCustomObject] avec .Label et .Root
# ---------------------------
function Ask-Destination() {
  Write-Host ""
  Write-Host "  Destination de l equipe / agent :" -ForegroundColor Cyan
  Write-Host "  F) FACTORY   -> 03_WorkShop-GPT\FACTORY"  -ForegroundColor White
  Write-Host "  P) PRODUCTS  -> 03_WorkShop-GPT\PRODUCTS" -ForegroundColor White
  Write-Host ""

  while ($true) {
    $pick = (Read-Host "  Choix [F/P]").Trim().ToUpper()
    if ($pick -eq "F") {
      return [PSCustomObject]@{ Label = "FACTORY";  Root = $script:FactoryTeamsRoot }
    }
    if ($pick -eq "P") {
      return [PSCustomObject]@{ Label = "PRODUCTS"; Root = $script:ProductsTeamsRoot }
    }
    Write-Host "  Entree invalide. Taper F ou P." -ForegroundColor Yellow
  }
}

function Ensure-RootScaffold() {
  Ensure-Dir $Root

  $top = @(
    "00_Administration",
    "00_Administration\Comptabilite",
    "00_Administration\Comptabilite\Fournisseurs",
    "00_Administration\Comptabilite\Clients",
    "00_Administration\Contrats-et-Notes",
    "00_Administration\Rapport_Analyse",
    "00_Administration\Rapport_Analyse\Mensuel",
    "00_Administration\Rapport_Analyse\Hebdomadaire",
    "00_Administration\Rapport_Analyse\Annuel",
    "00_Administration\RH",

    "00_Administration\University",
    "01_Architecture-Globale\10_Vision-Roadmap",
    "01_Architecture-Globale\00_overview",    
    "01_Architecture-Globale\Glossaire-Terme",
    "01_Architecture-Globale\Rapport_Analyse",
    
    "02_Procedures",    
    "02_Procedures\Guides",
    "02_Procedures\Automation",
    "02_Procedures\Nomenclature",
    "02_Procedures\Docs",

    "03_Workshop-GPT",
    "03_Workshop-GPT\FACTORY",
    "03_Workshop-GPT\PRODUCTS",

    
    
    
    "10_Images",
    
    
    "20_Dashboard",
    
    "70_Lab",
    "70_Lab\Tests-Scenarios",
    "70_Lab\Analyse (rapport)",
    "70_Lab\20_Migration",

    "75_Support",
    "75_Support\Tools",
    "75_Support\Outils-Scripts",
    "75_Support\Patch_N_Fix"
    "80_Changelog-Archives"
    
  )
  foreach ($d in $top) { Ensure-Dir (Join-Path $Root $d) }

  Ensure-Dir $AdminRoot
 
   
  Ensure-File (Join-Path $Root "00_Administration\README.md") "# Administration`n`n> Dossiers administratifs de gestion de l'entreprise`n"
  Ensure-File (Join-Path $Root "00_Administration\Fonctionnement_Systeme_GPT.md") "# Mode d'emploi de base des GPTs - Systeme GPT`n`n> Assets administratives de gestion`n"
  Ensure-File (Join-Path $Root "00_Administration\Comptabilite\README.md") "# Dossier comptable - Rapports comptable`n`n> Analyse comptbale`n`n> Previsions budgetaires`n"
  Ensure-File (Join-Path $Root "00_Administration\Comptabilite\Fournisseurs\README.md") "# Comptes fournisseurs`n`n> Comptabilite - comptes payables`n"
  Ensure-File (Join-Path $Root "00_Administration\Comptabilite\Clients\README.md") "# Comptes clients`n`n> Comptabilite - comptes a recevoir`n"
  Ensure-File (Join-Path $Root "00_Administration\Rapport_Analyse\README.md") "# Analyse comptable`n`n> Analyse hebdomadaire`n`n> Analyse mensuel`n`n> Analyse annuel`n"
  Ensure-File (Join-Path $Root "00_Administration\RH\README.md") "#Ressource humaine`n`n> Informations des ressources humaines`n"

  Ensure-File (Join-Path $Root "01_Architecture-Globale\README.md") "# Documentation - organigramme complet de toutes tes equipes IA`n"
  Ensure-File (Join-Path $Root "01_Architecture-Globale\10_Vision-Roadmap\Vision-generale.md") "# Vision globale et projection`n`n> Strategie et roadmap du systeme multi-agents`n"
  Ensure-File (Join-Path $Root "01_Architecture-Globale\10_Vision-Roadmap\Roadmap-3-mois.md") "# Planification des trois prochains mois`n`n> Description du WorkPlan`n"
  Ensure-File (Join-Path $Root "01_Architecture-Globale\10_Vision-Roadmap\Roadmap-12-mois.md") "# Planification de l'annee - 12mois`n`n> Description du WorkPlan`n"
  Ensure-File (Join-Path $Root "01_Architecture-Globale\10_Vision-Roadmap\Notes-idees-futures.md") "# Brainstorming futuriste`n`n> But a atteindre eventuellement`n"
  
  Ensure-File (Join-Path $Root "01_Architecture-Globale\Description-equipes.md") "# Description des equipes`n`n>liste des equipes : IT, Finance, Radio, Psy, etc.`n"
  Ensure-File (Join-Path $Root "01_Architecture-Globale\Schema-organisation-GPT.md") "# Schema de l'organisation`n`n> Inserer ici le schema (.pptx, .drawio, etc.)`n"
  Ensure-File (Join-Path $Root "01_Architecture-Globale\Roles-transverses.md") "# Schema de lorganisation transversale`n`n> par ex : GPT-Coach IA 360, @IT-DirecteurGeneral, CommandCore TRAD, etc `n"
  
  Ensure-File (Join-Path $Root "02_Procedures\Docs\README.md") "# Documentation`n`n> Documentation technique et guides`n"
  Ensure-File (Join-Path $Root "02_Procedures\README.md") "# Procedures`n`n> Nomenclatures`n`n> Procedures d'utilisation`n"
  Ensure-File (Join-Path $Root "02_Procedures\Automation\README.md") "# Automation`n`n> Script d'automatisation`n`n> taches planifiees`n"
  Ensure-File (Join-Path $Root "02_Procedures\Nomenclature\README.md") "# Nomenclature`n`n> Nomenclature d'appellation et de nommage`n"
  Ensure-File (Join-Path $Root "02_Procedures\Guides\README.md") "# Guides`n`n> Ebooks`n`n> Procedures d'utilisation`n"
   
  Ensure-File (Join-Path $Root "03_Workshop-GPT\README.md") "# Centre des oprations pour GPT Army`n`n> Production GPT - FACTORY`n`n> PRODUCTS - produits GPT livrables`n"
  Ensure-File (Join-Path $Root "03_Workshop-GPT\FACTORY\README.md") "# Centre des operations pour GPT Army`n`n>Usine de produyction de GPT`n"
  Ensure-File (Join-Path $Root "03_Workshop-GPT\PRODUCTS\README.md") "# Produits livrable de GPT Army`n`n> Equipe d'armees de GPT (client)`n"


  Ensure-File (Join-Path $Root "70_Lab\Tests-Scenario\README.md") "# Scenario en test`n`n> Test d'agents par equipe`n"
  Ensure-File (Join-Path $Root "70_Lab\Tests-Scenario\Incident-critique.md") "# Scenario en test`n`n> incident critique`n"


  Ensure-File (Join-Path $Root "80_Changelog-Archives\README.md") "# Changelog`n`n> Archive de changelog`n"

  Ensure-File (Join-Path $Root "06_Clients-Contexte\README.md") "# Documentation de client`n`n> Profil`n`n> Contraintes`n`n> Technologie utilisee`n"
  Ensure-File (Join-Path $Root "07_Outils-Scripts\README.md") "# Outils et script de validation de`n`n> Validation`n`n> Script PowerShell`n`n> Templates de script`n"
 
  Ensure-File (Join-Path $Root "10_Images\README.md") "# Images et Diagrammes`n`n> Assets visuels du systeme`n"

  Ensure-File (Join-Path $Root "70_Lab\20_Migration\README.md") "# Zone Migratoire`n`n> Documentation de la migration`n`n> Zone de transition avant deplacement vers dossier permanent`n"
  Ensure-File (Join-Path $Root "70_Lab\Analyse (rapport)\README.md") "# Fichiers d'analyse`n`n> Rapport d'analyse`n"
  Ensure-File (Join-Path $Root "22_Dashboard\README.md") "# Dashboard`n`n> Interface visuelle`n"
  Ensure-File (Join-Path $Root "75_Support\Patch_N_Fix\README.md") "# Fichiers de Correctif`n`n> Patch`n`n> Fichiers Fixes`n`n>  Fichiers de Restructuration `n"
  Ensure-File (Join-Path $Root "75_Support\Tools\README.md") "# Outils`n`n> Scripts PowerShell`n`n> Diverses technologies des clients`n"

  foreach ($d in $top) { Ensure-Dir (Join-Path $Root $d) }
  Ensure-Dir $TeamsRoot
  Ensure-File (Join-Path $Root "30_Equipes-GPT\README.md") "# Documentation des GPT Army`n`n> Dossiers de Agents GPT de l'equipe`n`n> Fichiers de configuration des agents`n"
  Ensure-File (Join-Path $Root "30_Equipes-GPT\17_Prompts\README.md") "# Prompts internes de`n`n> Brief de creation`n`n> Prompts-actifs`n`n> Templates`n`n> Fichiers enrichis`n"
  Ensure-File (Join-Path $Root "30_Equipes-GPT\17_Prompts\Templates\Check-list-modification-prompt.md") "# Check-liste de modification des prompts`n`n> Brief de creation`n`n> Prompts-actifs`n`n> Templates`n`n> Fichiers enrichis`n"
  Ensure-File (Join-Path $Root "30_Equipes-GPT\25_Templates\Template-Agent.md") "# Template d'agent specialiste`n`n> Template des agents specialiste`n`n> Prompts-actifs`n`n> Templates`n`n> Fichiers enrichis`n"
  Ensure-File (Join-Path $Root "30_Equipes-GPT\25_Templates\Template-Agent-AutreDomaine.md") "# Template de Prompts internes d'agents associes`n`n> Fichiers de prompts systeme d'agent asspcies`n"
  Ensure-File (Join-Path $Root "30_Equipes-GPT\17_Prompts\Prompts-archives\YYYY-MM-Archive-prompts-IT.md") "# Archive"
  Ensure-File (Join-Path $Root "30_Equipes-GPT\17_Prompts\Prompts-archives\YYYY-MM-Archive-tous-domaines.mdd") "# Archive de prompts d'agents associes`n"
}

function Load-Registry() {
  Ensure-Dir $AdminRoot

  if (-not (Test-Path -LiteralPath $RegistryPath)) {
    $initObj = [PSCustomObject]@{
      version    = "2.0"
      updated_at = (Get-Date).ToString("s")
      teams      = [PSCustomObject]@{}
    }
    $initObj | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $RegistryPath -Encoding UTF8
  }

  $raw = Get-Content -LiteralPath $RegistryPath -Raw
  $reg = $raw | ConvertFrom-Json

  if ($null -eq $reg.teams) {
    $reg | Add-Member -NotePropertyName teams -NotePropertyValue ([PSCustomObject]@{}) -Force
  }

  return $reg
}

function Save-Registry($reg) {
  $reg.updated_at = (Get-Date).ToString("s")
  $reg | ConvertTo-Json -Depth 50 | Set-Content -LiteralPath $RegistryPath -Encoding UTF8
}

function Ensure-TeamScaffold([string]$TeamFolder, [string]$DestRoot = "") {
  # Si DestRoot non fourni, fallback sur TeamsRoot (compatibilite)
  if ([string]::IsNullOrWhiteSpace($DestRoot)) { $DestRoot = $TeamsRoot }
  $teamPath = Join-Path $DestRoot $TeamFolder
  
  $teamDirs = @(
    "00_Administration",
    "00_Administration\06-Clients-Contexte",
    "00_Administration\06-Clients-Contexte",
    "00_Administration\06-Clients-Contexte\Client-A",
    "00_Administration\06-Clients-Contexte\Client-B",
    "00_Administration\06-Clients-Contexte\Client-c",
    "00_Administration\Glossaire-Termes",
    "00_Administration\01-Vision-Roadmap",
    "00_Administration\Rapport_Analyse",
    "00_Overview",
    "02_Architecture-Globale",
    "20-Procedures\Nomenclature",
    "20-Procedures\Guides_Utilisation",
    "30_Equipes-GPT\Fichiers_Agents",
    "30_Equipes-GPT\Fichiers_Agents\00_Templates",
    "30_Equipes-GPT\Fichiers_Agents\01_Templates",
    "30_Equipes-GPT\Fichiers_Agents\05_Knowledge",
    "30_Equipes-GPT\Fichiers_Agents\10_Memory",
    "30_Equipes-GPT\Fichiers_Agents",
    "30_Equipes-GPT\Fichiers_Teams\70_Bundle",
    "30_Equipes-GPT",
    "30_Equipes-GPT\00-Overview",
    "30_Equipes-GPT\20_Agents",
    "30_Equipes-GPT\17_Prompts",
    "30_Equipes-GPT\17_Prompts\Actifs",
    "30_Equipes-GPT\17_Prompts\Archives",
    "30_Equipes-GPT\25_Templates",
    "30_Equipes-GPT\13_Playbooks",
    "30_Equipes-GPT\14_Runbooks",
    "30_Equipes-GPT\15_Knowledge",
    "30_Equipes-GPT\26_Enrichissement",
    "30_Equipes-GPT\27_Bundle",
    "30_Equipes-GPT\28_Briefs",
    "50_Tests-Scenarios",
    "50_Tests-Scenarios\v1",
    "50_Tests-Scenarios\v2",
    "50_Tests-Scenarios\v3",
    "70_Outils-Scripts",
    "70_Outils-Scripts\Scripts-PowerShell",
    "70_Outils-Scripts\Scripts-Python",
    "70_Outils-Scripts\Templates_Script",
    "80_Changelog-Archives",
    "80_Changelog-Archives\Snapshots-architecture",
    "60_Documentation",
    "60_Images",
    "90_KNOWLEDGE", 
    "90_KNOWLEDGE\BUNDLES",
    "90_KNOWLEDGE\PACKS",
    "90_KNOWLEDGE\TEMPLATES",
    "90_KNOWLEDGE\CONTEXT",
    "90_KNOWLEDGE\BUNDLES\compiler",
    "90_KNOWLEDGE\BUNDLES\_sources",
    "90_KNOWLEDGE\BUNDLES\_compiled"
  )
  
  foreach ($dir in $teamDirs) {
    Ensure-Dir (Join-Path $teamPath $dir)
  }
  
  $agentsRoot = Join-Path $teamPath "30_Equipes-GPT\20_Agents"
  Ensure-Dir $agentsRoot

    Ensure-File (Join-Path $teamPath "90_KNOWLEDGE\BUNDLES\_sources\README.md") @"
# $TeamFolder - Vue d'Ensemble

## BUNDLE de KNOWLEDGE
> Description de la source de la connaissance
"@

  Ensure-File (Join-Path $teamPath "00_Overview\Description-equipe.md") @"
# $TeamFolder - Vue d'Ensemble

## Mission
> Decrire la mission principale de cette equipe

## Perimetre
> Definir les responsabilites et le perimetre d'action

## Agents de l'Equipe
> Liste des agents avec leurs roles

## Interfaces avec Autres Equipes
> Collaborations et handoffs

## KPIs
> Metriques de performance de l'equipe
"@

  Ensure-File (Join-Path $teamPath "00_Overview\Flux-de-travail-types.md") @"
# Flux de Travail Types - $TeamFolder

## Workflows Standards

### Workflow 1: [Nom]
1. Etape 1
2. Etape 2
3. Etape 3

### Workflow 2: [Nom]
1. Etape 1
2. Etape 2
3. Etape 3

## Escalations
> Procedures d'escalation

## Handoffs
> Protocoles de transfert entre agents
"@

  Ensure-File (Join-Path $teamPath "00_Administration\01-Vision-Roadmap\Roadmap-equipe.md") @"
# Roadmap - $TeamFolder

## Q1 2026
- [ ] Objectif 1
- [ ] Objectif 2

## Q2 2026
- [ ] Objectif 1
- [ ] Objectif 2

## Vision Long Terme
> Vision 12-24 mois
"@

  Ensure-File (Join-Path $teamPath "02_Architecture-Globale\Architecture-equipe.md") @"
# Architecture - $TeamFolder

## Composants
> Architecture des agents et systemes

## Dependances
> Systemes externes et APIs

## Data Flow
> Flux de donnees entre agents
"@

  Ensure-File (Join-Path $teamPath "30_Equipes-GPT\17_Prompts\Templates-prompts.md") @"
# Templates de Prompts - $TeamFolder

## Template 1: [Usage]
``````
[Prompt template]
``````

## Template 2: [Usage]
``````
[Prompt template]
``````
"@

  Ensure-File (Join-Path $teamPath "50_Tests-Scenarios\Scenarios-test.md") @"
# Scenarios de Test - $TeamFolder

## Scenario 1: [Nom]
**Input:**
``````
[Input de test]
``````

**Output Attendu:**
``````
[Output attendu]
``````

**Resultat:**
- [ ] Pass
- [ ] Fail
"@

  Ensure-File (Join-Path $teamPath "00_Administration\06-Clients-Contexte\Contextes-clients.md") @"
# Contextes Clients - $TeamFolder

## Client 1: [Nom]
- **Environnement:** [Description]
- **Specificites:** [Details]
- **Contraintes:** [Contraintes]

## Client 2: [Nom]
[...]
"@

  Ensure-File (Join-Path $teamPath "80_Changelog-Archives\CHANGELOG.md") @"
# Changelog - $TeamFolder

## [Unreleased]
### Added
- 

### Changed
- 

### Fixed
- 

## [1.0.0] - $(Get-Date -Format 'yyyy-MM-dd')
### Added
- Creation initiale de l'equipe $TeamFolder
"@

  Ensure-File (Join-Path $teamPath "60_Documentation\README.md") @"
# Documentation - $TeamFolder

## Guides
- [Guide 1](lien)
- [Guide 2](lien)

## References
- [Reference 1](lien)
- [Reference 2](lien)

## Best Practices
> Meilleures pratiques de l'equipe
"@

  return $agentsRoot
}

function Get-ManifestTemplate([string]$AgentName, [string]$TeamName) {
  $manifest = @{
    agent_name = $AgentName
    display_name = "@$AgentName"
    team = $TeamName
    role = "[Role de l'agent - A completer]"
    version = "1.0.0"
    files = @(
      "README.md",
      "00_REFERENCE_DATA/README.md",
      "01_TEMPLATES/",
      "02_RUNBOOKS/README.md",
      "03_CHECKLISTS/README.md",
      "04_EXEMPLES/README.md",
      "05_KNOWLEDGE/",
      "10_MEMORY/README.md",
      "65_TEST/README.md",
      "05_KNOWLEDGE/",
      "00_INSTRUCTIONS.md",
      "01_CONTRACT.yaml",
      "03_ORIGINAL_PROMPT.md",
      "04_KNOWLEDGE_INDEX.md"
      
    )
    outputs = @(
      "[Type de livrable 1]",
      "[Type de livrable 2]"
    )
    templates = @()
  }
  
  return ($manifest | ConvertTo-Json -Depth 10)
}

function Get-InstructionsTemplate([string]$AgentName, [string]$TeamName) {
  return @"
# Instructions Internes - $AgentName

## Identite de l'Agent

Tu es **@$AgentName**, un agent specialise de l'equipe **$TeamName**.

**Ton role:** [Decrire le role principal - A completer]

## Domaine d'Expertise

[Description du domaine d'expertise et des responsabilites - A completer]

## Livrables Attendus

Tu es capable de produire les types de documents suivants:
1. [Type de document 1]
2. [Type de document 2]
3. [Type de document 3]

## Protocole de Travail

### 1. Reception de Requete
- Analyser l'objectif principal
- Identifier le contexte et les contraintes
- Clarifier les ambiguites si necessaire

### 2. Planification
- Determiner le(s) livrable(s) approprie(s)
- Identifier les informations manquantes
- Evaluer la complexite et les risques

### 3. Execution
- Utiliser les templates appropries
- Respecter les standards de qualite
- Documenter les decisions et justifications

### 4. Livraison
- Fournir tous les livrables demandes
- Inclure les metadonnees (temps, complexite, confiance)
- Suggerer les prochaines etapes
- Escalader si necessaire

## Standards de Qualite

### Precision Technique
- Verifier tous les faits et donnees
- Citer les sources quand pertinent
- Utiliser la terminologie correcte

### Clarte et Structure
- Organisation logique du contenu
- Titres et sous-titres clairs
- Utilisation appropriee des listes et tableaux

### Professionnalisme
- Ton adapte a l'audience
- Format professionnel
- Respect des conventions MSP

## Format de Reponse Standard

``````yaml
output:
  status: [success/partial/failed/escalated]
  deliverables:
    - type: [Type de document]
      content: [Contenu]
      format: [markdown/yaml/json/text]
  metadata:
    execution_time: [Duree]
    complexity: [low/medium/high]
    confidence: [0.0-1.0]
  next_steps:
    - [Action recommandee 1]
    - [Action recommandee 2]
``````

---

*Document genere automatiquement - Version 1.0*
*A completer selon les besoins specifiques de l'agent*
"@
}

function Get-ContractTemplate([string]$AgentName, [string]$TeamName) {
  return @"
# Contract I/O - $AgentName

## Agent Identity
display_name: @$AgentName
team: $TeamName
role: [Role detaille - A completer]
version: 1.0.0

## Input Schema
input:
  type: object
  required:
    - objective
    - context
  properties:
    objective:
      type: string
      description: L'objectif principal de la requete
    context:
      type: string
      description: Le contexte complet de la situation
    priority:
      type: string
      enum: [low, medium, high, critical]

## Output Schema
output:
  type: object
  required:
    - status
    - deliverables
  properties:
    status:
      type: string
      enum: [success, partial, failed, escalated]
    deliverables:
      type: array
    metadata:
      type: object

## Expected Deliverables
- [Type de livrable 1]
- [Type de livrable 2]

## Quality Standards
- Precision technique elevee
- Format adapte au contexte professionnel
- Respect des standards MSP

---

*Contract genere automatiquement - Version 1.0*
"@
}

function Get-ReadmeTemplate([string]$AgentName, [string]$TeamName) {
  return @"
# Bundle GPT - $AgentName

## Vue d'Ensemble

**Agent:** $AgentName  
**Equipe:** $TeamName  
**Version:** 1.0.0  

## Description

[Description du role et des responsabilites - A completer]

## Installation dans GPT Editor

### Etape 1: Creer le GPT
1. Aller sur chat.openai.com
2. My GPTs -> Create a GPT

### Etape 2: Configuration
**Name:** @$AgentName
**Instructions:** Copier tout le contenu de 00_INSTRUCTIONS.md

### Etape 3: Upload Fichiers
Uploader TOUS les fichiers dans Knowledge

## Utilisation

Format de requete:
``````yaml
Objectif: [Votre objectif]
Contexte: [Contexte]
Priorite: [low/medium/high/critical]
``````

## Livrables

Cet agent peut produire:
1. [Type 1]
2. [Type 2]

---

*Bundle genere automatiquement*
"@
}

function Get-KnowledgeIndexTemplate([string]$AgentName) {
  return @"
# Knowledge Index - $AgentName

## Vue d'Ensemble

Cet agent dispose des ressources de connaissances suivantes:

## Fichiers de Connaissances

### Standards et Procedures
- [A ajouter]

### Exemples et Templates
- [A ajouter]

## Utilisation

Ces fichiers doivent etre consultes pour:
- Comprendre les standards et best practices
- Trouver des exemples de travaux similaires
- Verifier les procedures etablies

---

*Index genere automatiquement*
"@
}

# ==========================================
# DETECTION DE TYPE D'AGENT (v2.6)
# ==========================================

function Detect-AgentType([string]$AgentName) {
  $name = $AgentName.ToUpper()

  $keywordsIT  = @("PATCH","INFRA","SERVER","DEPLOY","MONITOR","BACKUP","NETWORK","ACTIVE","DOMAIN","SQL","FIREWALL","MIGRATION","VLAN","SWITCH","DC","SYSADMIN","WINDOWS","LINUX","VMWARE","HYPERV","STORAGE","SCCM","WSUS","RDS","GPO","DNS","DHCP","PKI","CERTIFICATE","VIRTUALIZ","CLOUD","AZURE","AWS")
  $keywordsMSP = @("SUPPORT","CLIENT","HELP","TICKET","INCIDENT","SLA","ESCALAT","SERVICEDESK","ONBOARD","OFFBOARD","RAPPORT","ACCOUNT","CSM","SUCCESS","RELATION","DESK","PORTAL","BILLING","CONTRACT","REVIEW")
  $keywordsTRAD= @("TRAD","TRADE","CRYPTO","MARKET","SIGNAL","INTEL","SCORE","TOKEN","PORTFOLIO","RISK","ANALYSE","SENTIMENT","FEAR","MOMENTUM","VOLUME","LIQUIDITY","EXCHANGE","PAIR","STRATEGY","BACKTEST","ALERT","INDICATOR","TREND","VOLATIL")
  $keywordsDAM = @("DAM","DESIGN","CATALOGUE","PRODUIT","INTERIOR","RENDER","VISUAL","ASSET","IMAGE","PHOTO","MOOD","BOARD","BRAND","LOGO","LAYOUT","TEMPLATE","BRANDING","CATALOG","PRODUCT","RENDU","FICHE","COLLECTION","MATERIAL","TEXTURE","ARCH")

  $scoreIT=0; $scoreMSP=0; $scoreTRAD=0; $scoreDAM=0

  foreach ($k in $keywordsIT)   { if ($name -like "*$k*") { $scoreIT++ } }
  foreach ($k in $keywordsMSP)  { if ($name -like "*$k*") { $scoreMSP++ } }
  foreach ($k in $keywordsTRAD) { if ($name -like "*$k*") { $scoreTRAD++ } }
  foreach ($k in $keywordsDAM)  { if ($name -like "*$k*") { $scoreDAM++ } }

  $max = [Math]::Max([Math]::Max($scoreIT,$scoreMSP),[Math]::Max($scoreTRAD,$scoreDAM))
  if ($max -eq 0) { return "GENERIC" }

  if ($scoreIT   -eq $max) { return "IT"    }
  if ($scoreTRAD -eq $max) { return "TRAD"  }
  if ($scoreDAM  -eq $max) { return "DAM"   }
  if ($scoreMSP  -eq $max) { return "MSP"   }
  return "GENERIC"
}

function Confirm-AgentType([string]$Detected, [string]$AgentName) {
  $types = @("IT","MSP","TRAD","DAM","GENERIC")
  $labels = @{
    "IT"      = "IT / Infrastructure / Patching"
    "MSP"     = "Support Client / MSP"
    "TRAD"    = "TRAD - Trading & Crypto Intelligence"
    "DAM"     = "DAM - Design & Catalogue Produit"
    "GENERIC" = "GENERIC - Gabarit universel"
  }

  Write-Host ""
  Write-Host ("  [TYPE AGENT] " + $AgentName) -ForegroundColor Cyan
  if ($Detected -ne "GENERIC") {
    Write-Host ("  Auto-detecte : " + $labels[$Detected]) -ForegroundColor Green
  } else {
    Write-Host "  Aucun mot-cle reconnu -> GENERIC par defaut" -ForegroundColor Yellow
  }
  Write-Host ""
  Write-Host "  Confirmer ou choisir un autre type :" -ForegroundColor White
  for ($i=0; $i -lt $types.Count; $i++) {
    $marker = if ($types[$i] -eq $Detected) { " <-- detecte" } else { "" }
    Write-Host ("  " + ($i+1) + ") " + $labels[$types[$i]] + $marker)
  }
  Write-Host ""

  while ($true) {
    $pick = (Read-Host "  Choix [1-5] (Entree = confirmer detecte)").Trim()
    if ([string]::IsNullOrWhiteSpace($pick)) { return $Detected }
    $num = 0
    if ([int]::TryParse($pick,[ref]$num) -and $num -ge 1 -and $num -le $types.Count) {
      return $types[$num-1]
    }
    Write-Host "  Choix invalide. Entrer un chiffre de 1 a 5." -ForegroundColor Yellow
  }
}

# --------------------------------------------------
# CONTENU SPECIALISE PAR TYPE
# --------------------------------------------------

function Get-Instructions-IT([string]$AgentName, [string]$TeamName) {
  return @"
# Instructions Internes - $AgentName
## Identite de l'Agent
Tu es **@$AgentName**, agent IT specialise de l'equipe **$TeamName**.
**Ton role:** Gerer, automatiser et documenter les operations d'infrastructure Windows/Linux, patching, deploiement et surveillance des systemes.

## Domaine d'Expertise
- Administration systemes : Windows Server, Active Directory, DNS, DHCP, GPO
- Patching et mise a jour : WSUS, SCCM, cycles de maintenance planifies
- Virtualisation : VMware, Hyper-V, gestion des VMs
- Surveillance : alertes, seuils, rapports d'etat systeme
- Sauvegarde et restauration : politiques backup, tests de restauration
- Securite infrastructure : firewall, certificats, acces privilegies

## Livrables Attendus
1. Rapport de patching (mensuel/hebdomadaire)
2. Plan de maintenance avec fenetres approuvees
3. Rapport d'incident technique (RCA)
4. Documentation de configuration
5. Checklist de deploiement

## Protocole de Travail
### 1. Reception
- Identifier l'environnement cible (PROD/DEV/TEST)
- Verifier les fenetres de maintenance autorisees
- Confirmer les contacts d'approbation client

### 2. Execution
- Appliquer le runbook correspondant
- Journaliser chaque action avec horodatage
- Capturer l'etat avant/apres

### 3. Livraison
- Rapport d'execution avec statut par serveur
- Liste des elements en echec ou a surveiller
- Recommandations pour la prochaine fenetre

## Format de Reponse Standard
``````yaml
output:
  status: [success/partial/failed/escalated]
  environment: [client / segment reseau]
  servers_total: [N]
  servers_success: [N]
  servers_failed: [N]
  next_maintenance: [YYYY-MM-DD]
  metadata:
    execution_time: [duree]
    technician: $AgentName
``````
---
*Instructions generees automatiquement - Type IT - Version 1.0*
*A completer : role specifique, clients assignes, acces systemes*
"@
}

function Get-Runbook-IT([string]$AgentName) {
  return @"
# RB-001 - Cycle de Patching Mensuel
**Agent:** @$AgentName | **Type:** IT Infrastructure

## Objectif
Appliquer les mises a jour de securite et correctifs systeme sur les serveurs assignes dans la fenetre de maintenance approuvee.

## Declencheur
- Date de maintenance planifiee (generalement 2e mardi du mois - Patch Tuesday)
- Alerte de vulnerabilite critique (CVSS >= 9.0 = hors cycle)

## Prerequis
- [ ] Fenetre de maintenance confirmee avec le client
- [ ] Snapshots/sauvegardes recentes verifiees
- [ ] Liste des serveurs cibles exportee
- [ ] Contacts d'urgence identifies

## Etapes
### Phase 1 - Pre-maintenance (J-2)
1. Exporter la liste des serveurs depuis la CMDB
2. Verifier l'etat des sauvegardes (< 24h)
3. Envoyer la notification de maintenance aux parties prenantes
4. Preparer le rapport de patching vierge

### Phase 2 - Execution (Fenetre maintenance)
1. Confirmer le debut de fenetre avec le client
2. Pour chaque serveur (ordre : DEV > QA > PROD) :
   a. Verifier connectivite RDP/WinRM
   b. Capturer l'etat actuel (uptime, services critiques)
   c. Lancer les mises a jour (Windows Update / WSUS)
   d. Surveiller la progression
   e. Redemarrer si requis (confirmation client si PROD)
   f. Verifier redemarrage et services post-patch
   g. Documenter le statut dans le rapport

### Phase 3 - Post-maintenance
1. Consolider le rapport final (succes / echecs / en attente)
2. Envoyer le rapport au client
3. Planifier le suivi pour les elements en echec
4. Mettre a jour la CMDB

## Verification
- [ ] Tous les serveurs cibles traites ou statut documente
- [ ] Services critiques operationnels
- [ ] Rapport envoye et accuse de reception obtenu

## Rollback
- Restaurer depuis le snapshot pre-maintenance
- Notifier le client immediatement
- Ouvrir un ticket d'incident

---
*RB-001 - $AgentName - Version 1.0*
"@
}

function Get-Checklist-IT([string]$AgentName) {
  return @"
# CL-001 - Checklist Pre/Post Patching
**Agent:** @$AgentName | **Type:** IT Infrastructure

## PRE-EXECUTION
### Preparation environnement
- [ ] Fenetre de maintenance approuvee par ecrit
- [ ] Backup/snapshot < 24h confirme pour chaque serveur PROD
- [ ] Services critiques identifies et surveilles
- [ ] Contacts d'urgence disponibles pendant la fenetre
- [ ] Plan de rollback documente

### Verification systeme
- [ ] Espace disque suffisant (>= 15% libre sur C:)
- [ ] Pas d'incidents actifs sur les serveurs cibles
- [ ] Acces administrateur valide (RDP / WinRM)
- [ ] Antivirus en mode exclusion pour la fenetre

## EXECUTION
- [ ] Serveurs DEV/QA traites avant PROD
- [ ] Chaque redemarrage confirme avec client (PROD)
- [ ] Statut journalise par serveur en temps reel
- [ ] Alertes monitoring suspendues pendant maintenance

## POST-EXECUTION
### Validation technique
- [ ] Services critiques operationnels (liste a definir par client)
- [ ] Pas d'erreurs dans l'Event Viewer (niveau Critical/Error)
- [ ] Connectivite reseau confirmee
- [ ] Applications metier accessibles

### Rapport et cloture
- [ ] Rapport de patching complete (succes/echecs/reportes)
- [ ] Rapport envoye au client dans les 2h post-maintenance
- [ ] Tickets ouverts pour les serveurs en echec
- [ ] CMDB mise a jour
- [ ] Prochaine fenetre planifiee si elements en suspens

---
*CL-001 - $AgentName - Version 1.0*
"@
}

function Get-Exemple-IT([string]$AgentName) {
  return @"
# EX-001 - Exemple : Rapport de Patching Mensuel
**Agent:** @$AgentName | **Type:** IT | **Statut:** PASS (cas nominal)

## INPUT
``````yaml
Objectif: Patching mensuel - Fenetre Mars 2026
Client: EC Solutions Inc.
Environnement: 12 serveurs Windows Server 2019/2022
Fenetre: Samedi 2026-03-15 02h00-06h00
Priorite: high
``````

## PROCESSING (resume)
- Phase pre-maintenance completee (backups verifies, notifications envoyees)
- 12 serveurs traites dans l'ordre DEV(3) -> QA(2) -> PROD(7)
- 2 redeemarrages PROD confirmes avec gestionnaire de garde
- 1 serveur en echec (SRV-SQL-04 : espace disque insuffisant)

## OUTPUT ATTENDU
``````yaml
output:
  status: partial
  servers_total: 12
  servers_success: 11
  servers_failed: 1
  servers_failed_list:
    - name: SRV-SQL-04
      reason: Espace disque insuffisant (8% libre)
      action: Ticket INC-2026-0315 ouvert
  next_action: Nettoyage SRV-SQL-04 + re-patching dans 72h
  rapport_envoye: true
  client_notifie: true
``````

## LECONS
- Verifier l'espace disque en pre-check (ajouter a CL-001)
- SRV-SQL-04 : purge logs SQL planifiee mensuellement

---
*EX-001 - $AgentName - Version 1.0*
"@
}

function Get-Instructions-MSP([string]$AgentName, [string]$TeamName) {
  return @"
# Instructions Internes - $AgentName
## Identite de l'Agent
Tu es **@$AgentName**, agent support specialise de l'equipe **$TeamName**.
**Ton role:** Gerer la relation client, traiter les tickets de support, assurer le suivi des SLA et produire les rapports de service.

## Domaine d'Expertise
- Gestion de tickets : creation, priorisation, escalade, resolution
- Suivi SLA : temps de reponse, temps de resolution, taux de respect
- Communication client : mises a jour, rapports, revues de service
- Onboarding/offboarding clients et utilisateurs
- Documentation : procedures, guides utilisateur, base de connaissances
- Satisfaction client : NPS, CSAT, actions correctives

## Livrables Attendus
1. Rapport de service mensuel (SLA, tickets, tendances)
2. Plan d'action suite a incident critique
3. Compte-rendu de revue de service trimestrielle
4. Guide utilisateur ou procedure
5. Resume d'escalade avec contexte complet

## Protocole de Travail
### 1. Ticket entrant
- Categoriser et prioriser (P1/P2/P3/P4)
- Verifier le SLA applicable
- Identifier le bon proprietaire technique

### 2. Suivi
- Mises a jour regulieres selon SLA
- Communication proactive au client
- Escalade si risque de breche SLA

### 3. Cloture
- Confirmation resolution avec le client
- Documentation de la solution
- Mise a jour base de connaissances si pertinent

## Format de Reponse Standard
``````yaml
output:
  status: [success/partial/escalated]
  ticket_id: [ID]
  client: [Nom client]
  sla_respecte: [true/false]
  temps_resolution: [duree]
  action_suivante: [description]
``````
---
*Instructions generees automatiquement - Type MSP - Version 1.0*
"@
}

function Get-Runbook-MSP([string]$AgentName) {
  return @"
# RB-001 - Gestion Incident P1/P2 (Critique/Majeur)
**Agent:** @$AgentName | **Type:** MSP Support

## Objectif
Gerer un incident de haute priorite de l'ouverture jusqu'a la resolution en respectant les SLA et en maintenant une communication fluide avec le client.

## Declencheur
- Ticket entrant classe P1 (indisponibilite totale) ou P2 (degradation majeure)
- Escalade manuelle d'un ticket P3

## SLA de Reference
| Priorite | Reponse initiale | Mise a jour | Resolution cible |
|----------|-----------------|-------------|-----------------|
| P1       | 15 min          | 30 min      | 4h              |
| P2       | 30 min          | 1h          | 8h              |
| P3       | 2h              | 4h          | 24h             |
| P4       | 4h              | 8h          | 72h             |

## Etapes
### Phase 1 - Reponse initiale (< SLA reponse)
1. Accuser reception au client (email/portail)
2. Evaluer l'impact reel et ajuster la priorite si necessaire
3. Identifier le technicien responsable
4. Creer le bridge de crise si P1

### Phase 2 - Diagnostic et resolution
1. Collecter les informations (logs, screenshots, contexte)
2. Identifier la cause probable
3. Appliquer la solution ou escalader au niveau 2/3
4. Communiquer l'avancement au client toutes les [X] min

### Phase 3 - Cloture
1. Confirmer la resolution avec le client
2. Documenter la cause racine (RCA si P1)
3. Proposer des mesures preventives
4. Clore le ticket avec notes completes

## Rollback / Escalade
- Si non resolu en 50% du SLA : escalader au lead technique
- Si non resolu en 80% du SLA : notifier le gestionnaire MSP et le client

---
*RB-001 - $AgentName - Version 1.0*
"@
}

function Get-Checklist-MSP([string]$AgentName) {
  return @"
# CL-001 - Checklist Qualite Rapport de Service Mensuel
**Agent:** @$AgentName | **Type:** MSP Support

## DONNEES A VALIDER
- [ ] Periode couverte clairement indiquee (du JJ/MM au JJ/MM)
- [ ] Nom du client exact et logo correct
- [ ] Tous les tickets du mois inclus (pas d'omission)
- [ ] Categorisation des tickets verifiee (P1/P2/P3/P4)

## METRIQUES SLA
- [ ] Taux de respect SLA calcule correctement
- [ ] Temps moyen de reponse calcule
- [ ] Temps moyen de resolution calcule
- [ ] Incidents P1/P2 du mois listes individuellement
- [ ] Comparaison avec le mois precedent presente

## CONTENU NARRATIF
- [ ] Resume executif (max 1 paragraphe, ton positif et professionnel)
- [ ] Points saillants du mois (incidents notables, ameliorations)
- [ ] Tendances identifiees (recurrence, type d'incident)
- [ ] Plan d'action pour le mois suivant

## FORMAT ET LIVRAISON
- [ ] En-tete avec logo client et date
- [ ] Langue correcte (francais professionnel)
- [ ] Tableau de bord visuel (graphiques si applicable)
- [ ] Envoye au bon contact client avant la deadline
- [ ] Copie archivee dans le dossier client

---
*CL-001 - $AgentName - Version 1.0*
"@
}

function Get-Exemple-MSP([string]$AgentName) {
  return @"
# EX-001 - Exemple : Rapport de Service Mensuel
**Agent:** @$AgentName | **Type:** MSP | **Statut:** PASS (cas nominal)

## INPUT
``````yaml
Objectif: Generer le rapport de service mensuel - Fevrier 2026
Client: PLB International Inc.
Periode: 2026-02-01 au 2026-02-28
Donnees: 47 tickets traites, 2 incidents P2, SLA global 96.8%
Priorite: medium
``````

## OUTPUT ATTENDU
``````markdown
# Rapport de Service - Fevrier 2026
**Client:** PLB International Inc.

## Resume Executif
Mois stable avec 47 requetes traitees. Taux SLA de 96.8%, au-dessus de
l'objectif contractuel de 95%. Deux incidents P2 resolus dans les delais.

## Metriques Cles
| Indicateur         | Fevrier | Janvier | Objectif |
|--------------------|---------|---------|----------|
| Tickets total      | 47      | 52      | -        |
| Respect SLA        | 96.8%   | 94.2%   | >= 95%   |
| Temps moy. reponse | 22 min  | 31 min  | <= 30min |
| CSAT               | 4.6/5   | 4.4/5   | >= 4.0   |

## Incidents P1/P2
- INC-2026-0214 (P2) : Lenteur VPN - Resolu en 3h22 (SLA: 8h) ✓
- INC-2026-0221 (P2) : Echec sauvegarde SQL - Resolu en 5h10 (SLA: 8h) ✓

## Plan d'action Mars 2026
- Revue de la configuration VPN (prevenir recurrence INC-0214)
- Mise a jour de la politique de sauvegarde SQL
``````

---
*EX-001 - $AgentName - Version 1.0*
"@
}

function Get-Instructions-TRAD([string]$AgentName, [string]$TeamName) {
  return @"
# Instructions Internes - $AgentName
## Identite de l'Agent
Tu es **@$AgentName**, agent d'intelligence de marche de l'equipe **$TeamName**.
**Ton role:** Analyser les marches crypto, produire des scores de sentiment et de momentum, generer des signaux d'action et des rapports d'intelligence.

## Domaine d'Expertise
- Analyse de marche : prix, volume, liquidite, order book
- Indicateurs techniques : RSI, MACD, Bollinger, EMA, support/resistance
- Sentiment de marche : Fear & Greed Index, sentiment social, news flow
- Scoring multi-domaines : ponderation de signaux heterogenes
- Gestion du risque : drawdown, position sizing, stop-loss
- Rapports d'intelligence : synthese pour prise de decision

## Livrables Attendus
1. Score de marche journalier (0-100 par domaine)
2. Rapport d'analyse technique (setup actuel)
3. Alerte de signal (entree/sortie potentielle)
4. Rapport de sentiment hebdomadaire
5. Bilan de performance de strategie

## Protocole de Travail
### 1. Collecte de donnees
- Prix OHLCV sur les timeframes pertinents
- Indicateurs on-chain (si disponibles)
- Flux de nouvelles et sentiment social

### 2. Scoring
- Calculer chaque domaine independamment
- Appliquer les coefficients de ponderation
- Produire le score global et le signal resultant

### 3. Livraison
- Score synthetique avec decomposition par domaine
- Signal clair : BULLISH / BEARISH / NEUTRE
- Niveau de confiance et facteurs de risque

## Format de Reponse Standard
``````yaml
output:
  asset: [BTC/ETH/...]
  timeframe: [1H/4H/1D]
  score_global: [0-100]
  signal: [BULLISH/BEARISH/NEUTRE]
  confiance: [0.0-1.0]
  domaines:
    technique: [score]
    sentiment: [score]
    volume: [score]
    momentum: [score]
  recommandation: [description]
``````
---
*Instructions generees automatiquement - Type TRAD - Version 1.0*
"@
}

function Get-Runbook-TRAD([string]$AgentName) {
  return @"
# RB-001 - Analyse Journaliere de Marche
**Agent:** @$AgentName | **Type:** TRAD Intelligence

## Objectif
Produire le rapport d'analyse quotidien avec scoring multi-domaines et signal de marche.

## Declencheur
- Routine quotidienne (heure a definir selon marche cible)
- Alerte de mouvement de prix >= X% en 1h

## Prerequis
- [ ] Acces aux flux de donnees de marche actifs
- [ ] Parametres de scoring a jour (coefficients valides)
- [ ] Seuils d'alerte configures

## Etapes
### Phase 1 - Collecte (15 min)
1. Capturer OHLCV sur les timeframes : 1H, 4H, 1D
2. Relever les indicateurs techniques cles (RSI, MACD, EMA20/50/200)
3. Collecter le Fear & Greed Index du jour
4. Scanner le flux de nouvelles (top 5 headlines)
5. Verifier le volume compare a la moyenne 30j

### Phase 2 - Scoring (10 min)
1. Scorer chaque domaine sur 100
2. Appliquer les coefficients de ponderation
3. Calculer le score global pondere
4. Determiner le signal (BULLISH si > 65 / BEARISH si < 35 / NEUTRE sinon)
5. Evaluer le niveau de confiance

### Phase 3 - Rapport (5 min)
1. Rediger le resume executif (3-5 lignes)
2. Lister les supports et resistances cles
3. Identifier les evenements a risque (news macro, expiration options)
4. Envoyer le rapport au canal designe

## Alertes immediates
- Score > 80 ou < 20 : alerte critique
- Mouvement > 5% en 1h : rapport intra-journalier

---
*RB-001 - $AgentName - Version 1.0*
"@
}

function Get-Checklist-TRAD([string]$AgentName) {
  return @"
# CL-001 - Checklist Validation Rapport d'Analyse
**Agent:** @$AgentName | **Type:** TRAD Intelligence

## DONNEES DE BASE
- [ ] Asset et paire de trading clairement identifies
- [ ] Timeframe(s) analyses specifies
- [ ] Source des donnees documentee
- [ ] Horodatage de l'analyse present

## ANALYSE TECHNIQUE
- [ ] Prix actuel, variation 24h/7j notes
- [ ] RSI calcule et interprete (survente/surachat?)
- [ ] MACD : position et croisement recents
- [ ] Niveaux supports/resistances identifies (min. 2 de chaque)
- [ ] Tendance macro identifiee (haussiere/baissiere/laterale)

## SENTIMENT ET CONTEXTE
- [ ] Fear & Greed Index note avec interpretation
- [ ] Volume compare a moyenne 30j (superieur/inferieur)
- [ ] Evenements macro a venir identifies (FOMC, CPI, expirations)
- [ ] Nouvelles significatives des 24h verifiees

## SCORING ET SIGNAL
- [ ] Chaque domaine score independamment (pas de contamination)
- [ ] Coefficients de ponderation appliques correctement
- [ ] Score global dans la plage [0-100]
- [ ] Signal coherent avec le score global
- [ ] Niveau de confiance justifie

## LIVRAISON
- [ ] Recommandation actionnable (pas juste "surveiller")
- [ ] Facteurs de risque principaux mentionnes
- [ ] Format de sortie YAML valide

---
*CL-001 - $AgentName - Version 1.0*
"@
}

function Get-Exemple-TRAD([string]$AgentName) {
  return @"
# EX-001 - Exemple : Analyse Journaliere BTC
**Agent:** @$AgentName | **Type:** TRAD | **Statut:** PASS (cas nominal)

## INPUT
``````yaml
Objectif: Analyse journaliere Bitcoin
Asset: BTC/USDT
Timeframes: 1H, 4H, 1D
Date: 2026-03-11
Priorite: high
``````

## OUTPUT ATTENDU
``````yaml
output:
  asset: BTC/USDT
  timeframe: 1D
  prix_actuel: 84250
  variation_24h: +2.3%
  score_global: 71
  signal: BULLISH
  confiance: 0.72
  domaines:
    technique:    78  # EMA20 > EMA50, MACD haussier
    sentiment:    65  # Fear & Greed: 62 (Greed)
    volume:       70  # Volume +18% vs moyenne 30j
    momentum:     74  # RSI 61 - zone positive non surchauffe
    on_chain:     68  # Accumulation wallets > 1 BTC
  supports_cles: [82000, 79500, 76000]
  resistances_cles: [86500, 89000, 92000]
  risques:
    - Expiration options vendredi 86B notional
    - CPI US jeudi - potentiel catalyseur
  recommandation: >
    Structure haussiere intacte au-dessus de 82000.
    Zone d'interet long sur pullback 82000-82500.
    Stop suggere sous 79500. Cible court terme 86500.
``````

---
*EX-001 - $AgentName - Version 1.0*
"@
}

function Get-Instructions-DAM([string]$AgentName, [string]$TeamName) {
  return @"
# Instructions Internes - $AgentName
## Identite de l'Agent
Tu es **@$AgentName**, agent de gestion des actifs digitaux et design de l'equipe **$TeamName**.
**Ton role:** Gerer, organiser et produire les actifs visuels, catalogues produits et livrables de design pour les clients de l'industrie construction/design interieur.

## Domaine d'Expertise
- Gestion d'actifs digitaux (DAM) : nomenclature, classification, archivage
- Design interieur : moodboards, palettes, fiches materiaux, rendu
- Catalogues produits : fiches techniques, specifications, visuels
- Rendu architectural : coordination SketchUp, Enscape, Veras, ControlNet
- Branding et identite visuelle : coherence, standards, templates
- Workflow de production : brief -> concept -> validation -> livraison

## Livrables Attendus
1. Fiche produit complete (visuel + specifications)
2. Catalogue de produits (collection complete)
3. Moodboard conceptuel
4. Guide de nomenclature et classification DAM
5. Pack de livraison client (assets finalises)

## Protocole de Travail
### 1. Reception du brief
- Identifier le type de livrable (fiche / catalogue / moodboard)
- Definir le style et les contraintes visuelles
- Lister les assets sources disponibles

### 2. Production
- Appliquer les standards de nomenclature
- Respecter la charte graphique client
- Documenter chaque decision de design

### 3. Livraison
- Pack organise selon la structure DAM
- Formats de livraison specifies (web/print/3D)
- Index des assets livre avec le pack

## Format de Reponse Standard
``````yaml
output:
  livrable: [fiche/catalogue/moodboard/pack]
  client: [nom]
  collection: [nom collection]
  assets_produits: [N]
  formats: [web/print/pdf]
  statut_approbation: [draft/revue/approuve]
``````
---
*Instructions generees automatiquement - Type DAM - Version 1.0*
"@
}

function Get-Runbook-DAM([string]$AgentName) {
  return @"
# RB-001 - Production d'une Fiche Produit
**Agent:** @$AgentName | **Type:** DAM Design

## Objectif
Produire une fiche produit complete et conforme aux standards pour integration dans un catalogue client.

## Declencheur
- Nouveau produit a integrer au catalogue
- Mise a jour d'une fiche existante (prix, specs, visuel)
- Brief de creation catalogue recu

## Prerequis
- [ ] Brief produit recu (nom, categorie, specs, visuels sources)
- [ ] Charte graphique client disponible
- [ ] Template de fiche approuve
- [ ] Acces aux assets visuels sources

## Etapes
### Phase 1 - Preparation
1. Verifier la completude du brief (specs manquantes = bloquer et demander)
2. Recuperer le template de fiche applicable (par categorie produit)
3. Verifier la disponibilite et la qualite des visuels sources
4. Attribuer le code produit selon la nomenclature DAM

### Phase 2 - Production
1. Completer toutes les sections de la fiche :
   - Nom commercial et code article
   - Description courte (< 50 mots) et longue (< 200 mots)
   - Specifications techniques (dimensions, materiaux, finitions)
   - Visuels : photo principale + vues complementaires
   - Disponibilite et delai de livraison
2. Optimiser les visuels (resolutions web et print)
3. Appliquer le style typographique de la charte

### Phase 3 - Validation et livraison
1. Relire la fiche (fautes, coherence specs/visuels)
2. Exporter en formats requis (PDF, PNG web, source)
3. Nommer les fichiers selon la nomenclature DAM
4. Livrer dans le dossier client designe
5. Mettre a jour l'index du catalogue

## Criteres de qualite
- Texte sans faute, specs verifiees aupres de la source
- Visuel principal : fond blanc ou contextuel selon charte
- Resolution print : 300 DPI minimum
- Resolution web : 72 DPI, < 500 Ko

---
*RB-001 - $AgentName - Version 1.0*
"@
}

function Get-Checklist-DAM([string]$AgentName) {
  return @"
# CL-001 - Checklist Qualite Fiche Produit / Catalogue
**Agent:** @$AgentName | **Type:** DAM Design

## INFORMATIONS PRODUIT
- [ ] Code article attribue selon nomenclature DAM
- [ ] Nom commercial exact (verifie aupres du fournisseur)
- [ ] Categorie et sous-categorie correctes
- [ ] Description courte <= 50 mots, sans faute
- [ ] Description longue <= 200 mots, sans faute
- [ ] Toutes les specifications techniques presentes (dimensions, materiaux, finitions)
- [ ] Prix et disponibilite a jour

## VISUELS
- [ ] Photo principale presente (fond conforme a la charte)
- [ ] Resolution print >= 300 DPI
- [ ] Resolution web <= 500 Ko (optimisee)
- [ ] Vues complementaires presentes si requis (angle, detail, contexte)
- [ ] Pas de filigrane ni logo fournisseur non autorise

## CONFORMITE
- [ ] Template de fiche correct pour cette categorie
- [ ] Typographie conforme a la charte client
- [ ] Couleurs conformes (codes HEX / Pantone valides)
- [ ] Nomenclature de fichiers respectee

## LIVRAISON
- [ ] Export PDF valide et lisible
- [ ] Export web (PNG/JPG) optimise
- [ ] Fichiers deposes dans le bon dossier client
- [ ] Index du catalogue mis a jour
- [ ] Confirmation de livraison envoyee au client

---
*CL-001 - $AgentName - Version 1.0*
"@
}

function Get-Exemple-DAM([string]$AgentName) {
  return @"
# EX-001 - Exemple : Production Fiche Produit
**Agent:** @$AgentName | **Type:** DAM | **Statut:** PASS (cas nominal)

## INPUT
``````yaml
Objectif: Creer la fiche produit pour un nouveau revetement de sol
Client: Ceramiques Beaumont Inc.
Produit: Carrelage "Ardoise Noire 60x60"
Specs:
  - Format: 60x60 cm
  - Epaisseur: 9 mm
  - Finition: Mat
  - Usage: Sol interieur / Sol exterieur (gel)
  - Prix: 89.99$/m2
Visuels disponibles: 3 photos HD fournisseur
Charte: Template "Beaumont-2026"
Priorite: medium
``````

## OUTPUT ATTENDU
``````yaml
output:
  livrable: fiche_produit
  code_article: CB-SOL-ARD-60-001
  nom: Ardoise Noire 60x60
  client: Ceramiques Beaumont Inc.
  fichiers_produits:
    - CB-SOL-ARD-60-001_fiche.pdf        # Print 300DPI
    - CB-SOL-ARD-60-001_web.jpg          # Web 72DPI <500Ko
    - CB-SOL-ARD-60-001_source.psd       # Source editble
  statut_approbation: draft
  notes_production:
    - Photo principale recadree fond blanc
    - Ajout pictogramme "Gel resistant"
    - Description validee avec le client
``````

## STRUCTURE FICHE PRODUITE
- En-tete : Logo Beaumont + code article
- Photo principale (80% de la fiche)
- Nom + description courte
- Tableau de specifications
- Pictogrammes usages autorises
- Prix et disponibilite
- Pied de page : coordonnees

---
*EX-001 - $AgentName - Version 1.0*
"@
}

function Get-Instructions-GENERIC([string]$AgentName, [string]$TeamName) {
  return @"
# Instructions Internes - $AgentName
## Identite de l'Agent
Tu es **@$AgentName**, un agent specialise de l'equipe **$TeamName**.
**Ton role:** [Decrire le role principal - A completer]

## Domaine d'Expertise
[Description du domaine d'expertise et des responsabilites - A completer]

## Livrables Attendus
1. [Type de document 1]
2. [Type de document 2]
3. [Type de document 3]

## Protocole de Travail
### 1. Reception de Requete
- Analyser l'objectif principal
- Identifier le contexte et les contraintes
- Clarifier les ambiguites si necessaire

### 2. Planification
- Determiner le(s) livrable(s) approprie(s)
- Identifier les informations manquantes
- Evaluer la complexite et les risques

### 3. Execution
- Utiliser les templates appropries
- Respecter les standards de qualite
- Documenter les decisions et justifications

### 4. Livraison
- Fournir tous les livrables demandes
- Inclure les metadonnees
- Suggerer les prochaines etapes

## Format de Reponse Standard
``````yaml
output:
  status: [success/partial/failed/escalated]
  deliverables:
    - type: [Type de document]
      content: [Contenu]
  metadata:
    execution_time: [Duree]
    complexity: [low/medium/high]
    confidence: [0.0-1.0]
``````
---
*Instructions generees automatiquement - Type GENERIC - Version 1.0*
*A completer selon les besoins specifiques de l'agent*
"@
}

function Get-Runbook-GENERIC([string]$AgentName) {
  return @"
# RB-001 - Procedure Operationnelle Type
**Agent:** @$AgentName | **Type:** GENERIC

## Objectif
[Decrire l'objectif de cette procedure - A completer]

## Declencheur
- [Condition 1 qui declenche ce runbook]
- [Condition 2]

## Prerequis
- [ ] [Prerequis 1]
- [ ] [Prerequis 2]

## Etapes
### Phase 1 - Preparation
1. [Etape 1]
2. [Etape 2]

### Phase 2 - Execution
1. [Etape 1]
2. [Etape 2]

### Phase 3 - Validation
1. [Etape 1]
2. [Etape 2]

## Verification
- [ ] [Critere de succes 1]
- [ ] [Critere de succes 2]

## Rollback
[Procedure d'annulation si probleme]

---
*RB-001 - $AgentName - Version 1.0 - A completer*
"@
}

function Get-Checklist-GENERIC([string]$AgentName) {
  return @"
# CL-001 - Checklist de Validation Generique
**Agent:** @$AgentName | **Type:** GENERIC

## PRE-EXECUTION
- [ ] [Verification 1 - A personnaliser]
- [ ] [Verification 2]
- [ ] [Verification 3]

## EXECUTION
- [ ] [Point de controle 1]
- [ ] [Point de controle 2]

## POST-EXECUTION
- [ ] [Validation 1]
- [ ] [Validation 2]
- [ ] Rapport complete et envoye
- [ ] Archivage effectue

---
*CL-001 - $AgentName - Version 1.0 - A personnaliser*
"@
}

function Get-Exemple-GENERIC([string]$AgentName) {
  return @"
# EX-001 - Exemple de Reference
**Agent:** @$AgentName | **Type:** GENERIC

## INPUT
``````yaml
Objectif: [Decrire l'objectif - A completer]
Contexte: [Contexte de la requete]
Priorite: [low/medium/high/critical]
``````

## PROCESSING
[Decrire les etapes de traitement - A completer]

## OUTPUT ATTENDU
``````yaml
output:
  status: success
  livrable: [Type de livrable]
  contenu: [Description du contenu produit]
  metadata:
    complexite: medium
    confiance: 0.85
``````

## LECONS APPRISES
- [A documenter apres le premier cas reel]

---
*EX-001 - $AgentName - Version 1.0 - A completer*
"@
}

function Resolve-TypedContent([string]$AgentType, [string]$AgentName, [string]$TeamName, [string]$ContentKey) {
  switch ($AgentType) {
    "IT" {
      switch ($ContentKey) {
        "instructions" { return Get-Instructions-IT   $AgentName $TeamName }
        "runbook"      { return Get-Runbook-IT         $AgentName }
        "checklist"    { return Get-Checklist-IT       $AgentName }
        "exemple"      { return Get-Exemple-IT         $AgentName }
      }
    }
    "MSP" {
      switch ($ContentKey) {
        "instructions" { return Get-Instructions-MSP  $AgentName $TeamName }
        "runbook"      { return Get-Runbook-MSP        $AgentName }
        "checklist"    { return Get-Checklist-MSP      $AgentName }
        "exemple"      { return Get-Exemple-MSP        $AgentName }
      }
    }
    "TRAD" {
      switch ($ContentKey) {
        "instructions" { return Get-Instructions-TRAD $AgentName $TeamName }
        "runbook"      { return Get-Runbook-TRAD       $AgentName }
        "checklist"    { return Get-Checklist-TRAD     $AgentName }
        "exemple"      { return Get-Exemple-TRAD       $AgentName }
      }
    }
    "DAM" {
      switch ($ContentKey) {
        "instructions" { return Get-Instructions-DAM  $AgentName $TeamName }
        "runbook"      { return Get-Runbook-DAM        $AgentName }
        "checklist"    { return Get-Checklist-DAM      $AgentName }
        "exemple"      { return Get-Exemple-DAM        $AgentName }
      }
    }
    default {
      switch ($ContentKey) {
        "instructions" { return Get-Instructions-GENERIC $AgentName $TeamName }
        "runbook"      { return Get-Runbook-GENERIC       $AgentName }
        "checklist"    { return Get-Checklist-GENERIC     $AgentName }
        "exemple"      { return Get-Exemple-GENERIC       $AgentName }
      }
    }
  }
  return ""
}

function Ensure-AgentTemplate([string]$AgentDir, [string]$AgentType = "GENERIC") {
  Ensure-Dir $AgentDir
  $agentName = Split-Path -Path $AgentDir -Leaf
  
  $agentsFolder = Split-Path -Path $AgentDir -Parent
  $equipeGPTFolder = Split-Path -Path $agentsFolder -Parent
  $teamFolder = Split-Path -Path $equipeGPTFolder -Parent
  $teamName = Split-Path -Path $teamFolder -Leaf

  # README et manifest : toujours generiques
  $readmePath = Join-Path $AgentDir "README.md"
  Ensure-File $readmePath (Get-ReadmeTemplate $agentName $teamName)

  $manifestPath = Join-Path $AgentDir "manifest.json"
  Ensure-File $manifestPath (Get-ManifestTemplate $agentName $teamName)

  # INSTRUCTIONS : contenu specialise selon le type
  $instructionsPath = Join-Path $AgentDir "00_INSTRUCTIONS.md"
  Ensure-File $instructionsPath (Resolve-TypedContent $AgentType $agentName $teamName "instructions")

  $contractPath = Join-Path $AgentDir "01_CONTRACT.yaml"
  Ensure-File $contractPath (Get-ContractTemplate $agentName $teamName)

  $templatesDir = Join-Path $AgentDir "01_TEMPLATES"
  Ensure-Dir $templatesDir
  
  $template1Path = Join-Path $templatesDir "template_document.md"
  $template1Content = @"
# [Nom du Template]

**Agent:** @$agentName

## Sections

### 1. [Section 1]
[Contenu]

### 2. [Section 2]
[Contenu]

---

*Template genere automatiquement pour $agentName*
"@
  Ensure-File $template1Path $template1Content

  $originalPromptPath = Join-Path $AgentDir "03_ORIGINAL_PROMPT.md"
  $originalPromptContent = @"
# Prompt Original - $agentName

## Role
Agent specialise de l'equipe $teamName

## Mission
[A completer]

## Instructions
- [Instruction 1]
- [Instruction 2]

---

*Prompt de reference - Version 1.0*
"@
  Ensure-File $originalPromptPath $originalPromptContent

  $knowledgeIndexPath = Join-Path $AgentDir "04_KNOWLEDGE_INDEX.md"
  Ensure-File $knowledgeIndexPath (Get-KnowledgeIndexTemplate $agentName)

  $knowledgeDir = Join-Path $AgentDir "05_KNOWLEDGE"
  Ensure-Dir $knowledgeDir
  
  $knowledgeReadmePath = Join-Path $knowledgeDir "README.md"
  $knowledgeReadmeContent = @"
# Base de Connaissances - $agentName

## Description

Ce dossier contient les fichiers de connaissances pour $agentName.

## Contenu

A ajouter:
- Procedures internes
- Standards MSP
- Exemples
- Best practices

---

*Knowledge base - Version 1.0*
"@
  Ensure-File $knowledgeReadmePath $knowledgeReadmeContent

  # --------------------------------------------------
  # 00_REFERENCE_DATA
  # --------------------------------------------------
  $refDataDir = Join-Path $AgentDir "00_REFERENCE_DATA"
  Ensure-Dir $refDataDir
  Ensure-File (Join-Path $refDataDir "README.md") @"
# Donnees de Reference - $agentName

## Description

Ce dossier centralise toutes les **donnees de reference statiques** utilisees par $agentName pour prendre des decisions et produire ses livrables.

## Contenu type

- Grilles tarifaires et baremes
- Standards et normes sectorielles (MSP, ITIL, etc.)
- Glossaires et definitions officielles
- Matrices de roles et responsabilites (RACI)
- Parametres de configuration de reference
- Seuils, limites et valeurs par defaut

## Utilisation

Ces donnees sont **consultees en lecture seule** par l'agent.  
Toute mise a jour doit etre validee avant remplacement.

---

*Reference Data - $agentName v1.0*
"@

  # --------------------------------------------------
  # 02_RUNBOOKS — contenu specialise selon AgentType
  # --------------------------------------------------
  $runbooksDir = Join-Path $AgentDir "02_RUNBOOKS"
  Ensure-Dir $runbooksDir
  Ensure-File (Join-Path $runbooksDir "README.md") @"
# Runbooks Operationnels - $agentName

## Description

Ce dossier contient les **runbooks** de $agentName : procedures pas-a-pas pour executer les taches recurrentes de maniere reproductible et sans ambiguite.

## Structure recommandee

Chaque runbook suit le format :
- **Objectif** : Ce que la procedure accomplit
- **Declencheur** : Quand executer ce runbook
- **Prerequis** : Ce qui doit etre en place avant
- **Etapes** : Sequence detaillee d'actions
- **Verification** : Comment confirmer le succes
- **Rollback** : Comment annuler si probleme

## Runbooks prevus

- [ ] RB-001_[Tache-principale].md
- [ ] RB-002_[Tache-secondaire].md

---

*Runbooks - $agentName v1.0*
"@
  Ensure-File (Join-Path $runbooksDir "RB-001_procedure-principale.md") `
    (Resolve-TypedContent $AgentType $agentName $teamName "runbook")

  # --------------------------------------------------
  # 03_CHECKLISTS — contenu specialise selon AgentType
  # --------------------------------------------------
  $checklistsDir = Join-Path $AgentDir "03_CHECKLISTS"
  Ensure-Dir $checklistsDir
  Ensure-File (Join-Path $checklistsDir "README.md") @"
# Checklists de Validation - $agentName

## Description

Ce dossier regroupe les **checklists de controle qualite** utilisees par $agentName avant, pendant et apres la production de livrables.

## Types de checklists

- **Pre-execution** : Verification des conditions avant de demarrer
- **En-cours** : Points de controle pendant le traitement
- **Post-livraison** : Validation de la qualite du livrable final
- **Conformite** : Respect des standards et procedures MSP

## Format standard

Chaque item de checklist doit inclure :
- `[ ]` Case a cocher
- Description claire de l'element a verifier
- Critere de succes mesurable

---

*Checklists - $agentName v1.0*
"@
  Ensure-File (Join-Path $checklistsDir "CL-001_validation-principale.md") `
    (Resolve-TypedContent $AgentType $agentName $teamName "checklist")

  # --------------------------------------------------
  # 04_EXEMPLES — contenu specialise selon AgentType
  # --------------------------------------------------
  $exemplesDir = Join-Path $AgentDir "04_EXEMPLES"
  Ensure-Dir $exemplesDir
  Ensure-File (Join-Path $exemplesDir "README.md") @"
# Exemples de Reference - $agentName

## Description

Ce dossier contient des **exemples concrets** illustrant les inputs acceptes et les outputs produits par $agentName.

## Nomenclature des fichiers

```
EX-[NNN]_[type]_[description-courte].md
Exemple : EX-001_nominal_rapport-patching-mensuel.md
```

---

*Exemples - $agentName v1.0*
"@
  Ensure-File (Join-Path $exemplesDir "EX-001_cas-nominal.md") `
    (Resolve-TypedContent $AgentType $agentName $teamName "exemple")

  # --------------------------------------------------
  # 10_MEMORY
  # --------------------------------------------------
  $memoryDir = Join-Path $AgentDir "10_MEMORY"
  Ensure-Dir $memoryDir
  Ensure-File (Join-Path $memoryDir "README.md") @"
# Memoire Persistante - $agentName

## Description

Ce dossier constitue la **memoire operationnelle persistante** de $agentName. Il conserve le contexte accumule, les decisions passees et les preferences apprises pour assurer la continuite entre les sessions.

## Contenu type

- **Contexte client** : Particularites et historique par client
- **Decisions archivees** : Choix importants et leurs justifications
- **Preferences apprises** : Formats preferes, niveaux de detail, etc.
- **Incidents passes** : Problemes rencontres et resolutions appliquees
- **Etat courant** : Taches en cours, en attente ou suspendues

## Politique de gestion

- Les entrees doivent etre horodatees (YYYY-MM-DD)
- Les informations obsoletes doivent etre archivees, jamais supprimees
- La memoire est mise a jour apres chaque interaction significative

---

*Memory Store - $agentName v1.0*
"@

  # --------------------------------------------------
  # 65_TEST
  # --------------------------------------------------
  $testDir = Join-Path $AgentDir "65_TEST"
  Ensure-Dir $testDir
  Ensure-File (Join-Path $testDir "README.md") @"
# Zone de Test et Validation - $agentName

## Description

Ce dossier est la **zone de QA et de validation** de $agentName. Il contient les scenarios de test, les resultats d'execution et les rapports de conformite.

## Structure

- **Scenarios/** : Cas de test documentes avec inputs et outputs attendus
- **Resultats/** : Sorties brutes des sessions de test
- **Rapports/** : Analyses comparatives et bilans de qualite

## Types de tests

- **Tests unitaires** : Validation d'une capacite isolee
- **Tests d'integration** : Interaction avec d'autres agents ou systemes
- **Tests de regression** : Verification apres modification du prompt
- **Tests de charge** : Comportement avec des inputs volumineux

## Statuts de test

| Statut | Description |
|--------|-------------|
| PASS   | Resultat conforme aux attentes |
| FAIL   | Ecart identifie - correction requise |
| WIP    | Test en cours de developpement |

---

*Test Zone - $agentName v1.0*
"@
}

function Read-AgentsFromUser() {
  Write-Host ""
  Write-Host "Entre les agents (1 par ligne, vide = terminer):" -ForegroundColor Cyan
  $agents = New-Object System.Collections.Generic.List[string]
  while ($true) {
    $line = Read-Host "Agent"
    if ([string]::IsNullOrWhiteSpace($line)) { break }
    $parts = $line.Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
    foreach ($p in $parts) { $agents.Add($p) }
  }
  return @($agents | Sort-Object -Unique)
}

function Show-MainMenu() {
  Clear-Host
  Write-Host "=============================================" -ForegroundColor DarkGray
  Write-Host " GPT Enterprise - Team Manager v2.6 " -ForegroundColor Green
  Write-Host " Structure Enrichie + Bundles GPT Ready " -ForegroundColor Cyan
  Write-Host "=============================================" -ForegroundColor DarkGray
  Write-Host ""
  Write-Host "1) Ajouter une nouvelle equipe + agents"
  Write-Host "2) Ajouter des agents a une equipe existante"
  Write-Host "3) Lister equipes / agents (registry)"
  Write-Host "4) Quitter"
  Write-Host ""
  Write-Host ("Chemin: " + $Root) -ForegroundColor DarkGray
  Write-Host ""
}

function List-Registry($reg) {
  Write-Host ""
  Write-Host ("Registry: " + $RegistryPath) -ForegroundColor DarkGray
  Write-Host ("Derniere MAJ: " + $reg.updated_at) -ForegroundColor DarkGray
  Write-Host ("Version: " + $reg.version) -ForegroundColor DarkGray
  Write-Host ""

  $teamNames = @(Get-ObjectPropertyNames $reg.teams | Sort-Object)
  if ($teamNames.Count -eq 0) {
    Write-Host "Aucune equipe enregistree." -ForegroundColor Yellow
    return
  }

  foreach ($t in $teamNames) {
    $agents = @($reg.teams.$t.agents)
    $destLabel = $reg.teams.$t.destination
    if (-not $destLabel) { $destLabel = "?" }
    Write-Host ("- {0}  [{1}]  ({2} agents)" -f $t, $destLabel, $agents.Count) -ForegroundColor Cyan
    foreach ($a in ($agents | Sort-Object)) {
      Write-Host "    - $a"
    }
  }
}

function Add-TeamAndAgents($reg) {
  Write-Host ""
  $teamRaw = Read-Host "Nom du dossier equipe (ex: IT-Operations)"
  $teamFolder = Safe-FolderName $teamRaw

  $existingTeams = @(Get-ObjectPropertyNames $reg.teams)
  if ($existingTeams -contains $teamFolder) {
    Write-Host "ATTENTION: L'equipe existe deja. Utilise l'option 2." -ForegroundColor Yellow
    return
  }

  # --- Choix FACTORY ou PRODUCTS ---
  $dest = Ask-Destination
  # ----------------------------------

  $agents = Read-AgentsFromUser
  if ($agents.Count -eq 0) {
    Write-Host "ATTENTION: Aucun agent saisi. Annule." -ForegroundColor Yellow
    return
  }

  Write-Host ""
  Write-Host "Creation de la structure equipe..." -ForegroundColor Yellow
  Ensure-RootScaffold
  $agentsRoot = Ensure-TeamScaffold $teamFolder $dest.Root

  Write-Host "Creation des bundles agents..." -ForegroundColor Yellow
  $sanitizedAgents = @()
  foreach ($aRaw in $agents) {
    $a = Safe-FolderName $aRaw
    $sanitizedAgents += $a
    $agentDir = Join-Path $agentsRoot $a
    Write-Host ""
    Write-Host "  -> Bundle: $a" -ForegroundColor Gray
    $detectedType = Detect-AgentType $a
    $confirmedType = Confirm-AgentType $detectedType $a
    Write-Host ("  -> Type confirme : [" + $confirmedType + "]") -ForegroundColor Cyan
    Ensure-AgentTemplate $agentDir $confirmedType
  }
  $sanitizedAgents = $sanitizedAgents | Sort-Object -Unique

  # Destination sauvegardee dans le registry
  $teamObj = [PSCustomObject]@{
    created_at  = (Get-Date).ToString("s")
    destination = $dest.Label
    agents      = $sanitizedAgents
  }
  $reg.teams | Add-Member -NotePropertyName $teamFolder -NotePropertyValue $teamObj -Force
  Save-Registry $reg

  Write-Host ""
  Write-Host "OK - Equipe creee : $teamFolder" -ForegroundColor Green
  Write-Host "OK - Destination  : [$($dest.Label)]  $($dest.Root)\$teamFolder" -ForegroundColor Green
  Write-Host "OK - Structure    : 17 dossiers par agent" -ForegroundColor Green
  Write-Host "OK - Agents crees : $($sanitizedAgents.Count)" -ForegroundColor Green
  Write-Host ""
  Write-Host "Bundles GPT crees avec:" -ForegroundColor Cyan
  Write-Host "   - README.md              - Guide d'installation" -ForegroundColor Gray
  Write-Host "   - manifest.json          - Metadonnees agent" -ForegroundColor Gray
  Write-Host "   - 00_INSTRUCTIONS.md     - Instructions completes" -ForegroundColor Gray
  Write-Host "   - 01_CONTRACT.yaml       - Contrat I/O enrichi" -ForegroundColor Gray
  Write-Host "   - 03_ORIGINAL_PROMPT.md  - Prompt de reference" -ForegroundColor Gray
  Write-Host "   - 04_KNOWLEDGE_INDEX.md  - Index connaissances" -ForegroundColor Gray
  Write-Host "   - 00_REFERENCE_DATA/     - Donnees de reference statiques" -ForegroundColor Gray
  Write-Host "   - 01_TEMPLATES/          - Templates de documents" -ForegroundColor Gray
  Write-Host "   - 02_RUNBOOKS/           - Procedures pas-a-pas operationnelles" -ForegroundColor Gray
  Write-Host "   - 03_CHECKLISTS/         - Checklists de controle qualite" -ForegroundColor Gray
  Write-Host "   - 04_EXEMPLES/           - Exemples d'inputs/outputs de reference" -ForegroundColor Gray
  Write-Host "   - 05_KNOWLEDGE/          - Base de connaissances" -ForegroundColor Gray
  Write-Host "   - 10_MEMORY/             - Memoire persistante de l'agent" -ForegroundColor Gray
  Write-Host "   - 65_TEST/               - Scenarios et rapports de test QA" -ForegroundColor Gray
  Write-Host ""
  Write-Host "Chemin agents: $agentsRoot" -ForegroundColor DarkGray
}

function Add-AgentsToExistingTeam($reg) {
  $teamNames = @(Get-ObjectPropertyNames $reg.teams | Sort-Object)
  if ($teamNames.Count -eq 0) {
    Write-Host "ATTENTION: Aucune equipe. Cree d'abord une equipe (option 1)." -ForegroundColor Yellow
    return
  }

  Write-Host ""
  Write-Host "Equipes existantes:" -ForegroundColor Cyan
  for ($i=0; $i -lt $teamNames.Count; $i++) {
    # Afficher la destination si connue dans le registry
    $destLabel = $reg.teams.($teamNames[$i]).destination
    if (-not $destLabel) { $destLabel = "?" }
    Write-Host ("{0}) {1}  [{2}]" -f ($i+1), $teamNames[$i], $destLabel)
  }

  $pick = Read-Host "Choisis un numero"
  $num = 0
  if (-not [int]::TryParse($pick, [ref]$num)) { 
    Write-Host "Entree invalide." -ForegroundColor Yellow
    return 
  }
  $idx = $num - 1
  if ($idx -lt 0 -or $idx -ge $teamNames.Count) { 
    Write-Host "Numero invalide." -ForegroundColor Yellow
    return 
  }

  $teamFolder = $teamNames[$idx]
  $existingAgents = @($reg.teams.$teamFolder.agents)

  # Recuperer la destination depuis le registry
  $storedDest = $reg.teams.$teamFolder.destination
  if ($storedDest -eq "FACTORY") {
    $destRoot = $script:FactoryTeamsRoot
  } elseif ($storedDest -eq "PRODUCTS") {
    $destRoot = $script:ProductsTeamsRoot
  } else {
    # Equipe sans destination enregistree : demander
    Write-Host "  Destination non trouvee dans le registry pour cette equipe." -ForegroundColor Yellow
    $dest = Ask-Destination
    $destRoot = $dest.Root
    $storedDest = $dest.Label
    # Mettre a jour le registry
    $reg.teams.$teamFolder | Add-Member -NotePropertyName destination -NotePropertyValue $storedDest -Force
  }

  $newAgents = Read-AgentsFromUser
  if ($newAgents.Count -eq 0) { 
    Write-Host "ATTENTION: Aucun agent saisi. Annule." -ForegroundColor Yellow
    return 
  }

  $merged = @($existingAgents + $newAgents) | ForEach-Object { Safe-FolderName $_ } | Sort-Object -Unique

  Write-Host ""
  Write-Host "Creation des bundles agents..." -ForegroundColor Yellow
  Ensure-RootScaffold
  $agentsRoot = Ensure-TeamScaffold $teamFolder $destRoot

  foreach ($a in $merged) {
    if ($existingAgents -notcontains $a) {
      Write-Host ""
      Write-Host ("  -> Nouveau bundle: " + $a) -ForegroundColor Gray
      $detectedType = Detect-AgentType $a
      $confirmedType = Confirm-AgentType $detectedType $a
      Write-Host ("  -> Type confirme : [" + $confirmedType + "]") -ForegroundColor Cyan
    } else {
      $confirmedType = "GENERIC"
    }
    $agentDir = Join-Path $agentsRoot $a
    Ensure-AgentTemplate $agentDir $confirmedType
  }

  $reg.teams.$teamFolder.agents = $merged
  Save-Registry $reg

  Write-Host ""
  Write-Host "OK - Equipe mise a jour : $teamFolder  [$storedDest]" -ForegroundColor Green
  Write-Host "OK - Total agents       : $($merged.Count)" -ForegroundColor Green
  Write-Host "OK - Nouveaux agents    : $(($merged | Where-Object { $existingAgents -notcontains $_ }).Count)" -ForegroundColor Green
  Write-Host "OK - Chemin agents      : $agentsRoot" -ForegroundColor DarkGray
}

# ==========================================
# BOOT
# ==========================================
Write-Host "Initialisation du systeme..." -ForegroundColor Yellow
Ensure-RootScaffold
$registry = Load-Registry
Write-Host "OK - Systeme initialise  (v2.6)" -ForegroundColor Green
Start-Sleep -Milliseconds 500

# ==========================================
# BOUCLE PRINCIPALE
# ==========================================
$continueLoop = $true
while ($continueLoop) {
  Show-MainMenu
  $choice = Read-Host "Choix"
  switch ($choice) {
    "1" {
      Add-TeamAndAgents $registry
      Read-Host "`nEntree pour continuer" | Out-Null
    }
    "2" {
      Add-AgentsToExistingTeam $registry
      Read-Host "`nEntree pour continuer" | Out-Null
    }
    "3" {
      List-Registry $registry
      Read-Host "`nEntree pour continuer" | Out-Null
    }
    "4" {
      $continueLoop = $false
    }
    default {
      Write-Host "Choix invalide." -ForegroundColor Yellow
      Start-Sleep -Milliseconds 700
    }
  }
}

Write-Host ""
Write-Host "GPT-TeamManager v2.6 - Session terminee" -ForegroundColor Green
Write-Host "Bundles prets pour GPT Editor!" -ForegroundColor Cyan
Write-Host ""
