# EXAMPLE: IT-MaintenanceMaster - Anatomie d'un agent parfait

## Pourquoi cet agent est excellent

IT-MaintenanceMaster obtient un quality score de **9.4/10** et représente un exemple parfait de création d'agent conforme aux standards root_IA.

---

## agent.yaml ✅

```yaml
id: IT-MaintenanceMaster
display_name: "@IT-MaintenanceMaster"
team_id: TEAM__IT
version: 1.0.0
status: active
description: "Assistant maintenance IT avec génération automatique de notes ConnectWise"
intents:
  - troubleshoot_server
  - analyze_event_log
  - suggest_powershell_commands
  - generate_cw_notes
  - track_maintenance_progress
```

### Ce qui est excellent:

**✅ id parfait**
- Format TEAM-Nom respecté
- Team IT clairement identifiée
- Nom descriptif (MaintenanceMaster)

**✅ description spécifique**
- Pas générique ("Agent IT" ❌)
- Mentionne ConnectWise (outil spécifique)
- 81 caractères (dans range 50-120)

**✅ intents pertinents**
- 5 intents (recommandé 3-5)
- Tous snake_case
- Couvrent domaine (troubleshoot, analyze, suggest, generate, track)
- Depuis catalogue intents.yaml

---

## contract.yaml ✅

### Inputs SPÉCIFIQUES (pas génériques)

```yaml
input:
  context:
    type: string
    required: false
    description: "Contexte intervention (serveurs, objectif)"
  
  screenshot_or_error:
    type: string|image
    required: false
    description: "Capture d'écran Event Log ou message erreur"
    
  intervention_status:
    type: enum(starting,in_progress,completed)
    required: false
    default: in_progress
```

### Ce qui est excellent:

**✅ Inputs domaine-spécifiques**
- Pas de "data", "info", "stuff"
- screenshot_or_error = spécifique à la maintenance IT
- intervention_status = enum clair

**✅ Outputs structurés**

```yaml
output:
  result:
    powershell_commands: array<string>
    next_steps: array<string>
    cw_discussion: string
    cw_note_interne: string
    email_client: string
```

**✅ Guardrails appropriés**

```yaml
guardrails:
  - "Jamais inclure credentials dans CW_DISCUSSION (client voit)"
  - "Commandes PowerShell doivent être testées et sûres"
  - "CW_NOTE_INTERNE technique, CW_DISCUSSION client-friendly"
  - "Toujours proposer prochaines étapes logiques"
```

**✅ Artifacts clairs**

```yaml
artifacts:
  - type: md
    title: "CW_DISCUSSION"
    path: "cw_discussion.md"
    description: "Note facturable client (bullet points)"
    required: true
    
  - type: md
    title: "CW_NOTE_INTERNE"
    path: "cw_note_interne.md"
    description: "Documentation technique complète"
    required: true
```

---

## prompt.md ✅

### Rôle UNIQUE

```markdown
Assistant maintenance IT qui analyse erreurs, screenshots et Event Logs 
en temps réel. Tu suggères commandes PowerShell contextuelles, proposes 
prochaines étapes logiques, et génères automatiquement documentation 
ConnectWise (CW_DISCUSSION + CW_NOTE_INTERNE + EMAIL_CLIENT).
```

### Ce qui est excellent:

**✅ Spécifique au domaine**
- Mentionne Event Logs, PowerShell (vocabulaire IT)
- Mentionne ConnectWise (outil réel)
- Pas générique

**✅ Exemples CONCRETS**

```markdown
### Exemple 1: Patching multi-serveurs

User: Je commence patching de SRV-DC01, SRV-APP01, SRV-SQL01
      Voici état pré-maintenance: [screenshot]

MaintenanceMaster:
Analysé screenshot ✓

Status pré-maintenance:
• SRV-DC01: 15 updates, 45GB libre
• SRV-APP01: 15 updates, 120GB libre
• SRV-SQL01: 15 updates, 80GB libre

Ordre recommandé (non-critiques d'abord):
1. SRV-APP01
2. SRV-SQL01
3. SRV-DC01 (DC en dernier)

Commande pour commencer:
```powershell
Install-WindowsUpdate -ComputerName SRV-APP01 -AcceptAll -AutoReboot
```

Prochaine étape: Surveiller reboot, puis SRV-SQL01
```

**Pourquoi excellent:**
- Input réaliste (noms serveurs, screenshot)
- Output détaillé (analyse, ordre, commandes, prochaines étapes)
- Commande PowerShell concrète
- Montre vraiment ce que fait l'agent

**✅ Alignment contract ↔ prompt**

Contract dit:
```yaml
powershell_commands: array<string>
cw_discussion: string
```

Prompt montre:
```markdown
Commande: Install-WindowsUpdate...
CW_DISCUSSION généré
```

→ Parfaitement aligné!

---

## Knowledge Pack associé ✅

IT-MaintenanceMaster a un **Knowledge Pack complet:**

```
IT-MaintenanceMaster_KnowledgePack_v1/
├── 01_TEMPLATES_CW/
│   ├── TEMPLATE__CW_DISCUSSION.md      (7 exemples)
│   ├── TEMPLATE__CW_NOTE_INTERNE.md    (2 exemples détaillés)
│   └── TEMPLATE__EMAIL_CLIENT.md       (7 exemples)
│
└── 04_POWERSHELL_LIBRARY/
    ├── POWERSHELL__Server_Management.md  (commandes essentielles)
    └── POWERSHELL__Event_Log_Analysis.md (Event IDs, troubleshooting)
```

### Ce qui est excellent:

**✅ Templates professionnels**
- CW_DISCUSSION: Bullet points client-friendly
- CW_NOTE_INTERNE: Technique avec commandes exactes
- EMAIL_CLIENT: 7 variantes selon situation

**✅ Bibliothèques complètes**
- Event IDs courants avec actions
- Commandes PowerShell testées
- Troubleshooting guides

---

## Metrics

```yaml
quality_score:
  overall: 9.4/10
  clarity: 9.5/10       # Instructions très claires
  completeness: 9.2/10  # Tous éléments présents
  compliance: 10.0/10   # 100% conforme standards
  timeliness: 9.5/10    # Très pertinent
```

---

## Leçons à retenir

### DO ✅

1. **Inputs spécifiques:**
   - screenshot_or_error (pas "data")
   - intervention_status enum (pas string vague)

2. **Prompts avec exemples concrets:**
   - Noms serveurs réalistes (SRV-DC01, SRV-APP01)
   - Commandes PowerShell réelles
   - Output détaillé montrant valeur

3. **Guardrails pratiques:**
   - "CW_DISCUSSION client-friendly, CW_NOTE_INTERNE technique"
   - Spécifiques au cas d'usage

4. **Knowledge Pack enrichi:**
   - Templates réutilisables
   - Bibliothèques référence
   - Exemples multiples

### DON'T ❌

1. **Éviter inputs génériques:**
   - ❌ data: string
   - ❌ info: object
   - ✅ screenshot_or_error: string|image

2. **Éviter prompts vagues:**
   - ❌ "Tu aides avec la maintenance"
   - ✅ "Tu analyses Event Logs et génères CW notes"

3. **Éviter exemples simplistes:**
   - ❌ Input: "Problème serveur" / Output: "Vérifier logs"
   - ✅ Input: "SRV-SQL01 Event ID 7000" / Output: [Diagnostic détaillé + commandes]

---

*Exemple version 1.0 - META-AgentFactory*
*IT-MaintenanceMaster comme référence de qualité*
