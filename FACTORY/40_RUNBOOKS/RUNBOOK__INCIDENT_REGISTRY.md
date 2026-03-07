# RUNBOOK — Incidents Registry & Routing

**ID :** RB-FACTORY-005  
**Version** : 2.0.0  
**Remplace** : RUNBOOK__incident.md (stub 12 lignes)  
**Propriétaire** : HUB-AgentMO + OPS-RouterIA + CTL-WatchdogIA  
**SLA** : < 5 minutes (P0/P1) | < 30 minutes (P2) | < 2h (P3)  
**Mise à jour** : 2026-03-06  

---

## Objectif

Procédure de triage et résolution pour tous les incidents liés au **registry**, au **routage** et aux **indexes** de la FACTORY root_IA.

---

## Classification des incidents

| Niveau | Description | Exemples | SLA |
|--------|-------------|----------|-----|
| P0 | FACTORY DOWN — aucun routage possible | `agents_index.yaml` corrompu, OPS-RouterIA down | 5 min |
| P1 | Équipe entière inaccessible | Tous les agents d'une équipe unreachable | 15 min |
| P2 | Agent critique inaccessible | MO, RouterIA, ou PlaybookRunner down | 30 min |
| P3 | Incident mineur — routage dégradé | Intent mal routé, fallback déclenché | 2h |

---

## INCIDENT TYPE 1 — "MO ne trouve pas le registry"

### Symptômes
- HUB-AgentMO retourne : `error: registry_not_found`
- `REGISTRY.md` ou `agents_index.yaml` absent
- MO ne peut pas résoudre un `agent_id`

### Triage (2 min)
1. Vérifier existence de `00_INDEX/agents_index.yaml`
2. Vérifier `00_INDEX/agents.yaml` et `00_ROOT/registry.yaml`
3. Vérifier `00_CONTROL_PLANE/CONTROL_PLANE.yaml`

### Résolution
```
Si agents_index.yaml absent ou vide :
  → Restaurer depuis 90_KNOWLEDGE/BACKUPS_ROUTING/ (dernier backup)
  → OU lancer : python 99_VALIDATION/rebuild_indexes.py

Si agents_index.yaml présent mais MO ne le lit pas :
  → Vérifier encoding (UTF-8 sans BOM)
  → Lancer : Fix-01-CRLF.ps1 (99_VALIDATION/)
```

---

## INCIDENT TYPE 2 — "capability inconnue"

### Symptômes
- RouterIA retourne : `error: no_route_for_intent`
- `capability_map.yaml` ne contient pas la capability demandée
- Fallback vers HUB-Concierge en boucle

### Triage (3 min)
1. Identifier l'intent exact (`intent_detected` dans le log RouterIA)
2. Chercher dans `00_INDEX/intents.yaml` → existe ?
3. Chercher dans `40_ROUTING/hub_routing.yaml` → route mappée ?
4. Vérifier l'agent cible dans `agents_index.yaml` → status = active ?

### Résolution
```
Si intent absent de intents.yaml :
  → Ajouter l'intent dans 00_INDEX/intents.yaml
  → Ajouter la route dans 40_ROUTING/hub_routing.yaml
  → Mettre à jour 00_INDEX/capability_map.yaml

Si intent présent mais agent cible absent :
  → Voir RUNBOOK__ADD_AGENT.md
  → OU RUNBOOK_AGENT_FAILURE.md (CTL)
```

---

## INCIDENT TYPE 3 — "agent absent des index"

### Symptômes
- Agent physiquement présent dans `20_AGENTS/` mais non routable
- WatchdogIA rapport : `agent_found_not_indexed`
- PlaybookRunner échoue sur `actor_id` non résolu

### Triage (2 min)
1. Confirmer présence physique dans `20_AGENTS/<TEAM>/<AGENT_ID>/`
2. Chercher dans `00_INDEX/agents_index.yaml`
3. Chercher dans `00_INDEX/agents_manifest.yaml`

### Résolution
```
Agent physique présent, absent de l'index :
  → Ajouter manuellement dans agents_index.yaml :
    <AGENT_ID>:
      team: TEAM__<CODE>
      role: <role>
      status: active
      capabilities: [...]
  
  → OU lancer : python 99_VALIDATION/rebuild_indexes.py (rebuild complet)

Agent absent physiquement ET de l'index :
  → Incident CREATE_AGENT → voir RUNBOOK__ADD_AGENT.md
  → OU statut "archived" → vérifier 90_KNOWLEDGE/ARCHIVE/
```

---

## INCIDENT TYPE 4 — "routing loop / boucle infinie"

### Symptômes
- Même agent appelé > 3 fois dans un run
- `execution_log` OPS-PlaybookRunner montre cycles
- Timeout playbook

### Triage (5 min)
1. Inspecter `40_ROUTING/hub_routing.yaml` — routes circulaires ?
2. Vérifier `80_MACHINES/` — machine flow avec boucle ?
3. Inspecter `log.decisions` de l'orchestrateur incriminé

### Résolution
```
Boucle détectée dans hub_routing.yaml :
  → Corriger avec Fix-02-Routing.ps1 (99_VALIDATION/)
  → Supprimer la route circulaire
  → Ajouter règle anti-loop : max_hops: 5

Boucle dans machine flow :
  → Éditer 80_MACHINES/<machine>.yaml
  → Ajouter condition de sortie explicite
  → Tester avec validate_machine_output.py
```

---

## INCIDENT TYPE 5 — "schema_version manquant / validation échoue"

### Symptômes
- `validate_integrity.py` signale agents sans `schema_version`
- `playbooks_index.yaml` incohérent avec fichiers réels
- CTL-WatchdogIA en alerte `schema_drift`

### Résolution
```
→ Lancer : python 99_VALIDATION/Fix-03-SchemaVersion.ps1
  (ajoute schema_version: "1.0" à tous les fichiers manquants)
  
→ Rebuild complet : python 99_VALIDATION/rebuild_indexes.py

→ Vérification : python 99_VALIDATION/validate_integrity.py
```

---

## PROCÉDURE D'ESCALADE

```
P3 → OPS-RouterIA (auto-correction si possible)
         │
P2 → HUB-AgentMO (coordination manuelle)
         │
P1 → IAHQ-TechLeadIA (architecture) + META-GouvernanceQA (audit)
         │
P0 → RUNBOOK_FACTORY_DOWN.md (CTL-WatchdogIA + IAHQ-OrchestreurEntrepriseIA)
```

---

## Checklist post-résolution

- [ ] Incident documenté dans `60_CHANGELOG/CHANGELOG.md`
- [ ] Cause racine identifiée (voir PB_CTL_03_POST_MORTEM_ANALYSIS.yaml si P0/P1)
- [ ] Validation `run_golden_tests.py` passée
- [ ] CTL-HealthReporter rapport généré
- [ ] Action préventive ajoutée au backlog

---

## Références

- `RUNBOOK_FACTORY_DOWN.md` (CTL) — panne totale
- `RUNBOOK_AGENT_FAILURE.md` (CTL) — échec agent spécifique
- `RUNBOOK__OPS_ROUTER_FAILURE.md` — RouterIA en panne
- `99_VALIDATION/` — scripts de validation et correction
- `90_KNOWLEDGE/BACKUPS_ROUTING/` — backups hub_routing.yaml
