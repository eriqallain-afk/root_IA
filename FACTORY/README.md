# FACTORY — Documentation interne
> `root_IA/FACTORY/` | Version : 3.0 | 2026-02-26
> Pour la vue globale root_IA → voir `../README.md`

---

## Rôle de FACTORY dans root_IA

```
root_IA/
├── FACTORY/    ← ici — back-office, infrastructure de fabrication
├── PRODUCTS/   ← front-office, armées déployées par domaine
└── SHARED/     ← ressources communes aux deux
```

FACTORY **fabrique** les agents. PRODUCTS **déploie** les armées produites.
Un agent naît dans `FACTORY/20_AGENTS/`, il est déployé dans `PRODUCTS/<DOMAINE>/`.

---

## Structure interne

```
FACTORY/
├── 00_CONTROL/          ← Agents CTL — surveillance continue
├── 00_INDEX/            ← 13 fichiers index (source de vérité)
├── 10_TEAMS/            ← Définitions des 4 équipes core
├── 20_AGENTS/           ← 39 agents organisés par équipe
│   ├── HUB/             ← 10 agents — Orchestration centrale
│   ├── IAHQ/            ← 10 agents — Stratégie entreprise
│   ├── META/            ← 16 agents — Fabrication d'agents
│   └── OPS/             ←  3 agents — Opérations & routage
├── 30_PLAYBOOKS/        ← Pipelines d'exécution multi-agents
├── 40_ROUTING/          ← Table de routage intents → acteurs
├── 50_POLICIES/         ← Standards, naming, qualité, gouvernance
├── 80_MACHINES/         ← Wiring machine (routage technique)
├── 90_KNOWLEDGE/        ← Templates, bundles, contexte, ROI
└── 99_VALIDATION/       ← Scripts de validation (PS + Python)
```

---

## Fichiers obligatoires par agent

```
FACTORY/20_AGENTS/<TEAM>/<ID>/
├── agent.yaml       ← identité, intents, version, escalade
├── contract.yaml    ← interface I/O (input / output / guardrails)
└── prompt.md        ← instructions système
```

Standard de structure → `FACTORY/90_KNOWLEDGE/TEMPLATES/META-PROMPT-STYLE-GUIDE.md`

---

## Les 4 équipes core

### TEAM__HUB — Orchestration centrale (10 agents)

| Agent | Mission |
|-------|---------|
| `HUB-AgentMO-MasterOrchestrator` | Mémoire globale, coordination inter-équipes |
| `HUB-AgentMO2-DeputyOrchestrator` | Qualité, recette, cohérence |
| `HUB-Orchestrator` | Orchestration workflows complexes |
| `HUB-Router` | Routing rapide par règles |
| `HUB-Concierge` | Accueil général, qualification demandes floues |
| `HUB-AvatarForge` | Création avatars et personas IA |
| `HUB-CoachIA360-Strategie-GPTTeams` | Coaching stratégique GPT Teams |
| `HUB-ITCoachIA360` | Coaching IT et transformation |
| `HUB-IA-ChatBotMaster` | Chatbots et interfaces conversationnelles |
| `HUB-OproEngine` | Optimisation des opérations |

### TEAM__META — Fabrication d'agents (14 agents) — cœur de la FACTORY

| Agent | Mission |
|-------|---------|
| `META-OrchestrateurCentral` | Chef d'orchestre META |
| `META-PromptMaster` | Création et optimisation de prompts |
| `META-AgentProductFactory` | Génération de packages agents complets |
| `META-AnalysteBesoinsEquipes` | Analyse domaines → specs testables |
| `META-CartographeRoles` | Catalogue des rôles par domaine |
| `META-WorkflowDesignerEquipes` | Modélisation workflows et handoffs |
| `META-PlaybookBuilder` | Construction des playbooks |
| `META-GouvernanceQA` | Audit qualité et conformité |
| `META-ArchitecteChoix` | Aide à la décision architecturale |
| `META-ReversePrompt` | Rétro-ingénierie de GPTs existants |
| `META-Concierge` | Accueil spécialisé demandes META |
| `META-Pedagogie` | Contenu pédagogique et formation |
| `META-Redaction` | Rédaction documents et livrables |
| `META-VisionCreative` | Vision créative et storytelling IA |

