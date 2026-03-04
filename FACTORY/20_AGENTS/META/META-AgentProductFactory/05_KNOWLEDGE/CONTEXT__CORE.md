# CONTEXT CORE - root_IA v3

## 🎯 Vue d'ensemble

**root_IA v3** est un écosystème de **43 agents spécialisés** organisés en **7 équipes**, conçu pour supporter les opérations d'un **MSP IT** et d'une **entreprise de construction**.

**Version:** 3.0  
**Statut:** Production  
**Date création:** Février 2026  
**Architecture:** Multi-agent collaborative

---

## 📊 Statistiques globales

### Agents
- **Total agents:** 43
- **Actifs:** 39
- **En développement:** 4
- **Qualité moyenne:** 9.3/10

### Teams
- **TEAM__IT:** 28 agents (65%)
- **TEAM__CONSTRUCTION:** 8 agents (19%)
- **TEAM__EDU:** 3 agents (7%)
- **TEAM__META:** 4 agents (9%)
- **Autres teams:** 0 agents (en planification)

### Domaines couverts
- Infrastructure IT et cloud
- Gestion projets construction
- Formation et certification CCQ
- Création et gouvernance agents

---

## 🏗️ Architecture

### Structure organisationnelle

```
root_IA_v3/
├── FACTORY/                    # 41 agents création/génération
│   ├── META-AgentFactory
│   ├── META-PromptMaster
│   ├── META-GouvernanceQA
│   └── META-KnowledgePackBuilder
│
└── PRODUCTS/                   # 8 produits opérationnels
    ├── IT-MSP/                 # 28 agents IT
    ├── CONSTRUCTION/           # 8 agents construction
    ├── EDU-CCQ/                # 3 agents éducation
    └── [Autres products...]
```

### Philosophie architecturale

**Principes clés:**
1. **Spécialisation** - Chaque agent a un rôle unique et précis
2. **Réutilisabilité** - Knowledge Packs partagés entre agents similaires
3. **Qualité** - Quality score minimum 9/10
4. **Conformité** - YAML 100% valide, standards stricts
5. **Documentation** - Tout est documenté et traçable

**Anti-patterns évités:**
- ❌ Agents généralistes "fait tout"
- ❌ Prompts "MODE MACHINE" identiques
- ❌ Duplication de code/logique
- ❌ Manque de documentation
- ❌ Création ad-hoc sans standards

---

## 🔧 Domaines principaux

### 1. IT MSP (28 agents)

**Objectif:** Supporter les opérations d'un Managed Service Provider IT

**Sous-domaines:**
- **Cloud:** Azure, M365, Google Workspace, AWS
- **Infrastructure:** Serveurs Windows/Linux, virtualisation
- **Réseau:** Watchguard, Fortinet, switches
- **Backup:** VEEAM, Datto
- **Monitoring:** Supervision proactive
- **Sécurité:** Audits, conformité, incident response
- **Support:** Interventions, maintenance, documentation

**Outils standards:**
- ConnectWise (ticketing, documentation)
- PowerShell / Azure CLI / AWS CLI
- VMware vSphere / Hyper-V Manager
- VEEAM Backup & Replication / Datto
- Azure Portal / M365 Admin Center
- Google Workspace Admin Console

**Agents clés:**
- IT-CloudMaster - Expert cloud multi-plateforme
- IT-MaintenanceMaster - Assistant maintenance avec génération ConnectWise
- IT-BackupSpecialist - Spécialiste VEEAM/Datto
- IT-NetworkSpecialist - Expert réseau et firewall
- IT-SecurityAuditor - Auditeur sécurité

### 2. Construction (8 agents)

**Objectif:** Gérer projets construction et inspections conformes CCQ/RBQ

**Sous-domaines:**
- **Inspection:** Bâtiments résidentiels/commerciaux
- **Gestion projets:** Planification, suivi, coordination
- **Estimation:** Coûts, matériaux, main d'œuvre
- **Sécurité:** Chantiers, CNESST
- **Qualité:** Contrôle conformité CCQ/RBQ
- **Planification:** Séquences travaux, optimisation
- **Gestion matériel:** Inventaire, approvisionnement

