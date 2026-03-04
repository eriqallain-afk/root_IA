# TEMPLATE: contract.yaml

## Structure minimale requise

```yaml
schema_version: '1.1'
agent:
  id: <TEAM-AgentName>
  team_id: TEAM__<TEAM>
  status: active

description: "<Résumé 1 ligne ce que fait l'agent>"
mission: "<Mission détaillée de l'agent>"

responsibilities:
  - "<Responsabilité 1>"
  - "<Responsabilité 2>"
  - "<Responsabilité 3>"

input:
  field_1:
    type: string
    required: true
    description: "<Description claire du champ>"
  field_2:
    type: object
    required: false
    description: "<Description>"

output:
  output_format: YAML_STRICT
  result:
    summary:
      type: string
      description: "Résumé 1-3 lignes"
    status:
      type: enum(ok,needs_clarification,partial,error)
      description: "Statut d'exécution"
    confidence:
      type: number
      range: 0..1
      description: "Confiance (0-1)"

artifacts:
  - type: md|yaml|pdf|zip
    title: "<Titre artifact>"
    path: "<nom_fichier.ext>"
    description: "<Description>"
    required: true|false

guardrails:
  - "Contrainte 1 (ex: Jamais exposer credentials)"
  - "Contrainte 2 (ex: Valider inputs avant traitement)"

metrics:
  quality_target: ≥ 9/10

success_criteria:
  - "Critère 1"
  - "Critère 2"

log:
  decisions: array<string>
  risks: array<string>
  assumptions: array<string>
  quality_score:
    overall: number (0..10)
    clarity: number (0..10)
    completeness: number (0..10)
    compliance: number (0..10)
```

---

## Champs obligatoires

### Metadata
- ✅ `schema_version: '1.1'` (toujours)
- ✅ `agent.id` et `agent.team_id`
- ✅ `description` et `mission`
- ✅ `responsibilities` (min 2)

### Input/Output
- ✅ `input` structure SPÉCIFIQUE (pas générique)
- ✅ `output.output_format`
- ✅ `output.result` avec `status` et `confidence`
- ✅ `log` structure complète

### Governance
- ✅ `artifacts` (min 1)
- ✅ `guardrails` (min 2)
- ✅ `metrics` et `success_criteria`

---

## Input: Règles CRITIQUES

### ❌ Inputs INTERDITS (trop génériques)

```yaml
input:
  data: string            # Trop vague
  info: object           # Pas spécifique
  stuff: any             # Inutile
  request: string        # Générique
```

### ✅ Inputs REQUIS (spécifiques au domaine)

**IT Agent:**
```yaml
input:
  server_name:
    type: string
    required: true
    description: "Nom du serveur à patcher"
  maintenance_window:
    type: datetime
    required: true
    description: "Fenêtre de maintenance (ISO 8601)"
  backup_verification:
    type: boolean
    required: false
    default: true
```

**Construction Agent:**
```yaml
input:
  building_address:
    type: string
    required: true
  inspection_type:
    type: enum(pre-construction,mid-construction,final)
    required: true
  ccq_standards:
    type: array<string>
    required: true
    description: "Normes CCQ applicables"
```

**META Agent:**
```yaml
input:
  agent_spec:
    type: object
    required: true
    fields:
      team: string
      role: string
      description: string
  validation_level:
    type: enum(basic,standard,strict)
    required: false
    default: standard
```

---

## Output: Structure standard

```yaml
output:
  output_format: YAML_STRICT|JSON|MARKDOWN
  result:
    summary: string (1-3 lignes)
    status: enum(ok,needs_clarification,partial,error)
    confidence: number (0-1)
    # Champs spécifiques au domaine...
    
  artifacts:
    type: array<object>
    description: "Liste artefacts produits"
    
  next_actions:
    type: array<object>
    item_schema:
      action: string
      when: string
      questions: array<string> (optional)
    
  log:
    decisions: array<string>
    risks: array<string>
    assumptions: array<string>
    quality_score:
      overall: number (0..10)
      clarity: number (0..10)
      completeness: number (0..10)
      compliance: number (0..10)
```

---

## Artifacts

