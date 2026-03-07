# RUNBOOK — Ajouter une nouvelle équipe dans la FACTORY

**ID :** RB-FACTORY-004  
**Version** : 2.0.0  
**Remplace** : RUNBOOK__add_team.md (stub 7 lignes)  
**Propriétaire** : META-OrchestrateurCentral + HUB-AgentMO  
**SLA** : < 2 heures (équipe simple) | < 1 jour (équipe complète)  
**Mise à jour** : 2026-03-06  

---

## Objectif

Intégrer une nouvelle équipe dans la FACTORY root_IA de façon **traçable, validée et immédiatement routable** — sans casser les indexes, les validations ou le routage existant.

---

## Prérequis

Avant de commencer, confirmer :
- [ ] `team_id` unique au format `TEAM__<CODE>` (ex: `TEAM__DAM`, `TEAM__EDU`)
- [ ] Mission de l'équipe clairement définie (1-2 phrases)
- [ ] Orchestrateur désigné (`<CODE>-Orchestrateur` ou `<CODE>-OrchestrateurCentral`)
- [ ] Au moins 1 agent spécialiste prévu
- [ ] Domaine métier distinct des équipes existantes (vérifier `10_TEAMS/teams.yaml`)

---

## Étapes

### PHASE 1 — Déclaration (15 min)

**Étape 1.1 — Créer le fichier équipe**

```
20_AGENTS/<CODE>/ → dossier racine de l'équipe
10_TEAMS/TEAM__<CODE>.yaml → fichier de déclaration
```

Structure minimale `TEAM__<CODE>.yaml` :
```yaml
schema_version: "1.0"
team_id: TEAM__<CODE>
name: <CODE>
mission: "<Mission en 1-2 phrases>"
default_orchestrator: <CODE>-Orchestrateur

agents_count: <N>

key_agents:
  - <CODE>-Orchestrateur
  - <CODE>-Agent1
  # ... autres agents

capabilities:
  - "<capacité 1>"
  - "<capacité 2>"

policies:
  - FACTORY/50_POLICIES/<CODE>_POLICY.yaml

runbooks:
  - FACTORY/40_RUNBOOKS/RUNBOOK__<CODE>_FAILURE.md

last_updated: "<YYYY-MM-DD>"
```

**Étape 1.2 — Mettre à jour `10_TEAMS/teams.yaml`**

Ajouter l'entrée :
```yaml
<CODE>:
  team_id: TEAM__<CODE>
  file: 10_TEAMS/TEAM__<CODE>.yaml
  status: active
  added: "<YYYY-MM-DD>"
```

---

### PHASE 2 — Création de l'orchestrateur (30 min)

**Étape 2.1 — Structure de dossier**

```
20_AGENTS/<CODE>/<CODE>-Orchestrateur/
  ├── agent.yaml
  ├── contract.yaml
  ├── prompt.md
  ├── memory/
  │   ├── glossary.yaml
  │   └── memory_pack.yaml
  └── tests/
      ├── sample_input.yaml
      └── expected_output.yaml
```

**Étape 2.2 — `agent.yaml` minimum**

```yaml
schema_version: "1.0"
agent_id: <CODE>-Orchestrateur
team_id: TEAM__<CODE>
role: orchestrator
status: active
version: "1.0.0"
```

**Étape 2.3 — Déclarer dans `00_INDEX/agents_index.yaml`**

```yaml
<CODE>-Orchestrateur:
  team: TEAM__<CODE>
  role: orchestrator
  status: active
  capabilities: ["orchestration", "<domaine>"]
```

---

### PHASE 3 — Création des agents spécialistes (variable)

Pour chaque agent spécialiste :
1. Utiliser le playbook `BUILD_TEAM_FROM_SCRATCH` (PB_FAB_03) via META-OrchestrateurCentral
2. Ou utiliser META-AgentProductFactory pour génération industrielle
3. Chaque agent doit avoir : `agent.yaml` + `contract.yaml` + `prompt.md` (≥ 150 lignes)

Référence : `RUNBOOK__ADD_AGENT.md`

---

### PHASE 4 — Intégration dans les indexes (15 min)

