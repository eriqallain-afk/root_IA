<#
ValidationLib.ps1 - utilitaires sans dependances.
Compatible Windows PowerShell 5.1. 100% ASCII.
Inclut Parse-RoutingTable pour hub_routing.yaml (format intents+agent+playbook).
#>

Set-StrictMode -Version Latest

function _Trim-Quotes([string]$s) {
  if ($null -eq $s) { return $null }
  $t = $s.Trim()
  if (($t.StartsWith('"') -and $t.EndsWith('"')) -or
      ($t.StartsWith("'") -and $t.EndsWith("'"))) {
    return $t.Substring(1, $t.Length - 2)
  }
  return $t
}

function _Split-InlineList([string]$s) {
  $t = $s.Trim().TrimStart('[').TrimEnd(']')
  $parts = $t -split ',' |
           ForEach-Object { (_Trim-Quotes $_.Trim()) } |
           Where-Object { $_ -ne '' }
  return @($parts)
}

function Write-Result([string]$Level, [string]$Message) {
  switch ($Level) {
    'OK'    { Write-Host ("[OK]  {0}" -f $Message) -ForegroundColor Green  }
    'WARN'  { Write-Host ("[WARN] {0}" -f $Message) -ForegroundColor Yellow }
    'ERR'   { Write-Host ("[ERR] {0}" -f $Message) -ForegroundColor Red    }
    default { Write-Host ("[{0}] {1}" -f $Level, $Message) }
  }
}

function Get-RepoFile([string]$RootPath, [string[]]$Candidates, [string]$FallbackName) {
  foreach ($c in $Candidates) {
    $p = Join-Path $RootPath $c
    if (Test-Path -LiteralPath $p) { return (Resolve-Path -LiteralPath $p).Path }
  }
  $hit = Get-ChildItem -LiteralPath $RootPath -Recurse -File -ErrorAction SilentlyContinue |
         Where-Object { $_.Name -ieq $FallbackName } |
         Select-Object -First 1
  if ($hit) { return $hit.FullName }
  return $null
}

function Get-RepoFilesByPattern([string]$RootPath, [string[]]$Patterns) {
  $files = @()
  foreach ($pat in $Patterns) {
    $files += @(Get-ChildItem -LiteralPath $RootPath -Recurse -File `
                -ErrorAction SilentlyContinue -Filter $pat)
  }
  $files | Sort-Object FullName -Unique
}

# ---- Parse-RoutingTable -------------------------------------------------
# Lit hub_routing.yaml format :
#   - intents: [a, b, c]
#     agent: AGENT-ID
#     playbook: PB_ID          (optionnel)
# Retourne une ligne par intent :
#   @{ __startLine; intent; actor_id; playbook_id }
# -------------------------------------------------------------------------
function Parse-RoutingTable([string]$Path) {
  if (-not (Test-Path -LiteralPath $Path)) {
    throw ("File not found: {0}" -f $Path)
  }

  [string[]]$lines = @(Get-Content -LiteralPath $Path -Encoding UTF8)

  $results    = New-Object System.Collections.Generic.List[hashtable]
  $script:intents    = @()
  $script:agent      = $null
  $script:playbook   = $null
  $script:startLine  = 0
  $inBlock    = $false
  $inIntList  = $false   # liste intents multi-lignes

  function _Flush {
    if ($script:intents.Count -eq 0 -or -not $script:agent) { return }
    foreach ($intent in $script:intents) {
      $row = @{
        __startLine = $script:startLine
        intent      = $intent
        actor_id    = $script:agent
        playbook_id = $script:playbook
      }
      $script:results.Add($row) | Out-Null
    }
  }

  for ($i = 0; $i -lt $lines.Count; $i++) {
    $raw    = $lines[$i]
    $lineNo = $i + 1

    if ($raw -match '^\s*#')                { $inIntList = $false; continue }
    if ([string]::IsNullOrWhiteSpace($raw)) { $inIntList = $false; continue }

    # Debut de bloc : "  - intents: [...]" ou "  - intents:"
    if ($raw -match '^\s*-\s+intents\s*:\s*(.*)$') {
      _Flush
      $script:intents   = @()
      $script:agent     = $null
      $script:playbook  = $null
      $script:startLine = $lineNo
      $inBlock   = $true
      $rest      = $Matches[1].Trim()
      if ($rest -ne '') {
        $script:intents   = _Split-InlineList $rest
        $inIntList = $false
      } else {
        $inIntList = $true
      }
      continue
    }

    # Item de liste intents multi-lignes : "    - intent_name"
    if ($inIntList -and $raw -match '^\s+-\s+([A-Za-z0-9_]+)\s*$') {
      $script:intents += $Matches[1]
      continue
    } else {
      $inIntList = $false
    }

    # Proprietes du bloc courant
    if ($inBlock) {
      if ($raw -match '^\s+(agent|actor_id)\s*:\s*(.+)$') {
        $script:agent = (_Trim-Quotes $Matches[2]).Trim()
        continue
      }
      if ($raw -match '^\s+(playbook|playbook_id)\s*:\s*(.+)$') {
        $script:playbook = (_Trim-Quotes $Matches[2]).Trim()
        continue
      }
    }
  }

  _Flush
  return $results
}

# ---- Parse-YamlLiteListOfMaps (agents_index, playbooks_index) -----------
function Parse-YamlLiteListOfMaps([string]$Path) {
  if (-not (Test-Path -LiteralPath $Path)) {
    throw ("File not found: {0}" -f $Path)
  }

  [string[]]$lines = @(Get-Content -LiteralPath $Path -Encoding UTF8)
  $items   = New-Object System.Collections.Generic.List[hashtable]
  $current = $null

  for ($i = 0; $i -lt $lines.Count; $i++) {
    $raw    = $lines[$i]
    $lineNo = $i + 1

    if ($raw -match '^\s*#')                { continue }
    if ([string]::IsNullOrWhiteSpace($raw)) { continue }

    if ($raw -match '^\s*-\s*(.*)$') {
      if ($null -ne $current) { $items.Add($current) | Out-Null }
      $current = @{}
      $current['__startLine'] = $lineNo
      $rest = $Matches[1].Trim()
      if ($rest -match '^([A-Za-z0-9_]+)\s*:\s*(.*)$') {
        $k = $Matches[1]; $v = _Trim-Quotes($Matches[2])
        $current[$k] = $v
      }
      continue
    }

    if ($raw -match '^\s*([A-Za-z0-9_]+)\s*:\s*(.+)$') {
      if ($null -eq $current) { continue }
      $k = $Matches[1]; $v = _Trim-Quotes($Matches[2])
      $current[$k] = $v
      continue
    }
  }

  if ($null -ne $current) { $items.Add($current) | Out-Null }
  return $items
}

# ---- Extract-IdsFromYamlLite --------------------------------------------
function Extract-IdsFromYamlLite([string]$Path, [string[]]$Keys) {
  $items = Parse-YamlLiteListOfMaps -Path $Path
  $set   = New-Object 'System.Collections.Generic.HashSet[string]'
  foreach ($it in $items) {
    foreach ($k in $Keys) {
      if ($it.ContainsKey($k) -and $it[$k]) {
        [void]$set.Add([string]$it[$k])
      }
    }
  }
  return $set
}
