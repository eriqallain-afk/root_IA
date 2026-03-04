# GUIDE — Knowledge GPT Editor
> Quels fichiers uploader dans l'onglet **Knowledge** de chaque agent
> Version : 1.0 | 2026-02-27 | FACTORY root_IA

---

## Principe général

Le GPT Editor a **deux zones distinctes** :

| Zone | Contenu | Fichier source |
|------|---------|----------------|
| **Instructions** | Le prompt système de l'agent | `prompt.md` → copier-coller |
| **Knowledge** | Fichiers de référence que l'agent consulte | Uploader les fichiers ci-dessous |

> ⚠️ `prompt.md` va dans **Instructions**, pas dans Knowledge.
> `contract.yaml` va dans **Knowledge** — c'est la référence I/O de l'agent.

---

## Règle des BUNDLES

Les fichiers `BUNDLE__<EQUIPE>_UPLOAD.md` dans `FACTORY/90_KNOWLEDGE/` sont conçus
pour **remplacer 5-6 fichiers séparés** en un seul upload. Toujours utiliser le
BUNDLE de l'équipe en premier.

```
FACTORY/90_KNOWLEDGE/
├── BUNDLE__CTL_UPLOAD.md    ← pour CTL-WatchdogIA, CTL-AlertRouter, CTL-HealthReporter
├── BUNDLE__HUB_UPLOAD.md    ← pour HUB-* (sauf MO/MO2 qui ont besoin de plus)
├── BUNDLE__META_UPLOAD.md   ← pour META-*
├── BUNDLE__IAHQ_UPLOAD.md   ← pour IAHQ-*
├── BUNDLE__OPS_UPLOAD.md    ← pour OPS-*
└── BUNDLE__IT_UPLOAD_FULL.md← pour IT-* (bundle très complet 42Ko)
```

---

## Profils par équipe

---

### 🔴 TEAM__CTL — Agents de surveillance

**CTL-WatchdogIA** — surveille la structure FACTORY

| # | Fichier | Chemin | Pourquoi |
|---|---------|--------|----------|
| 1 | `contract.yaml` | `00_CONTROL/agents/CTL-WatchdogIA/contract.yaml` | I/O + seuils drift/orphelins |
| 2 | `BUNDLE__CTL_UPLOAD.md` | `90_KNOWLEDGE/BUNDLE__CTL_UPLOAD.md` | Contexte, règles, escalades |
| 3 | `agents_manifest.yaml` | `00_INDEX/agents_manifest.yaml` | **Critique** — liste des agents à scanner |
| 4 | `agents_index.yaml` | `00_INDEX/agents_index.yaml` | IDs + statuts actifs |
| 5 | `ALERT_THRESHOLDS.yaml` | `00_CONTROL/policies/ALERT_THRESHOLDS.yaml` | Seuils P0/P1/P2/P3 |
| 6 | `naming.md` | `50_POLICIES/naming.md` | Valider les conventions |

**CTL-AlertRouter** — route les alertes

| # | Fichier | Chemin | Pourquoi |
|---|---------|--------|----------|
| 1 | `contract.yaml` | `00_CONTROL/agents/CTL-AlertRouter/contract.yaml` | I/O + format ticket |
| 2 | `BUNDLE__CTL_UPLOAD.md` | `90_KNOWLEDGE/BUNDLE__CTL_UPLOAD.md` | Contexte, règles |
| 3 | `ESCALATION_MATRIX.yaml` | `00_CONTROL/policies/ESCALATION_MATRIX.yaml` | **Critique** — qui alerter pour P0/P1/P2/P3 |
| 4 | `teams_index.yaml` | `00_INDEX/teams_index.yaml` | Connaître les équipes destinataires |

**CTL-HealthReporter** — génère les rapports de santé

| # | Fichier | Chemin | Pourquoi |
|---|---------|--------|----------|
| 1 | `contract.yaml` | `00_CONTROL/agents/CTL-HealthReporter/contract.yaml` | I/O + 3 formats rapport |
| 2 | `BUNDLE__CTL_UPLOAD.md` | `90_KNOWLEDGE/BUNDLE__CTL_UPLOAD.md` | Contexte, règles |
| 3 | `ALERT_THRESHOLDS.yaml` | `00_CONTROL/policies/ALERT_THRESHOLDS.yaml` | Interpréter les scores santé |
| 4 | `ESCALATION_MATRIX.yaml` | `00_CONTROL/policies/ESCALATION_MATRIX.yaml` | Savoir à qui adresser les rapports |

---

### 🟠 TEAM__OPS — Moteur d'exécution

**OPS-RouterIA** — détecte l'intent et route

