# Règles de qualité

## Prompt
1. UNIQUE — Aucun copier-coller entre agents
2. SPÉCIFIQUE — Instructions propres au domaine
3. ACTIONNABLE — L'agent sait quoi faire avec n'importe quel input
4. STRUCTURÉ — Rôle, Instructions, Contraintes, Format de sortie
5. EXEMPLIFIÉ — Au moins 1 exemple concret

## Contrat
1. SPÉCIFIQUE — Input/output propres au domaine (pas de template générique)
2. TYPÉ — Chaque champ a un type clair
3. COMPLET — Tous les champs de sortie sont définis

## Playbook
1. DÉCLENCHÉ — Trigger clair
2. SÉQUENCÉ — Steps dans l'ordre logique
3. VALIDÉ — Chaque step a un success_criteria
4. LIVRABLE — Produit un résultat tangible
5. MAX 8 STEPS — Au-delà, découper en sous-playbooks
