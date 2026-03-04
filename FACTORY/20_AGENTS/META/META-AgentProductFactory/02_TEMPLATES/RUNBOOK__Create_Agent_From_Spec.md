# RUNBOOK: Create Agent From Spec

## Objectif
Créer un agent complet (agent.yaml + contract.yaml + prompt.md) à partir d'une spécification métier.

---

## Inputs requis

### Minimum
```yaml
objective: "Créer un agent qui [fait X pour Y]"
```

### Complet (recommandé)
```yaml
objective: "Description du besoin"
context:
  domain: "IT|CONSTRUCTION|EDU|META"
  users: "Qui utilise l'agent"
agent_spec:
  team: "TEAM_NAME"
  role: "RôleAgent"
  description: "Ce que fait l'agent"
```

---

## Process de création

### Étape 1: Analyser le besoin métier

**Questions à répondre:**
- Quel problème résout cet agent?
- Pour qui? (techniciens, gestionnaires, clients)
- Quel domaine? (IT, Construction, Éducation, Meta)
- Quels outils utilise-t-il? (ConnectWise, VEEAM, etc.)

**Actions:**
1. Lire l'objective
2. Identifier domaine principal
3. Identifier cas d'usage principaux

**Output:** Compréhension claire du besoin

---

### Étape 2: Vérifier duplications

**Consulter:** `00_REFERENCE_DATA/agents_index.yaml`

**Vérifications:**
1. Agent similaire existe-t-il déjà?
2. Si oui, est-ce une extension ou un nouvel agent?
3. Le nom envisagé est-il disponible?

**Exemple:**
```yaml
# Besoin: Agent pour monitoring backup
# Vérification: IT-BackupSpecialist existe déjà
# Question: Nouveau agent ou étendre BackupSpecialist?
```

**Output:** Confirmation qu'agent est nécessaire et unique

---

### Étape 3: Designer l'agent

#### 3.1 Choisir team
**Consulter:** `00_REFERENCE_DATA/teams.yaml`

**Règles:**
- IT → Infrastructure, cloud, serveurs, réseau
- CONSTRUCTION → Projets, inspections, conformité
- EDU → Formation, évaluation, certification
- META → Création agents, gouvernance

#### 3.2 Nommer l'agent
**Consulter:** `TEMPLATE__agent_yaml.md`

**Format:** `TEAM-NomAgentPascalCase`

**Exemples:**
- IT-BackupMonitor
- CONSTRUCTION-EstimationCouts
- EDU-FormationTechnique
- META-PromptOptimizer

#### 3.3 Écrire description
**Longueur:** 50-120 caractères  
**Format:** "Spécialiste X qui fait Y" ou "Fait X pour Y"

**Bon:** "Spécialiste backup VEEAM et Datto - diagnostic et résolution"  
**Mauvais:** "Agent backup"

#### 3.4 Sélectionner intents
**Consulter:** `00_REFERENCE_DATA/intents.yaml`

**Nombre:** 3-5 intents pertinents au domaine

**Processus:**
1. Identifier actions principales de l'agent
2. Chercher intents correspondants dans intents.yaml
3. Si intent n'existe pas, créer selon pattern verbe_nom

**Exemple pour IT-BackupMonitor:**
```yaml
intents:
  - monitor_health          # Catégorie: maintenance
  - detect_anomalies        # Catégorie: analysis
  - troubleshoot_backup_failure  # Catégorie: analysis
  - generate_backup_report  # Catégorie: communication
  - alert_issues            # Catégorie: execution
```

**Output:** Design complet (team, nom, description, intents)

---

### Étape 4: Générer agent.yaml

**Utiliser:** `TEMPLATE__agent_yaml.md`

**Structure:**
```yaml
id: <TEAM-NomAgent>
display_name: "@<TEAM-NomAgent>"
team_id: TEAM__<TEAM>
version: 1.0.0
status: active
description: "<Description du step 3.3>"
intents:
  - <Intent 1 du step 3.4>
  - <Intent 2>
  - <Intent 3>
  - <Intent 4>
  - <Intent 5>
```

**Validation:**
- [ ] id suit pattern TEAM-Nom
- [ ] display_name = @id
- [ ] team_id valide
- [ ] description 50-120 chars
- [ ] 3-5 intents

**Output:** agent.yaml conforme

---

### Étape 5: Générer contract.yaml

**Utiliser:** `TEMPLATE__contract_yaml.md`

#### 5.1 Définir inputs spécifiques

**CRITIQUE:** Inputs DOIVENT être spécifiques au domaine

**IT Agent exemple:**
```yaml
input:
  server_list:
    type: array<string>
    required: true
    description: "Liste serveurs à monitorer"
  check_interval:
    type: number
    required: false
    default: 300
    description: "Intervalle vérification (secondes)"
```

**Construction Agent exemple:**
```yaml
input:
  building_address:
    type: string
    required: true
  inspection_type:
    type: enum(pre-construction,final)
    required: true
```

#### 5.2 Définir outputs

```yaml
output:
  output_format: YAML_STRICT
  result:
    summary: string
    status: enum(ok,needs_clarification,partial,error)
    confidence: number (0-1)
    # Champs spécifiques...
```

#### 5.3 Définir artifacts

**Format fichier simple (pas Google Drive):**
```yaml
artifacts:
  - type: md
    title: "Rapport monitoring"
    path: "monitoring_report.md"
    required: true
```

#### 5.4 Définir guardrails

