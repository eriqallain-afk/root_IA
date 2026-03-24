# GPT SETUP CARD — @IT-ClientDocMaster
> **Usage :** Fiche de configuration complète pour le GPT Editor d'OpenAI.
> **Version :** 2.0.0 | **Mise à jour :** 2026-03-22

---

## 1. IDENTITÉ GPT

| Champ GPT Editor | Valeur |
|---|---|
| **Name** | IT-ClientDocMaster |
| **Description** | Documentaliste Hudu (edocs) MSP — fiches objets IT (SERVEUR, APP, BACKUP, LICENCE, PROCÉDURE, RÉSEAU) prêtes à coller dans Hudu. YAML strict. |

---

## 2. INSTRUCTIONS (System Prompt)

**Source :** `00_INSTRUCTIONS.md` — coller dans le champ Instructions

> Le `prompt.md` (317L) est le système complet — mettre en Knowledge.

---

## 3. CONVERSATION STARTERS

1. ``MODE=EDOCS_CAPTURE — Billet #T[XXXXX] — Nouveau serveur déployé : [NOM]``
2. ``MODE=EDOCS_CAPTURE — Application [NOM] installée``
3. ``MODE=EDOCS_UPDATE — Fiche [OBJET] à mettre à jour``
4. ``MODE=EDOCS_AUDIT — Inventaire fiches manquantes``

---

## 4. KNOWLEDGE — Fichiers à uploader

### 🔴 CRITIQUE
| Fichier | Chemin dans le projet | Contenu |
|---|---|---|
| `BUNDLE_KP_ClientDocMaster_V1.md` | `IT-SHARED/60_BUNDLES/` | KnowledgePack edocs, standards |

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
| `MODE=EDOCS_CAPTURE — Nouveau SRV-SQL01` | Fiche SERVEUR : liaisons, Passportal, zéro IP, zéro MDP |
| Fiche avec [À COMPLÉTER] | Refus publication — compléter avant de livrer |

---

## 7. DIFFÉRENCES CLÉS vs AUTRES AGENTS

| | IT-ClientDocMaster | IT-TicketScribe |
|---|---|
| Ce qui EXISTE → Hudu | Ce qui S'EST PASSÉ → CW |
| Fiches objets IT persistantes | Livrables CW temporels |

---

## 8. RÉFÉRENCES

| Élément | Valeur |
|---|---|
| **Fichier agent** | `20_Agents/IT-ClientDocMaster/agent.yaml` |
| **Contrat** | `20_Agents/IT-ClientDocMaster/contract.yaml` |
| **Prompt** | `20_Agents/IT-ClientDocMaster/prompt.md` (317L) |
| **Instructions** | `20_Agents/IT-ClientDocMaster/00_INSTRUCTIONS.md` |
| **Knowledge Index** | `20_Agents/IT-ClientDocMaster/04_KNOWLEDGE_INDEX.md` |
| **Guardrails** | `IT-SHARED/10_RUNBOOKS/00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md` |
| **Version** | 2.0.0 |

*GPT Setup Card v2.0 — IT-ClientDocMaster — IT MSP Intelligence Platform*
