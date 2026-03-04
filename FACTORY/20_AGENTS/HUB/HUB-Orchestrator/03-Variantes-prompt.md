# Variantes de prompt — HUB-Orchestrator

## Variante 1 : MODE STANDARD (Séquentiel strict)

**Cas d'usage** : Workflows linéaires avec dépendances fortes entre steps

```yaml
Mode: STANDARD
Caractéristiques:
  - Exécution séquentielle stricte
  - Step N+1 attend completion step N
  - Output step N devient input step N+1
  - Arrêt immédiat si échec après retry

Prompt ajusté:
"Pour ce workflow, exécute chaque step l'un après l'autre. 
Le step suivant ne démarre QUE si le précédent est status=success.
Passe l'output de chaque step comme input du suivant.
Si un step échoue après retry, arrête et escalade."

Exemple playbook:
  create_agent_complete:
    - step1: AnalyseBesoins
    - step2: DesignRole (dépend step1)
    - step3: CreatePrompt (dépend step2)
    - step4: BuildAgent (dépend step3)
    - step5: QA (dépend step4)
```

---

## Variante 2 : MODE PARALLEL (Exécution simultanée)

**Cas d'usage** : Steps indépendants exécutables en parallèle pour gain temps

```yaml
Mode: PARALLEL
Caractéristiques:
  - Steps sans dépendances en simultané
  - Synchronisation après completion groupe
  - Gain temps = max(durations) vs sum(durations)
  - Compilation finale après toutes branches

Prompt ajusté:
"Pour ce workflow, identifie les steps SANS dépendances entre eux.
Exécute-les EN PARALLÈLE (simultanément).
Attends que TOUS soient complete avant de compiler.
Log la durée de chaque branche + gain temps total."

Exemple playbook:
  multi_team_research:
    - step1: Cadrage (séquentiel)
    - parallel_group_research:
        - step2: AnalyseTechnique (META)
        - step3: AnalyseBusiness (IAHQ)
        - step4: AnalyseRegulatory (IAHQ)
    - step5: Compilation (attend steps 2-4)

Gain temps = (4200 + 3800 + 5100) - max(4200, 3800, 5100)
           = 13100 - 5100 = 8000ms économisés
```

---

## Variante 3 : MODE CONDITIONAL (Branches if/then/else)

**Cas d'usage** : Workflows avec décisions conditionnelles (quality gates, validations)

```yaml
Mode: CONDITIONAL
Caractéristiques:
  - Branches if/then/else selon conditions
  - Skip steps non pertinents
  - Re-routing dynamique
  - Conditions basées sur outputs précédents

Prompt ajusté:
"Pour ce workflow, évalue les CONDITIONS après chaque step.
Si condition X vraie → branche THEN
Si condition X fausse → branche ELSE
Log quelle branche prise et pourquoi.
Skip les steps de la branche non prise."

Exemple playbook:
  conditional_deployment:
    - step1: QA initial
    - condition: quality >= 8.0
      then:
        - step2: Deploy direct
      else:
        - step2: Optimize prompt
        - step3: Re-QA
        - step4: Deploy if quality ok
        
Résultat:
  IF quality=7.5 → branche ELSE (optimize)
  IF quality=8.3 → branche THEN (deploy direct)
```

---

## Variante 4 : MODE DEBUG (Logs verbeux + validation stricte)

**Cas d'usage** : Debugging workflows complexes, développement nouveaux playbooks

```yaml
Mode: DEBUG
Caractéristiques:
  - Logs verbeux chaque micro-étape
  - Validation stricte contrats (reject si 1 champ manque)
  - Pause points configurables
  - Dumps complets input/output

Prompt ajusté:
"Active MODE DEBUG pour ce workflow.
Pour CHAQUE step, logge:
  - Input complet (tous champs)
  - Validation contrat pré-call (check required fields)
  - Call agent (timestamp exact)
  - Output complet (tous champs)
  - Validation contrat post-call (format, types, ranges)
  - Décisions micro (pourquoi choix X vs Y)
  
Si UN SEUL champ manquant → REJECT + liste missing_fields
Pause avant step si pause_point configuré."

Exemple output debug:
  step2_debug:
    input_validation:
      required_fields: [objective, constraints]
      missing_fields: []
      status: valid
    call:
      agent: META-PromptMaster
      timestamp_start: 2026-02-10T14:32:15.234Z
      timestamp_end: 2026-02-10T14:32:18.434Z
      duration_ms: 3200
    output_validation:
      required_fields: [prompt, quality_score]
      received_fields: [prompt, quality_score, patterns_used]
      status: valid
      format_check: YAML_STRICT ✓
      type_check: quality_score=number ✓
```

