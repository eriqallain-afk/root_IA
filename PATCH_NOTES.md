# Patchpack — Split v2

Ce patchpack corrige la cohérence *split* (FACTORY/ vs PRODUCTS/).

## Application
1) Copie/merge le contenu de ce patchpack à la racine de ton repo.
2) (Optionnel) Exécute `scripts/cleanup_legacy_monolith.ps1` pour déplacer l'ancien monolithe sous `LEGACY/`.
3) Exécute `python 00_ROOT/validate_rootIA_v2.py`.
4) Si besoin: `python scripts/rebuild_indexes.py`.
