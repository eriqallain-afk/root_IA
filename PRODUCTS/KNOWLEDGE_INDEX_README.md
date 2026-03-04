# KNOWLEDGE INDEX - root_IA v3

**Généré:** 2024-02-14  
**Version:** 1.0

## Vue d'ensemble

Cet index référence **398 fichiers** de knowledge pour **123 agents** répartis sur **8 produits**.

## Structure

```
PRODUCTS/
├── [PRODUCT]/
│   └── agents/
│       └── [AGENT_ID]/
│           └── 02_TEMPLATES/
│               ├── RUNBOOK__*.md
│               ├── CHECKLIST__*.md
│               ├── TEMPLATE__*.md
│               ├── GUIDE__*.md
│               └── REFERENCE__*.md
```

## Produits couverts


### DAM
- **Agents:** 22
- **Fichiers knowledge:** 66
- **Moyenne:** 3.0 fichiers/agent

### EDU
- **Agents:** 10
- **Fichiers knowledge:** 30
- **Moyenne:** 3.0 fichiers/agent

### ESPL
- **Agents:** 4
- **Fichiers knowledge:** 12
- **Moyenne:** 3.0 fichiers/agent

### IASM
- **Agents:** 23
- **Fichiers knowledge:** 69
- **Moyenne:** 3.0 fichiers/agent

### IT
- **Agents:** 31
- **Fichiers knowledge:** 122
- **Moyenne:** 3.9 fichiers/agent

### NEA
- **Agents:** 10
- **Fichiers knowledge:** 30
- **Moyenne:** 3.0 fichiers/agent

### PLR
- **Agents:** 6
- **Fichiers knowledge:** 18
- **Moyenne:** 3.0 fichiers/agent

### TRAD
- **Agents:** 17
- **Fichiers knowledge:** 51
- **Moyenne:** 3.0 fichiers/agent


## Types de fichiers

### RUNBOOK__*
Procédures opérationnelles étape par étape pour accomplir des tâches spécifiques.

### CHECKLIST__*
Listes de vérification pour valider la complétude et la qualité.

### TEMPLATE__*
Modèles de documents et formats de sortie standardisés.

### GUIDE__*
Guides et bonnes pratiques pour approches et méthodologies.

### REFERENCE__*
Références rapides : commandes, standards, indicateurs.

### LIBRARY__*
Bibliothèques de code réutilisable (PowerShell, Bash, etc.)

## Utilisation

### Pour les agents

Les agents accèdent automatiquement à leur knowledge via:

```yaml
knowledge_files:
  - 02_TEMPLATES/RUNBOOK__Process.md
  - 02_TEMPLATES/TEMPLATE__Output.md
```

### Pour les développeurs

Consulter `KNOWLEDGE_INDEX.yaml` pour:
- Lister knowledge disponible par agent
- Trouver chemin d'accès aux fichiers
- Valider coverage knowledge

### Structure de l'index

```yaml
products:
  [PRODUCT]:
    agents:
      - agent_id: [ID]
        knowledge_path: PRODUCTS/.../02_TEMPLATES
        knowledge_files:
          - RUNBOOK__*.md
          - TEMPLATE__*.md
```

## Maintenance

### Ajouter knowledge à un agent

1. Créer fichier dans `agents/[AGENT_ID]/02_TEMPLATES/`
2. Nommer selon convention (RUNBOOK__, TEMPLATE__, etc.)
3. Regénérer index: `python generate_knowledge_index.py`

### Conventions de nommage

**Format:** `[TYPE]__[Description].md`

**Types valides:**
- RUNBOOK
- CHECKLIST
- TEMPLATE
- GUIDE
- REFERENCE
- LIBRARY

**Exemples:**
- `RUNBOOK__M365_User_Onboarding.md`
- `TEMPLATE__Incident_Report.md`
- `CHECKLIST__Pre_Deployment.md`

## Statistiques

| Produit | Agents | Fichiers | Moy/Agent |
|---------|--------|----------|-----------|
| DAM | 22 | 66 | 3.0 |
| EDU | 10 | 30 | 3.0 |
| ESPL | 4 | 12 | 3.0 |
| IASM | 23 | 69 | 3.0 |
| IT | 31 | 122 | 3.9 |
| NEA | 10 | 30 | 3.0 |
| PLR | 6 | 18 | 3.0 |
| TRAD | 17 | 51 | 3.0 |

| **TOTAL** | **123** | **398** | **3.2** |

---

**Dernière mise à jour:** 2024-02-14  
**Généré par:** root_IA Knowledge Generator v1.0