**Standards appliqués:**
- Normes CCQ (Commission de la construction du Québec)
- Règlements RBQ (Régie du bâtiment du Québec)
- Code de construction du Québec
- Normes de sécurité CNESST

**Agents clés:**
- CONSTRUCTION-InspectionBatiment - Inspections conformité
- CONSTRUCTION-GestionProjet - Gestion projets
- CONSTRUCTION-EstimationCouts - Estimation budgets
- CONSTRUCTION-SecuriteChantier - Sécurité

### 3. Éducation CCQ (3 agents)

**Objectif:** Évaluation compétences et gestion formation métiers construction

**Sous-domaines:**
- **Évaluation:** Compétences selon référentiels CCQ
- **Formation:** Programmes techniques métiers
- **Certification:** Gestion processus certification CCQ
- **Développement:** Matériel pédagogique

**Standards appliqués:**
- Référentiels CCQ par métier (électricien, plombier, etc.)
- Normes d'apprentissage Emploi-Québec
- Standards certification professionnelle

**Agents clés:**
- EDU-EvaluationCCQ - Évaluation compétences
- EDU-FormationTechnique - Programmes formation
- EDU-CertificationCCQ - Gestion certifications

### 4. Meta & Gouvernance (4 agents)

**Objectif:** Créer, optimiser et gouverner l'écosystème root_IA

**Sous-domaines:**
- **Création agents:** Génération automatique agents conformes
- **Optimisation:** Amélioration prompts et contracts
- **Qualité:** Audits, validation, conformité
- **Knowledge Packs:** Création et maintenance
- **Standards:** Définition et application

**Responsabilités:**
- Maintenir quality score ≥ 9/10
- Assurer YAML 100% valide
- Éviter prompts génériques
- Documenter best practices
- Escalader problèmes qualité

**Agents clés:**
- META-AgentFactory - Générateur d'agents
- META-PromptMaster - Optimiseur prompts
- META-GouvernanceQA - Auditeur qualité
- META-KnowledgePackBuilder - Créateur Knowledge Packs

---

## 🛠️ Outils et technologies

### Ticketing et documentation
- **ConnectWise Manage** - Ticketing, time tracking, documentation
- **ConnectWise Automate** - RMM, monitoring, automation

### Infrastructure IT
- **Virtualisation:** VMware vSphere 8.0, Hyper-V Server 2022
- **Serveurs:** Windows Server 2019/2022, Ubuntu Server
- **Cloud:** Azure, AWS, Google Cloud Platform
- **SaaS:** Microsoft 365, Google Workspace

### Réseau
- **Firewalls:** Watchguard M-Series, Fortinet FortiGate
- **Switches:** Managed L2/L3
- **WiFi:** Enterprise-grade APs

### Backup et DR
- **VEEAM Backup & Replication** 12.x
- **Datto SIRIS** - Backup et disaster recovery
- **Azure Backup** - Cloud backup

### Automation
- **PowerShell** - Scripting Windows/Azure/M365
- **Azure CLI** - Gestion ressources Azure
- **AWS CLI** - Gestion ressources AWS
- **Terraform** - Infrastructure as Code

### Construction
- **Logiciels estimation** - Propriétaires secteur construction
- **Outils inspection** - Checklists CCQ/RBQ
- **Gestion projets** - Spécialisés construction

---

## 📋 Standards et conformité

### Qualité code
- **YAML validation:** 100% requis
- **Indentation:** 2 espaces (jamais tabs)
- **Encoding:** UTF-8 sans BOM
- **Line endings:** LF (Unix)

### Prompts
- **Unicité:** Pas de copier-coller générique
- **Exemples:** Minimum 1 par agent
- **Spécificité:** Instructions domaine-spécifiques
- **Alignment:** Prompt ↔ Contract 100%

