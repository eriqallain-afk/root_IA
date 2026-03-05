<#
validate_ops.ps1
Validation ciblée TEAM__OPS (sans dépendre d'autres teams).
Exit codes: 0 OK | 2 Errors | 1 Fatal
#>

[CmdletBinding()]
param(
  [string]$Root = ".",
  [string]$OutMd = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Assert-YamlSupport {
  if (-not (Get-Command ConvertFrom-Yaml -ErrorAction SilentlyContinue)) {
    throw "ConvertFrom-Yaml introuvable. Installe: Install-Module powershell-yaml -Scope CurrentUser"
  }
}

function Read-Yaml([string]$Path) {
  if (-not (Test-Path $Path)) { throw "Fichier introuvable: $Path" }
  (Get-Content -LiteralPath $Path -Raw -Encoding UTF8) | ConvertFrom-Yaml
}

function Fail($msg) { $script:Errors.Add($msg) | Out-Null }
function Warn($msg) { $script:Warnings.Add($msg) | Out-Null }

function Render-Report {
  param($Errors,$Warnings,$Facts)
  $md = @()
  $md += "# OPS — Validation"
  $md += ""
  $md += "## Résultat"
  $md += ""
  $md += "- Errors: **$($Errors.Count)**"
  $md += "- Warnings: **$($Warnings.Count)**"
  $md += ""
  $md += "## Facts"
  $md += ""
  foreach ($k in $Facts.Keys) { $md += "- $k: $($Facts[$k])" }
  $md += ""
  $md += "## Errors"
  $md += ""
  if ($Errors.Count -eq 0) { $md += "- (aucun)" } else { $Errors | ForEach-Object { $md += "- $_" } }
  $md += ""
  $md += "## Warnings"
  $md += ""
  if ($Warnings.Count -eq 0) { $md += "- (aucun)" } else { $Warnings | ForEach-Object { $md += "- $_" } }
  $md += ""
  return ($md -join "`n")
}

try {
  Assert-YamlSupport

  $Errors = New-Object System.Collections.Generic.List[string]
  $Warnings = New-Object System.Collections.Generic.List[string]
  $Facts = @{}

  $hubPath = Join-Path $Root "80_MACHINES/hub_routing.yaml"
  $pbPath  = Join-Path $Root "40_RUNBOOKS/playbooks.yaml"

  $routerAgent = Join-Path $Root "20_AGENTS/OPS/OPS-RouterIA/agent.yaml"
  $runnerAgent = Join-Path $Root "20_AGENTS/OPS/OPS-PlaybookRunner/agent.yaml"
  $dossierAgent = Join-Path $Root "20_AGENTS/OPS/OPS-DossierIA/agent.yaml"

  $routerContract = Join-Path $Root "20_AGENTS/OPS/OPS-RouterIA/contract.yaml"
  $runnerContract = Join-Path $Root "20_AGENTS/OPS/OPS-PlaybookRunner/contract.yaml"
  $dossierContract = Join-Path $Root "20_AGENTS/OPS/OPS-DossierIA/contract.yaml"

  # Parse YAML (hard fail if invalid)
  $hub = Read-Yaml $hubPath
  $pbs = Read-Yaml $pbPath
  $ra = Read-Yaml $routerAgent
  $rra = Read-Yaml $runnerAgent
  $da = Read-Yaml $dossierAgent
  [void](Read-Yaml $routerContract)
  [void](Read-Yaml $runnerContract)
  [void](Read-Yaml $dossierContract)

  # internal_only
  foreach ($a in @($ra,$rra,$da)) {
    $id = $a.id
    $vis = $a.machine.visibility
    if ($vis -ne "internal_only") { Fail "OPS agent '$id' machine.visibility doit être internal_only (actuel='$vis')." }
  }

  # hub_routing must not route to OPS-* directly
  $routes = $hub.routing_table
  if ($null -eq $routes) { $routes = @() }
  $opsTargets = @()
  $i=0
  foreach ($r in $routes) {
    $aid = $r.default_actor_id
    if ($aid -like "OPS-*") { $opsTargets += "route[$i] -> $aid" }
    $i++
  }
  if ($opsTargets.Count -gt 0) { Fail ("hub_routing route directement vers OPS: " + ($opsTargets -join "; ")) }

  # fallback sanity
  $fb = $hub.fallback
  if ($null -eq $fb.default_actor_id -or $null -eq $fb.default_playbook_id) {
    Fail "hub_routing.fallback doit définir default_actor_id + default_playbook_id."
  }

  # INTAKE_ROUTE_EXECUTE must call OPS chain
  $pbMap = $pbs.playbooks
  if ($null -eq $pbMap) { Fail "playbooks.yaml: clé 'playbooks' introuvable." }
  $intake = $pbMap.INTAKE_ROUTE_EXECUTE
  if ($null -eq $intake) { Fail "playbooks.yaml: playbook 'INTAKE_ROUTE_EXECUTE' introuvable." }
  else {
    $steps = @($intake.steps)
    $expected = @("OPS-RouterIA","OPS-PlaybookRunner","OPS-DossierIA")
    $got = @()
    foreach ($s in $steps) { $got += $s.actor_id }
    if (($got -join ",") -ne ($expected -join ",")) {
      Warn ("INTAKE_ROUTE_EXECUTE steps attendus: " + ($expected -join " -> ") + " | actuels: " + ($got -join " -> "))
    }
  }

  $Facts["hub_routing.routes"] = @($routes).Count
  $Facts["fallback.actor"] = $hub.fallback.default_actor_id
  $Facts["fallback.playbook"] = $hub.fallback.default_playbook_id
  $Facts["INTAKE_ROUTE_EXECUTE.steps"] = @($intake.steps).Count

  # Output
  Write-Host "== validate_ops.ps1 =="
  Write-Host "ERRORS: $($Errors.Count) | WARNINGS: $($Warnings.Count)"
  if ($Errors.Count -gt 0) { Write-Host "ERRORS:"; $Errors | ForEach-Object { Write-Host " - $_" } }
  if ($Warnings.Count -gt 0) { Write-Host "WARNINGS:"; $Warnings | ForEach-Object { Write-Host " - $_" } }

  if ($OutMd) {
    $rpt = Render-Report -Errors $Errors -Warnings $Warnings -Facts $Facts
    $dir = Split-Path -Parent $OutMd
    if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
    Set-Content -LiteralPath $OutMd -Value $rpt -Encoding UTF8
    Write-Host "Rapport écrit: $OutMd"
  }

  if ($Errors.Count -gt 0) { exit 2 } else { exit 0 }
}
catch {
  Write-Error "FATAL: $($_.Exception.Message)"
  exit 1
}
