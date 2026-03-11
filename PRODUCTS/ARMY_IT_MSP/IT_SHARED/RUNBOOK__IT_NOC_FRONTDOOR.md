# RUNBOOK — IT_NOC_FRONTDOOR

## Objectif
Traiter un événement NOC de bout en bout :
1) triage & dispatch (NOCDispatcher)
2) lead technique si nécessaire (Commandare-TECH)
3) lead NOC si nécessaire (Commandare-NOC)
4) contrôle ops / ticket / DoD (Commandare-OPR)
5) archivage (OPS-DossierIA)

## Inputs attendus
- Alerte/événement (title/description/raw/source/severity_hint/affected)

## Outputs attendus
- Décision de dispatch, plan d’action, update ticket-ready, checklist fermeture, logs.

## Étapes (order)
1. `dispatch` — IT-NOCDispatcher
2. `tech_lead` — IT-Commandare-TECH
3. `noc_lead` — IT-Commandare-NOC
4. `ops_control` — IT-Commandare-OPR
5. `archive` — OPS-DossierIA

## Notes d’exécution (branching logique)
- Si NOCDispatcher classe `monitoring_noise`, Commandare-TECH peut être “no-op”.
- Si c’est un incident technique (P1/P2), TECH est prioritaire et NOC assiste (paging/corrélation).
- OPR finalise toujours si un ticket/incident est ouvert.

## Definition of Done (DoD)
- Classification + justification
- Actions immédiates identifiées (0–15 min)
- Si incident: mitigation plan + next update time
- Si fermeture: critères remplis ou manquants explicités
- Logs complétés

