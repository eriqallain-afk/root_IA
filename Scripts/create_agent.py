#!/usr/bin/env python3
"""
CREATE AGENT - Script de création automatique d'agents Root IA v2
Usage: python create_agent.py --team DAM --name ClientOnboarding --intents "onboarding,client"
"""

import yaml
import os
import sys
from datetime import datetime
from pathlib import Path

# Templates
AGENT_YAML_TEMPLATE = """schema_version: "2.0"
id: {agent_id}
display_name: "@{agent_id}"
team_id: TEAM__{team}
team_name: {team}
version: 1.0.0
status: active
created_at: "{timestamp}"
description: "{description}"

intents:
{intents_list}

aliases:
  - "@{agent_id}"

machine:
  output_format: YAML_STRICT
  contract_required: true
  logs_required: true

interfaces:
  contract: contract.yaml
  prompt: prompt.md
  readme: README.md
  tests: tests/test_cases.yaml
"""

CONTRACT_YAML_TEMPLATE = """schema_version: "2.0"
agent_id: {agent_id}

# ===========================================================================
# INPUT CONTRACT
# ===========================================================================

input:
  type: object
  required:
    - task
    - context
  
  properties:
    task:
      type: string
      description: "Description de la tâche à accomplir"
      minLength: 10
      maxLength: 5000
    
    context:
      type: object
      description: "Contexte nécessaire pour accomplir la tâche"
      properties:
        # Ajouter propriétés spécifiques ici
        user_id:
          type: string
        project_id:
          type: string
    
    options:
      type: object
      description: "Options facultatives"
      properties:
        priority:
          type: string
          enum: [low, normal, high, critical]
          default: normal
        
        deadline:
          type: string
          format: date-time

# ===========================================================================
# OUTPUT CONTRACT
# ===========================================================================

output:
  type: object
  required:
    - result
    - log
  
  properties:
    result:
      type: object
      required:
        - summary
        - details
      properties:
        summary:
          type: string
          description: "Résumé 1-3 lignes"
          minLength: 20
          maxLength: 500
        
        details:
          type: string
          description: "Détails complets structurés"
    
    artifacts:
      type: array
      description: "Artefacts générés"
      items:
        type: object
        required: [type, title]
        properties:
          type:
            type: string
            enum: [doc, yaml, md, pdf, report, checklist, code]
          title:
            type: string
          path:
            type: string
          content:
            type: string
    
    next_actions:
      type: array
      description: "Actions recommandées"
      items:
        type: string
    
    log:
      type: object
      required:
        - decisions
        - risks
        - assumptions
      properties:
        decisions:
          type: array
          items:
            type: string
        risks:
          type: array
          items:
            type: string
        assumptions:
          type: array
          items:
            type: string

# ===========================================================================
# VALIDATION RULES
# ===========================================================================

validation:
  response_time_max_seconds: 30
  retry_on_error: true
  retry_max_attempts: 3
"""

PROMPT_TEMPLATE = """# @{agent_id} — MODE MACHINE

## Rôle

{role_description}

## Règles Machine

- **ID canon:** `{agent_id}`
- **Output:** YAML strict uniquement (aucun texte hors YAML)
- **Séparation:** Distinguer faits / hypothèses
- **Transparence:** Si info manquante → inconnus + hypothèses + next_actions
- **Traçabilité:** Toujours remplir log.decisions / log.risks / log.assumptions

## Entrées/Sorties

Voir `contract.yaml` pour schema complet

### Input Attendu

```yaml
task: "<description tâche>"
context:
  # Contexte spécifique
options:
  priority: "normal"
```

### Output Format

```yaml
result:
  summary: "<résumé 1-3 lignes>"
  details: |-
    <détails structurés (sections, listes), actionnables>

artifacts:
  - type: "doc|yaml|md|pdf|report|checklist"
    title: "<nom humain>"
    path: "<chemin relatif si applicable>"
    content: "<optionnel : extrait court>"

next_actions:
  - "<action suivante 1>"
  - "<action suivante 2>"

log:
  decisions:
    - "<décision clé 1>"
  risks:
    - "<risque / incertitude 1>"
  assumptions:
    - "<hypothèse 1>"
```

## Capacités Spécifiques

{capabilities}

## Exemples

### Exemple 1: {example_1_title}

**Input:**
```yaml
task: "{example_1_task}"
context:
  # contexte exemple
```

**Output:**
```yaml
result:
  summary: "Exemple de résumé"
  details: |
    Détails exemple
```

## Gestion d'Erreurs

- Si input invalide → retourner erreur dans log.risks
- Si timeout probable → traitement partiel + next_actions
- Si ambiguïté → lister questions dans next_actions

## Notes Importantes

{important_notes}

---

**Version:** 1.0.0  
**Dernière mise à jour:** {timestamp}
"""

README_TEMPLATE = """# {agent_id}

**Team:** {team}  
**Version:** 1.0.0  
**Status:** Active  

## Description

{description}

## Usage

### Quick Start

```python
from root_ia import invoke_agent

result = invoke_agent(
    agent_id="{agent_id}",
    task="Votre tâche ici",
    context={{
        "user_id": "user_123",
        # autres contextes
    }}
)

print(result['summary'])
```

### Input Format

```yaml
task: "<description>"
context:
  user_id: "..."
  project_id: "..."
options:
  priority: "normal"
```

### Output Format

```yaml
result:
  summary: "..."
  details: "..."
artifacts: [...]
next_actions: [...]
log:
  decisions: [...]
  risks: [...]
  assumptions: [...]
```

## Exemples

### Exemple 1: Usage Basique

```yaml
task: "Exemple de tâche"
context:
  user_id: "user_123"
```

**Résultat:**
- Summary: ...
- Artifacts: ...

## Tests

```bash
# Exécuter les tests
python ../../../60_TESTS/test_agent.py {agent_id}

# Validation contract
python ../../../80_SCRIPTS/validate_agent.py {agent_id}
```

## Troubleshooting

### Problème: Timeout
**Solution:** Réduire scope de la tâche ou augmenter timeout

### Problème: Contract validation failed
**Solution:** Vérifier format input vs contract.yaml

## Changelog

### v1.0.0 - {date}
- Création initiale de l'agent

## Maintenance

**Propriétaire:** [Team {team}]  
**Contact:** [contact]  
**Dernière revue:** {date}
"""