| # | Fichier | Chemin | Pourquoi |
|---|---------|--------|----------|
| 1 | `contract.yaml` | `20_AGENTS/OPS/OPS-RouterIA/contract.yaml` | I/O + algorithme routage |
| 2 | `BUNDLE__OPS_UPLOAD.md` | `90_KNOWLEDGE/BUNDLE__OPS_UPLOAD.md` | Contexte FACTORY |
| 3 | `hub_routing.yaml` | `40_ROUTING/hub_routing.yaml` | **Critique** — la table de routage |
| 4 | `intents.yaml` | `00_INDEX/intents.yaml` | Mapping intents → agents |
| 5 | `agents_index.yaml` | `00_INDEX/agents_index.yaml` | Valider que l'agent cible existe |

**OPS-PlaybookRunner** — exécute les playbooks

| # | Fichier | Chemin | Pourquoi |
|---|---------|--------|----------|
| 1 | `contract.yaml` | `20_AGENTS/OPS/OPS-PlaybookRunner/contract.yaml` | I/O + format execution_log |
| 2 | `BUNDLE__OPS_UPLOAD.md` | `90_KNOWLEDGE/BUNDLE__OPS_UPLOAD.md` | Contexte FACTORY |
| 3 | `playbooks_index.yaml` | `00_INDEX/playbooks_index.yaml` | Liste des playbooks disponibles |
| 4 | `agents_index.yaml` | `00_INDEX/agents_index.yaml` | Valider que les agents des steps existent |

**OPS-DossierIA** — mémoire persistante

| # | Fichier | Chemin | Pourquoi |
|---|---------|--------|----------|
| 1 | `contract.yaml` | `20_AGENTS/OPS/OPS-DossierIA/contract.yaml` | I/O + 4 opérations |
| 2 | `BUNDLE__OPS_UPLOAD.md` | `90_KNOWLEDGE/BUNDLE__OPS_UPLOAD.md` | Contexte FACTORY |
| 3 | `sla.md` | `50_POLICIES/ops/sla.md` | Respecter les SLA d'archivage |
| 4 | `logging_schema.md` | `50_POLICIES/ops/logging_schema.md` | Format des logs |

---

### 🟡 TEAM__META — Fabrication d'agents

**Tous les agents META** — base commune

| # | Fichier | Chemin | Pourquoi |
|---|---------|--------|----------|
| 1 | `contract.yaml` | `20_AGENTS/META/<ID>/contract.yaml` | I/O spécifique à l'agent |
| 2 | `BUNDLE__META_UPLOAD.md` | `90_KNOWLEDGE/BUNDLE__META_UPLOAD.md` | Contexte + règles META |
| 3 | `naming.md` | `50_POLICIES/naming.md` | Standards de nommage |
| 4 | `TEMPLATE__AGENT.md` | `90_KNOWLEDGE/TEMPLATES/TEMPLATE__AGENT.md` | Template agent à produire |
| 5 | `TEMPLATE__PLAYBOOK.md` | `90_KNOWLEDGE/TEMPLATES/TEMPLATE__PLAYBOOK.md` | Template playbook |

**Agents META supplémentaires selon rôle**

| Agent | Fichier supplémentaire | Raison |
|-------|----------------------|--------|
| `META-PromptMaster` | `META-PROMPT-STYLE-GUIDE.md` | Guide structure prompts |
| `META-AgentProductFactory` | `agents_index.yaml` | Éviter doublons d'IDs |
| `META-GouvernanceQA` | `quality_rules.md` + `agents_manifest.yaml` | Audit qualité + liste complète |
| `META-CartographeRoles` | `agents_index.yaml` | Éviter doublons de rôles |
| `META-PlaybookBuilder` | `playbooks_index.yaml` + `hub_routing.yaml` | Intégrer le nouveau playbook |
| `META-ReversePrompt` | `META-PROMPT-STYLE-GUIDE.md` | Reconstruire selon standards |
| `META-OrchestrateurCentral` | `teams_index.yaml` + `playbooks_index.yaml` | Vue globale pour coordination |

---

### 🔵 TEAM__IAHQ — Stratégie entreprise

**Tous les agents IAHQ** — base commune

| # | Fichier | Chemin | Pourquoi |
|---|---------|--------|----------|
| 1 | `contract.yaml` | `20_AGENTS/IAHQ/<ID>/contract.yaml` | I/O spécifique à l'agent |
| 2 | `BUNDLE__IAHQ_UPLOAD.md` | `90_KNOWLEDGE/BUNDLE__IAHQ_UPLOAD.md` | Contexte + règles IAHQ |

**Agents IAHQ supplémentaires selon rôle**

