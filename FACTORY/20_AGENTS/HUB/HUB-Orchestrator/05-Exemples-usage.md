# Exemples d'usage — HUB-Orchestrator

## Scénario 1 : Création agent IT support (Success)

### ENTRÉE
```yaml
objective: "Créer un agent de support IT niveau 1 pour gérer tickets incidents basiques"
playbook_id: create_agent_complete
context:
  team_target: TEAM__IT
  agent_type: support_l1
  domain: incidents_hardware
priority: medium
deadline: "2026-02-12"
```

### EXÉCUTION
```yaml
execution_log:
  playbook_id: create_agent_complete
  workflow_id: wf_2026-02-10_abc123
  started_at: "2026-02-10T14:30:00Z"
  steps:
    - step: 1
      agent: META-AnalysteBesoinsEquipes
      input:
        objective: "Agent support IT L1 incidents hardware"
      status: success
      duration_ms: 2100
      output_summary: "Besoin défini: support réactif, knowledge base hardware, escalade L2"
      
    - step: 2
      agent: META-CartographeRoles
      input:
        besoin: <output step 1>
        team_id: TEAM__IT
      status: success
      duration_ms: 1850
      output_summary: "Rôle conçu: IT-SupportL1-Hardware, 8 responsabilités, 12 intents"
      
    - step: 3
      agent: META-PromptMaster
      input:
        role: <output step 2>
        quality_target: 9.0
      status: success
      duration_ms: 3200
      output_summary: "Prompt créé, quality 9.2/10, patterns: CONVERSATIONAL + TROUBLESHOOTING"
      
    - step: 4
      agent: META-AgentFactory
      input:
        prompt: <output step 3>
        agent_id: IT-SupportL1-Hardware
        team_id: TEAM__IT
      status: success
      duration_ms: 2650
      output_summary: "Agent IT-SupportL1-Hardware créé, fichiers: agent.yaml, contract.yaml, prompt.md"
      
    - step: 5
      agent: META-GouvernanceQA
      input:
        agent: <output step 4>
        quality_target: 8.0
      status: success
      duration_ms: 2890
      output_summary: "QA passed: quality 8.7/10, tests 5/5 ok, prêt déploiement"
      
  final_status: complete
  total_duration_ms: 12690
  deliverables:
    - "Agent IT-SupportL1-Hardware"
    - "Prompt (quality 9.2/10)"
    - "Tests validation (5/5)"
```

### SORTIE
```yaml
output:
  result:
    summary: "Agent IT-SupportL1-Hardware créé avec succès. Quality 8.7/10, prêt production. Durée totale: 12.7s"
    status: ok
    confidence: 0.95
    execution_log: <voir ci-dessus>
    compiled_result:
      summary: "Agent support IT L1 hardware opérationnel"
      artifacts:
        - "PRODUCTS/IT/agents/IT-SupportL1-Hardware/"
        - "Prompt validé quality 9.2/10"
      key_decisions:
        - "Patterns CONVERSATIONAL + TROUBLESHOOTING sélectionnés"
        - "Template MSP hardware support utilisé"
      next_steps:
        - "Upload agent dans ChatGPT GPT Editor"
        - "Tester avec 3 tickets incidents réels"
        - "Ajuster knowledge base si nécessaire"
        
  artifacts:
    - type: yaml
      title: "Journal d'exécution"
      path: "orchestration/execution_log_wf_2026-02-10_abc123.yaml"
      
    - type: md
      title: "Compilation finale"
      path: "orchestration/compiled_result_wf_2026-02-10_abc123.md"
      
  next_actions: []  # Aucune action requise - success complet
  
  log:
    decisions:
      - "Step 1: Périmètre limité à hardware (exclu software/réseau)"
      - "Step 3: Quality target 9.0 → obtenu 9.2"
      - "Step 5: Tests 5/5 passed → validation immédiate"
    risks: []
    assumptions:
      - assumption: "Tickets hardware = 60% du volume total L1"
        confidence: medium
    quality_score: 9.1
```

---

## Scénario 2 : Business case IA (Partial - info manquante)

