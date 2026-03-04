# META-AgentFactory Knowledge Pack v1.0

## 🎯 Vue d'ensemble

Knowledge Pack complet pour META-AgentFactory permettant la création d'agents root_IA de haute qualité (score ≥9/10) conformes aux standards.

**Version:** 1.0  
**Date:** 2026-02-14  
**Status:** ✅ COMPLET et opérationnel

---

## 📦 Contenu (16 fichiers)

### 00_REFERENCE_DATA/ (5 fichiers) ✅

**Fichiers de référence essentiels**

1. **agents_index.yaml** - Catalogue 43 agents existants
   - 28 IT, 8 CONSTRUCTION, 3 EDU, 4 META
   - Éviter duplications
   - Suggérer agents similaires

2. **intents.yaml** - Catalogue 150+ intents
   - 9 catégories (generation, analysis, maintenance, etc.)
   - Patterns et conventions
   - Intents par domaine

3. **teams.yaml** - 7 teams disponibles
   - 4 actives (IT, CONSTRUCTION, EDU, META)
   - 3 planifiées (OPS, STRAT, DOSSIER_IA)
   - Domaines et outils par team

4. **POLICIES__INDEX.md** - Standards et politiques
   - Conventions nommage
   - Standards qualité (≥9/10)
   - Sécurité et compliance
   - Best practices DO/DON'T

5. **CONTEXT__CORE.md** - Contexte global root_IA v3
   - Architecture 43 agents
   - Domaines principaux
   - Outils et technologies
   - Métriques succès

---

### 01_TEMPLATES/ (3 fichiers) ✅

**Templates de génération d'agents**

1. **TEMPLATE__agent_yaml.md**
   - Structure standard
   - Règles remplissage détaillées
   - Exemples IT/CONSTRUCTION/META
   - Checklist validation
   - Anti-patterns

2. **TEMPLATE__contract_yaml.md**
   - Structure minimale et complète
   - Inputs SPÉCIFIQUES requis (pas génériques)
   - Outputs standards
   - Guardrails obligatoires
   - Exemples complets

3. **TEMPLATE__prompt_md.md** ⭐ CRITIQUE
   - Structure recommandée
   - Règles CRITIQUES (unique + exemples)
   - Exemples par type agent
   - Anti-patterns "MODE MACHINE"

---

### 02_RUNBOOKS/ (1 fichier) ✅

**Process de création d'agents**

1. **RUNBOOK__Create_Agent_From_Spec.md**
   - Process step-by-step complet
   - 8 étapes: Analyse → Vérification → Design → Génération → Validation
   - Gestion cas spéciaux
   - Temps estimé: 8-13 min/agent

---

### 03_CHECKLISTS/ (1 fichier) ✅

**Validation qualité**

1. **CHECKLIST__Agent_Completeness.md**
   - Validation agent.yaml (11 points)
   - Validation contract.yaml (20+ points)
   - Validation prompt.md (8 points)
   - Quality score (≥9/10)
   - Red flags (échecs automatiques)

---

### 04_EXAMPLES/ (1 fichier) ✅

**Exemples d'agents parfaits**

1. **EXAMPLE__IT-MaintenanceMaster.md**
   - Anatomie agent score 9.4/10
   - Pourquoi agent.yaml excellent
   - Pourquoi contract.yaml excellent
   - Pourquoi prompt.md excellent
   - Leçons DO/DON'T

---

## 🚀 Utilisation

### Créer un agent simple

```
User: Crée un agent qui génère des rapports hebdomadaires d'incidents IT

META-AgentFactory:
1. Consulte agents_index.yaml (vérifier si existe)
2. Consulte teams.yaml (TEAM__IT appropriée)
3. Consulte intents.yaml (choisir 3-5 intents)
4. Utilise TEMPLATE__agent_yaml.md
5. Utilise TEMPLATE__contract_yaml.md
6. Utilise TEMPLATE__prompt_md.md
7. Valide avec CHECKLIST__Agent_Completeness.md
8. Génère IT-WeeklyIncidentReporter

Output:
- agent.yaml ✓
- contract.yaml ✓
- prompt.md ✓
Quality score: 9.2/10
```

### Créer plusieurs agents (catalogue)

```
User: Crée 5 agents pour product IT-Monitoring:
- IT-ServerMonitor
- IT-NetworkMonitor  
- IT-BackupMonitor
- IT-SecurityMonitor
- IT-PerformanceMonitor

META-AgentFactory:
[Pour chaque agent]
1. Vérifier unicité (agents_index.yaml)
2. Designer selon domaine
3. Générer fichiers (templates)
4. Valider qualité (checklist)
5. Packager

Output: Bundle 5 agents + rapport génération
```

---

## ✅ Workflow complet

### Étape 1: Analyse
- Lire objective utilisateur
- Consulter CONTEXT__CORE.md (comprendre écosystème)
- Identifier domaine (IT, CONSTRUCTION, EDU, META)

### Étape 2: Vérification
- Consulter agents_index.yaml
- Vérifier si agent similaire existe
- Confirmer nom disponible

### Étape 3: Design
- Consulter teams.yaml (choisir team)
- Consulter intents.yaml (choisir 3-5 intents)
- Définir nom, description

