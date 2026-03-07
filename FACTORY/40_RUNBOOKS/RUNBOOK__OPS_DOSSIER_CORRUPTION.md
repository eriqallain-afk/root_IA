# RUNBOOK — OPS : Corruption Dossier IA

**ID :** RB-OPS-002  
**Version** : 1.0.0  
**Trigger** : OPS-DossierIA détecte incohérence, données manquantes ou dossier inaccessible  
**Propriétaire** : OPS-DossierIA + CTL-WatchdogIA  
**SLA** : < 15 minutes  
**Mise à jour** : 2026-03-06  

---

## Objectif

Résoudre les incidents liés à la mémoire persistante des projets gérée par OPS-DossierIA — corruption, perte de données, dossiers orphelins.

---

## Types d'incidents

| Code | Description |
|------|-------------|
| `DOSSIER_MISSING` | Dossier projet introuvable par son ID |
| `DOSSIER_CORRUPTED` | Structure invalide ou champs obligatoires manquants |
| `DOSSIER_ORPHAN` | Dossier existant mais non lié à un projet actif |
| `DOSSIER_OVERFLOW` | Volume de logs dépasse la capacité de traitement |
| `CHECKPOINT_LOST` | Dernier checkpoint perdu — reprise impossible |

---

## SCÉNARIO 1 — DOSSIER_MISSING

### Symptômes
- `OPS-DossierIA.search` retourne `not_found` pour un ID connu
- OPS-PlaybookRunner ne peut pas reprendre un run interrompu

### Résolution
1. Vérifier que `dossier_id` n'a pas changé de format (casse, underscores)
2. Chercher dans `90_MEMORY/` et `SHARED/90_MEMORY/`
3. Chercher archives dans `OPS-DossierIA/` sous-dossiers
4. Si introuvable → recréer le dossier à partir des logs d'exécution (OPS-PlaybookRunner `execution_log`)
5. Logger l'incident dans `CTL-HealthReporter`

---

## SCÉNARIO 2 — DOSSIER_CORRUPTED

### Symptômes
- Erreur YAML parse sur lecture dossier
- Champs `status`, `created_at`, ou `steps[]` manquants
- OPS-DossierIA retourne `validation_error`

### Résolution
```
Procédure de reconstruction :
1. Localiser le fichier dossier corrompu
2. Valider avec : python -c "import yaml; yaml.safe_load(open('dossier.yaml'))"
3. Identifier les champs manquants vs schema attendu
4. Restaurer les champs récupérables depuis execution_log
5. Marquer les champs irrécupérables comme null avec note [RECOVERED]
6. Sauvegarder la version reconstruite avec suffixe _RECOVERED
7. Archiver la version corrompue dans 90_KNOWLEDGE/ARCHIVE/
```

---

## SCÉNARIO 3 — CHECKPOINT_LOST

### Symptômes
- OPS-PlaybookRunner ne peut pas reprendre un playbook interrompu
- `last_checkpoint` absent ou invalide dans le dossier

### Résolution
1. Inspecter `execution_log` du playbook — identifier le dernier step réussi
2. OPS-DossierIA crée un checkpoint manuel à ce step
3. OPS-PlaybookRunner reprend depuis ce step
4. Documenter les steps potentiellement ré-exécutés (effets de bord ?)

---

## SCÉNARIO 4 — DOSSIER_ORPHAN

### Symptômes
- CTL-WatchdogIA détecte dossiers > 30 jours sans activité
- Dossier lié à un projet inexistant dans les indexes

### Résolution
1. CTL-WatchdogIA génère rapport des dossiers orphelins
2. Vérifier si projet toujours actif dans `00_INDEX/`
3. Si projet terminé → archiver dossier dans `90_KNOWLEDGE/ARCHIVE/DOSSIERS/`
4. Si projet actif → re-lier le dossier
5. Appliquer politique de rétention (`50_POLICIES/GOVERNANCE/DATA_RETENTION.md`)

---

## Politique de rétention des dossiers

```yaml
retention_policy:
  active_projects: illimité
  completed_projects: 90 jours (puis archivage)
  archived_projects: 365 jours (puis suppression)
  error_logs: 30 jours
  checkpoints: jusqu'à complétion projet
```

---

## Checklist post-incident

- [ ] Dossier restauré ou recréé
- [ ] Intégrité validée (`dossier.yaml` parse OK)
- [ ] Projet re-lié si orphelin
- [ ] CTL-HealthReporter notifié
- [ ] Politique de backup renforcée si nécessaire

---

## Prévention

Pour éviter la corruption :
- Chaque write OPS-DossierIA = transaction atomique + validation schema
- Checkpoint automatique toutes les 3 steps PlaybookRunner
- Backup quotidien dans `SHARED/90_MEMORY/`

---

## Références

- `OPS-DossierIA/prompt.md` — logique mémoire persistante
- `50_POLICIES/GOVERNANCE/DATA_RETENTION.md` — politique rétention
- `RUNBOOK__OPS_PLAYBOOK_RUNNER_FAILURE.md` — panne PlaybookRunner
