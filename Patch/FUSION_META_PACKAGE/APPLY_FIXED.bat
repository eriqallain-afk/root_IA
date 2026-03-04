@echo off
chcp 65001 > nul
REM Script d'application - Fusion META (10 -> 8 agents)
REM Date: 2026-02-01

echo === FUSION META - Application du package ===
echo.
echo Ce script va appliquer la fusion META via PowerShell.
echo.

REM Verifier PowerShell
where powershell >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERREUR: PowerShell n'est pas disponible
    pause
    exit /b 1
)

REM Executer le script PowerShell
echo Execution du script PowerShell...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0APPLY_FIXED.ps1"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo === SUCCESS ===
) else (
    echo.
    echo === ERREUR lors de l'execution ===
)

pause
