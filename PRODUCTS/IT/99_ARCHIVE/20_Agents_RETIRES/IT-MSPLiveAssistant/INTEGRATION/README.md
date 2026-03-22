# Intégration Mémoire — @EDU-Reflexions_CCQ

## Objectif
Rendre la cohérence de correction stable au fil du temps via des fichiers mémoire versionnés, même sans mémoire plateforme.

## Où placer
Dans root_IA :
- `20_AGENTS/EDU/EDU-Reflexions_CCQ/10_MEMORY/` (copier le dossier 10_MEMORY)
- Optionnel : `20_AGENTS/EDU/EDU-Reflexions_CCQ/contract.yaml` (mettre à jour le contrat)

## Mise à jour au fil du temps
1) L'agent produit un YAML de correction pouvant inclure `memory_patch`.
2) Sauvegarder ce YAML dans un fichier (ex: `last_result.yaml`)
3) Appliquer :
   python apply_memory_patch.py --memory-dir 20_AGENTS/EDU/EDU-Reflexions_CCQ/10_MEMORY --result-yaml last_result.yaml

## Sécurité
Le patch ne doit jamais contenir de données identifiantes ou du texte de copie.
