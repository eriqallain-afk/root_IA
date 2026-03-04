# RUNBOOK — Drift Comportemental Détecté
**ID :** RB-CTL-002  
**Trigger :** CTL-WatchdogIA détecte `drift_score < 0.75` sur un agent  
**Propriétaire :** META-GouvernanceQA + META-PromptMaster  
**Dernière révision :** 2026-02-25

---

## Définition du Drift

Un agent "dérive" quand ses outputs réels ne correspondent plus à ce que son `expected_output.yaml`
définit comme comportement attendu. Le drift est mesuré sur les 3-5 derniers outputs réels
comparés au schéma de référence.

**Score de drift :**
- `1.0` = aucun drift — agent parfaitement conforme
- `0.75-0.99` = dérive légère — surveiller
- `0.50-0.74` = **dérive confirmée — action requise (P1)**
- `< 0.50` = **dérive critique — suspendre l'agent (P0)**

---

## Étape 1 — MESURER PRÉCISÉMENT

```yaml
drift_assessment:
  agent_id: "<id>"
  drift_score: <float>
  outputs_analyzed: <int>     # minimum 3
  schema_fields_checked:
    - field: "result.status"
      conformance: "<OK|DRIFT>"
      evidence: "<exemple drifté si applicable>"
    - field: "log.decisions"
      conformance: "<OK|DRIFT>"
  summary: "<description courte du drift>"
```

Si moins de 3 outputs récents disponibles → `drift_score: null` + marquer comme hypothèse.

---

## Étape 2 — IDENTIFIER LA CAUSE RACINE

**Cause R1 — Prompt modifié sans mise à jour du contrat**
- Vérifier : `agent.version` et date de `last_updated` dans `agent.yaml`
- Vérifier : Différences entre `prompt.md` et `contract.yaml` output schema
- Signal : agent fonctionne mais produit des champs différents des attendus

**Cause R2 — Contrat modifié sans mise à jour du prompt**
- Vérifier : `contract.yaml` a-t-il des champs nouveaux non documentés dans `prompt.md` ?
- Signal : prompt.md parle d'anciens champs que le contrat n'attend plus

**Cause R3 — Évolution des inputs en amont**
- Vérifier : L'agent précédent dans le playbook produit-il des outputs différents ?
- Signal : drift corrélé à une modification récente d'un autre agent
- Fix : Mettre à jour la définition `input` du contrat de l'agent drifté

**Cause R4 — Instructions internes ambiguës**
- Vérifier : Le prompt contient-il des instructions contradictoires ?
- Signal : Comportement incohérent selon le contexte d'input
- Fix : Playbook `PROMPT_OPTIMIZATION_CYCLE`

---

## Étape 3 — CORRIGER SELON LE NIVEAU

**Drift léger (0.75-0.99) — Ajustement examples :**
```
1. Ajouter un example explicite dans la section E) du prompt (Format de sortie)
2. Mettre à jour tests/expected_output.yaml avec le comportement attendu
3. Incrémenter agent.version (patch : 1.2.0 → 1.2.1)
4. Valider sur 3 nouvelles exécutions
```

**Drift modéré (0.50-0.74) — Révision prompt :**
```
1. Escalader à META-GouvernanceQA : audit complet prompt vs contrat
2. Lancer playbook PROMPT_OPTIMIZATION_CYCLE
3. Soumettre les 2 variantes de prompt à META-GouvernanceQA pour évaluation
4. Appliquer la meilleure variante + test de régression complet
5. Incrémenter agent.version (minor : 1.2 → 1.3)
```

**Drift critique (< 0.50) — Suspend et refonte :**
```
1. Mettre agent.yaml status: degraded IMMÉDIATEMENT
2. Retirer l'agent des playbooks actifs (remplacer temporairement par fallback)
3. Escalader à META-OrchestrateurCentral pour refonte complète
4. Repartir du template TEMPLATE__AGENT.md
5. Revalidation complète par META-GouvernanceQA avant remise en service
6. Incrémenter agent.version (major : 1.3 → 2.0)
```

---

## Étape 4 — TESTS DE RÉGRESSION (obligatoire)

Avant tout retour en `status: active` :

```
1. Exécuter sample_input.yaml → comparer avec expected_output.yaml
2. Exécuter TOUS les test_cases.md (minimum 3)
3. Calculer le drift_score post-correction → doit être ≥ 0.90
4. Vérifier que les champs log.decisions et log.assumptions sont présents
5. Vérifier que le format YAML est strict (aucun texte hors YAML)
```

---

## Étape 5 — CAPITALISER

1. Ajouter le cas drifté comme `TC-XXX` dans `tests/test_cases.md`
2. Documenter la cause dans `memory/memory_pack.yaml` → `patterns`
3. Logger la résolution dans OPS-DossierIA
4. Mettre à jour `last_updated` dans `agent.yaml`

---

## Prévention

- Exécuter `FACTORY_HEALTH_CHECK` (full_check) chaque semaine
- Toujours incrémenter `agent.version` après toute modification de `prompt.md`
- Garder `tests/expected_output.yaml` à jour après chaque évolution du contrat
