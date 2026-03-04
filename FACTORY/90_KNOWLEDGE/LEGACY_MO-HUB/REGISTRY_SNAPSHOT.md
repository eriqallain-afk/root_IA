# REGISTRY SNAPSHOT — IA-factory (source-of-truth condensed)

> Objectif : fournir une “photo” lisible du système (control plane, indexes, policies clés).
> Usage : idéal pour Knowledge (1 fichier) ou pour audit rapide.
> Mise à jour : à chaque changement majeur des index/policies.

---

## 1) Control Plane (MO)
```yaml
control_plane:
  primary: AGENT-MO
  backup: AGENT-MO2

approvals:
  required_for_any_change:
    - TEAM-IAHQ
    - TEAM-META

routing:
  strategy: capability_map
  rule: "MO route vers l'orchestrateur de domaine (owner_orchestrator) via capability_map + teams_index."
