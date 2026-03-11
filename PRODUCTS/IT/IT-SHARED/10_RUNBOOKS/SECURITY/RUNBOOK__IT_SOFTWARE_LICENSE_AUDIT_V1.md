# RUNBOOK — Audit Licences Logicielles (SAM) MSP
**ID :** RUNBOOK__IT_SOFTWARE_LICENSE_AUDIT_V1  
**Version :** 1.0 | **Agent :** IT-SoftwMaster  
**Applicable :** Audit SAM trimestriel ou à la demande client

---

## DÉCLENCHEURS
- Audit SAM trimestriel planifié
- Départ employé / restructuration
- Nouveau client onboardé
- Alerte audit éditeur (Microsoft, Adobe, Oracle)
- Suspicion over-deployment ou shadow IT

---

## ÉTAPE 1 — COLLECTE INVENTAIRE LOGICIEL

### Via RMM (N-able / ConnectWise RMM) :
- Rapport "Installed Software" par client/site
- Filtrer par catégorie : OS, Office, sécurité, métier, utilitaires

### Via PowerShell (manuel si RMM indisponible) :
```powershell
# Inventaire logiciels installés (toutes architectures)
$Software = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
    Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
    Where-Object DisplayName -ne $null

$Software32 = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
    Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
    Where-Object DisplayName -ne $null

$All = ($Software + $Software32) | Sort-Object Publisher, DisplayName -Unique
$All | Export-Csv "C:\TEMP\Software_Inventory_$(Get-Date -Format 'yyyyMMdd').csv" -NoTypeInformation
```

### Microsoft 365 — via PowerShell :
```powershell
# Licences M365 utilisées vs disponibles
Connect-MsolService
Get-MsolAccountSku | Select-Object AccountSkuId, ActiveUnits, ConsumedUnits, 
    @{N='Available';E={$_.ActiveUnits - $_.ConsumedUnits}} | Format-Table
```

---

## ÉTAPE 2 — ANALYSE CONFORMITÉ

### 2.1 Matrice à compléter par éditeur :

| Logiciel | Licences achetées | Installs détectées | Delta | Statut |
|----------|------------------|--------------------|-------|--------|
| Windows Server | X | X | ±X | ✅/⚠️/🔴 |
| Microsoft 365 | X | X | ±X | ✅/⚠️/🔴 |
| Adobe Creative | X | X | ±X | ✅/⚠️/🔴 |
| Antivirus/EDR | X | X | ±X | ✅/⚠️/🔴 |

**Statut :** ✅ Conforme | ⚠️ Sous-licencié (<10%) | 🔴 Non conforme (>10% over)

### 2.2 Identifier :
- Logiciels sans licence connue → shadow IT → escalade IT-SecurityMaster
- Licences expirées → renouvellement urgent
- Logiciels en EOL non remplacés → risque sécurité

### 2.3 Microsoft specifics :
- Vérifier type licence : M365 Business vs Enterprise, CAL type (Device/User)
- SQL Server : vérifier Core vs CAL licensing
- Remote Desktop : RDS CAL count vs utilisateurs concurrents
- Confirme SA (Software Assurance) si applicable

---

## ÉTAPE 3 — OPTIMISATION

### Récupérer licences inutilisées :
```powershell
# M365 : comptes sans activité depuis 90 jours
$cutoff = (Get-Date).AddDays(-90)
Get-MsolUser -All | Where-Object { $_.LastDirSyncTime -lt $cutoff -and $_.isLicensed } |
    Select-Object UserPrincipalName, LastDirSyncTime, Licenses
```

### Actions optimisation :
1. Désactiver comptes inactifs > 90 jours → libérer licences
2. Désinstaller logiciels non utilisés (usage < 2x/an)
3. Regrouper licences (consolidation éditeur)
4. Négocier volume si croissance prévue

---

## ÉTAPE 4 — RAPPORT ET RECOMMANDATIONS

### Rapport SAM à produire via IT-ReportMaster :
- Tableau conformité par éditeur
- Économies potentielles identifiées (€/$/mois)
- Risques non-conformité (pénalités estimées si audit)
- Plan d'action : 30/60/90 jours

### Livrables CW :
- Note interne : résultats audit complets
- Discussion client : résumé + recommandations (sans données sensibles)
- Créer tickets pour chaque action requise

---

## ÉTAPE 5 — MISE À JOUR CMDB

- [ ] Mettre à jour IT-AssetMaster : licences actualisées
- [ ] Documenter contrats de maintenance et dates de renouvellement
- [ ] Programmer prochaine revue (trimestrielle recommandée)
- [ ] Alertes créées pour renouvellements à venir (60 jours avant)
