# IT-InterventionCopilot — Exemples d’usage (5 scénarios)

> Note : les exemples ci-dessous utilisent des **données pseudonymisées/fictives** (noms génériques) uniquement pour illustrer le format.

---

## 1) NOC — Service indisponible (MODE=LIVE)

### Entrée (brief)
```
/template NOC
MODE=LIVE
client=ExempleCo
ticket_id=123456
Objet: le portail client est indisponible depuis 09:10.
Actions déjà faites: redémarrage du service web effectué, retour OK à 09:25.
Validation: monitoring encore en alerte, besoin de vérifier.
```

### Sortie attendue (YAML)
```yaml
MODE: LIVE
CONTEXT:
  client: "ExempleCo"
  ticket_id: "123456"
  type: "NOC"
  objects: ["Portail client", "Service web"]
  maintenance_window: null
  after_hours: null
  approval_required: null
JOURNAL:
  - id: 1
    time: "09:10"
    action: "Réception de l’alerte : portail client indisponible."
    status: "FAIT"
  - id: 2
    time: "09:25"
    action: "Redémarrage du service web."
    status: "FAIT"
    note: "Confirmé par l’utilisateur."
CHECKLIST:
  - item: "Triage : confirmer impact (utilisateurs / zones / SLA)."
    status: "À FAIRE"
  - item: "Vérifier état monitoring/alerting (résumé)."
    status: "À SUIVRE"
  - item: "Collecter éléments utiles (résumé d’erreurs, changements récents si fournis)."
    status: "À FAIRE"
  - item: "Valider rétablissement : tests fonctionnels + monitoring OK."
    status: "À SUIVRE"
PREUVES: []
VALIDATIONS:
  - check: "Service accessible (test fonctionnel)"
    status: "À CONFIRMER"
  - check: "Monitoring OK"
    status: "KO"
    note: "Alerte encore active selon brief."
QUESTIONS:
  - "Quel est le message exact (ou résumé) de l’alerte monitoring actuelle ?"
  - "Le portail est-il accessible depuis l’extérieur (test utilisateur) ?"
PROCHAINES_ACTIONS:
  - "Récupérer un résumé de l’alerte monitoring et confirmer l’accessibilité utilisateur."
  - "Si accessible mais alerte persiste : vérifier métriques/sondes et mettre à jour la validation."
```

---

## 2) SOC — Alerte EDR (MODE=LIVE) avec capture illisible

### Entrée (brief)
```
/template SOC
MODE=LIVE
client=ExempleCo
ticket_id=789012
Alerte EDR sur un poste. J’ai une capture mais elle est floue.
[capture jointe]
Aucune action encore effectuée.
```

### Sortie attendue (YAML)
```yaml
MODE: LIVE
CONTEXT:
  client: "ExempleCo"
  ticket_id: "789012"
  type: "SOC"
  objects: ["Poste utilisateur (non précisé)"]
  maintenance_window: null
  after_hours: null
  approval_required: null
JOURNAL:
  - id: 1
    time: null
    action: "Réception de l’alerte EDR et ouverture de l’investigation."
    status: "FAIT"
CHECKLIST:
  - item: "Triage sécurité : confirmer type d’alerte, criticité, étendue."
    status: "À FAIRE"
  - item: "Collecter IOCs/horodatages (résumé non sensible)."
    status: "À FAIRE"
  - item: "Containment (isolement/limitation) si criticité élevée."
    status: "À CONFIRMER"
  - item: "Vérifier EDR/SIEM après actions (résumé)."
    status: "À FAIRE"
PREUVES:
  - type: "Capture d’écran"
    summary: "[ILLISIBLE]"
VALIDATIONS:
  - check: "Containment appliqué"
    status: "À CONFIRMER"
QUESTIONS:
  - "Peux-tu copier/coller le texte de l’alerte (ou un résumé lisible) ?"
  - "Y a-t-il d’autres alertes similaires (même utilisateur/appareil) ?"
PROCHAINES_ACTIONS:
  - "Obtenir un résumé lisible de l’alerte pour identifier la priorité et décider du containment."
```

---

## 3) Support — Problème applicatif (MODE=LIVE)

### Entrée (brief)
```
/template SUPPORT
MODE=LIVE
client=ExempleCo
ticket_id=345678
Symptôme: l’application plante à l’ouverture chez plusieurs utilisateurs.
Actions: mise à jour effectuée hier soir (info fournie par le client).
```

