# Test Cases — CTL-WatchdogIA

## TC-001 : Light check — FACTORY saine
**Input :** operation=light_check, scope=all, manifests fournis  
**Expected :** factory_status=healthy, issues=[], quality_score >= 9

## TC-002 : Full check — Agent fantôme détecté
**Input :** operation=full_check, scope=all  
**Condition :** Un agent référencé dans agents.manifest.yaml n'a pas de dossier physique  
**Expected :** factory_status=degraded, issues=[{severity: P1, type: phantom_agent}]

## TC-003 : Full check — Agent orphelin
**Input :** operation=full_check, scope=all  
**Condition :** Un agent actif n'est référencé dans aucun playbook  
**Expected :** issues=[{severity: P2, type: orphaned_agent, days_open: >14}]

## TC-004 : Drift check ciblé
**Input :** operation=drift_check, scope=META-PromptMaster  
**Expected :** drift_report avec drift_score 0.0-1.0, recommendation présente

## TC-005 : Manifest manquant
**Input :** operation=full_check, agents_manifest absent  
**Expected :** status=needs_input, missing_inputs=[agents_manifest]  (PAS de rapport incomplet)

## TC-006 : Issue P0 — contrat absent sur agent actif
**Input :** operation=light_check, scope=all  
**Condition :** contract.yaml absent sur un agent utilisé dans un playbook actif  
**Expected :** factory_status=critical, issues=[{severity: P0, type: schema_missing}]
