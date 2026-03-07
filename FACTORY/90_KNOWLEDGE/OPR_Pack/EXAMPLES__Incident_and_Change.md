# Examples OPR — Clôture ticket, Change, Communication

---

## Exemple 1 — Clôture ticket OPR (S2)

**Contexte :** Imprimante réseau HS chez client Béton ABC. TECH a résolu. OPR clôture.

**CW_NOTE_INTERNE (OPR)**
```
CLÔTURE TICKET #CW-4421
─────────────────────────────────────
RÉSOLUTION CONFIRMÉE : Oui — par Martin L. (TECH) à 14:35
ROOT CAUSE : Driver imprimante corrompu après mise à jour Windows KB5034441
FIX APPLIQUÉ : Désinstallation driver + réinstallation HP Universal Print Driver v7.0.1
VALIDATION : Test impression réussi. 3 utilisateurs testés. ✓

CMDB : HP LaserJet M507dn — driver mis à jour → v7.0.1 — Date MAJ : 2026-03-07
KB ARTICLE : Créé → KB-PRN-012 "Driver corrompu HP après KB Windows"

PROCHAINES ACTIONS : Aucune
STATUT : Completed
```

---

## Exemple 2 — Communication client post-incident (S1)

**Contexte :** Exchange Online inaccessible 2h. TECH a résolu. OPR envoie email.

**EMAIL CLIENT**
```
Sujet : [Résolu] Accès Exchange Online — Incident 2026-03-07

Bonjour [Contact client],

Nous vous confirmons que l'accès à Exchange Online a été pleinement rétabli
à 11h42 ce matin.

RÉSUMÉ
Début : 09:38 | Fin : 11:42 | Durée : 2h04
Impact : Accès messagerie indisponible pour tous les utilisateurs
Cause : Expiration certificat OAuth côté tenant (renouvellement automatique en échec)
Résolution : Renouvellement manuel + validation MFA

ACTIONS PRÉVENTIVES
→ Alerte proactive ajoutée : certificats OAuth — 60 jours avant expiration
→ Runbook de renouvellement certif créé et assigné à la maintenance mensuelle

Nous nous excusons pour la disruption causée. N'hésitez pas à nous contacter
pour toute question.

Cordialement,
[Nom] | Équipe MSP
```

---

## Exemple 3 — RFC Light OPR (change planifié)

**Contexte :** Mise à jour firmware FortiGate chez client Industries XYZ.

**RFC LIGHT**
```
TITRE : Mise à jour firmware FortiGate FG-200F — v7.4.3 → v7.4.5
OBJECTIF : Appliquer correctifs sécurité CVE-2024-21762 + CVE-2024-23113
SERVICE : Firewall périmètre (toutes connexions entrantes/sortantes)
ENVIRONNEMENT : Production
OWNER : Martin L. (INFRA)
APPROUVEURS : CTOMaster ✓ | Security ✓ | OPR (fenêtre + comms)

SCOPE
→ Ce qui change : firmware FortiGate uniquement
→ Ce qui NE change PAS : config, règles, VPN, policies
→ Impact utilisateur : interruption ~10 min (reboot firewall)
→ Dépendances : VPN clients, connexions WAN

RISQUES
1. Régression config post-update (mitigation : backup config avant)
2. Reboot > 10 min (mitigation : monitoring NOC + rollback ready)
3. CVE non couverts par nouvelle version (risque résiduel acceptable)

PLAN D'EXÉCUTION
1. Backup config FortiGate (FortiManager)
2. Télécharger firmware v7.4.5 depuis support.fortinet.com
3. Validation hash SHA256
4. Appliquer firmware — fenêtre : samedi 2026-03-08 02:00–04:00
5. Reboot automatique (~8 min)
6. Valider connexions WAN + VPN + règles
7. Test ping + DNS + accès Internet

VALIDATION POST-CHANGE
- [ ] Connexions WAN restaurées
- [ ] VPN clients reconnectés
- [ ] Règles firewall intactes
- [ ] Logs sécurité normaux
- [ ] Dashboard FortiGate vert

ROLLBACK
Point de non-retour : N/A (firmware rollback possible via FortiManager)
Étapes : Revert firmware via FortiManager → config restore
Temps estimé : 15 min

FENÊTRE : Sam 2026-03-08 02:00–04:00 (hors heures)
COMM CLIENT : Email envoyé vendredi 17:00 (OPR)
COMM INTERNE : Slack #noc-ops + alerte NOC pour monitoring renforcé
```

---

## Exemple 4 — Notification SLA à risque

**Contexte :** Ticket S2 proche du breach SLA (2h restantes).

**EMAIL CLIENT (proactif)**
```
Sujet : [Mise à jour] Ticket #CW-5512 — Accès VPN intermittent

Bonjour [Contact],

Nous travaillons activement sur votre ticket concernant les connexions VPN
intermittentes. Notre équipe a identifié la cause probable (configuration
split-tunnel) et finalise les tests en environnement de validation.

Nous visons une résolution complète avant 17h00 aujourd'hui.
Nous vous tiendrons informé dès la résolution confirmée.

Cordialement,
[Nom] | MSP Support
```