### ENTRÉE
```yaml
objective: "Générer business case pour adoption plateforme IA interne"
playbook_id: business_case_generation
context:
  company_size: 500 employees
  industry: financial_services
priority: high
deadline: "2026-02-15"
# MANQUE: budget range, existing tools, pain points détaillés
```

### EXÉCUTION
```yaml
execution_log:
  playbook_id: business_case_generation
  workflow_id: wf_2026-02-10_xyz789
  started_at: "2026-02-10T15:00:00Z"
  steps:
    - step: 1
      agent: IAHQ-BusinessAnalyst
      input:
        objective: "Business case plateforme IA"
        context: <input fourni>
      status: needs_info
      duration_ms: 1200
      output_summary: "Analyse partielle: manque budget range, existing tools, pain points quantifiés"
```

### SORTIE
```yaml
output:
  result:
    summary: "Business case partiellement généré. Information manquante critique: budget, outils existants, pain points. Impossible compléter sans ces données."
    status: needs_info
    confidence: 0.45
    execution_log: <voir ci-dessus>
    compiled_result:
      summary: "Analyse stoppée step 1 - données insuffisantes"
      missing_fields:
        - budget_range: "Fourchette investissement envisagée (ex: 100K-500K€)"
        - existing_tools: "Outils IA déjà utilisés (licences, coûts, limitations)"
        - pain_points: "3-5 problèmes business quantifiés (coût actuel, impact)"
        
  artifacts:
    - type: yaml
      title: "Journal d'exécution partiel"
      path: "orchestration/execution_log_wf_2026-02-10_xyz789.yaml"
      
  next_actions:
    - action: "Fournir budget range et existing tools"
      reason: "Information critique pour calculer ROI"
      required_inputs:
        - "budget_range: ex 200K-400K€"
        - "existing_tools: liste avec coûts annuels"
        - "pain_points: 3-5 problèmes avec coût/impact chiffrés"
    - action: "Relancer playbook avec données complètes"
      reason: "Une fois infos fournies, re-exécuter depuis step 1"
      required_inputs: []
      
  log:
    decisions:
      - "Step 1: Analyse stoppée car données insuffisantes pour ROI"
    risks:
      - risk: "Business case avec hypothèses faibles = rejet probable"
        severity: high
        mitigation: "Demander données réelles plutôt qu'estimer"
    assumptions:
      - assumption: "Budget likely 100K-500K€ (range typique financial services)"
        confidence: low
    quality_score: 4.5  # Faible car incomplet
```

---

## Scénario 3 : Échec avec retry puis escalade

### ENTRÉE
```yaml
objective: "Optimiser prompt agent existant pour atteindre quality 9+"
playbook_id: optimize_existing_prompt
context:
  agent_id: IT-Technicien
  current_quality: 7.2
  target_quality: 9.0
```

### EXÉCUTION
```yaml
execution_log:
  playbook_id: optimize_existing_prompt
  workflow_id: wf_2026-02-10_fail01
  started_at: "2026-02-10T16:00:00Z"
  steps:
    - step: 1
      agent: META-PromptMaster
      input:
        agent_id: IT-Technicien
        current_quality: 7.2
        target_quality: 9.0
      status: success
      duration_ms: 3500
      output_summary: "Prompt optimisé, quality estimée 8.8/10"
      
    - step: 2
      agent: META-GouvernanceQA
      input:
        prompt: <output step 1>
        quality_target: 9.0
      status: failed
      duration_ms: 2100
      output_summary: "QA failed: quality réelle 8.3/10 < 9.0 requis"
      retry: true
      retry_result:
        status: failed
        duration_ms: 2200
        output_summary: "Retry QA failed: quality 8.5/10 < 9.0 requis"
        reason: "Prompt amélioré mais pas assez pour atteindre target 9.0"
        
  final_status: failed
  escalated_to: HUB-AgentMO-MasterOrchestrator
```