### Sortie attendue (YAML)
```yaml
MODE: LIVE
CONTEXT:
  client: "ExempleCo"
  ticket_id: "345678"
  type: "Support"
  objects: ["Application (nom non précisé)"]
  maintenance_window: null
  after_hours: null
  approval_required: null
JOURNAL:
  - id: 1
    time: null
    action: "Prise en charge : application plante à l’ouverture (plusieurs utilisateurs)."
    status: "FAIT"
CHECKLIST:
  - item: "Reproduction : confirmer versions, environnement, fréquence."
    status: "À FAIRE"
  - item: "Diagnostic : corréler avec la mise à jour d’hier (si confirmée)."
    status: "À SUIVRE"
  - item: "Correctif : rollback/patch/contournement (selon décision)."
    status: "À CONFIRMER"
  - item: "Validation : utilisateur OK + absence de récidive."
    status: "À FAIRE"
PREUVES: []
VALIDATIONS: []
QUESTIONS:
  - "Quel est le message d’erreur (ou résumé) au moment du crash ?"
  - "Quelle version exacte de l’application et du système est concernée ?"
PROCHAINES_ACTIONS:
  - "Collecter message d’erreur (résumé) et versions."
  - "Identifier si la mise à jour d’hier est le déclencheur (corrélation)."
```

---

## 4) Changement planifié (fenêtre maintenance) — préparation rollback

### Entrée (brief)
```
/template AUTRE
MODE=LIVE
client=ExempleCo
ticket_id=555555
maintenance_window=Samedi 22:00-23:00
after_hours=true
approval_required=true
Objectif: appliquer un changement de configuration réseau.
Approbat°: pas encore reçue.
```

### Sortie attendue (YAML)
```yaml
MODE: LIVE
CONTEXT:
  client: "ExempleCo"
  ticket_id: "555555"
  type: "Autre"
  objects: ["Configuration réseau (détails non fournis)"]
  maintenance_window: "Samedi 22:00-23:00"
  after_hours: true
  approval_required: true
JOURNAL:
  - id: 1
    time: null
    action: "Préparation du changement planifié sous fenêtre de maintenance."
    status: "FAIT"
CHECKLIST:
  - item: "Vérifier approbation client/autorisation avant exécution."
    status: "À SUIVRE"
  - item: "Définir prérequis (accès, sauvegarde config, plan de communication)."
    status: "À FAIRE"
  - item: "Définir plan de rollback (étapes + critères de déclenchement)."
    status: "À FAIRE"
  - item: "Exécuter changement (uniquement après approbation)."
    status: "À CONFIRMER"
  - item: "Validation post-change : services OK + monitoring OK."
    status: "À FAIRE"
PREUVES: []
VALIDATIONS: []
QUESTIONS:
  - "Peux-tu confirmer que l’approbation client est reçue (oui/non) ?"
  - "Quels services critiques doivent être validés après changement ?"
PROCHAINES_ACTIONS:
  - "Obtenir approbation avant toute exécution."
  - "Rédiger plan de rollback et critères de validation."
```

---

## 5) Clôture ticket (MODE=CLOSE) avec email demandé

### Entrée (brief)
```
/close
email_required=true
email_tone=pro
Contexte: incident portail client (ticket 123456). Actions: redémarrage service web effectué, portail accessible. Monitoring revenu OK. Demande: clôturer.
```

### Sortie attendue (YAML)
```yaml
MODE: CLOSE
CW_INTERNAL_NOTES: |-
  Prendre connaissance de la demande et connexion à la documentation de l'entreprise.
  - Ticket: 123456 | Client: ExempleCo | Type: NOC
  - Synthèse : indisponibilité du portail client, remédiée par redémarrage du service web (confirmé).
  - Détails (timeline):
    1) Réception de l’alerte : portail indisponible. [À CONFIRMER] (heure exacte non fournie)
    2) Redémarrage du service web : effectué (confirmé).
    3) Validation accessibilité portail : confirmée par l’utilisateur.
    4) Validation monitoring : revenu OK (confirmé).
  - Preuves :
    - Résumé : monitoring OK (aucun log brut fourni).
  - Validations :
    - Service fonctionnel : OK
    - Monitoring : OK
  - Points à suivre / prévention :
    - Vérifier cause racine si récidive (aucune cause confirmée dans le brief).
CW_DISCUSSION: |-
  Intervention réalisée pour rétablir l’accès au portail client.
  Actions : redémarrage du service applicatif et validations de fonctionnement.
  Résultat : service rétabli et surveillance revenue à l’état normal.
EMAIL_CLIENT: |-
  Bonjour,

  Nous avons pris en charge l’incident d’indisponibilité du portail client. Une intervention a été effectuée pour rétablir le service, suivie de validations de fonctionnement et de surveillance.

  Le portail est de nouveau accessible et la supervision est revenue à l’état normal. Si vous observez une nouvelle anomalie, merci de répondre à ce fil en indiquant l’heure et le contexte.

  Cordialement,
ITEMS_A_CONFIRMER:
  - "Heure exacte de début d’incident non fournie."
```
