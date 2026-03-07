# RUNBOOK — IAHQ : Échec Pipeline FrontDoor Client

**ID :** RB-IAHQ-001  
**Version** : 1.0.0  
**Trigger** : Pipeline `PB_IAHQ_01_FRONTDOOR` bloqué ou livrable rejeté par QualityGate  
**Propriétaire** : IAHQ-OrchestreurEntrepriseIA + IAHQ-QualityGate  
**SLA** : < 30 minutes  
**Mise à jour** : 2026-03-06  

---

## Objectif

Résoudre les blocages dans le pipeline stratégique IAHQ qui transforme une demande client en business case validé et proposition d'offre.

---

## Architecture du pipeline IAHQ_FRONTDOOR

```
Entrée client
    │
    ▼
IAHQ-OrchestreurEntrepriseIA ── coordination globale
    │
    ├──[STEP 1]── IAHQ-Extractor ── ingestion documents client
    ├──[STEP 2]── IAHQ-ProcessMapper ── cartographie AS-IS
    ├──[STEP 3]── IAHQ-Strategist ── business case + roadmap
    ├──[STEP 4]── IAHQ-Economist ── ROI + scénarios financiers
    ├──[STEP 5]── IAHQ-TechLeadIA ── architecture technique
    ├──[STEP 6]── IAHQ-SolutionOrchestrator ── compilation livrable
    └──[STEP 7]── IAHQ-QualityGate ── validation finale (seuil 9/10)
```

---

## SCÉNARIO 1 — Données client insuffisantes (Step 1)

### Symptômes
- IAHQ-Extractor retourne `status: needs_info`
- Documents manquants ou illisibles
- `confidence < 0.6`

### Résolution
1. IAHQ-OrchestreurEntrepriseIA liste les données manquantes
2. Préparer template de collecte → IAHQ-AdminManagerIA génère questionnaire
3. Relancer Extractor avec données complétées
4. Si données partielles acceptables : continuer avec `log.assumptions` détaillées

---

## SCÉNARIO 2 — ProcessMapper bloqué (Step 2)

### Symptômes
- Processus AS-IS trop complexe ou mal documenté
- `goulots_etranglement` non identifiables
- Acteurs contradictoires dans les docs

### Résolution
1. IAHQ-ProcessMapper demande entretien complémentaire (max 3 questions)
2. Si impasse → produire version partielle + `missing_data` explicite
3. Marquer steps incertains dans `log.assumptions`
4. Continuer le pipeline avec version partielle

---

## SCÉNARIO 3 — ROI non calculable (Step 4)

### Symptômes
- IAHQ-Economist retourne `roi_calculable: false`
- Données financières manquantes (coûts opex, volumes, FTEs)
- Hypothèses trop incertaines pour scénario conservateur

### Résolution
1. Économiste produit un ROI **qualitatif** avec fourchettes sectorielles
2. Documenter toutes hypothèses dans `log.assumptions` avec `confidence_level`
3. Proposer 3 scénarios : pessimiste / réaliste / optimiste
4. Ne jamais produire un ROI sans base — préférer "non disponible" avec justification

---

## SCÉNARIO 4 — QualityGate rejette le livrable (Step 7)

### Symptômes
- `IAHQ-QualityGate` retourne `score < 9.0`
- Champs manquants identifiés
- Incohérences détectées entre sections

### Résolution
1. Lire le rapport détaillé de QualityGate (`issues[]`)
2. Identifier le(s) agent(s) responsable(s) de la section défaillante
3. Boucle correctrice : agent → QualityGate (max 2 itérations)
4. Si score toujours < 9 après 2 passes → escalader à IAHQ-OrchestreurEntrepriseIA
5. Livrable bloqué jusqu'à score ≥ 9.0

```yaml
quality_gate_protocol:
  threshold: 9.0
  max_iterations: 2
  on_failure: escalate_to_orchestrateur
  never_deliver_below: 8.5
```

---

## SCÉNARIO 5 — Timeout pipeline (> 3h)

### Symptômes
- Pipeline actif depuis > 180 minutes
- Step bloqué sans progression
- Orchestrateur ne répond plus

### Résolution
1. OPS-PlaybookRunner déclenche `pause` automatique
2. CTL-WatchdogIA alerte CTL-AlertRouter
3. IAHQ-OrchestreurEntrepriseIA reprend à partir du dernier step complété
4. OPS-DossierIA restaure l'état depuis le dernier checkpoint

---

## Checklist post-incident

- [ ] Cause documentée par IAHQ-OrchestreurEntrepriseIA
- [ ] Dossier client sauvegardé dans OPS-DossierIA
- [ ] QualityGate score final enregistré
- [ ] Retour expérience → IAHQ-ProcessMapper si pattern récurrent

---

## Références

- `PB_IAHQ_01_FRONTDOOR.yaml` — playbook principal
- `RUNBOOK__QUALITY_GATE_REJECTION.md` — rejets QualityGate
- `RUNBOOK_AGENT_FAILURE.md` (CTL) — agent IAHQ en panne
- `IAHQ-QualityGate/knowledge/runbooks/quality_gate_runbook.md` — runbook QG interne
