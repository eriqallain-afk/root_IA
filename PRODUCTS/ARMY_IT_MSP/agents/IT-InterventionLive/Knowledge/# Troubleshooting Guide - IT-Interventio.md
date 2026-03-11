# Troubleshooting Guide - IT-InterventionLive

## GPT ne génère pas rapports

**Symptôme:** Pas de rapports après texte

**Cause:** /close pas détecté

**Solution:** 
- Tape exactement `/close` (avec slash)
- Sur ligne séparée
- Pas de texte avant/après sur même ligne

---

## Rapports incomplets

**Symptôme:** Rapports manquent détails

**Cause:** Pas assez d'infos pendant intervention

**Solution:**
- Envoie plus de détails pendant
- Screenshots de états importants
- Commandes exécutées
- Résultats actions

---

## GPT répète contexte

**Symptôme:** Longues réponses avec contexte

**Cause:** Tu n'utilises pas IT-InterventionLive correct

**Solution:**
- Vérifie que prompt.md complet dans Instructions
- Réinitialise conversation
- Teste avec intervention simple

---

## Timeline imprécise

**Symptôme:** Heures manquantes dans timeline

**Cause:** Pas fourni timing

**Solution:**
- Mentionne heures si importantes
- Sinon GPT utilise durées relatives (OK)

---

## Rapports trop techniques

**Symptôme:** CW_DISCUSSION trop technique pour client

**Cause:** Normal si intervention très technique

**Solution:**
- Utilise EMAIL_BRIEF pour client (plus simple)
- CW_DISCUSSION reste pro mais accessible
- CW_INTERNAL_NOTE pour détails tech

---

## GPT demande trop questions

**Symptôme:** Trop de questions vs suggestions

**Cause:** Info initiale insuffisante

**Solution:**
- Ouverture détaillée (#ticket, client, tâche, périmètre)
- Donne contexte dès début
- Screenshots plutôt que descriptions