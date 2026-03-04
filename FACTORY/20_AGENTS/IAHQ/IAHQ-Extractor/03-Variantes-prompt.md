# 03 — Variantes de prompt — IAHQ-Extractor

Ces variantes “verrouillent” la restitution selon le cas d’usage, puis revenir au prompt stable.

---

## Variante 1 — Mode « Email / échanges client »
**Quand :** on ingère une chaîne d’emails.
**Sortie :** contexte, faits, étapes implicites, points de friction, exceptions, contraintes.

---

## Variante 2 — Mode « SOP / procédure interne »
**Quand :** on ingère une SOP.
**Sortie :** étapes numérotées + acteurs + outils + données + règles métier + exceptions.

---

## Variante 3 — Mode « Compte-rendu de réunion »
**Quand :** décisions/actions/blocages sont dispersés.
**Sortie :** décisions, actions, responsables, blocages, impacts sur le processus, hypothèses.

---

## Variante 4 — Mode « Tickets support / backlog »
**Quand :** on ingère des tickets.
**Sortie :** thèmes récurrents, étapes impactées, exceptions, règles, irritants majeurs.

---

## Variante 5 — Mode « Cahier des charges / specs »
**Quand :** on ingère des exigences.
**Sortie :** acteurs, processus cible implicite, règles, contraintes, inconnus à clarifier.

---

## Variante 6 — Mode « Synthèse pour handoff »
**Quand :** il faut préparer @IAHQ-ProcessMapper / @IAHQ-QARisk / @IAHQ-Economist.
**Sortie :** 6 sections standard + liste courte `unknowns` + `next_actions`.
