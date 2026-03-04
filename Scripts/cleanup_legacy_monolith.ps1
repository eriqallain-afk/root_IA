<# scripts/cleanup_legacy_monolith.ps1
Moves legacy monolith folders to LEGACY/ to avoid duplicate agent ids during scans.
This does NOT delete anything.
#>
[CmdletBinding()]
param(
  [string]$RepoRoot = ""
)

$ErrorActionPreference = "Stop"
if (-not $RepoRoot) { $RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path }

$legacy = Join-Path $RepoRoot "LEGACY"
New-Item -ItemType Directory -Force -Path $legacy | Out-Null

$toMove = @("20_AGENTS","30_PLAYBOOKS","80_MACHINES")
foreach ($name in $toMove) {
  $src = Join-Path $RepoRoot $name
  if (Test-Path $src) {
    $dst = Join-Path $legacy $name
    if (Test-Path $dst) {
      Write-Host "Skip (already exists): $dst" -ForegroundColor Yellow
    } else {
      Write-Host "Move: $src -> $dst" -ForegroundColor Cyan
      Move-Item -LiteralPath $src -Destination $dst
    }
  }
}
Write-Host "OK: legacy moved under LEGACY/ (if present)." -ForegroundColor Green
