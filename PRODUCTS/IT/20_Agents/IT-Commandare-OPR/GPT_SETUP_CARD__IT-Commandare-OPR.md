# GPT SETUP CARD — @IT-Commandare-OPR
> **Usage :** Fiche de configuration complète pour le GPT Editor d'OpenAI.
> **Version :** 2.0.0 | **Mise à jour :** 2026-03-22

---

## 1. IDENTITÉ GPT

| Champ GPT Editor | Valeur |
|---|---|
| **Name** | IT-Commandare-OPR |
| **Description** | Commandare OPR MSP — scribe officiel, communications clients, rapports, CMDB, clôture formelle incidents. Mémoire opérationnelle IT. YAML strict. |

---

## 2. INSTRUCTIONS (System Prompt)

**Source :** `00_INSTRUCTIONS.md` — coller dans le champ Instructions

> Le `prompt.md` (91L) est le système complet — mettre en Knowledge.

---

## 3. CONVERSATION STARTERS

1. ``MODE=CLOSE — Billet #T[XXXXX] — Incident résolu — [résumé 1 ligne]``
2. ``MODE=POSTMORTEM — Billet #T[XXXXX] — P1 résolu — durée : [Xh]``
3. ``MODE=COMMUNICATION — Email client fin maintenance``
4. ``MODE=QBR — Client : [Nom] — Q1 2026``

---

## 4. KNOWLEDGE — Fichiers à uploader

### 🔴 CRITIQUE
| Fichier | Chemin dans le projet | Contenu |
|---|---|---|
| `BUNDLE_KP_Commandare-OPR_V1.md` | `IT-SHARED/60_BUNDLES/` | KnowledgePack CMDB, comms, postmortem, KPIs |

### 🟠 IMPORTANT
| Fichier | Chemin | Contenu |
|---|---|---|
| `IT__Postmortem_Template.md` | `IT_Commandare_OPR_KnowledgePack_v1/` | Template postmortem |
| `IT__Comms_Templates.md` | `IT_Commandare_OPR_KnowledgePack_v1/` | Templates communications |

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
| `MODE=CLOSE — Patching mensuel 4 serveurs` | YAML : DoD vérifié, Note Interne "Prise de connaissance...", Discussion STAR |
| IP dans livrable client | Masquage automatique → [IP MASQUÉE] |

---

## 7. DIFFÉRENCES CLÉS vs AUTRES AGENTS

| | IT-Commandare-OPR | IT-TicketScribe |
|---|---|
| Pilote opérations documentaires | Rédige les livrables CW |
| QBR, rapports, CMDB, DoD | Note Interne, Discussion, Email, Teams |

---

## 8. RÉFÉRENCES

| Élément | Valeur |
|---|---|
| **Fichier agent** | `20_Agents/IT-Commandare-OPR/agent.yaml` |
| **Contrat** | `20_Agents/IT-Commandare-OPR/contract.yaml` |
| **Prompt** | `20_Agents/IT-Commandare-OPR/prompt.md` (91L) |
| **Instructions** | `20_Agents/IT-Commandare-OPR/00_INSTRUCTIONS.md` |
| **Knowledge Index** | `20_Agents/IT-Commandare-OPR/04_KNOWLEDGE_INDEX.md` |
| **Guardrails** | `IT-SHARED/10_RUNBOOKS/00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md` |
| **Version** | 2.0.0 |

*GPT Setup Card v2.0 — IT-Commandare-OPR — IT MSP Intelligence Platform*
