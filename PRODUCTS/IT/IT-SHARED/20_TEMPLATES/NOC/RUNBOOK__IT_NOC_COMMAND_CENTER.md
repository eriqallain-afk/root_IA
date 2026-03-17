# RUNBOOK — IT NOC Command Center

## Objectif
Ce runbook formalise le routage et l’usage des 4 agents IT suivants :
- `IT-NOCDispatcher` : dispatch / SLA / escalade
- `IT-Commandare-NOC` : triage NOC / corrélation / sévérité
- `IT-Commandare-TECH` : troubleshooting / RCA / remediation
- `IT-Commandare-OPR` : gouvernance ops / communication / coordination

## Playbooks
- `IT_NOC_DISPATCH` → `IT-NOCDispatcher`
- `IT_COMMANDARE_NOC` → `IT-Commandare-NOC`
- `IT_COMMANDARE_TECH` → `IT-Commandare-TECH`
- `IT_COMMANDARE_OPR` → `IT-Commandare-OPR`

## Routage (80_MACHINES/hub_routing.yaml)
Le routage est **déterministe** via intents dédiés :
- `it_noc_dispatch` / `noc_dispatch` / `noc_dispatcher`
- `it_commandare_noc` / `noc_triage`
- `it_commandare_tech` / `tech_escalation`
- `it_commandare_opr` / `ops_control`

Ces routes doivent être **prioritaires** par rapport à la route IT générique (MSP).

## Références
- `CONTEXT__CORE.md`
- `50_POLICIES/POLICIES__INDEX.md`
- `50_POLICIES/ops/incident_severity.md`
- `50_POLICIES/ops/sla.md`
- `50_POLICIES/ops/logging_schema.md`
