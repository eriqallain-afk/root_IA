# Decision Log — IA-factory (Source of Truth)

Objectif : consigner les décisions structurantes (gouvernance, standards, architecture, intégrations).
Règle : toute décision importante = 1 entrée ici + lien vers le(s) fichier(s) impactés.

## Statuts
- PENDING : en attente de validation
- APPROVED : validé (décision actée)
- REJECTED : refusé (on documente pourquoi)
- SUPERSEDED : remplacé par une nouvelle décision

## Format d’une décision
- ID : DEC-YYYYMMDD-###
- Validations : IAHQ + META (quand applicable)

---

## DEC-20251215-001 — Création du Master Orchestrator (MO) + Backup (MO2)
- Date : 2025-12-15
- - Added decision_log.md (governance source of truth)
- Statut : PENDING

### Contexte
On veut un point d’entrée unique pour orchestrer toutes les équipes, avec un backup et un audit, sans casser les équipes déjà fonctionnelles.

### Options considérées
1) Pas de MO (orchestration distribuée par équipe)
2) 1 MO unique sans backup
3) 1 MO + 1 MO2 (backup + auditeur)  ✅

### Décision
Mettre en place :
- AGENT-MO (Master Orchestrator)
- AGENT-MO2 (Deputy / Backup + Audit)

### Conséquences attendues
- + Cohérence (standards, interfaces, versioning)
- + Continuité (backup)
- - Risque de goulot d’étranglement si MO fait trop (MO doit rester “control plane”)

### Artefacts / fichiers liés
- REGISTRY/20_AGENTS/AGENT__mo.yaml
- REGISTRY/20_AGENTS/AGENT__mo2.yaml
- REGISTRY/00_INDEX/agents_index.yaml (si utilisé)

### Validations
- IAHQ : PENDING (nom/initiales : ____ )
- META : PENDING (nom/initiales : ____ )

---

## DEC-20251215-002 — Mise en place de la double validation (IAHQ + META) pour toute intégration
- Date : 2025-12-15
- Statut : PENDING

### Contexte
Pour intégrer de nouvelles équipes/agents sans chaos, on impose une validation gouvernance + une validation architecture agents.

### Options considérées
1) Validation unique IAHQ
2) Validation unique META
3) Double validation IAHQ + META ✅

### Décision
Toute intégration/modification touchant TEAM/AGENT/IFACE/POLICY/RUNBOOK doit être approuvée par :
- IAHQ (gouvernance / risques / critères d’acceptation)
- META (architecture agents / interfaces / tests)

### Conséquences attendues
- + Moins de régressions et de doublons
- + Onboarding plus propre
- - Légère friction (compensée par templates IP + checklists)

### Artefacts / fichiers liés
- REGISTRY/50_POLICIES/policy__approvals.md
- REGISTRY/70_INTEGRATION_PACKAGES/TEMPLATE__ip.md

### Validations
- IAHQ : PENDING (nom/initiales : ____ )
- META : PENDING (nom/initiales : ____ )

---
