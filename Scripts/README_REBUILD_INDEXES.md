# Rebuild indexes (Windows)

## Option PowerShell (recommandé)
Depuis la racine du repo `root_IA` :

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\rebuild_indexes.ps1 -Bundles -MirrorSchemas
```

Options:
- `-Force` : écrase même les fichiers non auto-générés
- `-Bundles` : reconstruit `90_KNOWLEDGE/CONTEXT__CORE.md` + `INDEX__*.md` + `BUNDLES/*`
- `-MirrorSchemas` : copie `SCHEMAS/*.json` vers `70_INTEGRATION_PACKAGES/SCHEMAS/`

## Option CMD
```bat
scripts\rebuild_indexes.cmd --bundles --mirror-schemas
```

## Ce qui est généré
- `10_TEAMS/teams.yaml`
- `00_INDEX/agents.yaml`
- `50_POLICIES/POLICIES__INDEX.md`
- `20_AGENTS/**/agent.yaml` (si manquant)
- (optionnel) `90_KNOWLEDGE/*` bundles

> Les fichiers générés contiennent un marqueur `AUTO-GENERATED...`.
> En mode normal, si un fichier existe sans marqueur, le script crée un `*.new` au lieu d'écraser.
