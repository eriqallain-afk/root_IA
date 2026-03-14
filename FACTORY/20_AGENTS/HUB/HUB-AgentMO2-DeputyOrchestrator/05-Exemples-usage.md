# 05 — Exemples d'Usage — HUB-AgentMO2-DeputyOrchestrator

5 scénarios complets : entrée → sortie attendue.

---

## Scénario 1 — Plan validé (cas nominal)

**Entrée** :
```yaml
intent: qa_plan
routing_plan:
  plan_id: PLAN-FAB-001
  steps:
    - step_id: S01
      actor_id: META-AnalysteBesoinsEquipes
      intent: analyse_besoins
      expected_output: spec_besoins.yaml
      success_criteria: "spec_besoins.yaml présent avec domaine identifié"
      on_failure: abort
    - step_id: S02
      actor_id: OPS-DossierIA
      intent: archive
      expected_output: dossier_id
      success_criteria: "dossier_id retourné"
      on_failure: continue
quality_indicators:
  priority: P2
  sla_minutes: 20
```

**Sortie attendue** :
```yaml
result:
  summary: "Plan PLAN-FAB-001 validé. 2 steps, tous agents actifs, DoD complète."
  status: validated
  confidence: 0.97
  plan_id: PLAN-FAB-001
  validation_report:
    routing_check:
      intent_valid: true
      all_actors_indexed: true
      ghost_agents: []
    data_security_check:
      pii_detected: false
      pii_fields: []
    dod_check:
      all_steps_have_success_criteria: true
      all_steps_have_on_failure: true
      missing_dod: []
  agent_briefs:
    - agent_id: META-AnalysteBesoinsEquipes
      brief: "Analyser les besoins du domaine cible. Produire spec_besoins.yaml."
      inputs_expected: [domain, client_context]
      outputs_expected: [spec_besoins.yaml]
      success_criteria: "spec_besoins.yaml présent avec domaine identifié"
      on_failure: abort
    - agent_id: OPS-DossierIA
      brief: "Archiver le dossier de fabrication. Retourner dossier_id."
      inputs_expected: [spec_besoins.yaml]
      outputs_expected: [dossier_id]
      success_criteria: "dossier_id retourné"
      on_failure: continue
  corrections_required: []
log:
  decisions:
    - id: D01
      decision: "Plan validé sans correction"
      rationale: "Tous agents actifs, DoD complète, aucune PII détectée"
  risks:
    - id: R01
      risk: "on_failure: abort sur S01 — blocage total si META-AnalysteBesoinsEquipes échoue"
      mitigation: "SLA court (20 min) — surveiller via CTL-WatchdogIA"
  assumptions: []
  quality_score: 9.7
```

---

## Scénario 2 — Agent fantôme détecté

**Entrée** :
```yaml
intent: qa_plan
routing_plan:
  plan_id: PLAN-TEST-002
  steps:
    - step_id: S01
      actor_id: META-AgentInexistant
      intent: do_something
```

**Sortie attendue** :
```yaml
result:
  summary: "Plan PLAN-TEST-002 rejeté. Agent fantôme détecté : META-AgentInexistant."
  status: rejected
  confidence: 1.0
  plan_id: PLAN-TEST-002
  validation_report:
    routing_check:
      intent_valid: false
      all_actors_indexed: false
      ghost_agents: [META-AgentInexistant]
  corrections_required:
    - issue_id: C01
      severity: blocker
      description: "META-AgentInexistant introuvable dans agents_index.yaml"
      resolution: "Remplacer par un agent actif ou créer META-AgentInexistant via PB_FAB_03"
log:
  decisions:
    - id: D01
      decision: "Rejet du plan"
      rationale: "Agent fantôme critique — DISPATCH impossible"
  risks:
    - id: R01
      risk: "Plan non exécutable en l'état"
      mitigation: "Corriger actor_id avant re-soumission à MO"
  quality_score: 0.0
```

---

## Scénario 3 — Corrections requises (DoD incomplète)

**Entrée** :
```yaml
intent: qa_plan
routing_plan:
  plan_id: PLAN-INCOMPLETE-003
  steps:
    - step_id: S01
      actor_id: CTL-WatchdogIA
      intent: factory_health_check
      # Pas de success_criteria, pas de on_failure
```

**Sortie attendue** :
```yaml
result:
  summary: "Plan PLAN-INCOMPLETE-003 — needs_review. DoD manquante sur S01."
  status: needs_review
  confidence: 0.6
  validation_report:
    dod_check:
      all_steps_have_success_criteria: false
      all_steps_have_on_failure: false
      missing_dod: [S01]
  corrections_required:
    - issue_id: C01
      severity: blocker
      description: "S01 sans success_criteria"
      resolution: "Ajouter: success_criteria: 'watchdog_report présent et factory_status défini'"
    - issue_id: C02
      severity: blocker
      description: "S01 sans on_failure"
      resolution: "Ajouter: on_failure: abort"
log:
  quality_score: 5.5
```

---

## Scénario 4 — PII détectée

**Entrée** :
```yaml
intent: qa_plan
routing_plan:
  plan_id: PLAN-CLIENT-004
  steps:
    - step_id: S01
      actor_id: IAHQ-Economist
      intent: business_case
      inputs:
        client_email: "jean.dupont@client.com"
        revenue: 1250000
```

**Sortie attendue** :
```yaml
result:
  summary: "Plan PLAN-CLIENT-004 bloqué. PII non masquée détectée (client_email)."
  status: needs_review
  confidence: 0.95
  validation_report:
    data_security_check:
      pii_detected: true
      pii_fields: [client_email]
      confidential_data: true
      notes: ["client_email doit être masqué avant DISPATCH"]
  corrections_required:
    - issue_id: C01
      severity: blocker
      description: "client_email en clair dans les inputs"
      resolution: "Remplacer par: client_email: '[MASKED]' ou supprimer du plan"
log:
  quality_score: 3.0
```

---

## Scénario 5 — Backup MO

**Entrée** :
```yaml
intent: backup_orchestrate
reason: MO_overloaded
objective: "Lancer un Factory Health Check"
context:
  available_agents: [CTL-WatchdogIA, CTL-HealthReporter, OPS-DossierIA]
  sla_minutes: 15
```

**Sortie attendue** :
```yaml
result:
  summary: "[MODE BACKUP] MO2 prend le relais. Plan health check généré."
  status: validated
  confidence: 0.88
  mode: BACKUP_ORCHESTRATION
  alert_sent_to: CTL-AlertRouter
  generated_plan:
    plan_id: BACKUP-PLAN-001
    steps:
      - step_id: S01
        actor_id: CTL-WatchdogIA
        intent: factory_health_check
        on_failure: abort
      - step_id: S02
        actor_id: CTL-HealthReporter
        intent: generate_report
        on_failure: continue
      - step_id: S03
        actor_id: OPS-DossierIA
        intent: archive
        on_failure: continue
log:
  decisions:
    - id: D01
      decision: "[MODE BACKUP] Plan conservateur généré"
      rationale: "MO indisponible — politique: tout doute → on_failure: escalate"
  assumptions:
    - id: A01
      assumption: "MO redeviendra disponible dans < 30 min"
      confidence: 0.7
  quality_score: 8.8
```
