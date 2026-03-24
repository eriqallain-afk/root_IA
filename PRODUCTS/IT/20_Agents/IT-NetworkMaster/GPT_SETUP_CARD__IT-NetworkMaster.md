# GPT SETUP CARD — @IT-NetworkMaster
> **Usage :** Fiche de configuration complète pour le GPT Editor d'OpenAI.
> **Version :** 2.0.0 | **Mise à jour :** 2026-03-22

---

## 1. IDENTITÉ GPT

| Champ GPT Editor | Valeur |
|---|---|
| **Name** | IT-NetworkMaster |
| **Description** | Expert réseau et firewalls MSP — WatchGuard, Fortinet, SonicWall, Meraki, UniFi, MikroTik, VPN SSL/IPSec/L2TP. YAML strict. |

---

## 2. INSTRUCTIONS (System Prompt)

**Source :** `00_INSTRUCTIONS.md` — coller dans le champ Instructions

> Le `prompt.md` (163L) est le système complet — mettre en Knowledge.

---

## 3. CONVERSATION STARTERS

1. ``MODE=WATCHGUARD — VPN SSL inaccessible depuis [heure]``
2. ``MODE=FORTINET — Tunnel IPSec [NOM] down``
3. ``MODE=VPN_UTILISATEUR — Erreur 789 L2TP``
4. ``MODE=DIAGNOSTIC_RESEAU — Site [NOM] hors ligne``

---

## 4. KNOWLEDGE — Fichiers à uploader

### 🔴 CRITIQUE
| Fichier | Chemin dans le projet | Contenu |
|---|---|---|
| `BUNDLE_KP_NetworkMaster_V1.md` | `IT-SHARED/60_BUNDLES/` | KnowledgePack réseau/firewalls |

### 🟠 IMPORTANT
| Fichier | Chemin | Contenu |
|---|---|---|
| `RUNBOOK__Network_Setup.md` | `knowledge/` | Configuration réseau |

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
| **Web Search** | Oui | CVE firewalls, firmware, notes de version |
| **DALL·E** | Non |  |
| **Code Interpreter** | Non |  |

---

## 6. TESTS DE VALIDATION POST-CONFIGURATION

| Message test | Comportement attendu |
|---|---|
| `MODE=VPN_UTILISATEUR — Erreur 789 L2TP Meraki` | YAML : fix registre AssumeUDPEncapsulationContextOnSendRule + reboot |
| Modification firewall sans billet CW | Refus + exiger billet CW approuvé |

---

## 7. DIFFÉRENCES CLÉS vs AUTRES AGENTS

| | IT-NetworkMaster | IT-Commandare-NOC |
|---|---|
| Technicien spécialiste réseau | Dispatcher/coordinateur NOC |
| Diagnostic + remédiation | Triage + routing |

---

## 8. RÉFÉRENCES

| Élément | Valeur |
|---|---|
| **Fichier agent** | `20_Agents/IT-NetworkMaster/agent.yaml` |
| **Contrat** | `20_Agents/IT-NetworkMaster/contract.yaml` |
| **Prompt** | `20_Agents/IT-NetworkMaster/prompt.md` (163L) |
| **Instructions** | `20_Agents/IT-NetworkMaster/00_INSTRUCTIONS.md` |
| **Knowledge Index** | `20_Agents/IT-NetworkMaster/04_KNOWLEDGE_INDEX.md` |
| **Guardrails** | `IT-SHARED/10_RUNBOOKS/00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md` |
| **Version** | 2.0.0 |

*GPT Setup Card v2.0 — IT-NetworkMaster — IT MSP Intelligence Platform*
