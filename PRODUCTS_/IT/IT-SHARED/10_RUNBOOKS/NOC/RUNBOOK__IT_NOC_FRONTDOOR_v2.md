# RUNBOOK — IT_NOC_FRONTDOOR (v2.0)
# Mise à jour : ajout IT-Commandare-Infra dans le flux

## Objectif
Traiter un événement NOC de bout en bout avec routage intelligent selon le type d'incident.

## Flux principal (avec branchement par type)

```
Événement entrant
        │
        ▼
Step 1 — IT-NOCDispatcher
  → Qualifier, prioriser, SLA, assignation initiale
  → Décision : type d'incident ?
        │
        ├─ Type: INFRA/CLOUD (server/vm/dc/azure/backup/storage)
        │         └─► Step 2A — IT-Commandare-Infra  ← NOUVEAU
        │                   → Lead technique infra, mobilise spécialiste(s)
        │                   → Si P1 multi : parallel tracks + IT-CTOMaster
        │
        ├─ Type: TECHNIQUE GÉNÉRAL (RCA, bug, remédiation complexe non-infra)
        │         └─► Step 2B — IT-Commandare-TECH
        │                   → Diagnostic, hypothèses, plan remédiation
        │
        ├─ Type: ALERTE CORRÉLATION (multiple alertes, impact scope inconnu)
        │         └─► Step 2C — IT-Commandare-NOC
        │                   → Corrélation, scope, paging, coordination
        │
        └─ Type: MONITORING NOISE / P4
                  └─► Clore ou planifier — pas d'escalade Commandare
        │
        ▼
Step 3 — IT-Commandare-OPR  (toujours si ticket ouvert)
  → Vérification DoD, fermeture ticket, standardisation

Step 4 — OPS-DossierIA
  → Archivage, audit trail
```

## Étapes (order — incident INFRA type)
1. `dispatch`     — IT-NOCDispatcher
2. `infra_lead`   — IT-Commandare-Infra       ← NOUVEAU
3. `tech_lead`    — IT-Commandare-TECH         (si RCA approfondi requis)
4. `noc_lead`     — IT-Commandare-NOC          (si corrélation multi-alertes)
5. `ops_control`  — IT-Commandare-OPR
6. `archive`      — OPS-DossierIA

## Notes d'exécution (branching logique)

- **IT-Commandare-Infra** prend le lead dès que le domaine est identifié comme infra/cloud.
  - Il mobilise directement `IT-InfrastructureMaster`, `IT-CloudMaster`, `IT-BackupDRMaster` ou `IT-NetworkMaster`.
  - `IT-Commandare-TECH` est activé EN PARALLÈLE ou EN SUITE si une RCA générale est requise.
  - `IT-Commandare-NOC` reste en support pour la coordination globale sur les P1.

- Si NOCDispatcher classe `monitoring_noise` → pas d'activation Commandare.
- Si incident P1 INFRA multi-domaines → IT-CTOMaster notifié par IT-Commandare-Infra.
- OPR finalise toujours si un ticket/incident est ouvert.

## Famille Commandare complète (v2)

| Agent | Rôle | Activé quand |
|-------|------|-------------|
| IT-NOCDispatcher | 1er contact, triage, SLA | Toujours en premier |
| IT-Commandare-NOC | Corrélation alertes, coordination NOC | Alertes multiples, scope inconnu |
| **IT-Commandare-Infra** | Lead infra/cloud incidents | Domaine = server/vm/dc/azure/backup/storage |
| IT-Commandare-TECH | RCA, remédiation technique | Diagnostic profond, bug, rollback |
| IT-Commandare-OPR | Fermeture, DoD, standardisation | Toujours en fin de ticket |

## Definition of Done (DoD)
- Classification + domaine infra identifié
- Spécialiste(s) mobilisé(s) avec tâches claires
- Actions immédiates documentées (0-15 min)
- Plan de validation post-fix défini
- Logs complétés (trace_id)
- Si fermeture : critères DoD remplis ou manquants explicités
