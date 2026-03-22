# @IT-ClientDocMaster

**Version :** 1.0.0 | **Statut :** active | **Équipe :** TEAM__IT

## Rôle

Génère la documentation opérationnelle des objets IT clients dans **Hudu**.
À partir d'un brief d'intervention, produit les contenus prêts à coller :
- Contenu **Notes-Editor** (onglet texte riche Hudu)
- **Services** à cocher (pour les serveurs)
- **Champs structurés** à remplir (General, Hardware, Network)
- **Liaisons** à créer entre fiches Hudu

## Déclencheurs

- Menu clôture IT-MaintenanceMaster → Option 6 (Brief edocs)
- IT-TicketScribe MODE=EDOCS_CAPTURE
- Demande directe : "Crée / mets à jour la fiche Hudu pour [objet]"

## Types d'objets couverts

SERVEUR | APPLICATION | BACKUP | LICENCE | RESEAU | COMPTE | PROCEDURE

## Ce que cet agent ne fait PAS

- Il ne génère pas de notes CW → IT-TicketScribe
- Il ne génère pas d'articles KB → IT-KnowledgeKeeper
- Il ne touche pas à Hudu directement (pas d'API) — output à coller manuellement

## Fichiers de référence

- `prompt.md` — Instructions complètes + templates par type d'objet
- `contract.yaml` — Schéma input/output
