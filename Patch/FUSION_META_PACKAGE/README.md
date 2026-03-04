# Package de fusion META — 10 → 8 agents

**Date** : 2026-02-01  
**Version** : 1.0  
**Statut** : Prêt à appliquer

---

## Contenu du package

```
FUSION_META_PACKAGE/
├── README.md (ce fichier)
├── GUIDE_FUSION_META.md (guide détaillé)
├── DEPRECATION.md (notice dépréciation)
├── APPLY.sh (script d'application automatique)
├── 20_AGENTS_META_NEW/
│   ├── META-PromptMaster/ (4 fichiers)
│   └── META-GouvernanceQA/ (4 fichiers)
└── PATCHES/
    ├── agents_index.yaml
    └── playbooks.yaml
```

---

## Installation rapide

### Windows

#### 1. Décompresser
Utilisez 7-Zip, WinRAR ou PowerShell :
```powershell
# PowerShell
tar -xzf FUSION_META_PACKAGE.tar.gz
cd root_IA  # Votre dépôt
```

#### 2. Appliquer (3 options)

**Option A : Double-clic** (le plus simple)
- Double-cliquer sur `FUSION_META_PACKAGE\APPLY.bat`

**Option B : PowerShell**
```powershell
powershell -ExecutionPolicy Bypass -File FUSION_META_PACKAGE\APPLY.ps1
```

**Option C : CMD**
```cmd
FUSION_META_PACKAGE\APPLY.bat
```

#### 3. Valider
```powershell
python scripts\validate_schemas.py
# validate_root_IA.sh nécessite Git Bash ou WSL
```

#### 4. Commit
```powershell
git add .
git commit -m "FUSION: META 10→8 agents (PromptMaster + GouvernanceQA)"
git push
```

---

### Linux/Mac

#### 1. Décompresser
```bash
tar -xzf FUSION_META_PACKAGE.tar.gz
cd root_IA  # Votre dépôt
```

#### 2. Appliquer
```bash
bash FUSION_META_PACKAGE/APPLY.sh
```

#### 3. Valider
```bash
python scripts/validate_schemas.py
bash validate_root_IA.sh
```

#### 4. Commit
```bash
git add .
git commit -m "FUSION: META 10→8 agents (PromptMaster + GouvernanceQA)"
git push
```

---

## Installation manuelle

Si vous préférez appliquer manuellement :

### Étape 1 : Nouveaux agents
```bash
cp -r FUSION_META_PACKAGE/20_AGENTS_META_NEW/META-PromptMaster 20_AGENTS/META/
cp -r FUSION_META_PACKAGE/20_AGENTS_META_NEW/META-GouvernanceQA 20_AGENTS/META/
```

### Étape 2 : Marquer deprecated
Ajouter dans chaque agent.yaml :
```yaml
# META-Opromptimizer et META-PromptArchitectEquipes
status: deprecated
deprecated_date: '2026-02-01'
replaced_by: META-PromptMaster

# META-SuperviseurInvisible et META-GouvernanceEtRisques
status: deprecated
deprecated_date: '2026-02-01'
replaced_by: META-GouvernanceQA
```

### Étape 3 : Appliquer patches
```bash
cp FUSION_META_PACKAGE/PATCHES/agents_index.yaml 00_INDEX/
cp FUSION_META_PACKAGE/PATCHES/playbooks.yaml 40_RUNBOOKS/
```

---

## Résumé des changements

### Agents créés
- ✅ **META-PromptMaster** : Fusion Opromptimizer + PromptArchitectEquipes
- ✅ **META-GouvernanceQA** : Fusion SuperviseurInvisible + GouvernanceEtRisques

### Agents dépréciés
- ❌ META-Opromptimizer
- ❌ META-PromptArchitectEquipes
- ❌ META-SuperviseurInvisible
- ❌ META-GouvernanceEtRisques

### Fichiers modifiés
- `00_INDEX/agents_index.yaml` : +2 agents, 4 marked deprecated
- `40_RUNBOOKS/playbooks.yaml` : BUILD_ARMY_FACTORY steps updated

---

## Validation

### Tests de non-régression
```bash
# Valider schemas
python scripts/validate_schemas.py

# Valider dépôt
bash validate_root_IA.sh

# Tester playbook BUILD_ARMY_FACTORY (manuel)
```

### Critères de succès
- [ ] Aucune erreur de validation schemas
- [ ] agents_index.yaml cohérent (12 entrées META)
- [ ] playbooks.yaml cohérent (BUILD_ARMY_FACTORY fonctionne)
- [ ] Nouveaux agents créés dans 20_AGENTS/META/

---

## Rollback

**Si problèmes critiques détectés** :

Le script APPLY.sh crée automatiquement un backup :
```bash
# Restaurer depuis backup
cp -r BACKUP_FUSION_META_YYYYMMDD_HHMMSS/META 20_AGENTS/
cp BACKUP_FUSION_META_YYYYMMDD_HHMMSS/agents_index.yaml 00_INDEX/
cp BACKUP_FUSION_META_YYYYMMDD_HHMMSS/playbooks.yaml 40_RUNBOOKS/
```

---

## Support

**Documentation complète** : `GUIDE_FUSION_META.md`  
**Notice dépréciation** : `DEPRECATION.md`  
**Questions** : Équipe META

---

## Timeline recommandée

| Date | Action |
|------|--------|
| J+0 (2026-02-01) | Application package |
| J+1 | Tests non-régression |
| J+2 à J+7 | Monitoring 1 semaine |
| J+30 | Archivage agents deprecated (si stable) |

---

**Prêt à déployer !**
