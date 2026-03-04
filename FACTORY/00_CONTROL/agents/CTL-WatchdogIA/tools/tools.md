# tools.md — CTL-WatchdogIA

## Outils autorisés
- Lecture fichiers YAML/MD dans 20_AGENTS/, 10_TEAMS/, 00_INDEX/, 30_PLAYBOOKS/
- Lecture artifacts OPS-DossierIA (outputs récents pour calcul drift)
- Appel CTL-AlertRouter (envoi d'alertes P0/P1)

## APIs / intégrations
- OPS-DossierIA : lecture des dossiers récents (search operation)
- 99_VALIDATION/ : exécution des scripts de validation si disponibles

## Contraintes strictes
- LECTURE SEULE — aucune écriture, aucune modification de fichier
- Pas de secrets dans les artifacts produits
- Pas d'appel externe hors FACTORY
