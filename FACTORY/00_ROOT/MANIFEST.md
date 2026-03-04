# root_IA — ALL-IN-ONE OPERATIONAL PACK
Generated: 2025-12-28T17:37:17Z

## Included packs
- Base Machine registry (agents, teams, intents, routing, playbooks, memory)
- OPS Ready (runbooks détaillés, templates mémoire, policies ops, intégrations, validateurs, CI)
- Production Ready (observability, security/governance, incidents)
- EDU Ready (MasterClass curriculum + modules + exercices + rubrics)
- META Factory Ready (templates + quality gates + examples)
- IAHQ Sales/Delivery Ready (offres + SOW + livrables)

## Validate
- bash validate_root_IA.sh
- python3 scripts/validate_strict.py

## Start here
- REGISTRY/00_CONTROL_PLANE/CONTROL_PLANE.yaml
- REGISTRY/80_MACHINES/hub_routing.yaml
- REGISTRY/40_RUNBOOKS/playbooks.yaml
- REGISTRY/90_MEMORY/memory.yaml

## Global Memory Objects (auto-regenerated)
- 90_MEMORY/MEM-PlaybooksGlobal.yaml
- 90_MEMORY/MEM-AgentsGlobal.yaml
- 90_MEMORY/MEM-TeamsGlobal.yaml
- 90_MEMORY/MEM-IntentsGlobal.yaml
- 90_MEMORY/MEM-RoutingGlobal.yaml
- 90_MEMORY/MEM-CapabilitiesGlobal.yaml
- 90_MEMORY/MEM-RunbooksGlobal.yaml
- 90_MEMORY/MEM-IntegrationPackagesGlobal.yaml
- 90_MEMORY/MEM-QualityGatesGlobal.yaml

## Validation & Schemas
- SCHEMAS/
- scripts/lint_yaml.py
- scripts/validate_schemas.py
- scripts/run_golden_tests.py
- tests/golden/
- .github/workflows/validate_windows.yml
- GOVERNANCE/
## v5 ULTIMATE additions
- tests/golden_outputs/
- scripts/validate_machine_output.py
- scripts/new_agent_wizard.py
- scripts/new_playbook_wizard.py
- scripts/registry_lock.py
- scripts/version_bump.py
- scripts/one_click_windows.ps1
- REGISTRY_LOCK.json (generated)
## Source Integrity
- 50_POLICIES/SOURCE_ATTRIBUTION.yaml
- scripts/validate_no_fake_citations.py
- 90_MEMORY/MEM-EvidenceRegister.yaml

