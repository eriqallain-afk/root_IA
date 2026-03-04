# EA_IA Validation Pack (v1.2)

Pack de validation pour verifier les liens entre:
- hub_routing.yaml (intent -> actor_id + playbook_id)
- agents_index.yaml (actor_id existants)
- playbooks_index.yaml (playbook_id existants) OU auto-discovery de playbook*.y*ml

IMPORTANT:
- Aucun module externe. YAML "lite" seulement (list of maps).
- Compatible Windows PowerShell 5.1.

## Installation
Dezipper dans:
C:\Intranet_EA\EA_IA\root_IA\

Tu obtiens:
C:\Intranet_EA\EA_IA\root_IA\99_VALIDATION\...

## Execution
Depuis root_IA:
powershell -ExecutionPolicy Bypass -File .\99_VALIDATION\Run-Validation.ps1 -RootPath "C:\Intranet_EA\EA_IA\root_IA"

## Debug
- Validate refs seulement:
  powershell -ExecutionPolicy Bypass -File .\99_VALIDATION\Validate-Refs.ps1 -RootPath "C:\Intranet_EA\EA_IA\root_IA" -OutJson .\validation_report.json
- Validate naming seulement:
  powershell -ExecutionPolicy Bypass -File .\99_VALIDATION\Validate-Naming.ps1 -RootPath "C:\Intranet_EA\EA_IA\root_IA"
