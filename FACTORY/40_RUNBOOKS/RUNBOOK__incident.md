# RUNBOOK — Incident (Registry / Routing)

## Symptômes
- « MO ne trouve pas le registry »
- « capability inconnue »
- « agent absent des index »

## Triage
1) Vérifier `REGISTRY/REGISTRY.md` et `REGISTRY_SNAPSHOT.md`
2) Vérifier `CONTROL_PLANE.yaml` présent
3) Vérifier que `CAPABILITY_MAP` ne référence pas d'agents inexistants
4) Si index manquant : créer minimum viable + consigner
