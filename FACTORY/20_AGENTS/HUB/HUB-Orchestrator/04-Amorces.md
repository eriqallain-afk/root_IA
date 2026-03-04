# Amorces de conversation — HUB-Orchestrator

## 1. Exécution playbook standard

**« Exécute le playbook 'create_agent_complete' avec l'objectif : créer un agent de support IT niveau 1 pour tickets incidents »**

**Contexte**: Cas d'usage principal - orchestration workflow de création d'agent  
**Steps attendus**: Analyse besoin → Design rôle → Créer prompt → Build agent → QA  
**Output**: Agent créé + logs + quality score

---

## 2. Playbook multi-équipes avec priorité

**« Lance le playbook 'business_case_generation' en priorité HIGH avec deadline 2026-02-15 pour justifier investissement plateforme IA »**

**Contexte**: Urgence + contrainte temporelle + multi-équipes (IAHQ + META)  
**Particularité**: Priority high = moins de retry, escalade rapide si blocage  
**Output**: Business case + ROI + plan déploiement

---

## 3. Playbook avec contraintes strictes

**« Orchestre 'data_migration_secure' avec contraintes : sécurité niveau 3, conformité RGPD, validation juridique obligatoire »**

**Contexte**: Playbook sensible avec guardrails stricts  
**Particularité**: Chaque step nécessite validation conformité avant passage suivant  
**Output**: Migration ok + audit trail + certificat conformité

---

## 4. Mode debug avec override steps

**« Exécute 'optimize_existing_prompt' en mode DEBUG avec steps_override : skip validation QA initiale, aller direct à l'optimisation »**

**Contexte**: Mode avancé - modification séquence steps  
**Particularité**: Override permet sauter/réordonner steps (expert usage)  
**Output**: Prompt optimisé + logs verbeux debug

---

## 5. Playbook avec branches conditionnelles

**« Lance 'agent_deployment_pipeline' : si quality_score < 8 alors retry optimisation, sinon deploy direct »**

**Contexte**: Workflow conditionnel (if/then/else)  
**Particularité**: Décision automatique basée sur quality score step précédent  
**Output**: Agent déployé OU retour optimisation avec raison

---

## 6. Orchestration parallèle (si supporté)

**« Exécute 'multi_team_research' avec steps 2-4 en parallèle (équipes META, IAHQ, OPS travaillent simultanément) »**

**Contexte**: Gain temps - steps indépendants exécutés en même temps  
**Particularité**: Synchronisation à la fin avant compilation  
**Output**: Résultats agrégés de 3 équipes + timing optimisé

---

## 7. Gestion d'échec et retry

**« Que faire si le step 'META-GouvernanceQA' échoue après retry dans 'create_agent_complete' avec erreur : quality score 6.5 < 8 requis ? »**

**Contexte**: Edge case - échec après retry automatique  
**Réponse attendue**: Escalade vers HUB-AgentMO avec contexte complet  
**Output**: Escalation structurée + options (accepter 6.5, retravailler, changer agent)

---

## 8. Playbook avec ressources externes

**« Orchestre 'document_generation' avec resources : template_master.docx, brand_guidelines.pdf, data_export.csv »**

**Contexte**: Playbook nécessitant fichiers externes fournis  
**Particularité**: Vérifier présence resources avant démarrage, passer aux agents  
**Output**: Document final + références resources utilisées

---

## 9. Workflow incrémental avec sauvegardes

**« Lance 'long_analysis_pipeline' (durée estimée 2h) avec checkpoints toutes les 30 min »**

**Contexte**: Workflow long - besoin sauvegarde état intermédiaire  
**Particularité**: execution_context sauvegardé régulièrement (reprise possible)  
**Output**: Analyse complète + checkpoints intermédiaires

---

## 10. Guidance et aide

**« Explique-moi comment tu séquences les agents dans un playbook multi-équipes. Quelles validations tu fais ? »**

**Contexte**: Question méthodologie - comprendre fonctionnement  
**Réponse attendue**: 
- Protocole exécution (7 étapes)
- Validations inputs/outputs
- Gestion erreurs (retry + escalade)
- Exemple concret avec execution_log

---

## 11. BONUS - Création playbook à la volée

**« Crée et exécute un playbook ad-hoc : 1) Analyser besoin via IAHQ-BusinessAnalyst, 2) Créer prompt via META-PromptMaster, 3) Valider qualité via META-GouvernanceQA »**

**Contexte**: Playbook non prédéfini - création dynamique  
**Particularité**: HUB-Orchestrator génère playbook structure puis exécute  
**Output**: Playbook créé + exécuté + résultats

---

## 12. BONUS - Analyse post-mortem

**« Analyse l'exécution du playbook 'failed_deployment_xyz' (workflow_id: wf_2026-02-09_def456) : pourquoi a-t-il échoué ? »**

**Contexte**: Debug - analyse échec passé  
**Réponse attendue**: 
- Lecture execution_log
- Identification step failure
- Analyse root cause
- Recommandations corrections

---

**Note**: Ces amorces couvrent :
- ✅ Cas d'usage principaux (1, 2, 3)
- ✅ Modes avancés (4, 5, 6)
- ✅ Edge cases / erreurs (7)
- ✅ Features spécifiques (8, 9)
- ✅ Guidance / aide (10)
- ✅ Use cases bonus (11, 12)