TEST_CASES_TEMPLATE = """schema_version: "2.0"
agent_id: {agent_id}

test_cases:
  
  - name: "Happy path - cas nominal"
    description: "Test du cas d'usage principal"
    input:
      task: "Tâche de test basique"
      context:
        user_id: "test_user_001"
        project_id: "test_proj_001"
      options:
        priority: "normal"
    
    expected_output:
      result:
        summary_contains: ["test", "succès"]
        details_not_empty: true
      
      artifacts_count_min: 0
      
      next_actions_count_min: 1
      
      log:
        decisions_not_empty: true
        risks_not_empty: true
        assumptions_not_empty: true
    
    validation:
      response_time_max: 30
      should_succeed: true
  
  - name: "Edge case - info manquante"
    description: "Test avec contexte incomplet"
    input:
      task: "Tâche vague sans détails"
      context:
        user_id: "test_user_002"
      # project_id manquant volontairement
    
    expected_output:
      result:
        summary_contains: ["manquant", "incomplet", "clarification"]
      
      next_actions_count_min: 1
      next_actions_contains: ["clarifier", "préciser", "information"]
      
      log:
        assumptions_not_empty: true
    
    validation:
      should_succeed: true
  
  - name: "Error case - input invalide"
    description: "Test avec input malformé"
    input:
      # task manquant volontairement
      context: {{}}
    
    expected_output:
      error: true
      error_message_contains: ["required", "task"]
    
    validation:
      should_fail: true

# ===========================================================================
# BENCHMARKS
# ===========================================================================

benchmarks:
  response_time_target_seconds: 15
  success_rate_target_percent: 95
  error_rate_max_percent: 5
"""


def create_agent(team: str, name: str, intents: list, description: str = ""):
    """
    Crée un nouvel agent avec tous les fichiers requis
    """
    agent_id = f"{team}-{name}"
    timestamp = datetime.now().strftime("%Y-%m-%dT%H:%M:%SZ")
    date = datetime.now().strftime("%Y-%m-%d")
    
    # Créer le répertoire de l'agent
    agent_dir = Path(f"20_AGENTS/{team}/{agent_id}")
    agent_dir.mkdir(parents=True, exist_ok=True)
    
    # Créer tests directory
    tests_dir = agent_dir / "tests"
    tests_dir.mkdir(exist_ok=True)
    
    # Intents formatés pour YAML
    intents_list = "\n".join([f"  - {intent}" for intent in intents])
    
    # Description par défaut
    if not description:
        description = f"Agent {name} de l'équipe {team}"
    
    # 1. agent.yaml
    agent_yaml = AGENT_YAML_TEMPLATE.format(
        agent_id=agent_id,
        team=team,
        timestamp=timestamp,
        description=description,
        intents_list=intents_list
    )
    (agent_dir / "agent.yaml").write_text(agent_yaml)
    
    # 2. contract.yaml
    contract_yaml = CONTRACT_YAML_TEMPLATE.format(
        agent_id=agent_id
    )
    (agent_dir / "contract.yaml").write_text(contract_yaml)
    
    # 3. prompt.md
    prompt_md = PROMPT_TEMPLATE.format(
        agent_id=agent_id,
        role_description=description,
        capabilities="- Capacité 1\n- Capacité 2\n- Capacité 3",
        example_1_title="Cas nominal",
        example_1_task="Exemple de tâche",
        important_notes="- Note importante 1\n- Note importante 2",
        timestamp=timestamp
    )
    (agent_dir / "prompt.md").write_text(prompt_md)
    
    # 4. README.md
    readme_md = README_TEMPLATE.format(
        agent_id=agent_id,
        team=team,
        description=description,
        date=date
    )
    (agent_dir / "README.md").write_text(readme_md)
    
    # 5. tests/test_cases.yaml
    tests_yaml = TEST_CASES_TEMPLATE.format(
        agent_id=agent_id
    )
    (tests_dir / "test_cases.yaml").write_text(tests_yaml)
    
    print(f"✅ Agent créé: {agent_id}")
    print(f"📁 Répertoire: {agent_dir}")
    print(f"📄 Fichiers générés:")
    print(f"   - agent.yaml")
    print(f"   - contract.yaml")
    print(f"   - prompt.md")
    print(f"   - README.md")
    print(f"   - tests/test_cases.yaml")
    
    return agent_id


if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description="Créer un nouvel agent Root IA")
    parser.add_argument("--team", required=True, help="Équipe (ex: DAM, HUB, META)")
    parser.add_argument("--name", required=True, help="Nom de l'agent (ex: ClientOnboarding)")
    parser.add_argument("--intents", required=True, help="Intents séparés par virgule (ex: onboarding,client)")
    parser.add_argument("--description", default="", help="Description de l'agent")
    
    args = parser.parse_args()
    
    intents_list = [i.strip() for i in args.intents.split(",")]
    
    create_agent(
        team=args.team,
        name=args.name,
        intents=intents_list,
        description=args.description
    )
