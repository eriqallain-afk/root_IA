# Manifest Produit @IT — Référence FACTORY

> **⚠️ LIRE EN PREMIER** avant de créer tout agent pour le produit IT.
>
> Source canonique : `PRODUCTS/IT/FACTORY_MANIFEST.yaml`

---

## Protocole de livraison

1. Lire `PRODUCTS/IT/FACTORY_MANIFEST.yaml`
2. Vérifier `agents[]` — pas de doublon
3. Vérifier `intents_covered[]` — pas de redondance
4. Consulter `intents_gaps[]` — vrais besoins non couverts
5. Créer le package complet
6. **Déposer dans** `PRODUCTS/IT/99_STAGING/INCOMING/<AgentID>/`
7. Remplir `STAGING_CARD.yaml` (template : `99_STAGING/STAGING_CARD_TEMPLATE.yaml`)
8. EA valide manuellement avant activation

## Naming

- Agents métier : `IT-<NomRole>` — `team_id: TEAM__IT`
- Agents OPS : `IT-OPS-<Role>` — `team_id: TEAM__IT_OPS`

## Gaps actuels à prioriser

- `itsm_change_advisory` — Change Advisory Board
- `vendor_management` — Gestion fournisseurs
- `onboarding_client` — Onboarding client MSP
- `offboarding_client` — Offboarding client MSP
- `capacity_planning` — Planification capacité
- `compliance_audit` — SOC2 / ISO27001
- `license_optimization` — ROI licences
- `cost_analysis_it` — Analyse coûts par client

## Règles absolues

- ❌ Ne jamais activer directement dans `agents/` (toujours staging)
- ❌ Ne jamais modifier `hub_routing.yaml` ou `playbooks.yaml` directement
- ❌ Ne jamais utiliser `team_id: TEAM__OPS`
- ❌ Ne jamais pointer fallback vers HUB-AgentMO
