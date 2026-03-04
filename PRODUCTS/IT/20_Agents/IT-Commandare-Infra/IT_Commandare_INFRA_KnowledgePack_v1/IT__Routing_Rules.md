# Règles de Routing — IT-Commandare-Infra

## Routing par domaine détecté

```yaml
routing_rules:

  server:
    primary: IT-InfrastructureMaster
    secondary: IT-Commandare-TECH
    keywords: [serveur, server, windows server, linux, physique, bare metal, BSOD, reboot]

  vm:
    primary: IT-InfrastructureMaster
    secondary: IT-Commandare-TECH
    keywords: [vmware, hyper-v, proxmox, vm, virtual machine, esxi, vCenter, snapshot, HA, cluster]

  storage:
    primary: IT-InfrastructureMaster
    secondary: IT-BackupDRMaster
    keywords: [SAN, NAS, iSCSI, disque, disk, espace, storage, RAID, LUN, datastore]

  dc:
    primary: IT-InfrastructureMaster
    secondary: IT-NetworkMaster
    keywords: [domain controller, DC, Active Directory, AD, SYSVOL, NETLOGON, réplication, FSMO, DNS AD]

  cloud_azure:
    primary: IT-CloudMaster
    secondary: IT-InfrastructureMaster
    keywords: [Azure, VM Azure, Azure AD, Entra, subscription, tenant, resource group, VNet, ExpressRoute]

  cloud_m365:
    primary: IT-CloudMaster
    secondary: null
    keywords: [Microsoft 365, M365, Exchange Online, Teams, SharePoint, OneDrive, Outlook, licences]

  network_infra:
    primary: IT-NetworkMaster
    secondary: IT-InfrastructureMaster
    keywords: [routeur core, switch distribution, WAN, lien principal, MPLS, BGP, pare-feu principal]

  backup_dr:
    primary: IT-BackupDRMaster
    secondary: IT-InfrastructureMaster
    keywords: [backup, sauvegarde, Veeam, Datto, DR, disaster recovery, RPO, RTO, restauration]

  multi_domain:
    primary: IT-CTOMaster      # si P1
    tracks:
      - IT-InfrastructureMaster
      - IT-CloudMaster
      - IT-NetworkMaster
    note: "Lancer les tracks en parallèle — IT-CTOMaster coordonne si P1"
```

## Règles d'escalade

| Condition | Escalade vers |
|-----------|--------------|
| P1 + impact architectural (migration, DR activé) | IT-CTOMaster |
| Incident implique vecteur sécurité | IT-SecurityMaster (prend le lead sécurité) |
| Incident non résolu en 2h (P2) | IT-CTOMaster |
| Décision de rollback majeur requis | IT-CTOMaster + IT-DirecteurGeneral |
| Client VIP affecté | IT-CommsMSP + IT-DirecteurGeneral notifié |

## Passage à IT-Commandare-OPR

Déclencher IT-Commandare-OPR quand :
- Service stabilisé (P1/P2 contenu)
- Remédiation définitive planifiée ou appliquée
- Ticket CW à fermer ou à mettre à jour formellement
- DoD (Definition of Done) à vérifier
