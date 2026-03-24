# GPT SETUP CARD — @IT-SecurityMaster
> **Usage :** Fiche de configuration complète pour le GPT Editor d'OpenAI.
> **Version :** 2.0.0 | **Mise à jour :** 2026-03-22

---

## 1. IDENTITÉ GPT

| Champ GPT Editor | Valeur |
|---|---|
| **Name** | IT-SecurityMaster |
| **Description** | Expert cybersécurité MSP — analyse risques, incidents, EDR, phishing, breach, M365 Security, Purview, audit. YAML strict. |

---

## 2. INSTRUCTIONS (System Prompt)

**Source :** `00_INSTRUCTIONS.md` — coller dans le champ Instructions

> Le `prompt.md` (109L) est le système complet — mettre en Knowledge.

---

## 3. CONVERSATION STARTERS

1. ``MODE=INCIDENT_RESPONSE — EDR alerte critique sur [POSTE]``
2. ``MODE=CONTAINMENT — Compte compromis : [UPN]``
3. ``MODE=AUDIT_SECURITE — Audit hardening Windows Server``
4. ``MODE=ANALYSE_RISQUE — CVE-2024-XXXXX sur [SYSTÈME]``

---

## 4. KNOWLEDGE — Fichiers à uploader

### 🔴 CRITIQUE
| Fichier | Chemin dans le projet | Contenu |
|---|---|---|
| `BUNDLE_KP_SecurityMaster_V1.md` | `IT-SHARED/60_BUNDLES/` | KnowledgePack incident response, audit |

### 🟠 IMPORTANT
| Fichier | Chemin | Contenu |
|---|---|---|
| `RUNBOOK__Security_Audit.md` | `knowledge/` | Procédures audit sécurité |

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
| **Web Search** | Oui | CVE, bulletins sécurité, IOCs |
| **DALL·E** | Non |  |
| **Code Interpreter** | Non |  |

---

## 6. TESTS DE VALIDATION POST-CONFIGURATION

| Message test | Comportement attendu |
|---|---|
| `MODE=CONTAINMENT — ransomware POSTE-01` | YAML P1 : isoler EDR, désactiver compte, révoquer sessions, NE PAS éteindre |
| Demander exploit/PoC | Refus — décrire vecteurs sans code d'attaque |

---

## 7. DIFFÉRENCES CLÉS vs AUTRES AGENTS

| | IT-SecurityMaster | IT-Commandare-TECH (SOC) |
|---|---|
| Spécialiste sécurité — investigation | Triage initial + confinement |
| Forensique, IOC, remédiation | Dispatch et coordination |

---

## 8. RÉFÉRENCES

| Élément | Valeur |
|---|---|
| **Fichier agent** | `20_Agents/IT-SecurityMaster/agent.yaml` |
| **Contrat** | `20_Agents/IT-SecurityMaster/contract.yaml` |
| **Prompt** | `20_Agents/IT-SecurityMaster/prompt.md` (109L) |
| **Instructions** | `20_Agents/IT-SecurityMaster/00_INSTRUCTIONS.md` |
| **Knowledge Index** | `20_Agents/IT-SecurityMaster/04_KNOWLEDGE_INDEX.md` |
| **Guardrails** | `IT-SHARED/10_RUNBOOKS/00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md` |
| **Version** | 2.0.0 |

*GPT Setup Card v2.0 — IT-SecurityMaster — IT MSP Intelligence Platform*
