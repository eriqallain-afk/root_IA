# Guide de fusion META — 10 → 8 agents

**Date** : 2026-02-01  
**Auteur** : Claude Sonnet 4.5  
**Portée** : Fusion 2 paires d'agents META

---

## Résumé exécutif

### Fusions effectuées

**FUSION 1 : META-PromptMaster**
- **De** : META-Opromptimizer + META-PromptArchitectEquipes
- **Rationale** : Expert unique prompt engineering (design + standardisation)
- **Localisation** : `20_AGENTS/META/META-PromptMaster/`

**FUSION 2 : META-GouvernanceQA**
- **De** : META-SuperviseurInvisible + META-GouvernanceEtRisques
- **Rationale** : Pilier unique gouvernance (audit + risques)
- **Localisation** : `20_AGENTS/META/META-GouvernanceQA/`

### Agents META (avant → après)

**AVANT (10 agents)** :
1. META-AnalysteBesoinsEquipes ✅
2. META-CartographeRoles ✅
3. META-GouvernanceEtRisques → ❌ DEPRECATED
4. META-Opromptimizer → ❌ DEPRECATED
5. META-OrchestrateurCentral ✅
6. META-PlaybookBuilder ✅
7. META-PromptArchitectEquipes → ❌ DEPRECATED
8. META-ReversePrompt ✅
9. META-SuperviseurInvisible → ❌ DEPRECATED
10. META-WorkflowDesignerEquipes ✅

**APRÈS (8 agents)** :
1. META-AnalysteBesoinsEquipes ✅
2. META-CartographeRoles ✅
3. META-GouvernanceQA 🆕 (fusion 2)
4. META-OrchestrateurCentral ✅
5. META-PlaybookBuilder ✅
6. META-PromptMaster 🆕 (fusion 1)
7. META-ReversePrompt ✅
8. META-WorkflowDesignerEquipes ✅

---

## Fichiers modifiés

### 1. Nouveaux agents créés

```
20_AGENTS/META/META-PromptMaster/
├── agent.yaml
├── contract.yaml
├── prompt.md
└── README.md

20_AGENTS/META/META-GouvernanceQA/
├── agent.yaml
├── contract.yaml
├── prompt.md
└── README.md
```

### 2. Agents dépréciés (marqués)

```
20_AGENTS/META/META-Opromptimizer/agent.yaml
  + status: deprecated
  + replaced_by: META-PromptMaster

20_AGENTS/META/META-PromptArchitectEquipes/agent.yaml
  + status: deprecated
  + replaced_by: META-PromptMaster

20_AGENTS/META/META-SuperviseurInvisible/agent.yaml
  + status: deprecated
  + replaced_by: META-GouvernanceQA

20_AGENTS/META/META-GouvernanceEtRisques/agent.yaml
  + status: deprecated
  + replaced_by: META-GouvernanceQA
```

### 3. Fichiers index patchés

**00_INDEX/agents_index.yaml**
- 4 agents marqués deprecated
- 2 nouveaux agents ajoutés (PromptMaster, GouvernanceQA)

**40_RUNBOOKS/playbooks.yaml**
- Playbook `BUILD_ARMY_FACTORY` :
  - Step `prompts` : `META-Opromptimizer` → `META-PromptMaster`
  - Step `audit` : `META-SuperviseurInvisible` → `META-GouvernanceQA`

---

## Checklist de validation

### Avant déploiement

- [ ] Lire `SYNTHESE_VISUELLE.md` (vue d'ensemble)
- [ ] Valider les 2 nouveaux agents (prompts cohérents)
- [ ] Vérifier agents_index.yaml (10 → 12 entrées, 4 deprecated)
- [ ] Vérifier playbooks.yaml (BUILD_ARMY_FACTORY corrigé)
- [ ] Tester le playbook BUILD_ARMY_FACTORY avec nouveaux agents

### Tests de non-régression

```bash
# 1. Valider schemas
cd /path/to/root_IA
python scripts/validate_schemas.py

# 2. Valider agent.yaml
python scripts/validate_no_fake_citations.py

# 3. Valider dépôt complet
bash validate_root_IA.sh

# 4. Tester BUILD_ARMY_FACTORY (si possible)
# Vérifier que META-PromptMaster et META-GouvernanceQA fonctionnent
```

### Post-déploiement (Semaine 1)

- [ ] Monitoring : aucune erreur de routing vers anciens agents
- [ ] Vérifier que BUILD_ARMY_FACTORY utilise bien les nouveaux agents
- [ ] Feedback utilisateurs : META-PromptMaster produit prompts qualité

---

## Plan d'archivage (après 1 mois)

**Si stable (pas de rollback requis)** :

```bash
# Archiver les 4 agents deprecated
mkdir -p ARCHIVE/20_AGENTS_DEPRECATED_2026-02/META
mv 20_AGENTS/META/META-Opromptimizer ARCHIVE/20_AGENTS_DEPRECATED_2026-02/META/
mv 20_AGENTS/META/META-PromptArchitectEquipes ARCHIVE/20_AGENTS_DEPRECATED_2026-02/META/
mv 20_AGENTS/META/META-SuperviseurInvisible ARCHIVE/20_AGENTS_DEPRECATED_2026-02/META/
mv 20_AGENTS/META/META-GouvernanceEtRisques ARCHIVE/20_AGENTS_DEPRECATED_2026-02/META/

# Commit
git add .
git commit -m "ARCHIVE: Agents META deprecated archivés (fusion PromptMaster + GouvernanceQA)"
```

---

## Rollback (si nécessaire)

**Si problèmes critiques** :

1. Restaurer anciens agents_index.yaml et playbooks.yaml depuis backup
2. Marquer META-PromptMaster et META-GouvernanceQA comme `status: inactive`
3. Retirer `status: deprecated` des 4 anciens agents
4. Redémarrer services

---

## Contenu du package

Ce dossier `FUSION_META_PACKAGE/` contient :

```
FUSION_META_PACKAGE/
├── GUIDE_FUSION_META.md (ce fichier)
├── 20_AGENTS_META_NEW/
│   ├── META-PromptMaster/ (agent complet)
│   └── META-GouvernanceQA/ (agent complet)
├── PATCHES/
│   ├── agents_index.yaml (patché)
│   └── playbooks.yaml (patché)
└── DEPRECATION.md (notice dépréciation)
```

---

## Timeline recommandée

| Date | Action |
|------|--------|
| 2026-02-01 | Package créé, prêt à merger |
| 2026-02-02 | Revue équipe, validation |
| 2026-02-03 | Merge dans main |
| 2026-02-04 | Tests de non-régression |
| 2026-02-05-08 | Monitoring 4 jours |
| 2026-03-01 | Archivage agents deprecated (si stable) |

---

## Support

**Questions** : Équipe META  
**Documentation** : `agents_META_OPTIMIZED.yaml` (dans corrections_architecture/)  
**Référence** : Rapport complet dans `RAPPORT_ANALYSE_CORRECTIONS.md`

---

**FIN DU GUIDE**
