# TEMPLATE — Machine Flow (HUB Standard)

> **Usage** : Remplir ce template pour définir un flow Machine complet, prêt à être soumis à `OPS-PlaybookRunner` via `HUB-Orchestrator`.  
> **Convention de nommage** : `MACHINE_FLOW__<INTENT>__<DATE>.yaml`

---

## 1. En-tête de la Machine

```yaml
machine_flow:
  id: "<INTENT_CODE>__<YYYYMMDD>"
  display_name: "<Nom lisible du flow>"
  version: "1.0.0"
  objective: "<1 phrase : ce que ce flow accomplit>"
  trigger_intent: "<intent_id depuis 00_INDEX/intents.yaml>"
  team_owner: "<TEAM_ID>"
  estimated_duration_minutes: <int>
  sla: "<ex: 30 min>"
  environment: dev|stage|prod
```

---

## 2. Contexte & Inputs requis

```yaml
  inputs:
    - field: objective
      type: string
      required: true
      description: "<description>"
    - field: context
      type: object
      required: false
      description: "<description>"
    - field: constraints
      type: list[string]
      required: false
      description: "<contraintes>"
    # Ajouter les champs spécifiques au flow
```

---

## 3. Équipes & Rôles mobilisés

```yaml
  teams_involved:
    - team_id: <TEAM_ID>
      role: "<rôle dans ce flow>"
      agents: [<agent_id_1>, <agent_id_2>]
    # Répéter par équipe
```

---

## 4. Séquence d'exécution

```yaml
  steps:
    - step: "<step_name>"
      order: 1
      actor_id: "<agent_id>"
      role_description: "<ce que fait cet acteur ici>"
      input_from: user|step_<N>
      input_fields: [<field1>, <field2>]
      prompt_template: |
        ## Contexte
        {context}

        ## Consignes
        {consignes_specifiques}

        ## Format de sortie attendu
        {format}
      output_artifacts: [<livrable1>]
      success_criteria:
        - "<critère testable>"
      on_failure: retry_once|skip|abort|escalate
      escalation_target: "<agent_id>"

    - step: "<step_name_2>"
      order: 2
      actor_id: "<agent_id>"
      # ... (même structure)
```

---

## 5. Livrable final

```yaml
  deliverables:
    - type: yaml|md|report|checklist
      title: "<nom du livrable>"
      path: "<chemin relatif FACTORY>"
      description: "<ce que contient ce livrable>"
      produced_by_step: "<step_name>"
```

---

## 6. Critères de succès (Definition of Done)

```yaml
  definition_of_done:
    - "<critère 1 — vérifiable>"
    - "<critère 2>"
    - "Score qualité ≥ 9/10"
    - "Log d'exécution archivé (OPS-DossierIA)"
    - "Tous les steps = status:success"
```

---

## 7. Politique d'escalade

```yaml
  escalation_policy:
    on_quality_below: 9
    on_step_failure: abort_after_retry
    escalation_target: HUB-AgentMO-MasterOrchestrator
    notification: "<canal ou agent à notifier>"
```

---

## 8. Références

```yaml
  references:
    playbook_file: "30_PLAYBOOKS/<PB_ID>.yaml"
    runbook_file: "40_RUNBOOKS/RUNBOOK__<PB_ID>.md"
    agents_consulted:
      - "<agent_id_1>"
      - "<agent_id_2>"
    policies_applied:
      - "50_POLICIES/quality_rules.md"
      - "50_POLICIES/naming.md"
```

---

## 9. Log du flow (à remplir à l'exécution)

```yaml
  execution_log:
    run_id: "<uuid>"
    started_at: "<ISO 8601>"
    completed_at: "<ISO 8601>"
    status: pending|running|paused|complete|failed
    steps_completed: <int>
    steps_total: <int>
    quality_score: 0-10
    decisions: []
    risks_encountered: []
    assumptions_made: []
```
