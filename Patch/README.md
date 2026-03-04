# Knowledge Packages — root_IA

**Généré le** : 2026-02-01  
**Version** : 1.0

---

## Vue d'ensemble

Ce package contient les **bundles knowledge** pour chaque GPT custom de l'équipe **META** (8 agents actifs).

Chaque bundle contient ~11 fichiers à uploader dans le knowledge du GPT custom correspondant.

---

## Contenu

### KNOWLEDGE_PACKAGES__META.zip

```
META/
├── _CORE/                          # Fichiers communs (partagés par tous)
│   ├── CONTEXT__CORE.md
│   ├── POLICIES__INDEX.md
│   ├── teams_index.yaml
│   ├── playbooks.yaml
│   └── hub_routing.yaml
│
├── _TEAM_CORE/                     # Fichiers équipe META
│   ├── TEAM__META.yaml
│   ├── agents_META_list.yaml
│   └── playbooks_META.yaml
│
├── META-AnalysteBesoinsEquipes/
│   ├── BUNDLE__META-AnalysteBesoinsEquipes/
│   │   ├── 00_CORE/ (5 fichiers)
│   │   ├── 10_TEAM/ (3 fichiers)
│   │   ├── 20_AGENT/ (3 fichiers)
│   │   └── UPLOAD_INSTRUCTIONS.txt
│   └── BUNDLE__META-AnalysteBesoinsEquipes.zip
│
├── META-CartographeRoles/
│   └── BUNDLE__META-CartographeRoles.zip
│
├── META-GouvernanceQA/ 🆕
│   └── BUNDLE__META-GouvernanceQA.zip
│
├── META-OrchestrateurCentral/
│   └── BUNDLE__META-OrchestrateurCentral.zip
│
├── META-PlaybookBuilder/
│   └── BUNDLE__META-PlaybookBuilder.zip
│
├── META-PromptMaster/ 🆕
│   └── BUNDLE__META-PromptMaster.zip
│
├── META-ReversePrompt/
│   └── BUNDLE__META-ReversePrompt.zip
│
└── META-WorkflowDesignerEquipes/
    └── BUNDLE__META-WorkflowDesignerEquipes.zip
```

---

## Utilisation

### Option 1 : Upload ZIP complet (recommandé)

1. Extraire `KNOWLEDGE_PACKAGES__META.zip`
2. Pour chaque agent, aller dans son dossier
3. Upload `BUNDLE__<AGENT>.zip` dans le knowledge du GPT custom

**Exemple** :
```
META/META-PromptMaster/BUNDLE__META-PromptMaster.zip
→ Uploader dans le GPT "META-PromptMaster"
```

### Option 2 : Upload fichier par fichier

1. Extraire le bundle d'un agent
2. Suivre `UPLOAD_INSTRUCTIONS.txt`
3. Uploader les 11 fichiers un par un

---

## Structure d'un bundle

Chaque bundle contient **3 sections** :

### 00_CORE (5 fichiers) — Contexte global
- `CONTEXT__CORE.md` : Contexte général root_IA
- `POLICIES__INDEX.md` : Policies (naming, format, etc.)
- `teams_index.yaml` : Liste des 13 équipes
- `playbooks.yaml` : Tous les playbooks (43+)
- `hub_routing.yaml` : Routage global

### 10_TEAM (3 fichiers) — Contexte équipe META
- `TEAM__META.yaml` : Définition équipe
- `agents_META_list.yaml` : Liste agents META (8 actifs)
- `playbooks_META.yaml` : Playbook BUILD_ARMY_FACTORY

### 20_AGENT (3 fichiers) — Spécifique agent
- `agent.yaml` : Métadonnées agent
- `contract.yaml` : Contrat I/O
- `README.md` : Documentation agent

**Total** : 11 fichiers par agent

---

## Agents inclus

### ✅ Actifs (8 agents)

1. **META-AnalysteBesoinsEquipes**
2. **META-CartographeRoles**
3. **META-GouvernanceQA** 🆕 (fusion SuperviseurInvisible + GouvernanceEtRisques)
4. **META-OrchestrateurCentral**
5. **META-PlaybookBuilder**
6. **META-PromptMaster** 🆕 (fusion Opromptimizer + PromptArchitectEquipes)
7. **META-ReversePrompt**
8. **META-WorkflowDesignerEquipes**

### ❌ Exclus (deprecated)

- META-Opromptimizer (remplacé par PromptMaster)
- META-PromptArchitectEquipes (remplacé par PromptMaster)
- META-SuperviseurInvisible (remplacé par GouvernanceQA)
- META-GouvernanceEtRisques (remplacé par GouvernanceQA)

---

## Taille des fichiers

**Par agent** :
- CORE : ~50 KB
- TEAM : ~20 KB
- AGENT : ~10 KB
- **Total** : ~80 KB

**Total META (8 agents)** : ~640 KB

**ZIP global** : ~150 KB (compression)

---

## Upload dans GPT Custom

### Étape 1 : Accéder au GPT

```
platform.openai.com
→ My GPTs
→ Sélectionner le GPT (ex: META-PromptMaster)
```

### Étape 2 : Upload knowledge

```
→ Section "Knowledge"
→ "Upload files" ou drag & drop
→ Sélectionner BUNDLE__<AGENT>.zip
→ Save
```

### Étape 3 : Vérification

Le GPT devrait maintenant avoir accès à :
- Contexte global root_IA
- Définition de son équipe
- Son propre contrat et métadonnées

---

## Notes importantes

### ⚠️ Le prompt.md n'est PAS inclus

Le `prompt.md` de chaque agent contient les **instructions internes** et doit être copié dans le **system prompt** du GPT custom, pas dans le knowledge.

**Fichiers knowledge** = Données de référence (contexte, contrats, routing)  
**System prompt** = Instructions d'exécution (`prompt.md`)

### ✅ Fichiers à jour post-fusion

Les bundles **META-PromptMaster** et **META-GouvernanceQA** contiennent les versions fusionnées (2026-02-01).

Les anciens agents (Opromptimizer, etc.) ne sont PAS inclus.

---

## Génération d'autres équipes

Pour générer les packages d'autres équipes :

```bash
# HUB
python scripts/generate_knowledge_packages.py --team HUB

# IAHQ
python scripts/generate_knowledge_packages.py --team IAHQ

# Toutes les équipes
python scripts/generate_knowledge_packages.py --all
```

*(Script non inclus — à créer si besoin)*

---

## Checklist par agent

Pour chaque GPT custom :

- [ ] Extraire le bundle ZIP
- [ ] Lire `UPLOAD_INSTRUCTIONS.txt`
- [ ] Uploader les 11 fichiers (ou ZIP complet)
- [ ] Vérifier que le GPT accède aux fichiers
- [ ] Copier `prompt.md` dans le system prompt (séparément)
- [ ] Tester le GPT avec une requête simple

---

## Support

**Questions** : Équipe META  
**Documentation** : `MANIFESTE.md` (dans ce package)  
**Référence** : Rapport complet dans `RAPPORT_ANALYSE_CORRECTIONS.md`

---

**Prêt à uploader !** 🚀
