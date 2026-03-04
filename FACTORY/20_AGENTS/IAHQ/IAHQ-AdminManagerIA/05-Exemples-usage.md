# 05 — Exemples d’usage (5 scénarios)

> Note : exemples illustratifs. Les éléments non fournis sont marqués “Hypothèse à valider”.

## Scénario 1 — Offre “PME IA” en 3 phases
**Entrée (résumé)**  
Client PME, besoin: diagnostic + assistant interne + formation. Délai: 6 semaines.

**Sortie (extrait YAML)**
```yaml
result:
  summary: "Offre phasée: Diagnostic → Livraison MVP → Formation & passage en run."
  details: |-
    faits:
      - "Client: PME, objectif: assistant interne."
    hypotheses_a_valider:
      - "Hypothèse à valider: outil de suivi projet (Jira/Notion/Asana) déjà choisi."
    phases:
      - name: "Phase 1 — Diagnostic & Blueprint"
        livrables: ["Ateliers cadrage", "Blueprint", "Backlog priorisé"]
      - name: "Phase 2 — Mise en place MVP"
        livrables: ["Prototype", "Tests", "Validation"]
      - name: "Phase 3 — Formation & run"
        livrables: ["Formation", "Handover", "Plan support"]
next_actions:
  - "Confirmer contraintes (sécurité/données) et outils de pilotage."
log:
  decisions:
    - "Structurer l’offre en phases avec critères d’acceptation."
  risks:
    - "Scope creep si options/addons non cadrés."
  assumptions:
    - "Le client peut fournir un référent métier + un référent IT."
```

## Scénario 2 — Onboarding client (armée GPT) + checklist accès
**Entrée (résumé)**  
Projet: armée GPT + intégration SI. Démarrage la semaine prochaine.

**Sortie (extrait YAML)**
```yaml
result:
  summary: "Onboarding en 10 points: accès, données, interlocuteurs, rituels, sécurité."
  details: |-
    checklist_onboarding:
      - "Signer NDA / conditions (si applicable)"
      - "Identifier sponsors + RACI"
      - "Accès outils (sans secrets dans les messages)"
      - "Inventaire sources data + contraintes PII"
      - "Kick-off + calendrier jalons"
    inconnus:
      - "Canal officiel de partage d’accès (Hypothèse à valider: coffre/ITSM)."
next_actions:
  - "Organiser kick-off + valider RACI et canaux d’accès."
log:
  decisions:
    - "Privilégier checklists standardisées réutilisables."
  risks:
    - "Retard si accès non prêts avant kick-off."
  assumptions:
    - "Un canal sécurisé existe pour l’échange d’accès."
```

## Scénario 3 — Change request (anti-scope creep)
**Entrée (résumé)**  
Le client demande des “petites fonctionnalités en plus” chaque semaine.

**Sortie (extrait YAML)**
```yaml
result:
  summary: "Procédure de change request: qualification → impact → décision → avenant."
  details: |-
    procedure:
      - "Soumission CR (description, valeur business, urgence)"
      - "Analyse impact (charge, délai, coût, risques)"
      - "Décision (accept/refuse/park) par sponsor"
      - "Mise à jour backlog + contrat/jalons si accepté"
next_actions:
  - "Mettre en place un template CR et un rituel de revue hebdo."
log:
  decisions:
    - "Exiger validation sponsor pour tout changement impactant."
  risks:
    - "Baisse marge / glissement planning si CR non contrôlées."
  assumptions:
    - "Le sponsor client peut arbitrer rapidement."
```

## Scénario 4 — Templates de messages (génériques)
**Entrée (résumé)**  
Besoin: relance documents + confirmation jalon + demande feedback.

**Sortie (extrait YAML)**
```yaml
result:
  summary: "Canevas de messages génériques, sans données sensibles."
  details: |-
    templates:
      - name: "Relance informations"
        body: "Bonjour, pour avancer sur [PHASE], il nous manque: [LISTE]. Pouvez-vous partager avant [DATE] via le canal sécurisé habituel ?"
      - name: "Confirmation jalon"
        body: "Bonjour, le jalon [JALON] est validé. Prochaine étape: [ETAPE], avec les prérequis: [PREREQUIS]."
      - name: "Demande feedback"
        body: "Bonjour, pourriez-vous partager votre feedback sur [PERIMETRE] (ce qui marche / à améliorer) ?"
next_actions:
  - "Adapter les champs [PLACEHOLDERS] au contexte projet."
log:
  decisions:
    - "Utiliser des templates génériques à placeholders."
  risks:
    - "Risque de partage d’infos sensibles si placeholders remplacés sans contrôle."
  assumptions:
    - "Le client utilise un canal sécurisé pour pièces jointes."
```

## Scénario 5 — Facturation par jalons (sans conseil fiscal définitif)
**Entrée (résumé)**  
Projet 3 mois, phases claires, besoin d’un schéma d’acompte + réception livrables.

**Sortie (extrait YAML)**
```yaml
result:
  summary: "Facturation par jalons: acompte → jalons → réception → solde."
  details: |-
    schema:
      - "Acompte à la commande (démarrage)"
      - "Facture à chaque jalon livré + reçu"
      - "Solde à la clôture + handover"
    note:
      - "Conseil fiscal/juridique définitif: escalader à un pro humain."
next_actions:
  - "Définir les critères de réception (DoD) par phase."
log:
  decisions:
    - "Lier facturation à des livrables/acceptations pour éviter ambiguïtés."
  risks:
    - "Litiges si critères de réception non explicités."
  assumptions:
    - "Les jalons sont acceptés formellement (mail/outil)."
```
