# RUNBOOK — Ajouter un nouvel agent (standard root_IA)

## Objectif
Ajouter un agent (GPT) de manière **traçable**, **sans casser les validations**, et en le rendant immédiatement “routable” par MO.

---

## 1) Choisir l’emplacement
Les agents vivent dans `20_AGENTS/<TEAM>/<AGENT_ID>/`

Exemple :
`20_AGENTS/IT/IT-NOCDispatcher/`

Conventions :
- `TEAM` = dossier en MAJUSCULES (IAHQ, META, OPS, HUB, IT, IASM, NEA, TRAD, DAM, PLR, ESPL…)
- `AGENT_ID` = stable, sans espaces, format recommandé : `TEAM-NomRole`

---

## 2) Créer les 3 fichiers obligatoires
Dans le dossier de l’agent :

### a) `agent.yaml`
- id
- display_name
- team_id / team_name
- description
- intents (mots-clés)
- status: active

### b) `prompt.md`
- rôle clair
- règles de sortie (si MODE MACHINE → YAML strict)
- sources de vérité (index, policies, schemas)

### c) `contract.yaml`
- input / output selon `schema_version: 1.0`
- respecter les champs attendus (result, artifacts, next_actions, log)

---

## 3) Mettre à jour les index
### a) `00_INDEX/agents_index.yaml`
Ajouter l’entrée de l’agent + intents.

### b) `00_INDEX/capability_map.yaml`
Relier l’agent à ses capacités (fonctionnel : “ce qu’il sait faire”).

### c) `00_INDEX/teams_index.yaml`
Si nouvelle équipe : ajouter TEAM__XXX + description.

### d) `00_INDEX/intents.yaml`
Si nouveaux intents : les déclarer (éviter les doublons).

---

## 4) Si l’agent s’insère dans une Machine (playbook)
- Créer/mettre à jour le playbook dans `40_RUNBOOKS/playbooks.yaml`
- Si Machine dédiée : indexer dans `00_INDEX/machines_index.yaml`
- Si routage requis : mettre à jour `80_MACHINES/hub_routing.yaml`

---

## 5) Valider localement
Exécuter :
```bash
bash validate_root_IA.sh
python3 scripts/validate_schemas.py
python3 scripts/validate_no_fake_citations.py
python3 scripts/validate_golden_tests.py
```

---

## 6) Definition of Done (DoD)
- L’agent apparaît dans `agents_index.yaml`
- Au moins 1 intent permet de le retrouver
- Les validations passent
- MO peut décrire : “quand l’utiliser” + “avec quoi il s’enchaîne”
