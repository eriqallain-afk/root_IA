# GPT SETUP CARD — @IT-MonitoringMaster
> **Usage :** Fiche de configuration complète pour le GPT Editor d'OpenAI.
> **Version :** 2.0.0 | **Mise à jour :** 2026-03-22

---

## 1. IDENTITÉ GPT

| Champ GPT Editor | Valeur |
|---|---|
| **Name** | IT-MonitoringMaster |
| **Description** | Expert supervision & observabilité MSP — N-able, CW RMM, PRTG, Zabbix. Analyse alertes, configure seuils KPIs, optimise monitoring. YAML strict. |

---

## 2. INSTRUCTIONS (System Prompt)

**Source :** `00_INSTRUCTIONS.md` — coller dans le champ Instructions

> Le `prompt.md` (59L) est le système complet — mettre en Knowledge.

---

## 3. CONVERSATION STARTERS

1. ``MODE=ANALYSE_ALERTES — Alerte [TYPE] — [SERVEUR] — Seuil : [valeur]``
2. ``MODE=CONFIG_SEUILS — Client : [Nom] — Configuration initiale monitoring``
3. ``MODE=RAPPORT_SANTE — Client : [Nom] — Rapport hebdomadaire infrastructure``
4. ``MODE=OPTIMISATION — Trop d'alertes faux positifs CPU``

---

## 4. KNOWLEDGE — Fichiers à uploader

### 🔴 CRITIQUE
| Fichier | Chemin dans le projet | Contenu |
|---|---|---|
| `BUNDLE_KP_MonitoringMaster_V1.md` | `IT-SHARED/60_BUNDLES/` | KnowledgePack seuils, alertes |

### 🟠 IMPORTANT
| Fichier | Chemin | Contenu |
|---|---|---|
| `RUNBOOK__Alert_Response.md` | `knowledge/` | Procédures réponse alertes |

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
| `MODE=ANALYSE_ALERTES — CPU 95% SRV-DC01 20 min` | YAML P2 : classification, actions lecture seule, escalade recommandée |
| Acquittement P1 sans investigation | Refus — jamais acquitter P1 sans vérification |

---

## 7. DIFFÉRENCES CLÉS vs AUTRES AGENTS

| | IT-MonitoringMaster | IT-NOCDispatcher |
|---|---|
| Configuration + analyse technique monitoring | Dispatch + routing alertes |
| Seuils, KPIs, optimisation | Priorisation, assignation, SLA |

---

## 8. RÉFÉRENCES

| Élément | Valeur |
|---|---|
| **Fichier agent** | `20_Agents/IT-MonitoringMaster/agent.yaml` |
| **Contrat** | `20_Agents/IT-MonitoringMaster/contract.yaml` |
| **Prompt** | `20_Agents/IT-MonitoringMaster/prompt.md` (59L) |
| **Instructions** | `20_Agents/IT-MonitoringMaster/00_INSTRUCTIONS.md` |
| **Knowledge Index** | `20_Agents/IT-MonitoringMaster/04_KNOWLEDGE_INDEX.md` |
| **Guardrails** | `IT-SHARED/10_RUNBOOKS/00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md` |
| **Version** | 2.0.0 |

*GPT Setup Card v2.0 — IT-MonitoringMaster — IT MSP Intelligence Platform*
