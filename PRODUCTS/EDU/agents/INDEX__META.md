# INDEX — META (usine à équipes)

## Mission
META conçoit et produit des équipes/agents/playbooks **compatibles root_IA** (conventions + policies + schemas), puis prépare un package d’intégration.

## À lire / uploader (références)
### Source de vérité (CORE)
- `90_KNOWLEDGE/CONTEXT__CORE.md`

### Standards & validation
- Schemas : `SCHEMAS/*.schema.json`
- Policies : `50_POLICIES/POLICIES__INDEX.md`
- Naming : `50_POLICIES/naming.md`
- Format : `50_POLICIES/output_format.md`

### Fabrication
- Template agent : `90_KNOWLEDGE/TEMPLATES/TEMPLATE__AGENT.md`
- Template playbook : `90_KNOWLEDGE/TEMPLATES/TEMPLATE__PLAYBOOK.md`
- Runbook create team : `40_RUNBOOKS/RUNBOOKS_MD/RUNBOOK__CREATE_TEAM.md`
- Runbook create playbook : `40_RUNBOOKS/RUNBOOKS_MD/RUNBOOK__CREATE_PLAYBOOK.md`
- Checklist review prompts : `40_RUNBOOKS/RUNBOOKS_MD/RUNBOOK__PROMPT_REVIEW_CHECKLIST.md`

### Wiring
- Playbooks : `40_RUNBOOKS/playbooks.yaml`
- Routage : `80_MACHINES/hub_routing.yaml`
- Teams : `10_TEAMS/teams.yaml`
- Agents : `20_AGENTS/**/agent.yaml`

## Livrables attendus
- Nouveaux agents (dossiers complets + contracts)
- Playbooks (définis + documentés)
- Routage mis à jour (intents → acteurs)
- Pack de notes d’intégration (risques, dépendances, tests)

## Definition of Done (META)
- Schémas valides, nommage conforme
- Prompts revus (checklist OK)
- Validations : schemas + no_fake_citations + validate_root_IA OK

## Module EDU — CCQ (pipeline)
- Agents : `EDU-Extractor_CCQ` → `EDU-Reflexions_CCQ` → `EDU-Orchestrator_CCQ` (alias `@EDU-Orchestreur-CCQ`)
- Playbook : `EDU_CCQ_EXTRACT_EVAL_V1` (voir `playbooks.yaml`)
- Routage : intents CCQ/éducation/évaluation/extraction → `EDU_CCQ_EXTRACT_EVAL_V1` (voir `hub_routing.yaml`)
