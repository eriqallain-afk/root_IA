# Dépréciation — META-Opromptimizer & META-PromptArchitectEquipes

**Date** : 2026-02-01  
**Raison** : Fusion en META-PromptMaster  
**Status** : DEPRECATED

---

## Agents dépréciés

### META-Opromptimizer
- **ID** : `META-Opromptimizer`
- **Mission** : Conçoit/évalue/optimise prompts et standards machine
- **Status** : DEPRECATED
- **Remplacé par** : META-PromptMaster
- **Date dépréciation** : 2026-02-01

### META-PromptArchitectEquipes
- **ID** : `META-PromptArchitectEquipes`
- **Mission** : Structure et standardise les prompts des agents
- **Status** : DEPRECATED
- **Remplacé par** : META-PromptMaster
- **Date dépréciation** : 2026-02-01

---

## Raison de la dépréciation

Les deux agents avaient des **responsabilités qui se chevauchaient** :

**META-Opromptimizer** :
- Conçoit prompts
- Évalue prompts
- Optimise prompts
- Définit standards machine

**META-PromptArchitectEquipes** :
- Structure prompts
- Standardise prompts
- Format machine
- Constraints & DoD

→ **Redondance** : Design/optimisation vs structure/standardisation = séparation artificielle

---

## Migration vers META-PromptMaster

### Ce qui change

**AVANT (2 agents)** :
```
Besoin nouveau prompt
  ↓
META-Opromptimizer (design initial)
  ↓
META-PromptArchitectEquipes (standardisation)
  ↓
Prompt final
```

**APRÈS (1 agent)** :
```
Besoin nouveau prompt
  ↓
META-PromptMaster (design + standardisation intégrés)
  ↓
Prompt final
```

### Mapping des fonctionnalités

| Ancienne fonctionnalité | Ancien agent | Nouvel agent | Notes |
|------------------------|--------------|--------------|-------|
| Design prompts | Opromptimizer | PromptMaster | Inchangé |
| Optimisation prompts | Opromptimizer | PromptMaster | Inchangé |
| Tests prompts | Opromptimizer | PromptMaster | Étendu |
| Standardisation | PromptArchitectEquipes | PromptMaster | Intégré |
| Format machine | PromptArchitectEquipes | PromptMaster | Intégré |
| Constraints | PromptArchitectEquipes | PromptMaster | Intégré |
| Library patterns | — | PromptMaster | **NOUVEAU** |

---

## Actions requises

### Pour les utilisateurs des anciens agents

1. **Mettre à jour les références** :
   ```yaml
   # AVANT
   actor_id: META-Opromptimizer
   
   # APRÈS
   actor_id: META-PromptMaster
   ```

2. **Mettre à jour playbooks** :
   - Remplacer `META-Opromptimizer` par `META-PromptMaster`
   - Remplacer `META-PromptArchitectEquipes` par `META-PromptMaster`

3. **Vérifier intents** :
   - Anciens intents toujours supportés
   - Nouveaux intents disponibles (voir `agent.yaml`)

### Pour le dépôt root_IA

1. **Marquer anciens agents comme deprecated** :
   ```yaml
   # Dans META-Opromptimizer/agent.yaml
   status: deprecated
   deprecated_date: "2026-02-01"
   replaced_by: META-PromptMaster
   
   # Dans META-PromptArchitectEquipes/agent.yaml
   status: deprecated
   deprecated_date: "2026-02-01"
   replaced_by: META-PromptMaster
   ```

2. **Mettre à jour playbooks** :
   - `40_RUNBOOKS/playbooks.yaml`
   - Remplacer références aux anciens agents

3. **Mettre à jour routing** :
   - `80_MACHINES/hub_routing.yaml`
   - Router intents vers META-PromptMaster

---

## Timeline de retrait

| Date | Action |
|------|--------|
| 2026-02-01 | Agents marqués DEPRECATED |
| 2026-02-08 | Tests migration validés |
| 2026-02-15 | Playbooks migrés |
| 2026-03-01 | Agents marqués RETIRED |
| 2026-04-01 | Agents archivés (si stable) |

---

## Support

### Période de transition : 1 mois
- Les anciens agents restent accessibles (deprecated)
- Support disponible pour migration
- Tests de non-régression requis

### Après transition
- Anciens agents marqués RETIRED
- Redirection automatique vers META-PromptMaster (si possible)
- Documentation mise à jour

---

## Questions fréquentes

### Q: Pourquoi fusionner maintenant ?
**R**: Simplification architecture META (10 → 8 agents), élimination redondances.

### Q: Les anciens prompts fonctionnent-ils encore ?
**R**: Oui, pendant période de transition (1 mois). Migration recommandée immédiatement.

### Q: Faut-il réécrire tous les prompts ?
**R**: Non. META-PromptMaster est compatible avec les anciens workflows. Seules les références (actor_id) doivent changer.

### Q: Que faire si je trouve un bug ?
**R**: Reporter immédiatement à l'équipe META. Rollback possible si critique.

### Q: Les intents changent-ils ?
**R**: Les anciens intents sont tous supportés. Nouveaux intents ajoutés pour plus de flexibilité.

---

## Contacts

- **Équipe META** : [contact]
- **Documentation** : Voir `MIGRATION_GUIDE.md`
- **Support technique** : [canal Slack]

---

**FIN DEPRECATION NOTICE**
