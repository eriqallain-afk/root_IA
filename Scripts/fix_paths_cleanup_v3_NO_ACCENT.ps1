# Script Final V3 - Correction Chemins + Nettoyage ROOT IA
# Version: 3.0.1 - SANS ACCENTS (fix encoding)

function Write-Header {
    param($Message)
    Write-Host "`n============================================" -ForegroundColor Blue
    Write-Host $Message -ForegroundColor Blue
    Write-Host "============================================`n" -ForegroundColor Blue
}

function Write-Success {
    param($Message)
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-Warning {
    param($Message)
    Write-Host "[!] $Message" -ForegroundColor Yellow
}

function Write-Info {
    param($Message)
    Write-Host "[i] $Message" -ForegroundColor Cyan
}

function Write-Error {
    param($Message)
    Write-Host "[X] $Message" -ForegroundColor Red
}

# Verification securite
function Check-Safety {
    Write-Header "VERIFICATION SECURITE"
    
    if (-not (Test-Path "FACTORY") -or -not (Test-Path "PRODUCTS")) {
        Write-Error "FACTORY ou PRODUCTS manquant!"
        exit 1
    }
    
    $factoryCount = 0
    Get-ChildItem "FACTORY\20_AGENTS" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        $count = (Get-ChildItem $_.FullName -Directory).Count
        $factoryCount += $count
    }
    
    $productsCount = 0
    Get-ChildItem "PRODUCTS" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        if (Test-Path "$($_.FullName)\agents") {
            $count = (Get-ChildItem "$($_.FullName)\agents" -Directory -ErrorAction SilentlyContinue).Count
            $productsCount += $count
        }
    }
    
    if ($factoryCount -lt 30) {
        Write-Error "FACTORY: seulement $factoryCount agents (attendu 40+)"
        exit 1
    }
    
    if ($productsCount -lt 80) {
        Write-Error "PRODUCTS: seulement $productsCount agents (attendu 90+)"
        exit 1
    }
    
    Write-Success "FACTORY: $factoryCount agents OK"
    Write-Success "PRODUCTS: $productsCount agents OK"
    Write-Success "Migration semble complete, safe de continuer"
}

# Phase 1: Correction chemins FACTORY
function Fix-FactoryPaths {
    Write-Header "PHASE 1: CORRECTION CHEMINS FACTORY"
    
    $filesFixed = 0
    $files = Get-ChildItem -Path "FACTORY" -Recurse -Include *.yaml,*.md,*.json -File -ErrorAction SilentlyContinue
    
    Write-Info "Traitement de $($files.Count) fichiers..."
    
    foreach ($file in $files) {
        try {
            $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
            
            if ($content -and ($content -match '20_AGENTS/')) {
                $originalContent = $content
                
                # Pattern: "20_AGENTS/..." -> "FACTORY/20_AGENTS/..."
                $content = $content -replace '(["\'':])\s*20_AGENTS/', '$1FACTORY/20_AGENTS/'
                
                # Pattern: root_IA/20_AGENTS/ -> root_IA/FACTORY/20_AGENTS/
                $content = $content -replace 'root_IA/20_AGENTS/', 'root_IA/FACTORY/20_AGENTS/'
                
                # Pattern: ../20_AGENTS/ -> ../FACTORY/20_AGENTS/
                $content = $content -replace '\.\./20_AGENTS/', '../FACTORY/20_AGENTS/'
                
                if ($content -ne $originalContent) {
                    $content | Out-File -FilePath $file.FullName -Encoding UTF8 -NoNewline
                    $filesFixed++
                }
            }
        }
        catch {
            Write-Warning "Erreur fichier: $($file.Name)"
        }
    }
    
    Write-Success "FACTORY: $filesFixed fichiers corriges"
}

