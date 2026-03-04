# RUNBOOK — @IAHQ-QualityGate (TEAM__IAHQ)
Porte de qualité de la Factory : vérifie conformité d’une soumission (agent package / deliverable pack / prompt / contract), mesure risques, propose correctifs + escalades.   
## 0) Scope
    **Entrées** : paquet de fichiers + métadonnées de cible (`target_kind`, `target_id`).
    **Sorties** : YAML conforme au contrat avec `verdict`, `overall_score`, `findings` traçables, `recommendations`, `escalations`, `log`.

    Cibles supportées :
    - `agent_package` : `agent.yaml`, `contract.yaml`, `prompt.md`, `README.md`, `tests.yaml` (+ assets optionnels)
    - `deliverable_pack` : runbook + checklists + templates + examples + spec
    - `mixed` : audit prompt↔contract (au minimum `contract.yaml` + `prompt.md`)

    ## 1) Quality Gates (ordre obligatoire)
    ### QG0 — Intake & normalisation
    - Indexer tous les fichiers (path, type_hint, taille, contenu)
    - Déduire la cible réelle si `target_kind` incohérent (loguer l’inférence)

    **Fail fast** si : aucune liste de fichiers, ou `target_id` manquant.

    ### QG1 — Validité syntaxique & parse
    - YAML: parse strict (fail si invalide pour un fichier “clé”)
    - MD: présence minimale (titre, sections), pas de placeholders critiques

    Fichiers clés (bloquants selon kind) :
    - `agent_package` : `agent.yaml`, `contract.yaml`, `prompt.md`
    - `mixed` : `contract.yaml`, `prompt.md`
    - `deliverable_pack` : runbook, ≥1 checklist, ≥1 template, ≥1 example, spec

    ### QG2 — Complétude artefacts (structure dépôt)
    - Vérifier chemins attendus + cohérence (team_id, agent_id, refs)
    - Vérifier existence `tests.yaml` pour agent_package (peut être vide mais doit exister)

    ### QG3 — Alignement prompt ↔ contract (testabilité)
    - Le prompt **verrouille** explicitement :
      - format de sortie (YAML)
      - champs requis du `output.required`
      - interdictions (pas JSON si YAML attendu)
      - exemples conformes au schéma
    - Le contrat :
      - `input.required` et `output.required` définis
      - types cohérents (pas d’ambiguïtés triviales)

    **Conditional** si : le prompt mentionne “score/avis” sans imposer les champs requis.

    ### QG4 — Scoring & risques
    Score = 0..100, calculé par sections (pondération recommandée) :
    - Syntaxe & parse : 25
    - Complétude artefacts : 25
    - Alignement prompt↔contract : 30
    - Testabilité & exemples : 10
    - Gouvernance & traçabilité : 10

    Sévérités findings :
    - `critical` : YAML invalide sur fichier clé; contract manquant; incohérence majeure prompt↔contract
    - `high` : prompt n’impose pas format/required; artefact clé manquant non-bloquant (selon kind)
    - `medium/low` : best practices, docs faibles, tests insuffisants

    ## 2) Politique de décision (canon)
    - **PASS** : score ≥ 85, aucun `high/critical`, artefacts requis présents
    - **CONDITIONAL** : score 70–84, ou corrections nécessaires mais non bloquantes
    - **FAIL** : score < 70, YAML invalide, artefacts bloquants manquants, ou incohérence majeure prompt↔contract

    ## 3) Escalations (matrice)
    Déclencheurs :
    - `critical` (toujours) → escalade
    - `high` répété / systémique → escalade

    Cibles (exemples) :
    - `META-AgentFactory` : intégration agent, conventions, routage
    - `HUB-AgentMO2-DeputyOrchestrator` : cohérence tests/runbooks et recette
    - `OPS-PlaybookRunner` : incidents d’exécution/outillage

    ## 4) Format des findings (traçable)
    Chaque finding DOIT contenir :
    - `id` (stable)
    - `severity`
    - `title`
    - `evidence` :
      - `file_path`
      - `snippet` (court)
      - `reasoning` (1–2 lignes)
    - `impact`
    - `fix` (action concrète)
    - `owner_suggestion` (team/role)

    ## 5) Gestion d’erreurs & rollback
    - Parse YAML échoue (fichier clé) :
      - verdict=fail
      - escalation=META-AgentFactory
      - recommendation: corriger syntaxe + ajouter test T4-like
    - Artefact bloquant manquant :
      - verdict=fail
      - recommendation: ajouter fichier + template
    - Erreur non déterministe / contenu tronqué :
      - verdict=conditional
      - log.unknowns + next_actions: re-fournir fichiers complets

    Rollback (si intégré dans pipeline CI) :
    - Bloquer merge / publication
    - Conserver rapport + artefacts d’entrée dans dossier d’archive (OPS-DossierIA)

    ## 6) Output template (minimum)
    ```yaml
    verdict: "pass|conditional|fail"
    overall_score: 0
    findings: []
    recommendations: []
    escalations: []
    log:
      decisions: []
      risks: []
      assumptions: []
      unknowns: []
      inputs_digest: {}
    ```

    ## 7) Checklist opératoire (copy/paste)
    - [ ] QG0 intake OK (target_kind/id + inventaire)
    - [ ] QG1 parse OK (ou fail fast)
    - [ ] QG2 artefacts requis présents
    - [ ] QG3 prompt↔contract alignés (output.required verrouillés)
    - [ ] QG4 score calculé + sévérités cohérentes
    - [ ] Verdict conforme à la politique
    - [ ] Escalations si high/critical
    - [ ] Rapport traçable (evidences par fichier)