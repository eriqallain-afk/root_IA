# TEMPLATE — Playbook Universel (META Standard)

> **Usage** : Template standard pour créer tout nouveau playbook dans la Factory.  
> **Généré par** : `META-PlaybookBuilder`  
> **Convention de nommage** : `PB_<CATEGORY>_<NN>_<NOM_MAJUSCULES>.yaml`  
> **Categories** : `HUB` | `FAB` | `OPT` | `CTL` | `OPS` | `EXP`

---

## Fichier 1 — Playbook YAML (`30_PLAYBOOKS/PB_<CATEGORY>_<NN>_<NOM>.yaml`)

```yaml
id: PB_<CATEGORY>_<NN>_<NOM>
display_name: "<Nom lisible>"
version: "1.0.0"
category: <category>
team_owner: <TEAM_ID>
trigger: "<déclencheur | intent_id>"
sla_minutes: <int>
description: >
  <1-2 phrases : objectif et résultat attendu>

steps:
  - step: <step_name_verbe_objet>
    order: 1
    actor_id: <agent_id>
    description: "<ce que fait cet acteur dans ce step>"
    condition: null  # ou "expression booléenne si step conditionnel"
    input:
      from: user  # ou: step_<nom_step_precedent>
      fields:
        - <champ_requis_1>
        - <champ_requis_2>
    output:
      artifacts:
        - <nom_livrable_1>
      passes_to: <step_suivant ou final>
    success_criteria:
      - "<critère testable et vérifiable>"
    on_failure: retry_once  # retry_once | skip | abort | escalate
    escalation_target: null  # <agent_id si on_failure: escalate>

  # Dupliquer le bloc step pour chaque étape supplémentaire

escalation_policy:
  trigger: on_failure_abort
  target: HUB-AgentMO-MasterOrchestrator
  notification: "CTL-AlertRouter"

definition_of_done:
  - "Tous les steps critiques = status:success"
  - "Artefacts finaux produits et validés"
  - "Score qualité >= 9/10"
  - "Run archivé dans OPS-DossierIA"
  - "next_actions définis"

references:
  runbook: "40_RUNBOOKS/RUNBOOK__<PB_ID>.md"
  playbooks_index: "30_PLAYBOOKS/playbooks.yaml"
  agents_consulted:
    - <agent_id_1>
    - <agent_id_2>
  policies_applied:
    - "50_POLICIES/quality_rules.md"
    - "50_POLICIES/naming.md"
```

---

## Fichier 2 — Runbook Markdown (`40_RUNBOOKS/RUNBOOK__<PB_ID>.md`)

```markdown
# RUNBOOK — <PB_ID>

**Version** : 1.0.0  
**Équipe** : <TEAM_ID>  
**Playbook** : `30_PLAYBOOKS/<PB_ID>.yaml`  
**SLA** : <N> minutes  
**Mise à jour** : <YYYY-MM-DD>

---

## Objectif

<1-2 phrases claires sur ce que ce playbook accomplit et pour qui.>

---

## Prérequis

| Élément | Requis | Description |
|---------|--------|-------------|
| Agents actifs | ✅ Obligatoire | <liste des agent_ids> |
| <Fichier source> | ✅ Obligatoire | <description> |
| <Input utilisateur> | ✅ Obligatoire | <description> |
| <Contexte> | ⚪ Optionnel | <description> |

---

## Étapes détaillées

### Step 1 — <Nom> (`<actor_id>`)

**Durée estimée** : < X secondes/minutes

**Input** :
- `<champ>` : <description>

**Action** :
1. <action 1>
2. <action 2>

**Output attendu** :
```yaml
<exemple de sortie>
```

**Contrôle qualité** : <critère vérifiable>.

**Si échec** : <action en cas d'erreur>.

---
<!-- Répéter pour chaque step -->

---

## Definition of Done (DoD)

- [ ] <critère 1>
- [ ] <critère 2>
- [ ] Score qualité >= 9/10
- [ ] Run archivé dans OPS-DossierIA

---

## Cas d'erreur & Fallbacks

| Situation | Action |
|-----------|--------|
| <agent> indisponible | <action de fallback> |
| Input manquant | stop + demande clarification |
| Output non conforme | escalade <agent> |
| SLA dépassé | alerte CTL-AlertRouter |

---

## Métriques de performance

| Indicateur | Cible |
|-----------|-------|
| Taux de succès | ≥ <N>% |
| Durée médiane | < <N> min |

---

## Références

- Playbook : `30_PLAYBOOKS/<PB_ID>.yaml`
- Policies : `50_POLICIES/quality_rules.md`
```

---

## Fichier 3 — Entrée dans l'index (`30_PLAYBOOKS/playbooks.yaml` delta)

```yaml
<PB_ID>:
  display_name: "<Nom lisible>"
  category: <category>
  team_owner: <TEAM_ID>
  trigger: "<déclencheur>"
  duration_minutes: <int>
  steps_count: <int>
  version: "1.0.0"
  file: "30_PLAYBOOKS/<PB_ID>.yaml"
```

---

## Checklist de validation (avant merge)

- [ ] `id` unique — pas de doublon dans `playbooks.yaml`
- [ ] Tous les `actor_id` existent dans `00_INDEX/agents_index.yaml`
- [ ] Tous les steps ont au moins 1 `success_criteria`
- [ ] `on_failure` défini pour chaque step
- [ ] RUNBOOK créé et cohérent avec le playbook
- [ ] Entrée ajoutée dans `30_PLAYBOOKS/playbooks.yaml`
- [ ] `definition_of_done` complète et testable
- [ ] Playbook référencé dans `00_INDEX/playbooks_index.yaml`
