# INDEX — OPS (control plane / exécution)

## Mission
OPS opère “LA machine” : routage, exécution des playbooks, logging, SLA et gestion d’incidents.

## À lire / uploader (références)
### Source de vérité (CORE)
- `90_KNOWLEDGE/CONTEXT__CORE.md`

### Wiring et exécution
- Routage : `80_MACHINES/hub_routing.yaml`
- Playbooks : `40_RUNBOOKS/playbooks.yaml`
- Runbooks : `40_RUNBOOKS/RUNBOOKS_MD/*`

### Policies OPS
- Index policies : `50_POLICIES/POLICIES__INDEX.md`
- SLA : `50_POLICIES/ops/sla.md`
- Logging : `50_POLICIES/ops/logging_schema.md`
- Sévérité : `50_POLICIES/ops/incident_severity.md`

## Definition of Done (OPS)
- Routage cohérent (intents uniques, fallback défini)
- Playbooks exécutables (actors existants + contracts)
- Logging conforme policy
- SLA respecté et incident process documenté
