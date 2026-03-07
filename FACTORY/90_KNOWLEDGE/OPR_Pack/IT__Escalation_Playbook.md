# IT — Escalation Playbook (OPR)

> Version OPR : focus sur gouvernance, change, communications et CMDB.
> OPR reçoit les escalades administratives / back-office et coordonne les comms.

---

## Rôle OPR dans la chaîne d'escalade

```
NOC (détecte) → TECH (remédie) → OPR (orchestre comms + CMDB + clôture)
                                 ↓
                           CTOMaster (arbitre si enjeu stratégique)
```

OPR n'est pas premier répondant sur les incidents — il est l'**orchestrateur back-office**.

---

## Déclencheurs d'escalade vers OPR

| Situation | Déclencheur | Action OPR |
|-----------|-------------|------------|
| Incident S0/S1 actif | NOC après stabilisation | Communication client + update CMDB |
| Change requis (prod) | INFRA/TECH après diagnostic | Fenêtre + comms + RFC Light |
| SLA à risque breach | NOC/Dispatcher | Alerte proactive client + escalade CTO |
| Asset non documenté | TECH pendant diagnostic | Ticket CMDB completion |
| Client demande update | Toute entrée | Communication structurée |
| Ticket à clore | TECH après résolution | Vérification documentation + KB |

---

## Escalade OPR → CTOMaster

Escalader vers CTOMaster si :
- RFC impacte une architecture majeure (infra, sécurité, cloud)
- Incident client avec risque contractuel / SLA pénalité
- Décision de priorisation entre plusieurs clients/urgences
- Change qui dépasse le périmètre technique habituel
- Conflit de ressources non résolvable en équipe

---

## Escalade OPR → CommsMSP

Déléguer à CommsMSP pour :
- Rédaction email client complexe (incident majeur, post-mortem client)
- Notifications maintenance (template EMAIL_CLIENT__MAINTENANCE)
- Communications Teams formalisées
- Tout canal externe dépassant la note CW standard

---

## Process OPR — Clôture de ticket

```
1. Vérifier résolution confirmée par TECH
2. Vérifier CW_NOTE_INTERNE complète (timeline + actions)
3. Vérifier CW_DISCUSSION (résumé client prêt)
4. Envoyer email client si S0/S1 ou demande explicite
5. MAJ CMDB si asset modifié
6. Créer KB article (KnowledgeKeeper) si incident nouveau ou complexe
7. Déclencher post-mortem si S0 ou S1 > 60 min
8. Clore ticket CW — statut : Completed
```

---

## Process OPR — Change Management

```
1. RFC Light reçu (INFRA/TECH)
2. Valider fenêtre maintenance (calendrier clients)
3. Rédiger notification client (si impact)
4. Confirmer plan rollback documenté
5. Alerter NOC pour monitoring renforcé
6. Post-change : confirmer succès / déclencher rollback si échec
7. MAJ CMDB + archivage RFC
```

---

## SLA Breach — Procédure OPR

| Délai avant breach | Action |
|--------------------|--------|
| T-4h | Alerte interne (NOC + TECH) |
| T-2h | Communication proactive client |
| T-1h | Escalade CTOMaster |
| T=0 (breach) | Communication client + rapport direction |

---

> Voir aussi : IT__Severity_Matrix.md | IT__Comms_Templates.md | IT__CMDB_Standards.md
