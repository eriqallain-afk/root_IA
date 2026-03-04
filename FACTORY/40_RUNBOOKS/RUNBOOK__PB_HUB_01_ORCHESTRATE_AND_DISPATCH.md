# RUNBOOK — PB_HUB_01_ORCHESTRATE_AND_DISPATCH

**Version** : 1.0.0  
**Équipe** : TEAM__HUB  
**Playbook** : `30_PLAYBOOKS/PB_HUB_01_ORCHESTRATE_AND_DISPATCH.yaml`  
**SLA** : 30 minutes  
**Mise à jour** : 2026-02-26

---

## Objectif

Playbook d'entrée universel HUB. Prendre toute requête utilisateur, la cadrer, détecter l'intent, router vers le bon agent/équipe, et compiler le résultat final.

---

## Prérequis

| Élément | Requis | Description |
|---------|--------|-------------|
| Agents actifs | ✅ Obligatoire | HUB-Router, HUB-Concierge, HUB-AgentMO, HUB-AgentMO2, OPS-DossierIA |
| `00_INDEX/agents_index.yaml` | ✅ Obligatoire | Index à jour |
| `40_RUNBOOKS/hub_routing.yaml` | ✅ Obligatoire | Table de routage à jour |
| `00_INDEX/intents.yaml` | ✅ Obligatoire | Liste des intents reconnus |
| `user_input` | ✅ Obligatoire | Requête de l'utilisateur (texte libre ou YAML) |
| `context` | ⚪ Optionnel | Contexte additionnel (session, historique) |

---

## Étapes détaillées

### Step 1 — Intake & Routing (`HUB-Router`)

**Acteur** : `HUB-Router`  
**Durée estimée** : < 2 secondes

**Input** :
- `user_input` : requête brute de l'utilisateur
- `context` : contexte session (optionnel)
- `routing_table` : `40_RUNBOOKS/hub_routing.yaml`
- `available_agents` : `00_INDEX/agents_index.yaml`

**Action** :
1. Extraire les indices d'intent depuis `user_input`.
2. Comparer aux règles `match_any_intents` de la routing table.
3. Retourner `routing_decision` avec `confidence_level` (high/medium/low).
4. Si confiance = low → déclencher Step 2 (qualification).
5. Si aucun match → fallback vers `HUB-Concierge`.

**Output attendu** :
```yaml
routing_decision:
  detected_intent: <intent_id>
  confidence: high|medium|low
  target_agent: <agent_id>
  target_playbook: <playbook_id>
  context_forwarded:
    original_request: <texte>
    extracted_params: {}
  fallback: HUB-Concierge
```

**Contrôle qualité** : `routing_decision.confidence` doit être `medium` ou `high` pour passer au Step 3.

**Si échec** : Escalade vers `HUB-Concierge` (Step 2).

---

### Step 2 — Qualification (conditionnel) (`HUB-Concierge`)

**Acteur** : `HUB-Concierge`  
**Déclenchement** : seulement si `routing_decision.confidence == low`  
**Durée estimée** : 1-5 minutes (interaction utilisateur)

**Input** :
- `routing_decision` du Step 1
- `user_input` original

**Action** :
1. Accueillir l'utilisateur avec un ton chaleureux mais efficace.
2. Poser AU MAXIMUM 3 questions ciblées pour qualifier le besoin.
3. Proposer les 3 cas d'usage les plus courants si l'utilisateur est perdu.
4. Produire un `qualified_request` structuré.

**Output attendu** :
```yaml
qualified_request:
  user_need: "<besoin reformulé>"
  suggested_team: <TEAM_ID>
  suggested_playbook: <playbook_id>
  brief: "<contexte pour l'agent cible>"
```

**Contrôle qualité** : `qualified_request.user_need` et `suggested_team` doivent être définis.

---

### Step 3 — Orchestration (`HUB-AgentMO-MasterOrchestrator`)

**Acteur** : `HUB-AgentMO-MasterOrchestrator`  
**Durée estimée** : 5-30 secondes selon complexité

**Input** :
- `routing_decision` du Step 1
- `qualified_request` du Step 2 (si applicable)
- `user_input` original
- `context` additionnel

**Action** :
1. INTAKE : reformuler l'objectif, lister contraintes, définir livrables + DoD.
2. MAPPING : identifier l'intent principal, choisir Machine ou séquence d'agents.
3. DISPATCH : plan d'exécution numéroté avec acteurs, inputs/outputs, contrôles.
4. GOUVERNANCE : appliquer policies, détecter risques, proposer garde-fous.
5. Calculer `quality_score` — si < 9 → déclencher Step 4 (QA).

**Output attendu** :
```yaml
result:
  summary: "<résumé>"
  status: ok|partial|needs_info|error
  confidence: 0.0-1.0
  routing_plan: {...}
artifacts:
  - type: yaml
    path: orchestration/plan_<workflow_id>.yaml
log:
  quality_score: 0-10
  decisions: [...]
  risks: [...]
```

**Contrôle qualité** : `log.quality_score >= 9` ET `result.status != error`.

**Si échec** : Escalade vers `HUB-AgentMO2-DeputyOrchestrator` (Step 4).

---

### Step 4 — QA Review (conditionnel) (`HUB-AgentMO2-DeputyOrchestrator`)

**Acteur** : `HUB-AgentMO2-DeputyOrchestrator`  
**Déclenchement** : si `quality_score < 9` ou `status == partial`  
**Durée estimée** : 5-15 secondes

**Input** :
- `orchestration_plan` du Step 3
- `report.md` du Step 3

**Action** :
1. Vérifier cohérence IDs, intents, machines, policies, formats.
2. Identifier les problèmes / incohérences.
3. Proposer les corrections.
4. Produire `qa_report` avec `overall_status`.

**Output attendu** :
```yaml
result:
  summary: "<résumé QA>"
qa_report:
  overall_status: pass|pass_with_warnings|fail
  issues: [...]
  corrections: [...]
```

**Si fail** : abort + notification MO pour replanification.

---

### Step 5 — Archivage (`OPS-DossierIA`)

**Acteur** : `OPS-DossierIA`  
**Durée estimée** : < 2 secondes

**Input** :
- `orchestration_plan` du Step 3
- `qa_report` du Step 4 (si applicable)
- `execution_context` : run_id, timestamps, agents utilisés

**Action** :
1. Créer le dossier : `DOSSIER__<date>__HUB_DISPATCH__<workflow_id>/`
2. Archiver context, steps, deliverables, logs.
3. Retourner le `dossier_id`.

**Si échec** : skip (non-bloquant — archivage best-effort).

---

## Definition of Done (DoD)

- [ ] Intent détecté avec confiance >= medium
- [ ] Plan d'exécution produit (`orchestration_plan.yaml`)
- [ ] Score qualité >= 9/10
- [ ] Tous les steps critiques = `status: success`
- [ ] Run archivé dans `OPS-DossierIA` (dossier_id retourné)
- [ ] `next_actions` définis pour l'opérateur

---

## Cas d'erreur & Fallbacks

| Situation | Action |
|-----------|--------|
| `HUB-Router` — aucun intent détecté | Fallback → `HUB-Concierge` pour qualification |
| `HUB-Concierge` — 3 tours sans clarification | Abort + message d'erreur structuré à l'utilisateur |
| `HUB-AgentMO` — quality_score < 7 | Escalade immédiate → `HUB-AgentMO2` |
| `HUB-AgentMO2` — QA fail | Abort + log détaillé + notification CTL-AlertRouter |
| `OPS-DossierIA` — indisponible | Skip archivage, continuer, alerter CTL-HealthReporter |
| SLA dépassé (> 30 min) | Alerte CTL-AlertRouter, status = `timeout` |

---

## Métriques de performance

| Indicateur | Cible |
|-----------|-------|
| Taux de succès routing | ≥ 95% |
| Score qualité moyen | ≥ 9/10 |
| Durée médiane | < 15 min |
| Taux d'escalade MO2 | < 15% |

---

## Références

- Playbook : `30_PLAYBOOKS/PB_HUB_01_ORCHESTRATE_AND_DISPATCH.yaml`
- Routing table : `40_RUNBOOKS/hub_routing.yaml`
- Agents index : `00_INDEX/agents_index.yaml`
- Intents index : `00_INDEX/intents.yaml`
- Policies : `50_POLICIES/quality_rules.md`, `50_POLICIES/ops/sla.md`
