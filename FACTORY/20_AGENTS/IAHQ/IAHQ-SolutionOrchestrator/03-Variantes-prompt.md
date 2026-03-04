# 03 — Variantes de prompt (par cas d’usage)

> Objectif : adapter le même rôle à différents contextes sans changer le “socle”.
> Utilisation : copier-coller **une variante** à la fin du prompt interne (ou la donner en instruction utilisateur).

---

## Variante A — Proposition courte (2–3 pages max)
**Instruction :**
- Produis une proposition concise (2–3 pages).  
- Réduis l’As-Is à 6–10 bullets, et le To-Be à 1 page max.  
- Mets 1 tableau “Bénéfices vs Effort” (qualitatif) + 1 plan 30-60-90.

---

## Variante B — Version “MVP vs Full”
**Instruction :**
- Fournis deux options :
  1) **MVP (phase 1)** : périmètre minimum viable, risques maîtrisés, time-to-value rapide.
  2) **Full** : extension du périmètre + industrialisation.
- Pour chaque option : livrables, dépendances, risques, estimation d’effort (qualitative) et critères d’acceptation.

---

## Variante C — Réponse à un appel d’offres / RFP
**Instruction :**
- Reprends la structure RFP :
  - compréhension du besoin
  - approche & méthode
  - planning
  - gouvernance
  - risques & mitigations
  - hypothèses & exclusions
- Ajoute une section “Conformité / Sécurité” explicite, même si l’input est mince.

---

## Variante D — Note interne de cadrage (pré-delivery)
**Instruction :**
- Écris pour l’équipe interne (OPS/META/IT), pas pour le client.
- Ajoute :
  - responsabilités (RACI léger)
  - backlog technique (intégrations, données)
  - stratégie de tests (QA, golden tests)
  - jalons MVP + critères “go/no-go”.

---

## Variante E — After objections (client sceptique)
**Instruction :**
- Ajoute une section “Objections fréquentes & réponses” :
  - hallucinations / qualité
  - confidentialité
  - coûts / ROI
  - adoption par les équipes
- Termine par un plan de pilote “safe” (durée, périmètre, critères de succès).

---

## Variante F — Secteur sensible (santé / juridique / finance)
**Instruction :**
- Renforce “Risques & qualité” :
  - human-in-the-loop obligatoire
  - logs/traçabilité
  - contrôle d’accès et gestion des données sensibles
  - validation de contenu par un responsable métier
- Si un point relève du juridique/médical : écrire “Hypothèse à valider: validation par un professionnel qualifié requis.”
