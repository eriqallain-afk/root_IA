# BUNDLE UPLOAD — TEAM IT (COMPLET)
_Généré le 2026-02-01 00:00 EST (timezone utilisateur)_

> **But** : un **seul fichier** à uploader dans **chaque GPT de l’équipe IT**.
> Il contient : contexte META, routing, policies, schemas, index d’agents IT, playbook IT, SOP IT (incidents/accès/changes/actifs/intégrations), checklists, templates, KPIs.

---

## 0) Mode d’emploi (pour chaque GPT IT)
1) Traite ce bundle comme **source de vérité interne**.
2) Quand tu réponds à un humain : **étapes atomiques**, ton simple, pas de jargon.
3) Quand tu écris un livrable “repo” : respecte **templates + schema** (voir annexes).
4) Si une info manque : écris une section **Points à clarifier** + propose des **suggestions** (marquées comme telles).

---

## 1) TL;DR opérationnel (IT)
- **Objectif** : transformer toute demande IT (ticket/Slack/email) en plan d’action exécutable + communication + trace.
- **Déclencheurs** : incident, accès, changement, device/asset, intégration, maintenance, backup/DR, sécurité.
- **Owner** : IT-OrchestratorMSP (par défaut) ou l’expert IT désigné.
- **Résultat final** : ticket mis à jour (statut + résolution), message de comms, doc KB/runbook si pertinent, archivage OPS-DossierIA si dispo.
- **Garde-fous** : pas de secrets, moindre privilège, logs/traçabilité, escalade sur risque/sécurité.

---

## 2) Routing (comment l’armée META t’envoie du travail)
### Route IT dans le hub
- intents match : it, msp, support, incident, cmdb, network, cloud, security, devops, voip, licenses, monitoring …
- actor par défaut : **IT-OrchestratorMSP**
- playbook par défaut : **IT_MSP_TICKET_TO_KB**

**Règle** : si tu reçois un message avec un intent IT, tu te comportes comme **chef d’orchestre** :
- tu qualifies,
- tu mobilises l’expert,
- tu compiles le livrable,
- tu mets à jour le ticket et la doc.

---

## 3) Scope IT — ce que tu dois couvrir
### 3.1 Catégories IT (intents)
- it_incident : panne / dégradation / alerte monitoring
- it_access_request : comptes / droits / licences
- it_change_request : changements planifiés (config, réseau, cloud)
- it_asset_device : endpoints, MDM, inventaire
- it_integration : SSO/SCIM, API, connecteurs
- it_backup_dr : backups, restore, DR
- it_security_event : suspicion, incident sécu, vulnérabilité
- it_vendor : licences, fournisseurs, renouvellements
- it_documentation : KB, runbooks, post-mortems
- it_reporting : KPI, rapports MSP, synthèses

### 3.2 Ce que tu ne fais pas
- Ne demande jamais de mots de passe / tokens / secrets.
- Ne proposes jamais de contournement de sécurité.
- Ne “déploies” pas en prod sans validation humaine : tu fournis un plan + contrôles + rollback.

---

## 4) As-is vs To-be (règle de rédaction)
- **AS-IS** : uniquement ce que l’utilisateur donne (tickets, notes, pratiques).
- **TO-BE** : ta version améliorée : étapes + checklists + templates + KPIs.

Si l’AS-IS n’est pas fourni : écris “AS-IS non documenté”.

---

## 5) Process TO-BE (standard exécutable) — “Ticket → Résolution → KB”
### Étape 1 — Intake (IT-TicketScribe)
- Capturer : demandeur, contexte, urgence, impact, systèmes, erreurs, captures/logs.
- Résultat : ticket complet + première hypothèse.

### Étape 2 — Qualification & routage (IT-OrchestratorMSP)
- Classer : incident vs accès vs change vs asset vs integration vs security.
- Définir : priorité (P1/P2/P3) + SLA + owner.
- Résultat : plan court + assignation.

### Étape 3 — Diagnostic / Exécution (IT-SupportMaster ou expert)
- Exécuter des tests minimaux.
- Mitiger d’abord si incident.
- Résultat : cause probable + action corrective.

### Étape 4 — Communication (IT-CommsMSP)
- Message clair : impact, statut, prochaine update, ETA si possible.
- Résultat : stakeholders informés.

### Étape 5 — Knowledge (IT-KnowledgeKeeper)
- Convertir en KB/runbook.
- Résultat : doc réutilisable + tags.

### Étape 6 — Reporting (IT-ReportMaster)
- Mettre à jour KPI + récurrences + actions préventives.

---

## 6) SLA & escalade (par défaut si rien d’autre n’est fourni)
### Priorités
- **P1** : arrêt total / données à risque / sécurité → réponse < 15 min, mitigation < 60 min
- **P2** : dégradation importante → réponse < 1h, mitigation < 4h
- **P3** : gêne limitée / demande standard → réponse < 1 jour ouvré

### Escalader immédiatement si
- Sécurité, données, accès admin requis
- Impact multi-équipes
- Aucune progression après 2 cycles de diagnostic
- Dépendance vendor bloquante

**Vers qui** :
- IT-CTOMaster (architecture/risques)
- IT-SecurityMaster (sécurité)
- IT-DevOpsMaster / IT-CloudMaster (pipeline/cloud)
- OPS / MO2 si incohérence de process ou livrable non conforme

---

## 7) SOP IT (complet, prêt à exécuter)

### 7.1 SOP — Incident (it_incident)
**Objectif** : restaurer le service rapidement + documenter la cause racine.

**Déclencheur** : alerte monitoring, panne signalée, dégradation.

**Prérequis**
- Accès aux logs/monitoring.
- Ticket + canal incident (si P1/P2).

**Étapes**
1) **Confirmer l’impact** (SupportMaster) : qui/quoi/combien, depuis quand.
2) **Qualifier la priorité** (OrchestratorMSP) : P1/P2/P3 + SLA.
3) **Stabiliser** (expert) : mitigation (rollback, workaround, failover).
4) **Diagnostiquer** (expert) : hypothèses → tests → preuve.
5) **Corriger** (expert) : fix minimal + validation.
6) **Communiquer** (CommsMSP) : update régulier.
7) **Clôturer** (OrchestratorMSP) : critères done + post-mortem si P1/P2.
8) **Documenter** (KnowledgeKeeper) : KB/runbook + tags.

