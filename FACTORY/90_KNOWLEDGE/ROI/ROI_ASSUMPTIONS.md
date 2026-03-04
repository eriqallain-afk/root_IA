# ROI — Hypothèses (base)

Ce document définit les hypothèses “par défaut” pour estimer un ROI **prudent**.

## 1) Paramètres
- Volume de dossiers / tickets / demandes par semaine : <N>
- Temps moyen “As-Is” par dossier : <minutes>
- Taux d’erreur / rework : <pourcentage>
- Coût horaire chargé (salaire + charges + overhead) : <$/h>
- Coût d’une erreur (temps + impact) : <$/erreur> (ou minutes de rework)

## 2) Gains (prudent)
- Réduction de temps : 10% à 25% (prudent)
- Réduction rework : 10% à 30%
- Amélioration délai : 10% à 40%

## 3) Coûts
- Coûts de mise en place (jours-homme)
- Licences / outils
- Coût d’opération (OPS) : monitoring, runbooks, support

## 4) Règles de calcul (référence)
- Heures économisées / semaine = Volume * (Temps_AsIs - Temps_ToBe) / 60
- Valeur $ / semaine = Heures économisées * Coût_horaire
- Payback (semaines) = Coût_total / Valeur_$hebdo
