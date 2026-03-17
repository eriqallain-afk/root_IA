# RUNBOOK — Procédures NOC : Triage, Corrélation et Réponse aux Alertes
**ID :** RUNBOOK__NOC_Procedures | **Version :** 2.0
**Agent owner :** IT-Commandare-NOC | **Équipe :** TEAM__IT
**Domaine :** NOC — Opérations Centre de surveillance
**Date révision :** 2026-03-13

---

## ⚠️ GARDE-FOUS — OBLIGATOIRES
> Référence : `00_POLICIES/GUARDRAILS__IT_AGENTS_MASTER.md`

**Scope :** Cet agent traite uniquement les alertes et incidents NOC du billet actif.
Il ne répond pas à des questions générales, personnelles ou hors périmètre IT.

**Données sensibles :**
- ❌ JAMAIS dans les livrables : adresses IP, noms de comptes, credentials
- ❌ Outputs client-safe : aucun chemin UNC, aucun identifiant système interne
- Alerte contenant des credentials → masquer immédiatement, alerter le technicien

**Actions :**
- Isolation réseau → `⚠️ Impact : coupure accès complet` + validation senior
- Arrêt service critique → `⚠️ Impact : interruption service` + validation + dépendances vérifiées

---

## 1. Objectif
Standardiser les procédures NOC pour :
- Réception et qualification des alertes (monitoring / RMM / client)
- Triage et classification (P1-P4)
- Corrélation multi-alertes
- Déclenchement des runbooks spécialisés

---

## 2. Flux de traitement d'une alerte

```
ALERTE ENTRANTE (RMM / Monitoring / Client / Email)
        │
        ▼ Étape 1 — Qualification (< 5 min)
   Est-ce une vraie alerte ou du bruit ?
   └─ Bruit connu → ACK + noter dans CW + surveiller
   └─ Vraie alerte → continuer
        │
        ▼ Étape 2 — Classification (P1/P2/P3/P4)
   Impact business ?  Propagation active ?
        │
        ├─ P1/P2 → Activation Commandare + plan d'action immédiat
        ├─ P3    → Ticket CW + assignation + SLA 4h
        └─ P4    → Ticket CW planifié
        │
        ▼ Étape 3 — Dispatch
   Type d'incident ?
   ├─ Infra/Serveur  → IT-InfrastructureMaster
   ├─ Réseau/VPN     → IT-NetworkMaster
   ├─ Backup         → IT-BackupDRMaster
   ├─ Sécurité       → IT-SecurityMaster
   ├─ M365/Cloud     → IT-CloudMaster
   └─ Support user   → IT-Commandare-TECH
        │
        ▼ Étape 4 — Suivi + Clôture
   Résolution confirmée → Documentation CW + ACK monitoring
```

---

## 3. Classification P1-P4

| Priorité | Critères | Exemples | SLA réponse | SLA mitigation |
|----------|---------|---------|-------------|----------------|
| P1 | Service critique down / sécurité active / données à risque | DC down, ransomware actif, réseau principal coupé | 15 min | 60 min |
| P2 | Fonctionnalité clé dégradée / impact large | Email lent, VPN instable, backup en échec > 48h | 30 min | 4h |
| P3 | Incident contournable / impact limité | Imprimante KO, PC utilisateur lent, service mineur arrêté | 4h | 1 jour ouvré |
| P4 | Amélioration / demande planifiée | Ajout logiciel, question technique, documentation | Best effort | 3 jours ouvrés |

---

## 4. Réponse aux alertes courantes

### 4.1 Alerte CPU > 90% (serveur)
```powershell
# Diagnostic (lecture seule — aucun impact)
# Processus consommateurs
Get-Process | Sort-Object CPU -Descending | Select-Object -First 15 Name, Id,
  @{n='CPU_s';e={[math]::Round($_.CPU,0)}},
  @{n='RAM_MB';e={[math]::Round($_.WorkingSet/1MB,0)}} | Format-Table -Auto

# Événements récents (charge anormale)
$Start = (Get-Date).AddHours(-1)
Get-WinEvent -FilterHashtable @{LogName='System'; StartTime=$Start} -ErrorAction SilentlyContinue |
  Where-Object {$_.LevelDisplayName -in 'Error','Critical'} |
  Select-Object -First 10 TimeCreated, Id, Message | Format-Table -Wrap
```

