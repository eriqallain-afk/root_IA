# GPT SETUP CARD — @IT-BackupDRMaster
> **Usage :** Fiche de configuration complète pour le GPT Editor d'OpenAI.
> **Version :** 2.0.0 | **Mise à jour :** 2026-03-22

---

## 1. IDENTITÉ GPT

| Champ GPT Editor | Valeur |
|---|---|
| **Name** | IT-BackupDRMaster |
| **Description** | Expert Backup & DR MSP — Veeam, Datto BCDR, Keepit. Triage jobs, restauration fichier/VM, tests DR, validation RPO/RTO. YAML strict. |

---

## 2. INSTRUCTIONS (System Prompt)

**Source :** `00_INSTRUCTIONS.md` — coller dans le champ Instructions

> Le `prompt.md` (142L) est le système complet — mettre en Knowledge.

---

## 3. CONVERSATION STARTERS

1. ``MODE=VEEAM_TRIAGE — Billet #T[XXXXX] — Job [NOM] en échec — Erreur : [message]``
2. ``MODE=DATTO_TRIAGE — Screenshot manquant sur [VM]``
3. ``MODE=KEEPIT_TRIAGE — Connecteur M365 déconnecté``
4. ``MODE=TEST_DR — Test DR mensuel — VM : [NOM]``

---

## 4. KNOWLEDGE — Fichiers à uploader

### 🔴 CRITIQUE
| Fichier | Chemin dans le projet | Contenu |
|---|---|---|
| `BUNDLE_KP_BackupDRMaster_V1.md` | `IT-SHARED/60_BUNDLES/` | KnowledgePack Veeam/Datto/Keepit/DR |

### 🟠 IMPORTANT
| Fichier | Chemin | Contenu |
|---|---|---|
| `CHECKLIST__DR_Readiness.md` | `knowledge/` | Checklist DR mensuelle |
| `RUNBOOK__Backup_Configuration.md` | `knowledge/` | Configuration backup |

### 🟡 OPTIONNEL
| Fichier | Chemin | Contenu |
|---|---|---|
_Aucun_

### ❌ NE PAS UPLOADER
| Fichier | Raison |
|---|---|
| `agent.yaml` | Config/metadata interne |
| `contract.yaml` | Config/metadata interne |
| `manifest.json` | Config/metadata interne |
| `README.md` | Config/metadata interne |
| `03_PROMPT_ARCHIVE.md` | Config/metadata interne |

> **Limite GPT Knowledge :** 20 fichiers max. Prioriser dans l'ordre : 🔴 → 🟠 → 🟡

---

## 5. CAPABILITIES

| Capability | Activer ? | Raison |
|---|---|---|
| **Web Search** | Non |  |
| **DALL·E** | Non |  |
| **Code Interpreter** | Non |  |

---

## 6. TESTS DE VALIDATION POST-CONFIGURATION

| Message test | Comportement attendu |
|---|---|
| `MODE=VEEAM_TRIAGE — VSS snapshot failed` | YAML : diagnostic VSS writer, fix, next_actions |
| Restauration emplacement original sans confirmation | Refus + ⚠️ Impact + confirmation explicite |

---

## 7. DIFFÉRENCES CLÉS vs AUTRES AGENTS

| | IT-BackupDRMaster | IT-CloudMaster |
|---|---|
| Veeam, Datto, Keepit, DR | Exchange, Entra ID, Teams, SharePoint |
| Jobs backup, restauration VM | Messagerie, identité, conformité |

---

## 8. RÉFÉRENCES

| Élément | Valeur |
|---|---|
| **Fichier agent** | `20_Agents/IT-BackupDRMaster/agent.yaml` |
| **Contrat** | `20_Agents/IT-BackupDRMaster/contract.yaml` |
| **Prompt** | `20_Agents/IT-BackupDRMaster/prompt.md` (142L) |
| **Instructions** | `20_Agents/IT-BackupDRMaster/00_INSTRUCTIONS.md` |
| **Knowledge Index** | `20_Agents/IT-BackupDRMaster/04_KNOWLEDGE_INDEX.md` |
| **Guardrails** | `IT-SHARED/10_RUNBOOKS/00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md` |
| **Version** | 2.0.0 |

*GPT Setup Card v2.0 — IT-BackupDRMaster — IT MSP Intelligence Platform*
