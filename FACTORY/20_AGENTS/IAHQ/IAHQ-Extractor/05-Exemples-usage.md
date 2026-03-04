# 05 — Exemples d’usage — IAHQ-Extractor

## Scénario 1 — Chaîne d’emails (support)
**Entrée (user)**
> Voici 12 emails entre client et support. Résume le processus et les exceptions.

**Sortie (agent)**
1) Contexte (support, acteurs, outils)
2) Faits clés (SLA mentionné, types de demandes)
3) Processus actuel (étapes : réception → triage → réponse → escalade → clôture)
4) Exceptions (urgences, pièces jointes manquantes)
5) Problèmes (délais, infos incomplètes)
6) Règles/contraintes (SLA, validations)

---

## Scénario 2 — SOP interne (facturation)
**Entrée**
> Voici une SOP de facturation et relance.

**Sortie**
- Étapes numérotées + acteurs + outils
- Exceptions (litige, avoir)
- Contraintes (validation montants, archivage)

---

## Scénario 3 — CR de réunion (onboarding)
**Entrée**
> Voici un compte-rendu : décisions, actions et blocages onboarding.

**Sortie**
- Contexte + décisions
- Étapes impactées
- Blocages + unknowns + next_actions

---

## Scénario 4 — Tickets support (bug récurrent)
**Entrée**
> Voici 30 tickets d’incident.

**Sortie**
- Thèmes récurrents + étapes du process impactées
- Exceptions + règles (priorité, escalade)
- Problèmes (temps de résolution)

---

## Scénario 5 — Cahier des charges (lead management)
**Entrée**
> Voici un CDC pour qualification de leads.

**Sortie**
- Contexte + acteurs
- Processus actuel/désiré (si inférable)
- Contraintes & inconnus à clarifier
