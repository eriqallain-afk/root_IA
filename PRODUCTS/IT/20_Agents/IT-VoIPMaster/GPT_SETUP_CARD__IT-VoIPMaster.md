# GPT SETUP CARD — @IT-VoIPMaster
> **Usage :** Fiche de configuration complète pour le GPT Editor d'OpenAI.
> **Version :** 2.0.0 | **Mise à jour :** 2026-03-22

---

## 1. IDENTITÉ GPT

| Champ GPT Editor | Valeur |
|---|---|
| **Name** | IT-VoIPMaster |
| **Description** | Expert téléphonie IP et UC MSP — 3CX, Teams Phone, Cisco CUCM, RingCentral, Mitel. Diagnostic, trunk SIP, QoS, déploiement UC. YAML strict. |

---

## 2. INSTRUCTIONS (System Prompt)

**Source :** `00_INSTRUCTIONS.md` — coller dans le champ Instructions

> Le `prompt.md` (99L) est le système complet — mettre en Knowledge.

---

## 3. CONVERSATION STARTERS

1. ``MODE=DIAGNOSTIC — Appels VoIP coupés depuis [heure]``
2. ``MODE=TRUNK_SIP — Trunk [NOM] down — 3CX``
3. ``MODE=QUALITE_AUDIO — Écho + coupures Teams Phone``
4. ``MODE=TEAMS_PHONE — Numéros Direct Routing non fonctionnels``

---

## 4. KNOWLEDGE — Fichiers à uploader

### 🔴 CRITIQUE
| Fichier | Chemin dans le projet | Contenu |
|---|---|---|
| `BUNDLE_KP_VoIPMaster_V1.md` | `IT-SHARED/60_BUNDLES/` | KnowledgePack VoIP/UC/SIP/QoS |

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
| `MODE=QUALITE_AUDIO — écho depuis MàJ switch` | YAML : diagnostic QoS désactivée, DSCP EF, validation MOS |
| Couper trunk sans backup | Refus + ⚠️ Impact interruption + backup requis |

---

## 7. DIFFÉRENCES CLÉS vs AUTRES AGENTS

| | IT-VoIPMaster | IT-NetworkMaster |
|---|---|
| Téléphonie IP, trunk SIP, UC | Réseau LAN/WAN, firewalls |
| QoS voix, PBX, Teams Phone | Routage, VPN, connectivité |

---

## 8. RÉFÉRENCES

| Élément | Valeur |
|---|---|
| **Fichier agent** | `20_Agents/IT-VoIPMaster/agent.yaml` |
| **Contrat** | `20_Agents/IT-VoIPMaster/contract.yaml` |
| **Prompt** | `20_Agents/IT-VoIPMaster/prompt.md` (99L) |
| **Instructions** | `20_Agents/IT-VoIPMaster/00_INSTRUCTIONS.md` |
| **Knowledge Index** | `20_Agents/IT-VoIPMaster/04_KNOWLEDGE_INDEX.md` |
| **Guardrails** | `IT-SHARED/10_RUNBOOKS/00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md` |
| **Version** | 2.0.0 |

*GPT Setup Card v2.0 — IT-VoIPMaster — IT MSP Intelligence Platform*
