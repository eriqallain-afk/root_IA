# RUNBOOK — FACTORY DOWN (Recovery Complète)
**ID :** RB-CTL-003  
**Trigger :** factory_status=critical OU cascade de 3+ agents en échec OU 00_INDEX corrompu  
**Propriétaire :** HUB-AgentMO + IAHQ-TechLeadIA + IAHQ-OrchestreurEntrepriseIA  
**Dernière révision :** 2026-02-25  
**⚠️ PRIORITÉ ABSOLUE — Interrompre tous les playbooks en cours**

---

## NIVEAUX D'INCIDENT

```
NIVEAU 1 — Agent inactif (1 agent seul bloqué)
  → Voir RUNBOOK_AGENT_FAILURE

NIVEAU 2 — Playbook bloqué (1 playbook impossible à terminer)
  → Section 2 de ce runbook

NIVEAU 3 — Corruption d'index (00_INDEX invalide ou manquant)
  → Section 3 de ce runbook

NIVEAU 4 — Perte de données Dossier IA
  → Section 4 de ce runbook

NIVEAU 5 — Défaillance totale (2+ niveaux simultanés)
  → Contacter IAHQ-OrchestreurEntrepriseIA immédiatement
  → Décision humaine requise avant toute action automatique
```

---

## SECTION 2 — Playbook Bloqué

### Diagnostic
```yaml
playbook_failure_info:
  playbook_id: "<id>"
  stuck_at_step: "<step_id>"
  blocking_agent: "<agent_id>"
  error: "<message>"
  can_skip_step: "<oui|non>"
  fallback_agent_available: "<oui|non>"
```

### Actions
```
Option A — Skip du step (si non critique) :
  1. Vérifier que on_failure: skip est autorisé dans le playbook
  2. Logger le skip dans OPS-DossierIA avec justification
  3. Continuer le playbook depuis le step suivant
  4. Ouvrir un ticket P1 pour réparer l'agent skippé

Option B — Agent de remplacement :
  1. Identifier un agent équivalent (même intents dans l'index)
  2. Router manuellement vers cet agent
  3. Documenter la substitution dans le Dossier IA
  4. Ouvrir un ticket P1 pour réparer l'agent original

Option C — Abandon contrôlé :
  1. Arrêter le playbook avec status: abandoned
  2. Sauvegarder tous les outputs produits jusqu'au step bloquant (OPS-DossierIA)
  3. Planifier une reprise après correction de l'agent
  4. Notifier le requérant
```

---

## SECTION 3 — Corruption d'Index

### Symptômes
- OPS-RouterIA ne trouve plus d'agents dans l'index
- `agents.manifest.yaml` vide ou malformé
- `gpt_catalog.yaml` désynchronisé avec les fichiers physiques

### Procédure de reconstruction

```
Étape 1 — SNAPSHOT
  → OPS-DossierIA : operation=create, metadata={type: emergency_backup}
  → Copier l'état actuel de 00_INDEX/ dans 90_KNOWLEDGE/ARCHIVE/BACKUP_<date>/

Étape 2 — VALIDATION
  → Exécuter les scripts de validation :
    99_VALIDATION/Run-Validation.ps1    (PowerShell)
    99_VALIDATION/validate_refs_regex.py (Python)
  → Identifier les fichiers corrompus vs sains

Étape 3 — RECONSTRUCTION SÉLECTIVE
  Si 1-3 fichiers corrompus :
    → Réparer manuellement depuis les fichiers agents (20_AGENTS/)
    → Un agent valide = son agent.yaml a tous les champs requis
  
  Si corruption totale de 00_INDEX/ :
    → Reconstruire agents.manifest.yaml en scannant 20_AGENTS/*/agent.yaml
    → Reconstruire teams_index.yaml depuis 10_TEAMS/TEAM__*.yaml
    → Regénérer intents.yaml depuis les champs intents: de chaque agent.yaml
    → Regénérer gpt_catalog.yaml depuis agents.manifest.yaml

Étape 4 — REVALIDATION
  → Re-exécuter 99_VALIDATION/Run-Validation.ps1
  → CTL-WatchdogIA : operation=full_check
  → Si factory_status=healthy → RECOVERY COMPLET

Étape 5 — POST-MORTEM
  → Lancer PB-CTL-03 (POST_MORTEM_ANALYSIS)
  → Documenter la cause de la corruption dans CHANGELOG.md
```

---

## SECTION 4 — Perte de Données Dossier IA

### Évaluation
```yaml
loss_assessment:
  dossiers_affected: ["<dossier_id>"]
  data_type: "run_logs|outputs|metadata|all"
  last_known_good: "<timestamp>"
  recovery_possible: "<oui|non|partiel>"
```

### Procédure
```
1. ARRÊTER toute écriture dans OPS-DossierIA (stopper les playbooks en cours)
2. ÉVALUER l'étendue de la perte avec CTL-WatchdogIA
3. RESTAURER depuis 90_KNOWLEDGE/ARCHIVE/ si disponible
4. Si pas de backup : documenter la perte dans CHANGELOG.md avec date et périmètre
5. REPRENDRE les playbooks interrompus depuis le dernier step archivé avec succès
6. IMPLÉMENTER une politique de backup automatique si absente
```

---

## SECTION 5 — Checklist de Recovery Complète

Après tout incident NIVEAU 2+ :

```
□ Tous les playbooks en cours stoppés proprement
□ État au moment de l'incident sauvegardé dans OPS-DossierIA
□ Cause racine identifiée (même provisoirement)
□ Scripts de validation exécutés et passés
□ CTL-WatchdogIA full_check : factory_status=healthy
□ Post-mortem ouvert (PB-CTL-03)
□ CHANGELOG.md mis à jour
□ IAHQ-OrchestreurEntrepriseIA notifié si NIVEAU 3+
□ Reprise des playbooks validée par IAHQ-QualityGate
```

---

## Contact d'urgence

En cas de doute sur la procédure à suivre :
→ Arrêter toutes les opérations en cours
→ Escalader à `HUB-AgentMO-MasterOrchestrator` avec le maximum d'informations
→ Ne jamais tenter une correction de masse sans backup préalable