### Étape 4: Génération agent.yaml
- Utiliser TEMPLATE__agent_yaml.md
- Appliquer POLICIES__INDEX.md (conventions)
- Générer fichier conforme

### Étape 5: Génération contract.yaml
- Utiliser TEMPLATE__contract_yaml.md
- Inputs SPÉCIFIQUES au domaine (pas data/info/stuff)
- Guardrails appropriés (min 2)

### Étape 6: Génération prompt.md
- Utiliser TEMPLATE__prompt_md.md
- Prompt UNIQUE (pas copier-coller)
- MINIMUM 1 exemple concret
- Alignment avec contract.yaml

### Étape 7: Validation
- Utiliser CHECKLIST__Agent_Completeness.md
- Vérifier quality score ≥9/10
- Vérifier YAML 100% valide
- Vérifier prompt unique

### Étape 8: Package
- Créer dossier agent/
- Copier 3 fichiers
- Générer rapport

---

## 🎯 Standards de qualité

### Obligatoires
- ✅ YAML 100% valide
- ✅ Prompts UNIQUES (pas MODE MACHINE)
- ✅ Min 1 exemple concret dans prompt.md
- ✅ Inputs SPÉCIFIQUES (pas génériques)
- ✅ Quality score ≥9/10

### Recommandés
- ✅ README.md par agent
- ✅ Knowledge Pack si agent complexe
- ✅ Tests de validation

---

## 📊 Métriques attendues

**Avec ce Knowledge Pack complet:**

- ⏱️ Temps création: 8-13 min/agent (vs 1h+ manuel)
- 🎯 Quality score: ≥9.0/10 (100% agents)
- ✅ YAML valid: 100%
- 🎨 Prompts uniques: >95%
- 🚫 Duplications: 0%
- 📚 Documentation: 100%

---

## 🔑 Fichiers CRITIQUES

### Les 3 plus importants ⭐

1. **TEMPLATE__prompt_md.md** - Éviter prompts génériques
2. **CHECKLIST__Agent_Completeness.md** - Validation qualité
3. **POLICIES__INDEX.md** - Standards conformité

### Consultés à chaque création

- agents_index.yaml (éviter duplications)
- intents.yaml (choisir intents)
- teams.yaml (assigner team)

---

## 💡 Exemples de création

### Exemple 1: Agent IT simple

**Input:**
```
Crée un agent qui diagnostique problèmes réseau (connectivité, firewall)
```

**Process:**
1. ✓ Domaine: IT
2. ✓ Team: TEAM__IT
3. ✓ Nom: IT-NetworkTroubleshooter
4. ✓ Intents: diagnose_connectivity, troubleshoot_firewall, analyze_network, generate_diagnostic_report
5. ✓ Générer 3 fichiers
6. ✓ Score: 9.3/10

### Exemple 2: Agent Construction

**Input:**
```
Crée agent pour estimer coûts projets résidentiels
```

**Process:**
1. ✓ Domaine: CONSTRUCTION
2. ✓ Team: TEAM__CONSTRUCTION
3. ✓ Nom: CONSTRUCTION-EstimationResidentielle
4. ✓ Intents: estimate_costs, calculate_materials, assess_labor, generate_quote
5. ✓ Inputs spécifiques: project_plans, square_footage, materials_list
6. ✓ Score: 9.1/10

---

## 🆘 Troubleshooting

**Problème:** Quality score < 9  
**Solution:** Vérifier prompt unique + exemples concrets présents

**Problème:** YAML invalide  
**Solution:** Vérifier indentation 2 espaces (pas tabs)

**Problème:** Prompt trop générique  
**Solution:** Consulter EXAMPLE__IT-MaintenanceMaster.md pour voir bon exemple

**Problème:** Inputs génériques (data, info)  
**Solution:** Redéfinir inputs spécifiques au domaine dans contract.yaml

---

## 📞 Escalation

**Quality score < 7:**
→ META-PromptMaster (refactoring prompt)

**YAML invalide récurrent:**
→ META-AgentFactory (correction automatique)

**Risques sécurité/compliance:**
→ META-GouvernanceQA (audit)

---

## 🎓 Best Practices

### DO ✅
- Consulter agents_index.yaml AVANT création
- Utiliser intents.yaml pour choisir intents
- Créer prompts UNIQUES avec exemples concrets
- Valider avec CHECKLIST avant packaging
- Inputs spécifiques au domaine

### DON'T ❌
- Copier-coller prompts génériques
- Créer sans vérifier duplications
- Omettre exemples dans prompt.md
- Utiliser inputs génériques (data, info, stuff)
- Ignorer quality score

---

## 📈 Roadmap

### v1.0 (actuel) ✅
- 5 fichiers référence
- 3 templates critiques
- 1 runbook création
- 1 checklist validation
- 1 exemple parfait

### v1.1 (futur)
- Runbook validation agent existant
- Template test_cases.yaml
- Exemples additionnels (CONSTRUCTION, EDU, META)
- Scripts validation automatique

---

*Knowledge Pack version 1.0 - META-AgentFactory*  
*Complet et opérationnel - 16 fichiers*  
*Quality target: ≥9/10 pour tous agents générés*
