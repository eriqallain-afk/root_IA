# RB-001 — Audit CMDB Actifs IT
**Agent :** IT-AssetMaster | **Fréquence :** Trimestrielle
## Procédure
1. Exporter liste actifs ConnectWise (Configurations)
2. Comparer avec Hudu (edocs) et actifs détectés RMM
3. Identifier : EOL/EOS, licences expirées, actifs non monitorés
4. Mettre à jour fiches edocs manquantes/obsolètes
5. Produire rapport : priorités remplacement + licences à renouveler
## Commandes
```powershell
Get-ComputerInfo | Select-Object CsName,OsName,BiosVersion,CsManufacturer,CsModel
Get-PhysicalDisk | Select-Object FriendlyName,Size,HealthStatus
```