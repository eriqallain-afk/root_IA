# TEMPLATE: agent.yaml

## Structure standard

```yaml
id: <TEAM-NomAgent>
display_name: "@<TEAM-NomAgent>"
team_id: TEAM__<TEAM>
version: 1.0.0
status: active
description: "<1 phrase claire décrivant ce que fait l'agent>"
intents:
  - <intent_1>
  - <intent_2>
  - <intent_3>
```

---

## Règles de remplissage

### id
- **Format:** `TEAM-NomAgent` (kebab-case)
- **Pattern:** `^[A-Z]+-.+$`
- **Exemples:** `IT-CloudMaster`, `CONSTRUCTION-InspectionBatiment`, `META-AgentFactory`

### display_name
- **Format:** `@<id>`
- **Exemples:** `@IT-CloudMaster`, `@META-AgentFactory`

### team_id
- **Format:** `TEAM__<UPPERCASE>`
- **Teams:** TEAM__IT, TEAM__CONSTRUCTION, TEAM__EDU, TEAM__META, TEAM__OPS, TEAM__STRAT

### version
- **Format:** X.Y.Z (semantic versioning)
- **Exemples:** `1.0.0` (initial), `1.1.0` (feature), `2.0.0` (breaking)

### status
- **Valeurs:** `active` (recommandé), `draft`, `deprecated`, `archived`

### description
- **Longueur:** 50-120 caractères
- **Format:** "Fait X pour Y" ou "Spécialiste X qui fait Y"
- **Bon:** "Expert cloud multi-plateforme (Azure, M365, Google, AWS)"
- **Mauvais:** "Agent IT" (trop vague)

### intents
- **Nombre:** 3-5 intents minimum
- **Format:** `verbe_nom` (snake_case)
- **Exemples:** `generate_report`, `troubleshoot_server`, `validate_compliance`
- **Source:** Consulter `intents.yaml` pour choisir intents appropriés

---

## Exemples complets

### IT Agent
```yaml
id: IT-BackupSpecialist
display_name: "@IT-BackupSpecialist"
team_id: TEAM__IT
version: 1.0.0
status: active
description: "Spécialiste backup VEEAM et Datto - diagnostic et résolution problèmes"
intents:
  - troubleshoot_backup_failure
  - analyze_veeam_logs
  - generate_backup_report
  - recommend_retention_policy
```

### Construction Agent
```yaml
id: CONSTRUCTION-GestionProjet
display_name: "@CONSTRUCTION-GestionProjet"
team_id: TEAM__CONSTRUCTION
version: 1.0.0
status: active
description: "Gestion projets construction - planification, suivi, coordination"
intents:
  - plan_project
  - track_progress
  - manage_budget
  - coordinate_teams
  - generate_project_report
```

### META Agent
```yaml
id: META-PromptOptimizer
display_name: "@META-PromptOptimizer"
team_id: TEAM__META
version: 1.0.0
status: active
description: "Optimise prompts d'agents existants pour maximiser qualité"
intents:
  - analyze_prompt_quality
  - identify_improvements
  - refactor_instructions
  - validate_alignment
```

---

## Checklist validation

- [ ] YAML valide (2 espaces, pas tabs)
- [ ] `id` unique (vérifier `agents_index.yaml`)
- [ ] `display_name` est `@<id>`
- [ ] `team_id` valide
- [ ] `version` semver valide
- [ ] `description` claire (50-120 chars)
- [ ] 3-5 intents pertinents
- [ ] Tous intents snake_case

---

## Anti-patterns

❌ **À éviter:**
- `id: CloudMaster` (manque team)
- `description: "Agent IT"` (trop vague)
- `intents: [do_stuff, handle_things]` (génériques)
- Plus de 10 intents

---

*Template version 1.0 - META-AgentFactory*
