# RUNBOOK — META : Échec de Construction d'Agent / Armée GPT

**ID :** RB-META-001  
**Version** : 1.0.0  
**Trigger** : `BUILD_ARMY_FACTORY` ou `BUILD_TEAM_FROM_SCRATCH` échoue / qualité insuffisante  
**Propriétaire** : META-OrchestrateurCentral + META-GouvernanceQA  
**SLA** : < 1 heure  
**Mise à jour** : 2026-03-06  

---

## Objectif

Résoudre les blocages dans le pipeline de création d'agents et d'armées GPT — de l'analyse des besoins jusqu'à la validation finale.

---

## Architecture du pipeline BUILD

```
META-OrchestrateurCentral
    │
    ├──[STEP 1]── META-AnalysteBesoinsEquipes ── requirements spec
    ├──[STEP 2]── META-CartographeRoles ── agents catalog
    ├──[STEP 3]── META-ArchitecteChoix ── décisions archi (si complexe)
    ├──[STEP 4]── META-PromptMaster ── prompts complets
    ├──[STEP 5]── META-AgentProductFactory ── packaging (agent.yaml + contract)
    ├──[STEP 6]── META-WorkflowDesignerEquipes ── workflows
    ├──[STEP 7]── META-PlaybookBuilder ── playbooks exécutables
    └──[STEP 8]── META-GouvernanceQA ── audit final (score ≥ 9/10)
```

---

## SCÉNARIO 1 — Requirements trop flous (Step 1)

### Symptômes
- `META-AnalysteBesoinsEquipes` retourne `status: needs_info` après 3 questions
- `confidence < 0.6` dans le `requirements_spec`
- Domaine métier non identifiable

### Résolution
1. Escalader vers `HUB-CoachIA360` pour session de discovery stratégique
2. Si contexte IT-MSP → enrichir avec templates ConnectWise disponibles
3. Relancer avec spec partielle + `missing_data` explicite
4. OrchestrateurCentral autorise continuation si `confidence ≥ 0.5` + hypothèses documentées

---

## SCÉNARIO 2 — Doublons détectés (Step 2)

### Symptômes
- `META-CartographeRoles` détecte chevauchement avec agents existants
- `anti_overlap_check.conflicts_found` non vide

### Résolution
```
Pour chaque conflit détecté :
  Option A : Réutiliser l'agent existant (recommandé si > 80% overlap)
  Option B : Créer un agent spécialisé avec scope distinct et clarifié
  Option C : Fusionner avec l'agent existant → RUNBOOK__ADD_AGENT.md

→ Documenter décision dans log.decisions avec justification
→ Mettre à jour agents_index.yaml si réutilisation
```

---

## SCÉNARIO 3 — Score prompt < 9/10 (Step 4)

### Symptômes
- `META-PromptMaster` score final < 9.0
- Critères défaillants dans le rapport d'évaluation

### Résolution
1. Identifier les dimensions sous le seuil (clarté, couverture, exemples, format, règles)
2. Itération ciblée : PromptMaster revise uniquement les sections défaillantes
3. Maximum 3 itérations avant escalade à `HUB-OproEngine` (optimisation avancée)
4. Si après 3 passes : score toujours < 9 → audit complet `PB_OPT_01_PROMPT_OPTIMIZATION_CYCLE`

---

## SCÉNARIO 4 — Packaging invalide (Step 5)

### Symptômes
- `META-AgentProductFactory` retourne erreur de validation
- `agent.yaml` ou `contract.yaml` non conforme au schema
- Champs obligatoires manquants

### Résolution
```
Vérifier les champs obligatoires :
  agent.yaml : schema_version, agent_id, team_id, role, status, version
  contract.yaml : inputs[], outputs[], error_codes[]
  prompt.md : ID canon, Version, Mission, Règles Machine, Format sortie

→ Lancer : python 99_VALIDATION/validate_integrity.py --agent <AGENT_ID>
→ Corriger les champs manquants
→ Re-soumettre à AgentProductFactory
```

---

## SCÉNARIO 5 — GouvernanceQA rejette l'armée (Step 8)

### Symptômes
- Score global < 9.0 / Score individuel agent < 8.5
- Agents fantômes (cités mais inexistants)
- Playbooks référençant des agents non déclarés

### Résolution
1. Lire rapport GouvernanceQA — identifier agents/sections en défaut
2. Prioriser par criticité : orchestrateur > agents clés > agents secondaires
3. Boucle correctrice par agent (max 2 passes par agent)
4. Validation finale : tous agents ≥ 9.0, aucun fantôme, playbooks cohérents
5. Si > 20% agents sous seuil → relancer pipeline complet depuis Step 4

---

## SCÉNARIO 6 — Playbooks non exécutables (Step 7)

### Symptômes
- `META-PlaybookBuilder` produit playbook avec `actor_id` non résolu
- Steps sans `on_failure` défini
- Playbook vide ou partiel

### Résolution
1. Vérifier que tous les `actor_id` dans les steps existent dans `agents_index.yaml`
2. Ajouter `on_failure: skip | retry | abort` à chaque step
3. S'assurer que le `trigger` correspond à un intent déclaré dans `intents.yaml`
4. Tester via `OPS-PlaybookRunner` en mode dry_run avant activation

---

## Checklist post-construction réussie

- [ ] Tous agents dans `20_AGENTS/<TEAM>/`
- [ ] Tous agents dans `00_INDEX/agents_index.yaml`
- [ ] Au moins 2 playbooks dans `30_PLAYBOOKS/`
- [ ] Routes dans `40_ROUTING/hub_routing.yaml`
- [ ] GouvernanceQA score ≥ 9.0 pour chaque agent
- [ ] Runbook d'incident créé : `RUNBOOK__<TEAM>_FAILURE.md`
- [ ] `60_CHANGELOG/CHANGELOG.md` mis à jour
- [ ] CTL-WatchdogIA reconnaît la nouvelle équipe (scan `light_check`)

---

## Références

- `PB_FAB_01_BUILD_ARMY_FACTORY.yaml` — pipeline principal
- `PB_FAB_03_BUILD_TEAM_FROM_SCRATCH.yaml` — version complète
- `RUNBOOK__META_PROMPT_OPTIMIZATION_FAILURE.md` — échec optimisation
- `RUNBOOK__QUALITY_GATE_REJECTION.md` — rejet GouvernanceQA
- `PB_OPT_02_ARMY_AUDIT_COMPLETE.yaml` — audit complet armée
