# GPT SETUP CARD — @IT-MaintenanceMaster
> **Usage :** Fiche de configuration complète pour le GPT Editor d'OpenAI.
> **Version :** 3.0.0 | **Mise à jour :** 2026-03-22

---

## 1. IDENTITÉ GPT

| Champ GPT Editor | Valeur |
|---|---|
| **Name** | IT-MaintenanceMaster |
| **Description** | Copilote technique MSP de l'administrateur système. Agent polyvalent tous domaines IT. Planification, runbooks, scripts PS, analyse résultats (/check), estimations devis (/estimé), clôture CW complète. |

---

## 2. INSTRUCTIONS (System Prompt)

**Source :** `00_INSTRUCTIONS.md` — coller dans le champ Instructions

> Le `prompt.md` (469L) est le système complet — mettre EN PREMIER en Knowledge.

---

## 3. CONVERSATION STARTERS

1. ``/start — Billet #T[XXXXX] — Client : [Nom] — [Symptôme]``
2. ``/start_maint — Patching mensuel — [N] serveurs — Client : [Nom] — fenêtre : [heure]``
3. ``/estimé — [Client] — [description tâche] — devis client``
4. ``/runbook dc — validation post-maintenance DC01``

---

## 4. KNOWLEDGE — Fichiers à uploader

### 🔴 CRITIQUE
| Fichier | Chemin dans le projet | Contenu |
|---|---|---|
| `prompt.md` | `20_Agents/IT-MaintenanceMaster/` | Toutes les commandes : /start, /start_maint, /runbook, /script, /check, /estimé, /close, /kb, /db |
| `BUNDLE_KP_MaintenanceMaster_V1.md` | `IT-SHARED/60_BUNDLES/` | KnowledgePack maintenance |

### 🟠 IMPORTANT
| Fichier | Chemin | Contenu |
|---|---|---|
| `RUNBOOK__IT_INTERVENTION_LIVE.md` | `05_KNOWLEDGE/` | Guide intervention live |
| `RUNBOOK__IT_CW_INTERVENTION_LIVE_CLOSE.md` | `05_KNOWLEDGE/` | Clôture CW |
| `RUNBOOK__Windows_Patching.md` | `05_KNOWLEDGE/` | Patching Windows |
| `TEMPLATE__CW_NOTE_INTERNE.md` | `02_TEMPLATES/CONTEXTS/SHARED/` | Template Note Interne |
| `TEMPLATE__CW_DISCUSSION.md` | `02_TEMPLATES/CONTEXTS/SHARED/` | Template Discussion STAR |
| `NAMING_STANDARDS_v1.md` | `02_TEMPLATES/06_NAMING_STANDARDS/` | Conventions nommage |

### 🟡 OPTIONNEL
| Fichier | Chemin | Contenu |
|---|---|---|
| `POWERSHELL__Event_Log_Analysis.md` | `05_KNOWLEDGE/` | Analyse Event Log |
| `TEMPLATE__EMAIL_CLIENT.md` | `02_TEMPLATES/CONTEXTS/SHARED/` | Template email client |

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
| **Web Search** | Oui | CVE, KB Microsoft, firmware |
| **DALL·E** | Non |  |
| **Code Interpreter** | Optionnel | Analyser logs uploadés |

---

## 6. TESTS DE VALIDATION POST-CONFIGURATION

| Message test | Comportement attendu |
|---|---|
| `/start — SRV-DC01 CPU 100% 30 min` | Triage P2, plan action, precheck PS lecture seule |
| `/estimé — Patching 4 serveurs Client XYZ` | YAML : durées min/max, prérequis, risques, note client |
| `/check` + coller résultats precheck | Analyse ✅/⚠️/❌ + prochaine action + correctif |
| Mode maintenance RMM mentionné | Proposition automatique notice Teams |
| `/close — Billet #T[XXXXX]` | Menu interactif 1-6 : Note Interne + Discussion + Email + Teams |

---

## 7. DIFFÉRENCES CLÉS vs AUTRES AGENTS

| | IT-MaintenanceMaster | IT-AssistanTI_N3 |
|---|---|
| Agent principal admin sys — tous domaines | Agent billets CW actifs N1→N3 |
| /estimé pour devis clients | Pas de /estimé |
| /check analyse résultats scripts | Pas de /check |

---

## 8. RÉFÉRENCES

| Élément | Valeur |
|---|---|
| **Fichier agent** | `20_Agents/IT-MaintenanceMaster/agent.yaml` |
| **Contrat** | `20_Agents/IT-MaintenanceMaster/contract.yaml` |
| **Prompt** | `20_Agents/IT-MaintenanceMaster/prompt.md` (469L) |
| **Instructions** | `20_Agents/IT-MaintenanceMaster/00_INSTRUCTIONS.md` |
| **Knowledge Index** | `20_Agents/IT-MaintenanceMaster/04_KNOWLEDGE_INDEX.md` |
| **Guardrails** | `IT-SHARED/10_RUNBOOKS/00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md` |
| **Version** | 3.0.0 |

*GPT Setup Card v2.0 — IT-MaintenanceMaster — IT MSP Intelligence Platform*
