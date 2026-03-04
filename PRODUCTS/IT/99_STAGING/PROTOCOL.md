# Protocole FACTORY → @IT (Staging & Validation)

## Flux complet

```
FACTORY crée l'agent
        ↓
Dépose dans 99_STAGING/INCOMING/<AgentID>/
        ↓
EA valide manuellement (checklist ci-dessous)
        ↓
    ┌───┴───┐
  ✅ OK    ❌ Refus
    ↓         ↓
VALIDATED/  REJECTED/
    ↓
EA copie dans agents/<AgentID>/
EA met à jour agents.yaml + agents_index.yaml
EA met à jour hub_routing.yaml si nouveaux intents
EA met à jour FACTORY_MANIFEST.yaml (agents + intents_covered)
```

---

## Ce que la FACTORY DOIT faire avant de créer

1. **Lire** `FACTORY_MANIFEST.yaml` (source de vérité IT)
2. **Vérifier** que l'agent n'existe pas déjà dans `agents[]`
3. **Vérifier** que les intents ne sont pas dans `intents_covered[]`
4. **Consulter** `intents_gaps[]` pour les vrais besoins
5. **Déposer** le package complet dans `99_STAGING/INCOMING/<AgentID>/`

---

## Package requis par la FACTORY (format livraison)

```
99_STAGING/INCOMING/<AgentID>/
├── agent.yaml          ← Obligatoire
├── prompt.md           ← Obligatoire
├── contract.yaml       ← Obligatoire
├── README.md           ← Obligatoire
├── tests.yaml          ← Obligatoire (min 3 tests)
├── STAGING_CARD.yaml   ← Obligatoire (voir format ci-dessous)
└── 02_TEMPLATES/       ← Si applicable
```

## Format STAGING_CARD.yaml

```yaml
schema_version: '1.0'
agent_id: <ID>
created_by: META-AgentProductFactory
created_at: <ISO8601>
purpose: <Pourquoi cet agent, quel gap il comble>
intents_new:
  - <intent non couvert>
playbook_integration:
  - playbook_id: <ID>
    step: <nom>
    order: <position>
knowledge_pack_required: false   # ou true + path
conflicts_checked: true
manifest_version_read: '3.0'
status: staging
```

---

## Checklist de validation EA (avant activation)

### Vérifications de base
- [ ] `agent_id` unique (absent de `agents.yaml`)
- [ ] `team_id` = `TEAM__IT` (jamais TEAM__OPS)
- [ ] Intents nouveaux et non redondants
- [ ] Pas de doublon fonctionnel avec un agent existant

### Qualité du package
- [ ] `prompt.md` : rôle clair, règles machines, format de sortie défini
- [ ] `contract.yaml` : inputs/outputs spécifiques (pas génériques)
- [ ] `tests.yaml` : min 3 tests dont 1 "format breaker"
- [ ] `README.md` présent et lisible

### Intégration
- [ ] `STAGING_CARD.yaml` remplie et cohérente
- [ ] Si playbook_integration : les étapes proposées sont logiques
- [ ] Pas de référence FACTORY/HUB dans les outputs produits
- [ ] `forbidden_actors` présent dans contract si agent peut router

### Score minimum : 8/10 sur clarity + precision + testability

---

## Actions post-validation EA

```
SI VALIDÉ :
  1. Copier agents/<AgentID>/ depuis 99_STAGING/INCOMING/<AgentID>/
  2. Ajouter dans 00_INDEX/agents.yaml
  3. Ajouter dans 00_INDEX/agents_index.yaml (avec intents)
  4. Si nouveaux intents : mettre à jour 80_MACHINES/hub_routing.yaml
  5. Mettre à jour FACTORY_MANIFEST.yaml :
     - Ajouter dans agents[]
     - Ajouter intents dans intents_covered[]
     - Retirer de intents_gaps[] si applicable
  6. Déplacer vers 99_STAGING/VALIDATED/<AgentID>/
  7. Indiquer status: active dans agent.yaml

SI REJETÉ :
  1. Documenter la raison dans STAGING_CARD.yaml (champ rejection_reason)
  2. Déplacer vers 99_STAGING/REJECTED/<AgentID>/
  3. La FACTORY peut corriger et re-soumettre
```
