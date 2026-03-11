# IT-InterventionCopilot — Amorces de conversation

> Amorces prêtes à copier (remplace les valeurs `__` / `...`).

## A) Amorces ultra courtes (1 ligne) — idéal GPT Builder

1) `Ticket CW: Client=__ Ticket_ID=__ Brief=__ → classifie (NOC/SOC/SUPPORT/AUTRE) + checklist + LOG vide.`
2) `/template NOC|SOC|SUPPORT|AUTRE — Contexte: __ → checklist + LOG vide.`
3) `FAIT: __ (outil: __) Résultat: __ → mets à jour Journal + Checklist + Preuves.`
4) `FAIT: __ → KO: __ (résumé) → mets à jour + propose 3 prochaines étapes.`
5) `FAIT: validations finales (services/monitoring/backups) = __ → mets à jour VALIDATIONS.`
6) `CLOSE (email oui/non) → génère CW_INTERNAL_NOTES + CW_DISCUSSION (+ EMAIL_CLIENT si oui).`

## B) Amorces détaillées (10)

1) `MODE=LIVE | client=... | ticket_id=... | type=Support | Brief: l’utilisateur ne peut plus se connecter à l’application X. Actions déjà tentées: ...`

2)
```text
/template NOC
MODE=LIVE | Ticket: alerte monitoring “service indisponible”. Contexte: impact=?, depuis quand=?, actions en cours=?
```

3)
```text
/template SOC
MODE=LIVE | Ticket: alerte EDR sur poste utilisateur. Preuves: capture/texte ci-dessous.
```

4) `MODE=LIVE | Reprise d’intervention: voici le journal partiel (1..n). Reconstitue la timeline et marque [À CONFIRMER] ce qui manque.`

5) `MODE=LIVE | Hors-heures: after_hours=true, approval_required=true. Indique quoi faire avant d’exécuter un changement.`

6) `MODE=LIVE | Je colle une capture d’écran du message d’erreur (si illisible, note [ILLISIBLE]) : [capture]`

7) `MODE=LIVE | Type=Support | J’ai besoin d’une checklist simple + prochaines actions, sans jargon.`

8) `MODE=LIVE | Type=NOC | On suspecte un changement récent. Propose les vérifications et comment consigner les preuves (résumé).`

9)
```text
/close
Fin d’intervention. Génère CW_INTERNAL_NOTES + CW_DISCUSSION (client-safe). Pas d’email.
```

10)
```text
/close
email_required=true | email_tone=pro
Fin d’intervention. Ajoute un email client court et clair.
```
