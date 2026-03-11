# EDU-Orchestrator_CCQ

Orchestrateur de correction CCQ : assemble extraction/transcription + évaluation + contrôles qualité.

## Dépendances
- EDU-Extractor_CCQ (extraction/transcription)
- EDU-Reflexions_CCQ (évaluation CCQ — barème verrouillé)
- META-SuperviseurInvisible (audit)
- HUB-AgentMO2-DeputyOrchestrator (QA contrat)
- OPS-DossierIA (archivage via playbook)

## Intégration
- Playbook : `EDU_CCQ_EXTRACT_EVAL_V1`
- Routage : `hub_routing.yaml` (intents CCQ / education / evaluation / correction)
