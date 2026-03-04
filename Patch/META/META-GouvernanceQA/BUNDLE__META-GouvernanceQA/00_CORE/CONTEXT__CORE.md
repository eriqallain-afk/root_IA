# CONTEXT — CORE (source de vérité)

Ce fichier est la **porte d’entrée** pour comprendre le dépôt `root_IA` : qui fait quoi, comment s’orchestrent les équipes, et comment ajouter de nouveaux agents sans casser la structure.

> Usage recommandé : uploade ce fichier dans les prompts internes (META / IAHQ / OPS), puis uploade le bundle spécifique à l’équipe.

---

## 1) Vue d’ensemble

### Objectif du dépôt
- Définir des **équipes** (TEAM) et des **agents** (GPT) standardisés.
- Définir des **playbooks** (enchaînements d’agents) et le **routage** (intents → acteurs).
- Définir des **policies** (règles) et des **schemas** (contrats de fichiers) pour éviter la dérive.

### Orchestrateurs globaux
- **MO** : `HUB-AgentMO-MasterOrchestrator` — mémoire “qui fait quoi”, coordination, intégration.
- **MO2** : `HUB-AgentMO2-DeputyOrchestrator` — assistant qualité/recette, checklists, cohérence.

### Machine d’exécution (OPS)
- `OPS-RouterIA` : choisit le bon playbook / acteur selon l’intent.
- `OPS-PlaybookRunner` : exécute le playbook (séquence).
- `OPS-DossierIA` : archive / mémoire opérationnelle / traçabilité.

---

## 2) Carte du dépôt (où trouver quoi)

- `10_TEAMS/` : définitions d’équipes (`TEAM__*.yaml`) + index `teams.yaml`.
- `20_AGENTS/` : agents par équipe. Chaque agent a au minimum :
  - `agent.yaml` (métadonnées / intents / interfaces)
  - `contract.yaml` (contrat I/O)
  - `prompt.md` (prompt interne)
- `40_RUNBOOKS/` :
  - `playbooks.yaml` (définitions des playbooks)
  - `RUNBOOKS_MD/` (docs opérationnelles)
- `50_POLICIES/` : règles (naming, output format, sources, sécurité IASM, policies OPS…)
- `SCHEMAS/` : schémas JSON (validation des fichiers YAML)
- `80_MACHINES/` : routage et “wiring” (ex. `hub_routing.yaml`)
- `90_MEMORY/` : index mémoire (si applicable)
- `90_KNOWLEDGE/` : templates, guides, bundles uploadables
- `70_INTEGRATION_PACKAGES/` : connecteurs (Slack, Notion, M365, etc.) + copie des schemas (référence)

---

## 3) Fichiers “canon” à connaître

- Inventaire équipes : `10_TEAMS/teams.yaml`
- Inventaire agents : `20_AGENTS/**/agent.yaml`
- Playbooks : `40_RUNBOOKS/playbooks.yaml`
- Routage : `80_MACHINES/hub_routing.yaml`
- Policies : `50_POLICIES/POLICIES__INDEX.md`
- Schemas : `SCHEMAS/*.schema.json`

---

## 4) Ajouter un nouvel agent (résumé)
1. Créer un dossier `20_AGENTS/<TEAM>/<AgentID>/`
2. Ajouter :
   - `agent.yaml` (voir template)
   - `contract.yaml` (voir template)
   - `prompt.md`
3. Mettre à jour si besoin :
   - `40_RUNBOOKS/playbooks.yaml` (si un playbook l’utilise)
   - `80_MACHINES/hub_routing.yaml` (si routable par intent)
4. Valider (scripts + checks).

Voir : `40_RUNBOOKS/RUNBOOKS_MD/RUNBOOK__ADD_AGENT.md` et `90_KNOWLEDGE/TEMPLATES/TEMPLATE__AGENT.md`.

---

## 5) Ajouter un playbook (résumé)
1. Définir l’objectif + I/O du playbook
2. Ajouter l’entrée dans `40_RUNBOOKS/playbooks.yaml`
3. Ajouter un runbook doc dans `40_RUNBOOKS/RUNBOOKS_MD/`
4. Raccorder au routage (`80_MACHINES/hub_routing.yaml`)

Voir : `40_RUNBOOKS/RUNBOOKS_MD/RUNBOOK__CREATE_PLAYBOOK.md` et `90_KNOWLEDGE/TEMPLATES/TEMPLATE__PLAYBOOK.md`.

---

## 6) Qualité — commandes de validation (local)
- `bash validate_root_IA.sh`
- `python scripts/validate_schemas.py`
- `python scripts/validate_no_fake_citations.py`

---

_Généré le 2026-01-05T00:47:21Z_