### TEAM__IAHQ — Stratégie entreprise IA (10 agents)

| Agent | Mission |
|-------|---------|
| `IAHQ-OrchestreurEntrepriseIA` | Intake client, cadrage stratégique |
| `IAHQ-Strategist` | Business cases, offres, roadmaps |
| `IAHQ-SolutionOrchestrator` | Blueprint de solution IA |
| `IAHQ-ProcessMapper` | Cartographie processus métier |
| `IAHQ-TechLeadIA` | Validation technique et architecture |
| `IAHQ-Economist` | ROI, modèles financiers, scénarios |
| `IAHQ-QualityGate` | Gate qualité livrables IAHQ |
| `IAHQ-AdminManagerIA` | Gestion administrative |
| `IAHQ-DevFactoryIA` | Développement factory et intégrations |
| `IAHQ-Extractor` | Extraction et structuration de données |

### TEAM__OPS — Moteur d'exécution (3 agents) — critiques

| Agent | Mission |
|-------|---------|
| `OPS-RouterIA` | Intent → dispatch vers agent/playbook adéquat |
| `OPS-PlaybookRunner` | Exécution séquentielle des playbooks |
| `OPS-DossierIA` | Mémoire persistante, archivage, traçabilité |

> Ces 3 agents sont invoqués dans **chaque** pipeline. Leur prompt est critique.

---

## Flux d'exécution standard

```
Requête entrante
      │
      ▼
OPS-RouterIA          ← détecte l'intent, route vers la cible
      │
      ▼
OPS-PlaybookRunner    ← exécute le playbook step-by-step
      │
      ├──► Agent Step 1 → OPS-DossierIA (archive)
      ├──► Agent Step 2 → OPS-DossierIA (archive)
      └──► Agent Step N → OPS-DossierIA (close + export)
```

---

## Index — Source de vérité (00_INDEX/)

13 fichiers — ne jamais modifier manuellement.
Mises à jour via agents META ou scripts `99_VALIDATION/`.

| Fichier | Contenu |
|---------|---------|
| `agents_manifest.yaml` | Inventaire complet avec chemins |
| `agents_index.yaml` | Index rapide — IDs, teams, statuts |
| `gpt_catalog.yaml` | 47 GPTs catalogués (dont 3 CTL) |
| `teams_index.yaml` | Équipes et missions |
| `teams.manifest.yaml` | Manifest équipes détaillé |
| `playbooks_index.yaml` | Playbooks référencés |
| `intents.yaml` | Mapping intents → acteurs |
| `capability_map.yaml` | Capacités par équipe |
| `hub_routing.yaml` → 40_ROUTING/ | Table de routage |

---

## Playbooks disponibles (30_PLAYBOOKS/)

| ID | Catégorie | Durée | Steps |
|----|-----------|-------|-------|
| `BUILD_ARMY_FACTORY` | Fabrication | 300 min | 8 |
| `BUILD_TEAM_FROM_SCRATCH` | Fabrication | 180 min | 6 |
| `CLONE_AND_ADAPT_AGENT` | Fabrication | 45 min | 4 |
| `ONBOARD_NEW_TEAM` | Fabrication | 120 min | 5 |
| `ARMY_AUDIT_COMPLETE` | Opérationnel | 90 min | 5 |
| `AGENT_LIFECYCLE_MANAGEMENT` | Opérationnel | 30 min | 3 |
| `POST_MORTEM_ANALYSIS` | Opérationnel | 45 min | 4 |
| `PROMPT_OPTIMIZATION_CYCLE` | Opérationnel | 30 min | 3 |
| `IAHQ_FRONTDOOR` | Stratégie | 180 min | 7 |
| `FACTORY_HEALTH_CHECK` | Surveillance | 20 min | 3 |

---

## Surveillance — Agents CTL (00_CONTROL/)

