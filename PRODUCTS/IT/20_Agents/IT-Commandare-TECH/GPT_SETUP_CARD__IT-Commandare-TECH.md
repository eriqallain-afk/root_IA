# GPT SETUP CARD — @IT-Commandare-TECH
> **Usage :** Fiche de configuration complète pour le GPT Editor d'OpenAI.
> **Version :** 2.0.0 | **Mise à jour :** 2026-03-22

---

## 1. IDENTITÉ GPT

| Champ GPT Editor | Valeur |
|---|---|
| **Name** | IT-Commandare-TECH |
| **Description** | Commandare TECH MSP — support N1/N2/N3 et SOC. Seul Commandare utilisable par les équipes FACTORY pour leurs besoins helpdesk. YAML strict. |

---

## 2. INSTRUCTIONS (System Prompt)

**Source :** `00_INSTRUCTIONS.md` — coller dans le champ Instructions

> Le `prompt.md` (81L) est le système complet — mettre en Knowledge.

---

## 3. CONVERSATION STARTERS

1. ``SUPPORT_TRIAGE — Billet #T[XXXXX] — [N] utilisateurs sans accès [SERVICE]``
2. ``SOC — EDR alerte phishing — utilisateur [UPN]``
3. ``SUPPORT_TRIAGE — Application [NOM] crash depuis MàJ``
4. ``CROSS_DEPT — Équipe [CCQ/EDU] — [symptôme]``

---

## 4. KNOWLEDGE — Fichiers à uploader

### 🔴 CRITIQUE
| Fichier | Chemin dans le projet | Contenu |
|---|---|---|
| `BUNDLE_KP_Commandare-TECH_V1.md` | `IT-SHARED/60_BUNDLES/` | KnowledgePack support triage, SOC, escalation |

### 🟠 IMPORTANT
| Fichier | Chemin | Contenu |
|---|---|---|
| `IT__Escalation_Playbook.md` | `IT_Commandare_TECH_KnowledgePack_v1/` | Playbook escalades |
| `IT__Routing_Rules.md` | `IT_Commandare_TECH_KnowledgePack_v1/` | Routing agents TECH |

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
| `SOC — EDR alerte ransomware POSTE-01` | YAML P1 : routing IT-SecurityMaster lead, isolation immédiate sans confirmation |
| `SUPPORT_TRIAGE — 15 users sans Teams 30 min` | YAML P2 : routing IT-CloudMaster, SLA 30 min |

---

## 7. DIFFÉRENCES CLÉS vs AUTRES AGENTS

| | IT-Commandare-TECH | IT-Commandare-NOC |
|---|---|
| Support N1/N2/N3 + SOC | Alertes réseau, VPN, backup |
| Helpdesk tous dpts FACTORY | NOC uniquement |

---

## 8. RÉFÉRENCES

| Élément | Valeur |
|---|---|
| **Fichier agent** | `20_Agents/IT-Commandare-TECH/agent.yaml` |
| **Contrat** | `20_Agents/IT-Commandare-TECH/contract.yaml` |
| **Prompt** | `20_Agents/IT-Commandare-TECH/prompt.md` (81L) |
| **Instructions** | `20_Agents/IT-Commandare-TECH/00_INSTRUCTIONS.md` |
| **Knowledge Index** | `20_Agents/IT-Commandare-TECH/04_KNOWLEDGE_INDEX.md` |
| **Guardrails** | `IT-SHARED/10_RUNBOOKS/00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md` |
| **Version** | 2.0.0 |

*GPT Setup Card v2.0 — IT-Commandare-TECH — IT MSP Intelligence Platform*
