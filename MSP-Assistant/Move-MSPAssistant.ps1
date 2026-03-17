#Requires -Version 5.1
# ============================================================
# Move-MSPAssistant.ps1
# Deplace MSP-Assistant de C:\MSP-Assistant vers le dossier IA
# ============================================================
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$Source = "C:\MSP-Assistant"
$Target = "C:\Intranet_EA\EA4AI\GPT-Enterprise\MSP-Assistant"

Write-Host ""
Write-Host "=== Demenagement MSP-Assistant ===" -ForegroundColor Cyan
Write-Host "Source : $Source"
Write-Host "Cible  : $Target"
Write-Host ""

# Creer la structure cible
foreach ($folder in @("DB","Scripts","Reports")) {
    $path = Join-Path $Target $folder
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
        Write-Host "[OK] Dossier cree : $path" -ForegroundColor Green
    }
}

# Copier si source existe
if (Test-Path $Source) {
    Get-ChildItem $Source -Recurse -File | ForEach-Object {
        $relative = $_.FullName.Substring($Source.Length)
        $dest     = Join-Path $Target $relative
        $destDir  = Split-Path $dest -Parent
        if (-not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
        Copy-Item $_.FullName -Destination $dest -Force
        Write-Host "[COPIE] $relative" -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "[OK] Copie terminee." -ForegroundColor Green
    Write-Host "[INFO] Verifie que tout fonctionne, puis supprime l'ancien dossier :" -ForegroundColor Gray
    Write-Host "       Remove-Item -Recurse -Force '$Source'" -ForegroundColor Gray
} else {
    Write-Host "[INFO] $Source n'existe pas — structure cible creee." -ForegroundColor Cyan
}

Write-Host ""
Write-Host "=== Structure finale ===" -ForegroundColor Cyan
Get-ChildItem $Target -Recurse | Select-Object FullName
Write-Host ""
Write-Host "PROCHAINE ETAPE : python Scripts\create_db.py" -ForegroundColor Green