### SORTIE
```yaml
output:
  result:
    summary: "Échec après retry: quality 8.5/10 < 9.0 requis. Escalade vers HUB-AgentMO pour arbitrage."
    status: error
    confidence: 0.80
    execution_log: <voir ci-dessus>
    compiled_result:
      summary: "Optimisation insuffisante malgré retry"
      issue: "Quality gap 9.0 - 8.5 = 0.5 trop important"
      escalation:
        reason: "Step 2 (META-GouvernanceQA) failed après retry"
        agent: HUB-AgentMO-MasterOrchestrator
        required_decision: "Accepter 8.5 OU retravailler prompt OU réviser target à 8.5"
        
  artifacts:
    - type: yaml
      title: "Journal échec + escalade"
      path: "orchestration/execution_log_wf_2026-02-10_fail01.yaml"
      
  next_actions:
    - action: "Arbitrage HUB-AgentMO"
      reason: "Décision nécessaire: accepter qualité moindre ou investir plus temps"
      required_inputs: ["decision: accept_8.5 | rework | lower_target"]
      
  log:
    decisions:
      - "Step 1: Optimisation standard appliquée (patterns + structure)"
      - "Step 2: Retry automatique après 1er échec"
      - "Step 2 retry: Échec confirmé → escalade obligatoire"
    risks:
      - risk: "Prompt quality 8.5 peut être insuffisant en production"
        severity: medium
        mitigation: "Escalade pour arbitrage informé"
    assumptions:
      - assumption: "Quality 9.0 possible avec plus iterations"
        confidence: medium
    quality_score: 5.0  # Faible car objectif non atteint
```

---

## Scénario 4 : Playbook conditionnel (branch if/else)

### ENTRÉE
```yaml
objective: "Déployer agent avec QA conditionnelle : si quality ≥ 8 deploy, sinon optimize"
playbook_id: conditional_deployment
context:
  agent_id: DAM-ProjectManager
  quality_threshold: 8.0
```

### EXÉCUTION
```yaml
execution_log:
  playbook_id: conditional_deployment
  workflow_id: wf_2026-02-10_cond01
  started_at: "2026-02-10T17:00:00Z"
  steps:
    - step: 1
      agent: META-GouvernanceQA
      input:
        agent_id: DAM-ProjectManager
        quality_target: 8.0
      status: success
      duration_ms: 2400
      output_summary: "QA: quality 7.5/10"
      
    - step: 2  # Condition: quality < 8
      branch: else  # Quality 7.5 < 8 → branche optimize
      agent: META-PromptMaster
      input:
        agent_id: DAM-ProjectManager
        optimize_for: quality
        target: 8.0
      status: success
      duration_ms: 3100
      output_summary: "Prompt optimisé, quality estimée 8.3/10"
      
    - step: 3  # Re-QA après optimize
      agent: META-GouvernanceQA
      input:
        agent: <output step 2>
        quality_target: 8.0
      status: success
      duration_ms: 2500
      output_summary: "QA passed: quality 8.3/10 ≥ 8.0"
      
    - step: 4  # Deploy (condition satisfaite)
      agent: OPS-PlaybookRunner
      input:
        action: deploy
        agent_id: DAM-ProjectManager
        environment: production
      status: success
      duration_ms: 1800
      output_summary: "Agent déployé en production"
      
  final_status: complete
  total_duration_ms: 9800
```

### SORTIE
```yaml
output:
  result:
    summary: "Agent DAM-ProjectManager déployé après optimisation. Quality 7.5 → 8.3. Condition if/else appliquée avec succès."
    status: ok
    confidence: 0.90
    execution_log: <voir ci-dessus>
    compiled_result:
      summary: "Déploiement réussi via branche conditionnelle"
      conditional_logic:
        condition: "quality < 8.0"
        branch_taken: "else (optimize)"
        branch_skipped: "then (deploy direct)"
      final_quality: 8.3
      
  artifacts:
    - type: yaml
      title: "Journal exécution conditionnelle"
      path: "orchestration/execution_log_wf_2026-02-10_cond01.yaml"
      
  next_actions: []
  
  log:
    decisions:
      - "Step 1: Quality 7.5 < 8 → branche ELSE (optimize)"
      - "Step 2: Optimisation appliquée"
      - "Step 3: Re-QA passed → condition satisfaite"
      - "Step 4: Deploy autorisé"
    risks: []
    assumptions:
      - assumption: "Une seule itération optimize suffisante"
        confidence: high
    quality_score: 8.8
```

---

## Scénario 5 : Playbook parallèle multi-équipes

