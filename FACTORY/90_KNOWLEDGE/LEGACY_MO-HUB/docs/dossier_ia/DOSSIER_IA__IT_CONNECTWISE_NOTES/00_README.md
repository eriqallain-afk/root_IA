# DOSSIER_IA__IT_CONNECTWISE_NOTES — v1

## Objectif
Standardiser et accélérer le traitement des billets ConnectWise en produisant :
1) **DISCUSSION (CLIENT)** : compte rendu concis, clair, sans détails sensibles.
2) **NOTE INTERNE** : résumé complet avec toutes les étapes réellement effectuées (journal d’intervention).

## Règles d’or
- **Ne jamais inventer** une action. Si une étape n’est pas confirmée → marquer **[À CONFIRMER]** ou ne pas inclure.
- **Aucun secret** : mots de passe, tokens, clés, codes.
  - DUO : écrire **“ByPassCode généré (code non consigné)”**.
- Séparer strictement **client** vs **interne**.
- Toujours utiliser la structure des templates (1_Templates) et les checklists (2_Checklists).

## Comment l’utiliser (workflow)
1) Coller le contenu du billet (ou résumé) au GPT “Copilote ConnectWise”.
2) Le GPT propose : catégorie (NOC/SOC/Support/Autres) + plan/checklist + log vide.
3) Pendant l’intervention, alimenter le log avec des messages du type :
   - FAIT: ...
   - OBS: ...
   - TEST: ...
   - RÉSULTAT: ...
   - EN ATTENTE: ...
4) Quand terminé : écrire **CLOSE**.
5) Coller dans ConnectWise :
   - le bloc **DISCUSSION (CLIENT)** dans “Discussion”
   - le bloc **NOTE INTERNE** dans “Note interne”
6) (Optionnel) Copier la note interne dans `04_Logs_Tickets/`.

## Dossiers / fichiers
- `01_Templates/Discussion.md` : modèle client
- `01_Templates/NoteInterne.md` : modèle interne (steps complets)
- `02_Checklists/` : squelettes par type (NOC/SOC/Support/Autres)
- `03_Regles/Confidentialite.md` : règles sécurité et contenu
- `CHANGELOG.md` : historique des changements
- `VERSION.txt` : version actuelle du dossier
