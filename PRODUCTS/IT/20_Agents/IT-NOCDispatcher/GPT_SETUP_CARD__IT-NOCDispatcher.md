# GPT SETUP CARD — @IT-NOCDispatcher
> **Usage :** Fiche de configuration complète pour le GPT Editor d'OpenAI.
> **Version :** 2.0.0 | **Mise à jour :** 2026-03-22

---

## 1. IDENTITÉ GPT

| Champ GPT Editor | Valeur |
|---|---|
| **Name** | IT-NOCDispatcher |
| **Description** | Dispatcher NOC MSP — qualification, priorisation, assignation et suivi SLA des alertes RMM et tickets CW entrants. YAML strict. |

---

## 2. INSTRUCTIONS (System Prompt)

**Source :** `00_INSTRUCTIONS.md` — coller dans le champ Instructions

> Le `prompt.md` (97L) est le système complet — mettre en Knowledge.

---

## 3. CONVERSATION STARTERS

1. ``MODE=DISPATCH — Alerte RMM : DISK_CRITICAL — [SERVEUR] — C: 3% libre``
2. ``MODE=DISPATCH — Site [NOM] hors ligne depuis [heure]``
3. ``MODE=ESCALADE_SLA — P2 — SLA réponse dans 5 min — non assigné``
4. ``MODE=SHIFT_HANDOVER — Passation de quart — [DATE] [HEURE]``

---

## 4. KNOWLEDGE — Fichiers à uploader

### 🔴 CRITIQUE
| Fichier | Chemin dans le projet | Contenu |
|---|---|---|
| `BUNDLE_KP_NOCDispatcher_V1.md` | `IT-SHARED/60_BUNDLES/` | KnowledgePack SLA, routing, NOC |

### 🟠 IMPORTANT
| Fichier | Chemin | Contenu |
|---|---|---|
| `REFERENCE__SLA_Matrix.md` | `knowledge/` | Matrice SLA P1→P4 |
| `RUNBOOK__NOC_Procedures.md` | `knowledge/` | Procédures NOC |
| `CHECKLIST__Shift_Handover.md` | `knowledge/` | Passation de quart |

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
| `MODE=DISPATCH — DISK_CRITICAL SRV-FILE01 3% libre` | YAML P2 : owner IT-MaintenanceMaster, SLA calculé |
| P1 non assigné après 10 min | Escalade automatique IT-Commandare-NOC — obligatoire |

---

## 7. DIFFÉRENCES CLÉS vs AUTRES AGENTS

| | IT-NOCDispatcher | IT-Commandare-NOC |
|---|---|
| Dispatch initial — routing | Pilotage opérations NOC |
| Qualification + assignation | Coordination réponse réseau |

---

## 8. RÉFÉRENCES

| Élément | Valeur |
|---|---|
| **Fichier agent** | `20_Agents/IT-NOCDispatcher/agent.yaml` |
| **Contrat** | `20_Agents/IT-NOCDispatcher/contract.yaml` |
| **Prompt** | `20_Agents/IT-NOCDispatcher/prompt.md` (97L) |
| **Instructions** | `20_Agents/IT-NOCDispatcher/00_INSTRUCTIONS.md` |
| **Knowledge Index** | `20_Agents/IT-NOCDispatcher/04_KNOWLEDGE_INDEX.md` |
| **Guardrails** | `IT-SHARED/10_RUNBOOKS/00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md` |
| **Version** | 2.0.0 |

*GPT Setup Card v2.0 — IT-NOCDispatcher — IT MSP Intelligence Platform*