# Phase 2: Correction chemins PRODUCTS
function Fix-ProductsPaths {
    Write-Header "PHASE 2: CORRECTION CHEMINS PRODUCTS"
    
    $filesFixed = 0
    $files = Get-ChildItem -Path "PRODUCTS" -Recurse -Include *.yaml,*.md,*.json -File -ErrorAction SilentlyContinue
    
    Write-Info "Traitement de $($files.Count) fichiers..."
    
    foreach ($file in $files) {
        try {
            $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
            
            if ($content -and ($content -match '20_AGENTS/')) {
                $originalContent = $content
                $relativePath = $file.FullName
                
                # Detecter equipe (IT, DAM, etc.)
                if ($relativePath -match 'PRODUCTS\\(IT|DAM|IASM|TRAD|EDU|NEA|PLR|ESPL)') {
                    $team = $matches[1]
                    
                    # "20_AGENTS/IT/..." -> "PRODUCTS/IT/agents/..."
                    $content = $content -replace "([`"':]\s*)20_AGENTS/$team/", "`$1PRODUCTS/$team/agents/"
                    
                    # root_IA/20_AGENTS/IT/ -> root_IA/PRODUCTS/IT/agents/
                    $content = $content -replace "root_IA/20_AGENTS/$team/", "root_IA/PRODUCTS/$team/agents/"
                    
                    # ../20_AGENTS/IT/ -> ../agents/
                    $content = $content -replace "\.\./20_AGENTS/$team/", "../agents/"
                }
                
                if ($content -ne $originalContent) {
                    $content | Out-File -FilePath $file.FullName -Encoding UTF8 -NoNewline
                    $filesFixed++
                }
            }
        }
        catch {
            Write-Warning "Erreur fichier: $($file.Name)"
        }
    }
    
    Write-Success "PRODUCTS: $filesFixed fichiers corriges"
}

# Phase 3: Correction chemins SHARED
function Fix-SharedPaths {
    Write-Header "PHASE 3: CORRECTION CHEMINS SHARED"
    
    $filesFixed = 0
    
    # Corriger references dans tous les fichiers
    $allFiles = @()
    $allFiles += Get-ChildItem -Path "FACTORY" -Recurse -Include *.yaml,*.md,*.json -File -ErrorAction SilentlyContinue
    $allFiles += Get-ChildItem -Path "PRODUCTS" -Recurse -Include *.yaml,*.md,*.json -File -ErrorAction SilentlyContinue
    if (Test-Path "SHARED") {
        $allFiles += Get-ChildItem -Path "SHARED" -Recurse -Include *.yaml,*.md,*.json -File -ErrorAction SilentlyContinue
    }
    
    Write-Info "Traitement de $($allFiles.Count) fichiers..."
    
    foreach ($file in $allFiles) {
        try {
            $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
            
            if ($content -and ($content -match '70_INTEGRATION_PACKAGES/|90_MEMORY/')) {
                $originalContent = $content
                
                # 70_INTEGRATION_PACKAGES/ -> SHARED/70_INTEGRATION_PACKAGES/
                $content = $content -replace '(["\'':])\s*70_INTEGRATION_PACKAGES/', '$1SHARED/70_INTEGRATION_PACKAGES/'
                
                # 90_MEMORY/ -> SHARED/90_MEMORY/
                $content = $content -replace '(["\'':])\s*90_MEMORY/', '$1SHARED/90_MEMORY/'
                
                if ($content -ne $originalContent) {
                    $content | Out-File -FilePath $file.FullName -Encoding UTF8 -NoNewline
                    $filesFixed++
                }
            }
        }
        catch {
            Write-Warning "Erreur fichier: $($file.Name)"
        }
    }
    
    Write-Success "Chemins SHARED corriges dans $filesFixed fichiers"
}

# Phase 4: Validation corrections
function Validate-Corrections {
    Write-Header "PHASE 4: VALIDATION CORRECTIONS"
    
    Write-Info "Recherche chemins casses restants..."
    
    $badPaths = @()
    
    Get-ChildItem -Path "FACTORY","PRODUCTS","SHARED" -Recurse -Include *.yaml,*.md -File -ErrorAction SilentlyContinue | ForEach-Object {
        $content = Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue
        
        if ($content -match '"20_AGENTS/' -and $content -notmatch 'FACTORY/20_AGENTS/|PRODUCTS/.*/agents/') {
            $badPaths += $_.FullName
        }
    }
    
    if ($badPaths.Count -eq 0) {
        Write-Success "Tous les chemins corriges!"
    } else {
        Write-Warning "$($badPaths.Count) fichiers avec chemins potentiellement casses"
        $badPaths | Select-Object -First 5 | ForEach-Object {
            Write-Host "  - $_"
        }
    }
}

