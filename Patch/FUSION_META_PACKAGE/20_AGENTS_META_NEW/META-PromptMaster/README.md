# META-PromptMaster

**Version** : 2.0.0  
**Status** : Active  
**Team** : META  
**Fusion de** : META-Opromptimizer + META-PromptArchitectEquipes  
**Date fusion** : 2026-02-01

---

## Mission

Expert prompt engineering complet couvrant tout le cycle de vie du prompt :
- Design initial (intent → contrat → prompt)
- Optimisation (amélioration qualité, performance)
- Standardisation (format machine, constraints, DoD)
- Tests & validation
- Gestion library de patterns

---

## Responsabilités

1. **Design de prompts** : Créer prompts clairs, précis, testables
2. **Optimisation** : Améliorer prompts existants
3. **Standardisation** : Appliquer standards machine (YAML_STRICT, etc.)
4. **Tests** : Créer suites de tests, valider prompts
5. **Patterns** : Maintenir library de patterns réutilisables

---

## Intents gérés

- `prompt`
- `engineering`
- `optimize`
- `prompt_design`
- `prompt_optimization`
- `standardization`
- `architecture`
- `prompt_architecture`

---

## Fichiers

- `agent.yaml` : Métadonnées agent
- `contract.yaml` : Contrat I/O complet
- `prompt.md` : Prompt interne (mode machine)
- `README.md` : Ce fichier

---

## Rationale de la fusion

### Agents fusionnés
- **META-Opromptimizer** : Design, optimisation, tests de prompts
- **META-PromptArchitectEquipes** : Standardisation, format machine, constraints

### Pourquoi fusionner ?
Les deux agents avaient des responsabilités qui se chevauchaient. La séparation créait :
- Redondance dans les tâches de prompt engineering
- Confusion sur "qui fait quoi" (design vs standardisation)
- Overhead de coordination entre les deux

### Bénéfices de la fusion
- **Expert unique** couvrant tout le cycle de vie du prompt
- **Élimination redondances** : Un seul agent à maintenir
- **Clarté responsabilités** : Toutes les tâches prompt = META-PromptMaster
- **Meilleure cohérence** : Design et standardisation intégrés dès le départ

---

## Usage

### Créer un nouveau prompt
```yaml
input:
  objective: "Créer prompt pour IT-InfraCore"
  mode:
    type: "create_new"
  agent_definition:
    agent_id: "IT-InfraCore"
    mission: "Infrastructure centrale"
    # ...
```

### Optimiser un prompt existant
```yaml
input:
  objective: "Optimiser prompt META-Opromptimizer"
  mode:
    type: "optimize_existing"
    existing_prompt: "[contenu actuel]"
  quality_requirements:
    clarity: "high"
```

### Standardiser format machine
```yaml
input:
  objective: "Standardiser prompt pour output YAML strict"
  mode:
    type: "standardize"
  io_contract:
    output_format: "YAML_STRICT"
```

---

## Qualité

### Métriques qualité
- **Clarity** : 0-10 (clarté instructions)
- **Precision** : 0-10 (précision spécifications)
- **Testability** : 0-10 (facilité à tester)
- **Overall** : Score global

### Seuils acceptables
- Clarity ≥ 7
- Precision ≥ 7
- Testability ≥ 7
- Overall ≥ 7

---

## Évolution

**Version 1.0** (avant fusion) :
- META-Opromptimizer : Design & optimisation
- META-PromptArchitectEquipes : Standardisation

**Version 2.0** (post-fusion) :
- META-PromptMaster : Expert unique prompt engineering

**Prochaines versions** :
- Intégration AI-assisted prompt testing
- Library de patterns étendue
- Templates par type d'agent (orchestrator, specialist, QA, etc.)

---

## Contact

Pour questions ou suggestions :
- Équipe META
- Voir `INDEX__META.md` pour contexte équipe
