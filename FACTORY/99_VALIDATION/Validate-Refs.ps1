<#
Validate-Refs.ps1
Valide les references (routing -> agents/playbooks).
Sans modules externes (YAML lite). Compatible Windows PowerShell 5.1.
ExitCode 0 si OK, 1 si erreurs.
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory=$false)]
  [string]$RootPath = "C:\Intranet_EA\EA_IA\root_IA",

  [Parameter(Mandatory=$false)]
  [string]$OutJson = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "_lib\ValidationLib.ps1")

if (-not (Test-Path -LiteralPath $RootPath)) {
  Write-Result "ERR" ("RootPath introuvable: {0}" -f $RootPath)
  exit 1

$router    = Get-RepoFile -RootPath $RootPath -Candidates @("00_INDEX\hub_routing.yaml","hub_routing.yaml") -FallbackName "hub_routing.yaml"
$agentsIdx = Get-RepoFile -RootPath $RootPath -Candidates @("00_INDEX\agents_index.yaml","agents_index.yaml") -FallbackName "agents_index.yaml"
$playbooksIdx = Get-RepoFile -RootPath $RootPath -Candidates @("00_INDEX\playbooks_index.yaml","playbooks_index.yaml","00_INDEX\playbooks.yaml","playbooks.yaml") -FallbackName "playbooks_index.yaml"

$errors   = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

if (-not $router)    { $errors.Add("hub_routing.yaml introuvable (candidats: 00_INDEX\hub_routing.yaml, hub_routing.yaml).") | Out-Null }
if (-not $agentsIdx) { $errors.Add("agents_index.yaml introuvable (candidats: 00_INDEX\agents_index.yaml, agents_index.yaml).") | Out-Null }


}

Write-Result "OK" ("RootPath:  {0}" -f $RootPath)
Write-Result "OK" ("Router:    {0}" -f $router)
Write-Result "OK" ("Agents:    {0}" -f $agentsIdx)
if ($playbooksIdx) { Write-Result "OK" ("Playbooks: {0}" -f $playbooksIdx) } else { Write-Result "WARN" "playbooks_index.yaml introuvable - auto-discovery playbook*.y*ml." }

$routes = Parse-YamlLiteListOfMaps -Path $router
if ($routes.Count -eq 0) {
  $errors.Add("Aucune route detectee dans hub_routing.yaml (format attendu: '- intent: ...').") | Out-Null
}

$agentsSet = Extract-IdsFromYamlLite -Path $agentsIdx -Keys @("actor_id","id","actorId")
if ($agentsSet.Count -eq 0) {
  $warnings.Add("Aucun actor_id detecte dans agents_index.yaml (cle attendue: actor_id).") | Out-Null
}

$playbooksSet = New-Object 'System.Collections.Generic.HashSet[string]'
if ($playbooksIdx) {
  $playbooksSet = Extract-IdsFromYamlLite -Path $playbooksIdx -Keys @("playbook_id","id","playbookId")
} else {
  $pbFiles = Get-RepoFilesByPattern -RootPath $RootPath -Patterns @("playbook*.yaml","playbook*.yml","*playbooks*.yaml","*playbooks*.yml")
  foreach ($f in $pbFiles) {
    try {
      $tmp = Extract-IdsFromYamlLite -Path $f.FullName -Keys @("playbook_id","id","playbookId")
      foreach ($x in $tmp) { [void]$playbooksSet.Add($x) }
    } catch {
      $warnings.Add(("Impossible de parser (YAML lite): {0}" -f $f.FullName)) | Out-Null
    }
  }
}

$intentSet = New-Object 'System.Collections.Generic.HashSet[string]'

foreach ($r in $routes) {
  $ln     = $r["__startLine"]
  $intent = $r["intent"]
  $actor  = $r["actor_id"]
  $pb     = $r["playbook_id"]

  if (-not $intent -or -not $actor) {
    $errors.Add(("Route incomplete ({0}:{1}) - requis: intent, actor_id (playbook_id optionnel)." -f $router, $ln)) | Out-Null
    continue
  }

  if (-not $intentSet.Add($intent)) {
    $errors.Add(("Intent duplique '{0}' ({1}:{2})." -f $intent, $router, $ln)) | Out-Null
  }

  if ($agentsSet.Count -gt 0 -and -not $agentsSet.Contains($actor)) {
    $errors.Add(("actor_id inconnu '{0}' pour intent '{1}' ({2}:{3})." -f $actor, $intent, $router, $ln)) | Out-Null
  }

  if ($playbooksSet.Count -gt 0 -and -not $playbooksSet.Contains($pb)) {
    $errors.Add(("playbook_id inconnu '{0}' pour intent '{1}' ({2}:{3})." -f $pb, $intent, $router, $ln)) | Out-Null
  }
}

Write-Host ""
Write-Host "=== Resultats Validate-Refs ==="
Write-Result "OK"   ("Routes lues: {0}" -f $routes.Count)
Write-Result "OK"   ("Agents detectes: {0}" -f $agentsSet.Count)
Write-Result "OK"   ("Playbooks detectes: {0}" -f $playbooksSet.Count)
Write-Result "WARN" ("Warnings: {0}" -f $warnings.Count)
Write-Result "ERR"  ("Erreurs: {0}" -f $errors.Count)

foreach ($w in $warnings) { Write-Result "WARN" $w }
foreach ($e in $errors)   { Write-Result "ERR"  $e }

if ($OutJson -and $OutJson.Trim() -ne "") {
  $obj = [ordered]@{
    rootPath = $RootPath
    files = [ordered]@{
      router = $router
      agents_index = $agentsIdx
      playbooks_index = $playbooksIdx
    }
    counts = [ordered]@{
      routes = $routes.Count
      agents = $agentsSet.Count
      playbooks = $playbooksSet.Count
      warnings = $warnings.Count
      errors = $errors.Count
    }
    warnings = $warnings
    errors = $errors
  }
  $obj | ConvertTo-Json -Depth 6 | Out-File -FilePath $OutJson -Encoding UTF8
  Write-Result "OK" ("Rapport JSON ecrit: {0}" -f $OutJson)
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }
