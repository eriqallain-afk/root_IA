# Catalogue — Playbooks par équipe

_Généré le 2026-01-17T21:19:45Z_

## Lecture
- Chaque playbook correspond à une **tâche** (ou un flux) exécutable.
- Les steps pointent vers des **actor_id** existants dans `agents_index.yaml`.

## TEAM__DAM — DAM

- `DAM_PROJECT_CONTROL` — Projet DAM : conformité/budget/planning/inspection + synthèse
- `DAM_BUDGET_FORECAST_V1` — Budget & forecast (analyse -> projection -> risques -> synthèse)
- `DAM_COMPLIANCE_AUDIT_V1` — Audit conformité (conformité -> légal -> recommandations -> validation)
- `DAM_PLANNING_MASTER_V1` — Planification chantier/projet (planning -> ressources -> jalons -> com)
- `DAM_PROCUREMENT_PACKAGE_V1` — Pack achat (besoin -> sourcing -> légal -> conformité -> communication)
- `DAM_SITE_INSPECTION_REPORT_V1` — Inspection site (checklist -> constats -> preuves -> rapport)
- `DAM_VENDOR_SATISFACTION_LOOP_V1` — Boucle satisfaction (feedback -> analyse -> actions -> communication)

## TEAM__ESPL — ESPL

- `ESPL_PUBLISH_PACK_V1` — Pack publication (titre -> description -> hooks -> check conformité)
- `ESPL_SHOW_RESEARCH_V1` — Recherche émission (sujets -> sources -> points clés -> angles)

## TEAM__HUB — HUB

- `HUB_AVATAR_ASSETS_V1` — Création / adaptation d'assets d'avatar (brief -> itérations -> pack)
- `HUB_COACH_GPT_TEAMS_V1` — Coaching GPT Teams (stratégie -> mapping rôles -> workflow -> handoff build)
- `HUB_CONCIERGE_INTAKE_V1` — Concierge HUB : qualification demande + normalisation + handoff vers OPS Router
- `HUB_PROMPT_OPTIMIZATION_V1` — Optimisation de prompts (diagnostic -> variantes -> tests -> validation risques)

## TEAM__IAHQ — IAHQ

- `IAHQ_FRONTDOOR` — Front door business : cadrage IAHQ -> mapping process -> route -> exécute -> archive
- `IAHQ_BUSINESS_CASE_V1` — Business case (hypothèses -> ROI -> risques -> synthèse)
- `IAHQ_OFFER_DESIGN_V1` — Design d'offre (positionnement -> processus -> solution -> packaging)
- `IAHQ_PROCESS_MAPPING_V1` — Cartographie process (as-is -> to-be -> KPI -> risques)
- `IAHQ_TECH_BLUEPRINT_V1` — Blueprint technique IA (archi -> intégrations -> gouvernance -> plan build)

## TEAM__IASM — IASM

- `IASM_SESSION` — Cabinet IA : intake -> risques -> analyse -> plan -> validation
- `IASM_ADDICTIONS_SUPPORT_V1` — Support addictions/compulsions (analyse -> plan -> suivi)
- `IASM_ANGER_MANAGEMENT_V1` — Gestion de la colère (déclencheurs -> plan -> exercices)
- `IASM_EMOTION_REGULATION_V1` — Régulation émotionnelle (diagnostic -> outils TCC -> support)
- `IASM_RELATIONSHIP_COUNSELING_V1` — Conseil relationnel (schémas -> objectifs -> plan couple/famille)
- `IASM_SAFETY_TRIAGE_V1` — Triage sécurité (risques -> recommandations -> escalade)

## TEAM__IT — IT

- `IT_MSP_TICKET_TO_KB` — Ticket MSP -> diagnostic -> communication -> knowledge
- `IT_ASSET_LIFECYCLE_V1` — Gestion du cycle de vie des assets (inventaire -> standard -> plan renouvellement)
- `IT_BACKUP_DR_TEST_V1` — Test Backup/DR (plan -> exécution -> preuves -> rapport)
- `IT_CLOUD_ARCHITECTURE_V1` — Architecture cloud (requirements -> design -> sécurité -> runbook)
- `IT_DEVOPS_PIPELINE_V1` — Pipeline DevOps (CI/CD -> IaC -> observabilité -> rollback)
- `IT_INCIDENT_COMMAND_V1` — Incident command (triage NOC -> diagnostic -> plan -> report)
- `IT_NETWORK_DIAGNOSTIC_V1` — Diagnostic réseau (symptômes -> hypothèses -> tests -> correctifs)
- `IT_SECURITY_ALERT_TRIAGE_V1` — Alerte sécurité (analyse -> containment -> communication -> KB)

## TEAM__META — META

- `META_GOVERNANCE_AUDIT_V1` — Audit conformité & risques (policies -> gaps -> recommandations)
- `META_PLAYBOOK_BUILD_V1` — Construction d'un playbook (spec -> wiring -> runbook -> validation)
- `META_PROMPT_ARCHITECTURE_V1` — Architecture de prompts (intent -> contrat -> prompt -> tests)

## TEAM__NEA — NEA

- `NEA_MACHINE_LIVRE_V1` — NEA : cadrage -> structure -> patterns -> rédaction -> imagerie -> archivage -> dossier
- `NEA_BOOK_OUTLINE_V1` — Plan de livre (mapping -> outline -> validation -> archive)
- `NEA_EDITING_QA_V1` — Relecture & QA (cohérence -> style -> corrections -> archivage)
- `NEA_ILLUSTRATION_BRIEF_V1` — Brief illustrations (intent -> style -> prompts -> pack)
- `NEA_PATTERNS_COUNSEL_V1` — Conseil patterns (collecte -> patterns -> recommandations)

## TEAM__OPS — OPS

- `OPS_POSTMORTEM_AUDIT_V1` — Post-mortem / audit d'exécution : analyse, risques, actions correctives
- `OPS_RUN_PLAYBOOK_V1` — Exécution standard d'un playbook avec journalisation et archivage

## TEAM__PLR — PLR

- `PLR_EPISODE_PLAN_V1` — Plan d'épisode (angle -> plan -> punchlines -> structure)
- `PLR_SHOW_NOTES_PACK_V1` — Show notes (résumé -> titres -> timestamps -> pack diffusion)

## TEAM__TRAD — TRAD

- `TRAD_WATCH_TO_REPORT` — Veille -> corrélation -> rapport
- `TRAD_CRYPTO_THESIS_V1` — Thèse crypto (stratégie -> modèles -> corrélations -> note)
- `TRAD_CYBER_THREAT_DIGEST_V1` — Digest cyber (veille -> triage -> synthèse -> recommandations)
- `TRAD_INTEL_BRIEF_V1` — Brief intel (collecte -> validation -> brief exécutif)
- `TRAD_MARKET_DIGEST_V1` — Digest marchés (veille -> analyse -> corrélation -> report)
- `TRAD_SOCIO_SENTIMENT_REPORT_V1` — Sentiment social (radar -> psycho -> synthèse -> report)

