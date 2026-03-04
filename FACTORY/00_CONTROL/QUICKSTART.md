# Quickstart Root IA v3

## Pour utiliser un agent
1. Aller dans `20_AGENTS/<TEAM>/<AGENT>/`
2. Lire `prompt.md` — c'est le système prompt à copier dans le GPT
3. `contract.yaml` définit les inputs/outputs attendus

## Pour exécuter un workflow
1. Consulter `30_PLAYBOOKS/playbooks.yaml`
2. Suivre les steps dans l'ordre
3. Passer l'output de chaque step comme input du suivant

## Pour créer un nouvel agent
1. Utiliser META-AgentFactory
2. Ou copier un agent existant et personnaliser TOUT (pas de copier-coller!)
