@echo off
REM Script d'application — Fusion META (10 → 8 agents)
REM Date: 2026-02-01
REM Windows CMD version

echo === FUSION META - Application du package ===
echo.
echo Ce script va appliquer la fusion META via PowerShell.
echo.

REM Vérifier PowerShell
where powershell >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERREUR: PowerShell n'est pas disponible
    pause
    exit /b 1
)

REM Exécuter le script PowerShell
echo Execution du script PowerShell...
powershell -ExecutionPolicy Bypass -File "%~dp0APPLY.ps1"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo === SUCCESS ===
) else (
    echo.
    echo === ERREUR lors de l'execution ===
)

pause
