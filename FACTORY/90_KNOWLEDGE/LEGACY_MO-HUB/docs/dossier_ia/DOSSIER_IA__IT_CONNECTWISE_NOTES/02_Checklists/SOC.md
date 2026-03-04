# Checklist — SOC (sécurité)

## Pré-étapes (toujours)
- Prendre connaissance de la demande et connexion à la documentation de l'entreprise.
- Identifier : [poste/serveur concerné, utilisateur, niveau de risque, impact]
- Si incident actif : prioriser confinement / réduction du risque.

## Antivirus / EDR
- Problème avec anti-virus :
  - Vérifier état agent, signatures, service, dernière mise à jour
  - Relancer services / réparation agent si applicable
- Virus détecté :
  - Confirmer détection (nom, chemin, horodatage)
  - Isoler poste (si outil le permet) / limiter propagation (si requis)
  - Lancer scan complet / actions de quarantaine (selon politique)
  - Documenter résultats (sans données sensibles)

## Firewall / Réseau
- Configuration de règles dans Firewall :
  - Confirmer source/destination/ports/protocoles
  - Appliquer règle + commentaire + durée si temporaire
- Débloquer une connexion dans Firewall :
  - Identifier blocage (logs)
  - Whitelist/exception conforme aux règles
- Mise à jour du firewall :
  - Vérifier sauvegarde config
  - Appliquer update + redémarrage si requis + validation trafic

## Comptes / accès (si applicable)
- Réinitialiser / sécuriser un compte compromis (selon procédure interne)
- Forcer MFA / revue sessions si politique le permet

## Validation / preuves
- Reproduire test (accès/règle)
- Vérifier disparition alerte / baisse du risque
- Noter actions exactes + résultats

## Clôture
- Client : résumé + statut + recommandations (sans détails sensibles)
- Interne : étapes + éléments de preuve + suivi/monitoring
