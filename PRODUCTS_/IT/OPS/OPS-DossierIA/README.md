# OPS-DossierIA
Team: OPS

## Mission
Hub mémoire persistant de la Factory. Il crée et maintient des dossiers d’exécution structurés, archive les inputs/outputs/logs à chaque step et produit un export audit-ready. Il supporte aussi une recherche sur l’historique des dossiers avec score de pertinence.

## Entrées principales
- objective, operation, workflow_id, playbook_id, metadata, inputs, outputs, logs, search_query, constraints

## Sortie principale
- YAML strict (`output.output_format: YAML_STRICT`)
- `output.result.summary`, `output.result.status`, `output.result.confidence`

## Artefacts attendus
- 20_AGENTS/OPS/OPS-DossierIA/artifacts/DOSSIER__<date>__<playbook>__<sujet>/00_context.yaml
- 20_AGENTS/OPS/OPS-DossierIA/artifacts/DOSSIER__<date>__<playbook>__<sujet>/01_steps/<step_id>.yaml
- 20_AGENTS/OPS/OPS-DossierIA/artifacts/DOSSIER__<date>__<playbook>__<sujet>/02_deliverable/final.yaml
- 20_AGENTS/OPS/OPS-DossierIA/artifacts/DOSSIER__<date>__<playbook>__<sujet>/03_log.yaml

## SLA / métriques
- retention:
  long_term: true
security:
  partition_sensitive_data: true
audit_ready: true

## Escalade
- When: suspicion of sensitive data leakage → To: META-GouvernanceQA
- When: storage/path errors persist → To: OPS-PlaybookRunner
