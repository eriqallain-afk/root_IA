# PACKAGE CTL — TEAM__CTL
## Monitoring & Contrôle de la FACTORY root_IA
**Version :** 1.0.0 | **Date :** 2026-02-25 | **Statut :** Prêt à déployer

---

## Contenu de ce package

```
10_TEAMS/
  └── TEAM__CTL.yaml                         ← Déclaration de l'équipe

00_CONTROL/
  ├── agents/
  │   ├── CTL-WatchdogIA/                    ← Gardien de la FACTORY
  │   │   ├── agent.yaml
  │   │   ├── contract.yaml
  │   │   ├── prompt.md
  │   │   ├── memory/ (glossary + memory_pack)
  │   │   ├── tests/ (sample_input + expected_output + test_cases)
  │   │   └── tools/tools.md
  │   ├── CTL-AlertRouter/                   ← Centrale d'alertes
  │   │   ├── agent.yaml
  │   │   ├── contract.yaml
  │   │   ├── prompt.md
  │   │   ├── memory/
  │   │   ├── tests/
  │   │   └── tools/
  │   └── CTL-HealthReporter/                ← Journaliste de la FACTORY
  │       ├── agent.yaml
  │       ├── contract.yaml
  │       ├── prompt.md
  │       ├── memory/
  │       ├── tests/
  │       └── tools/
  ├── policies/
  │   ├── ALERT_THRESHOLDS.yaml              ← Seuils d'alerte configurables
  │   ├── ESCALATION_MATRIX.yaml             ← Qui est alerté pour quoi
  │   └── RETENTION_METRICS.yaml             ← Durée de rétention des logs
  └── runbooks/
      ├── RUNBOOK_AGENT_FAILURE.md           ← Procédure échec agent
      ├── RUNBOOK_DRIFT_DETECTED.md          ← Procédure drift comportemental
      └── RUNBOOK_FACTORY_DOWN.md            ← Recovery complète (NIVEAU 1-5)

30_PLAYBOOKS/
  └── PB_CTL_01_FACTORY_HEALTH_CHECK.yaml   ← Playbook audit santé complet

00_INDEX_ADDITIONS/
  └── INDEX_ADDITIONS_CTL.yaml              ← Instructions de mise à jour des index
```

---

## Instructions de déploiement

### Étape 1 — Copier les fichiers
```
Copier 10_TEAMS/TEAM__CTL.yaml → <FACTORY_ROOT>/10_TEAMS/
Copier 00_CONTROL/agents/* → <FACTORY_ROOT>/00_CONTROL/agents/
Copier 00_CONTROL/policies/* → <FACTORY_ROOT>/00_CONTROL/policies/
Copier 00_CONTROL/runbooks/* → <FACTORY_ROOT>/00_CONTROL/runbooks/
Copier 30_PLAYBOOKS/PB_CTL_01* → <FACTORY_ROOT>/30_PLAYBOOKS/
```

### Étape 2 — Mettre à jour les index
Ouvrir `00_INDEX_ADDITIONS/INDEX_ADDITIONS_CTL.yaml` et intégrer chaque bloc
commenté dans le fichier 00_INDEX/ correspondant.

### Étape 3 — Valider
```
Exécuter : 99_VALIDATION/Run-Validation.ps1
```
Attendu : 0 erreur, 3 nouveaux agents détectés (CTL-WatchdogIA, CTL-AlertRouter, CTL-HealthReporter)

### Étape 4 — Premier run
Lancer le playbook FACTORY_HEALTH_CHECK avec check_type=full.
Résultat attendu : factory_status + health_score + premier weekly_report de référence.

---

## Dépendances

Ce package dépend des agents existants suivants (doivent être actifs) :
- `OPS-DossierIA` — Archivage des rapports
- `HUB-AgentMO-MasterOrchestrator` — Escalade P0
- `META-GouvernanceQA` — Correction des drifts P1
- `IAHQ-QualityGate` — Validation avant reprise post-incident

---

## Prochain sprint recommandé

Après déploiement de CTL :
1. `PB-CTL-02 AGENT_LIFECYCLE_MANAGEMENT`
2. `PB-CTL-03 POST_MORTEM_ANALYSIS`
3. `PB-OPT-01 PROMPT_OPTIMIZATION_CYCLE`