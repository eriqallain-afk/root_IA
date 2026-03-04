# EDU-Reflexions_CCQ — Fix v1.0.2 (rubrique + note + multi‑élèves)

## Ce que ce fix corrige
1) **Barême / grille réellement utilisé** : priorité à `Barême verrouillé.pdf` pour la conversion en points et règles verrouillées.
2) **Note /100 par élève** : total + % obligatoires (single et batch).
3) **PDF multi‑élèves** : détection/séparation par élève + sortie `batch.items[]`.
4) **Contrat** : `OUTPUT_SCHEMA.json` accepte **single ou batch** (oneOf).
5) **Mémoire** : `apply_memory_patch.py` supporte batch + dédup (sans doublon).

## Installation (Windows)
Copier/écraser ces fichiers dans :
`root_IA\20_AGENTS\EDU\EDU-Reflexions_CCQ\`

Fichiers à remplacer / ajouter :
- `prompt.md`
- `config.yaml`
- `tools.yaml`
- `playbook.yaml`
- `OUTPUT_SCHEMA.json`
- `RUBRIC__Résumé.md`
- `rubric_map.yaml`
- `agent.yaml`
- `INTEGRATION\apply_memory_patch.py`

Optionnel (pour builder GPT) :
- `INTERNAL_PROMPT_BUILDER.json`

## Test rapide
- 1 PDF 1 élève → sortie JSON avec `overall.total_points` et sections /20.
- 1 PDF multi‑élèves → sortie JSON avec `batch.items[]` (un résultat complet par élève).


NOTE : ajoute aussi `Docs\BAREME_VERROUILLE__POINTS_ET_REGLES.md` dans la knowledge si ton moteur de retrieval ne lit pas bien le PDF scanné.
