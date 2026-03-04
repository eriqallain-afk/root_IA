<#
.SYNOPSIS
    Run-AllFixes.ps1 - Lance tous les correctifs dans l ordre optimal
.DESCRIPTION
    Script maitre qui enchaine les 5 correctifs root_IA.
    TOUJOURS lancer avec -DryRun en premier.

    STRUCTURE :
      root_IA        Scripts\   <- Ce script est ici
        FACTORY\   <- Infrastructure centrale
        PRODUCTS\  <- Armees GPT deployees

.PARAMETER DryRun
    Preview sans modification
.PARAMETER StopOnError
    Arreter a la premiere erreur
.PARAMETER SkipFix
    Numeros de fix a ignorer. Ex: -SkipFix 4,5

.EXAMPLE
    .\Run-AllFixes.ps1 -DryRun
    .\Run-AllFixes.ps1
    .\Run-AllFixes.ps1 -SkipFix 4,5
#>
param(
    [switch]$DryRun,
    [switch]$StopOnError,
    [int[]]$SkipFix = @()
)

Set-StrictMode -Version Latest

$rootIA       = Split-Path $PSScriptRoot -Parent
$FactoryPath  = Join-Path $rootIA "FACTORY"
$ProductsPath = Join-Path $rootIA "PRODUCTS"
$scriptsDir   = $PSScriptRoot

if (-not (Test-Path $FactoryPath)) {
    Write-Host "[ERREUR] FACTORY introuvable : $FactoryPath" -ForegroundColor Red
    Write-Host "         Structure attendue :"
    Write-Host "           root_IA"
    Write-Host "             Scripts\  <- scripts ici"
    Write-Host "             FACTORY\  <- infra centrale"
    Write-Host "             PRODUCTS\ <- armees GPT"
    exit 1
}

if ($DryRun) { $modeLabel = "DRY-RUN" } else { $modeLabel = "EXECUTION" }

Write-Host "" 
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "      Run-AllFixes.ps1 - root_IA Corrections Majeures               " -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  Mode     : $modeLabel"
Write-Host "  Scripts  : $scriptsDir"
Write-Host "  FACTORY  : $FactoryPath"
Write-Host "  PRODUCTS : $ProductsPath"
Write-Host "======================================================================"
Write-Host ""

if ($DryRun) {
    Write-Host "  Mode DRY-RUN - aucun fichier ne sera modifie." -ForegroundColor Yellow
    Write-Host "  Verifier les actions proposees, puis relancer sans -DryRun."
    Write-Host ""
}

$fixes = @(
    @{ Num=1; Script="Fix-01-CRLF.ps1";            Desc="Encodage CRLF vers LF (42 fichiers YAML)" }
    @{ Num=2; Script="Fix-02-Routing.ps1";          Desc="Consolidation hub_routing.yaml (4 copies vers 2 sources)" }
    @{ Num=3; Script="Fix-03-SchemaVersion.ps1";    Desc="schema_version manquant (3 agents META)" }
    @{ Num=4; Script="Fix-04-SyncOPS.ps1";          Desc="Sync agents OPS core vers 10 produits" }
    @{ Num=5; Script="Fix-05-HUBOrchestrator.ps1";  Desc="Deprecier HUB-Orchestrator legacy" }
    @{ Num=6; Script="Fix-06-CRLF-Products.ps1";   Desc="Encodage CRLF vers LF (42 fichiers YAML)" }
)

$results = [System.Collections.Generic.List[PSObject]]::new()

