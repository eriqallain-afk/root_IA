# RUNBOOK — FACTORY : Intégration d'un Nouveau PRODUCT

**ID :** RB-FACTORY-008  
**Version** : 1.0.0  
**Trigger** : Un nouveau PRODUCT (ex: @IT, @DAM, @EDU) doit être intégré dans la FACTORY  
**Propriétaire** : META-OrchestrateurCentral + HUB-AgentMO + IAHQ-DevFactoryIA  
**SLA** : < 4 heures (intégration complète)  
**Mise à jour** : 2026-03-06  

---

## Principe fondamental

**Un PRODUCT est INDÉPENDANT de la FACTORY.**

```
FACTORY ──[bridge]──► PRODUCT
                         │
                    Propre OPS team
                    Propre Orchestrateur
                    Propre PlaybookRunner
                    Propre RouterIA
                    Propre DossierIA
```

La FACTORY ne gère PAS les opérations quotidiennes du PRODUCT.  
Le PRODUCT appelle la FACTORY uniquement pour : créer de nouveaux agents, auditer, optimiser.

---

## Architecture minimale d'un PRODUCT autonome

```
PRODUCT/<NOM>/
├── 10_TEAMS/
│   └── TEAM__<NOM>.yaml
├── 20_AGENTS/
│   ├── <NOM>-Orchestrateur/          ← Orchestrateur produit
│   ├── <NOM>-RouterIA/               ← OPS propre
│   ├── <NOM>-PlaybookRunner/         ← OPS propre
│   ├── <NOM>-DossierIA/              ← OPS propre
│   └── {agents spécialistes...}
├── 30_PLAYBOOKS/                      ← Playbooks propres
├── 40_RUNBOOKS/                       ← Runbooks propres
├── 40_ROUTING/                        ← Routing propre
├── 50_POLICIES/                       ← Policies propres
└── BRIDGE/
    ├── INCOMING/                      ← Demandes de la FACTORY (staging)
    ├── VALIDATED/                     ← Approuvées par le PRODUCT
    └── REJECTED/                      ← Refusées (avec raison)
```

---

## PHASE 1 — Vérification de l'autonomie du PRODUCT (30 min)

Avant intégration, confirmer que le PRODUCT possède :
- [ ] Orchestrateur propre avec prompt.md ≥ 150 lignes
- [ ] OPS team : RouterIA + PlaybookRunner + DossierIA
- [ ] Au moins 2 playbooks opérationnels propres
- [ ] Routing table propre (`hub_routing.yaml` ou équivalent)
- [ ] Runbook d'incident propre

**Si éléments manquants** : construire d'abord via `PB_FAB_03_BUILD_TEAM_FROM_SCRATCH.yaml`

---

## PHASE 2 — Déclaration dans la FACTORY (20 min)

**Étape 2.1 — `80_MACHINES/products_routing.yaml`**

Ajouter l'entrée PRODUCT :
```yaml
products:
  <NOM>:
    product_id: PRODUCT__<NOM>
    orchestrator: <NOM>-Orchestrateur
    bridge_path: PRODUCT/<NOM>/BRIDGE/
    status: active
    team: TEAM__<NOM>
    capabilities: ["<cap1>", "<cap2>"]
    factory_bridge:
      incoming: PRODUCT/<NOM>/BRIDGE/INCOMING/
      validated: PRODUCT/<NOM>/BRIDGE/VALIDATED/
      rejected: PRODUCT/<NOM>/BRIDGE/REJECTED/
```

**Étape 2.2 — `40_ROUTING/hub_routing.yaml`**

Ajouter les intents du PRODUCT :
```yaml
routes:
  - intent: "<intent_product>"
    target: <NOM>-Orchestrateur
    product: PRODUCT__<NOM>
    bridge: true
    confidence_threshold: 0.8
```

---

## PHASE 3 — Configuration du Bridge FACTORY ↔ PRODUCT (30 min)

Le bridge permet à la FACTORY de livrer de nouveaux agents au PRODUCT avec validation manuelle.

**Protocole INCOMING (FACTORY → PRODUCT)**
```
FACTORY produit nouvel agent → dépose dans BRIDGE/INCOMING/
PRODUCT review → 
  ✓ Accepté → copier vers BRIDGE/VALIDATED/ + intégrer dans 20_AGENTS/
  ✗ Rejeté → déplacer vers BRIDGE/REJECTED/ + note de raison
```

**Protocole OUTGOING (PRODUCT → FACTORY)**
```
PRODUCT demande amélioration/audit → 
  Appeler META-AgentProductFactory ou PB_OPT_02_ARMY_AUDIT_COMPLETE
  Résultats retournés dans BRIDGE/INCOMING/
```

---

## PHASE 4 — Tests d'intégration (30 min)

- [ ] Test de routage : HUB-Concierge → OPS-RouterIA → <NOM>-Orchestrateur
- [ ] Test bridge : FACTORY dépose agent → PRODUCT reçoit dans INCOMING/
- [ ] Test autonomie : PRODUCT exécute playbook sans appeler FACTORY
- [ ] CTL-WatchdogIA reconnaît le nouveau PRODUCT dans son scan
- [ ] CTL-HealthReporter inclut le PRODUCT dans le rapport global

---

## PHASE 5 — Documentation finale (15 min)

- [ ] `MANIFEST.md` mis à jour avec le nouveau PRODUCT
- [ ] `00_INDEX/gpt_catalog.yaml` mis à jour
- [ ] `60_CHANGELOG/CHANGELOG.md` entrée ajoutée
- [ ] `90_KNOWLEDGE/INDEX__<NOM>.md` créé

---

## Règles de gouvernance FACTORY ↔ PRODUCT

1. **La FACTORY ne commande pas** le PRODUCT — elle livre et propose
2. **Le PRODUCT valide** toute modification avant intégration (via BRIDGE)
3. **Pas de dépendance runtime** — le PRODUCT fonctionne si la FACTORY est down
4. **CTL surveille** les PRODUCTS mais ne les gère pas
5. **Indexes séparés** — agents du PRODUCT pas dans `agents_index.yaml` FACTORY

---

## Références

- `80_MACHINES/products_routing.yaml` — routing produits
- `PB_FAB_03_BUILD_TEAM_FROM_SCRATCH.yaml` — build team PRODUCT
- `PB_EXP_01_ONBOARD_NEW_TEAM.yaml` — onboarding complet
- `RUNBOOK__ADD_TEAM_COMPLETE.md` — ajout équipe interne