### Sécurité
- ❌ Jamais credentials dans prompts/contracts
- ❌ Jamais données sensibles en clair
- ✅ Validation inputs/outputs
- ✅ Guardrails définis
- ✅ Respect RGPD/privacy

### Documentation
- ✅ README.md par agent
- ✅ Changelog si version > 1.0.0
- ✅ Exemples concrets fournis
- ✅ agents_index.yaml maintenu

---

## 🎓 Best Practices établies

### Création d'agents
1. **Analyser** besoin métier clairement
2. **Designer** agent spécifique (pas généraliste)
3. **Nommer** selon conventions strictes
4. **Générer** fichiers conformes (agent.yaml, contract.yaml, prompt.md)
5. **Valider** qualité ≥ 9/10
6. **Documenter** complètement
7. **Tester** avec cas réels

### Knowledge Packs
- Regrouper templates/runbooks/checklists par domaine
- Partager entre agents similaires (IT-CloudMaster, IT-MaintenanceMaster)
- Maintenir qualité et pertinence
- Versionner et documenter changements

### Escalation
- Quality score < 7 → META-PromptMaster
- YAML invalide → META-AgentFactory
- Risques compliance → META-GouvernanceQA

---

## 📈 Métriques de succès

### Globales
- **Quality score moyen:** 9.3/10 (target: ≥9/10) ✅
- **YAML valid:** 100% (target: 100%) ✅
- **Prompts uniques:** 95% (target: >90%) ✅
- **Documentation:** 98% (target: >95%) ✅

### Par team
- **TEAM__IT:** 9.2/10 moyenne
- **TEAM__CONSTRUCTION:** 9.5/10 moyenne
- **TEAM__EDU:** 9.4/10 moyenne
- **TEAM__META:** 9.1/10 moyenne

### Adoption
- **Agents actifs:** 39/43 (91%)
- **Usage quotidien:** ~120 interactions/jour
- **Satisfaction utilisateurs:** 4.7/5

---

## 🚀 Évolution et roadmap

### Complété (v3.0)
- ✅ 43 agents créés et documentés
- ✅ 4 teams opérationnelles
- ✅ Knowledge Packs IT-CloudMaster, IT-MaintenanceMaster
- ✅ Standards et politiques définis
- ✅ Catalogues (agents, intents, teams)

### En cours
- 🔄 META-PromptMaster (draft)
- 🔄 META-GouvernanceQA (draft)
- 🔄 META-KnowledgePackBuilder (draft)
- 🔄 Knowledge Pack META-AgentFactory

### Planifié (v3.1+)
- 📋 TEAM__OPS (orchestration workflows)
- 📋 TEAM__STRAT (intelligence d'affaires)
- 📋 TEAM__DOSSIER_IA (documentation système)
- 📋 Intégrations API externes
- 📋 Monitoring et analytics avancés

---

## 🌟 Principes directeurs

### Vision
Créer un écosystème d'agents IA hautement spécialisés qui augmentent la productivité et la qualité des services IT et construction.

### Mission
- Automatiser tâches répétitives
- Standardiser processus
- Améliorer qualité livrables
- Réduire temps réponse
- Documenter knowledge base

### Valeurs
- **Qualité** avant quantité
- **Spécialisation** avant généralisation
- **Standards** avant improvisation
- **Documentation** avant déploiement
- **Amélioration continue** toujours

---

## 📞 Support et contacts

### Documentation
- Catalogue agents: `00_REFERENCE_DATA/agents_index.yaml`
- Catalogue intents: `00_REFERENCE_DATA/intents.yaml`
- Catalogue teams: `00_REFERENCE_DATA/teams.yaml`
- Politiques: `00_REFERENCE_DATA/POLICIES__INDEX.md`

### Escalation
- Qualité: META-PromptMaster
- Technique: META-AgentFactory
- Compliance: META-GouvernanceQA

---

*Context Core version 1.0 - root_IA v3*  
*Dernière mise à jour: 2026-02-14*  
*Créé par: EA (Eric Archambault)*