foreach ($fix in $fixes) {
    $num    = $fix.Num
    $script = $fix.Script
    $desc   = $fix.Desc

    if ($SkipFix -contains $num) {
        Write-Host "  [SKIP] Fix-0$num ignore (-SkipFix $num)" -ForegroundColor DarkGray
        $results.Add([PSCustomObject]@{ Num=$num; Script=$script; Status="SKIPPED"; OK=$true; Duration=0 })
        continue
    }

    $scriptPath = Join-Path $scriptsDir $script

    Write-Host ""
    Write-Host "----------------------------------------------------------------------" -ForegroundColor DarkCyan
    Write-Host "  [0$num/05] $script" -ForegroundColor White
    Write-Host "          $desc" -ForegroundColor DarkGray
    Write-Host "----------------------------------------------------------------------" -ForegroundColor DarkCyan
    Write-Host ""

    if (-not (Test-Path $scriptPath)) {
        Write-Host "  [ERREUR] Script introuvable : $scriptPath" -ForegroundColor Red
        $results.Add([PSCustomObject]@{ Num=$num; Script=$script; Status="MISSING"; OK=$false; Duration=0 })
        if ($StopOnError) { break }
        continue
    }

    try {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()

        $params = @{ FactoryPath = $FactoryPath }
        if ($DryRun) { $params.DryRun = $true }
        if ($num -eq 4) { $params.ProductsPath = $ProductsPath }

        & $scriptPath @params

        $sw.Stop()
        $ok     = ($LASTEXITCODE -eq 0) -or ($null -eq $LASTEXITCODE)
        if ($ok) { $status = "OK" } else { $status = "WARN" }

        $results.Add([PSCustomObject]@{
            Num      = $num
            Script   = $script
            Status   = $status
            OK       = $ok
            Duration = [math]::Round($sw.Elapsed.TotalSeconds, 1)
        })

        if ((-not $ok) -and $StopOnError) {
            Write-Host "  [STOP] Erreur detectee et -StopOnError actif." -ForegroundColor Red
            break
        }

    } catch {
        $results.Add([PSCustomObject]@{
            Num      = $num
            Script   = $script
            Status   = "ERREUR"
            OK       = $false
            Duration = 0
        })
        Write-Host "  [ERREUR] $($_.Exception.Message)" -ForegroundColor Red
        if ($StopOnError) { break }
    }
}

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "                       RAPPORT FINAL                                  " -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan

foreach ($r in $results) {
    if ($r.Status -eq "OK")      { $color = "Green"   ; $icon = "[OK]  " }
    elseif ($r.Status -eq "SKIPPED") { $color = "DarkGray"; $icon = "[SKIP]" }
    elseif ($r.OK)               { $color = "Yellow"  ; $icon = "[WARN]" }
    else                         { $color = "Red"     ; $icon = "[ERR] " }

    if ($r.Duration -gt 0) { $dur = "$($r.Duration)s" } else { $dur = "-" }
    Write-Host ("  $icon  Fix-0{0}  {1,-40}  {2}" -f $r.Num, $r.Script, $dur) -ForegroundColor $color
}

Write-Host "======================================================================" -ForegroundColor Cyan

$errCount = ($results | Where-Object { -not $_.OK }).Count

if ($errCount -eq 0 -and -not $DryRun) {
    Write-Host "  RESULTAT : TOUS LES CORRECTIFS APPLIQUES" -ForegroundColor Green
} elseif ($DryRun) {
    Write-Host "  DRY-RUN TERMINE - Relancer sans -DryRun pour appliquer" -ForegroundColor Yellow
} else {
    Write-Host "  RESULTAT : $errCount correctif(s) en erreur" -ForegroundColor Red
}

Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

if ((-not $DryRun) -and ($errCount -eq 0)) {
    Write-Host "PROCHAINES ETAPES :" -ForegroundColor White
    Write-Host ""
    Write-Host "  1. Valider la factory :"
    Write-Host "     cd ..\FACTORY\99_VALIDATION" -ForegroundColor DarkGray
    Write-Host "     .\Run-Validation.ps1 -RootPath .." -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  2. Health check (dans le GPT) :"
    Write-Host "     @OPS-PlaybookRunner -> playbook_id: FACTORY_HEALTH_CHECK" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  3. Commit Git :"
    Write-Host "     git add -A" -ForegroundColor DarkGray
    Write-Host "     git commit -m fix: 5 corrections majeures root_IA" -ForegroundColor DarkGray
    Write-Host ""
}

if ($DryRun) {
    Write-Host "Pour appliquer : .\Run-AllFixes.ps1  (sans -DryRun)" -ForegroundColor Cyan
}