**Minimum 2, recommandé 4:**
```yaml
guardrails:
  - "Jamais exposer credentials"
  - "Valider inputs avant traitement"
  - "Respecter privacy si données personnelles"
  - "Documenter toutes actions"
```

**Output:** contract.yaml conforme

---

### Étape 6: Générer prompt.md

**Utiliser:** `TEMPLATE__prompt_md.md`

**CRITIQUE:** Prompt DOIT être UNIQUE avec EXEMPLES

#### 6.1 Structure de base

```markdown
# <AgentName> (@<TEAM-AgentName>)

## Rôle
[Description UNIQUE - PAS de copier-coller]

## Quand utiliser
- [Cas 1]
- [Cas 2]
- [Cas 3]

## Process
1. [Étape 1]
2. [Étape 2]
3. [Étape 3]

## Exemples

### Exemple 1: [Titre]
Input: [Exemple concret]
Output: [Résultat détaillé]
```

#### 6.2 Créer exemples concrets

**MINIMUM 1 exemple requis**

**Bon exemple:**
```
Input:
```
Serveur SRV-SQL01 - backup a échoué cette nuit
Erreur Event Log: ID 8193 "VSS Writer failed"
```

Output:
```
Diagnostic:
- SQL Writer en état failed
- Cause: Service SQL VSS Writer arrêté
- Solution: Redémarrer service + relancer backup

Commandes PowerShell:
Get-Service SQLWRITER | Restart-Service
Start-VBRJob -Job "SQL Servers Backup"
```
```

**Mauvais exemple:**
```
Input: Problème backup
Output: Vérifier les logs
```

#### 6.3 Aligner avec contract.yaml

**Vérifier:**
- Même terminologie (server_name, maintenance_window, etc.)
- Inputs/outputs correspondent
- Aucune divergence

**Output:** prompt.md unique et conforme

---

### Étape 7: Valider qualité

**Utiliser:** `CHECKLIST__Agent_Completeness.md`

**Vérifications:**

**agent.yaml:**
- [ ] YAML 100% valide
- [ ] id unique (pas dans agents_index.yaml)
- [ ] Conventions nommage respectées
- [ ] Description claire

**contract.yaml:**
- [ ] schema_version = '1.1'
- [ ] Inputs SPÉCIFIQUES (pas génériques)
- [ ] Outputs avec status/confidence
- [ ] Min 1 artifact, min 2 guardrails

**prompt.md:**
- [ ] Prompt UNIQUE (pas copier-coller)
- [ ] Min 1 exemple concret
- [ ] Aligné avec contract.yaml

**Quality Score:**
- [ ] Overall ≥ 9/10
- [ ] Clarity ≥ 9/10
- [ ] Completeness ≥ 8/10
- [ ] Compliance = 10/10

**Output:** Validation complète ou liste corrections

---

### Étape 8: Générer package final

**Structure:**
```
<TEAM-AgentName>/
├── agent.yaml
├── contract.yaml
├── prompt.md
└── README.md (optionnel)
```

**Output format:**

```yaml
status: ok
confidence: 0.95
agent_created:
  id: IT-BackupMonitor
  team_id: TEAM__IT
  files_generated: 3
  quality_score: 9.4

artifacts:
  - agent.yaml
  - contract.yaml  
  - prompt.md

log:
  decisions:
    - "Utilisé TEAM__IT car monitoring infrastructure"
    - "Choisi intents depuis intents.yaml catégorie maintenance"
  assumptions:
    - "Agent aura accès à VEEAM/Datto APIs"
  risks:
    - "Nécessite credentials VEEAM (à configurer)"
  quality_score:
    overall: 9.4
    clarity: 9.5
    completeness: 9.2
    compliance: 10.0
```

---

## Gestion des cas spéciaux

### Cas 1: Information manquante

**Si domaine pas clair:**
```yaml
status: needs_clarification
questions:
  - "Quel domaine? (IT, CONSTRUCTION, EDU, META)"
  - "Quels outils l'agent utilise?"
  - "Qui sont les utilisateurs finaux?"
```

### Cas 2: Agent similaire existe

**Si IT-BackupSpecialist existe et on demande IT-BackupMonitor:**
```yaml
status: needs_clarification
similar_agents:
  - id: IT-BackupSpecialist
    description: "Spécialiste backup VEEAM et Datto"
    suggestion: "Étendre IT-BackupSpecialist ou créer nouveau?"
```

### Cas 3: Intents manquants

**Si intents nécessaires n'existent pas dans intents.yaml:**
```yaml
new_intents_created:
  - monitor_backup_health    # Créé selon pattern
  - detect_backup_anomalies  # Créé selon pattern

next_actions:
  - "Ajouter ces intents à intents.yaml"
```

---

## Temps estimé

- Analyse besoin: 1-2 min
- Vérification duplications: 1 min
- Design agent: 2-3 min
- Génération fichiers: 3-5 min
- Validation: 1-2 min

**Total: 8-13 minutes par agent**

---

## Troubleshooting

**Problème:** Quality score < 9
**Solution:** Vérifier prompt unique + exemples présents

**Problème:** YAML invalid
**Solution:** Vérifier indentation (2 espaces, pas tabs)

**Problème:** Prompt trop générique
**Solution:** Ajouter exemples concrets du domaine

**Problème:** Inputs trop génériques (data, info, stuff)
**Solution:** Redéfinir inputs spécifiques au domaine

---

*Runbook version 1.0 - META-AgentFactory*
