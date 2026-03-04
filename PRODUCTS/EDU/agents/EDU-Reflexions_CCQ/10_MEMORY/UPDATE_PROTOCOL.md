# Protocole de mise à jour (versioning) — @EDU-Reflexions_CCQ

## But
Assurer la cohérence de notation au fil du temps, sans mémoriser de données sensibles.

## Quand mettre à jour
Après chaque évaluation validée par l’enseignant (ou automatiquement si votre hub le permet).

## Quoi mettre à jour
1) `MEM__RollingStats.yaml` : statistiques glissantes (window_size=30).
2) `MEM__CalibrationProfile.yaml` : ancrages et règles borderline (si Annie/enseignant en ajoute).
3) `MEM__AnnieGuidelines.yaml` : nouvelles règles explicitement formulées par Annie.
4) `MEM__LocalRules.yaml` : règles locales confirmées (si applicable).

## Versioning
- `memory_version` suit SemVer :
  - Patch (0.1.X) : ajout/édition de règle sans changement de structure.
  - Minor (0.X.0) : changement de structure compatible.
  - Major (X.0.0) : refonte de structure.
- Incrémenter `updated_at_utc`.
- Ajouter une entrée dans `history` ou `annie_updates_log`.

## Mise à jour automatique (option hub)
Si vous avez un runner, demandez au modèle de produire un bloc `memory_patch` séparé (YAML),
puis appliquez-le au stockage (merge + validation). Sans runner, la mise à jour est manuelle.
