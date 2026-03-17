#Requires -Version 5.1
# ============================================================
# insert_from_prompt.ps1 — MSP-Assistant v1.1
# Appele par IT-AssistanceTechnique apres /close
# Cree un JSON temporaire et appelle insert_entry.py
# ============================================================
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

param(
    [Parameter(Mandatory=$true)]  [string]$Client,
    [Parameter(Mandatory=$true)]  [string]$Ticket,
    [string]$Technicien      = $env:USERNAME,
    [string]$Debut           = (Get-Date -Format "yyyy-MM-dd HH:mm"),
    [string]$Fin             = (Get-Date -Format "yyyy-MM-dd HH:mm"),
    [string]$Resume          = "",
    [string]$NoteInterne     = "",
    [string]$Discussion      = "",
    [string]$CourrielClient  = "",
    [string]$Teams           = "",
    [string]$Scripts         = "",
    [string]$Diagnostic      = "",
    [string]$Chronologie     = ""
)

$BasePath = "C:\Intranet_EA\EA4AI\GPT-Enterprise\root_IA\MSP-Assistant"
$ScriptPy = Join-Path $BasePath "Scripts\insert_entry.py"
$TempJson = Join-Path $env:TEMP ("msp_entry_" + (Get-Date -Format "yyyyMMddHHmmss") + ".json")

# Valider que le script Python existe
if (-not (Test-Path $ScriptPy)) {
    Write-Host "[ERREUR] Script Python introuvable : $ScriptPy" -ForegroundColor Red
    exit 1
}

# Construire le JSON avec les 13 champs
$data = [ordered]@{
    client           = $Client
    ticket           = $Ticket
    technicien       = $Technicien
    debut            = $Debut
    fin              = $Fin
    resume           = $Resume
    note_interne     = $NoteInterne
    discussion       = $Discussion
    courriel_client  = $CourrielClient
    teams            = $Teams
    scripts_suggeres = $Scripts
    diagnostic       = $Diagnostic
    chronologie      = $Chronologie
}

$data | ConvertTo-Json -Depth 3 | Out-File -FilePath $TempJson -Encoding UTF8
Write-Host "[OK] JSON temporaire cree : $TempJson" -ForegroundColor Cyan

# Appeler Python
Write-Host "[...] Insertion dans la DB..." -ForegroundColor Yellow
python "$ScriptPy" "$TempJson"

if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Intervention inseree dans MSP-Assistant DB" -ForegroundColor Green
} else {
    Write-Host "[ERREUR] Echec insertion — verifier Python et le chemin DB" -ForegroundColor Red
}

# Nettoyer le JSON temporaire
Remove-Item $TempJson -ErrorAction SilentlyContinue
