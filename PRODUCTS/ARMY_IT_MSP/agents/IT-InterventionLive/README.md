# IT-InterventionLive

**Assistant Intervention Temps Réel MSP**

## Description

Agent optimisé pour suivre interventions techniques en temps réel et générer rapports ConnectWise automatiquement.

**Workflow:**
1. Tu ouvres intervention (ticket, client, tâche)
2. Tu m'envoies infos au fur et à mesure (screenshots, états, logs)
3. Je te suggère prochaine étape (1-2 lignes max)
4. Je note TOUT en silence
5. Tu tapes `/close`
6. Je génère 3 rapports prêts pour CW

## Quick Start

### Ouvrir Intervention

```
#12345 - ACME Corp
Patches Windows sur SRV-DC01, SRV-FILE01
Fenêtre: 20h-22h
```

### Pendant Intervention

Envoie simplement:
- Screenshots
- États serveurs
- Logs
- Erreurs
- Actions faites

Je réponds court et suggère suite.

### Terminer

```
/close
```

Je génère:
1. **CW_DISCUSSION** - Pour ticket client
2. **CW_INTERNAL_NOTE** - Notes techniques
3. **EMAIL_BRIEF** - Pour IT-CommsMSP

## Commandes

| Commande | Action |
|----------|--------|
| `/close` | Génère les 3 rapports |
| `/summary` | État actuel rapide |
| `/timeline` | Chronologie actions |
| `/reset` | Nouvelle intervention |
| `/pause` | Pause (reprise ultérieure) |
| `/cancel [raison]` | Annule intervention |

## Exemple Réel

**Toi:**
```
#12345 - ACME Corp
Server slow SRV-FILE01
```

**Moi:**
```
✅ #12345 ouvert - SRV-FILE01 slow

Check CPU/RAM?
```

**Toi:**
[Screenshot Task Manager - CPU 95%]

**Moi:**
```
✅ CPU 95% - noté

Top process consommant CPU?
```

**Toi:**
```
antimalware.exe 85%
```

**Moi:**
```
✅ Defender scan actif - noté

Pause scan ou attends fin?
```

**Toi:**
```
Pausé, CPU normal now
/close
```

**Moi:**
```yaml
# === CW_DISCUSSION ===
Serveur SRV-FILE01 lent signalé.

Cause: Windows Defender scan complet (85% CPU)
Solution: Scan pausé temporairement
Résultat: Performance restaurée

Scan replanifié hors heures ouvrables.

# === CW_INTERNAL_NOTE ===
...détails techniques...

# === EMAIL_BRIEF ===
...brief pour client...
```

## Avantages vs Autres Agents

**IT-MaintenanceMaster:**
- ❌ Réécrit contexte chaque fois
- ✅ Bons rapports

**IT-InterventionCopilot:**
- ❌ Fait briefs pour autres depts
- ❌ Pas focus live

**IT-InterventionLive:**
- ✅ Silent recording
- ✅ Réponses ultra-courtes
- ✅ Rapports CW parfaits
- ✅ Timeline auto
- ✅ Lit screenshots

## Utilisation Optimale

### ✅ UTILISE-MOI POUR:
- Interventions live MSP
- Maintenances serveurs
- Troubleshooting incidents
- Déploiements
- Patches

### ❌ N'UTILISE PAS POUR:
- Tickets simples (<5 min)
- Documentation après coup
- Rapports sans intervention

## Économie Temps

**Sans IT-InterventionLive:**
- Intervention: 1h
- Documentation CW: 30 min
- Email client: 15 min
- **Total: 1h45**

**Avec IT-InterventionLive:**
- Intervention: 1h (agent suit en silence)
- `/close`: 30 sec
- Copie rapports: 2 min
- **Total: 1h02**

**Économie: 43 minutes par intervention!**

Sur 5 interventions/semaine: **3h35 économisées!**

## Format Rapports

### CW_DISCUSSION
- Client-friendly
- Pas de jargon
- Résultat clair

### CW_INTERNAL_NOTE
- Timeline précise
- Commandes exécutées
- États techniques
- Notes troubleshooting

### EMAIL_BRIEF
- Format pro
- Bullet points
- Prêt pour IT-CommsMSP
- Client-ready

## Fichiers

```
IT-InterventionLive/
├── agent.yaml           Configuration
├── contract.yaml        Input/Output
├── prompt.md            Instructions complètes
├── README.md            Ce fichier
├── 10_MEMORY/           Interventions sauvegardées
├── examples/            Exemples interventions
└── tests/               Tests automatisés
```

## Support

**Questions workflow?**  
Lis `prompt.md` - Instructions ultra-détaillées

**Agent ne répond pas comme attendu?**  
Vérifie que tu utilises format correct ouverture intervention

**Rapports manquent info?**  
Donne plus de détails pendant intervention (je note tout!)

## Notes Importantes

- Je lis screenshots et note contenu
- Je conserve timeline automatiquement
- Je génère rapports SEULEMENT au `/close`
- Pendant intervention: réponses 1-2 lignes MAX
- Je NE réécris JAMAIS le contexte

---

**PRÊT POUR TON SHIFT CE SOIR!** 🚀

**Version:** 1.0.0  
**Créé:** 3 février 2026  
**Optimisé pour:** Eric workflow MSP temps réel
