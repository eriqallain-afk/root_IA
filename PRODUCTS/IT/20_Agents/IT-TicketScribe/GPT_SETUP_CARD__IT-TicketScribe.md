# GPT SETUP CARD — @IT-TicketScribe
> **Usage :** Fiche de configuration complète pour le GPT Editor d'OpenAI.
> **Version :** 2.0.0 | **Mise à jour :** 2026-03-22

---

## 1. IDENTITÉ GPT

| Champ GPT Editor | Valeur |
|---|---|
| **Name** | IT-TicketScribe |
| **Description** | Rédacteur ConnectWise & documentaliste Hudu MSP — CW Note Interne, Discussion STAR, emails, annonces Teams, briefs /kb, fiches edocs Hudu. |

---

## 2. INSTRUCTIONS (System Prompt)

**Source :** `00_INSTRUCTIONS.md` — coller dans le champ Instructions

> Le `prompt.md` (379L) est le système complet — mettre en Knowledge.

---

## 3. CONVERSATION STARTERS

1. ``MODE=NOTE_INTERNE — Billet #T[XXXXX] — [Coller contexte intervention]``
2. ``MODE=DISCUSSION — Billet #T[XXXXX] — [Résumé intervention]``
3. ``MODE=EMAIL_CLIENT — Billet #T[XXXXX] — [Objet + résumé]``
4. ``MODE=AVIS_TEAMS — Début maintenance — [CLIENT] — [SERVEUR] — [HEURE]``

---

## 4. KNOWLEDGE — Fichiers à uploader

### 🔴 CRITIQUE
| Fichier | Chemin dans le projet | Contenu |
|---|---|---|
| `BUNDLE_KP_TicketScribe_V1.md` | `IT-SHARED/60_BUNDLES/` | KnowledgePack templates CW, edocs |

### 🟠 IMPORTANT
| Fichier | Chemin | Contenu |
|---|---|---|
| `EXEMPLE_kb_brief_1683171.yaml` | `04_EXEMPLES/` | Exemple brief /kb structuré |

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
| `MODE=NOTE_INTERNE — résumé intervention` | "Prise de connaissance de la demande et consultation de la documentation du client." + timeline + commandes |
| IP dans Discussion CW | Masquage automatique → zéro détails techniques dans livrable client |
| `MODE=AVIS_TEAMS — début maintenance` | Annonce Teams : 🔧 emoji, client, serveurs, heure début/fin, impact |

---

## 7. DIFFÉRENCES CLÉS vs AUTRES AGENTS

| | IT-TicketScribe | IT-Commandare-OPR |
|---|---|
| Rédige les livrables CW/edocs | Pilote les opérations documentaires |
| Note Interne, Discussion, Email, Teams | Mobilise TicketScribe, ReportMaster, AssetMaster |

---

## 8. RÉFÉRENCES

| Élément | Valeur |
|---|---|
| **Fichier agent** | `20_Agents/IT-TicketScribe/agent.yaml` |
| **Contrat** | `20_Agents/IT-TicketScribe/contract.yaml` |
| **Prompt** | `20_Agents/IT-TicketScribe/prompt.md` (379L) |
| **Instructions** | `20_Agents/IT-TicketScribe/00_INSTRUCTIONS.md` |
| **Knowledge Index** | `20_Agents/IT-TicketScribe/04_KNOWLEDGE_INDEX.md` |
| **Guardrails** | `IT-SHARED/10_RUNBOOKS/00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md` |
| **Version** | 2.0.0 |

*GPT Setup Card v2.0 — IT-TicketScribe — IT MSP Intelligence Platform*