# Phase 5: Archive
function Create-Archive {
    Write-Header "PHASE 5: ARCHIVE DE SECURITE"
    
    $zipName = "ARCHIVE_DOUBLONS_$(Get-Date -Format 'yyyyMMdd_HHmmss').zip"
    $tempDir = "_TEMP_ARCHIVE"
    
    New-Item -ItemType Directory -Force -Path $tempDir | Out-Null
    
    Write-Info "Archivage doublons..."
    
    # Archiver SEULEMENT les doublons
    if (Test-Path "20_AGENTS") {
        Copy-Item -Path "20_AGENTS" -Destination "$tempDir\" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  [ARCHIVE] 20_AGENTS/"
    }
    
    if (Test-Path "70_INTEGRATION_PACKAGES") {
        Copy-Item -Path "70_INTEGRATION_PACKAGES" -Destination "$tempDir\" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  [ARCHIVE] 70_INTEGRATION_PACKAGES/"
    }
    
    if (Test-Path "10_TEAMS") {
        Copy-Item -Path "10_TEAMS" -Destination "$tempDir\" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  [ARCHIVE] 10_TEAMS/"
    }
    
    Compress-Archive -Path "$tempDir\*" -DestinationPath $zipName -Force
    Remove-Item -Path $tempDir -Recurse -Force
    
    Write-Success "Archive creee: $zipName"
    Write-Warning "Gardez ce ZIP pendant 30 jours!"
    
    return $zipName
}

# Phase 6: Suppression DOUBLONS SEULEMENT
function Remove-Duplicates {
    param($ZipName)
    
    Write-Header "PHASE 6: SUPPRESSION DOUBLONS"
    
    Write-Host ""
    Write-Host "DOUBLONS A SUPPRIMER:" -ForegroundColor Yellow
    Write-Host "  - 20_AGENTS/ (existe dans FACTORY et PRODUCTS)"
    Write-Host "  - 70_INTEGRATION_PACKAGES/ (existe dans SHARED)"
    Write-Host "  - 10_TEAMS/ (si existe)"
    Write-Host ""
    Write-Host "GARDER A LA RACINE:" -ForegroundColor Green
    Write-Host "  - 00_ROOT/ (registry global)"
    Write-Host "  - 00_CONTROL/ (controle)"
    Write-Host "  - 00_CONTROL_PLANE/"
    Write-Host "  - 30_INTERFACES/"
    Write-Host "  - 30_PLAYBOOKS/"
    Write-Host "  - 60_CHANGELOG/"
    Write-Host "  - 80_MACHINES/"
    Write-Host "  - FACTORY/"
    Write-Host "  - PRODUCTS/"
    Write-Host "  - SHARED/"
    Write-Host ""
    Write-Host "Archive: $ZipName" -ForegroundColor Cyan
    Write-Host ""
    
    $response = Read-Host "Confirmer suppression DOUBLONS seulement? (tapez OUI)"
    
    if ($response -ne "OUI") {
        Write-Info "Suppression annulee"
        return $false
    }
    
    # Supprimer UNIQUEMENT les doublons confirmes
    $toDelete = @("20_AGENTS", "70_INTEGRATION_PACKAGES", "10_TEAMS")
    
    foreach ($item in $toDelete) {
        if (Test-Path $item) {
            Write-Info "Suppression: $item"
            Remove-Item -Path $item -Recurse -Force -ErrorAction SilentlyContinue
            
            if (-not (Test-Path $item)) {
                Write-Success "$item supprime"
            } else {
                Write-Warning "$item pas completement supprime"
            }
        }
    }
    
    return $true
}