| Agent | Fichier supplémentaire | Raison |
|-------|----------------------|--------|
| `IAHQ-Economist` | `ROI_ASSUMPTIONS.md` + `ROI_SCENARIOS.md` | Bases de calcul ROI |
| `IAHQ-Strategist` | `TEMPLATE__PROPOSITION_IAHQ.md` + `TEMPLATE__30_60_90.md` | Templates livrables |
| `IAHQ-OrchestreurEntrepriseIA` | `teams_index.yaml` + `playbooks_index.yaml` | Vue FACTORY globale |
| `IAHQ-QualityGate` | `quality_rules.md` | Standards de qualité |
| `IAHQ-TechLeadIA` | *(aucun — le contract suffit)* | — |

---

### 🟢 TEAM__HUB — Orchestration centrale

**HUB-AgentMO-MasterOrchestrator** et **HUB-AgentMO2-DeputyOrchestrator**
(orchestrateurs globaux — besoin maximal)

| # | Fichier | Chemin | Pourquoi |
|---|---------|--------|----------|
| 1 | `contract.yaml` | `20_AGENTS/HUB/<ID>/contract.yaml` | I/O spécifique |
| 2 | `BUNDLE__HUB_UPLOAD.md` | `90_KNOWLEDGE/BUNDLE__HUB_UPLOAD.md` | Contexte + coordination |
| 3 | `agents_manifest.yaml` | `00_INDEX/agents_manifest.yaml` | Vue complète — qui fait quoi |
| 4 | `teams_index.yaml` | `00_INDEX/teams_index.yaml` | Équipes disponibles |
| 5 | `hub_routing.yaml` | `40_ROUTING/hub_routing.yaml` | Table de routage complète |
| 6 | `playbooks_index.yaml` | `00_INDEX/playbooks_index.yaml` | Playbooks disponibles |

**Autres agents HUB** (Concierge, Router, Orchestrator, spécialisés)

| # | Fichier | Chemin | Pourquoi |
|---|---------|--------|----------|
| 1 | `contract.yaml` | `20_AGENTS/HUB/<ID>/contract.yaml` | I/O spécifique |
| 2 | `BUNDLE__HUB_UPLOAD.md` | `90_KNOWLEDGE/BUNDLE__HUB_UPLOAD.md` | Contexte + coordination |
| 3 | `hub_routing.yaml` | `40_ROUTING/hub_routing.yaml` | Pour HUB-Router + HUB-Concierge |

---

## Tableau récapitulatif — Nombre de fichiers par agent

| Équipe | Base | Max (agents complexes) | Taille totale estimée |
|--------|------|----------------------|----------------------|
| CTL | 4 fichiers | 6 fichiers | ~40 Ko |
| OPS | 4 fichiers | 5 fichiers | ~30 Ko |
| META | 5 fichiers | 7 fichiers | ~25 Ko |
| IAHQ | 2 fichiers | 4 fichiers | ~5 Ko |
| HUB (MO/MO2) | 6 fichiers | 6 fichiers | ~50 Ko |
| HUB (autres) | 3 fichiers | 3 fichiers | ~15 Ko |

---

## Ce qu'il NE FAUT PAS uploader

| Fichier | Raison |
|---------|--------|
| `prompt.md` | Va dans **Instructions**, pas Knowledge |
| `agents_manifest.yaml` complet | Trop lourd (17Ko) pour agents simples — réservé à MO/CTL |
| `gpt_catalog.yaml` | Redondant avec agents_index — inutile dans Knowledge |
| `intents.yaml` complet | Trop lourd (13Ko) — uniquement pour OPS-RouterIA |
| `BUNDLE__IT_UPLOAD_FULL.md` | 42Ko — uniquement pour agents IT, pas les autres équipes |

---

## Ordre d'upload recommandé

Pour chaque agent dans le GPT Editor :

```
1. Instructions  ← coller le contenu de prompt.md
2. Knowledge     ← uploader dans cet ordre :
   a. contract.yaml           (toujours en premier)
   b. BUNDLE__<EQUIPE>.md     (toujours en second)
   c. fichiers spécifiques    (selon le tableau ci-dessus)
```

---

## Note sur les mises à jour

Quand `hub_routing.yaml`, `agents_manifest.yaml` ou `intents.yaml` changent
(ajout d'un agent, nouveau playbook) :

→ **Ré-uploader uniquement les fichiers modifiés** dans le Knowledge de chaque
agent concerné. Pas besoin de tout refaire.

Agents à mettre à jour en priorité si routing change :
`OPS-RouterIA`, `HUB-Router`, `HUB-Concierge`, `HUB-AgentMO-MasterOrchestrator`

---

*Guide FACTORY root_IA — `90_KNOWLEDGE/GUIDE__KNOWLEDGE_GPT_EDITOR.md`*
