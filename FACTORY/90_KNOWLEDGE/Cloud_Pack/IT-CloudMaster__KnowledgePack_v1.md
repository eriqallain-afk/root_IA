# IT-CloudMaster — Knowledge Pack v1

> Pack complet cloud MSP : Azure, M365, Entra ID, gouvernance, commandes.

---

## 1. RÉFÉRENCE — Portails Admin Microsoft

| Service | URL | Rôle requis |
|---------|-----|------------|
| Microsoft 365 Admin | https://admin.microsoft.com | Global Admin / Exchange Admin |
| Azure Portal | https://portal.azure.com | Subscription Owner / Contributor |
| Entra ID (Azure AD) | https://entra.microsoft.com | Global Admin / User Admin |
| Exchange Online | https://admin.exchange.microsoft.com | Exchange Admin |
| Teams Admin | https://admin.teams.microsoft.com | Teams Admin |
| SharePoint Admin | https://[tenant]-admin.sharepoint.com | SharePoint Admin |
| Defender for O365 | https://security.microsoft.com | Security Admin |
| Intune / Endpoint | https://intune.microsoft.com | Intune Admin |
| Azure AD B2C | https://portal.azure.com → B2C tenant | Global Admin |
| Azure Cost Management | https://portal.azure.com → Cost Management | Cost Management Reader |

---

## 2. RUNBOOK — Onboarding Utilisateur M365

```
ONBOARDING UTILISATEUR M365
─────────────────────────────────────
INFORMATIONS REQUISES
[ ] Prénom / Nom
[ ] Titre / Département
[ ] Manager direct
[ ] Date de début
[ ] Licences requises (E3 / Business Premium / F1 / autre)
[ ] Groupes de sécurité à assigner
[ ] Partages réseau requis
[ ] Téléphone IP requis ?

CRÉATION COMPTE
1. Entra ID → Users → New user
2. Remplir : UPN / Nom / Usage location / Département / Manager
3. Assigner licence(s) via Groupe ou directement
4. Assigner MFA : Authentification → Policies → Require MFA
5. Ajouter aux groupes de sécurité (Entra ID → Groups)
6. Créer boîte Exchange (auto si licence assignée)
7. Configurer signature email (Exchange Admin → Rules)

ACCÈS SYSTÈMES
8. Active Directory On-Prem (si hybride) :
   - Créer user dans OU correcte
   - Groupes sécurité AD (partages, imprimantes)
   - Sync Entra Connect (si applicable)
9. ConnectWise : créer contact client (si technicien)

VALIDATION
[ ] Connexion M365 testée + MFA configuré
[ ] Email reçu et envoyé
[ ] Teams accès OK
[ ] SharePoint accès OK
[ ] OneDrive provisionné
[ ] Accès VPN configuré (si requis)

COMMUNICATION
→ Email de bienvenue avec instructions MFA
→ Informer manager (OPR/CommsMSP)
→ Mettre à jour CMDB (user + licence)
→ Documenter dans CW (ticket onboarding)
```

---

## 3. CHECKLIST — Configuration M365 Sécurité

```
SÉCURITÉ M365 — Baseline MSP
─────────────────────────────────────
ENTRA ID / IDENTITY
[ ] MFA obligatoire pour tous les utilisateurs (Conditional Access)
[ ] MFA obligatoire Admins (séparé — politique plus stricte)
[ ] Comptes admins dédiés (pas d'email sur compte admin)
[ ] Emergency access accounts configurés (2 comptes break-glass)
[ ] Privileged Identity Management (PIM) si P2
[ ] Rapport connexions risquées activé (Identity Protection)

CONDITIONAL ACCESS
[ ] Policy : Require MFA — All users — Cloud apps : All
[ ] Policy : Block Legacy Auth (SMTP/POP/IMAP)
[ ] Policy : Require compliant device (si Intune)
[ ] Policy : Block non-corporate countries (si applicable)

EXCHANGE ONLINE
[ ] SPF : v=spf1 include:spf.protection.outlook.com -all
[ ] DKIM activé (Exchange Admin → DKIM)
[ ] DMARC : v=DMARC1; p=quarantine; rua=mailto:dmarc@client.com
[ ] Anti-phishing policy configurée
[ ] Safe Links + Safe Attachments activés (Defender for O365)
[ ] Audit mailbox activé
[ ] Accès SMTP Auth désactivé (sauf exceptions documentées)

SHAREPOINT / ONEDRIVE
[ ] Partage externe désactivé ou limité (domaines approuvés)
[ ] Expiration liens anonymes : 7 jours max
[ ] Audit accès fichiers sensibles activé

INTUNE (si applicable)
[ ] Compliance policies configurées
[ ] Conditional access lié à conformité
[ ] Chiffrement BitLocker requis
[ ] PIN/Password requis mobile
```

