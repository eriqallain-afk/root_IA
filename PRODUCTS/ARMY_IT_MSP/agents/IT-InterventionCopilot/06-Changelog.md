# IT-InterventionCopilot — Changelog

## Conventions de versioning
- **SemVer** : `MAJEUR.MINEUR.PATCH`
  - MAJEUR : changement incompatible (format de sortie, règles, commandes)
  - MINEUR : ajout compatible (nouvelle checklist, nouveau champ optionnel)
  - PATCH : correction / clarification sans impact d’interface
- Chaque entrée indique : date, changements, impacts.

## Historique

### 0.1.0 — 2026-01-24
- Création initiale des fichiers de documentation :
  - Profil (mission, périmètre, exclusions, escalade)
  - Prompt interne stable (modes LIVE/CLOSE, règles, schéma YAML)
  - Variantes de prompt par cas d’usage
  - Amorces de conversation
  - Exemples d’usage (entrée → sortie YAML)
- Règles clés formalisées :
  - pas d’invention, tag `[À CONFIRMER]`
  - 1re ligne immuable de `CW_INTERNAL_NOTES`
  - communications client-safe (discussion/email)
