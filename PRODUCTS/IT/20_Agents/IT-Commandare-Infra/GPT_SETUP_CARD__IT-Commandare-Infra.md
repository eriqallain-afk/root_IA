# GPT SETUP CARD — @IT-Commandare-Infra
> **Usage :** Fiche de configuration complète pour le GPT Editor d'OpenAI.
> **Version :** 2.0.0 | **Mise à jour :** 2026-03-22

---

## 1. IDENTITÉ GPT

| Champ GPT Editor | Valeur |
|---|---|
| **Name** | IT-Commandare-Infra |
| **Description** | Commandare INFRA MSP — pilote incidents infrastructure (serveurs, VMs, DC/AD, Azure, backup/DR). Mobilise spécialistes, coordonne. P1 < 5 min. YAML strict. |

---

## 2. INSTRUCTIONS (System Prompt)

**Source :** `00_INSTRUCTIONS.md` — coller dans le champ Instructions

> Le `prompt.md` (73L) est le système complet — mettre en Knowledge.

---

## 3. CONVERSATION STARTERS

1. ``TRIAGE_INCIDENT — Billet #T[XXXXX] — [SERVEUR] inaccessible depuis [heure]``
2. ``TRIAGE_INCIDENT — DC01 CPU 0% — alertes RMM``
3. ``TRIAGE_INCIDENT — Alerte stockage SAN — espace critique``
4. ``ESCALADE — Multi-domaines : serveur + réseau + backup simultanés``

---

## 4. KNOWLEDGE — Fichiers à uploader

### 🔴 CRITIQUE
| Fichier | Chemin dans le projet | Contenu |
|---|---|---|
| `BUNDLE_KP_Commandare-Infra_V1.md` | `IT-SHARED/60_BUNDLES/` | KnowledgePack routing + matrice sévérité |

### 🟠 IMPORTANT
| Fichier | Chemin | Contenu |
|---|---|---|
| `IT__Routing_Rules.md` | `IT_Commandare_INFRA_KnowledgePack_v1/` | Routing spécialistes |
| `IT__Severity_Matrix.md` | `IT_Commandare_INFRA_KnowledgePack_v1/` | Matrice sévérité infra |
| `EXAMPLES__Infra_Incidents.md` | `IT_Commandare_INFRA_KnowledgePack_v1/` | Exemples incidents |

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
| `DC01 inaccessible — CPU 0%` | YAML P1 : routing IT-MaintenanceMaster, plan action, validation post-fix |
| Incident sécurité mentionné | Escalade IT-SecurityMaster en lead — immédiat |

---

## 7. DIFFÉRENCES CLÉS vs AUTRES AGENTS

| | IT-Commandare-Infra | IT-Commandare-NOC |
|---|---|
| Serveurs, VMs, DC, stockage | Réseau, VPN, backup, monitoring |
| Mobilise MaintenanceMaster | Mobilise NetworkMaster, BackupDRMaster |

---

## 8. RÉFÉRENCES

| Élément | Valeur |
|---|---|
| **Fichier agent** | `20_Agents/IT-Commandare-Infra/agent.yaml` |
| **Contrat** | `20_Agents/IT-Commandare-Infra/contract.yaml` |
| **Prompt** | `20_Agents/IT-Commandare-Infra/prompt.md` (73L) |
| **Instructions** | `20_Agents/IT-Commandare-Infra/00_INSTRUCTIONS.md` |
| **Knowledge Index** | `20_Agents/IT-Commandare-Infra/04_KNOWLEDGE_INDEX.md` |
| **Guardrails** | `IT-SHARED/10_RUNBOOKS/00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md` |
| **Version** | 2.0.0 |

*GPT Setup Card v2.0 — IT-Commandare-Infra — IT MSP Intelligence Platform*
