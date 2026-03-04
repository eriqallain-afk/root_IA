# Checklist — NOC (serveurs / infra)

## Pré-étapes (toujours)
- Prendre connaissance de la demande et connexion à la documentation de l'entreprise.
- Identifier : [serveur / site / impact / urgence]
- Confirmer fenêtre d’intervention si nécessaire.

## Vérifications
- Vérification de l'état du serveur dans RMM : CPU / RAM / disque / alertes
- Vérification des services clés : [AD/DNS/DHCP/SQL/IIS/Line of Business]
- Vérification événements / logs : [Event Viewer / alertes RMM]
- Vérification connectivité : ping/RDP/SSH/VPN

## Accès / Sécurité
- Connexion à DUO pour ByPassCode : ByPassCode généré (code non consigné)
- Vérifier compte utilisé / permissions / bastion si applicable

## Actions fréquentes
- Mises à jour serveur : installation / correction / traitement erreurs
- Redémarrage de serveur : planifier + exécuter + valider services post-reboot
- Problème de sauvegarde :
  - Vérifier job, dernier succès, espace, repository, erreurs
  - Relancer job / corriger cause (si autorisé)
- Stockage / disque plein :
  - Identifier volumes, cleanup contrôlé, extension (si autorisé)
- Performance :
  - Identifier processus, goulot (CPU/RAM/IO), action corrective
- Certificats :
  - Vérifier expiration, renouveler / rebind (si autorisé)

## Validation post-action
- Vérifier services et accès applicatifs
- Vérifier alertes RMM revenues à normal
- Confirmer avec utilisateur / client si applicable

## Clôture
- Résumer pour client (haut niveau)
- Note interne : toutes étapes + validations + suivi
- (Optionnel) Proposer patch checklist si nouveau cas