---

## Variante 5 : MODE RESILIENT (Max retry + fallback)

**Cas d'usage** : Workflows critiques nécessitant robustesse maximale

```yaml
Mode: RESILIENT
Caractéristiques:
  - Retry configurable (1-3x au lieu de 1x)
  - Fallback agents alternatifs
  - Timeout configurable par step
  - Circuit breaker si échecs répétés

Prompt ajusté:
"Pour ce workflow CRITIQUE, maximise la résilience:
  - Retry chaque step JUSQU'À 3 fois (vs 1x standard)
  - Si échec après 3 retry → essaie agent FALLBACK si défini
  - Si échec fallback → escalade avec contexte complet
  - Timeout 2x durée estimée step
  - Circuit breaker: si 3 steps consécutifs failed → arrêt workflow"

Exemple playbook resilient:
  critical_deployment:
    - step1: 
        agent: META-GouvernanceQA
        retry_max: 3
        timeout_ms: 10000
        fallback_agent: META-GouvernanceQA-Backup
    - step2:
        agent: OPS-PlaybookRunner
        retry_max: 3
        timeout_ms: 5000
        circuit_breaker: true
```

---

## Variante 6 : MODE INCREMENTAL (Checkpoints + reprise)

**Cas d'usage** : Workflows longs (>30 min) avec besoin sauvegarde état

```yaml
Mode: INCREMENTAL
Caractéristiques:
  - Checkpoints réguliers (toutes les N steps OU M minutes)
  - Sauvegarde execution_context
  - Reprise possible depuis dernier checkpoint
  - Rollback si échec critique

Prompt ajusté:
"Pour ce workflow LONG, active mode INCREMENTAL:
  - Checkpoint toutes les 3 steps OU toutes les 10 minutes
  - Sauvegarder execution_context dans checkpoint_<n>.yaml
  - Si échec: proposer reprise depuis dernier checkpoint
  - Log checkpoint IDs dans execution_log"

Exemple playbook:
  long_analysis_pipeline:
    - step1-3: Data collection
      checkpoint: cp_001
    - step4-6: Data processing
      checkpoint: cp_002
    - step7-9: Analysis
      checkpoint: cp_003
    - step10: Compilation
    
Si échec step8 → reprendre depuis cp_002 (step4)
```

---

## Variante 7 : MODE AUDIT (Traçabilité maximale)

**Cas d'usage** : Workflows réglementés (RGPD, SOC2, ISO) nécessitant audit trail

```yaml
Mode: AUDIT
Caractéristiques:
  - Traçabilité complète (qui, quoi, quand, pourquoi)
  - Immutabilité logs (hash SHA256)
  - Signatures numériques agents
  - Compliance checks automatiques

Prompt ajusté:
"Pour ce workflow RÉGLEMENTÉ, active mode AUDIT:
  - Logger TOUT: inputs, outputs, décisions, timestamps, agents
  - Chaque log entry = hash SHA256
  - Signature numérique agent après chaque step
  - Vérifier compliance contraintes (RGPD, sécurité)
  - Générer audit_trail.pdf certifié"

Exemple output audit:
  audit_trail:
    workflow_id: wf_2026-02-10_audit01
    compliance_frameworks: [RGPD, ISO27001]
    steps:
      - step: 1
        agent: META-PromptMaster
        agent_signature: "sig_abc123...xyz789"
        input_hash: "sha256_def456..."
        output_hash: "sha256_ghi789..."
        timestamp: "2026-02-10T14:30:00.000Z"
        compliance_checks:
          - RGPD_data_minimization: passed
          - RGPD_consent_required: passed
    audit_certificate: "audit_trail_wf_2026-02-10_audit01.pdf"
```

---

## Variante 8 : MODE INTERACTIVE (Validation humaine)

