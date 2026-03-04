# IT-InterventionCopilot — Variantes de prompt (par cas d’usage)

> Utilisation : ajouter la variante **au début du brief** utilisateur.  
> Rappel : la sortie reste **YAML strict uniquement**.

## 1) LIVE — NOC (priorité disponibilité)
**Variante à coller**
```text
MODE=LIVE. Type=NOC.
Priorités : rétablir le service, réduire l’impact, consigner timeline + validations (service/monitoring).
Si une action n’est pas explicitement confirmée : [À CONFIRMER].
```

## 2) LIVE — SOC (priorité sécurité)
**Variante à coller**
```text
MODE=LIVE. Type=SOC.
Priorités : containment rapide, collecte d’indices (résumé non sensible), recommandations de suivi.
CW_DISCUSSION/EMAIL = client-safe (aucun détail sensible).
```

## 3) LIVE — Support (priorité expérience utilisateur)
**Variante à coller**
```text
MODE=LIVE. Type=Support.
Priorités : reproduction, diagnostic, correctif, validation côté utilisateur/service.
Consigne une checklist simple et des prochaines actions courtes.
```

## 4) LIVE — Changement planifié (fenêtre maintenance)
**Variante à coller**
```text
MODE=LIVE. Type=Autre.
Contexte : changement planifié sous fenêtre de maintenance.
Ajoute explicitement : prérequis, plan de rollback, validations post-change.
Si approbation requise non fournie : ajoute QUESTIONS + marque [À CONFIRMER].
```

## 5) CLOSE — Clôture standard (sans email)
**Variante à coller**
```text
/close
Génère CW_INTERNAL_NOTES (complet) + CW_DISCUSSION (court, facturable, client-safe).
N’inclus pas EMAIL_CLIENT.
```

## 6) CLOSE — Clôture + email “pro”
**Variante à coller**
```text
/close
email_required: true
email_tone: pro
Email court, clair, client-safe, avec prochaines étapes si nécessaires.
```

## 7) CLOSE — Clôture + email “empathique”
**Variante à coller**
```text
/close
email_required: true
email_tone: empathique
Email client-safe, ton rassurant, rappelle l’impact et la résolution sans détails sensibles.
```

## 8) LIVE — Rattrapage (journal à reconstituer)
**Variante à coller**
```text
MODE=LIVE.
Je fournis un historique partiel : reconstitue un JOURNAL numéroté.
Tout ce qui n’est pas explicitement daté/confirmé doit être [À CONFIRMER].
```

## 9) LIVE — Demande d’infos manquantes (minimum viable)
**Variante à coller**
```text
MODE=LIVE.
Si des infos critiques manquent, limite-toi à : QUESTIONS + PROCHAINES_ACTIONS.
Ne remplis pas de faux détails.
```

## 10) SOC — Post-incident (recommandations)
**Variante à coller**
```text
MODE=LIVE. Type=SOC.
Ajoute une section VALIDATIONS orientée sécurité (EDR/SIEM OK, comptes verrouillés/rotations si confirmées).
Propose des recommandations client-safe.
```
