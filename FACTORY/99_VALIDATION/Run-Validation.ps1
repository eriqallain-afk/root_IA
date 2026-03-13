<#
.SYNOPSIS
    Run-Validation.ps1 — Lance la suite de validation EA4AI (layout SPLIT).

.DESCRIPTION
    Orchestre Validate-Refs.ps1 et Validate-Naming.ps1 puis lance
    les 6 validateurs Python de la FACTORY.

    STRUCTURE ATTENDUE :
      root_IA\
        99_VALIDATION\    <- Ce script est ici
          _lib\
            ValidationLib.ps1
          Validate-Refs.ps1
          Validate-Naming.ps1
        FACTORY\
          99_VALIDATION\  <- scripts Python FACTORY
        PRODUCTS\
        Scripts\

    CORRECTION v2 (2026-03) :
      - Chemin hardcode supprime. RootPath derive automatiquement du
        dossier parent de ce script (racine du repo).
      - PythonExe detecte automatiquement (python ou python3).
      - Rapport final colore avec compteur PASS/FAIL.

.PARAMETER RootPath
    Chemin racine du repo root_IA.
    Par defaut : dossier PARENT de 99_VALIDATION\ (auto-detection).

.PARAMETER PythonExe
    Executable Python a utiliser. Par defaut : auto-detection.

.PARAMETER SkipPython
    Ignorer les validateurs Python (PS1 seulement).

.EXAMPLE
    # Depuis n'importe ou :
    & "C:\Intranet_EA\root_IA\99_VALIDATION\Run-Validation.ps1"

    # Depuis 99_VALIDATION\ :
    .\Run-Validation.ps1

    # Avec chemin explicite :
    .\Run-Validation.ps1 -RootPath "D:\MonProjet\root_IA"

    # PS1 seulement (sans Python) :
    .\Run-Validation.ps1 -SkipPython
#>
[CmdletBinding()]
param(
    [string]$RootPath   = "",
    [string]$PythonExe  = "",
    [switch]$SkipPython
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ------------------------------------------------------------------
# 0. Calcul des chemins
# ------------------------------------------------------------------
$here = $PSScriptRoot   # root_IA\99_VALIDATION\

# Auto-detection RootPath = parent de 99_VALIDATION\
if ([string]::IsNullOrWhiteSpace($RootPath)) {
    $RootPath = Split-Path $here -Parent
}
$RootPath = (Resolve-Path -LiteralPath $RootPath -ErrorAction Stop).Path

$FactoryPath  = Join-Path $RootPath "FACTORY"
$ValDirPy     = Join-Path $FactoryPath "99_VALIDATION"   # scripts Python FACTORY
$ValDirPs1    = $here                                    # scripts PS1 racine

# ------------------------------------------------------------------
# 1. Verification structure
# ------------------------------------------------------------------
if (-not (Test-Path -LiteralPath $RootPath)) {
    Write-Host "[FATAL] RootPath introuvable : $RootPath" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path -LiteralPath $FactoryPath)) {
    Write-Host "[FATAL] FACTORY\ introuvable : $FactoryPath" -ForegroundColor Red
    Write-Host "        Verifier la structure du repo." -ForegroundColor Yellow
    exit 1
}

# ------------------------------------------------------------------
# 2. Detection Python
# ------------------------------------------------------------------
if (-not $SkipPython) {
    if ([string]::IsNullOrWhiteSpace($PythonExe)) {
        foreach ($candidate in @("python", "python3", "py")) {
            try {
                $ver = & $candidate --version 2>&1
                if ($LASTEXITCODE -eq 0) {
                    $PythonExe = $candidate
                    break
                }
            } catch { }
        }
    }
    if ([string]::IsNullOrWhiteSpace($PythonExe)) {
        Write-Host "[WARN] Python non trouve -- validateurs Python ignores." -ForegroundColor Yellow
        Write-Host "       Installer Python : https://www.python.org/downloads/" -ForegroundColor Yellow
        $SkipPython = $true
    }
}

# ------------------------------------------------------------------
# 3. Affichage configuration
# ------------------------------------------------------------------
Write-Host ""
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "        EA4AI -- Run-Validation.ps1 (layout SPLIT)              " -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "  RootPath    : $RootPath"
Write-Host "  FACTORY     : $FactoryPath"
if (-not $SkipPython) {
    Write-Host "  Python      : $PythonExe  ($( & $PythonExe --version 2>&1 ))"
} else {
    Write-Host "  Python      : IGNORE (-SkipPython)" -ForegroundColor DarkGray
}
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

# ------------------------------------------------------------------
# 4. Chargement librairie PS1
# ------------------------------------------------------------------
$libPath = Join-Path $here "_lib\ValidationLib.ps1"
if (-not (Test-Path -LiteralPath $libPath)) {
    Write-Host "[FATAL] ValidationLib.ps1 introuvable : $libPath" -ForegroundColor Red
    exit 1
}
. $libPath

