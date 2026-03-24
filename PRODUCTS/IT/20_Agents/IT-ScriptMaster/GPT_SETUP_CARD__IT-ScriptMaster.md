# GPT SETUP CARD — @IT-ScriptMaster
> **Usage :** Fiche de configuration complète pour le GPT Editor d'OpenAI.
> **Version :** 2.0.0 | **Mise à jour :** 2026-03-22

---

## 1. IDENTITÉ GPT

| Champ GPT Editor | Valeur |
|---|---|
| **Name** | IT-ScriptMaster |
| **Description** | Générateur scripts PS/Bash/CMD production-ready pour MSP. Standards : header, UTF-8, transcript, logging, dry-run, gestion erreurs. |

---

## 2. INSTRUCTIONS (System Prompt)

**Source :** `00_INSTRUCTIONS.md` — coller dans le champ Instructions

> Le `prompt.md` (112L) est le système complet — mettre en Knowledge.

---

## 3. CONVERSATION STARTERS

1. ``POWERSHELL — Billet #T[XXXXX] — Health check CPU/RAM/disk sur [SERVEUR]``
2. ``POWERSHELL — Nettoyage dossiers temp sur [SERVEUR]``
3. ``BASH — Vérification services arrêtés sur serveur Linux``
4. ``AUDIT_SCRIPT — Auditer la qualité de ce script : [coller script]``

---

## 4. KNOWLEDGE — Fichiers à uploader

### 🔴 CRITIQUE
| Fichier | Chemin dans le projet | Contenu |
|---|---|---|
| `BUNDLE_KP_ScriptMaster_V1.md` | `IT-SHARED/60_BUNDLES/` | KnowledgePack templates PS, snippets |

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
| **Web Search** | Oui | Documentation PS, modules, cmdlets |
| **DALL·E** | Non |  |
| **Code Interpreter** | Optionnel | Tester la logique du script |

---

## 6. TESTS DE VALIDATION POST-CONFIGURATION

| Message test | Comportement attendu |
|---|---|
| `POWERSHELL — Health check SRV-DC01` | PS : header #Requires, ⚠️ Impact, UTF-8, Transcript C:\IT_LOGS\DIAG\, Try/Catch |
| Credentials dans script demandé | Refus + SecureString ou Passportal |

---

## 7. DIFFÉRENCES CLÉS vs AUTRES AGENTS

| | IT-ScriptMaster | IT-MaintenanceMaster (/script) |
|---|---|
| Spécialiste scripting — scripts complexes | Scripts standards maintenance |
| AUDIT_SCRIPT — revue qualité | Génération dans contexte intervention |

---

## 8. RÉFÉRENCES

| Élément | Valeur |
|---|---|
| **Fichier agent** | `20_Agents/IT-ScriptMaster/agent.yaml` |
| **Contrat** | `20_Agents/IT-ScriptMaster/contract.yaml` |
| **Prompt** | `20_Agents/IT-ScriptMaster/prompt.md` (112L) |
| **Instructions** | `20_Agents/IT-ScriptMaster/00_INSTRUCTIONS.md` |
| **Knowledge Index** | `20_Agents/IT-ScriptMaster/04_KNOWLEDGE_INDEX.md` |
| **Guardrails** | `IT-SHARED/10_RUNBOOKS/00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md` |
| **Version** | 2.0.0 |

*GPT Setup Card v2.0 — IT-ScriptMaster — IT MSP Intelligence Platform*
