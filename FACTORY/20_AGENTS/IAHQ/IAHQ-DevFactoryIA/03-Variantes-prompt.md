# 03 — Variantes de prompt — IAHQ-DevFactoryIA

Utilise ces variantes pour “verrouiller” un format de sortie selon le besoin, puis reviens au prompt stable.

---

## Variante 1 — Mode « Backlog & phases (sprints) »
**Quand :** tu as une architecture/armée GPT et tu dois produire un plan d’exécution.

**Sortie attendue :**
- Hypothèses & contraintes
- Backlog priorisé (impact × effort × risque)
- Phases 1/2/3 + dépendances
- Critères de sortie par phase (DoD)

---

## Variante 2 — Mode « Workflows d’intégration »
**Quand :** le client veut des flux précis : humain ↔ GPT ↔ outils.

**Sortie attendue :**
- Liste des workflows (par scénario)
- Pour chaque workflow : entrée → traitement → sortie → validations humaines
- Gestion erreurs / exceptions / escalades
- Traces & logs à conserver (auditabilité)

---

## Variante 3 — Mode « Plan de test & validation »
**Quand :** on veut vérifier la robustesse avant go-live.

**Sortie attendue :**
- Scénarios (fonctionnels, edge cases, sécurité, conformité)
- Jeux de données fictifs / anonymisés (si applicable)
- Critères de réussite + seuils
- Plan de recette (qui valide quoi, quand)

---

## Variante 4 — Mode « Go-live & runbook »
**Quand :** mise en production imminente ou migration.

**Sortie attendue :**
- Checklist pré-prod (accès, secrets, environnements, monitoring)
- Plan de déploiement (steps + rollback)
- Runbook incident (symptômes → diagnostics → actions)
- KPI/SLA/SLO (Hypothèse à valider si non fournis)

---

## Variante 5 — Mode « Maintenance & amélioration continue »
**Quand :** le système tourne déjà et doit être optimisé.

**Sortie attendue :**
- Rituels (hebdo/mensuel) + reporting
- Backlog d’amélioration (qualité, coût, latence, UX)
- Moments de retour vers META (prompts/rôles) et OPS (infra/monitoring)
- Plan d’A/B tests (si pertinent)

---

## Variante 6 — Mode « Incident / Turnaround »
**Quand :** ça casse en prod, il faut stabiliser vite.

**Sortie attendue :**
- Triage (impact, périmètre, cause probable)
- Stop/Start/Continue
- Correctifs immédiats + correctifs structurels
- Post-mortem (actions + prévention)
