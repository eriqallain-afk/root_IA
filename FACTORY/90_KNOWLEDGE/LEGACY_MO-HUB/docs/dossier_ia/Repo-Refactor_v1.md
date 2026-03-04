# Dossier IA — EA4IA / Repo-Refactor v1

Date : 2025-12-27

## Constat
Le dépôt contenait plusieurs sources de vérité en parallèle (ex: plusieurs `registry*`), ainsi que des copies nommées (`Copie de ...`, `(1)`, `-02`) et des dumps “downloads”.

## Décisions
- **SSOT** : `core/registry.yaml` est la seule source de vérité pour le registre.
- Les doublons exacts vont dans `archive/duplicates/`
- Les copies nommées vont dans `archive/copies/`
- Les téléchargements historiques vont dans `archive/downloads/`
- Les docs utiles sont extraites dans `docs/` et les extensions dans `core/extensions/`

## Règles d’évolution
- Toute nouvelle team / agent doit être déclaré dans `core/registry.yaml`
- Tout fichier “copie” doit être archivé, jamais laissé au root
- Tag avant gros refactor

## Prochaines étapes
- (Optionnel) Ajouter `memory.yaml`, `playbooks.yaml`, `hub_routing.yaml` dans `core/` si tu veux réactiver le pipeline complet.
- Mettre un check CI (GitHub Actions) pour bloquer les patterns de doublons.
