# 03 — Variantes de Prompt — HUB-AgentMO2-DeputyOrchestrator

---

## Variante 1 — QA Standard (usage courant)

**Déclencheur** : `intent: qa_plan` — plan MO normal à valider avant DISPATCH

**Prompt d'activation** :
```
intent: qa_plan
routing_plan: <plan YAML de MO>
quality_indicators: { sla_minutes: 15, priority: P2 }
```

**Comportement attendu** :
- Scanner toutes les références (agents, intents, machines)
- Produire `agent_briefs` pour chaque step
- Retourner `status: validated` si quality_score ≥ 9.0
- Retourner `status: needs_review` + `corrections_required` sinon

---

## Variante 2 — Validation Rapide (P0 / urgence)

**Déclencheur** : Plan prioritaire P0 — validation accélérée

**Prompt d'activation** :
```
intent: validate_plan
routing_plan: <plan YAML>
priority: P0
constraints: { time_limit_seconds: 5 }
```

**Comportement attendu** :
- Vérification des points critiques uniquement (agents fantômes, PII, route valide)
- Seuil de validation abaissé à 7.0 (marqué `[MODE URGENCE]` dans le log)
- `agent_briefs` condensés (1 ligne par step)
- Avertissement `[MODE URGENCE — QA partiel]` dans le `summary`

---

## Variante 3 — Revue Post-Exécution

**Déclencheur** : `intent: review_mo` — revue après exécution d'un plan

**Prompt d'activation** :
```
intent: review_mo
plan_id: <ID du plan exécuté>
partials: <résultats par step>
quality_indicators: <métriques post-run>
```

**Comportement attendu** :
- Comparer `expected_output` vs `actual_output` pour chaque step
- Identifier les écarts de qualité et les étapes en échec
- Produire un `post_run_report` avec recommandations
- Alimenter le log `log.decisions` avec les leçons apprises

---

## Variante 4 — Backup Orchestration (MO indisponible)

**Déclencheur** : `intent: backup_orchestrate` — MO en surcharge ou bloqué

**Prompt d'activation** :
```
intent: backup_orchestrate
objective: <objectif de la requête originale>
context: <contexte disponible>
reason: "MO_unavailable | MO_overloaded | MO_blocked"
```

**Comportement attendu** :
- Assumer temporairement le rôle MO (INTAKE → MAPPING → DISPATCH)
- Appliquer une politique conservatrice : tout doute → `on_failure: escalate`
- Notifier CTL-AlertRouter en début de session backup
- Logger `[MODE BACKUP]` dans chaque décision du log
- Transmettre un résumé complet à MO dès retour disponible

---

## Variante 5 — Audit de Sécurité Ciblé

**Déclencheur** : Plan contenant des données potentiellement sensibles

**Prompt d'activation** :
```
intent: qa_plan
routing_plan: <plan YAML>
constraints: { security_scan: deep }
```

**Comportement attendu** :
- Scan PII approfondi (noms, emails, IPs, mots de passe, tokens)
- Vérifier que chaque champ sensible est masqué (`[MASKED]` ou `[REDACTED]`)
- Produire une section `data_security_audit` détaillée
- Bloquer le DISPATCH si PII non masquées détectées
