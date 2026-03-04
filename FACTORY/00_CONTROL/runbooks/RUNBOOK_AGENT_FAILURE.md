# RUNBOOK — Agent Failure
**ID :** RB-CTL-001  
**Trigger :** Un agent retourne une erreur, un output invalide, ou ne répond pas  
**Propriétaire :** CTL-WatchdogIA + IAHQ-TechLeadIA  
**Dernière révision :** 2026-02-25

---

## Étape 1 — DÉTECTER

**Sources de détection :**
- OPS-PlaybookRunner retourne `step.status=failed`
- CTL-WatchdogIA détecte `drift_score < 0.75` ou schéma invalide
- OPS-DossierIA log un step sans output

**Informations à collecter avant d'agir :**
```yaml
failure_info:
  agent_id: "<id>"
  playbook_id: "<id>"
  step_id: "<id>"
  error_type: "<schema_invalid|no_output|timeout|wrong_format>"
  error_message: "<message complet>"
  input_provided: "<résumé de l'input>"
  timestamp: "<ISO 8601>"
  occurrence_count: <int>   # 1er échec ou répété ?
```

---

## Étape 2 — CLASSIFIER

| Situation | Sévérité | Action |
|---|---|---|
| 1er échec isolé | P3 | Logger uniquement, continuer si `on_failure: skip` |
| 2ème échec consécutif | P2 | Marquer agent `degraded`, alerter CTL-AlertRouter |
| 3ème échec ou plus | P1 | Suspendre le step, escalader à META-GouvernanceQA |
| Échec bloque playbook critique | P0 | Arrêt immédiat, escalader à HUB-AgentMO |
| Echec en cascade (3+ agents) | P0 | FACTORY_DOWN — voir RUNBOOK_FACTORY_DOWN |

---

## Étape 3 — DIAGNOSTIQUER

**Cause A — Input invalide**
- Symptôme : L'agent indique `status: needs_input` ou champs requis manquants
- Vérifier : Le contrat `contract.yaml` de l'agent précédent dans le playbook
- Fix : Corriger l'output de l'agent producteur → incrémenter sa version

**Cause B — Prompt défaillant**
- Symptôme : Output ne respecte pas le format YAML ou les champs du contrat
- Vérifier : Comparer `prompt.md` vs `contract.yaml` (output schema)
- Fix : Escalader à `META-PromptMaster` → playbook `PROMPT_OPTIMIZATION_CYCLE`

**Cause C — Contrat désynchronisé**
- Symptôme : L'agent produit un YAML valide mais avec des champs inattendus
- Vérifier : Comparer `contract.yaml` vs `expected_output.yaml` dans tests/
- Fix : Escalader à `META-GouvernanceQA` pour audit et réconciliation

**Cause D — Timeout**
- Symptôme : Step dépasse le SLA (> 30 min par défaut)
- Vérifier : Complexité de l'input, taille du contexte fourni
- Fix : Découper le step en sous-steps, ou augmenter le `sla.timeout` dans `agent.yaml`

---

## Étape 4 — CORRIGER

```
Si P3 (isolé) :
  → Logger dans OPS-DossierIA
  → Continuer le playbook (on_failure: skip ou retry_once)

Si P2 (répété) :
  → Mettre agent.yaml status: degraded
  → Notifier CTL-AlertRouter
  → Planifier correction dans la semaine

Si P1 (suspendu) :
  → Stopper le step
  → Appeler META-GouvernanceQA avec le dossier d'erreur
  → Ne pas relancer avant validation du correctif

Si P0 (bloquant) :
  → Arrêter le playbook complet
  → Escalader à HUB-AgentMO + IAHQ-QualityGate
  → Ouvrir un post-mortem via PB-CTL-03
```

---

## Étape 5 — VALIDER & FERMER

1. Appliquer le correctif (prompt, contrat, ou input de l'agent précédent)
2. Incrémenter `agent.version` (ex: 1.1 → 1.2)
3. Relancer avec `tests/sample_input.yaml`
4. Comparer output vs `tests/expected_output.yaml`
5. Si OK : remettre `status: active`
6. Ajouter le cas d'échec comme nouveau `test_case` dans `tests/test_cases.md`
7. Logger la résolution dans OPS-DossierIA avec `operation: close`

---

## Escalade finale si non résolu en 48h

→ `IAHQ-OrchestreurEntrepriseIA` pour décision stratégique (remplacer l'agent vs patch)
