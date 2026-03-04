<#
Validate-Naming.ps1
Valide la conformite des noms (intent / actor_id / playbook_id).
ExitCode 0 si OK, 1 si erreurs.
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory=$false)]
  [string]$RootPath = "C:\Intranet_EA\EA_IA\root_IA"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "_lib\ValidationLib.ps1")

if (-not (Test-Path -LiteralPath $RootPath)) {
  Write-Result "ERR" ("RootPath introuvable: {0}" -f $RootPath)
  exit 1
}

$router    = Get-RepoFile -RootPath $RootPath -Candidates @("00_INDEX\hub_routing.yaml","hub_routing.yaml") -FallbackName "hub_routing.yaml"
$agentsIdx = Get-RepoFile -RootPath $RootPath -Candidates @("00_INDEX\agents_index.yaml","agents_index.yaml") -FallbackName "agents_index.yaml"
$playbooksIdx = Get-RepoFile -RootPath $RootPath -Candidates @("00_INDEX\playbooks_index.yaml","playbooks_index.yaml","00_INDEX\playbooks.yaml","playbooks.yaml") -FallbackName "playbooks_index.yaml"

$errors   = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

# Patterns (ajuste si tu as une nomenclature plus stricte)
$intentPattern   = '^[A-Z][A-Z0-9_]{2,80}$'
$actorPattern    = '^[A-Z0-9]+-[A-Za-z0-9][A-Za-z0-9_-]{1,80}$'
$playbookPattern = '^[A-Za-z0-9_:-]{3,120}$'

function _Check([string]$label, [string]$value, [string]$pattern, [string]$file, [int]$line) {
  if (-not $value) { return }
  if ($value -notmatch $pattern) {
    $script:errors.Add(("{0} non conforme '{1}' ({2}:{3}) - attendu: /{4}/" -f $label, $value, $file, $line, $pattern)) | Out-Null
  }
}

if ($router) {
  $routes = Parse-YamlLiteListOfMaps -Path $router
  foreach ($r in $routes) {
    $ln = $r["__startLine"]
    _Check "intent"     $r["intent"]     $intentPattern   $router $ln
    _Check "actor_id"   $r["actor_id"]   $actorPattern    $router $ln
    _Check "playbook_id" $r["playbook_id"] $playbookPattern $router $ln
  }
} else {
  $warnings.Add("hub_routing.yaml introuvable - naming check partiel.") | Out-Null
}

if ($agentsIdx) {
  $items = Parse-YamlLiteListOfMaps -Path $agentsIdx
  foreach ($it in $items) {
    $ln = $it["__startLine"]
    $aid = $it["actor_id"]
    if ($aid) { _Check "actor_id" $aid $actorPattern $agentsIdx $ln }
  }
} else {
  $warnings.Add("agents_index.yaml introuvable - naming check partiel.") | Out-Null
}

if ($playbooksIdx) {
  $items = Parse-YamlLiteListOfMaps -Path $playbooksIdx
  foreach ($it in $items) {
    $ln = $it["__startLine"]
    $pbId = $it["playbook_id"]
    if ($pbId) { _Check "playbook_id" $pbId $playbookPattern $playbooksIdx $ln }
  }
} else {
  $warnings.Add("playbooks_index.yaml introuvable - naming check partiel.") | Out-Null
}

Write-Host ""
Write-Host "=== Resultats Validate-Naming ==="
Write-Result "WARN" ("Warnings: {0}" -f $warnings.Count)
Write-Result "ERR"  ("Erreurs: {0}" -f $errors.Count)

foreach ($w in $warnings) { Write-Result "WARN" $w }
foreach ($e in $errors)   { Write-Result "ERR"  $e }

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }
