# RUNBOOK — OPS : Résolution des pannes PlaybookRunner

**Version** : 1.0.0  
**Équipe** : TEAM__OPS + TEAM__CTL  
**SLA intervention** : < 15 minutes (production)  
**Mise à jour** : 2026-02-26

---

## Objectif

Procédure de diagnostic et de résolution pour toute panne ou dégradation de `OPS-PlaybookRunner`. Couvre les cas : timeout, step failed, agent injoignable, boucle infinie, données corrompues.

---

## Niveau de sévérité

| Symptôme | Sévérité | SLA résolution |
|----------|----------|----------------|
| 1 run failed, autres OK | P3 — Low | < 2h |
| > 10% des runs failed | P2 — Medium | < 1h |
| PlaybookRunner totalement indisponible | P1 — High | < 15 min |
| Perte de données (dossiers corrompus) | P0 — Critical | Immédiat |

---

## Diagnostic (Step-by-step)

### 1. Confirmer la panne

```yaml
# Appeler CTL-HealthReporter
input:
  check_target: OPS-PlaybookRunner
  check_type: full
```

Vérifier :
- `status` dans `OPS-PlaybookRunner/agent.yaml` → doit être `active`
- Derniers runs dans `OPS-DossierIA` → chercher `status: failed` ou `status: timeout`
- Dashboard `00_CONTROL/dashboards/AGENT_PERFORMANCE.yaml` → indicateurs anormaux

### 2. Identifier le type de panne

| Type | Symptôme | Go to |
|------|----------|-------|
| Step timeout | `duration_ms > sla_ms * 2` | §3.A |
| Agent fantôme | `actor_id non trouvé dans agents_index` | §3.B |
| Input manquant | `required field absent` | §3.C |
| Output non conforme | `success_criteria failed` | §3.D |
| Boucle infinie | `retry_count > 3` | §3.E |

---

## Résolutions

### 3.A — Step Timeout

**Cause** : L'agent ciblé ne répond pas dans le SLA.

**Actions** :
1. Vérifier le statut de l'agent cible : `00_INDEX/agents_index.yaml` → `status`.
2. Si `status: inactive` → mettre à jour ou escalader vers META-GouvernanceQA.
3. Si l'agent est surchargé → ajuster `sla_minutes` dans le playbook (temporaire).
4. Relancer le run avec `context.resume_from_step: <step_name>`.

```yaml
# Reprise du run
input:
  playbook_id: <playbook_id>
  context:
    resume_from_step: <step_qui_a_timeout>
    state: <état_précédent>
```

---

### 3.B — Agent Fantôme (actor_id inexistant)

**Cause** : Le playbook référence un `agent_id` absent de `00_INDEX/agents_index.yaml`.

**Actions** :
1. Identifier l'`agent_id` fantôme depuis le `execution_log.errors`.
2. Vérifier si l'agent existe sous un autre ID (alias, rename).
3. **Correction A** : Mettre à jour le playbook avec le bon `actor_id`.
4. **Correction B** : Créer l'agent manquant via `META-AgentProductFactory`.
5. Mettre à jour `00_INDEX/agents_index.yaml`.
6. Exécuter `99_VALIDATION/Run-Validation.ps1` pour confirmer.

---

### 3.C — Input Manquant

**Cause** : Un champ requis n'est pas transmis entre steps.

**Actions** :
1. Lire `execution_log.steps[N].error_detail` pour identifier le champ manquant.
2. Vérifier la cohérence `output.passes_to` du step N-1 vs `input.fields` du step N.
3. Corriger le playbook : ajouter le champ manquant dans `output.artifacts` du step précédent.
4. Si c'est un input utilisateur manquant → router vers `HUB-Concierge` pour re-qualification.

---

### 3.D — Output Non Conforme

**Cause** : L'agent produit un output qui ne satisfait pas les `success_criteria`.

**Actions** :
1. Inspecter `execution_log.steps[N].output_summary`.
2. Comparer avec les `success_criteria` du step.
3. Escalader vers `HUB-AgentMO2-DeputyOrchestrator` pour QA review.
4. Si le prompt de l'agent est en cause → trigger `META-PromptMaster` pour optimisation.

---

### 3.E — Boucle Infinie (retry_count > 3)

**Cause** : Le step échoue en continu malgré les retries.

**Actions** :
1. **Forcer l'abort** : mettre à jour `on_failure: abort` dans le playbook (temporaire).
2. Analyser la cause racine avec `HUB-AgentMO2-DeputyOrchestrator`.
3. Si bug structurel → ticket vers META-GouvernanceQA pour audit complet du step.
4. Documenter dans `60_CHANGELOG/CHANGELOG.md`.

---

## Escalade

| Situation | Escalade vers |
|-----------|---------------|
| Panne persiste > SLA | CTL-AlertRouter |
| Corruption de données | HUB-AgentMO-MasterOrchestrator + OPS-DossierIA |
| Bug structurel playbook | META-GouvernanceQA |
| Agent manquant ou dégradé | META-AgentProductFactory |

---

## Post-Mortem (P1/P0 obligatoire)

Utiliser le playbook `PB_CTL_03_POST_MORTEM_ANALYSIS.yaml` dans les 24h suivant l'incident.

Documenter dans `00_CONTROL/runbooks/RUNBOOK_AGENT_FAILURE.md` :
- Timeline de l'incident
- Root cause
- Actions correctives appliquées
- Mesures préventives

---

## Références

- `00_CONTROL/dashboards/AGENT_PERFORMANCE.yaml`
- `00_CONTROL/policies/ESCALATION_MATRIX.yaml`
- `30_PLAYBOOKS/PB_CTL_01_FACTORY_HEALTH_CHECK.yaml`
- `50_POLICIES/ops/incident_severity.md`
- `50_POLICIES/ops/sla.md`
