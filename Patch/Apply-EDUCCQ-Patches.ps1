# Apply-EDUCCQ-Patches.ps1
$ErrorActionPreference = "Stop"

$Root     = "C:\Intranet_EA\EA_IA\root_IA"
$PatchDir = Join-Path $Root "Patch\EDU_CCQ_WORKFLOW_BATCH"

$BaseAgents   = Join-Path $Root "00_INDEX\agents_index.yaml"
$BasePlaybook = Join-Path $Root "40_RUNBOOKS\playbooks.yaml"
$BaseRouting  = Join-Path $Root "80_MACHINES\hub_routing.yaml"

$PatchAgents   = Join-Path $PatchDir "PATCH__agents_index.yaml"
$PatchPlaybook = Join-Path $PatchDir "PATCH__playbook.yaml"
$PatchRouting  = Join-Path $PatchDir "PATCH__hub_routing.yaml"

$ApplyPatchDir = Join-Path $Root "20_AGENTS\EDU\EDU-Reflexions_CCQ\INTEGRATION"
$ApplyPatchPy  = Join-Path $ApplyPatchDir "apply_patch.py"

Write-Host "=== EDU CCQ PATCHER ===" -ForegroundColor Cyan
Write-Host "Root      : $Root"
Write-Host "PatchDir  : $PatchDir"
Write-Host ""

# --- Checks
function Assert-Exists($Path, $Label) {
  if (!(Test-Path $Path)) {
    throw "Fichier/Dossier manquant: $Label => $Path"
  }
}

Assert-Exists $Root "ROOT"
Assert-Exists $PatchDir "PatchDir"
Assert-Exists $BaseAgents "00_INDEX\agents_index.yaml"
Assert-Exists $BasePlaybook "40_RUNBOOKS\playbooks.yaml"
Assert-Exists $BaseRouting "80_MACHINES\hub_routing.yaml"
Assert-Exists $PatchAgents "PATCH__agents_index.yaml"
Assert-Exists $PatchPlaybook "PATCH__playbook.yaml"
Assert-Exists $PatchRouting "PATCH__hub_routing.yaml"

# --- Ensure python exists
$py = Get-Command python -ErrorAction SilentlyContinue
if (-not $py) { throw "Python introuvable dans PATH. Installe Python ou ajoute-le au PATH." }
Write-Host "Python OK: $($py.Source)" -ForegroundColor Green

# --- Ensure apply_patch.py exists; if not, create it
if (!(Test-Path $ApplyPatchPy)) {
  Write-Host "apply_patch.py absent -> création: $ApplyPatchPy" -ForegroundColor Yellow
  New-Item -ItemType Directory -Force -Path $ApplyPatchDir | Out-Null

  $pyContent = @'
import argparse
import copy
import yaml

MERGE_KEYS = ("id", "name", "slug", "key", "agent_id", "playbook_id", "team_id")

def merge(a, b):
    if b is None:
        return a
    if a is None:
        return copy.deepcopy(b)

    if isinstance(a, dict) and isinstance(b, dict):
        out = copy.deepcopy(a)
        for k, v in b.items():
            out[k] = merge(out.get(k), v)
        return out

    if isinstance(a, list) and isinstance(b, list):
        if all(isinstance(x, dict) for x in a + b) and (a or b):
            key = None
            for candidate in MERGE_KEYS:
                if any(candidate in x for x in a + b):
                    key = candidate
                    break
            if key:
                out = copy.deepcopy(a)
                index = {x.get(key): i for i, x in enumerate(out) if x.get(key) is not None}
                for item in b:
                    k = item.get(key)
                    if k is not None and k in index:
                        out[index[k]] = merge(out[index[k]], item)
                    else:
                        out.append(copy.deepcopy(item))
                return out

        out = copy.deepcopy(a)
        for item in b:
            if item not in out:
                out.append(copy.deepcopy(item))
        return out

    return copy.deepcopy(b)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("base")
    ap.add_argument("patch")
    ap.add_argument("--inplace", action="store_true")
    args = ap.parse_args()

    with open(args.base, "r", encoding="utf-8") as f:
        base = yaml.safe_load(f)
    with open(args.patch, "r", encoding="utf-8") as f:
        patch = yaml.safe_load(f)

    merged = merge(base, patch)

    out_path = args.base if args.inplace else args.base + ".merged.yaml"
    with open(out_path, "w", encoding="utf-8") as f:
        yaml.safe_dump(merged, f, sort_keys=False, allow_unicode=True)

    print(f"OK -> {out_path}")

if __name__ == "__main__":
    main()
'@

  Set-Content -Path $ApplyPatchPy -Value $pyContent -Encoding UTF8
  Write-Host "apply_patch.py créé." -ForegroundColor Green
} else {
  Write-Host "apply_patch.py OK: $ApplyPatchPy" -ForegroundColor Green
}

# --- Apply patches
Write-Host ""
Write-Host "== Application des patchs ==" -ForegroundColor Cyan

python $ApplyPatchPy $BaseAgents   $PatchAgents   --inplace
python $ApplyPatchPy $BasePlaybook $PatchPlaybook --inplace
python $ApplyPatchPy $BaseRouting  $PatchRouting  --inplace

Write-Host ""
Write-Host "== Validation YAML (parse) ==" -ForegroundColor Cyan

python -c "import yaml; yaml.safe_load(open(r'$BaseAgents','r',encoding='utf-8')); print('agents_index OK')"
python -c "import yaml; yaml.safe_load(open(r'$BasePlaybook','r',encoding='utf-8')); print('playbook OK')"
python -c "import yaml; yaml.safe_load(open(r'$BaseRouting','r',encoding='utf-8')); print('hub_routing OK')"

Write-Host ""
Write-Host "== Vérifs contenu ==" -ForegroundColor Cyan
Select-String -Path $BasePlaybook -Pattern "EDU_CCQ_EVAL_BATCH_V1" -Quiet `
  | ForEach-Object { if ($_ -eq $true) { Write-Host "Playbook batch détecté ✅" -ForegroundColor Green } }

Select-String -Path $BaseAgents -Pattern "EDU-Reflexions_CCQ" -Quiet `
  | ForEach-Object { if ($_ -eq $true) { Write-Host "Agent détecté ✅" -ForegroundColor Green } }

Write-Host ""
Write-Host "Terminé ✅" -ForegroundColor Green
