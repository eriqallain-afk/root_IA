# NAMING & IDs — Conventions Registry (IA-factory)

## 1) Conventions de fichiers
- TEAM : REGISTRY/10_TEAMS/TEAM__<slug>.yaml
- AGENT : REGISTRY/20_AGENTS/AGENT__<slug>.yaml (optionnel si agent inline dans TEAM)
- IFACE : REGISTRY/30_INTERFACES/IFACE__<slug>.yaml
- POLICIES : REGISTRY/50_POLICIES/policy__<name>.md
- RUNBOOKS : REGISTRY/40_RUNBOOKS/RUNBOOK__<name>.md
- IP : REGISTRY/70_INTEGRATION_PACKAGES/IP__<slug>.md

## 2) Champs standard YAML
Pour TEAM/IFACE :
- schema_version: "1.0"
- kind: "team" ou "interface"
- id: "…"

## 3) IDs (stables, jamais renommés)
### Teams
Format : TEAM-<CODE>
Exemples :
- TEAM-IAHQ
- TEAM-META
- TEAM-IT
- TEAM-NEA
- TEAM-TRAD
- TEAM-CAB-IA
- TEAM-DAM

### Orchestrateurs de domaine
Format : ORCH-<CODE>
Exemples :
- ORCH-IT (nom GPT : @IT-OrchestratorMSP)
- ORCH-DAM (nom GPT : @DAM-Orchestrateur)
- ORCH-NEA, ORCH-META, ORCH-TRAD, ORCH-CAB-IA

### Control plane
- AGENT-MO
- AGENT-MO2

### Agents internes d’une équipe (recommandé)
Format : AGENT-<TEAMCODE>-<ROLE>
Exemples (TEAM-IT) :
- AGENT-IT-SUPPORT
- AGENT-IT-SEC
- AGENT-IT-INFRA
- AGENT-IT-CLOUD
- etc.

### Interfaces
Format : IFACE-<SRC>-TO-<DST>
Exemples :
- IFACE-ALL-TO-IT
- IFACE-IT-TO-ALL
- IFACE-ALL-TO-DAM
- IFACE-DAM-TO-ALL

### Capabilities
Format : CAP-<NAME>
Exemples :
- CAP-IT
- CAP-GPT-FACTORY
- CAP-EDITORIAL
- CAP-DAM

## 4) Règle centrale (évite les corrections infinies)
- Dans les TEAM/IFACE on référence des IDs (ORCH-IT, AGENT-IT-SEC…).
- Le mapping “ID → nom GPT réel” vit dans : REGISTRY/00_INDEX/agents_index.yaml

## 5) Versioning
- version: "MAJOR.MINOR.PATCH"
  - MAJOR : breaking change (ex: interface/fields obligatoires changent)
  - MINOR : ajout compatible
  - PATCH : correction sans impact

## 6) Slugs
- minuscules
- tirets "-"
- pas d’accents
Ex : team__design-annie-morneau.yaml
