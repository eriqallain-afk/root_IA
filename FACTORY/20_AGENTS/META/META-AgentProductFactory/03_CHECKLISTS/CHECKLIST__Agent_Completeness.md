# CHECKLIST: Agent Completeness

## Vue d'ensemble
Utiliser cette checklist pour valider qu'un agent est complet, conforme et de qualité ≥9/10.

---

## 📋 AGENT.YAML

### Structure et format
- [ ] Fichier YAML 100% valide (yamllint passe)
- [ ] Indentation 2 espaces (jamais de tabs)
- [ ] Encoding UTF-8 sans BOM
- [ ] Line endings LF (Unix)

### Champs obligatoires
- [ ] `id` présent et valide
- [ ] `display_name` présent et valide
- [ ] `team_id` présent et valide
- [ ] `version` présent et valide
- [ ] `status` présent et valide
- [ ] `description` présent et valide
- [ ] `intents` présent et valide

### id
- [ ] Format `TEAM-NomAgent` (kebab-case)
- [ ] Pattern `^[A-Z]+-.+$` respecté
- [ ] Team prefix en UPPERCASE
- [ ] Nom agent en PascalCase
- [ ] Unique (pas dans agents_index.yaml)

**Exemples valides:** IT-CloudMaster, DAM-InspectionBatiment  
**Exemples invalides:** CloudMaster, it-cloudmaster, IT_CloudMaster

### display_name
- [ ] Format `@<id>` exactement
- [ ] Commence par `@`
- [ ] Correspond exactement à l'id

**Bon:** @IT-CloudMaster  
**Mauvais:** IT-CloudMaster, @CloudMaster

### team_id
- [ ] Format `TEAM__<UPPERCASE>`
- [ ] Pattern `^TEAM__[A-Z_]+$` respecté
- [ ] Team existe dans teams.yaml
- [ ] Approprié au domaine de l'agent

**Valides:** TEAM__IT, TEAM__CONSTRUCTION, TEAM__EDU, TEAM__META  
**Invalides:** TEAM_IT, IT, team__it

### version
- [ ] Format semantic versioning (X.Y.Z)
- [ ] Pattern `^\d+\.\d+\.\d+$` respecté
- [ ] Première version = 1.0.0

**Valides:** 1.0.0, 1.2.3, 2.0.0  
**Invalides:** 1.0, v1.0.0, 1.0.0-beta

### status
- [ ] Valeur dans: active, draft, deprecated, archived
- [ ] Nouveaux agents = active

### description
- [ ] Longueur 50-120 caractères
- [ ] 1 phrase claire et spécifique
- [ ] Pas générique ("Agent IT" ❌)
- [ ] Décrit vraiment ce que fait l'agent

**Bon:** "Expert cloud multi-plateforme (Azure, M365, Google, AWS)"  
**Mauvais:** "Agent IT", "Fait des choses"

### intents
- [ ] Contient 3-5 intents minimum
- [ ] Maximum 10 intents
- [ ] Format snake_case pour tous
- [ ] Pattern `^[a-z]+_[a-z_]+$` pour chaque intent
- [ ] Intents pertinents au domaine
- [ ] Pas de duplication
- [ ] Préférablement depuis intents.yaml

**Bons:** generate_report, troubleshoot_server, validate_compliance  
**Mauvais:** doStuff, handle-things, GENERATE_REPORT

---

## 📋 CONTRACT.YAML

### Structure et format
- [ ] Fichier YAML 100% valide
- [ ] Indentation 2 espaces
- [ ] Encoding UTF-8 sans BOM

### Champs obligatoires racine
- [ ] `schema_version` présent
- [ ] `agent` section présente
- [ ] `description` présent
- [ ] `mission` présent
- [ ] `responsibilities` présent
- [ ] `input` présent
- [ ] `output` présent
- [ ] `artifacts` présent
- [ ] `guardrails` présent
- [ ] `metrics` présent
- [ ] `success_criteria` présent

### schema_version
- [ ] Valeur = '1.1' (string, pas number)

### agent section
- [ ] `agent.id` correspond à agent.yaml
- [ ] `agent.team_id` correspond à agent.yaml
- [ ] `agent.status` correspond à agent.yaml

### description et mission
- [ ] `description` = résumé 1 ligne
- [ ] `mission` = mission détaillée
- [ ] Descriptions claires et spécifiques

### responsibilities
- [ ] Minimum 2 responsabilités
- [ ] Liste array de strings
- [ ] Responsabilités claires et actionnables

### INPUT - CRITIQUE ⚠️
- [ ] Input PAS générique (data, info, stuff ❌)
- [ ] Champs SPÉCIFIQUES au domaine
- [ ] Chaque champ a `type`
- [ ] Chaque champ a `required`
- [ ] Chaque champ a `description`
- [ ] Types appropriés (string, number, array, object, enum, etc.)

**Bon exemple IT:**
```yaml
input:
  server_name:
    type: string
    required: true
  maintenance_window:
    type: datetime
    required: true
```

**Mauvais exemple:**
```yaml
input:
  data: string
  info: object
```

### OUTPUT
- [ ] `output_format` défini (YAML_STRICT, JSON, MARKDOWN)
- [ ] `result` section présente
- [ ] `result.summary` type string
- [ ] `result.status` type enum avec valeurs définies
- [ ] `result.confidence` type number avec range 0..1
- [ ] `log` structure complète présente

### log structure
- [ ] `log.decisions` type array
- [ ] `log.risks` type array
- [ ] `log.assumptions` type array
- [ ] `log.quality_score` object présent
- [ ] `quality_score.overall` défini (0..10)
- [ ] `quality_score.clarity` défini (0..10)
- [ ] `quality_score.completeness` défini (0..10)
- [ ] `quality_score.compliance` défini (0..10)

