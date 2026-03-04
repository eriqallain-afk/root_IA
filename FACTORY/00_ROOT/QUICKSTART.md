# QUICKSTART — root_IA (All-in-one)
Generated: 2025-12-28T17:37:17Z

## 1) Validation
```bash
bash validate_root_IA.sh
python3 scripts/validate_strict.py  # exécute la suite complète de validations
```

## 2) Routing
- Edit: `REGISTRY/80_MACHINES/hub_routing.yaml`
- Index intents: `REGISTRY/00_INDEX/intents.yaml`

## 3) Exécution (concept)
- Router -> PlaybookRunner -> DossierIA
- Playbooks: `REGISTRY/40_RUNBOOKS/playbooks.yaml`

## 4) Mémoire
- Policies: `REGISTRY/90_MEMORY/memory.yaml`
- Template dossier: `REGISTRY/90_MEMORY/TEMPLATES/project_dossier/`

## 5) Delivery
- Offres & livrables: `REGISTRY/90_KNOWLEDGE/IAHQ_SALES_DELIVERY/`
- Templates META: `REGISTRY/90_KNOWLEDGE/META_FACTORY/`
- MasterClass: `REGISTRY/90_KNOWLEDGE/EDU_MASTERCLASS/`