**Étape 4.1 — Mettre à jour `00_INDEX/agents_index.yaml`**  
→ Ajouter chaque agent de la nouvelle équipe

**Étape 4.2 — Mettre à jour `00_INDEX/capability_map.yaml`**  
→ Ajouter les capabilities de l'équipe avec le mapping vers les agents

**Étape 4.3 — Mettre à jour `40_ROUTING/hub_routing.yaml`**  
→ Ajouter les intents spécifiques à l'équipe avec leur route vers l'orchestrateur

```yaml
routes:
  - intent: "<intent_equipe>"
    target: <CODE>-Orchestrateur
    team: TEAM__<CODE>
    confidence_threshold: 0.7
```

**Étape 4.4 — Mettre à jour `00_INDEX/intents.yaml`**  
→ Déclarer les intents propres à cette équipe

---

### PHASE 5 — Playbooks et runbooks (30 min)

**Étape 5.1 — Créer au minimum 2 playbooks**
- Playbook d'entrée principale (ex: `PB_<CODE>_01_FRONTDOOR.yaml`)
- Playbook de build/configuration si applicable

**Étape 5.2 — Créer le runbook d'incident**
- `RUNBOOK__<CODE>_FAILURE.md` dans `40_RUNBOOKS/`
- Inclure : triggers, triage, résolution, escalade

**Étape 5.3 — Mettre à jour `00_INDEX/playbooks_index.yaml`**  
→ Référencer les nouveaux playbooks

---

### PHASE 6 — Validation (20 min)

**Étape 6.1 — Validation structurelle**

Exécuter (si disponible) :
```bash
python 99_VALIDATION/validate_integrity.py --team <CODE>
```

Vérifications manuelles :
- [ ] `TEAM__<CODE>.yaml` valide
- [ ] Orchestrateur dans `agents_index.yaml`
- [ ] Au moins 1 playbook déclaré
- [ ] Routes dans `hub_routing.yaml`

**Étape 6.2 — Test de routage**

Tester via HUB-Concierge → OPS-RouterIA :
```
Input : "Je veux [action typique de l'équipe]"
Attendu : route vers <CODE>-Orchestrateur
```

**Étape 6.3 — Validation CTL**

Lancer `PB_CTL_01_FACTORY_HEALTH_CHECK.yaml` en mode `full` :
- CTL-WatchdogIA doit reconnaître la nouvelle équipe
- Aucune alerte critique sur les nouveaux agents

---

### PHASE 7 — Documentation et changelog (10 min)

- [ ] Mettre à jour `60_CHANGELOG/CHANGELOG.md`
- [ ] Mettre à jour `00_ROOT/MANIFEST.md`
- [ ] Mettre à jour `00_ROOT/REPO_HEALTH.md`
- [ ] Créer `90_KNOWLEDGE/INDEX__<CODE>.md` (index knowledge de l'équipe)

---

## Cas d'échec courants

| Symptôme | Cause | Résolution |
|----------|-------|------------|
| RouterIA route vers mauvaise équipe | Intent non déclaré dans `hub_routing.yaml` | Ajouter le mapping intent → équipe |
| Agent "fantôme" (cité mais non trouvé) | Non déclaré dans `agents_index.yaml` | Ajouter dans l'index |
| PlaybookRunner échoue à trouver l'orchestrateur | `team_id` mal typé ou `agent_id` incorrect | Vérifier casse et format |
| Validation refuse les fichiers | `schema_version` manquant dans agent.yaml | Ajouter `schema_version: "1.0"` |
| WatchdogIA ne scanne pas la nouvelle équipe | teams.yaml non mis à jour | Ajouter dans teams.yaml |

---

## Références

- `RUNBOOK__ADD_AGENT.md` — pour chaque agent individuel
- `PB_FAB_03_BUILD_TEAM_FROM_SCRATCH.yaml` — playbook complet de construction
- `PB_EXP_01_ONBOARD_NEW_TEAM.yaml` — onboarding avec validation business
- `00_INDEX/agents_index.yaml` — index central agents
- `40_ROUTING/hub_routing.yaml` — table de routage
