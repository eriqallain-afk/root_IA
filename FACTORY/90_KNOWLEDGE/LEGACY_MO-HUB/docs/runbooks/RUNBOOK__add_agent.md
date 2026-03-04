# RUNBOOK — Ajouter un agent (dans une TEAM)

1) Définir rôle, limites, outputs attendus
2) Impact: doublon ? quelle interface impactée ?
3) Créer AGENT__<slug>.yaml (ou entrée inventaire)
4) Mettre à jour TEAM__<slug>.yaml (agents:)
5) Tests: 2 normaux + 1 edge case
6) IP + double validation (IAHQ + META)
7) Changelog + Decision log
