# Liste des fichiers à uploader — Knowledge GPT Custom

**Date** : 2026-02-01  
**Équipe** : META (8 agents actifs)

---

## 🎯 MÉTHODE RAPIDE (Recommandée)

**Pour chaque GPT** → Upload 1 seul fichier ZIP

| GPT Custom | Fichier ZIP à uploader |
|-----------|----------------------|
| META-AnalysteBesoinsEquipes | `BUNDLE__META-AnalysteBesoinsEquipes.zip` (13 KB) |
| META-CartographeRoles | `BUNDLE__META-CartographeRoles.zip` (13 KB) |
| META-GouvernanceQA 🆕 | `BUNDLE__META-GouvernanceQA.zip` (14 KB) |
| META-OrchestrateurCentral | `BUNDLE__META-OrchestrateurCentral.zip` (13 KB) |
| META-PlaybookBuilder | `BUNDLE__META-PlaybookBuilder.zip` (13 KB) |
| META-PromptMaster 🆕 | `BUNDLE__META-PromptMaster.zip` (15 KB) |
| META-ReversePrompt | `BUNDLE__META-ReversePrompt.zip` (13 KB) |
| META-WorkflowDesignerEquipes | `BUNDLE__META-WorkflowDesignerEquipes.zip` (13 KB) |

**Total** : 8 GPTs × 1 ZIP = **8 uploads**

---

## 📋 MÉTHODE DÉTAILLÉE (Si tu veux voir les fichiers)

Si tu préfères uploader fichier par fichier, voici le détail pour **CHAQUE GPT** :

### Fichiers communs (identiques pour tous les 8 GPTs)

#### 00_CORE/ (5 fichiers - 50 KB)
1. ✅ `CONTEXT__CORE.md` — Contexte général root_IA
2. ✅ `POLICIES__INDEX.md` — Policies globales
3. ✅ `teams_index.yaml` — Liste des 13 équipes
4. ✅ `playbooks.yaml` — Tous les playbooks (43+)
5. ✅ `hub_routing.yaml` — Routage global

#### 10_TEAM/ (3 fichiers - 20 KB)
6. ✅ `TEAM__META.yaml` — Définition équipe META
7. ✅ `agents_META_list.yaml` — Liste agents META (8 actifs)
8. ✅ `playbooks_META.yaml` — Playbook BUILD_ARMY_FACTORY

### Fichiers spécifiques (différents pour chaque GPT)

#### 20_AGENT/ (3 fichiers - 10 KB)
9. ✅ `agent.yaml` — Métadonnées de l'agent
10. ✅ `contract.yaml` — Contrat I/O de l'agent
11. ✅ `README.md` — Documentation de l'agent

**Total par GPT** : **11 fichiers (~80 KB)**

---

## 🔥 CE QU'IL NE FAUT PAS UPLOADER

### ❌ prompt.md (à mettre dans System Prompt)

Le fichier `prompt.md` contient les **instructions d'exécution** de l'agent.

**Il ne va PAS dans Knowledge** → Il va dans le **System Prompt** du GPT

**Exemple** :
```
GPT: META-PromptMaster
→ Section "Instructions" (pas "Knowledge")
→ Copier/coller le contenu de prompt.md
```

---

## 📊 Récapitulatif par GPT

### 1. META-AnalysteBesoinsEquipes

**Knowledge (11 fichiers)** :
- 00_CORE/ (5 fichiers communs)
- 10_TEAM/ (3 fichiers META)
- 20_AGENT/
  - `agent.yaml`
  - `contract.yaml`
  - `README.md`

**System Prompt** :
- Copier `20_AGENTS/META/META-AnalysteBesoinsEquipes/prompt.md`

---

### 2. META-CartographeRoles

**Knowledge (11 fichiers)** :
- 00_CORE/ (5 fichiers communs)
- 10_TEAM/ (3 fichiers META)
- 20_AGENT/
  - `agent.yaml`
  - `contract.yaml`
  - `README.md`

**System Prompt** :
- Copier `20_AGENTS/META/META-CartographeRoles/prompt.md`

---

### 3. META-GouvernanceQA 🆕 (Fusionné)

**Knowledge (11 fichiers)** :
- 00_CORE/ (5 fichiers communs)
- 10_TEAM/ (3 fichiers META)
- 20_AGENT/
  - `agent.yaml`
  - `contract.yaml`
  - `README.md`

**System Prompt** :
- Copier `20_AGENTS/META/META-GouvernanceQA/prompt.md`

