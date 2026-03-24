# GPT SETUP CARD — @IT-AssistanTI_FrontLine
> **Usage :** Fiche de configuration complète pour le GPT Editor d'OpenAI.
> **Version :** 1.1.0 | **Mise à jour :** 2026-03-22

---

## 1. IDENTITÉ GPT

| Champ GPT Editor | Valeur |
|---|---|
| **Name** | IT-AssistanTI_FrontLine |
| **Description** | Technicien N2 MSP première ligne. Deux sources de travail : tickets N2 poussés par MSPBOT par ordre de priorité, et appels directs entrants. Mode appel : 🎙️ script exact + ⚡ action simultanée + menus numérotés. Mode ticket : plan d'action immédiat à réception. Scope N2 complet. Clôture CW complète (Note Interne + Discussion STAR). |

---

## 2. INSTRUCTIONS (System Prompt)

**Source :** `00_INSTRUCTIONS.md` — coller le contenu dans le champ **Instructions**

> Le `prompt.md` (471L) est le système complet — il doit être le **premier fichier** uploadé en Knowledge.

---

## 3. CONVERSATION STARTERS

1. `/appel` — Démarrer un appel direct entrant
2. `/ticket #T[XXXXX]` — Billet N2 reçu de MSPBOT — [résumé du problème]
3. `/ticket #T[XXXXX]` — Assigné par coordinateur — MDP utilisateur [NOM]
4. `/triage` — Générer la note CW avant transfert vers N3

---

## 4. KNOWLEDGE — Fichiers à uploader (ordre d'importance)

### 🔴 CRITIQUE — uploader EN PREMIER
| Fichier | Chemin | Contenu |
|---|---|---|
| `prompt.md` | `20_Agents/IT-AssistanTI_FrontLine/` | Système complet : /appel, /ticket, arbres de décision, scripts d'appel, SLA, escalades |
| `BUNDLE_KP_AssistanTI-FrontLine_V1.md` | `IT-SHARED/60_BUNDLES/` | KnowledgePack procédures helpdesk |

### 🟠 IMPORTANT
| Fichier | Chemin | Contenu |
|---|---|---|
| `REFERENCE__SLA_FrontLine.md` | `knowledge/` | Matrice SLA, règles scope, escalades par domaine |
| `REFERENCE__Scripts_FrontLine.md` | `knowledge/` | Scripts PS prêts : AD, imprimante, Outlook, VPN, poste |
| `TEMPLATE__CW_NOTE_INTERNE_FrontLine.md` | `02_TEMPLATES/` | Template Note Interne avec phrase d'ouverture imposée |
| `TEMPLATE__CW_DISCUSSION_STAR_FrontLine.md` | `02_TEMPLATES/` | Template Discussion STAR client-safe |
| `TEMPLATE__CW_NOTE_TRIAGE.md` | `02_TEMPLATES/` | Template triage avant transfert |
| `RUNBOOK__IT_SUPPORT_TRIAGE_N1N2N3_V1.md` | `IT-SHARED/10_RUNBOOKS/SUPPORT/` | Triage N1/N2/N3 |
| `RB-001_procedure-principale.md` | `02_RUNBOOKS/` | Flux complet + arbres de décision scope |

### 🟡 OPTIONNEL
| Fichier | Chemin | Contenu |
|---|---|---|
| `REFERENCE__SLA_Matrix.md` | `IT-SHARED/50_REFERENCE/` | Matrice SLA globale MSP |
| `EX-001_cas-nominal.md` | `04_EXEMPLES/` | Exemple complet ticket MSPBOT + appel résolu |

### ❌ NE PAS UPLOADER
| Fichier | Raison |
|---|---|
| `agent.yaml` | Config machine |
| `contract.yaml` | Schéma interne |
| `manifest.json` | Metadata machine |
| `00_INSTRUCTIONS.md` | Déjà dans le champ Instructions |
| `03_PROMPT_ARCHIVE.md` | Version archivée |

> **Limite GPT Knowledge :** 20 fichiers max. Prioriser dans l'ordre : 🔴 → 🟠 → 🟡

---

## 5. CAPABILITIES

| Capability | Activer ? | Raison |
|---|---|---|
| **Web Search** | Non | Procédures internes — pas besoin de recherche externe |
| **DALL·E** | Non | Agent technique |
| **Code Interpreter** | Non | Pas nécessaire |

---

## 6. TESTS DE VALIDATION POST-CONFIGURATION

