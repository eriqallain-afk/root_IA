# RUNBOOK — META : Échec Cycle d'Optimisation Prompt

**ID :** RB-META-002  
**Version** : 1.0.0  
**Trigger** : Score prompt < seuil après cycle OPRO, ou drift comportemental persistant  
**Propriétaire** : META-PromptMaster + HUB-OproEngine + META-GouvernanceQA  
**SLA** : < 2 heures  
**Mise à jour** : 2026-03-06  

---

## Objectif

Résoudre les situations où un prompt ne passe pas le seuil qualité (9.0/10) malgré un cycle d'optimisation — ou lorsque le drift comportemental persiste après correction.

---

## Seuils de référence

| Niveau | Score | Action |
|--------|-------|--------|
| Excellent | ≥ 9.5 | Production — aucune action |
| Acceptable | 9.0–9.4 | Production avec monitoring |
| Sous seuil | 8.0–8.9 | Cycle OPRO obligatoire |
| Critique | < 8.0 | Réécriture complète |
| Drift | Δ > 15% vs baseline | Correction urgente |

---

## SCÉNARIO 1 — Score < 9.0 après 1er cycle OPRO

### Symptômes
- `PB_OPT_01_PROMPT_OPTIMIZATION_CYCLE` terminé
- Score final < 9.0
- Variantes produites mais aucune supérieure à la baseline

### Résolution
1. Analyser rapport OPRO : quelles dimensions défaillantes ?
   - Clarté mission (< 9) → réécrire section Mission
   - Couverture cas d'usage (< 9) → ajouter scénarios
   - Format sortie (< 9) → réviser schéma YAML
   - Règles machines (< 9) → compléter les contraintes
   - Exemples (< 9) → ajouter 2-3 exemples concrets

2. Relancer META-PromptMaster en mode `targeted_fix` sur les dimensions défaillantes
3. Maximum 3 itérations au total

---

## SCÉNARIO 2 — Drift comportemental persistant

### Symptômes
- CTL-WatchdogIA : `drift_score < 0.75` sur plusieurs runs consécutifs
- Agent ne respecte plus son format de sortie
- `expected_output` vs `actual_output` divergents dans les tests

### Cause racine fréquente
- Contamination par contexte externe dans les runs
- Prompt ambigu sur le format de sortie
- Règles machine contradictoires

### Résolution
1. `META-ReversePrompt` analyse les outputs récents réels → reconstruit le prompt implicite
2. Comparer prompt implicite vs prompt officiel → identifier divergences
3. `META-PromptMaster` corrige les ambiguïtés identifiées
4. `HUB-OproEngine` valide avec tests de régression (3 runs identiques)
5. Si drift lié au contexte → ajouter section `context_guard` dans le prompt

```yaml
context_guard:
  never_do:
    - "Ne pas modifier l'ID canon"
    - "Ne pas sortir du format YAML strict"
  always_do:
    - "Séparer faits / hypothèses / inconnus"
    - "Remplir log.decisions à chaque décision non triviale"
```

---

## SCÉNARIO 3 — Réécriture complète nécessaire (score < 8.0)

### Symptômes
- Score < 8.0 après 2 cycles OPRO
- Agent fondamentalement mal conçu (mission floue, responsabilités trop larges)

### Résolution
1. META-GouvernanceQA produit rapport d'audit détaillé
2. META-OrchestrateurCentral décide : refactoring ou réécriture complète
3. Si réécriture → utiliser `META-AgentProductFactory` avec spec corrigée
4. Conserver l'ancien prompt en archive dans `90_KNOWLEDGE/ARCHIVE/`
5. Tester exhaustivement avant déploiement (golden tests)

---

## SCÉNARIO 4 — Régression post-optimisation

### Symptômes
- Score initial : 8.5 → après optimisation : 8.0 (régression)
- Fonctionnalité cassée par modification

### Résolution
```
Protocole de rollback :
1. Identifier le commit de la régression (CHANGELOG)
2. Restaurer l'ancienne version depuis archive ou git
3. Analyser pourquoi l'optimisation a cassé quelque chose
4. Modifier uniquement la partie défaillante (chirurgical)
5. Tester avec run_golden_tests.py avant de redéployer
```

---

## Protocole de validation avant déploiement

Avant tout déploiement de prompt optimisé :
- [ ] Score META-PromptMaster ≥ 9.0
- [ ] Tests golden passés (`run_golden_tests.py`)
- [ ] `META-GouvernanceQA` validé
- [ ] Changelog mis à jour avec version (1.x.x → 1.x+1.0)
- [ ] Tests de non-régression sur cas d'usage existants

---

## Références

- `PB_OPT_01_PROMPT_OPTIMIZATION_CYCLE.yaml` — playbook optimisation
- `RUNBOOK_DRIFT_DETECTED.md` (CTL) — drift détecté par WatchdogIA
- `META-PromptMaster/prompt.md` — référence qualité (642 lignes, score 10/10)
- `99_VALIDATION/run_golden_tests.py` — tests de validation
