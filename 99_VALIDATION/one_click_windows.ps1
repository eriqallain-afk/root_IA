param(
  [string]$Python = "python"
)
$ErrorActionPreference = "Stop"
function Info($m){ Write-Host "[INFO] $m" -ForegroundColor Cyan }
function Ok($m){ Write-Host "[OK]   $m" -ForegroundColor Green }

Info "root_IA one-click (v5 ULTIMATE) — 2025-12-28T20:05:18Z"
Info "Installing deps (pyyaml)…"
& $Python -m pip install --upgrade pip | Out-Null
& $Python -m pip install pyyaml | Out-Null
Ok "Deps ok"

Info "Running validations…"
& $Python .\scripts\lint_yaml.py
& $Python .\scripts\validate_integrity.py
& $Python .\scripts\validate_strict.py
& $Python .\scripts\validate_schemas.py
& $Python .\scripts\run_golden_tests.py
& $Python .\scripts\validate_machine_output.py
& $Python .\scripts\validate_no_fake_citations.py
Ok "Validations ok"

Info "Regenerating MEM-*…"
& $Python .\scripts\build_memories.py
Ok "Memories ok"

Info "Creating registry lock…"
& $Python .\scripts\registry_lock.py create
Ok "Lock created"

Ok "DONE"
