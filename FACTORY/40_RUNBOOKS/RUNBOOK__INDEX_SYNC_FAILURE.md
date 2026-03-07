# RUNBOOK — FACTORY : Désynchronisation des Indexes

**ID :** RB-FACTORY-007  
**Version** : 1.0.0  
**Trigger** : 00_INDEX désynchronisé avec 20_AGENTS — agents fantômes, routes cassées, intents orphelins  
**Propriétaire** : HUB-AgentMO + META-GouvernanceQA + CTL-WatchdogIA  
**SLA** : < 20 minutes  
**Mise à jour** : 2026-03-06  

---

## Objectif

Resynchroniser les indexes `00_INDEX/` avec l'état réel de `20_AGENTS/` lorsqu'une divergence est détectée — sans perte de données et sans créer de nouveaux fantômes.

---

## Indexes concernés

| Fichier | Rôle | Impact si désynchronisé |
|---------|------|------------------------|
| `agents_index.yaml` | Liste tous les agents actifs | Routage cassé, PlaybookRunner échoue |
| `agents_manifest.yaml` | Manifeste complet avec fichiers | Validation impossible |
| `intents.yaml` | Intents enregistrés | RouterIA retourne NO_ROUTE |
| `playbooks_index.yaml` | Playbooks disponibles | Runner ne trouve pas le playbook |
| `capability_map.yaml` | Capabilities → agents | CoachIA360 donne mauvaises recommandations |
| `teams_index.yaml` | Équipes actives | WatchdogIA ne scanne pas les nouvelles équipes |

---

## Détection automatique

CTL-WatchdogIA peut détecter :
- Agent dans `20_AGENTS/` absent de `agents_index.yaml` → `agent_not_indexed`
- Agent dans `agents_index.yaml` absent de `20_AGENTS/` → `ghost_agent`
- Intent dans `intents.yaml` sans route dans `hub_routing.yaml` → `orphan_intent`
- Playbook dans `playbooks_index.yaml` sans fichier physique → `playbook_missing`

---

## PROCÉDURE — Rebuild complet des indexes

### Option A — Script automatique (recommandé)

```bash
# Windows
cd FACTORY\99_VALIDATION
python rebuild_indexes.py

# OU via PowerShell
.\rebuild_indexes.ps1
```

Ce script :
1. Scanne `20_AGENTS/` → rebuilde `agents_index.yaml` et `agents_manifest.yaml`
2. Vérifie `30_PLAYBOOKS/` → rebuilde `playbooks_index.yaml`
3. Valide `40_ROUTING/hub_routing.yaml` → liste les routes orphelines
4. Produit un rapport de diff avant/après

### Option B — Correction manuelle (si script indisponible)

**Étape 1 — Identifier les divergences**
```
Pour chaque dossier dans 20_AGENTS/<TEAM>/<AGENT>/ :
  → Vérifier présence dans agents_index.yaml
  → Si absent : AJOUTER

Pour chaque entrée dans agents_index.yaml :
  → Vérifier existence dossier 20_AGENTS/<TEAM>/<AGENT>/
  → Si absent : SUPPRIMER ou marquer status: archived
```

**Étape 2 — Corriger agents_index.yaml**
```yaml
# Format standard entrée
<AGENT_ID>:
  team: TEAM__<CODE>
  role: <orchestrator|specialist|concierge>
  status: active
  version: "1.x.x"
  capabilities: ["<cap1>", "<cap2>"]
  file: 20_AGENTS/<TEAM>/<AGENT_ID>/agent.yaml
```

**Étape 3 — Corriger hub_routing.yaml**
```
Pour chaque route dans hub_routing.yaml :
  → Vérifier que target (agent_id) existe dans agents_index.yaml
  → Supprimer les routes pointant vers agents fantômes
```

**Étape 4 — Valider**
```bash
python 99_VALIDATION/validate_integrity.py
python 99_VALIDATION/validate_refs.py
```

---

## Agents fantômes — traitement

Un agent fantôme = cité dans un index mais sans existence physique.

```
Traitement par cas :
1. Fantôme récent (< 7 jours) → probablement en cours de création → attendre
2. Fantôme ancien (> 7 jours) → vérifier 90_KNOWLEDGE/ARCHIVE/
   → Si trouvé archivé → décider : restaurer ou supprimer de l'index
   → Si introuvable → supprimer de l'index + noter dans CHANGELOG
3. Fantôme référencé dans playbook actif → BLOCKER — créer l'agent manquant
```

---

## Prévention

Règles à appliquer après chaque modification d'agents :
- Toute création d'agent → immédiatement dans `agents_index.yaml`
- Tout retrait d'agent → marquer `status: archived` avant suppression physique
- Toute nouvelle équipe → `teams_index.yaml` mis à jour le jour même
- Rebuild indexes recommandé : hebdomadaire (via `PB_CTL_01_FACTORY_HEALTH_CHECK.yaml`)

---

## Références

- `99_VALIDATION/rebuild_indexes.py` — script de rebuild
- `99_VALIDATION/validate_integrity.py` — validation complète
- `00_INDEX/agents_index.yaml` — index principal
- `RUNBOOK__INCIDENT_REGISTRY.md` — incidents registry généraux
- `PB_CTL_01_FACTORY_HEALTH_CHECK.yaml` — health check hebdomadaire
