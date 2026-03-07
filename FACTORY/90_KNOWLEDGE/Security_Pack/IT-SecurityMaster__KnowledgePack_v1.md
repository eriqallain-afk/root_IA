# IT-SecurityMaster — Knowledge Pack v1

> Pack complet de référence pour l'agent IT-SecurityMaster.
> Couvre : triage alertes SOC, frameworks, remédiations, conformité, comms.

---

## 1. MATRICE DE TRIAGE — Alertes Sécurité

| Catégorie | Sévérité | Délai réponse | Action immédiate |
|-----------|----------|---------------|-----------------|
| Ransomware / chiffrement actif | S0 CRITIQUE | < 5 min | Isoler machine(s), couper réseau, alerter CTO |
| Compromission compte admin | S0 CRITIQUE | < 5 min | Désactiver compte AD, révoquer sessions |
| Exfiltration données active | S0 CRITIQUE | < 10 min | Bloquer IP dest, couper accès, CTO + légal |
| Brute force actif (> 50 tentatives) | S1 HIGH | < 15 min | Bloquer IP source, vérifier logs auth |
| Malware détecté (non actif) | S1 HIGH | < 30 min | Quarantaine, scan complet, analyse |
| Vulnérabilité critique (CVE CVSS ≥ 9) | S1 HIGH | < 24h | Patch disponible ? → RFC urgent |
| Connexion géographique anormale | S2 MEDIUM | < 2h | Vérifier avec utilisateur, MFA review |
| Port scan externe | S2 MEDIUM | < 4h | Vérifier firewall + logs, bloquer si répété |
| Politique MFA non respectée | S3 LOW | < 48h | Ticket conformité + rapport OPR |
| CVE sévérité moyenne (CVSS 7-8) | S3 LOW | < 72h | Planifier patch cycle normal |

---

## 2. CHECKLIST — Triage Initial SOC

```
ALERTE REÇUE — Étapes obligatoires
─────────────────────────────────────
[ ] 1. Identifier la source (SIEM / EDR / AV / Firewall / RMM)
[ ] 2. Qualifier : Vrai positif / Faux positif / Indéterminé
[ ] 3. Évaluer le scope : 1 machine / réseau / tenant / multi-clients
[ ] 4. Chercher les IOC associés (hash, IP, domaine, user)
[ ] 5. Vérifier les logs corrélés (event 4625/4624, DNS, netflow)
[ ] 6. Classifier sévérité (S0/S1/S2/S3) → Severity Matrix
[ ] 7. Déclencher escalade si S0/S1 → NOC + CTO
[ ] 8. Documenter dans CW (note interne)
[ ] 9. Appliquer containment si compromission confirmée
```

---

## 3. PLAYBOOK — Réponse Ransomware

```
ALERTE RANSOMWARE — PROCÉDURE URGENTE
─────────────────────────────────────
PHASE 1 — CONTAINMENT (< 5 min)
  1. Isoler machine(s) affectée(s) du réseau (désactiver NIC via RMM)
  2. Couper les partages réseau accédés par la machine
  3. Identifier le compte utilisateur actif → Désactiver dans AD
  4. Alerter CTO + Direction immédiatement
  5. NE PAS redémarrer la machine (préserver preuves forensiques)

PHASE 2 — ANALYSE (< 30 min)
  6. Identifier le vecteur d'entrée (email phishing / RDP / vulnérabilité)
  7. Chercher les IOC : extensions chiffrées, ransom note, processus actifs
  8. Vérifier si d'autres machines sont atteintes (scan RMM)
  9. Déterminer scope chiffrement : quels fichiers / serveurs / backups

PHASE 3 — ÉRADICATION (avec INFRA)
  10. Supprimer le malware identifié (EDR + scan manuel)
  11. Révoquer toutes les sessions AD du compte compromis
  12. Changer mots de passe admin locaux et AD (tous les comptes à risque)
  13. Patcher la vulnérabilité d'entrée (RFC urgent)

PHASE 4 — RESTAURATION (avec INFRA + BackupDRMaster)
  14. Valider intégrité des backups (Veeam / Datto)
  15. Restaurer depuis dernier backup sain (avant chiffrement)
  16. Valider restauration poste par poste
  17. Monitoring renforcé 72h post-restauration

PHASE 5 — POST-INCIDENT
  18. Post-mortem obligatoire (SecurityMaster + TECH + CTO)
  19. Rapport client (OPR/CommsMSP)
  20. Notification légale si données personnelles exposées
  21. Mise à jour CMDB + KB article
```

---

## 4. RÉFÉRENCE — CVE & Vulnérabilités

### Priorité de patching MSP

