# Manifeste des packages Knowledge par GPT

**Généré le** : 2026-02-01  
**Objectif** : Packages à uploader dans le knowledge de chaque GPT custom

---

## Structure des packages

Chaque agent GPT reçoit un package contenant :

1. **CORE (commun à tous)** :
   - `CONTEXT__CORE.md` (contexte root_IA)
   - `POLICIES__INDEX.md` (policies globales)
   - `teams_index.yaml` (liste des équipes)
   - `playbooks.yaml` (tous les playbooks)
   - `hub_routing.yaml` (routage global)

2. **TEAM (commun à l'équipe)** :
   - `TEAM__<TEAM>.yaml` (définition équipe)
   - Liste des agents de l'équipe
   - Playbooks spécifiques à l'équipe

3. **AGENT (spécifique)** :
   - `agent.yaml` (propre définition)
   - `contract.yaml` (propre contrat)
   - `prompt.md` (instructions internes — OPTIONNEL si déjà dans system prompt)

---

## Packages à créer

### TEAM__META (12 agents post-fusion)

#### Agents actifs (8)
1. **META-AnalysteBesoinsEquipes**
2. **META-CartographeRoles**
3. **META-GouvernanceQA** 🆕
4. **META-OrchestrateurCentral**
5. **META-PlaybookBuilder**
6. **META-PromptMaster** 🆕
7. **META-ReversePrompt**
8. **META-WorkflowDesignerEquipes**

#### Agents deprecated (4) — NE PAS créer de packages
- META-Opromptimizer ❌
- META-PromptArchitectEquipes ❌
- META-SuperviseurInvisible ❌
- META-GouvernanceEtRisques ❌

---

## Organisation des packages

```
KNOWLEDGE_PACKAGES/
├── _CORE/                          # Fichiers communs à TOUS
│   ├── CONTEXT__CORE.md
│   ├── POLICIES__INDEX.md
│   ├── teams_index.yaml
│   ├── playbooks.yaml
│   └── hub_routing.yaml
│
├── META/                           # Package équipe META
│   ├── _TEAM_CORE/                 # Commun à tous META
│   │   ├── TEAM__META.yaml
│   │   ├── agents_META_list.yaml
│   │   └── playbooks_META.yaml
│   │
│   ├── META-AnalysteBesoinsEquipes/
│   │   ├── BUNDLE.zip              # Package complet pour cet agent
│   │   └── UPLOAD_LIST.txt         # Liste fichiers à uploader
│   │
│   ├── META-CartographeRoles/
│   ├── META-GouvernanceQA/
│   ├── META-OrchestrateurCentral/
│   ├── META-PlaybookBuilder/
│   ├── META-PromptMaster/
│   ├── META-ReversePrompt/
│   └── META-WorkflowDesignerEquipes/
│
├── HUB/                            # Package équipe HUB
├── IAHQ/                           # Package équipe IAHQ
├── IT/                             # Package équipe IT
├── ... (autres équipes)
└── README.md                       # Ce fichier
```

---

## Contenu type d'un BUNDLE agent

### Exemple : META-PromptMaster/BUNDLE.zip

```
BUNDLE__META-PromptMaster/
├── 00_CORE/                        # Contexte global (5 fichiers)
│   ├── CONTEXT__CORE.md
│   ├── POLICIES__INDEX.md
│   ├── teams_index.yaml
│   ├── playbooks.yaml
│   └── hub_routing.yaml
│
├── 10_TEAM/                        # Contexte équipe META (3 fichiers)
│   ├── TEAM__META.yaml
│   ├── agents_META_list.yaml
│   └── playbooks_META.yaml
│
├── 20_AGENT/                       # Fichiers propres (3 fichiers)
│   ├── agent.yaml
│   ├── contract.yaml
│   └── README.md
│
└── UPLOAD_INSTRUCTIONS.txt         # Instructions d'upload
```

**Total par agent** : ~11 fichiers (peut varier selon équipe)

---

## Priorisation

### Phase 1 : META (urgent post-fusion)
- ✅ 8 agents actifs uniquement
- 🆕 Inclure META-PromptMaster et META-GouvernanceQA

### Phase 2 : HUB, IAHQ, OPS (core)
- Agents orchestrateurs centraux

### Phase 3 : IT (post-restructuration)
- Attendre validation restructuration IT
- 12 agents nouveaux (pas les 28 anciens)

### Phase 4 : Autres équipes
- TRAD, DAM, NEA, EDU, IASM, etc.

---

## Template UPLOAD_INSTRUCTIONS.txt

```
=============================================================
INSTRUCTIONS D'UPLOAD — Knowledge GPT Custom
=============================================================

Agent: <AGENT_ID>
Équipe: <TEAM>
Date: 2026-02-01

=============================================================
FICHIERS À UPLOADER (dans cet ordre)
=============================================================

1. CONTEXTE GLOBAL (5 fichiers) :
   [ ] 00_CORE/CONTEXT__CORE.md
   [ ] 00_CORE/POLICIES__INDEX.md
   [ ] 00_CORE/teams_index.yaml
   [ ] 00_CORE/playbooks.yaml
   [ ] 00_CORE/hub_routing.yaml

2. CONTEXTE ÉQUIPE (3 fichiers) :
   [ ] 10_TEAM/TEAM__<TEAM>.yaml
   [ ] 10_TEAM/agents_<TEAM>_list.yaml
   [ ] 10_TEAM/playbooks_<TEAM>.yaml

3. AGENT SPÉCIFIQUE (2-3 fichiers) :
   [ ] 20_AGENT/agent.yaml
   [ ] 20_AGENT/contract.yaml
   [ ] 20_AGENT/README.md (optionnel)

=============================================================
TOTAL : ~10-11 fichiers
=============================================================

NOTES :
- Le prompt.md n'est PAS uploadé (déjà dans le system prompt)
- L'ordre d'upload n'est pas critique mais recommandé
- Tous les fichiers sont en texte (MD/YAML)

=============================================================
```

---

## Génération automatique

Pour générer tous les packages :

```bash
# Générer packages META
python scripts/generate_knowledge_packages.py --team META

# Générer tous les packages
python scripts/generate_knowledge_packages.py --all
```

---

## Estimation taille

**Par agent** :
- CORE : ~50 KB (5 fichiers)
- TEAM : ~20 KB (3 fichiers)
- AGENT : ~10 KB (3 fichiers)
- **Total** : ~80 KB par agent

**Total META (8 agents)** : ~640 KB

---

## Prochaines étapes

1. Générer packages META (8 agents)
2. Tester avec META-PromptMaster
3. Valider avec équipe
4. Générer autres équipes

---

**FIN DU MANIFESTE**