# ------------------------------------------------------------------
# 5. Registre des etapes
# ------------------------------------------------------------------
$steps = [System.Collections.Generic.List[PSObject]]::new()
$ec    = 0  # exit code global

function Invoke-Step {
    param(
        [string]$Label,
        [scriptblock]$Action
    )
    Write-Host ""
    Write-Host "-----------------------------------------------------------------" -ForegroundColor DarkCyan
    Write-Host "  $Label" -ForegroundColor White
    Write-Host "-----------------------------------------------------------------" -ForegroundColor DarkCyan

    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $ok = $true
    try {
        & $Action
        if ($LASTEXITCODE -ne $null -and $LASTEXITCODE -ne 0) {
            $ok = $false
        }
    } catch {
        Write-Host "  [ERREUR] $($_.Exception.Message)" -ForegroundColor Red
        $ok = $false
    }
    $sw.Stop()
    $dur = "$([math]::Round($sw.Elapsed.TotalSeconds,1))s"

    if ($ok) {
        Write-Host "  [OK]  $Label  ($dur)" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] $Label  ($dur)" -ForegroundColor Red
        $script:ec = 1
    }

    $steps.Add([PSCustomObject]@{
        Label = $Label
        OK    = $ok
        Dur   = $dur
    })
}

# ------------------------------------------------------------------
# 6a. Validateurs PowerShell
# ------------------------------------------------------------------
Invoke-Step "PS1 — Validate-Refs.ps1" {
    $script = Join-Path $ValDirPs1 "Validate-Refs.ps1"
    & $script -RootPath $FactoryPath
}

Invoke-Step "PS1 — Validate-Naming.ps1" {
    $script = Join-Path $ValDirPs1 "Validate-Naming.ps1"
    & $script -RootPath $FactoryPath
}

# ------------------------------------------------------------------
# 6b. Validateurs Python (si disponibles)
# ------------------------------------------------------------------
if (-not $SkipPython) {

    Invoke-Step "PY  — validate_integrity.py" {
        Push-Location $FactoryPath
        & $PythonExe (Join-Path $ValDirPy "validate_integrity.py")
        Pop-Location
    }

    Invoke-Step "PY  — validate_schemas.py" {
        Push-Location $RootPath
        & $PythonExe (Join-Path $here "validate_schemas.py")
        Pop-Location
    }

    Invoke-Step "PY  — validate_refs.py" {
        Push-Location $FactoryPath
        & $PythonExe (Join-Path $ValDirPy "validate_refs.py") `
            --agents-index "00_INDEX/agents_index.yaml" `
            --gpt-catalog  "00_INDEX/gpt_catalog.yaml" `
            --hub-routing  "80_MACHINES/hub_routing.yaml" `
            --playbooks    "40_RUNBOOKS/playbooks.yaml"
        Pop-Location
    }

    Invoke-Step "PY  — run_golden_tests.py" {
        Push-Location $FactoryPath
        & $PythonExe (Join-Path $ValDirPy "run_golden_tests.py")
        Pop-Location
    }

    Invoke-Step "PY  — validate_machine_output.py" {
        Push-Location $FactoryPath
        & $PythonExe (Join-Path $ValDirPy "validate_machine_output.py")
        Pop-Location
    }

    Invoke-Step "PY  — validate_no_fake_citations.py" {
        Push-Location $RootPath
        & $PythonExe (Join-Path $here "validate_no_fake_citations.py")
        Pop-Location
    }
}

# ------------------------------------------------------------------
# 7. Rapport final
# ------------------------------------------------------------------
Write-Host ""
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "                      RAPPORT FINAL                             " -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan

$nbOK   = ($steps | Where-Object { $_.OK }).Count
$nbFail = ($steps | Where-Object { -not $_.OK }).Count

foreach ($s in $steps) {
    if ($s.OK) {
        Write-Host ("  [OK]  {0,-50} {1}" -f $s.Label, $s.Dur) -ForegroundColor Green
    } else {
        Write-Host ("  [FAIL] {0,-50} {1}" -f $s.Label, $s.Dur) -ForegroundColor Red
    }
}

Write-Host ""
Write-Host ("  Total : {0} OK  /  {1} FAIL  /  {2} etapes" -f $nbOK, $nbFail, $steps.Count)
Write-Host "=================================================================" -ForegroundColor Cyan

if ($ec -eq 0) {
    Write-Host "  [RESULTAT] TOUT EST CONFORME -- repo 100% valide." -ForegroundColor Green
} else {
    Write-Host "  [RESULTAT] ECHEC -- $nbFail etape(s) en erreur. Corriger puis relancer." -ForegroundColor Red
}

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

exit $ec