---

### 4. META-OrchestrateurCentral

**Knowledge (11 fichiers)** :
- 00_CORE/ (5 fichiers communs)
- 10_TEAM/ (3 fichiers META)
- 20_AGENT/
  - `agent.yaml`
  - `contract.yaml`
  - `README.md`

**System Prompt** :
- Copier `20_AGENTS/META/META-OrchestrateurCentral/prompt.md`

---

### 5. META-PlaybookBuilder

**Knowledge (11 fichiers)** :
- 00_CORE/ (5 fichiers communs)
- 10_TEAM/ (3 fichiers META)
- 20_AGENT/
  - `agent.yaml`
  - `contract.yaml`
  - `README.md`

**System Prompt** :
- Copier `20_AGENTS/META/META-PlaybookBuilder/prompt.md`

---

### 6. META-PromptMaster 🆕 (Fusionné)

**Knowledge (11 fichiers)** :
- 00_CORE/ (5 fichiers communs)
- 10_TEAM/ (3 fichiers META)
- 20_AGENT/
  - `agent.yaml`
  - `contract.yaml`
  - `README.md`

**System Prompt** :
- Copier `20_AGENTS/META/META-PromptMaster/prompt.md`

**Note** : Prompt très long (~350 lignes) — c'est normal

---

### 7. META-ReversePrompt

**Knowledge (11 fichiers)** :
- 00_CORE/ (5 fichiers communs)
- 10_TEAM/ (3 fichiers META)
- 20_AGENT/
  - `agent.yaml`
  - `contract.yaml`
  - `README.md`

**System Prompt** :
- Copier `20_AGENTS/META/META-ReversePrompt/prompt.md`

---

### 8. META-WorkflowDesignerEquipes

**Knowledge (11 fichiers)** :
- 00_CORE/ (5 fichiers communs)
- 10_TEAM/ (3 fichiers META)
- 20_AGENT/
  - `agent.yaml`
  - `contract.yaml`
  - `README.md`

**System Prompt** :
- Copier `20_AGENTS/META/META-WorkflowDesignerEquipes/prompt.md`

---

## ⚠️ IMPORTANT : Agents deprecated à NE PAS créer

Ces agents sont deprecated et remplacés :

- ❌ META-Opromptimizer → Remplacé par **META-PromptMaster**
- ❌ META-PromptArchitectEquipes → Remplacé par **META-PromptMaster**
- ❌ META-SuperviseurInvisible → Remplacé par **META-GouvernanceQA**
- ❌ META-GouvernanceEtRisques → Remplacé par **META-GouvernanceQA**

**Ne PAS créer de GPT custom pour ces 4 agents**

---

## ✅ Checklist complète

### Pour chaque GPT (x8)

- [ ] Créer GPT custom sur platform.openai.com
- [ ] **Knowledge** : Upload `BUNDLE__<AGENT>.zip` (13-15 KB)
- [ ] **Instructions** : Copier/coller `prompt.md` dans System Prompt
- [ ] Nommer le GPT : `<AGENT_ID>` (ex: "META-PromptMaster")
- [ ] Tester avec une requête simple
- [ ] Vérifier que le GPT accède aux fichiers knowledge

### Ordre recommandé

1. META-OrchestrateurCentral (chef d'orchestre)
2. META-PromptMaster 🆕 (nouveau, important)
3. META-GouvernanceQA 🆕 (nouveau, important)
4. Les 5 autres (ordre au choix)

---

## 🚀 Temps estimé

**Upload ZIP** : ~30 secondes par GPT  
**Copie System Prompt** : ~1 minute par GPT  
**Total pour 8 GPTs** : ~12 minutes

---

## 📦 Localisation des fichiers

Tous dans : `KNOWLEDGE_PACKAGES__META.zip`

Extraire et naviguer :
```
META/
├── META-AnalysteBesoinsEquipes/BUNDLE__*.zip
├── META-CartographeRoles/BUNDLE__*.zip
├── META-GouvernanceQA/BUNDLE__*.zip 🆕
├── META-OrchestrateurCentral/BUNDLE__*.zip
├── META-PlaybookBuilder/BUNDLE__*.zip
├── META-PromptMaster/BUNDLE__*.zip 🆕
├── META-ReversePrompt/BUNDLE__*.zip
└── META-WorkflowDesignerEquipes/BUNDLE__*.zip
```

---

**Prêt à créer tes GPTs ! 🎯**
