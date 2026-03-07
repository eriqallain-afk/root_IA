# RUNBOOK — Quality Gate : Rejet de Livrable

**ID :** RB-FACTORY-006  
**Version** : 1.0.0  
**Trigger** : IAHQ-QualityGate ou META-GouvernanceQA bloque un livrable (score < seuil)  
**Propriétaire** : IAHQ-QualityGate + META-GouvernanceQA + orchestrateur d'équipe  
**SLA** : < 1 heure (correction) | < 15 min (triage)  
**Mise à jour** : 2026-03-06  

---

## Objectif

Gérer les rejets de Quality Gate de façon structurée — identifier la cause, corriger efficacement, et revalider sans boucle infinie.

---

## Seuils par type de livrable

| Type | Gate | Seuil minimum |
|------|------|---------------|
| Agent GPT complet | META-GouvernanceQA | 9.0 / 10 |
| Armée GPT complète | META-GouvernanceQA | 9.0 / 10 (moyenne) + 8.5 (min individuel) |
| Livrable client IAHQ | IAHQ-QualityGate | 9.0 / 10 |
| Prompt seul | META-PromptMaster | 9.0 / 10 |
| Playbook | META-PlaybookBuilder + validation | 8.5 / 10 |
| Business case | IAHQ-QualityGate | 9.0 / 10 |

**Règle absolue** : Aucun livrable ne sort de la FACTORY avec score < 8.5.

---

## SCÉNARIO 1 — Rejet agent GPT (META-GouvernanceQA)

### Lecture du rapport GouvernanceQA

```yaml
# Exemple de rapport rejet
audit_result:
  agent_id: NOUVEAU-Agent
  score: 7.8
  verdict: REJECTED
  issues:
    - dimension: prompt_completeness
      score: 6.0
      detail: "Format de sortie non défini"
    - dimension: mission_clarity  
      score: 8.0
      detail: "Mission trop large — 3 responsabilités distinctes"
    - dimension: rules_machine
      score: 8.5
      detail: "Règle anti-hallucination manquante"
```

### Procédure de correction

1. **Prioriser** : corriger d'abord les dimensions < 8.0
2. **Cibler** : ne modifier QUE les sections défaillantes (chirurgical)
3. **Déléguer** :
   - `prompt_completeness` → META-PromptMaster (format sortie)
   - `mission_clarity` → META-CartographeRoles (redéfinition scope)
   - `rules_machine` → META-PromptMaster (ajout règles)
4. **Revalider** : soumettre à GouvernanceQA après correction
5. **Limite** : 2 passes de correction maximum — si échec → RUNBOOK__META_AGENT_BUILD_FAILURE.md

---

## SCÉNARIO 2 — Rejet livrable client (IAHQ-QualityGate)

### Dimensions évaluées par IAHQ-QualityGate

| Dimension | Poids | Seuil |
|-----------|-------|-------|
| Exhaustivité factuelle | 25% | 9.0 |
| Cohérence interne | 20% | 9.0 |
| Clarté et lisibilité | 20% | 8.5 |
| Chiffrages justifiés | 20% | 9.0 |
| Plan d'action actionnable | 15% | 9.0 |

### Procédure de correction

1. Identifier section(s) sous seuil dans le rapport QualityGate
2. Retourner à l'agent responsable de la section :
   - Chiffrages → IAHQ-Economist
   - Processus → IAHQ-ProcessMapper
   - Architecture → IAHQ-TechLeadIA
   - Stratégie → IAHQ-Strategist
   - Compilation → IAHQ-SolutionOrchestrator (cohérence globale)
3. Correction ciblée + re-soumission
4. Limite : 2 itérations correcives

---

## SCÉNARIO 3 — Score plancher non atteint malgré 2 passes

### Symptômes
- Après 2 cycles de correction, score toujours < 9.0
- Problème fondamental de conception (pas cosmétique)

### Résolution
1. Escalader à l'orchestrateur d'équipe (META-OrchestrateurCentral ou IAHQ-OrchestreurEntrepriseIA)
2. Décision : refactoring majeur OU abandon
3. Si refactoring : reconstruire la section défaillante from scratch
4. Document post-mortem : qu'est-ce qui a raté dans la conception initiale ?

---

## Anti-patterns à éviter

❌ **Ne pas baisser le seuil** pour passer un livrable médiocre  
❌ **Ne pas itérer > 3 fois** — si ça ne passe pas en 3 passes, c'est un problème de conception  
❌ **Ne pas ignorer un item** même si "cosmétique" — la somme des petits défauts compte  
❌ **Ne pas créer un workaround** — corriger la vraie cause  

---

## Checklist post-rejet résolu

- [ ] Score final ≥ 9.0 confirmé par le QA Gate
- [ ] Cause racine documentée dans `log.decisions`
- [ ] Leçon tirée ajoutée à `META-GouvernanceQA` ou `IAHQ-QualityGate` si pattern nouveau
- [ ] Changelog version incrémenté

---

## Références

- `IAHQ-QualityGate/knowledge/runbooks/quality_gate_runbook.md` — logique interne QG
- `RUNBOOK__META_AGENT_BUILD_FAILURE.md` — échec build agent
- `RUNBOOK__IAHQ_FRONTDOOR_FAILURE.md` — échec pipeline IAHQ
- `PB_OPT_02_ARMY_AUDIT_COMPLETE.yaml` — audit complet armée
