# Gouvernance (Repo)

## Principes

- **SSOT** : une seule source de vérité par type.
- **Archivage** : on préfère déplacer dans `archive/` plutôt que supprimer.
- **Commits atomiques** : 1 intention = 1 commit (ex: “archive duplicates”, “update registry”).

## Conventions de nommage

- Pas d’espaces inutiles en début de nom.
- Éviter les dossiers “fourre-tout” type *Downloads* au root.
- Préférer : `snake_case` ou `kebab-case` (choisir 1 style et s’y tenir).
- Les folders “Teams” vivent dans `teams/`.

## Ce qui est interdit au root

- `registry*.yaml-*`, `*-02`, `(1)`, `Copie de ...`
- fichiers ZIP de transferts
- exports OneDrive non triés

## Politique d’archive

- `archive/duplicates/` : doublons exacts (même hash)
- `archive/copies/` : copies nommées (Copie de / (1) / etc.)
- `archive/downloads/` : dumps historiques

On purge `archive/` seulement quand l’équipe est stable (ou après tag).
