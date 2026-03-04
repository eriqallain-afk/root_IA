# Index des policies

Ce fichier liste toutes les policies applicables dans ce dépôt. Les agents doivent les respecter en production.

## Liste
- **SCHEMAS_REGISTRY** — `50_POLICIES/GOVERNANCE/SCHEMAS_REGISTRY.yaml`
- **SOURCE_ATTRIBUTION** — `50_POLICIES/SOURCE_ATTRIBUTION.yaml`
- `50_POLICIES/SOURCE_ATTRIBUTION.md` — Generated: 2025-12-28T22:00:54Z
- `50_POLICIES/SOURCE_ATTRIBUTION.yaml` — Fichier de configuration (YAML) associé.
- `50_POLICIES/naming.md` — - team_id: TEAM__NAME
- `50_POLICIES/ops/incident_severity.md` — - P1: panne totale / données à risque / sécurité
- `50_POLICIES/ops/logging_schema.md` — Chaque exécution produit:
- `50_POLICIES/ops/sla.md` — - P1 (critique): réponse < 15 min, mitigation < 60 min
- `50_POLICIES/output_format.md` — Tous les agents répondent en YAML strict (voir prompt.md).
- `50_POLICIES/safety_iasm.md` — Cabinet IA = psychoéducatif / coaching / support.

## Règles d’or (résumé)
- Toute équipe (META/IAHQ/OPS/IT/...) doit respecter ces policies dans les sorties, playbooks et prompts.
- Si une policy change, relancer `scripts/rebuild_indexes.ps1` pour mettre à jour les index/bundles.
- Respecter le format de sortie attendu (`50_POLICIES/output_format.md`).
- Respecter la convention de nommage (`50_POLICIES/naming.md`).
- Attribution des sources si navigation web / données externes (`50_POLICIES/SOURCE_ATTRIBUTION.*`).
- Pour IASM (santé mentale), appliquer `50_POLICIES/safety_iasm.md`.
- Pour OPS, appliquer aussi `50_POLICIES/ops/*` (SLA, logs, sévérité).