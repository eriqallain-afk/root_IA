# GPT SETUP CARD — @IT-CloudMaster
> **Usage :** Fiche de configuration complète pour le GPT Editor d'OpenAI.
> **Version :** 2.0.0 | **Mise à jour :** 2026-03-22

---

## 1. IDENTITÉ GPT

| Champ GPT Editor | Valeur |
|---|---|
| **Name** | IT-CloudMaster |
| **Description** | Expert M365, Azure & Cloud MSP — Exchange Online, Entra ID, Teams, SharePoint, Intune, Compliance, Keepit. YAML strict. |

---

## 2. INSTRUCTIONS (System Prompt)

**Source :** `00_INSTRUCTIONS.md` — coller dans le champ Instructions

> Le `prompt.md` (131L) est le système complet — mettre en Knowledge.

---

## 3. CONVERSATION STARTERS

1. ``MODE=EXCHANGE_TRIAGE — Billet #T[XXXXX] — [utilisateur] ne reçoit plus ses emails``
2. ``MODE=ENTRAID_TRIAGE — Connexions suspectes sur [UPN]``
3. ``MODE=INTUNE_TRIAGE — Appareil [NOM] non conforme``
4. ``MODE=KEEPIT_M365 — Connecteur Microsoft 365 déconnecté``

---

## 4. KNOWLEDGE — Fichiers à uploader

### 🔴 CRITIQUE
| Fichier | Chemin dans le projet | Contenu |
|---|---|---|
| `BUNDLE_KP_CloudMaster_V1.md` | `IT-SHARED/60_BUNDLES/` | KnowledgePack M365/Azure/Keepit |

### 🟠 IMPORTANT
| Fichier | Chemin | Contenu |
|---|---|---|
| `REFERENCE__Cloud_Admin_Portals.md` | `knowledge/` | Portails admin cloud |
| `RUNBOOK__M365_User_Management.md` | `knowledge/` | Gestion utilisateurs M365 |

### 🟡 OPTIONNEL
| Fichier | Chemin | Contenu |
|---|---|---|
| `RUNBOOK__Quick_Start.md` | `knowledge/` | Quick start M365/Azure |

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
| `MODE=ENTRAID_TRIAGE — connexions 2 pays en 30 min` | YAML : escalade IT-SecurityMaster + Disable-ADAccount + Revoke-MgUserSignInSession |
| Règles Outlook ForwardTo externe | Escalade IT-SecurityMaster immédiate — P1 SOC |

---

## 7. DIFFÉRENCES CLÉS vs AUTRES AGENTS

| | IT-CloudMaster | IT-NetworkMaster |
|---|---|
| M365, Azure, Entra ID, Intune | Firewalls, VPN, LAN/WAN |
| Exchange, Teams, SharePoint | WatchGuard, Fortinet, Meraki |

---

## 8. RÉFÉRENCES

| Élément | Valeur |
|---|---|
| **Fichier agent** | `20_Agents/IT-CloudMaster/agent.yaml` |
| **Contrat** | `20_Agents/IT-CloudMaster/contract.yaml` |
| **Prompt** | `20_Agents/IT-CloudMaster/prompt.md` (131L) |
| **Instructions** | `20_Agents/IT-CloudMaster/00_INSTRUCTIONS.md` |
| **Knowledge Index** | `20_Agents/IT-CloudMaster/04_KNOWLEDGE_INDEX.md` |
| **Guardrails** | `IT-SHARED/10_RUNBOOKS/00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md` |
| **Version** | 2.0.0 |

*GPT Setup Card v2.0 — IT-CloudMaster — IT MSP Intelligence Platform*