**Cas d'usage** : Workflows nécessitant validation/approbation humaine à certains steps

```yaml
Mode: INTERACTIVE
Caractéristiques:
  - Pause steps pour validation humaine
  - Approve/reject/modify options
  - Timeout si pas réponse (escalade)
  - Log décisions humaines

Prompt ajusté:
"Pour ce workflow INTERACTIF, pause aux validation_points:
  - Après step validé, PAUSE et demande approbation humaine
  - Options: APPROVE (continue) | REJECT (arrêt) | MODIFY (ajuster)
  - Timeout 2h → escalade si pas réponse
  - Logger décision humaine + rationale"

Exemple playbook:
  interactive_deployment:
    - step1: Create agent
    - validation_point_1:
        message: "Agent créé. Approuver avant QA?"
        timeout_minutes: 120
        options: [approve, reject, modify]
    - step2: QA (si approved)
    - validation_point_2:
        message: "QA passed. Déployer en production?"
        timeout_minutes: 30
    - step3: Deploy (si approved)
```

---

## Variante 9 : MODE DRY_RUN (Simulation sans exécution)

**Cas d'usage** : Tester workflow avant exécution réelle, estimer durée/coût

```yaml
Mode: DRY_RUN
Caractéristiques:
  - Simulation pure (pas d'appel agents réels)
  - Estimation durée/coût basée historique
  - Validation contrats uniquement
  - Identification problèmes potentiels

Prompt ajusté:
"Pour ce workflow, exécute en MODE DRY_RUN (simulation):
  - NE PAS appeler agents réels
  - Valider contrats inputs/outputs (types, required fields)
  - Estimer durée chaque step (moyenne historique)
  - Identifier problèmes potentiels (missing fields, incompatibilités)
  - Output: plan exécution + estimations + warnings"

Exemple output dry_run:
  dry_run_result:
    workflow_id: wf_2026-02-10_dryrun01
    simulation: true
    estimated_duration_ms: 12500
    estimated_cost: 0.45€
    steps_validated: 5/5
    potential_issues:
      - step3: "Warning: input 'constraints' optional mais recommandé"
    execution_plan:
      - step1: META-AnalysteBesoins (est. 2s)
      - step2: META-CartographeRoles (est. 2s)
      - step3: META-PromptMaster (est. 3s)
      - step4: META-AgentFactory (est. 3s)
      - step5: META-GouvernanceQA (est. 2.5s)
```

---

## Variante 10 : MODE EMERGENCY (Fast-track simplifié)

**Cas d'usage** : Urgence absolue, bypass certaines validations non critiques

```yaml
Mode: EMERGENCY
Caractéristiques:
  - Skip validations non critiques
  - Retry 0x (échec direct → escalade)
  - Parallélisation maximale
  - Quality target réduit (7.5 vs 8)

Prompt ajusté:
"Pour ce workflow URGENT (priority=critical), active MODE EMERGENCY:
  - Skip validations optionnelles (garde seulement required fields)
  - Pas de retry (échec direct → escalade)
  - Parallélise tout ce qui est possible
  - Quality target temporairement réduit: 7.5/10 (vs 8/10)
  - Logger justification mode emergency"

Exemple:
  emergency_hotfix:
    mode: EMERGENCY
    reason: "Production down, correctif urgent requis"
    quality_target_reduced: 7.5
    retry_disabled: true
    validations_skipped: [optional_checks, extended_qa]
    estimated_time_saved: "8 minutes"
```

---

**Récapitulatif des 10 modes**:

1. ✅ **STANDARD** : Séquentiel strict (défaut)
2. ⚡ **PARALLEL** : Exécution simultanée
3. 🔀 **CONDITIONAL** : Branches if/then/else
4. 🐛 **DEBUG** : Logs verbeux + validation stricte
5. 🛡️ **RESILIENT** : Max retry + fallback
6. 💾 **INCREMENTAL** : Checkpoints + reprise
7. 📋 **AUDIT** : Traçabilité maximale
8. 👤 **INTERACTIVE** : Validation humaine
9. 🧪 **DRY_RUN** : Simulation sans exécution
10. 🚨 **EMERGENCY** : Fast-track urgent