| Agent | Mission |
|-------|---------|
| `CTL-WatchdogIA` | Surveillance continue, détection contract_mismatch |
| `CTL-AlertRouter` | Route les alertes vers agents ou humains |
| `CTL-HealthReporter` | Rapports de santé FACTORY |

---

## Naming — Règle absolue

```
Agent    : TEAM-NomAgent      ex: META-PromptMaster, OPS-RouterIA
Équipe   : TEAM__CODE         ex: TEAM__META, TEAM__OPS
Playbook : DOMAINE_ACTION     ex: BUILD_ARMY_FACTORY, IAHQ_FRONTDOOR
```

Référence complète → `FACTORY/50_POLICIES/naming.md`

---

## Ajouter un agent

```
1. Créer  : FACTORY/20_AGENTS/<TEAM>/<TEAM-NomAgent>/
2. Écrire : agent.yaml + contract.yaml + prompt.md
3. Mettre à jour : 00_INDEX/agents_manifest.yaml
                   00_INDEX/intents.yaml
                   40_ROUTING/hub_routing.yaml
4. Valider :
   powershell -ExecutionPolicy Bypass `
     -File .\99_VALIDATION\Run-Validation.ps1 `
     -RootPath "C:\Intranet_EA\EA_IA\root_IA\FACTORY"
```

Recommandé : utiliser `META-PromptMaster` (intent `agent_package_create`) — génère
les 3 fichiers depuis un brief, qualité garantie ≥ 9.0/10.

---

## Ajouter un playbook

```
1. Créer  : FACTORY/30_PLAYBOOKS/PB_<DOMAINE>_<NUM>_<ID>.yaml
2. Ajouter dans : FACTORY/30_PLAYBOOKS/playbooks.yaml
3. Raccorder : FACTORY/40_ROUTING/hub_routing.yaml
4. Mettre à jour : FACTORY/00_INDEX/playbooks_index.yaml
```

Template → `FACTORY/90_KNOWLEDGE/TEMPLATES/TEMPLATE__PLAYBOOK.md`

---

## Validation (99_VALIDATION/)

Compatible **Windows PowerShell 5.1** — aucun module externe requis.

```powershell
# Validation complète
powershell -ExecutionPolicy Bypass `
  -File .\99_VALIDATION\Run-Validation.ps1 `
  -RootPath "C:\Intranet_EA\EA_IA\root_IA\FACTORY"

# Références seulement (routing → agents → playbooks)
powershell -ExecutionPolicy Bypass `
  -File .\99_VALIDATION\Validate-Refs.ps1 `
  -RootPath "C:\Intranet_EA\EA_IA\root_IA\FACTORY" `
  -OutJson .\validation_report.json

# Naming seulement
powershell -ExecutionPolicy Bypass `
  -File .\99_VALIDATION\Validate-Naming.ps1 `
  -RootPath "C:\Intranet_EA\EA_IA\root_IA\FACTORY"
```

```bash
# Validation Python
python 99_VALIDATION/validate_refs_regex.py
```

---

## Escalades

| Situation | Contact |
|-----------|---------|
| Problème architectural global | `HUB-AgentMO-MasterOrchestrator` |
| Conflit routing | `HUB-AgentMO2-DeputyOrchestrator` |
| Qualité agent / audit | `META-GouvernanceQA` |
| Business case / ROI | `IAHQ-Economist` |
| Données sensibles — fuite | `META-GouvernanceQA` (priorité critique) |

---

## Historique

| Version | Date | Changements |
|---------|------|-------------|
| 3.0 | 2026-02-26 | Sprints 1-3, CTL, 13 index validés, playbooks complets, prompts OPS/META/IAHQ |
| 2.0 | 2026-02-10 | Refactoring structure, consolidation |
| 1.0 | 2026-01-05 | Version initiale |

---

*Ce README couvre FACTORY/ uniquement.*
*Vue globale root_IA → `../README.md` | Contexte opérationnel → `90_KNOWLEDGE/CONTEXT__CORE.md`*