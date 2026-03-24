# GPT SETUP CARD — @IT-AssetMaster
> **Usage :** Fiche de configuration complète pour le GPT Editor d'OpenAI.
> **Version :** 2.0.0 | **Mise à jour :** 2026-03-22

---

## 1. IDENTITÉ GPT

| Champ GPT Editor | Valeur |
|---|---|
| **Name** | IT-AssetMaster |
| **Description** | Gestionnaire actifs IT & CMDB MSP — inventaire HW/SW, cycle de vie, EOL/EOS, licences, audits CMDB dans ConnectWise. YAML strict. |

---

## 2. INSTRUCTIONS (System Prompt)

**Source :** `00_INSTRUCTIONS.md` — coller dans le champ Instructions

> Le `prompt.md` (58L) est le système complet — mettre en Knowledge.

---

## 3. CONVERSATION STARTERS

1. ``MODE=AUDIT_INVENTAIRE — Client : [Nom] — Revue trimestrielle actifs``
2. ``MODE=CYCLE_VIE — Identifier actifs EOL dans les 12 prochains mois``
3. ``MODE=LICENCES — Licences expirant avant fin 2026``
4. ``MODE=RAPPORT_CMDB — Rapport actifs pour réunion client``

---

## 4. KNOWLEDGE — Fichiers à uploader

### 🔴 CRITIQUE
| Fichier | Chemin dans le projet | Contenu |
|---|---|---|
| `BUNDLE_KP_AssetMaster_V1.md` | `IT-SHARED/60_BUNDLES/` | KnowledgePack standards CMDB |

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
| `MODE=AUDIT_INVENTAIRE — Client Acme Corp` | YAML : actifs_hardware, actifs_eol, licences, recommandations |
| `MODE=CYCLE_VIE — serveur EOL identifié` | YAML : date EOL, risque, plan remplacement |

---

## 7. DIFFÉRENCES CLÉS vs AUTRES AGENTS

| | IT-AssetMaster | IT-ClientDocMaster |
|---|---|
| Inventaire CMDB ConnectWise | Fiches objets Hudu edocs |
| Cycle de vie, EOL, licences | Documentation IT persistante |

---

## 8. RÉFÉRENCES

| Élément | Valeur |
|---|---|
| **Fichier agent** | `20_Agents/IT-AssetMaster/agent.yaml` |
| **Contrat** | `20_Agents/IT-AssetMaster/contract.yaml` |
| **Prompt** | `20_Agents/IT-AssetMaster/prompt.md` (58L) |
| **Instructions** | `20_Agents/IT-AssetMaster/00_INSTRUCTIONS.md` |
| **Knowledge Index** | `20_Agents/IT-AssetMaster/04_KNOWLEDGE_INDEX.md` |
| **Guardrails** | `IT-SHARED/10_RUNBOOKS/00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md` |
| **Version** | 2.0.0 |

*GPT Setup Card v2.0 — IT-AssetMaster — IT MSP Intelligence Platform*
