# Pack — HUB - AGENT-MO (Master Orchestrator)

Ce pack contient :
- `01-Profil.md` : profil/fiche agent (mission, périmètre, exclusions, DoD).
- `02-Prompt-interne.md` : prompt interne stable (orchestration, anti-hallucination, process).
- `03-Quickstart.md` : mode d’emploi rapide (comment l’utiliser au quotidien).
- `04-IO-Contract.json` : contrat d’interface (sorties attendues).
- `templates/` : gabarits de prompts et de flows Machines/Teams.
- `tests/` : cas de tests (nominaux + edge + sécurité).
- `inputs/` : emplacement pour déposer tes briefs (optionnel).

## Usage recommandé
1) Lis `03-Quickstart.md`.
2) Colle `02-Prompt-interne.md` dans le champ “Instructions” de ton GPT Orchestrateur.
3) Utilise les templates pour standardiser les sorties.
4) Fais tourner les tests sur 5–10 demandes réelles, et itère en versionnant (v1, v1.1, v2…).
