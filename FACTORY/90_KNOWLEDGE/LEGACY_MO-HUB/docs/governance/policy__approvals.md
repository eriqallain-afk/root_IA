# Policy — Double validation (IAHQ + META)

Toute création/modification de TEAM / AGENT / IFACE / POLICY / RUNBOOK doit passer par un Integration Package (IP)
et obtenir deux validations :

## Validation 1 — IAHQ (Gouvernance)
- ownership clair (owner_orchestrator)
- périmètre IN/OUT
- risques (confidentialité, réputation, légal)
- critères d’acceptation (DoD)

## Validation 2 — META (Architecture GPT)
- agent cards complètes (rôle, limites)
- interfaces définies (inputs/outputs)
- tests minimum
- pas de doublon de capability

Sans les deux : statut = NO-GO.
