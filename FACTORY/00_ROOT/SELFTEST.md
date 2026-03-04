# SELFTEST — root_IA (Machine)
Generated: 2025-12-28T18:28:31Z

## Si tu as Python installé (recommandé)
```powershell
python .\scripts\validate_integrity.py
python .\scripts\validate_strict.py
python .\scripts\build_memories.py
```

## Sans Python
- Vérifie présence fichiers critiques:
  - 00_CONTROL_PLANE/CONTROL_PLANE.yaml
  - 00_INDEX/gpt_catalog.yaml
  - 80_MACHINES/hub_routing.yaml
  - 40_RUNBOOKS/playbooks.yaml
  - 90_MEMORY/memory.yaml
  - 90_MEMORY/MEM-PlaybooksGlobal.yaml
  - registry.yaml

## Windows (one-click)
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\one_click_windows.ps1
```
