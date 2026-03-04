# PATCH__ADD_IT_MSP_DISPATCH_PLAYBOOK_V1 (SAFE)

## Ce que fait ce patch
- Ajoute un **nouveau playbook** dans `playbooks.yaml` :
  - `IT_MSP_CONNECTWISE_DISPATCH_V1`

## Ce que ce patch NE fait PAS
- Ne modifie pas `hub_routing.yaml`
- Ne change pas le playbook par défaut (`IT_MSP_TICKET_TO_KB`)
- N'active aucune intégration

## Comment l'appliquer sans casser
Option 1 (recommandée):
1) Copier-coller le bloc YAML de `playbooks.addition.yaml` dans votre `playbooks.yaml` sous `playbooks:`
2) Valider `actor_id` (doivent exister)
3) Ne pas changer le routage tant que ce n'est pas testé

Option 2:
- Remplacer votre `playbooks.yaml` par `playbooks.full.yaml` **uniquement** si vous avez fait une sauvegarde
  et si vous voulez intégrer directement le nouveau playbook.

## Activation (plus tard)
Quand vous serez prêts, il faudra mettre à jour `hub_routing.yaml` pour router un intent IT vers `IT_MSP_CONNECTWISE_DISPATCH_V1`.