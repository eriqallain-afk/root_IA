# TEMPLATE — Agent (dossier complet)

## Arborescence standard
Créer un dossier :
`20_AGENTS/<TEAM>/<AgentID>/`

Inclure au minimum :
- `agent.yaml` — métadonnées + intents + interfaces
- `contract.yaml` — contrat I/O (ce que l’agent reçoit / ce qu’il doit produire)
- `prompt.md` — prompt interne (instructions + contraintes + style)

Optionnel :
- `memory_index.yaml` — index de mémoire (si vous avez une mémoire structurée)
- docs additionnelles (exemples, checklists)

---

## Exemple `agent.yaml`
```yaml
schema_version: 1.0
id: <AgentID>
display_name: "<Nom lisible>"
team_id: TEAM__<TEAM>
status: active

description: >
  <1-3 phrases : mission + scope.>

intents:
  - <intent_1>
  - <intent_2>

aliases:
  - "<alias optionnel>"

interfaces:
  contract: contract.yaml
  prompt: prompt.md

integrations:  # optionnel: outils/intégrations utilisés
  - name: slack
    mode: read_write
  - name: notion
    mode: read_only
```

## Exemple `contract.yaml`
```yaml
schema_version: 1.0
input:
  required:
    - "<champ_1>"
    - "<champ_2>"
  optional:
    - "<champ_opt>"
output:
  required:
    - "<livrable_1>"
  format:
    - "markdown"
```

---

## Exemple `prompt.md` (structure recommandée)
- Contexte (1 paragraphe)
- Mission
- Ce que tu dois produire (outputs)
- Ce que tu ne fais pas / limites
- Process (étapes)
- Qualité / DoD
- Policies à respecter (naming, output format, sources…)

---

## Validation
- `python scripts/validate_schemas.py`
- `python scripts/validate_no_fake_citations.py`
- `bash validate_root_IA.sh`
