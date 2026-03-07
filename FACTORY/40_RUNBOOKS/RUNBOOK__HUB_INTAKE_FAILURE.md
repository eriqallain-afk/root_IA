# RUNBOOK — HUB : Échec d'intake et de qualification

**ID :** RB-HUB-001  
**Version** : 1.0.0  
**Trigger** : HUB-Concierge ou HUB-AgentMO échoue à qualifier / router une demande  
**Propriétaire** : HUB-AgentMO + OPS-RouterIA  
**SLA** : < 10 minutes  
**Mise à jour** : 2026-03-06  

---

## Objectif

Résoudre les situations où le pipeline d'intake HUB ne parvient pas à transformer une demande utilisateur en brief structuré routable.

---

## Types d'échec couverts

| Code | Description |
|------|-------------|
| `INTAKE_AMBIGUOUS` | Demande trop vague pour qualifier après 3 questions |
| `INTAKE_NO_ROUTE` | Intent détecté mais aucun agent/playbook correspondant |
| `INTAKE_LOOP` | Concierge ↔ RouterIA en boucle (> 3 passes) |
| `INTAKE_TIMEOUT` | Pas de réponse utilisateur dans le délai attendu |
| `INTAKE_DOMAIN_UNKNOWN` | Domaine hors périmètre connu de la FACTORY |

---

## SCÉNARIO 1 — Demande trop vague (`INTAKE_AMBIGUOUS`)

### Symptômes
- HUB-Concierge a posé 3 questions, toujours pas d'intent clair
- `confidence < 0.5` après clarifications
- Boucle de questions sans convergence

### Résolution
1. HUB-Concierge déclenche le fallback `HUB-CoachIA360-Strategie-GPTTeams`
2. CoachIA360 propose une liste structurée de domaines → utilisateur choisit
3. Si toujours bloqué → escalader à `IAHQ-OrchestreurEntrepriseIA` (session stratégique)

```yaml
fallback_chain:
  1: HUB-Concierge (3 questions max)
  2: HUB-CoachIA360 (choix guidé)
  3: IAHQ-OrchestreurEntrepriseIA (cadrage stratégique)
```

---

## SCÉNARIO 2 — Aucune route disponible (`INTAKE_NO_ROUTE`)

### Symptômes
- OPS-RouterIA retourne `no_route_for_intent: true`
- Intent identifié mais absent de `hub_routing.yaml`

### Résolution
1. OPS-RouterIA tente le fallback générique `HUB-AgentMO`
2. HUB-AgentMO évalue si l'intent mérite une nouvelle route → log dans `log.decisions`
3. Si nouveau domaine légitime → déclencher `PB_EXP_01_ONBOARD_NEW_TEAM.yaml`
4. Si hors périmètre → informer l'utilisateur avec explication claire

---

## SCÉNARIO 3 — Boucle Concierge ↔ RouterIA (`INTAKE_LOOP`)

### Symptômes
- Même requête passée > 3 fois entre HUB-Concierge et OPS-RouterIA
- `execution_log` montre cycle

### Résolution
1. OPS-PlaybookRunner détecte le cycle (compteur `hop_count > 3`)
2. Déclenche circuit-breaker → route forcée vers `HUB-AgentMO`
3. HUB-AgentMO prend en charge manuellement
4. Corriger `hub_routing.yaml` si route circulaire confirmée

---

## SCÉNARIO 4 — Domaine inconnu (`INTAKE_DOMAIN_UNKNOWN`)

### Symptômes
- Intent = domaine inexistant dans la FACTORY
- Ex: demande HR, juridique, comptable sans équipe dédiée

### Résolution
1. HUB-Concierge informe l'utilisateur : domaine non couvert actuellement
2. Proposer les domaines disponibles
3. Logger la demande dans `OPS-DossierIA` comme `opportunity_log`
4. CTL-WatchdogIA génère `new_domain_request` si > 3 demandes similaires en 7 jours

---

## Checklist post-incident

- [ ] Cause documentée dans `log.decisions` de HUB-AgentMO
- [ ] Demande archivée dans OPS-DossierIA
- [ ] `hub_routing.yaml` mis à jour si route manquante
- [ ] Rapport à CTL-HealthReporter si incident récurrent

---

## Références

- `40_ROUTING/hub_routing.yaml` — table de routage
- `RUNBOOK__INCIDENT_REGISTRY.md` — incidents registry
- `RUNBOOK__OPS_ROUTER_FAILURE.md` — RouterIA en panne
- `PB_HUB_01_ORCHESTRATE_AND_DISPATCH.yaml` — playbook principal HUB
