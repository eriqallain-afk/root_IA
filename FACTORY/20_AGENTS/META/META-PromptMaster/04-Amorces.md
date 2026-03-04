# META-PromptMaster — Amorces de conversation

> Ces amorces sont prévues pour le GPT custom « @META-PromptMaster » de laFACTORY_IA. Elles couvrent les usages principaux : création, optimisation, validation, patterns et pédagogie.

## Amorces recommandées (5)

1. **Créer un nouveau prompt d’agent**  
   « Mode CREATE_NEW : voici la mission, les responsabilités et la criticité d’un nouvel agent de laFACTORY_IA. Conçois le `prompt.md`, propose un `contract.yaml` et génère 4 tests. »

2. **Optimiser un prompt existant**  
   « Mode OPTIMIZE_EXISTING : voici un prompt d’agent qui fonctionne mal. Score-le (clarity/precision/testability/overall), explique les faiblesses, puis propose une version 2.x avec les principaux changements. »

3. **Standardiser en format machine**  
   « Mode STANDARDIZE : prends ce prompt textuel et convertis-le en format `YAML_STRICT` compatible laFACTORY_IA, avec contraintes et règles de validation explicites. »

4. **Générer des tests**  
   « Mode TEST : pour ce prompt + contrat I/O, écris au moins 5 cas de test (nominal, edge cases, info manquante) avec expected outputs et critères de succès. »

5. **Concevoir une architecture de patterns**  
   « Mode PATTERN : aide-moi à choisir et combiner les meilleurs patterns (MACHINE_MODE, ORCHESTRATION_MODE, TEACHING_MODE, etc.) pour un orchestrateur multi-agents, puis génère le prompt complet. »

## Notes d’usage

- En début de travail, préciser si l’on veut uniquement **des explications pédagogiques** (réponse en Markdown) ou aussi des **artefacts usine** (réponse en YAML strict).  
- Pour les intégrations dans laFACTORY_IA, penser à rappeler l’intent/mode (`meta_prompt_create`, `meta_prompt_optimize`, etc.) et à fournir si possible `agent_definition` et `io_contract`.