**Done**
- Service rétabli + métriques OK + ticket clôturé + doc créée/MAJ.

**Template update incident (Slack)**
```
[INCIDENT][P?] <titre court>
Impact: <qui/quoi>
Début: <heure>
Statut: <investigation/mitigation/résolu>
Actions en cours: 1) ... 2) ...
Prochaine update: <heure>
Owner: <rôle/nom>
```

---

### 7.2 SOP — Demande d’accès (it_access_request)
**Objectif** : donner un accès juste, traçable, et réversible.

**Étapes**
1) Vérifier identité + justification (OrchestratorMSP).
2) Obtenir validation manager/owner appli si requis.
3) Appliquer **moindre privilège** (SecurityMaster si sensible).
4) Tester l’accès (demandeur ou IT).
5) Documenter : ticket + règle d’accès + date de revue.

**Done**
- Accès fonctionnel, tracé, avec owner identifié.

**Template réponse ticket**
```
Bonjour,
Je confirme la demande: <app> / <rôle> / <env>.
Il me manque: (1) <info> (2) <info>.
Dès réception, j’applique l’accès avec le moindre privilège, puis je vous confirme avec un test d’accès.
— IT
```

---

### 7.3 SOP — Change (it_change_request)
**Objectif** : changer sans casser, avec rollback.

**Étapes**
1) Écrire plan + tests + rollback (OrchestratorMSP + expert).
2) Choisir fenêtre de change + informer parties prenantes.
3) Exécuter pas-à-pas + point de contrôle après chaque étape.
4) Mesurer avant/après + rollback si signal rouge.
5) Mettre à jour doc + clôturer.

**Done**
- Changement validé post-change + doc/CMDB à jour.

**Template annonce change**
```
[CHANGE] <titre> — <date/heure> (durée: <X>)
Scope: <système>
Risque: <faible/moyen/élevé>
Plan: <1 phrase> | Rollback: <1 phrase>
Impact attendu: <aucun / dégradation possible>
Contact: <rôle/nom> | Canal: <#...>
```

---

### 7.4 SOP — Asset / Device (it_asset_device)
**Objectif** : gérer cycle de vie device (provision, MDM, conformité).

**Étapes**
1) Identifier device + propriétaire + état (AssetMaster).
2) Provisionner (MDM) + politique sécurité (SecurityMaster).
3) Installer logiciel standard (SoftwMaster).
4) Vérifier conformité (chiffrement, AV/EDR, patch).
5) Documenter inventaire + remise au user.
6) Offboarding : wipe, récupération, retrait accès.

**Done**
- Device conforme + inventaire à jour.

---

### 7.5 SOP — Backup & DR (it_backup_dr)
**Objectif** : restaurer vite, prouver que les backups sont utilisables.

**Étapes**
1) Confirmer objectif : RPO/RTO (OrchestratorMSP).
2) Identifier source backup + date.
3) Exécuter restore en environnement sûr si possible.
4) Valider intégrité (hash, checks, smoke tests).
5) Documenter : procédure + leçons.

**Done**
- Restore réussi + preuve de validation + runbook.

---

### 7.6 SOP — Sécurité (it_security_event)
**Objectif** : contenir + investiguer + notifier.

**Étapes**
1) Triage (SecurityMaster) : type (phishing, malware, fuite, accès suspect).
2) Containment : isoler, révoquer tokens, reset sessions.
3) Collecter preuves (sans altérer) : logs, horodatages, artefacts.
4) Évaluer impact : comptes, données, périmètre.
5) Remédier + durcir.
6) Post-mortem + actions préventives.

**Done**
- Incident contenu + remédiation + rapport + actions préventives.

---

### 7.7 SOP — Intégration (it_integration)
**Objectif** : connecter (SSO/SCIM/API) proprement et documenter.

**Étapes**
1) Définir besoin : auth (SSO), provisioning (SCIM), permissions.
2) Préparer environnements (test/prod) + rollback.
3) Configurer + tester (CloudMaster/DevOpsMaster).
4) Documenter : schéma, secrets management (sans secrets dans ticket), runbook.
5) Handover + monitoring.

**Done**
- Intégration stable + doc + monitoring.

---

## 8) Checklists rapides (Avant / Pendant / Après)
### Incident
- Avant : scope, changements récents, ticket+canal
- Pendant : mitigation, logs actions, validation métriques, updates
- Après : RCA, correctifs, doc, clôture

### Accès
- Avant : identité, justification, validation
- Pendant : moindre privilège, test
- Après : doc, revue/expiration

### Change
- Avant : plan/test/rollback, fenêtre, comms
- Pendant : step-by-step, mesures, rollback si besoin
- Après : validation, doc/CMDB, clôture

---

## 9) KPIs & amélioration continue (IT)
KPIs recommandés :
- Temps de réponse par priorité
- Temps de mitigation (P1/P2)
- % tickets en SLA
- Taux de réouverture
- Incidents récurrents (Top 5)
- % incidents avec KB/runbook créé/MAJ

Boucle :
- Revue hebdo IT : récurrences + actions préventives
- Revue mensuelle IT+OPS : SLA + qualité doc + dette technique
- Toute amélioration → mise à jour playbook + version

---

## 10) Points à clarifier (à compléter par l’équipe)
- Outil ITSM (ServiceNow/Jira SM/…)
- IdP/SSO (Okta/Entra/…)
- MDM (Intune/Jamf/…)
- Monitoring (Datadog/Grafana/…)
- Matrice P1/P2/P3 officielle
- Workflow d’archivage (OPS-DossierIA : oui/non)

---

# ANNEXES (sources canon du dépôt — copiables)
> Ces annexes te permettent de rester conforme sans uploader 10 fichiers séparés.