| CVSS Score | Délai patch | Type |
|-----------|------------|------|
| 9.0 – 10.0 (CRITIQUE) | < 24h (urgence) | RFC urgent |
| 7.0 – 8.9 (HIGH) | < 72h | RFC express |
| 4.0 – 6.9 (MEDIUM) | Prochain cycle patching (≤ 30j) | Planifié |
| < 4.0 (LOW) | Cycle trimestriel | Planifié |

### Sources CVE à surveiller
- NVD : https://nvd.nist.gov/vuln/search
- CISA KEV : https://www.cisa.gov/known-exploited-vulnerabilities-catalog
- Microsoft Security Updates : https://msrc.microsoft.com/update-guide/
- FortiGuard : https://www.fortiguard.com/psirt

---

## 5. CHECKLIST — Audit Conformité MSP

```
AUDIT SÉCURITÉ CLIENT — Vérifications
─────────────────────────────────────
IDENTITÉ & ACCÈS
[ ] MFA activé pour tous les comptes admin (Azure AD / M365)
[ ] MFA activé pour accès VPN
[ ] Comptes admin dédiés (pas d'usage dual admin/user)
[ ] Comptes de service avec mots de passe forts + rotation
[ ] Revue des accès privilegiés (dernier audit < 90 jours)
[ ] Conditonal Access policies actives

ENDPOINTS
[ ] EDR déployé sur 100% des endpoints
[ ] Windows Defender activé + signatures à jour
[ ] BitLocker activé (postes portables minimum)
[ ] Patches OS à jour (< 30 jours retard max)

RÉSEAU
[ ] Firewall périmètre à jour (firmware + règles)
[ ] RDP non exposé sur Internet
[ ] VPN avec MFA
[ ] Segmentation réseau (VLAN admin / users / IoT)
[ ] DNS filtering actif

BACKUP & DR
[ ] Backup quotidien validé (Veeam / Datto)
[ ] Test restauration < 90 jours
[ ] Backup offline / immuable disponible

EMAIL
[ ] SPF + DKIM + DMARC configurés
[ ] Anti-phishing Microsoft Defender for Office 365
[ ] Macro Office désactivée pour sources non approuvées
```

---

## 6. COMMUNICATION — Templates Sécurité

### Notification incident sécurité (client)
```
Sujet : [URGENT - Sécurité] Action requise — {Client}

Bonjour {Contact},

Notre équipe a détecté une activité anormale sur votre environnement.

SITUATION : {Description en 1 phrase, sans détails techniques qui risquent}
ÉTAT ACTUEL : {Containment appliqué / En cours d'investigation}
IMPACT : {Ce qui est/était affecté}
VOTRE ACTION : {Action requise du client, si applicable}

Nous vous tiendrons informé toutes les {30/60} minutes.
Un rapport complet suivra dans les 24h.

Contact direct : {Nom} — {Téléphone}
```

### Rapport post-incident sécurité (synthèse client)
```
RAPPORT SÉCURITÉ — {Date}
─────────────────────────────────────
ÉVÉNEMENT : {Titre}
PÉRIODE : {Début} → {Fin}
IMPACT : {Description impact utilisateurs/données}

CAUSE : {Explication non-technique}
ACTIONS EFFECTUÉES : {Ce que MSP a fait}
RÉSULTAT : {Service restauré / Aucune donnée compromise / etc.}

MESURES PRÉVENTIVES MISES EN PLACE :
1. {Action 1}
2. {Action 2}

RECOMMANDATIONS ADDITIONNELLES :
→ {Recommandation 1} — Priorité : {Haute/Moyenne}
→ {Recommandation 2}
```

---

## 7. GLOSSAIRE SÉCURITÉ

| Terme | Définition |
|-------|-----------|
| **IOC** | Indicator of Compromise — preuve de compromission (IP, hash, domaine) |
| **EDR** | Endpoint Detection & Response — solution détection/réponse sur endpoints |
| **SIEM** | Security Information & Event Management — corrélation logs/alertes |
| **CVE** | Common Vulnerabilities & Exposures — identifiant vulnérabilité publique |
| **CVSS** | Common Vulnerability Scoring System — score gravité CVE (0-10) |
| **MFA** | Multi-Factor Authentication — authentification multi-facteurs |
| **Lateral movement** | Déplacement d'un attaquant dans le réseau après entrée initiale |
| **C2 / C&C** | Command & Control — serveur contrôlant un malware |
| **Exfiltration** | Vol/extraction de données vers l'extérieur |
| **RBAC** | Role-Based Access Control — contrôle accès par rôles |
| **Zero Trust** | Modèle sécurité : ne jamais faire confiance, toujours vérifier |
| **Threat Intelligence** | Renseignement sur les menaces actives (IOC, TTPs) |

---

> Voir aussi : IT__Severity_Matrix.md | RUNBOOK__IT_SECURITY_ALERT_TRIAGE_V1.md
