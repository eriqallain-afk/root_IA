param(
  [string]$RepoRoot = "",
  [switch]$Force,
  [switch]$Bundles,
  [switch]$MirrorSchemas
)

# rebuild_indexes.ps1
# Exécute scripts/rebuild_indexes.py avec un comportement robuste.
# Usage:
#   powershell -ExecutionPolicy Bypass -File .\scripts\rebuild_indexes.ps1 -RepoRoot "C:\...\root_IA" -Bundles -MirrorSchemas
#   .\scripts\rebuild_indexes.ps1 -Bundles -MirrorSchemas

$ErrorActionPreference = "Stop"

function Resolve-RepoRoot {
  param([string]$RepoRoot)
  if ($RepoRoot -and (Test-Path $RepoRoot)) { return (Resolve-Path $RepoRoot).Path }
  # repo root is parent of this script's folder
  $here = Split-Path -Parent $MyInvocation.MyCommand.Path
  $repo = Resolve-Path (Join-Path $here "..")
  return $repo.Path
}

$root = Resolve-RepoRoot -RepoRoot $RepoRoot
Write-Host "RepoRoot: $root"

$pyArgs = @("$root")
$cmdArgs = @("scripts/rebuild_indexes.py", "--root", $root)
if ($Force) { $cmdArgs += "--force" }
if ($Bundles) { $cmdArgs += "--bundles" }
if ($MirrorSchemas) { $cmdArgs += "--mirror-schemas" }

# Prefer 'py -3' on Windows, fallback to 'python'
$python = $null
try {
  $python = (Get-Command py -ErrorAction Stop).Source
  $run = @("py", "-3") + $cmdArgs
  Write-Host "Running: $($run -join ' ')"
  & py -3 @($cmdArgs)
  exit $LASTEXITCODE
} catch {
  try {
    $python = (Get-Command python -ErrorAction Stop).Source
    $run = @("python") + $cmdArgs
    Write-Host "Running: $($run -join ' ')"
    & python @($cmdArgs)
    exit $LASTEXITCODE
  } catch {
    Write-Error "Python introuvable. Installe Python 3 (ou lance via 'py -3')."
    exit 2
  }
}