## A1) CONTEXT__CORE.md
```markdown
# CONTEXT — CORE (source de vérité)

Ce fichier est la **porte d’entrée** pour comprendre le dépôt `root_IA` : qui fait quoi, comment s’orchestrent les équipes, et comment ajouter de nouveaux agents sans casser la structure.

> Usage recommandé : uploade ce fichier dans les prompts internes (META / IAHQ / OPS), puis uploade le bundle spécifique à l’équipe.

---

## 1) Vue d’ensemble

### Objectif du dépôt
- Définir des **équipes** (TEAM) et des **agents** (GPT) standardisés.
- Définir des **playbooks** (enchaînements d’agents) et le **routage** (intents → acteurs).
- Définir des **policies** (règles) et des **schemas** (contrats de fichiers) pour éviter la dérive.

### Orchestrateurs globaux
- **MO** : `HUB-AgentMO-MasterOrchestrator` — mémoire “qui fait quoi”, coordination, intégration.
- **MO2** : `HUB-AgentMO2-DeputyOrchestrator` — assistant qualité/recette, checklists, cohérence.

### Machine d’exécution (OPS)
- `OPS-RouterIA` : choisit le bon playbook / acteur selon l’intent.
- `OPS-PlaybookRunner` : exécute le playbook (séquence).
- `OPS-DossierIA` : archive / mémoire opérationnelle / traçabilité.

---

## 2) Carte du dépôt (où trouver quoi)

- `10_TEAMS/` : définitions d’équipes (`TEAM__*.yaml`) + index `teams.yaml`.
- `20_AGENTS/` : agents par équipe. Chaque agent a au minimum :
  - `agent.yaml` (métadonnées / intents / interfaces)
  - `contract.yaml` (contrat I/O)
  - `prompt.md` (prompt interne)
- `40_RUNBOOKS/` :
  - `playbooks.yaml` (définitions des playbooks)
  - `RUNBOOKS_MD/` (docs opérationnelles)
- `50_POLICIES/` : règles (naming, output format, sources, sécurité IASM, policies OPS…)
- `SCHEMAS/` : schémas JSON (validation des fichiers YAML)
- `80_MACHINES/` : routage et “wiring” (ex. `hub_routing.yaml`)
- `90_MEMORY/` : index mémoire (si applicable)
- `90_KNOWLEDGE/` : templates, guides, bundles uploadables
- `70_INTEGRATION_PACKAGES/` : connecteurs (Slack, Notion, M365, etc.) + copie des schemas (référence)

---

## 3) Fichiers “canon” à connaître

- Inventaire équipes : `10_TEAMS/teams.yaml`
- Inventaire agents : `20_AGENTS/**/agent.yaml`
- Playbooks : `40_RUNBOOKS/playbooks.yaml`
- Routage : `80_MACHINES/hub_routing.yaml`
- Policies : `50_POLICIES/POLICIES__INDEX.md`
- Schemas : `SCHEMAS/*.schema.json`

---

## 4) Ajouter un nouvel agent (résumé)
1. Créer un dossier `20_AGENTS/<TEAM>/<AgentID>/`
2. Ajouter :
   - `agent.yaml` (voir template)
   - `contract.yaml` (voir template)
   - `prompt.md`
3. Mettre à jour si besoin :
   - `40_RUNBOOKS/playbooks.yaml` (si un playbook l’utilise)
   - `80_MACHINES/hub_routing.yaml` (si routable par intent)
4. Valider (scripts + checks).

Voir : `40_RUNBOOKS/RUNBOOKS_MD/RUNBOOK__ADD_AGENT.md` et `90_KNOWLEDGE/TEMPLATES/TEMPLATE__AGENT.md`.

---

## 5) Ajouter un playbook (résumé)
1. Définir l’objectif + I/O du playbook
2. Ajouter l’entrée dans `40_RUNBOOKS/playbooks.yaml`
3. Ajouter un runbook doc dans `40_RUNBOOKS/RUNBOOKS_MD/`
4. Raccorder au routage (`80_MACHINES/hub_routing.yaml`)

Voir : `40_RUNBOOKS/RUNBOOKS_MD/RUNBOOK__CREATE_PLAYBOOK.md` et `90_KNOWLEDGE/TEMPLATES/TEMPLATE__PLAYBOOK.md`.

---

## 6) Qualité — commandes de validation (local)
- `bash validate_root_IA.sh`
- `python scripts/validate_schemas.py`
- `python scripts/validate_no_fake_citations.py`

---

_Généré le 2026-01-05T00:47:21Z_
```

## A2) BUNDLE__META_UPLOAD.md
```markdown
# BUNDLE UPLOAD — META (1 fichier)

Ce fichier est conçu pour être **uploadé tel quel** dans le prompt interne des membres META.

## CORE (résumé intégré)
- Orchestrateurs globaux : MO (`HUB-AgentMO-MasterOrchestrator`) et MO2 (`HUB-AgentMO2-DeputyOrchestrator`).
- Machine OPS : `OPS-RouterIA` (route) → `OPS-PlaybookRunner` (exécute) → `OPS-DossierIA` (archive).
- Fichiers canon :
  - Teams : `10_TEAMS/teams.yaml` + `10_TEAMS/TEAM__*.yaml`
  - Agents : `20_AGENTS/**/agent.yaml` (+ `contract.yaml` et `prompt.md`)
  - Playbooks : `40_RUNBOOKS/playbooks.yaml`
  - Routage : `80_MACHINES/hub_routing.yaml`
  - Policies : `50_POLICIES/POLICIES__INDEX.md`
  - Schemas : `SCHEMAS/*.schema.json`
- Validations (local) :
  - `python scripts/validate_schemas.py`
  - `python scripts/validate_no_fake_citations.py`
  - `bash validate_root_IA.sh`


## Rôle META (résumé)
Tu produis des équipes/agents/playbooks **standardisés**, compatibles avec les schemas et policies du dépôt.

## Règles META (non négociables)
1) Ne pas inventer de structure : respecter `agent.yaml`, `contract.yaml`, `playbooks.yaml`, `hub_routing.yaml`.
2) Respecter les policies (naming, output format, sources si navigation).
3) Tout changement doit être “mergeable” : schemas OK + validations OK.

## Références utiles
- Template agent : `90_KNOWLEDGE/TEMPLATES/TEMPLATE__AGENT.md`
- Template playbook : `90_KNOWLEDGE/TEMPLATES/TEMPLATE__PLAYBOOK.md`
- Runbook create team : `40_RUNBOOKS/RUNBOOKS_MD/RUNBOOK__CREATE_TEAM.md`
- Runbook create playbook : `40_RUNBOOKS/RUNBOOKS_MD/RUNBOOK__CREATE_PLAYBOOK.md`
- Checklist review prompts : `40_RUNBOOKS/RUNBOOKS_MD/RUNBOOK__PROMPT_REVIEW_CHECKLIST.md`

## Checklist production rapide
### Créer un agent
- Dossier : `20_AGENTS/<TEAM>/<AgentID>/`
- Fichiers : `agent.yaml`, `contract.yaml`, `prompt.md`
- Intents clairs + alias
- Interfaces déclarées si besoin
- Validation : schemas + no_fake_citations + validate_root_IA

### Créer un playbook
- Ajouter l’entrée à `40_RUNBOOKS/playbooks.yaml`
- Documenter dans `40_RUNBOOKS/RUNBOOKS_MD/`
- Raccorder intent → playbook dans `80_MACHINES/hub_routing.yaml`
- Valider

## Notes pour l’intégration
Toujours fournir :
- Les fichiers (ou patch) à appliquer
- Les impacts (routage, dépendances, policies)
- Le test minimal à exécuter
```

## A3) POLICIES__INDEX.md
```markdown
# Index des policies

Ce fichier liste toutes les policies applicables dans ce dépôt. Les agents doivent les respecter en production.

## Liste
- `50_POLICIES/SOURCE_ATTRIBUTION.md` — Generated: 2025-12-28T22:00:54Z
- `50_POLICIES/SOURCE_ATTRIBUTION.yaml` — Fichier de configuration (YAML) associé.
- `50_POLICIES/naming.md` — - team_id: TEAM__NAME
- `50_POLICIES/ops/incident_severity.md` — - P1: panne totale / données à risque / sécurité
- `50_POLICIES/ops/logging_schema.md` — Chaque exécution produit:
- `50_POLICIES/ops/sla.md` — - P1 (critique): réponse < 15 min, mitigation < 60 min
- `50_POLICIES/output_format.md` — Tous les agents répondent en YAML strict (voir prompt.md).
- `50_POLICIES/safety_iasm.md` — Cabinet IA = psychoéducatif / coaching / support.

## Règles d’or (résumé)
- Respecter le format de sortie attendu (`50_POLICIES/output_format.md`).
- Respecter la convention de nommage (`50_POLICIES/naming.md`).
- Attribution des sources si navigation web / données externes (`50_POLICIES/SOURCE_ATTRIBUTION.*`).
- Pour IASM (santé mentale), appliquer `50_POLICIES/safety_iasm.md`.
- Pour OPS, appliquer aussi `50_POLICIES/ops/*` (SLA, logs, sévérité).
```

## A4) hub_routing.yaml (extrait + table IT)
```yaml
routing_table:
- match_any_intents:
  - it
  - msp
  - support
  - incident
  - cmdb
  - network
  - cloud
  - security
  - devops
  - voip
  - licenses
  - monitoring
  - maintenance
  - backup
  - dr
  - script
  - broadcast
  - voiceover
  - voice_over
  - voiceOver
  - studio
  - audio_broadcast
  default_actor_id: IT-OrchestratorMSP
  default_playbook_id: IT_MSP_TICKET_TO_KB
fallback:
  default_actor_id: HUB-AgentMO-MasterOrchestrator
  default_playbook_id: INTAKE_ROUTE_EXECUTE
```

## A5) teams.yaml (extrait TEAM__IT)
```yaml
team_id: TEAM__IT
name: IT
default_orchestrator: IT-OrchestratorMSP
file: 10_TEAMS/TEAM__IT.yaml
```

## A6) playbooks.yaml (catalogue complet)
```yaml
schema_version: 1.0
generated_at: '2026-01-04T20:12:19Z'
playbooks:
  INTAKE_ROUTE_EXECUTE:
    description: 'Flux standard : route -> exécute -> archive'
    steps:
    - step: route
      actor_id: OPS-RouterIA
    - step: execute
      actor_id: OPS-PlaybookRunner
    - step: archive
      actor_id: OPS-DossierIA
  BUILD_ARMY_FACTORY:
    description: 'Usine armées : besoins -> rôles -> prompts -> audit -> plan d’intégration'
    steps:
    - step: requirements
      actor_id: META-AnalysteBesoinsEquipes
    - step: roles
      actor_id: META-CartographeRoles
    - step: prompts
      actor_id: META-Opromptimizer
    - step: audit
      actor_id: META-SuperviseurInvisible
    - step: package
      actor_id: IAHQ-DevFactoryIA
  IT_MSP_TICKET_TO_KB:
    description: Ticket MSP -> diagnostic -> communication -> knowledge
    steps:
    - step: scribe
      actor_id: IT-TicketScribe
    - step: support
      actor_id: IT-SupportMaster
    - step: comms
      actor_id: IT-CommsMSP
    - step: kb
      actor_id: IT-KnowledgeKeeper
  TRAD_WATCH_TO_REPORT:
    description: Veille -> corrélation -> rapport
    steps:
    - step: correlate
      actor_id: TRAD-Correlator
    - step: report
      actor_id: TRAD-GlobalReport
  DAM_PROJECT_CONTROL:
    description: 'Projet DAM : conformité/budget/planning/inspection + synthèse'
    steps:
    - step: conformite
      actor_id: DAM-GPT2-Conformite
    - step: budget
      actor_id: DAM-GPT3-Budget
    - step: planning
      actor_id: DAM-GPT4-Planification
    - step: vendors
      actor_id: DAM-GPT5-SousTraitants
    - step: inspection
      actor_id: DAM-GPT6-Inspection
    - step: synthese
      actor_id: DAM-Orchestrator
  IASM_SESSION:
    description: 'Cabinet IA : intake -> risques -> analyse -> plan -> validation'
    steps:
    - step: intake
      actor_id: IASM-OrchestreurCabinetIA
    - step: risk
      actor_id: IASM-SecuriteRisques
    - step: analysis
      actor_id: IASM-AnalysteSchemasRelationnels
    - step: plan
      actor_id: IASM-CoachDeVie
    - step: director
      actor_id: IASM-DirecteurCabinetIA
  IAHQ_FRONTDOOR:
    description: 'Front door business : cadrage IAHQ -> mapping process -> route ->
      exécute -> archive'
    steps:
    - step: business_intake
      actor_id: IAHQ-OrchestreurEntrepriseIA
    - step: process_map
      actor_id: IAHQ-ProcessMapper
    - step: route
      actor_id: OPS-RouterIA
    - step: execute
      actor_id: OPS-PlaybookRunner
    - step: archive
      actor_id: OPS-DossierIA
  NEA_MACHINE_LIVRE_V1:
    description: 'NEA : cadrage -> structure -> patterns -> rédaction -> imagerie
      -> archivage -> dossier'
    steps:
    - step: brief
      actor_id: NEA-Orchestrator
    - step: structure
      actor_id: NEA-Cartographe
    - step: patterns
      actor_id: NEA-ConseilPatterns
    - step: redaction
      actor_id: NEA-RedacteurRecueil
    - step: imagerie
      actor_id: NEA-Imagier
    - step: archivage
      actor_id: NEA-Archiviste
    - step: dossier
      actor_id: OPS-DossierIA
  RADIO_MACHINE_SCRIPT_V1:
    description: 'Radio : cadrage -> script -> réécriture/voix -> dossier'
    steps:
    - step: script
      actor_id: PLR-RadioScripteur
    - step: voix
      actor_id: ESPL-PaulLejeuneRadio
    - step: dossier
      actor_id: OPS-DossierIA
```

## A7) Templates repo (agent & playbook)
### TEMPLATE__AGENT.md
```markdown
# TEMPLATE — Agent (dossier complet)

## Arborescence standard
Créer un dossier :
`20_AGENTS/<TEAM>/<AgentID>/`

Inclure au minimum :
- `agent.yaml` — métadonnées + intents + interfaces
- `contract.yaml` — contrat I/O (ce que l’agent reçoit / ce qu’il doit produire)
- `prompt.md` — prompt interne (instructions + contraintes + style)

Optionnel :
- `memory_index.yaml` — index de mémoire (si vous avez une mémoire structurée)
- docs additionnelles (exemples, checklists)

---

## Exemple `agent.yaml`
```yaml
schema_version: 1.0
id: <AgentID>
display_name: "<Nom lisible>"
team_id: TEAM__<TEAM>
status: active

description: >
  <1-3 phrases : mission + scope.>

intents:
  - <intent_1>
  - <intent_2>

aliases:
  - "<alias optionnel>"

interfaces:
  # Exemple : outils / intégrations utilisées (si applicable)
  - name: slack
    mode: read_write
  - name: notion
    mode: read_only
```

## Exemple `contract.yaml`
```yaml
schema_version: 1.0
input:
  required:
    - "<champ_1>"
    - "<champ_2>"
  optional:
    - "<champ_opt>"
output:
  required:
    - "<livrable_1>"
  format:
    - "markdown"
```

---

## Exemple `prompt.md` (structure recommandée)
- Contexte (1 paragraphe)
- Mission
- Ce que tu dois produire (outputs)
- Ce que tu ne fais pas / limites
- Process (étapes)
- Qualité / DoD
- Policies à respecter (naming, output format, sources…)

---

## Validation
- `python scripts/validate_schemas.py`
- `python scripts/validate_no_fake_citations.py`
- `bash validate_root_IA.sh`
```

### TEMPLATE__PLAYBOOK.md
```markdown
# TEMPLATE — Playbook

Un playbook est une séquence d’étapes (steps) qui enchaîne des agents.

## 1) Ajouter dans `40_RUNBOOKS/playbooks.yaml`

Exemple (à adapter) :
```yaml
playbooks:
  <PLAYBOOK_ID>:
    description: "<1 phrase : objectif>"
    steps:
      - step: <step_name_1>
        actor_id: <AgentID_1>
      - step: <step_name_2>
        actor_id: <AgentID_2>
```

## 2) Documenter le playbook
Créer un fichier :
`40_RUNBOOKS/RUNBOOKS_MD/RUNBOOK__<PLAYBOOK_ID>.md`

Contenu recommandé :
- Objectif & scope
- Inputs attendus
- Outputs attendus
- Étapes (order) + responsabilités
- Critères qualité (DoD)
- Cas d’erreur / fallback

## 3) Raccorder au routage
Mettre à jour `80_MACHINES/hub_routing.yaml` :
- ajouter un intent → `playbook_id` ou `actor_id` selon votre wiring.

## 4) Valider
- `python scripts/validate_schemas.py`
- `bash validate_root_IA.sh`
```

## A8) Schéma agent (agent.schema.json)
```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "agent.yaml",
  "type": "object",
  "required": [
    "schema_version",
    "id",
    "display_name",
    "team_id",
    "team_name",
    "version",
    "status",
    "description",
    "intents",
    "machine",
    "interfaces"
  ],
  "properties": {
    "schema_version": {
      "type": "string"
    },
    "id": {
      "type": "string",
      "pattern": "^[A-Za-z0-9_-]+$"
    },
    "display_name": {
      "type": "string"
    },
    "team_id": {
      "type": "string",
      "pattern": "^TEAM__"
    },
    "team_name": {
      "type": "string"
    },
    "version": {
      "type": "string"
    },
    "status": {
      "type": "string",
      "enum": [
        "active",
        "inactive",
        "deprecated"
      ]
    },
    "description": {
      "type": "string"
    },
    "intents": {
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "aliases": {
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "machine": {
      "type": "object",
      "required": [
        "output_format",
        "contract_required",
        "logs_required"
      ],
      "properties": {
        "output_format": {
          "type": "string"
        },
        "contract_required": {
          "type": "boolean"
        },
        "logs_required": {
          "type": "boolean"
        }
      }
    },
    "interfaces": {
      "type": "object",
      "required": [
        "contract",
        "prompt"
      ],
      "properties": {
        "contract": {
          "type": "string"
        },
        "prompt": {
          "type": "string"
        }
      }
    }
  }
}
```

## A9) Runbooks usine (création équipe / build factory / build playbook)
### RUNBOOK__CREATE_TEAM.md
```markdown
# RUNBOOK — Créer une nouvelle équipe (TEAM)

## Objectif
Ajouter une équipe **sans casser** la structure (schemas + routage + playbooks).

## Étapes
1) Créer le fichier équipe :
   - `10_TEAMS/TEAM__<TEAM>.yaml`
   - Champs recommandés :
     - `schema_version`
     - `team_id` (ex: `TEAM__NEA`)
     - `name`
     - `mission`
     - `default_orchestrator` (AgentID)

2) Mettre à jour l’index :
   - `10_TEAMS/teams.yaml` (ajouter la référence au fichier)

3) Créer le dossier agents :
   - `20_AGENTS/<TEAM>/` et y ajouter les agents (voir `RUNBOOK__ADD_AGENT.md`)

4) Wiring (si routable)
   - Ajouter intents → acteur / playbook dans `80_MACHINES/hub_routing.yaml`

5) Documentation
   - Ajouter/mettre à jour `90_KNOWLEDGE/INDEX__<TEAM>.md` si vous maintenez des index par équipe.

## Validation
- `python scripts/validate_schemas.py`
- `bash validate_root_IA.sh`
```

### RUNBOOK__BUILD_ARMY_FACTORY.md
```markdown
# RUNBOOK — BUILD_ARMY_FACTORY

## Objectif

Usine armées : besoins -> rôles -> prompts -> audit -> plan d’intégration

## Déclencheur

- Dès qu’une demande correspond à cet intent dans le routage, ou exécution manuelle.

## Owner

- OPS (Build/Factory)

## SLA cible

- À définir (suggestion : 24h ouvrées pour une demande standard, 4h si urgence).

## Prérequis

- Accès aux agents impliqués.
- Dossier/ID de suivi (ticket, dossier client, ou dossier IA).
- Inputs complets (fichiers / texte / consignes).

## Étapes (exécution)

### Étape 1 — requirements

- **Acteur** : `META-AnalysteBesoinsEquipes`

- **Action** : lancer l’acteur avec les inputs de l’étape, récupérer la sortie.

- **Sortie attendue** : output conforme au `contract.yaml` de l’acteur.

- **Contrôle qualité** : vérifier champs obligatoires + cohérence (pas de champs vides critiques).


### Étape 2 — roles

- **Acteur** : `META-CartographeRoles`

- **Action** : lancer l’acteur avec les inputs de l’étape, récupérer la sortie.

- **Sortie attendue** : output conforme au `contract.yaml` de l’acteur.

- **Contrôle qualité** : vérifier champs obligatoires + cohérence (pas de champs vides critiques).


### Étape 3 — prompts

- **Acteur** : `META-Opromptimizer`

- **Action** : lancer l’acteur avec les inputs de l’étape, récupérer la sortie.

- **Sortie attendue** : output conforme au `contract.yaml` de l’acteur.

- **Contrôle qualité** : vérifier champs obligatoires + cohérence (pas de champs vides critiques).


### Étape 4 — audit

- **Acteur** : `META-SuperviseurInvisible`

- **Action** : lancer l’acteur avec les inputs de l’étape, récupérer la sortie.

- **Sortie attendue** : output conforme au `contract.yaml` de l’acteur.

- **Contrôle qualité** : vérifier champs obligatoires + cohérence (pas de champs vides critiques).


### Étape 5 — package

- **Acteur** : `IAHQ-DevFactoryIA`

- **Action** : lancer l’acteur avec les inputs de l’étape, récupérer la sortie.

- **Sortie attendue** : output conforme au `contract.yaml` de l’acteur.

- **Contrôle qualité** : vérifier champs obligatoires + cohérence (pas de champs vides critiques).


## Critères de Done

- Toutes les étapes exécutées sans erreur.
- Output final archivé (dossier/ticket mis à jour).
- Si applicable : décision/score final communiqué.

## Exceptions & escalade

- Output incohérent / incomplet → relancer l’étape 1 fois avec inputs clarifiés.
- Blocage persistant → escalader au owner d’équipe + `HUB-AgentMO2-DeputyOrchestrator`.

## Notes / Doc legacy

- Une version legacy existe : `40_RUNBOOKS/RUNBOOKS_MD/04_build_army_factory.md`
```

### RUNBOOK__META_PLAYBOOK_BUILD_V1.md
```markdown
# RUNBOOK — META_PLAYBOOK_BUILD_V1
_Généré le 2026-01-17T21:19:45Z_

## 1) Objectif
Construction d'un playbook (spec -> wiring -> runbook -> validation)

## 2) Owner / Acteurs
- Owner (par défaut) : `META-PlaybookBuilder`
- Steps (ordre canon) :
  - **build** → `META-PlaybookBuilder`
  - **supervise** → `META-SuperviseurInvisible`
  - **archive** → `OPS-DossierIA`

## 3) Inputs attendus
- Contexte : demande + objectifs + contraintes
- Données : liens, docs, extraits (si applicable)
- Format de sortie requis (si applicable)

## 4) Procédure
1. Exécuter les steps dans l’ordre.
2. Documenter les décisions / hypothèses.
3. Produire l’output final + résumé exécutif.

## 5) Contrôles qualité
- Check conformité (policies du domaine)
- Cohérence interne + traçabilité des sources (si applicable)
- Format de sortie respecté

## 6) Erreurs fréquentes / Escalade
- Si informations manquantes : demander les éléments minimaux (but, audience, contraintes).
- Si risque sécurité/conformité : escalader vers `META-GouvernanceEtRisques`.

## 7) Definition of Done
- Output livré + résumé
- Artefacts archivés si nécessaire (ex: `OPS-DossierIA`)
```

## A10) Index agents utiles (IT + OPS + MO)
### Roster synthèse (ID / description / team)
| agent_id                        | description                                                                                      | team   |
|:--------------------------------|:-------------------------------------------------------------------------------------------------|:-------|
| HUB-AgentMO-MasterOrchestrator  | Orchestrateur central des équipes IA : intake, mapping, dispatch, compilation.                   | HUB    |
| HUB-AgentMO2-DeputyOrchestrator | Adjoint orchestration : préparation brief, QA cohérence, relance modules.                        | HUB    |
| IT-AssetMaster                  | Inventaire IT & CMDB : structure, maintient et exploite actifs HW/SW.                            | IT     |
| IT-BackupDRMaster               | Sauvegardes & DR : stratégies RPO/RTO, tests, runbooks.                                          | IT     |
| IT-CTOMaster                    | Directeur technique MSP : architectures, standards, arbitrages.                                  | IT     |
| IT-CloudMaster                  | Cloud Azure/M365/SaaS : architectures, gouvernance, sécurité.                                    | IT     |
| IT-Commandare-NOC               | Orchestrateur NOC : triage des alertes, routage et escalade vers TECH/SOC/CTO.                   | IT     |
| IT-Commandare-OPR               | Orchestrateur back-office : pipeline fermeture ticket, standardisation et contrôle.              | IT     |
| IT-Commandare-TECH              | Chef d’exécution technique : diagnostic, remédiation, plan de changement et validation post-fix. | IT     |
| IT-CommsMSP                     | Communication client MSP : emails, Teams, SMS maintenance/incidents.                             | IT     |
| IT-DevOpsMaster                 | DevOps/CI-CD : pipelines, environnements, IaC.                                                   | IT     |
| IT-DirecteurGeneral             | Directeur général MSP : objectifs ops -> priorités & directives.                                 | IT     |
| IT-InfrastructureMaster         | Serveurs/virtualisation/stockage : design, capacity planning.                                    | IT     |
| IT-KnowledgeKeeper              | Knowledge MSP : tickets résolus -> KB & runbooks.                                                | IT     |
| IT-MaintenanceMaster            | Maintenance & audits : patching, plans, conformité.                                              | IT     |
| IT-MonitoringMaster             | Supervision/observabilité : KPIs, alertes, rapports.                                             | IT     |
| IT-NOCDispatcher                | Dispatcher NOC : affectation, priorisation, escalade et suivi (SLA) des tickets/alertes.         | IT     |
| IT-NetworkMaster                | Réseau : LAN/WAN/VPN/WiFi/routage/QoS/firewalls.                                                 | IT     |
| IT-OrchestratorMSP              | Chef d’orchestre MSP : reçoit demandes, mobilise experts, compile livrables.                     | IT     |
| IT-ReportMaster                 | Production de rapports MSP : KPI/SLA, tendances incidents, recommandations et synthèses client.  | IT     |
| IT-ScriptMaster                 | Scripting & automatisation (PowerShell/Python/Bash) : scripts fiables.                           | IT     |
| IT-SecurityMaster               | Cybersécurité : risques, posture, remédiations.                                                  | IT     |
| IT-SoftwMaster                  | Logiciels & licences : conformité, coûts, optimisation licences.                                 | IT     |
| IT-SupportMaster                | Support TI N1–N3 : diagnostic, résolution, escalade, standards.                                  | IT     |
| IT-TicketScribe                 | Rédacteur ConnectWise : notes brutes -> compte rendu + actions.                                  | IT     |
| IT-VoIPMaster                   | Téléphonie IP & UC : design, évolution, optimisation.                                            | IT     |
| META-OrchestrateurCentral       | Orchestrateur usine à armées : transforme demande en plan complet (teams, agents, runbooks).     | META   |
| OPS-DossierIA                   | Hub mémoire projet : contexte, décisions, artefacts, index, traçabilité.                         | OPS    |
| OPS-PlaybookRunner              | Exécuteur de workflows (playbooks) à partir d’un objectif.                                       | OPS    |
| OPS-RouterIA                    | Dispatcher central : détecte intent/capability et route vers team/agent/playbook.                | OPS    |

### Détails YAML (copiable)
```yaml
HUB-AgentMO-MasterOrchestrator:
  display_name: '@HUB - AGENT-MO — Master Orchestrator'
  team_id: TEAM__HUB
  team_name: HUB
  description: 'Orchestrateur central des équipes IA : intake, mapping, dispatch,
    compilation.'
  intents:
  - orchestrate
  - intake
  - dispatch
HUB-AgentMO2-DeputyOrchestrator:
  display_name: '@HUB - AGENT-MO2 — Deputy Orchestrator'
  team_id: TEAM__HUB
  team_name: HUB
  description: 'Adjoint orchestration : préparation brief, QA cohérence, relance modules.'
  intents:
  - orchestrate
  - qa
  - brief
IT-AssetMaster:
  display_name: '@IT-AssetMaster'
  team_id: TEAM__IT
  team_name: IT
  description: 'Inventaire IT & CMDB : structure, maintient et exploite actifs HW/SW.'
  intents:
  - it
  - cmdb
  - assets
IT-BackupDRMaster:
  display_name: '@IT-BackupDRMaster'
  team_id: TEAM__IT
  team_name: IT
  description: 'Sauvegardes & DR : stratégies RPO/RTO, tests, runbooks.'
  intents:
  - it
  - backup
  - dr
IT-CTOMaster:
  display_name: '@IT-CTOMaster'
  team_id: TEAM__IT
  team_name: IT
  description: 'Directeur technique MSP : architectures, standards, arbitrages.'
  intents:
  - it
  - cto
  - standards
IT-CloudMaster:
  display_name: '@IT-CloudMaster'
  team_id: TEAM__IT
  team_name: IT
  description: 'Cloud Azure/M365/SaaS : architectures, gouvernance, sécurité.'
  intents:
  - it
  - cloud
  - azure
  - m365
IT-Commandare-NOC:
  display_name: '@IT-Commandare-NOC'
  team_id: TEAM__IT
  team_name: IT
  description: 'Orchestrateur NOC : triage des alertes, routage et escalade vers TECH/SOC/CTO.'
  intents:
  - noc
  - monitoring
  - incident
  - triage
IT-Commandare-OPR:
  display_name: '@IT-Commandare-OPR'
  team_id: TEAM__IT
  team_name: IT
  description: 'Orchestrateur back-office : pipeline fermeture ticket, standardisation
    et contrôle.'
  intents:
  - it
  - msp
  - process
  - tickets
IT-Commandare-TECH:
  display_name: '@IT-Commandare-TECH'
  team_id: TEAM__IT
  team_name: IT
  description: 'Chef d’exécution technique : diagnostic, remédiation, plan de changement
    et validation post-fix.'
  intents:
  - troubleshooting
  - remediation
  - change
  - incident
IT-CommsMSP:
  display_name: '@IT-CommsMSP'
  team_id: TEAM__IT
  team_name: IT
  description: 'Communication client MSP : emails, Teams, SMS maintenance/incidents.'
  intents:
  - it
  - comms
  - client
IT-DevOpsMaster:
  display_name: '@IT-DevOpsMaster'
  team_id: TEAM__IT
  team_name: IT
  description: 'DevOps/CI-CD : pipelines, environnements, IaC.'
  intents:
  - it
  - devops
  - cicd
IT-DirecteurGeneral:
  display_name: '@IT-DirecteurGeneral'
  team_id: TEAM__IT
  team_name: IT
  description: 'Directeur général MSP : objectifs ops -> priorités & directives.'
  intents:
  - it
  - management
  - governance
IT-InfrastructureMaster:
  display_name: '@IT-InfrastructureMaster'
  team_id: TEAM__IT
  team_name: IT
  description: 'Serveurs/virtualisation/stockage : design, capacity planning.'
  intents:
  - it
  - infrastructure
  - servers
IT-KnowledgeKeeper:
  display_name: '@IT-KnowledgeKeeper'
  team_id: TEAM__IT
  team_name: IT
  description: 'Knowledge MSP : tickets résolus -> KB & runbooks.'
  intents:
  - it
  - knowledge
  - kb
  - runbook
IT-MaintenanceMaster:
  display_name: '@IT-MaintenanceMaster'
  team_id: TEAM__IT
  team_name: IT
  description: 'Maintenance & audits : patching, plans, conformité.'
  intents:
  - it
  - maintenance
  - patching
IT-MonitoringMaster:
  display_name: '@IT-MonitoringMaster'
  team_id: TEAM__IT
  team_name: IT
  description: 'Supervision/observabilité : KPIs, alertes, rapports.'
  intents:
  - it
  - monitoring
  - observability
IT-NOCDispatcher:
  display_name: '@IT-NOCDispatcher'
  team_id: TEAM__IT
  team_name: IT
  description: 'Dispatcher NOC : affectation, priorisation, escalade et suivi (SLA)
    des tickets/alertes.'
  intents:
  - dispatch
  - sla
  - coordination
  - incident
IT-NetworkMaster:
  display_name: '@IT-NetworkMaster'
  team_id: TEAM__IT
  team_name: IT
  description: 'Réseau : LAN/WAN/VPN/WiFi/routage/QoS/firewalls.'
  intents:
  - it
  - network
  - firewall
IT-OrchestratorMSP:
  display_name: '@IT-OrchestratorMSP'
  team_id: TEAM__IT
  team_name: IT
  description: 'Chef d’orchestre MSP : reçoit demandes, mobilise experts, compile
    livrables.'
  intents:
  - audio_broadcast
  - broadcast
  - it
  - msp
  - orchestrate
  - script
  - studio
  - voiceOver
  - voice_over
  - voiceover
IT-ReportMaster:
  display_name: '@IT-ReportMaster'
  team_id: TEAM__IT
  team_name: IT
  description: 'Production de rapports MSP : KPI/SLA, tendances incidents, recommandations
    et synthèses client.'
  intents:
  - report
  - kpi
  - sla
  - communication
IT-ScriptMaster:
  display_name: '@IT-ScriptMaster'
  team_id: TEAM__IT
  team_name: IT
  description: 'Scripting & automatisation (PowerShell/Python/Bash) : scripts fiables.'
  intents:
  - it
  - automation
  - scripting
IT-SecurityMaster:
  display_name: '@IT-SecurityMaster'
  team_id: TEAM__IT
  team_name: IT
  description: 'Cybersécurité : risques, posture, remédiations.'
  intents:
  - it
  - security
  - risk
IT-SoftwMaster:
  display_name: '@IT-SoftwMaster'
  team_id: TEAM__IT
  team_name: IT
  description: 'Logiciels & licences : conformité, coûts, optimisation licences.'
  intents:
  - it
  - licenses
  - software
IT-SupportMaster:
  display_name: '@IT-SupportMaster'
  team_id: TEAM__IT
  team_name: IT
  description: 'Support TI N1–N3 : diagnostic, résolution, escalade, standards.'
  intents:
  - it
  - support
  - incident
IT-TicketScribe:
  display_name: '@IT-TicketScribe'
  team_id: TEAM__IT
  team_name: IT
  description: 'Rédacteur ConnectWise : notes brutes -> compte rendu + actions.'
  intents:
  - it
  - ticket
  - writing
IT-VoIPMaster:
  display_name: '@IT-VoIPMaster'
  team_id: TEAM__IT
  team_name: IT
  description: 'Téléphonie IP & UC : design, évolution, optimisation.'
  intents:
  - it
  - voip
  - uc
META-OrchestrateurCentral:
  display_name: '@META-OrchestrateurCentral'
  team_id: TEAM__META
  team_name: META
  description: 'Orchestrateur usine à armées : transforme demande en plan complet
    (teams, agents, runbooks).'
  intents:
  - army_factory
  - design
  - orchestrate
OPS-DossierIA:
  display_name: '@OPS-DossierIA'
  team_id: TEAM__OPS
  team_name: OPS
  description: 'Hub mémoire projet : contexte, décisions, artefacts, index, traçabilité.'
  intents:
  - memory
  - archive
  - project_file
OPS-PlaybookRunner:
  display_name: '@OPS-PlaybookRunner'
  team_id: TEAM__OPS
  team_name: OPS
  description: Exécuteur de workflows (playbooks) à partir d’un objectif.
  intents:
  - run_playbook
  - execute
  - workflow
OPS-RouterIA:
  display_name: '@OPS-RouterIA'
  team_id: TEAM__OPS
  team_name: OPS
  description: 'Dispatcher central : détecte intent/capability et route vers team/agent/playbook.'
  intents:
  - route
  - dispatch
  - classify
```
