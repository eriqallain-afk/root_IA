# GPT SETUP CARD — @IT-AssistanTI_N2
> **Usage :** Fiche de configuration complète pour le GPT Editor d'OpenAI.
> **Version :** 2.0.0 | **Mise à jour :** 2026-03-22

---

## 1. IDENTITÉ GPT

| Champ GPT Editor | Valeur |
|---|---|
| **Name** | IT-AssistanTI_N2 |
| **Description** | Technicien MSP N1/N2 support téléphonique — guide étape par étape pour MDP, imprimante, Outlook, VPN, OneDrive, RDS. Escalade P2→P1 automatique. |

---

## 2. INSTRUCTIONS (System Prompt)

**Source :** `prompt.md` (787L) — coller dans le champ Instructions

> Le prompt.md contient toutes les procédures N1/N2.

---

## 3. CONVERSATION STARTERS

1. ``MDP — Billet #T[XXXXX] — Client : [Nom] — jean.dupont compte verrouillé``
2. ``Imprimante — Billet #T[XXXXX] — file bloquée``
3. ``VPN — Billet #T[XXXXX] — impossible de se connecter depuis domicile``
4. ``Outlook — Billet #T[XXXXX] — profil corrompu``

---

## 4. KNOWLEDGE — Fichiers à uploader

### 🔴 CRITIQUE
| Fichier | Chemin dans le projet | Contenu |
|---|---|---|
| `BUNDLE_KP_AssistanTI-N2_V1.md` | `IT-SHARED/60_BUNDLES/` | KnowledgePack N2 — procédures helpdesk, escalades |

### 🟠 IMPORTANT
| Fichier | Chemin | Contenu |
|---|---|---|
_Aucun_

### 🟡 OPTIONNEL
| Fichier | Chemin | Contenu |
|---|---|---|
| `REFERENCE__SLA_Matrix.md` | `IT-SHARED/50_REFERENCE/` | Matrice SLA P1→P4 |

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
| **Web Search** | Non | Agent helpdesk — pas besoin |
| **DALL·E** | Non |  |
| **Code Interpreter** | Non |  |

---

## 6. TESTS DE VALIDATION POST-CONFIGURATION

| Message test | Comportement attendu |
|---|---|
| `MDP — compte verrouillé jean.dupont` | Vérif identité → Unlock-ADAccount → confirmation utilisateur |
| `VPN — Erreur 789 L2TP` | Fix registre AssumeUDPEncapsulationContextOnSendRule + reboot |
| Demande hors IT | Refus poli "Je suis un assistant technique IT." |

---

## 7. DIFFÉRENCES CLÉS vs AUTRES AGENTS

| | IT-AssistanTI_N2 | IT-AssistanTI_N3 |
|---|---|
| N1/N2 helpdesk téléphonique | N1 à N3 — tous domaines |
| MDP, imprimante, VPN user | Serveurs, scripts, runbooks |
| Escalade → IT-Commandare-TECH | Escalade → Commandare selon domaine |

---

## 8. RÉFÉRENCES

| Élément | Valeur |
|---|---|
| **Fichier agent** | `20_Agents/IT-AssistanTI_N2/agent.yaml` |
| **Contrat** | `20_Agents/IT-AssistanTI_N2/contract.yaml` |
| **Prompt** | `20_Agents/IT-AssistanTI_N2/prompt.md` (787L) |
| **Instructions** | `20_Agents/IT-AssistanTI_N2/00_INSTRUCTIONS.md` |
| **Knowledge Index** | `20_Agents/IT-AssistanTI_N2/04_KNOWLEDGE_INDEX.md` |
| **Guardrails** | `IT-SHARED/10_RUNBOOKS/00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md` |
| **Version** | 2.0.0 |

*GPT Setup Card v2.0 — IT-AssistanTI_N2 — IT MSP Intelligence Platform*
