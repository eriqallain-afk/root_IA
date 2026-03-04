# Bundle META — Contrats enrichis (root_IA)

**Date de mise à niveau** : 2026-02-07  
**Équipe** : TEAM__META  
**Objectif** : remplacer les contrats génériques par des `contract.yaml` **enrichis** et **standardisés** (YAML strict), en s’appuyant sur les briefs + fichiers internes du bundle.

## ✅ Standard de contrat appliqué (schema_version: 1.1)

Chaque `contract.yaml` inclut :
- `description` (2–3 phrases), `mission`, `responsibilities`
- `input` structuré (champs de base + entrées spécifiques agent)
- `output` (YAML_STRICT) avec :
  - `result.summary`, `result.status`, `result.confidence`
  - champs dédiés au livrable principal (ex. `meta_plan`, `requirements_spec`, `catalogue_roles`, `audit_report`, etc.)
  - `artifacts`, `next_actions`, `log` (decisions/risks/assumptions + `quality_score`)
- `artifacts` (fichiers générés, paths conventionnés)
- `constraints`, `metrics`, `success_criteria`, `guardrails`, `escalation`
- `references.consulted_files` + `references.related_agents`

## 🧩 Agents inclus et statut

| agent_id | status | replaced_by (si deprecated) |
|---|---|---|
| META-AgentProductFactory | active |  |
| META-AnalysteBesoinsEquipes | active |  |
| META-ArchitecteChoix | active |  |
| META-CartographeRoles | active |  |
| META-GouvernanceEtRisques | deprecated | META-GouvernanceQA |
| META-GouvernanceQA | active |  |
| META-Opromptimizer | deprecated | META-PromptMaster |
| META-OrchestrateurCentral | active |  |
| META-Pedagogie | active |  |
| META-PlaybookBuilder | active |  |
| META-PromptArchitectEquipes | deprecated | META-PromptMaster |
| META-PromptMaster | active |  |
| META-Redaction | active |  |
| META-ReversePrompt | active |  |
| META-Concierge  | active |  |
| META-SuperviseurInvisible | deprecated | META-GouvernanceQA |
| META-VisionCreative | active |  |
| META-WorkflowDesignerEquipes | active |  |


## 🧯 Agents dépréciés (à rerouter)

Les agents ci-dessous sont **dépréciés** dans `agent.yaml` et disposent d’un bloc `deprecation` dans leur contrat :

- META-Opromptimizer → remplacé par **META-PromptMaster** (optimisation intégrée)
- META-PromptArchitectEquipes → remplacé par **META-PromptMaster**
- META-SuperviseurInvisible → remplacé par **META-GouvernanceQA**
- META-GouvernanceEtRisques → remplacé par **META-GouvernanceQA**

## 📌 Note sur les chemins d’artefacts

Les chemins sont exprimés avec la racine : `Mon Drive/EA_IA/root_IA`  
(adaptable si ton dépôt local utilise une autre racine).

