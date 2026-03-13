@echo off
:: ============================================================
:: Launch-Validation.cmd
:: Lanceur EA4AI — contourne ExecutionPolicy sans la modifier.
:: Usage : double-clic ou appel depuis la console.
:: ============================================================

setlocal
set "SCRIPT_DIR=%~dp0"
set "ROOTPATH=C:\Intranet_EA\EA4AI\GPT-Enterprise\root_IA\FACTORY"

:: Accepter un argument custom : Launch-Validation.cmd C:\Intranet_EA\EA4AI\GPT-Enterprise\root_IA\
if not "%~1"=="" set "ROOTPATH=%~1"

echo === EA4AI Validation Launcher ===
echo RootPath : %ROOTPATH%
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%Run-Validation.ps1" -RootPath "%ROOTPATH%"
set "EXITCODE=%ERRORLEVEL%"

echo.
if %EXITCODE% EQU 0 (
  echo [OK]  Validation reussie.
) else (
  echo [ERR] Validation echouee. Code: %EXITCODE%
)

pause
exit /b %EXITCODE%