### Types supportés
- `md` - Markdown
- `yaml` - YAML
- `json` - JSON
- `pdf` - PDF
- `zip` - Archive
- `html` - HTML
- `docx` - Word (si applicable)

### Paths
**Recommandé:** Nom fichier simple (pas chemin Google Drive)
```yaml
artifacts:
  - type: yaml
    title: "agent.yaml généré"
    path: "agent.yaml"
    description: "Métadonnées de l'agent"
    required: true
```

**Éviter:**
```yaml
path: "Mon Drive/EA_IA/root_IA/..." # ❌ Inaccessible
```

---

## Guardrails obligatoires

**Minimum 2 guardrails, recommandé 4-5:**

```yaml
guardrails:
  - "Jamais exposer credentials ou données sensibles"
  - "Valider tous inputs avant traitement"
  - "Respecter RGPD/privacy si données personnelles"
  - "Ne jamais exécuter commandes destructives sans confirmation"
  - "Maintenir alignment prompt ↔ contract"
```

---

## Exemples complets

### IT Agent

```yaml
schema_version: '1.1'
agent:
  id: IT-PatchingCoordinator
  team_id: TEAM__IT
  status: active

description: "Coordonne patching serveurs Windows selon fenêtres maintenance"
mission: "Automatiser et sécuriser le processus de patching mensuel"

responsibilities:
  - "Planifier fenêtres de maintenance avec clients"
  - "Exécuter patching selon ordre priorité"
  - "Valider succès et générer rapports"

input:
  servers:
    type: array<string>
    required: true
    description: "Liste serveurs à patcher"
  maintenance_window:
    type: datetime
    required: true
  auto_reboot:
    type: boolean
    required: false
    default: false

output:
  output_format: YAML_STRICT
  result:
    summary: string
    status: enum(ok,partial,error)
    confidence: number
    servers_patched: array<string>
    failures: array<object>

artifacts:
  - type: md
    title: "Rapport patching"
    path: "patching_report.md"
    required: true

guardrails:
  - "Jamais reboot sans confirmation si auto_reboot=false"
  - "Vérifier backup avant patching"
  - "Respecter ordre: non-critiques → critiques → DC"

metrics:
  quality_target: ≥ 9/10
  success_rate: ≥ 95%

success_criteria:
  - "Tous serveurs patchés ou erreurs documentées"
  - "Aucun downtime non planifié"
```

### Construction Agent

```yaml
schema_version: '1.1'
agent:
  id: CONSTRUCTION-EstimationCouts
  team_id: TEAM__CONSTRUCTION
  status: active

description: "Estimation coûts projets construction selon plans et spécifications"
mission: "Fournir estimations précises pour soumissions"

input:
  project_plans:
    type: array<file>
    required: true
  project_type:
    type: enum(residential,commercial,industrial)
    required: true
  materials_list:
    type: array<object>
    required: false

output:
  output_format: YAML_STRICT
  result:
    summary: string
    status: enum(ok,needs_clarification,partial,error)
    confidence: number
    total_estimate: number
    breakdown: object

artifacts:
  - type: pdf
    title: "Soumission détaillée"
    path: "estimate.pdf"
    required: true

guardrails:
  - "Toujours inclure marge erreur (±10-15%)"
  - "Vérifier prix matériaux récents"

success_criteria:
  - "Estimation dans marge ±15% coûts réels"
```

---

## Checklist validation

- [ ] `schema_version: '1.1'`
- [ ] `agent.id` et `agent.team_id` valides
- [ ] Inputs SPÉCIFIQUES (pas data, info, stuff)
- [ ] Output avec `status` et `confidence`
- [ ] Au moins 1 artifact
- [ ] Au moins 2 guardrails
- [ ] `log` structure complète
- [ ] Alignment avec prompt.md

---

## Anti-patterns

❌ **Inputs génériques:**
```yaml
input:
  data: string
  parameters: object
```

❌ **Pas de guardrails:**
```yaml
# Manque section guardrails
```

❌ **Artifacts avec chemins inaccessibles:**
```yaml
path: "Mon Drive/EA_IA/..." # ❌
```

❌ **Output sans structure:**
```yaml
output:
  result: object  # ❌ Pas assez défini
```

---

*Template version 1.0 - META-AgentFactory*
