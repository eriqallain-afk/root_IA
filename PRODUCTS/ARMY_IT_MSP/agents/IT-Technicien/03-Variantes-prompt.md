# IT-Technicien — Variantes de prompt (par cas d’usage)

> Utilise ces variantes comme messages “prêts à coller” quand tu lances @IT-Technicien.

## 1) Triage rapide (sans blabla)
**Prompt**
- « Voici le ticket CW ci-dessous. Donne : catégorie, 1–3 hypothèses, 5 actions SUGGESTION max, 3 validations, et un bloc POUR COPILOT. Pose 1 question seulement si bloquant. »

## 2) NOC — Serveur en alerte (CPU/RAM/Disque)
**Prompt**
- « Ticket NOC : serveur en alerte. Propose un diagnostic probable et une checklist priorisée (RMM, services, events, capacity). Donne les validations et le bloc POUR COPILOT. »

## 3) NOC — Mises à jour + redémarrage (maintenance)
**Prompt**
- « Ticket NOC : patching serveur + redémarrage. Liste les précautions (fenêtre/approbation), les étapes SUGGESTION, et les validations post-reboot. Produis POUR COPILOT. »

## 4) NOC — Sauvegarde en échec
**Prompt**
- « Ticket NOC : sauvegarde en échec. Donne hypothèses (espace, repo, credentials, agent, réseau), actions SUGGESTION, validations, et POUR COPILOT. Marque [ESCALADE REQUISE] si risque de perte de données. »

## 5) SOC — Détection antivirus / EDR
**Prompt**
- « Ticket SOC : détection malware. Donne triage (confinement selon politique), remédiation SUGGESTION, validations, et POUR COPILOT. Si risque élevé → [ESCALADE REQUISE]. »

## 6) SOC — Demande firewall (déblocage / règle)
**Prompt**
- « Ticket SOC : connexion bloquée au firewall. Propose les vérifs à faire (logs, scope, durée temporaire), actions SUGGESTION, validations, et POUR COPILOT. Demande 1 info manquante si nécessaire (source/dest/ports). »

## 7) SUPPORT — Ajout utilisateur M365
**Prompt**
- « Ticket Support : création/ajout utilisateur M365. Donne étapes SUGGESTION (compte, licences, groupes, MFA selon standards) + validations, et POUR COPILOT. »

## 8) SUPPORT — Problème Exchange (envoi/réception)
**Prompt**
- « Ticket Support : problème mail Exchange/M365. Propose hypothèses (quota, règles, connectivité, trace), actions SUGGESTION, validations, et POUR COPILOT. »

## 9) Mode HANDOFF (juste le bloc scribe)
**Prompt**
- « MODE=HANDOFF. Transforme les notes suivantes en bloc POUR COPILOT (/obs /fait /test /preuve) + items_a_confirmer. Notes : … »

## 10) Post-mortem court (quand c’est réglé)
**Prompt**
- « C’est réglé. Résume cause probable + prévention (2–3 points) et prépare POUR COPILOT avec les actions confirmées. »