### ENTRÉE
```yaml
objective: "Recherche multi-angle sur adoption IA healthcare"
playbook_id: multi_team_research
context:
  domain: healthcare_ai_adoption
  perspectives: [technical, business, regulatory]
execution_mode: parallel  # Steps 2-4 en parallèle
```

### EXÉCUTION
```yaml
execution_log:
  playbook_id: multi_team_research
  workflow_id: wf_2026-02-10_par01
  started_at: "2026-02-10T18:00:00Z"
  steps:
    - step: 1
      agent: HUB-Concierge
      input:
        objective: "Cadrer recherche multi-angle healthcare AI"
      status: success
      duration_ms: 1500
      output_summary: "Cadrage: 3 angles (technique, business, réglementaire), 2 semaines, budget 50K€"
      
    # Steps 2-4 en PARALLÈLE (exécutés simultanément)
    - step: 2
      agent: META-AnalysteBesoinsEquipes
      parallel_group: research
      input:
        angle: technical
        domain: healthcare_ai
      status: success
      duration_ms: 4200
      output_summary: "Analyse technique: IA diagnostic, IA prédictive, IA administrative"
      started_at: "2026-02-10T18:00:01.5Z"
      completed_at: "2026-02-10T18:00:05.7Z"
      
    - step: 3
      agent: IAHQ-BusinessAnalyst
      parallel_group: research
      input:
        angle: business
        domain: healthcare_ai
      status: success
      duration_ms: 3800
      output_summary: "Analyse business: ROI 18 mois, réduction coûts 25%, satisfaction +30%"
      started_at: "2026-02-10T18:00:01.5Z"
      completed_at: "2026-02-10T18:00:05.3Z"
      
    - step: 4
      agent: IAHQ-ComplianceExpert
      parallel_group: research
      input:
        angle: regulatory
        domain: healthcare_ai
      status: success
      duration_ms: 5100
      output_summary: "Analyse réglementaire: RGPD, ISO 13485, FDA AI/ML guidelines"
      started_at: "2026-02-10T18:00:01.5Z"
      completed_at: "2026-02-10T18:00:06.6Z"
      
    # Synchronisation après parallel_group
    - step: 5
      agent: META-Redaction
      input:
        compile_from: [step2, step3, step4]
        format: executive_report
      status: success
      duration_ms: 2900
      output_summary: "Rapport exécutif 12 pages compilé"
      
  final_status: complete
  total_duration_ms: 8200  # Gain temps: 5100ms (max parallel) vs 13100ms (si séquentiel)
  parallel_gain_ms: 4900
```

### SORTIE
```yaml
output:
  result:
    summary: "Recherche multi-angle terminée en 8.2s (vs 13.1s séquentiel, gain 37%). Rapport exécutif 12 pages généré."
    status: ok
    confidence: 0.92
    execution_log: <voir ci-dessus>
    compiled_result:
      summary: "Adoption IA healthcare analysée sous 3 angles"
      perspectives:
        technical: "IA diagnostic, prédictive, administrative identifiées"
        business: "ROI 18 mois, -25% coûts, +30% satisfaction"
        regulatory: "Conformité RGPD + ISO 13485 + FDA requis"
      executive_report: "orchestration/healthcare_ai_report_wf_2026-02-10_par01.pdf"
      
  artifacts:
    - type: yaml
      title: "Journal exécution parallèle"
      path: "orchestration/execution_log_wf_2026-02-10_par01.yaml"
      
    - type: pdf
      title: "Rapport exécutif healthcare AI"
      path: "orchestration/healthcare_ai_report_wf_2026-02-10_par01.pdf"
      
  next_actions: []
  
  log:
    decisions:
      - "Steps 2-4: Exécution parallèle autorisée (pas dépendances inter-steps)"
      - "Step 5: Synchronisation attendu completion steps 2-4"
      - "Gain temps 37% vs exécution séquentielle"
    risks: []
    assumptions:
      - assumption: "3 équipes disponibles simultanément"
        confidence: high
    quality_score: 9.2
```

---

**Ces 5 scénarios couvrent**:
1. ✅ Success complet (création agent)
2. ⚠️ Partial - info manquante (business case)
3. ❌ Échec avec retry + escalade (optimisation)
4. 🔀 Conditionnel if/else (deployment)
5. ⚡ Parallèle multi-équipes (research)