# Verification finale
function Final-Verification {
    Write-Header "VERIFICATION FINALE"
    
    Write-Host "`nSTRUCTURE FINALE RACINE:"
    
    $rootDirs = Get-ChildItem -Directory | Select-Object -ExpandProperty Name | Sort-Object
    
    $shouldKeep = @("00_ROOT", "00_CONTROL", "00_CONTROL_PLANE", "30_INTERFACES", "30_PLAYBOOKS", 
                    "60_CHANGELOG", "80_MACHINES", "FACTORY", "PRODUCTS", "SHARED")
    
    $shouldDelete = @("20_AGENTS", "70_INTEGRATION_PACKAGES", "10_TEAMS")
    
    foreach ($dir in $rootDirs) {
        if ($shouldKeep -contains $dir) {
            Write-Success "$dir (correct)"
        } elseif ($shouldDelete -contains $dir) {
            Write-Error "$dir (devrait etre supprime!)"
        } elseif ($dir -like "ARCHIVE*" -or $dir -like "_*") {
            Write-Info "$dir (archive)"
        } else {
            Write-Warning "$dir (inattendu)"
        }
    }
    
    Write-Host "`nCOMPTAGE FINAL:"
    
    $factoryCount = 0
    Get-ChildItem "FACTORY\20_AGENTS" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        $count = (Get-ChildItem $_.FullName -Directory).Count
        Write-Host "  FACTORY\$($_.Name): $count agents"
        $factoryCount += $count
    }
    Write-Success "TOTAL FACTORY: $factoryCount agents"
    
    $productsCount = 0
    Get-ChildItem "PRODUCTS" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        if (Test-Path "$($_.FullName)\agents") {
            $count = (Get-ChildItem "$($_.FullName)\agents" -Directory -ErrorAction SilentlyContinue).Count
            if ($count -gt 0) {
                Write-Host "  PRODUCTS\$($_.Name): $count agents"
                $productsCount += $count
            }
        }
    }
    Write-Success "TOTAL PRODUCTS: $productsCount agents"
    
    $total = $factoryCount + $productsCount
    Write-Success "GRAND TOTAL: $total agents"
}

# Rapport final
function Final-Report {
    Write-Header "NETTOYAGE TERMINE"
    
    Write-Host ""
    Write-Host "Structure ROOT IA nettoyee!" -ForegroundColor Green
    Write-Host ""
    Write-Host "ACTIONS EFFECTUEES:"
    Write-Host "  1. Chemins corriges FACTORY"
    Write-Host "  2. Chemins corriges PRODUCTS"
    Write-Host "  3. Chemins corriges SHARED"
    Write-Host "  4. Archive doublons creee"
    Write-Host "  5. Doublons supprimes"
    Write-Host ""
    Write-Host "STRUCTURE FINALE (12 dossiers racine):"
    Write-Host "  ROOT_IA\"
    Write-Host "    00_ROOT\ 00_CONTROL\ 00_CONTROL_PLANE\"
    Write-Host "    30_INTERFACES\ 30_PLAYBOOKS\"
    Write-Host "    60_CHANGELOG\ 80_MACHINES\"
    Write-Host "    FACTORY\ PRODUCTS\ SHARED\"
    Write-Host "    README.md root_ia_index.yaml"
    Write-Host ""
}

# MAIN
function Main {
    Clear-Host
    
    Write-Header "NETTOYAGE ROOT IA - VERSION 3.0.1"
    Write-Host "Correction chemins + Suppression doublons" -ForegroundColor Blue
    Write-Host ""
    
    $response = Read-Host "Demarrer? (o/n)"
    
    if ($response -ne "o" -and $response -ne "O") {
        Write-Info "Annule"
        exit 0
    }
    
    Check-Safety
    Fix-FactoryPaths
    Fix-ProductsPaths
    Fix-SharedPaths
    Validate-Corrections
    
    $zipName = Create-Archive
    $deleted = Remove-Duplicates -ZipName $zipName
    
    if ($deleted) {
        Final-Verification
        Final-Report
    } else {
        Write-Warning "Suppression annulee - Chemins corriges quand meme"
    }
}

Main
