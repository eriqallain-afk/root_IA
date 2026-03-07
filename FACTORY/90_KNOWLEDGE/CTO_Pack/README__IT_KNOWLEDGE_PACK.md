# IT CTOMaster — Knowledge Pack v1
_Date: 2026-01-21_

Ce pack est conçu pour être importé dans la section **Knowledge** de ton GPT **IT-CTOMaster** (GPT Editor → Configure → Knowledge).
Objectif : donner au CTOMaster des **templates**, **matrices**, et **règles de routage** stables, sans surcharger le champ **Instructions**.

## Recommandation de répartition
- **Instructions (court)** : Mission, IN/OUT, règles d’or, escalades, formats obligatoires, autorité.
- **Knowledge (ce pack)** : Matrice de sévérité, templates (RFC, post-mortem, comms), standards CMDB, KPI, routing rules, exemples.

## Contenu
1. `IT__Routing_Rules.md` — événements → owner → escalade → outputs attendus  
2. `IT__Severity_Matrix.md` — S0–S4 + cadence updates + triggers post-mortem  
3. `IT__RFC_Light_Template.md` — format standard pour INFRA (+ go/no-go)  
4. `IT__Comms_Templates.md` — messages client/interne (incident, change, maintenance)  
5. `IT__Postmortem_Template.md` — template post-mortem + CAPA  
6. `IT__KPI_Definitions.md` — définitions KPI (MTTD/MTTR, SLA, change failure rate, etc.)  
7. `IT__CMDB_Standards.md` — champs obligatoires + règles de MAJ  
8. `IT__Escalation_Playbook.md` — “who to call when” + critères  
9. `IT__Glossary.md` — glossaire court (pour éviter les malentendus)  
10. `EXAMPLES__Incident_and_Change.md` — 2 exemples complets (incident + RFC)

## Conseils d’usage
- Demande au CTOMaster de **citer le fichier** qu’il applique (ex : “selon IT__Severity_Matrix.md”).
- Si tu changes un process, incrémente : v1 → v1.1 (templates) → v2 (process).
