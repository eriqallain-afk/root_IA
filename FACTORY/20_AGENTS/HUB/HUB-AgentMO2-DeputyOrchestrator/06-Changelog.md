# 06 — Changelog — HUB-AgentMO2-DeputyOrchestrator

## Conventions de versioning

| Niveau | Type de changement | Exemple |
|--------|-------------------|---------|
| **MAJOR** (X.0.0) | Refonte du rôle, changement de périmètre, rupture de contrat | 1.0.0 → 2.0.0 |
| **MINOR** (x.Y.0) | Nouveau intent, nouveau champ output, nouvelle variante | 2.0.0 → 2.1.0 |
| **PATCH** (x.y.Z) | Correction bug, clarification texte, ajout guardrail | 2.0.0 → 2.0.1 |

---

## Historique

### v2.0.0 — 2026-03-13
**Type** : MAJOR — Mise à niveau schema 1.1.0 + enrichissement complet

**Changements** :
- `agent.yaml` : migré de schema `1.0` (`id`) vers `1.1.0` (`agent_id`)
- Ajout de `playbooks_as_actor`, `dependencies`, `guardrails`, `sla` dans `agent.yaml`
- Création des 6 fichiers de documentation manquants (01 à 06)
- Prompt enrichi : ajout Variante 4 (Backup MO) et Variante 5 (Audit sécurité)
- Seuil quality_score explicite : **9.0** pour validation, **7.0** en mode urgence P0
- Ajout champ `mode: BACKUP_ORCHESTRATION` dans la sortie backup

**Auteur** : EA4AI Factory  
**Raison** : Conformité schema v1.1.0 + gaps documentaires comblés

---

### v1.0.0 — 2026-03-06
**Type** : INITIAL — Création initiale

**Contenu** :
- `agent.yaml` schema 1.0 avec intents : `qa_plan`, `validate_plan`, `review_mo`, `backup_orchestrate`
- `contract.yaml` : interface I/O complète (routing_plan, partials, quality_indicators)
- `prompt.md` : workflow 6 étapes + format YAML strict + checklist qualité
- `README.md` : profil, périmètre, escalade
- `GPT-GENERATION-BRIEF.md` : brief pour génération de documentation
- `memory/memory_pack.yaml` + `memory/glossary.yaml` : placeholders
- `tests/sample_input.yaml` + `tests/expected_output.yaml`
- `tools/tools.md`

**Auteur** : EA4AI Factory  
**Raison** : Création initiale de l'agent Deputy Orchestrator
