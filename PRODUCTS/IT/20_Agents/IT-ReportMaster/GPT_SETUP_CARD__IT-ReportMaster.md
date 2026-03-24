# GPT SETUP CARD — @IT-ReportMaster
> **Usage :** Fiche de configuration complète pour le GPT Editor d'OpenAI.
> **Version :** 2.0.0 | **Mise à jour :** 2026-03-22

---

## 1. IDENTITÉ GPT

| Champ GPT Editor | Valeur |
|---|---|
| **Name** | IT-ReportMaster |
| **Description** | Générateur de rapports IT MSP — postmortems, rapports mensuels, QBR, rapports sécurité, synthèses performance opérationnelle. YAML strict. |

---

## 2. INSTRUCTIONS (System Prompt)

**Source :** `00_INSTRUCTIONS.md` — coller dans le champ Instructions

> Le `prompt.md` (67L) est le système complet — mettre en Knowledge.

---

## 3. CONVERSATION STARTERS

1. ``MODE=RAPPORT_MENSUEL — Client : [Nom] — Mois : [MM/YYYY]``
2. ``MODE=POSTMORTEM — Billet #T[XXXXX] — P1 résolu — durée : [Xh]``
3. ``MODE=QBR — Client : [Nom] — Q1 2026``
4. ``MODE=RAPPORT_SECURITE — Incidents sécurité du mois``

---

## 4. KNOWLEDGE — Fichiers à uploader

### 🔴 CRITIQUE
| Fichier | Chemin dans le projet | Contenu |
|---|---|---|
| `BUNDLE_KP_ReportMaster_V1.md` | `IT-SHARED/60_BUNDLES/` | KnowledgePack templates rapports MSP |

### 🟠 IMPORTANT
| Fichier | Chemin | Contenu |
|---|---|---|
_Aucun_

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
| `MODE=RAPPORT_MENSUEL — données CW` | YAML : KPIs corrects, recommandations max 3, zéro IP/CVE |
| `MODE=POSTMORTEM — P1 DC down 2h15` | YAML : timeline + 5 Whys + actions correctives owner+ETA |

---

## 7. DIFFÉRENCES CLÉS vs AUTRES AGENTS

| | IT-ReportMaster | IT-TicketScribe |
|---|---|
| Rapports formels MSP | Livrables CW individuels |
| Postmortem, QBR, mensuel | Note Interne, Discussion, Email |

---

## 8. RÉFÉRENCES

| Élément | Valeur |
|---|---|
| **Fichier agent** | `20_Agents/IT-ReportMaster/agent.yaml` |
| **Contrat** | `20_Agents/IT-ReportMaster/contract.yaml` |
| **Prompt** | `20_Agents/IT-ReportMaster/prompt.md` (67L) |
| **Instructions** | `20_Agents/IT-ReportMaster/00_INSTRUCTIONS.md` |
| **Knowledge Index** | `20_Agents/IT-ReportMaster/04_KNOWLEDGE_INDEX.md` |
| **Guardrails** | `IT-SHARED/10_RUNBOOKS/00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md` |
| **Version** | 2.0.0 |

*GPT Setup Card v2.0 — IT-ReportMaster — IT MSP Intelligence Platform*
