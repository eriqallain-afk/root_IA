# 05 — Exemples d’usage — IAHQ-DevFactoryIA

## Scénario 1 — Plan par phases (MVP → industrialisation)
**Entrée (user)**
> On a une armée de GPT pour support client + CRM. Donne un plan d’exécution par phases.

**Sortie (agent)**
- Synthèse (objectif, rôles GPT, architecture)
- Backlog priorisé
- Phase 1/2/3 + critères de sortie
- Risques + mitigations

---

## Scénario 2 — Workflows d’intégration (humain ↔ GPT ↔ outils)
**Entrée**
> Décris le workflow “email entrant → réponse → création ticket → escalade humain si risque”.

**Sortie**
- Workflow détaillé : entrée → traitement → sortie
- Points de validation humaine + exceptions
- Logs à conserver (audit)

---

## Scénario 3 — Plan de test avant go-live
**Entrée**
> Propose un plan de test pour une armée de GPT qui rédige des réponses clients.

**Sortie**
- Scénarios représentatifs + edge cases
- Jeux de données fictifs / anonymisés
- Critères de réussite + seuils
- Plan de recette (qui valide quoi)

---

## Scénario 4 — Go-live + runbook + rollback
**Entrée**
> On déploie demain. Donne une checklist et un runbook incident.

**Sortie**
- Checklist pré-prod
- Plan de déploiement (steps) + rollback
- Runbook (symptômes → diagnostic → action)
- KPI/SLO (Hypothèse à valider si non fournis)

---

## Scénario 5 — Amélioration continue (mensuelle)
**Entrée**
> Le système tourne. Comment l’optimiser chaque mois ?

**Sortie**
- Rituels + reporting
- Backlog d’amélioration (qualité/coût/latence/UX)
- Cadence de retours META/OPS
- Plan d’expérimentation (A/B tests si pertinent)

---

### Exemple de sortie en MODE MACHINE (extrait)
```yaml
result:
  summary: "Plan d’exécution en 3 phases pour déployer l’armée GPT."
  details: |-
    Phase 1 (MVP):
      - ...
artifacts:
  - type: "plan"
    title: "Backlog & phases"
    path: "backlog.yaml"
next_actions:
  - "Valider les contraintes (outils, données, SLA)."
log:
  decisions:
    - "Découpage MVP/Extension/Industrialisation."
  risks:
    - "Données sensibles non anonymisées."
  assumptions:
    - "Hypothèse à valider : accès API CRM disponible."
```
