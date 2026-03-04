# RUNBOOK — EDU_CCQ_EVAL_BATCH_V1 (@EDU-Reflexions_CCQ)

## Objectif
Traiter un lot (batch) de copies (PDF/texte) avec :
- cohérence de notation cross-session (fichiers `10_MEMORY/*`),
- QA automatique (contrat YAML),
- validation enseignant (sur copies flaggées),
- mise à jour mémoire versionnée,
- rapport de batch + archivage.

## Emplacements (root_IA)
- Index agents : `00_INDEX/agents_index.yaml`
- Playbooks : `40_RUNBOOKS/playbook.yaml`
- Routing : `80_MACHINES/hub_routing.yaml`
- Agent : `20_AGENTS/EDU/EDU-Reflexions_CCQ/`
- Mémoire : `20_AGENTS/EDU/EDU-Reflexions_CCQ/10_MEMORY/`
- Script mémoire : `20_AGENTS/EDU/EDU-Reflexions_CCQ/INTEGRATION/apply_memory_patch.py`

## Entrée attendue (manifest batch recommandé)
Format JSON (ou YAML) suggéré pour le runner :
```json
{
  "batch_id": "CCQ-2026-01-13-G1",
  "grade_level": "sec4",
  "teacher_review_mode": "flagged_only",
  "memory_update": true,
  "items": [
    {"copy_id":"C001","student_label":"S-01","file_path":".../copy1.pdf"},
    {"copy_id":"C002","student_label":"S-02","file_path":".../copy2.pdf"}
  ]
}
```

## Drapeaux QA (flagged_only)
Une copie est flaggée si :
- `quality_and_risk.rubric_available=false`
- `ocr_confidence=low` ou `ocr_flags` non vide
- score proche d’un seuil (ex. 59/60) ou outlier (z>2 si stats disponibles)
- YAML invalide / non conforme contrat

## Mise à jour mémoire (cross-session)
Principe :
1) Après validation enseignant, appliquer `memory_patch` pour les copies approuvées.
2) Commande (exemple) :
```bash
python 20_AGENTS/EDU/EDU-Reflexions_CCQ/INTEGRATION/apply_memory_patch.py \
  --memory-dir 20_AGENTS/EDU/EDU-Reflexions_CCQ/10_MEMORY \
  --result-yaml <chemin_resultat_yaml>
```
Le script bump `memory_version` et `updated_at_utc`.

## Sorties
- Un YAML par copie (conforme contrat) + flags.
- Un rapport batch (CSV/MD) : total, moyenne, dispersion, % flaggées.
- Logs d’exécution : batch_id, versions mémoire avant/après, erreurs.

## SLA recommandé
- Évaluation IA : < 2 min / copie (selon taille PDF)
- QA contrat : < 30 s / copie
- Validation enseignant : < 24 h (flagged_only)

## Fail-safe
- Grille inaccessible : REFUS de noter -> escalade enseignant.
- OCR trop incertain : “à valider” + pas de pénalisation automatique.
- YAML invalide : 1 retry; sinon escalade MO2/enseignant.
