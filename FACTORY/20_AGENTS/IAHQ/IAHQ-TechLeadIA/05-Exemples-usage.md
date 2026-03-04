# 05 — Exemples d’usage (5 scénarios)

> Note : exemples illustratifs. Les éléments non fournis sont marqués “Hypothèse à valider”.

## Scénario 1 — PME : stack “light” + MVP
**Entrée (résumé)**  
Objectif: déployer un assistant interne support IT + base de connaissances.  
Contraintes: 1 mois, équipe réduite, données sensibles limitées.

**Sortie (extrait YAML)**
```yaml
result:
  summary: "Architecture light: chat + orchestration simple + index doc + logs de base."
  details: |-
    faits:
      - "Objectif: support IT interne."
    hypotheses_a_valider:
      - "Hypothèse à valider: les docs sources sont centralisées (Drive/Notion/Confluence)."
    architecture_logique:
      - "Interfaces → Orchestration → IA → Données → Supervision"
next_actions:
  - "Lister les sources documentaires et leur format."
log:
  decisions:
    - "Proposer une stack light sans vendor imposé."
  risks:
    - "Qualité KB insuffisante si docs obsolètes."
  assumptions:
    - "Docs accessibles via un dépôt unique."
```

## Scénario 2 — Entreprise réglementée : durcissement sécurité
**Entrée (résumé)**  
Objectif: assistants métiers sur données clients (PII).  
Contraintes: audit, rétention, chiffrement, séparation environnements.

**Sortie (extrait YAML)**
```yaml
result:
  summary: "Architecture entreprise: IAM strict, secrets vault, chiffrement, audit logs, env séparés."
  details: |-
    mesures_cles:
      - "Séparation Dev/Prod + contrôles d’accès."
      - "Politique de logs + rétention (à définir)."
    hypotheses_a_valider:
      - "Hypothèse à valider: exigences exactes (RGPD, SOC2/ISO) et durées de rétention."
```

## Scénario 3 — Data/RAG : ingestion + indexation
**Entrée (résumé)**  
Objectif: RAG sur procédures + tickets.  
Contraintes: mise à jour quotidienne, éviter PII.

**Sortie (extrait YAML)**
```yaml
result:
  summary: "Pipeline data: ingestion → nettoyage → détection PII → index → refresh."
  details: |-
    controles_qualite:
      - "Déduplication, validation structure, tests de recherche."
    risks:
      - "Fuite PII si détection incomplète."
```

## Scénario 4 — Orchestration : workflows + erreurs
**Entrée (résumé)**  
Objectif: enchaîner analyse → décision → génération de livrables.  
Contraintes: traçabilité, retries, idempotence.

**Sortie (extrait YAML)**
```yaml
result:
  summary: "Workflows découpés, points de contrôle humains, gestion d’erreurs standard."
  details: |-
    patterns:
      - "Retries avec backoff, DLQ/queue d’échecs (si applicable)."
      - "États persistés pour idempotence."
```

## Scénario 5 — Standard IA-factory : catalogue de briques
**Entrée (résumé)**  
Objectif: standardiser 3 niveaux d’offre.  
Contraintes: réutilisable, gouvernable, maintenable.

**Sortie (extrait YAML)**
```yaml
result:
  summary: "Catalogue de briques par couche + 3 niveaux (light/pro/entreprise) + critères."
  details: |-
    niveaux:
      - "Light: minimum viable + logs basiques."
      - "Pro: orchestration robuste + observabilité."
      - "Entreprise: IAM, audit, conformité, haute dispo."
```
