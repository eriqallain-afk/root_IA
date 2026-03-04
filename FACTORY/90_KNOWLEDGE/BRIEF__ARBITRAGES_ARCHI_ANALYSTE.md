# Brief — Arbitrages à faire avec l’Architecte & l’Analyste besoins

_Généré le 2026-01-17T21:19:45Z_

## 1) Granularité “chaque tâche”
- Version livrée : **44 nouveaux playbooks** couvrant les tâches majeures par équipe (plus les playbooks existants).
- Option plus granulaire : 1 playbook par *agent* (103) + QA + archivage (utile si vous voulez tout standardiser).

## 2) Stratégie de routage
- Aujourd’hui : `hub_routing.yaml` route surtout **par équipe** (niveau macro).
- Décision : router **par tâche** (intents plus précis) ou garder “équipe” puis délégation à l’orchestrateur d’équipe.

## 3) QA & conformité
- QA agents identifiés : `META-GouvernanceEtRisques`, `IASM-SecuriteRisques`, `DAM-GPT2-Conformite`.
- Décision : QA systématique (toutes tâches) ou seulement sur tâches à risque (santé, légal, sécurité, finances).

## 4) Documentation / Knowledge
- Pattern recommandé : finir les playbooks par `OPS-DossierIA` quand il y a un livrable.
- Décision : archivage obligatoire ou optionnel selon playbook.

## 5) Nommage / Versioning
- Convention proposée : `<TEAM>_<TASK>_V1`.
- Décision : versionner partout ou seulement en cas de breaking change.
