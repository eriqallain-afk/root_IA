# OPS Ready Pack — Quickstart
Generated: 2025-12-28T17:19:07Z

## Ce pack ajoute
- Runbooks détaillés (md)
- Templates mémoire (dossier projet + schéma event log)
- Integration packages (config + mapping)
- Policies OPS (SLA, incident severity, logging schema)
- Validateur strict + Makefile + CI (GitHub Actions)

## Démarrage
1) Vérifier:
   - `bash validate_root_IA.sh`
   - `python3 scripts/validate_strict.py`
2) Routing:
   - `REGISTRY/80_MACHINES/hub_routing.yaml`
3) Exécution:
   - `REGISTRY/40_RUNBOOKS/playbooks.yaml`
4) Mémoire:
   - `REGISTRY/90_MEMORY/memory.yaml`
   - `REGISTRY/90_MEMORY/TEMPLATES/project_dossier/`
