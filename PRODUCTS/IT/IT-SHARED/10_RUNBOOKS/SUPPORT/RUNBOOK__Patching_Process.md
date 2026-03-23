# RUNBOOK — Communication Patching MSP (Client et Interne)
**ID :** RUNBOOK__Patching_Process | **Version :** 2.1
**Agent owner :** IT-TicketScribe | **Équipe :** TEAM__IT
**Domaine :** SUPPORT — Communications MSP
**Date révision :** 2026-03-20 — Agent owner mis à jour (v2.1)

---

## ⚠️ GARDE-FOUS — OBLIGATOIRES
> Référence : `00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md`

**Scope :** Cet agent rédige uniquement les communications liées au patching du billet actif.
Il ne répond pas aux demandes de rédaction hors contexte IT/MSP.

**Données sensibles dans les communications :**
- ❌ JAMAIS dans les emails/Teams clients : noms de serveurs, IPs, CVE spécifiques
- ❌ JAMAIS : informations qui permettraient d'exploiter des vulnérabilités avant le patch
- Les communications clients sont TOUJOURS en langage fonctionnel (impact et disponibilité)
- Toujours masquer les détails techniques des vulnérabilités corrigées

---

## 1. Objectif
Standardiser toutes les communications liées au cycle de patching :
- Notifications de fenêtre de maintenance aux clients
- Communications internes (équipe NOC/Tech)
- Annonces Teams (début/fin)
- Emails post-intervention (rapport fonctionnel)
- Gestion des escalades communication

---

## 2. Templates de communication par étape

### 2.1 Annonce préventive (J-48h) — Email client
```
Objet : [Entreprise] — Fenêtre de maintenance planifiée — [DATE]

Bonjour [Nom contact],

Nous vous informons qu'une fenêtre de maintenance est planifiée :
📅 Date : [JOUR DATE]
🕐 Heure : [HH:MM] à [HH:MM] ([fuseau horaire])
🎯 Objectif : Application des mises à jour de sécurité et de stabilité

Impact prévu :
- [Service X] : interruption possible de [durée estimée]
- [Service Y] : aucune interruption prévue

Actions requises de votre part :
- [ ] Sauvegarder vos documents ouverts avant [HH:MM]
- [ ] Prévoir une indisponibilité de [X] minutes sur [service]

Pour toute question, contactez : [email support] | [téléphone]

Cordialement,
[Signature MSP]
```

### 2.2 Annonce Teams — Début de maintenance
```
⚠️ MAINTENANCE EN COURS
📅 [DATE] — [HH:MM]
🔧 Application des mises à jour planifiées
⏱️ Durée estimée : [X heures]
📧 Toute interruption sera communiquée ici

Merci de votre compréhension. 🙏
```

### 2.3 Annonce Teams — Fin de maintenance (succès)
```
✅ MAINTENANCE TERMINÉE
📅 [DATE] — [HH:MM]
✔️ Mises à jour appliquées avec succès
🖥️ Tous les services sont opérationnels

En cas d'anomalie, contactez le support : [info contact]
```

### 2.4 Annonce Teams — Fin de maintenance (avec suivi)
```
✅ MAINTENANCE TERMINÉE — ⚠️ Suivi requis
📅 [DATE] — [HH:MM]
✔️ Mises à jour appliquées
⚠️ [Service X] : [état / action en cours]
📞 Notre équipe surveille activement la situation

Prochain point de communication : [HH:MM]
```

### 2.5 Email post-intervention — Rapport client
```
Objet : [Entreprise] — Rapport maintenance du [DATE]

Bonjour [Nom contact],

La fenêtre de maintenance du [DATE] est terminée. Voici le résumé :

✅ Résultat global : [Succès / Succès partiel]

Services mis à jour :
- [Catégorie service 1] : mise à jour appliquée — ✅ Opérationnel
- [Catégorie service 2] : mise à jour appliquée — ✅ Opérationnel

Durée effective : [HH:MM] à [HH:MM] ([X] minutes)

[Si applicable]
⚠️ Point de suivi : [description fonctionnelle — sans détails techniques]
   Action prévue : [description] — Délai : [date]

Prochaine maintenance planifiée : [DATE ou "À confirmer"]

Notre équipe reste disponible pour toute question.

Cordialement,
[Signature MSP]
```

---

## 3. Communication en cas d'incident durant la maintenance

### 3.1 Notification d'incident (délai 15 min max après détection)
```
Objet : [URGENT] [Entreprise] — Incident détecté durant maintenance — [DATE]

Bonjour [Nom contact],

Durant la fenêtre de maintenance, un incident a été détecté sur [catégorie service].

Statut actuel : Notre équipe technique est en train de traiter la situation.
Impact : [Service X] temporairement indisponible
Estimation retour à la normale : [heure estimée ou "sous X heures"]

Prochain point de communication : [heure]

Nous vous tenons informés de l'évolution.

[Signature MSP]
```

### 3.2 Résolution d'incident post-maintenance
```
Objet : [Résolution] [Entreprise] — Retour à la normale — [DATE]

Bonjour [Nom contact],

Bonne nouvelle — la situation est résolue.

✅ [Service X] : pleinement opérationnel depuis [HH:MM]
📋 Rapport détaillé disponible sur demande

Nous nous excusons pour la gêne occasionnée.

[Signature MSP]
```

---

## 4. Communication interne — Équipe technique

### 4.1 Briefing pré-maintenance (canal Teams IT)
```
🔧 MAINTENANCE PLANIFIÉE — BRIEFING
📅 [DATE] [HH:MM]-[HH:MM]
Client : [CLIENT]
Scope  : [description serveurs — sans IPs]
Owner  : @[Technicien assigné]
Backup : @[Technicien backup]
Proc   : [lien runbook ou playbook]
⚠️ Points d'attention : [risques identifiés]
```

### 4.2 Mise à jour état en cours (équipe)
```
⏳ UPDATE MAINTENANCE [CLIENT] — [HH:MM]
[✅/⚠️/❌] [Serveur/Service] : [statut court]
Prochaine étape : [action]
ETA fin : [estimation]
```

---

## 5. Checklist communication complète

- [ ] Annonce J-48h envoyée au client
- [ ] Confirmation réception client (si P1/P2 ou VIP)
- [ ] Briefing équipe IT effectué
- [ ] Annonce Teams début envoyée
- [ ] Updates intermédiaires si maintenance > 2h
- [ ] Annonce Teams fin envoyée
- [ ] Email rapport post-intervention envoyé (sous 24h)
- [ ] Note CW communication complète
