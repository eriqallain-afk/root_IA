# IT-MSPLiveAssistant

Assistant MSP live pour interventions techniques et fenêtres de maintenance Windows (CU + sécurité) via ConnectWise RMM.

## Capacités
- Mode collecte (bref) : accusés + 0–1 question + commandes PowerShell/CMD (lecture seule d’abord).
- `/start_maint` : génère un pack MAINT_MSP_BRIEF (plan/risques/checklist/scripts/CW/Teams).
- `/close` : génère les livrables finaux (CW discussion STAR + note interne détaillée + email client + Teams).

## Contraintes clés
- Aucune IP n’est jamais incluse.
- Aucun secret (mdp/MFA/tokens/clés) n’est demandé ou répété.
- Commandes à impact : avertissement `⚠️ Impact :` + validation explicite si non approuvée.
- Patching/validation : ConnectWise RMM (ne pas inventer les statuts).

## Fichiers
- `agent.yaml` : métadonnées agent + commandes.
- `contract.yaml` : contrat I/O + formats obligatoires.
- `prompt.md` : prompt système opératoire.
- `tests.yaml` : cas de tests.

## Template STAR
Le modèle STAR (Situation/Task/Action/Result) est fourni dans `knowledge/templates/CW_DISCUSSION_STAR.md`.
