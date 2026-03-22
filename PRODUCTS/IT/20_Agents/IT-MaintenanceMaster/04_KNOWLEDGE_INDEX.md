# Knowledge Index — IT-MaintenanceMaster (v2.0)

## Fichiers à uploader dans le GPT (Knowledge)

Tous les fichiers listés ici doivent être présents dans l'onglet Knowledge du GPT.
Priorité : charger d'abord les fichiers `priority: haute`.

---

## 05_KNOWLEDGE — Runbooks opérationnels

| Fichier | Contenu | Priorité |
|---|---|---|
| `IT-MaintenanceMaster__KnowledgePack_Supplement_v1.md` | Runbooks patching, health check, post-shutdown — référence principale | Haute |
| `RUNBOOK__Windows_Patching.md` | Procédure patching Windows complète | Haute |
| `RUNBOOK__Windows_Patching_CW_RMM_OneByOne.md` | Patching via CW RMM serveur par serveur | Haute |
| `RUNBOOK__IT_CW_INTERVENTION_LIVE_CLOSE.md` | Journal live + closeout CW (chain MaintenanceMaster → TicketScribe → KnowledgeKeeper) | Haute |
| `RUNBOOK__IT_INTERVENTION_LIVE.md` | Procédure d'intervention live guidée | Haute |
| `RUNBOOK__Patching_Process.md` | Processus de patching MSP complet | Moyenne |
| `RUNBOOK__IT_BACKUP_DR_TEST_V1.md` | Test DR et validation backups | Moyenne |
| `RUNBOOK__IT_INCIDENT_COMMAND_V1.md` | Commandement d'incident | Moyenne |
| `RUNBOOK__Post_Shutdown_Electrical_Validation.md` | Validation post-arrêt électrique | Moyenne |

## 05_KNOWLEDGE — Scripts PowerShell

| Fichier | Contenu | Priorité |
|---|---|---|
| `POWERSHELL__Server_Management.md` | Commandes PS gestion serveurs (services, disques, AD, événements) | Haute |
| `POWERSHELL__Event_Log_Analysis.md` | Analyse logs Windows — patterns courants | Haute |

## 05_KNOWLEDGE — Templates CW

| Fichier | Contenu | Priorité |
|---|---|---|
| `TEMPLATE__CW_NOTE_INTERNE.md` | Template note interne ConnectWise | Haute |
| `TEMPLATE__CW_DISCUSSION.md` | Template discussion client (facturable) | Haute |
| `TEMPLATE__EMAIL_CLIENT.md` | Template courriel client | Moyenne |
| `TEMPLATE__Server_Health_Check.md` | Template rapport health check serveur | Moyenne |

## 05_KNOWLEDGE — Standards

| Fichier | Contenu | Priorité |
|---|---|---|
| `NAMING_STANDARDS_v1.md` | Conventions nommage : snapshots, scripts, logs, tâches planifiées | Haute |
| `IT__CMDB_Standards.md` | Standards CMDB — nommage actifs, champs obligatoires | Moyenne |

## 02_TEMPLATES — Templates d'intervention

| Fichier | Contenu | Priorité |
|---|---|---|
| `04_POWERSHELL_LIBRARY/POWERSHELL__Template_Standard_v1.ps1` | Template PS obligatoire (header, UTF-8, transcript, try/catch) | Haute |
| `05_INTERVENTION_TEMPLATES/INTERVENTION_TEMPLATE_IT.md` | Template intervention IT complet | Haute |
| `05_INTERVENTION_TEMPLATES/TEMPLATE__Health_Check.md` | Template health check générique | Moyenne |
| `05_INTERVENTION_TEMPLATES/TEMPLATE__Azure_Health_Report.md` | Template rapport Azure | Basse |
| `05_INTERVENTION_TEMPLATES/TEMPLATE__Cloud_Health_Report.md` | Template rapport Cloud | Basse |
| `06_NAMING_STANDARDS/NAMING_STANDARDS_v1.md` | Conventions nommage — référence principale | Haute |

## 03_CHECKLISTS

| Fichier | Contenu | Priorité |
|---|---|---|
| `CL-001_validation-principale.md` | Checklist pre/post patching | Haute |

---

## Fichiers de référence externe (IT-SHARED)

Ces fichiers ne sont pas dans le dossier de l'agent mais doivent être disponibles :

| Fichier | Chemin dans IT-SHARED | Priorité |
|---|---|---|
| Guardrails agents | `10_RUNBOOKS/00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md` | Haute |
| Runbook master IT | `10_RUNBOOKS/RUNBOOK_MASTER__IT_v1.md` | Moyenne |
| Scripts PowerShell | `30_SCRIPTS/POWERSHELL__Server_Management.md` | Moyenne |

---

*Index v2.0 — 2026-03-20 — IT-MaintenanceMaster*
