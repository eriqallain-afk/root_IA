@echo off
REM Run-RebuildIndexes.cmd
REM Double-click to rebuild indexes/bundles with ExecutionPolicy Bypass.

setlocal
set SCRIPT_DIR=%~dp0

powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%Run-RebuildIndexes.ps1" -Bundles -MirrorSchemas

echo.
echo (Fin) Si tu vois une erreur, copie-colle le texte a ChatGPT.
pause
endlocal