---

## 4. COMMANDES — Azure PowerShell / Graph

```powershell
# Connexion
Connect-AzAccount                      # Azure
Connect-MgGraph -Scopes "User.Read.All", "Group.Read.All"  # Graph API

# Utilisateurs Entra ID
Get-MgUser -All | Select DisplayName, UserPrincipalName, AccountEnabled
Get-MgUser -Filter "Department eq 'IT'" | Select DisplayName, JobTitle

# Licences utilisateur
Get-MgUserLicenseDetail -UserId "user@domain.com" | Select SkuPartNumber

# Groupes
Get-MgGroup -All | Select DisplayName, GroupTypes, MembershipRule
Get-MgGroupMember -GroupId "group-id" | Select *

# Rapports connexions (90 derniers jours)
Get-MgAuditLogSignIn -Filter "createdDateTime ge 2026-01-01" | 
  Select UserDisplayName, AppDisplayName, Status, Location | 
  Export-Csv connexions.csv

# Azure VMs
Get-AzVM | Select Name, ResourceGroupName, Location, PowerState
Start-AzVM -Name "VM-PROD-01" -ResourceGroupName "RG-CLIENT"
Stop-AzVM -Name "VM-PROD-01" -ResourceGroupName "RG-CLIENT" -Force

# Coût Azure (30 derniers jours)
Get-AzConsumptionUsageDetail -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date) |
  Group-Object ResourceType | Select Name, @{N='Cost';E={($_.Group | Measure-Object PretaxCost -Sum).Sum}} |
  Sort Cost -Desc
```

---

## 5. GUIDE — Dépannage Azure/M365

### Utilisateur ne peut pas se connecter à M365

```
1. Vérifier compte actif : Entra ID → Users → [user] → Account status
2. Vérifier licence assignée : Licences → si manquante → assigner
3. Vérifier MFA : Authentication methods → si bloqué → reset MFA
4. Vérifier Conditional Access bloquant : Sign-in logs → raison blocage
5. Vérifier mot de passe : Reset si compromis ou expiré
6. Vérifier compte non verrouillé : Account enabled = Yes
7. Vérifier Entra Connect sync (si hybride) :
   Get-ADUser -Identity username | Select LockedOut, PasswordExpired
```

### Email non reçu

```
1. Vérifier boîte spam/quarantaine : security.microsoft.com → Email & collaboration → Review
2. Vérifier règles transport Exchange : Règle bloquante ?
3. Message Trace : Exchange Admin → Mail flow → Message trace
4. Vérifier MX records : nslookup -type=MX domaine.com
5. Vérifier SPF/DKIM : https://mxtoolbox.com/spf.aspx
6. Vérifier quota mailbox : Get-Mailbox user | Select ProhibitSendQuota
```

---

## 6. RÉFÉRENCE — Licences Microsoft (MSP)

| Licence | Principales features | Usage typique |
|---------|---------------------|--------------|
| **Microsoft 365 Business Basic** | Teams, Exchange, SharePoint (web only) | Utilisateurs légers |
| **Microsoft 365 Business Standard** | + Apps Office desktop | Utilisateurs bureautique |
| **Microsoft 365 Business Premium** | + Intune, Defender, Azure AD P1 | Standard MSP recommandé |
| **Microsoft 365 E3** | + Azure AD P1, Compliance basique | Grandes orgs |
| **Microsoft 365 E5** | + Defender avancé, Azure AD P2, Purview | Sécurité avancée |
| **Azure AD P1** | Conditional Access, PIM basique | Séparé si besoin |
| **Azure AD P2** | + Identity Protection, PIM complet | Haute sécurité |
| **Defender for Business** | EDR PME standalone | Si pas M365 BP |
| **Exchange Online Plan 1** | Email seulement (50 GB) | Boîtes mail simple |

---

## 7. KPIs CLOUD MSP

| KPI | Définition | Cible |
|-----|-----------|-------|
| **Licence Compliance** | % licences assignées / payées (ni sous ni sur) | ≤ 5% écart |
| **MFA Coverage** | % comptes avec MFA actif | 100% |
| **Secure Score M365** | Score sécurité Microsoft | ≥ 70% |
| **Conditional Access Coverage** | % users couverts par policies CA | 100% |
| **Azure Cost vs Budget** | Coût réel vs budget mensuel | ≤ 5% dépassement |
| **Uptime M365** | Disponibilité services M365 | ≥ 99.9% (SLA Microsoft) |

---

> Voir aussi : RUNBOOK__IT_CLOUD_ARCHITECTURE_V1.md | CHECKLIST__M365_Configuration.md
