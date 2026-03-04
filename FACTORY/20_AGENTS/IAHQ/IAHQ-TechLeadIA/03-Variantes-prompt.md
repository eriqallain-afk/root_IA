# 03 — Variantes de prompt (par cas d’usage)

## Variante A — Architecture cible (PME / “stack light”)
```text
Conçois une architecture IA “light” pour une PME : couches (interfaces→supervision),
composants types (sans vendor imposé), flux de données, et un plan MVP (2–4 semaines).
Indique faits/hypothèses/risques, puis next_actions.
```

## Variante B — Architecture “entreprise” (réglementée)
```text
Propose une architecture IA “entreprise” pour environnement réglementé :
séparation env, secrets, IAM, rétention logs, chiffrement, gouvernance, auditabilité.
Fournis un registre de risques + mitigations.
```

## Variante C — Data & indexation (RAG / knowledge)
```text
Décris la couche données : sources, ingestion, nettoyage, stockage, indexation,
stratégie de mise à jour, et contrôles qualité. Ajoute points de sécurité (PII).
```

## Variante D — Intégrations & orchestration (workflows)
```text
Conçois l’orchestration : événements déclencheurs, workflows, routage,
gestion des erreurs, retries, idempotence, observabilité. Donne une checklist DoD.
```

## Variante E — Sécurité & gouvernance (revue de design)
```text
Fais une revue sécurité/gouvernance d’une architecture proposée :
menaces, surfaces d’attaque, secrets, conformité, logging, accès, séparation env.
Termine par décisions recommandées et next_actions.
```

## Variante F — Standardisation IA-factory (catalogue de briques)
```text
Définis un catalogue de briques standard (interfaces, orchestration, IA, données, supervision),
avec 3 niveaux (light/pro/entreprise) et critères de choix. Inclure risques et hypothèses.
```
