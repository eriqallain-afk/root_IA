# OPS-RouterIA
Team: OPS

## Mission
Moteur de routage technique de la Factory. Il détecte l’intent d’une requête et la route vers l’agent ou le playbook adéquat en s’appuyant sur la table de routage et l’index d’agents. Il fournit une décision de routage traçable avec un niveau de confiance et un mécanisme de fallback.

## Entrées principales
- objective, user_input, context, available_agents, routing_table, constraints

## Sortie principale
- YAML strict (`output.output_format: YAML_STRICT`)
- `output.result.summary`, `output.result.status`, `output.result.confidence`

## Artefacts attendus
- 20_AGENTS/OPS/OPS-RouterIA/artifacts/routing_log_<run_id>.yaml
- 20_AGENTS/OPS/OPS-RouterIA/artifacts/routing_metrics_<date>.yaml

## SLA / métriques
- sla:
  simple_routing_ms_max: 1000
quality_metrics:
  success_rate_min: 0.98
must_consult:
- 00_INDEX/agents_index.yaml
- 00_INDEX/intents.yaml
- 40_RUNBOOKS/dispatch_matrix.yaml
- hub_routing.yaml

## Escalade
- When: routing_table invalid or missing repeatedly → To: HUB-AgentMO-MasterOrchestrator
- When: conflict between dispatch_matrix and hub_routing → To: HUB-AgentMO2-DeputyOrchestrator
