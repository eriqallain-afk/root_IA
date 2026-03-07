# RUNBOOK — OPS : Panne OPS-RouterIA

**ID :** RB-OPS-001  
**Version** : 1.0.0  
**Trigger** : OPS-RouterIA ne trouve pas de route valide ou retourne une erreur  
**Propriétaire** : OPS-RouterIA + HUB-AgentMO + CTL-WatchdogIA  
**SLA** : < 5 minutes (P1) | < 15 minutes (P2)  
**Mise à jour** : 2026-03-06  

---

## Objectif

Rétablir le routage dans la FACTORY lorsque OPS-RouterIA est en échec ou produit des routes incorrectes.

---

## Codes d'erreur connus

| Code | Description | Sévérité |
|------|-------------|----------|
| `NO_ROUTE_FOUND` | Aucune route pour l'intent détecté | P2 |
| `CONFIDENCE_BELOW_THRESHOLD` | Route trouvée mais confiance < seuil | P2 |
| `AGENT_UNREACHABLE` | Route trouvée, agent cible down | P1 |
| `INDEX_STALE` | `agents_index.yaml` outdated | P2 |
| `ROUTING_LOOP` | Même intent routé > 3 fois | P1 |
| `ROUTER_DOWN` | OPS-RouterIA lui-même ne répond pas | P0 → Factory Down |

---

## SCÉNARIO 1 — NO_ROUTE_FOUND

### Résolution
1. Inspecter `40_ROUTING/hub_routing.yaml` pour l'intent déclaré
2. Vérifier `00_INDEX/intents.yaml` — intent registré ?
3. Si route manquante → ajouter dans `hub_routing.yaml` :
```yaml
routes:
  - intent: "<intent_manquant>"
    target: "<AGENT_ID>"
    team: "TEAM__<CODE>"
    confidence_threshold: 0.7
    fallback: HUB-AgentMO
```
4. Relancer la requête

---

## SCÉNARIO 2 — CONFIDENCE_BELOW_THRESHOLD

### Résolution
1. Vérifier le `confidence_threshold` dans `hub_routing.yaml` pour cette route
2. Baisser temporairement le seuil si l'agent cible est correct (min: 0.5)
3. OU enrichir les patterns de détection d'intent pour cette route
4. Escalader vers `HUB-AgentMO` pour routage manuel si toujours < seuil

---

## SCÉNARIO 3 — AGENT_UNREACHABLE

### Résolution
1. Vérifier que l'agent cible est `status: active` dans `agents_index.yaml`
2. Vérifier que le dossier `20_AGENTS/<TEAM>/<AGENT>` existe et est complet
3. Si agent down → utiliser le `fallback` de la route
4. Déclencher `RUNBOOK_AGENT_FAILURE.md` (CTL) pour l'agent cible
5. Notifier CTL-AlertRouter

---

## SCÉNARIO 4 — ROUTING_LOOP

### Résolution
1. OPS-PlaybookRunner doit détecter et couper le cycle (circuit breaker à hop_count: 5)
2. Inspecter `hub_routing.yaml` pour route circulaire
3. Corriger avec `99_VALIDATION/Fix-02-Routing.ps1`
4. Tester avec `validate_refs.py`

---

## SCÉNARIO 5 — ROUTER_DOWN (P0)

### Résolution
→ Voir `RUNBOOK_FACTORY_DOWN.md` (CTL)

Étapes immédiates :
1. Vérifier que `OPS-RouterIA/prompt.md` et `agent.yaml` sont intacts
2. Vérifier que `hub_routing.yaml` est valide YAML (pas corrompu)
3. Restaurer depuis `90_KNOWLEDGE/BACKUPS_ROUTING/` si nécessaire
4. HUB-AgentMO prend le relais de routage manuel pendant la recovery

---

## Mode dégradé (fallback manuel)

Si RouterIA est inopérant :
1. HUB-AgentMO active le mode `manual_routing`
2. Chaque requête est routée manuellement par l'orchestrateur
3. Logger toutes décisions dans `log.decisions`
4. Durée max mode dégradé : 30 minutes avant escalade P0

---

## Références

- `40_ROUTING/hub_routing.yaml` — table de routage
- `00_INDEX/agents_index.yaml` — index des agents
- `99_VALIDATION/Fix-02-Routing.ps1` — fix automatique routing
- `90_KNOWLEDGE/BACKUPS_ROUTING/` — backups routage
- `RUNBOOK_FACTORY_DOWN.md` (CTL) — panne totale
