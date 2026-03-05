@echo off
REM Simple launcher for Windows.
REM Usage:
REM   scripts\rebuild_indexes.cmd
REM   scripts\rebuild_indexes.cmd --bundles --mirror-schemas --force

setlocal
set REPO=%~dp0..
set ARGS=%*

REM Prefer py -3
where py >nul 2>&1
if %errorlevel%==0 (
  py -3 "%REPO%\scripts\rebuild_indexes.py" --root "%REPO%" %ARGS%
  exit /b %errorlevel%
)

where python >nul 2>&1
if %errorlevel%==0 (
  python "%REPO%\scripts\rebuild_indexes.py" --root "%REPO%" %ARGS%
  exit /b %errorlevel%
)

echo Python 3 introuvable. Installe Python ou le launcher 'py'.
exit /b 2