### 4.2 Alerte espace disque < 10%
```powershell
# État disques (lecture seule)
Get-PSDrive -PSProvider FileSystem |
  Select-Object Name,
    @{n='Total_GB';e={[math]::Round(($_.Used+$_.Free)/1GB,1)}},
    @{n='Libre_GB';e={[math]::Round($_.Free/1GB,1)}},
    @{n='Libre_%';e={if(($_.Used+$_.Free) -gt 0){[math]::Round($_.Free/($_.Used+$_.Free)*100,1)}else{'N/A'}}} |
  Format-Table -Auto

# Top 10 dossiers les plus volumineux (lecture seule)
Get-ChildItem -Path "C:\" -Directory -ErrorAction SilentlyContinue |
  ForEach-Object {
    [pscustomobject]@{
      Dossier = $_.FullName
      Taille_GB = [math]::Round((Get-ChildItem $_.FullName -Recurse -ErrorAction SilentlyContinue |
                   Measure-Object -Property Length -Sum).Sum / 1GB, 2)
    }
  } | Sort-Object Taille_GB -Descending | Select-Object -First 10 | Format-Table -Auto
```

### 4.3 Alerte service Windows arrêté
```powershell
# Vérifier état
Get-Service -Name "[SERVICE]" | Select-Object Name, Status, StartType, DisplayName

# Événements liés
Get-WinEvent -FilterHashtable @{LogName='System'; StartTime=(Get-Date).AddHours(-2)} |
  Where-Object {$_.Message -match "[SERVICE]"} |
  Select-Object -First 10 TimeCreated, Id, LevelDisplayName, Message | Format-Table -Wrap

# ⚠️ Impact : démarrage du service — peut affecter les utilisateurs connectés
# → Confirmer avant : Start-Service -Name "[SERVICE]"
```

### 4.4 Alerte monitoring — Corrélation multi-alertes
```
Règle de corrélation :
- 3+ alertes différentes sur le même client en < 30 min → probable incident infra global
- Alertes sur DC + DNS + DHCP simultanées → incident AD (P1)
- CPU + RAM + Disque simultanés sur même serveur → saturation (P2)
- Alertes réseau + backup en échec → problème connectivité (P2)

Action corrélation :
→ Créer UN ticket parent P1/P2
→ Lier les alertes individuelles comme tickets enfants
→ Activer IT-InfrastructureMaster ou IT-Commandare-TECH selon domaine
```

---

## 5. Checklist fermeture alerte/ticket

- [ ] Cause racine identifiée (ou documentée comme `[À CONFIRMER]`)
- [ ] Action corrective appliquée (ou planifiée avec date)
- [ ] Monitoring ACK / alerte résolue dans le système
- [ ] Service / indicateur de retour à la normale confirmé
- [ ] Note CW complète (timeline + actions + résultat)
- [ ] Si récurrent → KB créée ou enrichie via `IT-KnowledgeKeeper`

---

## 6. Livrables CW

### Note interne
```
Prendre connaissance de la demande et connexion à la documentation de l'entreprise.

Alerte reçue : [type d'alerte — serveur/service — sans IP]
Classification : P[1/2/3/4]
Heure détection : [HH:MM]
Corrélation : [alerte isolée / liée à : ticket XXX]
Actions NOC :
  1. [action — FAIT / KO / [À CONFIRMER]]
  2. [action — FAIT / KO / [À CONFIRMER]]
Dispatch vers : @[Agent]
Résultat : [service rétabli / escalade en cours / planifié]
Durée d'interruption : [si applicable]
```

### Discussion client (client-safe)
```
- Détection et prise en charge de l'alerte.
- Analyse et identification de la cause.
- Correctif appliqué : [description fonctionnelle sans détails techniques].
- Retour à la normale confirmé.
- Prochaine étape : [surveillance renforcée / aucune action requise].
```

---

## 7. Escalade
- P1 immédiat → `IT-Commandare-NOC` + `IT-[Spécialiste domaine]`
- Incident sécurité → `IT-SecurityMaster` IMMÉDIAT
- 2 interventions sans résolution → `IT-Commandare-TECH`
