# POLICIES & STANDARDS - root_IA v3

## 📋 Index des politiques et standards

Dernière mise à jour: 2026-02-14

---

## 🎯 Standards de création d'agents

### 1. Structure fichiers obligatoires

Chaque agent DOIT contenir:
- ✅ **agent.yaml** - Métadonnées (id, team, version, intents)
- ✅ **contract.yaml** - Contrat I/O détaillé
- ✅ **prompt.md** - Instructions spécifiques et uniques
- ✅ **README.md** - Documentation agent (optionnel mais recommandé)

### 2. Formats et validation

#### YAML
- **Indentation:** 2 espaces (JAMAIS de tabs)
- **Validation:** 100% valide avant commit
- **Encoding:** UTF-8 sans BOM
- **Line endings:** LF (Unix style)
- **Schema version:** '1.1' (current)

**Validation automatique:**
```bash
yamllint agent.yaml
yamllint contract.yaml
```

#### Markdown
- **Encoding:** UTF-8
- **Line endings:** LF
- **Headers:** ATX style (# ## ###)
- **Code blocks:** Toujours spécifier langage

---

## 📛 Conventions de nommage

### Agent ID
**Format:** `TEAM-NomAgent`  
**Case:** kebab-case  
**Pattern:** `^[A-Z]+-.+$`

**Exemples valides:**
- ✅ IT-CloudMaster
- ✅ CONSTRUCTION-InspectionBatiment
- ✅ EDU-EvaluationCCQ
- ✅ META-AgentFactory

**Exemples invalides:**
- ❌ CloudMaster (manque team prefix)
- ❌ it-cloudmaster (team pas UPPERCASE)
- ❌ IT_CloudMaster (underscore au lieu de tiret)

### Team ID
**Format:** `TEAM__<UPPERCASE>`  
**Pattern:** `^TEAM__[A-Z_]+$`

**Teams disponibles:**
- TEAM__IT
- TEAM__CONSTRUCTION
- TEAM__EDU
- TEAM__META
- TEAM__OPS
- TEAM__STRAT
- TEAM__DOSSIER_IA

### Display Name
**Format:** `@<agent_id>`  
**Exemple:** @IT-CloudMaster

### Intents
**Format:** `verbe_nom`  
**Case:** snake_case  
**Pattern:** `^[a-z]+_[a-z_]+$`

**Exemples:**
- ✅ generate_report
- ✅ troubleshoot_server
- ✅ validate_compliance
- ❌ generateReport (camelCase interdit)
- ❌ do_stuff (trop vague)

### Versioning
**Format:** Semantic Versioning (X.Y.Z)

**Règles:**
- X.0.0 - Breaking changes
- 0.Y.0 - New features
- 0.0.Z - Bug fixes

**Exemples:**
- 1.0.0 - Première version stable
- 1.1.0 - Feature ajoutée
- 1.1.1 - Bug fix
- 2.0.0 - Breaking change

---

## ✅ Standards de qualité

### Quality Score Minimum
**Score global:** ≥ 9/10

**Composantes:**
- Clarity (clarté): ≥ 9/10
- Completeness (complétude): ≥ 8/10
- Compliance (conformité): 10/10
- Timeliness (pertinence): ≥ 8/10

### Prompts

#### ✅ Prompts DOIVENT être:
- **Uniques** - Pas de copier-coller template générique
- **Spécifiques au domaine** - Instructions pertinentes au rôle
- **Actionnables** - Instructions claires et exécutables
- **Avec exemples** - Au moins 1 exemple concret
- **Alignés au contract** - Pas de divergence prompt ↔ contract

#### ❌ Prompts NE DOIVENT PAS être:
- **"MODE MACHINE" identiques** - Éviter templates génériques réutilisés
- **Vagues ou génériques** - "Fait des choses IT" est inacceptable
- **Sans exemples** - Impossible de comprendre usage sans exemple
- **Divergents du contract** - Inputs/outputs doivent correspondre

**Exemple de prompt INTERDIT:**
```markdown
# Agent (@TEAM-Agent)

Tu es un agent qui aide l'utilisateur. Tu es expert dans ton domaine.
Réponds aux questions et fournis de l'aide.
```
**Pourquoi:** Trop générique, pas d'exemples, aucune instruction spécifique

**Exemple de prompt CORRECT:**
```markdown
# IT-CloudMaster (@IT-CloudMaster)

## Rôle
Expert cloud multi-plateforme spécialisé dans Azure, M365, Google Workspace et AWS.
Tu génères des procédures opérationnelles, rapports professionnels et checklists 
de configuration selon les meilleures pratiques.

## Quand utiliser
- Créer runbooks Azure/M365/AWS
- Générer rapports Cloud Health mensuels
- Auditer configuration sécurité cloud

## Exemple
Input: "Génère procédure provisioning VM Azure"
Output: [Runbook détaillé avec commandes PowerShell, validation, rollback]
```

### Contracts

#### Champs obligatoires
- ✅ `schema_version: '1.1'`
- ✅ `agent.id` et `agent.team_id`
- ✅ `description` et `mission`
- ✅ `input` structure (PAS générique)
- ✅ `output.output_format`
- ✅ `output.result` avec status/confidence
- ✅ `artifacts` (minimum 1)
- ✅ `guardrails` (minimum 2)
- ✅ `log` structure

#### Inputs/Outputs spécifiques
**INTERDIT - Inputs trop génériques:**
```yaml
input:
  data: string
  info: object
  stuff: any
```

**REQUIS - Inputs spécifiques au domaine:**
```yaml
input:
  server_name:
    type: string
    required: true
  maintenance_type:
    type: enum(patching,backup,monitoring)
    required: true
  schedule:
    type: datetime
    required: false
```

---

## 🔒 Sécurité et conformité

### Données sensibles - INTERDICTIONS ABSOLUES

❌ **JAMAIS dans prompts ou contracts:**
- Mots de passe / credentials
- Clés API / secrets
- Tokens d'authentification
- Informations personnelles identifiables (PII)
- Numéros cartes crédit
- SSN / NAS

❌ **JAMAIS dans fichiers YAML:**
- IPs internes en clair (si sensibles)
- URLs internes privées
- Noms de serveurs sensibles (si non publics)

✅ **Autorisé:**
- Exemples fictifs (example.com, 192.0.2.1)
- Noms génériques (SRV-APP01, srv-dc01.domain.local)
- URLs publiques de documentation

### Guardrails obligatoires

Chaque contract DOIT avoir minimum 2 guardrails:

```yaml
guardrails:
  - "Jamais exposer credentials ou données sensibles"
  - "Valider inputs avant traitement"
  - "Respecter RGPD/privacy si données personnelles"
  - "Ne jamais exécuter commandes destructives sans confirmation"
```

---

## 📊 Métriques et KPIs

### Métriques obligatoires dans contract.yaml

```yaml
metrics:
  quality_target: ≥ 9/10
  yaml_valid: 100%
  response_time: < 30s (si applicable)
  success_rate: > 95% (si applicable)
```

### Success Criteria

Chaque contract DOIT définir:
```yaml
success_criteria:
  - "Output généré conforme au format spécifié"
  - "Aucune erreur YAML"
  - "Quality score ≥ 9/10"
  - "[Critère spécifique au domaine]"
```

---

## 🚨 Escalation

### Triggers automatiques

**Score < 7:**
```yaml
escalation:
  - trigger: Quality score < 7
    to: META-PromptMaster
    reason: "Refactoring et amélioration prompt requis"
```

**YAML invalide:**
```yaml
escalation:
  - trigger: YAML validation fails
    to: META-AgentFactory
    reason: "Correction syntax YAML"
```

**Risques compliance:**
```yaml
escalation:
  - trigger: Security/compliance issue detected
    to: META-GouvernanceQA
    reason: "Audit sécurité et conformité"
```

---

## 📚 Documentation requise

### Par agent
- ✅ **README.md** - Vue d'ensemble, cas d'usage, exemples
- ✅ **Changelog** - Historique modifications (si version > 1.0.0)
- ✅ **Examples** - Au moins 1 exemple concret dans prompt.md

### Par team
- ✅ **Team README** - Description team, agents membres
- ✅ **Standards spécifiques** - Si applicable au domaine

### Globale
- ✅ **agents_index.yaml** - Catalogue tous agents
- ✅ **intents.yaml** - Catalogue tous intents
- ✅ **teams.yaml** - Catalogue toutes teams

---

## 🔄 Processus de création

### 1. Analyse besoin
- Comprendre objectif métier
- Identifier domaine (IT, CONSTRUCTION, EDU, META)
- Déterminer inputs/outputs requis

### 2. Design agent
- Nommer selon conventions
- Assigner à team appropriée
- Définir 3-5 intents pertinents

### 3. Génération fichiers
- **agent.yaml** - Métadonnées conformes
- **contract.yaml** - Contract I/O détaillé
- **prompt.md** - Prompt unique et spécifique

### 4. Validation
- YAML 100% valide
- Prompt unique (pas copier-coller)
- Au moins 1 exemple concret
- Alignment prompt ↔ contract
- Quality score ≥ 9/10

### 5. Documentation
- README.md créé
- Exemples fournis
- Ajout à agents_index.yaml

---

## 🎓 Best Practices

### DO ✅
- Créer prompts UNIQUES spécifiques au domaine
- Fournir exemples concrets et réalistes
- Aligner parfaitement prompt et contract
- Valider YAML avant commit
- Documenter décisions et assumptions
- Utiliser intents du catalogue existant
- Tester agent avec cas réels

### DON'T ❌
- Copier-coller templates génériques
- Créer prompts "MODE MACHINE" identiques
- Omettre exemples
- Laisser inputs/outputs génériques
- Inclure données sensibles
- Ignorer guardrails
- Négliger validation YAML

---

## 📞 Contacts et support

### Escalation
- **Qualité < 7:** META-PromptMaster
- **YAML invalide:** META-AgentFactory
- **Sécurité/Compliance:** META-GouvernanceQA

### Documentation
- Catalogue agents: `00_REFERENCE_DATA/agents_index.yaml`
- Catalogue intents: `00_REFERENCE_DATA/intents.yaml`
- Catalogue teams: `00_REFERENCE_DATA/teams.yaml`

---

*Policies version 1.1 - root_IA v3*  
*Dernière révision: 2026-02-14*