### artifacts
- [ ] Minimum 1 artifact défini
- [ ] Chaque artifact a `type`
- [ ] Chaque artifact a `title`
- [ ] Chaque artifact a `path`
- [ ] Chaque artifact a `description`
- [ ] Chaque artifact a `required`
- [ ] `path` est nom fichier simple (PAS chemin Google Drive)

**Bon:** path: "report.md"  
**Mauvais:** path: "Mon Drive/EA_IA/root_IA/..."

### guardrails
- [ ] Minimum 2 guardrails
- [ ] Liste array de strings
- [ ] Guardrails spécifiques et actionnables
- [ ] Inclut sécurité ("Jamais exposer credentials")
- [ ] Inclut validation ("Valider inputs")

### metrics
- [ ] `quality_target` défini (≥ 9/10)
- [ ] Autres métriques si applicable

### success_criteria
- [ ] Minimum 2 critères
- [ ] Critères mesurables ou vérifiables

---

## 📋 PROMPT.MD

### Structure
- [ ] Titre avec nom agent et @id
- [ ] Section "Rôle" présente
- [ ] Section "Quand utiliser" ou "Instructions" présente
- [ ] Section "Exemples" présente
- [ ] Section "Contraintes" présente (optionnelle)

### Rôle
- [ ] Description UNIQUE de l'agent
- [ ] PAS de copier-coller générique
- [ ] Spécifique au domaine
- [ ] Utilise vocabulaire approprié

### Instructions
- [ ] Instructions claires et actionnables
- [ ] Spécifiques au rôle de l'agent
- [ ] Process step-by-step si applicable

### Exemples - CRITIQUE ⚠️
- [ ] **MINIMUM 1 exemple présent**
- [ ] Exemple montre Input ET Output
- [ ] Exemple est concret et réaliste
- [ ] Exemple pas trop simple ou fictif
- [ ] Input utilise données réalistes
- [ ] Output montre résultat détaillé

**Bon exemple:**
```
Input:
```
Server SRV-SQL01 - Event ID 7000
Service MSSQLSERVER failed to start
```

Output:
```
Diagnostic: SQL service dependencies
Commandes:
Get-Service MSSQLSERVER | Select RequiredServices
[Procédure détaillée...]
```
```

**Mauvais exemple:**
```
Input: Problème serveur
Output: Vérifier les logs
```

### Alignment avec contract.yaml
- [ ] Même terminologie utilisée
- [ ] Inputs correspondent au contract
- [ ] Outputs correspondent au contract
- [ ] Pas de divergence

### Unicité - CRITIQUE ⚠️
- [ ] Prompt N'EST PAS un copier-coller d'autre agent
- [ ] Instructions SPÉCIFIQUES à ce domaine
- [ ] Exemples UNIQUES à cet agent
- [ ] Pas de "MODE MACHINE" générique

**MODE MACHINE interdit:**
```markdown
Tu es un agent expert. Tu aides l'utilisateur.
Réponds aux questions avec professionnalisme.
```

---

## 📊 QUALITY SCORE

### Overall Quality
- [ ] Quality score ≥ 9.0/10

### Clarity (≥ 9/10)
- [ ] Instructions claires
- [ ] Terminologie cohérente
- [ ] Process bien défini

### Completeness (≥ 8/10)
- [ ] Tous champs obligatoires présents
- [ ] Exemples fournis
- [ ] Documentation suffisante

### Compliance (10/10)
- [ ] YAML 100% valide
- [ ] Conventions nommage respectées
- [ ] Standards root_IA appliqués
- [ ] Pas de données sensibles

### Timeliness (≥ 8/10)
- [ ] Pertinent au besoin actuel
- [ ] Pas obsolète
- [ ] Technologies/outils actuels

---

## ✅ VALIDATION FINALE

### Tests de base
- [ ] yamllint agent.yaml (0 erreurs)
- [ ] yamllint contract.yaml (0 erreurs)
- [ ] Markdown prompt.md valide

### Vérifications croisées
- [ ] agent.id = contract.agent.id
- [ ] agent.team_id = contract.agent.team_id
- [ ] agent.status = contract.agent.status
- [ ] Terminologie alignée agent ↔ contract ↔ prompt

### Unicité
- [ ] Agent pas dupliqué dans agents_index.yaml
- [ ] Prompt unique (pas copier-coller)
- [ ] Valeur ajoutée claire vs agents existants

### Documentation
- [ ] README.md créé (optionnel mais recommandé)
- [ ] Exemples concrets fournis
- [ ] Cas d'usage documentés

---

## 🚨 RED FLAGS (Échec automatique)

### ❌ YAML invalide
Si yamllint échoue → Agent rejeté

### ❌ Prompt générique "MODE MACHINE"
Si prompt est copier-coller générique → Agent rejeté

### ❌ Pas d'exemples
Si prompt.md n'a aucun exemple → Agent rejeté

### ❌ Inputs génériques
Si contract.yaml a data/info/stuff → Agent rejeté

### ❌ Quality score < 7
Si overall < 7/10 → Escalade META-PromptMaster

### ❌ Données sensibles
Si credentials/secrets présents → Agent rejeté immédiatement

---

## 📈 SCORING

```yaml
quality_score:
  overall: [0-10]  # Moyenne pondérée
  clarity: [0-10]  # Instructions claires?
  completeness: [0-10]  # Tout présent?
  compliance: [0-10]  # Standards respectés?
  timeliness: [0-10]  # Pertinent et actuel?
```

**Calcul overall:**
- clarity × 30%
- completeness × 25%
- compliance × 30%
- timeliness × 15%

**Target: ≥ 9.0/10**

---

*Checklist version 1.0 - META-AgentFactory*  
*Utiliser pour validation avant packaging agent*
