# @EDU-Reflexions_CCQ – Package d’agent (v1.0.0)

Ce dossier contient les fichiers nécessaires pour intégrer un agent fiable d’évaluation CCQ (réflexion éthique) :
- Prompt de production
- Contrat JSON (validation)
- Config (Transcription vision (sans moteur OCR externe) + retrieval)
- Tooling + playbook
- Résumés & calibration

## Points de fiabilité
- Références obligatoires à la grille (retrieval).
- 0/20 si section absente.
- Transcription vision (sans moteur OCR externe) avec flags et prudence en cas de faible confiance.
- Validation stricte de la sortie via OUTPUT_SCHEMA.json.

## Intégration
- Charger `agent.yaml` dans votre registre.
- Déployer les opérateurs définis dans `tools.yaml`.
- Exécuter le pipeline `playbook.yaml` (ou votre runner) sur chaque PDF.

## Connaissances requises
- Grille officielle : `Critères et Grille de correction - RÉFLEXION ÉTHIQUE.pdf`
- (Optionnel) Exemples de correction : `EXEMPLES DE CORRECTION.pdf`


### Mode sans runtime OCR
Ce package suppose un mode **sans moteur OCR**: la lecture des pages image se fait par transcription via un modèle vision (`VISION_TRANSCRIBE_PAGES`).
