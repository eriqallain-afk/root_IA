# 05 — Exemples d’usage (5 scénarios)

> Important : ces exemples utilisent des **placeholders**.  
> Quand une valeur est non confirmée, elle est marquée : “Hypothèse à valider: …”.

---

## Scénario 1 — IT (MSP) : tickets → base de connaissance
### Entrée (résumé multi-agents)
- Extractor : « volume ~ <V_MOIS> tickets/mois, rework élevé sur triage » (Hypothèse à valider)
- ProcessMapper : « intake → triage → résolution → documentation »
- QARisk : « données client, logs, accès restreint, validation humaine »
- Economist : « baseline: <H> h/mois triage + <H> h/mois doc; coût horaire <€> » (Hypothèse à valider)

### Sortie attendue (extrait)
- EXEC_SUMMARY : bénéfices + MVP “ticket-to-KB”
- PROPOSITION : sections 1→7
- PLAN 30-60-90 : pilote + critères de succès (taux de résolution, temps moyen)

---

## Scénario 2 — NEA : production d’un livre (pipeline)
### Entrée
- ProcessMapper : « collecte → structuration → édition → relecture → mise en page »
- QARisk : « droits d’auteur, vérification sources, validation éditoriale »
- Economist : « gains surtout sur rework et délais (pas “full auto”) »

### Sortie (extrait)
- To-Be : armée NEA (éditeur, correcteur, fact-check, maquettiste, archiviste)
- Risques : droits, hallucinations → contrôle qualité
- 30-60-90 : MVP sur 1 ouvrage pilote

---

## Scénario 3 — IASM : cabinet (intake + suivi)
### Entrée
- Extractor : « intake manuel, notes dispersées »
- QARisk : « données sensibles (santé) → human-in-the-loop + contrôle accès »
- Economist : « valoriser surtout la réduction d’erreurs et la conformité »

### Sortie
- Gouvernance renforcée + exclusions claires (pas de conseil médical automatisé)
- MVP : prise de notes assistée + synthèse + tâches administratives

---

## Scénario 4 — DAM : rénovation (gestion de projet)
### Entrée
- ProcessMapper : « devis → planification → achats → suivi chantier → clôture »
- QARisk : « erreurs de commandes, délais fournisseurs, traçabilité décisions »
- Economist : « gains: réduction de retards + rework »

### Sortie
- Plan 30-60-90 orienté “pilot project” (1 chantier)
- Indicateurs : délai, budget, écarts, satisfaction

---

## Scénario 5 — TRAD : veille + rapport
### Entrée
- Extractor : « surveillance multi-sources + synthèses quotidiennes »
- QARisk : « risque d’erreurs factuelles → sources + disclaimers »
- Economist : « gains: temps analyste + standardisation »

### Sortie
- Proposition : pipeline “watch → synthèse → rapport”
- Next steps : règles de source attribution + validation humaine
