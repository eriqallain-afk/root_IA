# Best Practices Interventions MSP

## Workflow Optimal

1. **Ouverture claire**
   - Format: #ticket - Client - Tâche
   - Périmètre: Liste serveurs/systèmes
   - Fenêtre: Temps si maintenance

2. **Communication efficace**
   - Screenshots > descriptions texte
   - États factuels (CPU 95%, service stopped)
   - Commandes exactes exécutées

3. **Clôture systématique**
   - Toujours taper /close
   - Vérifier 3 rapports générés
   - Copier dans ConnectWise immédiatement

## Types Interventions Fréquentes

### Serveur Lent
```
Symptômes: Performance dégradée
Check: CPU, RAM, Disk, Network
Causes fréquentes: 
- Antivirus scan
- Backup en cours
- Memory leak
- Disk plein
```

### Service Down
```
Diagnostic:
1. Vérifier status service
2. Consulter Event Viewer
3. Identifier cause arrêt
4. Redémarrer service
5. Vérifier post-redémarrage
```

### Patching Serveurs
```
Procédure:
1. Snapshot/Backup pré-patch
2. Install updates
3. Reboot si requis
4. Vérifier services critiques
5. Tests fonctionnels
```

## Commandes Utiles PowerShell
```powershell
# Services
Get-Service -Name [service]
Restart-Service -Name [service]

# Updates
Get-WindowsUpdate
Install-WindowsUpdate -AcceptAll

# Performance
Get-Process | Sort CPU -Descending | Select -First 10

# Event Viewer
Get-EventLog -LogName System -Newest 50 -EntryType Error
```

## Erreurs à Éviter

❌ Messages vagues: "Problème réseau"
✅ Messages précis: "Ping timeout 192.168.1.10, packet loss 100%"

❌ Oublier /close
✅ Toujours /close pour rapports

❌ Descriptions longues
✅ Screenshots + états factuels

## Templates Rapides

**Incident Standard:**
```
#[ticket] - [client]
[Système]: [Problème]
Cause: [Root cause]
Fix: [Action]
Test: [Vérification]
/close
```

**Maintenance:**
```
#[ticket] - [client]
Maintenance: [Type]
Systèmes: [Liste]
[Actions par système]
/close
```