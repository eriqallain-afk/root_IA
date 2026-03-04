@echo off
setlocal

REM =========================================================
REM Création de la structure 00_CONTROL dans root_IA\Factory
REM =========================================================

REM Ajuste ce chemin si nécessaire
set "BASE=Factory"

echo Creation de la structure dans : %BASE%
echo.

REM -------------------------
REM Dossiers
REM -------------------------
mkdir "%BASE%" 2>nul
mkdir "%BASE%\agents" 2>nul
mkdir "%BASE%\agents\CTL-WatchdogIA" 2>nul
mkdir "%BASE%\agents\CTL-AlertRouter" 2>nul
mkdir "%BASE%\agents\CTL-HealthReporter" 2>nul

mkdir "%BASE%\dashboards" 2>nul
mkdir "%BASE%\schemas" 2>nul
mkdir "%BASE%\policies" 2>nul
mkdir "%BASE%\runbooks" 2>nul

REM -------------------------
REM Fichiers - CTL-WatchdogIA
REM -------------------------
if not exist "%BASE%\agents\CTL-WatchdogIA\agent.yaml" type nul > "%BASE%\agents\CTL-WatchdogIA\agent.yaml"
if not exist "%BASE%\agents\CTL-WatchdogIA\prompt.md" type nul > "%BASE%\agents\CTL-WatchdogIA\prompt.md"
if not exist "%BASE%\agents\CTL-WatchdogIA\contract.yaml" type nul > "%BASE%\agents\CTL-WatchdogIA\contract.yaml"

REM -------------------------
REM Fichiers - CTL-AlertRouter
REM -------------------------
if not exist "%BASE%\agents\CTL-AlertRouter\agent.yaml" type nul > "%BASE%\agents\CTL-AlertRouter\agent.yaml"
if not exist "%BASE%\agents\CTL-AlertRouter\prompt.md" type nul > "%BASE%\agents\CTL-AlertRouter\prompt.md"
if not exist "%BASE%\agents\CTL-AlertRouter\contract.yaml" type nul > "%BASE%\agents\CTL-AlertRouter\contract.yaml"

REM -------------------------
REM Fichiers - CTL-HealthReporter
REM -------------------------
if not exist "%BASE%\agents\CTL-HealthReporter\agent.yaml" type nul > "%BASE%\agents\CTL-HealthReporter\agent.yaml"
if not exist "%BASE%\agents\CTL-HealthReporter\prompt.md" type nul > "%BASE%\agents\CTL-HealthReporter\prompt.md"
if not exist "%BASE%\agents\CTL-HealthReporter\contract.yaml" type nul > "%BASE%\agents\CTL-HealthReporter\contract.yaml"

REM -------------------------
REM Dashboards
REM -------------------------
if not exist "%BASE%\dashboards\FACTORY_HEALTH.yaml" type nul > "%BASE%\dashboards\FACTORY_HEALTH.yaml"
if not exist "%BASE%\dashboards\PLAYBOOK_METRICS.yaml" type nul > "%BASE%\dashboards\PLAYBOOK_METRICS.yaml"
if not exist "%BASE%\dashboards\AGENT_PERFORMANCE.yaml" type nul > "%BASE%\dashboards\AGENT_PERFORMANCE.yaml"

REM -------------------------
REM Schemas
REM -------------------------
if not exist "%BASE%\schemas\health_check.schema.yaml" type nul > "%BASE%\schemas\health_check.schema.yaml"
if not exist "%BASE%\schemas\alert.schema.yaml" type nul > "%BASE%\schemas\alert.schema.yaml"
if not exist "%BASE%\schemas\metrics.schema.yaml" type nul > "%BASE%\schemas\metrics.schema.yaml"

REM -------------------------
REM Policies
REM -------------------------
if not exist "%BASE%\policies\ALERT_THRESHOLDS.yaml" type nul > "%BASE%\policies\ALERT_THRESHOLDS.yaml"
if not exist "%BASE%\policies\ESCALATION_MATRIX.yaml" type nul > "%BASE%\policies\ESCALATION_MATRIX.yaml"
if not exist "%BASE%\policies\RETENTION_METRICS.yaml" type nul > "%BASE%\policies\RETENTION_METRICS.yaml"

REM -------------------------
REM Runbooks
REM -------------------------
if not exist "%BASE%\runbooks\RUNBOOK_AGENT_FAILURE.md" type nul > "%BASE%\runbooks\RUNBOOK_AGENT_FAILURE.md"
if not exist "%BASE%\runbooks\RUNBOOK_DRIFT_DETECTED.md" type nul > "%BASE%\runbooks\RUNBOOK_DRIFT_DETECTED.md"
if not exist "%BASE%\runbooks\RUNBOOK_FACTORY_DOWN.md" type nul > "%BASE%\runbooks\RUNBOOK_FACTORY_DOWN.md"

echo.
echo Structure creee avec succes.
pause
endlocal