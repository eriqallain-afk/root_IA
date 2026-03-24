# GPT SETUP CARD — @IT-AssistanTI_N3
> **Usage :** Fiche de configuration complète pour le GPT Editor d'OpenAI.
> **Version :** 2.0.0 | **Mise à jour :** 2026-03-22

---

## 1. IDENTITÉ GPT

| Champ GPT Editor | Valeur |
|---|---|
| **Name** | IT-AssistanTI_N3 |
| **Description** | Copilote MSP N1 à N3 pour les billets ConnectWise. Triage, diagnostic guidé, scripts PowerShell, runbooks et clôture automatique. Du triage à la fermeture. |

---

## 2. INSTRUCTIONS (System Prompt)

**Source :** `00_INSTRUCTIONS.md` — coller dans le champ Instructions

> Le `prompt.md` (1140L) contient toutes les commandes et runbooks — mettre obligatoirement en Knowledge.

---

## 3. CONVERSATION STARTERS

1. ``/start — Billet #T[XXXXX] — Client : [Nom] — [Symptôme]``
2. ``/start_maint — Patching mensuel — [N] serveurs — Client : [Nom]``
3. ``/runbook veeam — Job backup en échec``
4. ``/script — Precheck CPU/RAM/services sur SRV-DC01``

---

## 4. KNOWLEDGE — Fichiers à uploader

### 🔴 CRITIQUE
| Fichier | Chemin dans le projet | Contenu |
|---|---|---|
| `prompt.md` | `20_Agents/IT-AssistanTI_N3/` | Toutes les commandes, runbooks intégrés, templates CW |

### 🟠 IMPORTANT
| Fichier | Chemin | Contenu |
|---|---|---|
| `RUNBOOK__Windows_Patching_CW_RMM_OneByOne.md` | `10_RUNBOOKS/MAINTENANCE/` | Patching via CW RMM |
| `RUNBOOK__IT_SUPPORT_TRIAGE_N1N2N3_V1.md` | `10_RUNBOOKS/SUPPORT/` | Triage N1-N3 |
| `RUNBOOK__IT_CW_INTERVENTION_LIVE_CLOSE.md` | `10_RUNBOOKS/SUPPORT/` | Journal live + clôture |
| `RUNBOOK__DC_PrePost_Validation.md` | `10_RUNBOOKS/INFRA/` | Validation DC |
| `RUNBOOK__IT_BACKUP_DR_TEST_V1.md` | `10_RUNBOOKS/INFRA/` | Test DR |
| `RUNBOOK__IT_SECURITY_INCIDENT_RESPONSE.md` | `10_RUNBOOKS/SECURITY/` | Réponse sécurité |
| `POWERSHELL__Server_Management.md` | `30_SCRIPTS/` | PS serveurs |
| `POWERSHELL__Event_Log_Analysis.md` | `30_SCRIPTS/` | Event Log |

### 🟡 OPTIONNEL
| Fichier | Chemin | Contenu |
|---|---|---|
| `EXEMPLE_kb_brief_1683171.yaml` | `04_EXEMPLES/` | Exemple output /kb |

### ❌ NE PAS UPLOADER
| Fichier | Raison |
|---|---|
| `agent.yaml` | Config/metadata interne |
| `contract.yaml` | Config/metadata interne |
| `manifest.json` | Config/metadata interne |
| `00_INSTRUCTIONS.md` | Config/metadata interne |
| `03_PROMPT_ARCHIVE.md` | Config/metadata interne |

> **Limite GPT Knowledge :** 20 fichiers max. Prioriser dans l'ordre : 🔴 → 🟠 → 🟡

---

## 5. CAPABILITIES

| Capability | Activer ? | Raison |
|---|---|---|
| **Web Search** | Oui | CVE, KB Microsoft, firmware |
| **DALL·E** | Non |  |
| **Code Interpreter** | Optionnel | Analyser logs uploadés |

---

## 6. TESTS DE VALIDATION POST-CONFIGURATION

| Message test | Comportement attendu |
|---|---|
| `/start — T99999 — Acme — SRV-DC01 CPU 100% 30 min` | Triage P2, plan action, precheck PS lecture seule |
| `/script — Precheck CPU/RAM SRV-DC01` | PS : header #Requires, UTF-8, Transcript C:\IT_LOGS\DIAG\, Try/Catch |
| `/close` après intervention | CW_DISCUSSION STAR + CW_NOTE_INTERNE + EMAIL + AVIS_TEAMS + /kb + /db |

---

## 7. DIFFÉRENCES CLÉS vs AUTRES AGENTS

| | IT-AssistanTI_N3 | IT-MaintenanceMaster |
|---|---|
| Billets CW actifs — triage à clôture | Maintenance planifiée + estimation devis |
| Markdown conversationnel | YAML strict |
| /start, /runbook, /close, /kb, /db | /start_maint, /estimé, /check, /close |

---

## 8. RÉFÉRENCES

| Élément | Valeur |
|---|---|
| **Fichier agent** | `20_Agents/IT-AssistanTI_N3/agent.yaml` |
| **Contrat** | `20_Agents/IT-AssistanTI_N3/contract.yaml` |
| **Prompt** | `20_Agents/IT-AssistanTI_N3/prompt.md` (1140L) |
| **Instructions** | `20_Agents/IT-AssistanTI_N3/00_INSTRUCTIONS.md` |
| **Knowledge Index** | `20_Agents/IT-AssistanTI_N3/04_KNOWLEDGE_INDEX.md` |
| **Guardrails** | `IT-SHARED/10_RUNBOOKS/00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md` |
| **Version** | 2.0.0 |

*GPT Setup Card v2.0 — IT-AssistanTI_N3 — IT MSP Intelligence Platform*
