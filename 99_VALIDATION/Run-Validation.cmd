@echo off
REM Run-Validation.cmd — Lance la validation sans restriction de signature
REM Usage : double-clic OU appel depuis CMD/PowerShell
REM Correction 2026-03-13
SETLOCAL
SET "SCRIPT_DIR=%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%Run-Validation.ps1" %*
SET "EC=%ERRORLEVEL%"
ENDLOCAL
exit /b %EC%
