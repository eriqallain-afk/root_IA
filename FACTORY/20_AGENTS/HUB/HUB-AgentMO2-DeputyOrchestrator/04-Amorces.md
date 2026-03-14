# 04 — Amorces de Conversation — HUB-AgentMO2-DeputyOrchestrator

10 amorces prêtes à l'emploi pour activer MO2 selon le contexte.

---

## 1. QA standard d'un plan MO

```
intent: qa_plan
routing_plan:
  plan_id: PLAN-2026-001
  steps:
    - step_id: S01
      actor_id: META-PromptMaster
      intent: optimize_prompt
      expected_output: optimized_prompt.yaml
quality_indicators:
  priority: P2
  sla_minutes: 15
```

---

## 2. Validation rapide P0

```
intent: validate_plan
priority: P0
constraints:
  time_limit_seconds: 5
routing_plan:
  plan_id: PLAN-URGENT-001
  steps:
    - step_id: S01
      actor_id: CTL-WatchdogIA
      intent: factory_health_check
```

---

## 3. Revue post-exécution

```
intent: review_mo
plan_id: PLAN-2026-001
partials:
  S01:
    status: completed
    output: "spec_besoins.yaml produit"
    duration_seconds: 45
quality_indicators:
  sla_respected: true
  error_count: 0
```

---

## 4. Détection d'agents fantômes

```
intent: qa_plan
routing_plan:
  plan_id: PLAN-TEST-GHOST
  steps:
    - step_id: S01
      actor_id: META-AgentInconnu
      intent: undefined_task
```
> MO2 doit retourner `status: rejected` avec liste `ghost_agents`.

---

## 5. Backup MO — surcharge

```
intent: backup_orchestrate
reason: MO_overloaded
objective: "Produire un audit Army pour TEAM__IT"
context:
  available_agents: [META-GouvernanceQA, CTL-WatchdogIA]
  deadline: "2026-03-14T18:00:00Z"
```

---

## 6. Scan sécurité approfondi

```
intent: qa_plan
constraints:
  security_scan: deep
routing_plan:
  plan_id: PLAN-CLIENT-ABC
  steps:
    - step_id: S01
      actor_id: IAHQ-Economist
      intent: business_case
      inputs:
        client_name: "Hypothèse à valider: Acme Corp"
        revenue: "[MASKED]"
```

---

## 7. Validation d'un plan multi-équipes

```
intent: qa_plan
routing_plan:
  plan_id: PLAN-CROSS-TEAM-001
  steps:
    - step_id: S01
      actor_id: META-AnalysteBesoinsEquipes
      intent: analyse_besoins
    - step_id: S02
      actor_id: CTL-WatchdogIA
      intent: factory_health_check
    - step_id: S03
      actor_id: OPS-DossierIA
      intent: archive
```

---

## 8. Corrections demandées à MO

```
intent: qa_plan
routing_plan:
  plan_id: PLAN-2026-002
  steps:
    - step_id: S01
      actor_id: META-CartographeRoles
      intent: cartographier_roles
      # Pas de success_criteria défini → correction requise
```
> MO2 doit retourner `status: needs_review` avec `corrections_required`.

---

## 9. DoD check uniquement

```
intent: validate_plan
objective: "Vérifier uniquement la DoD de chaque step"
routing_plan:
  plan_id: PLAN-DOD-CHECK
  steps:
    - step_id: S01
      actor_id: META-PlaybookBuilder
      intent: build_playbook
      success_criteria: "Playbook YAML valide produit"
      on_failure: continue
```

---

## 10. Rapport qualité complet

```
intent: review_mo
plan_id: PLAN-WEEKLY-AUDIT
partials:
  S01: { status: completed, quality_score: 9.5 }
  S02: { status: partial, quality_score: 6.0, issues: ["output format incorrect"] }
  S03: { status: failed, reason: "actor_id introuvable" }
quality_indicators:
  overall_score: 7.2
  sla_minutes_used: 18
  sla_limit: 15
```
