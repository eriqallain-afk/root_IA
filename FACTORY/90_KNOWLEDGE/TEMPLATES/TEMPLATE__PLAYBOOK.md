# TEMPLATE — Playbook

Un playbook est une séquence d’étapes (steps) qui enchaîne des agents.

## 1) Ajouter dans `40_RUNBOOKS/playbooks.yaml`

Exemple (à adapter) :
```yaml
playbooks:
  <PLAYBOOK_ID>:
    description: "<1 phrase : objectif>"
    steps:
      - step: <step_name_1>
        actor_id: <AgentID_1>
      - step: <step_name_2>
        actor_id: <AgentID_2>
```

## 2) Documenter le playbook
Créer un fichier :
`40_RUNBOOKS/RUNBOOKS_MD/RUNBOOK__<PLAYBOOK_ID>.md`

Contenu recommandé :
- Objectif & scope
- Inputs attendus
- Outputs attendus
- Étapes (order) + responsabilités
- Critères qualité (DoD)
- Cas d’erreur / fallback

## 3) Raccorder au routage
Mettre à jour `80_MACHINES/hub_routing.yaml` :
- ajouter un intent → `playbook_id` ou `actor_id` selon votre wiring.

## 4) Valider
- `python scripts/validate_schemas.py`
- `bash validate_root_IA.sh`