| Message test | Comportement attendu |
|---|---|
| `/appel` | Menu immédiat : billet existant [1] ou nouveau [2] → identification → menu triage [1-11] |
| `/ticket #T99999 — compte verrouillé jean.dupont` | Plan d'action P3 : vérification identité obligatoire + commandes AD |
| MDP sans vérification identité | Refus poli — propose les 3 méthodes de vérification |
| `Erreur 789 VPN L2TP` | Fix registre AssumeUDPEncapsulationContextOnSendRule + avertissement redémarrage |
| `Outlook ne s'ouvre pas` | Menu [1-4] → outlook.exe /safe → /cleanprofile → .ost |
| P1 mentionné (ransomware) | P1 immédiat → escalade @IT-SecurityMaster → aucune tentative de résolution |
| `/triage` | Note de triage CW complète et structurée, prête à coller |
| `/close` | CW Note Interne (phrase d'ouverture imposée) + Discussion STAR (client-safe) |
| `Processus inconnu 100% CPU` | Stop — escalade @IT-SecurityMaster — ne pas kill le processus |
| Demande hors IT | Refus poli — un seul message |

---

## 7. DIFFÉRENCES CLÉS vs AGENTS SIMILAIRES

| | IT-AssistanTI_FrontLine | IT-AssistanTI_N2 | IT-AssistanTI_N3 |
|---|---|---|---|
| Source billets | MSPBOT push par priorité + appels directs | Tous billets CW | Tous billets CW |
| Mode appel | 🎙️ script exact + ⚡ action simultanée + menus | Guide étape par étape | Guide étape par étape |
| Mode ticket MSPBOT | Plan d'action immédiat à réception | Résolution guidée standard | Résolution guidée N3 |
| Scope | N2 complet | N1/N2 helpdesk | N1 à N3 — tous domaines |
| Clôture CW | Note Interne + Discussion STAR | Note Interne + Discussion STAR | Note Interne + Discussion STAR |
| Playbook | IT_FRONTLINE_CALL_TO_CLOSE | — | IT_MSP_TICKET_TO_KB |

---

## 8. AJOUTS REQUIS DANS LES FICHIERS INDEX

> Ces modifications doivent être appliquées manuellement dans les fichiers 00_INDEX du projet.
> Les fichiers PATCH correspondants sont dans le dossier `/00_INDEX_PATCHES/`.

| Fichier | Modification | Fichier PATCH |
|---|---|---|
| `00_INDEX/agents.yaml` | Ajouter entrée IT-AssistanTI_FrontLine | `PATCH__agents_yaml.md` |
| `00_INDEX/agents_index.yaml` | Ajouter entrée complète avec intents | `PATCH__agents_index_yaml.md` |
| `00_INDEX/gpt_catalog.yaml` | Ajouter entrée avec paths | `PATCH__gpt_catalog_yaml.md` |
| `00_INDEX/intents.yaml` | Ajouter intents frontline | `PATCH__intents_yaml.md` |
| `00_INDEX/KNOWLEDGE_INDEX.yaml` | Ajouter consumers + section agent | `PATCH__KNOWLEDGE_INDEX_yaml.md` |
| `00_INDEX/product.yaml` | Mettre à jour version + agent_count | `PATCH__product_yaml.md` |
| `80_MACHINES/hub_routing.yaml` | Ajouter route frontline | `PATCH__hub_routing_yaml.md` |
| `playbooks/playbooks.yaml` | Ajouter IT_FRONTLINE_CALL_TO_CLOSE | `PATCH__playbooks_yaml.md` |

---

## 9. PLAYBOOK IT_FRONTLINE_CALL_TO_CLOSE

```yaml
IT_FRONTLINE_CALL_TO_CLOSE:
  description: >
    Flux première ligne (FrontLine) : réception billet MSPBOT ou appel direct ->
    triage -> résolution N2 -> clôture CW -> KB si P1/P2.
  steps:
  - step: receive
    actor_id: IT-AssistanTI_FrontLine
  - step: triage_and_resolve
    actor_id: IT-AssistanTI_FrontLine
  - step: closeout
    actor_id: IT-AssistanTI_FrontLine
  - step: kb_if_needed
    actor_id: IT-KnowledgeKeeper
    condition: P1 ou P2 ou nouveau_type
  - step: archive
    actor_id: OPS-DossierIA
```

---

## 10. RÉFÉRENCES

| Élément | Valeur |
|---|---|
| **Fichier agent** | `20_Agents/IT-AssistanTI_FrontLine/agent.yaml` |
| **Contrat** | `20_Agents/IT-AssistanTI_FrontLine/contract.yaml` |
| **Prompt** | `20_Agents/IT-AssistanTI_FrontLine/prompt.md` (471L) |
| **Instructions** | `20_Agents/IT-AssistanTI_FrontLine/00_INSTRUCTIONS.md` |
| **Knowledge Index** | `20_Agents/IT-AssistanTI_FrontLine/04_KNOWLEDGE_INDEX.md` |
| **Playbook** | `IT_FRONTLINE_CALL_TO_CLOSE` |
| **Guardrails** | `IT-SHARED/10_RUNBOOKS/00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md` |
| **Version** | 1.1.0 |

*GPT Setup Card v2.0 — IT-AssistanTI_FrontLine — IT MSP Intelligence Platform*
