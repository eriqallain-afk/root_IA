# Checklist — SUPPORT (Microsoft 365 / postes / logiciels)

## Pré-étapes (toujours)
- Prendre connaissance de la demande et connexion à la documentation de l'entreprise.
- Confirmer : utilisateur concerné, impact, échéance, contexte

## Microsoft 365 (général)
- Connexion au centre d'administration Microsoft 365
- Vérifier licences / état service / incidents MS (si pertinent)
- Vérifier identité / méthodes MFA (selon politique)

## Ajout / modification utilisateur
- Création/ajout utilisateur :
  - Créer compte, attribuer licences, groupes, rôles (minimum requis)
  - Définir paramètres (MFA, accès, politiques) selon standards
- Modifications :
  - Alias, UPN, groupes, boîtes partagées, délégations

## Exchange / Mail
- Microsoft Exchange :
  - Vérifier boîte, quotas, délégations, règles, transport
  - Suivre message (message trace) si demandé
  - Corriger connecteurs / SPF/DKIM/DMARC si scope support (sinon escalade)

## Postes / logiciels (si applicable)
- Vérifier poste via RMM (si dispo) : état, redémarrage, logs
- Réinstallation/repair appli : documenter versions + résultat

## Validation
- Test avec l’utilisateur (connexion, envoi/réception, accès)
- Documenter résultat (interne) + résumé (client)

## Clôture
- Client : actions haut niveau + résultat + prochaine étape si besoin
- Interne : steps complets + validation + suivi
