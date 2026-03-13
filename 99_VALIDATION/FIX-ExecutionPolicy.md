# Résoudre l'erreur ExecutionPolicy PowerShell

## Erreur
```
Le fichier Run-Validation.ps1 n'est pas signé numériquement.
Vous ne pouvez pas exécuter ce script sur le système actuel.
```

---

## Solution 1 — Lanceur CMD (recommandé, sans toucher aux policies)

Double-cliquer ou exécuter :
```cmd
Launch-Validation.cmd
```
Ou depuis PowerShell :
```powershell
cmd /c "Launch-Validation.cmd"
```

---

## Solution 2 — Bypass ponctuel (1 session, sans risque)

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Run-Validation.ps1
```

---

## Solution 3 — Policy permanente CurrentUser (recommandé si admin refusé)

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
```
Puis tester :
```powershell
.\Run-Validation.ps1
```

---

## Solution 4 — Policy permanente machine (nécessite admin)

```powershell
# En PowerShell Administrator
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned -Force
```

---

## Solution 5 — Débloquer les scripts (Unblock-File)

```powershell
# Depuis le dossier 99_VALIDATION
Get-ChildItem -Path . -Filter "*.ps1" -Recurse | Unblock-File
Get-ChildItem -Path .\_lib -Filter "*.ps1" | Unblock-File
```

---

## Quelle solution choisir ?

| Contexte | Solution |
|----------|----------|
| Rapide, sans admin | **Solution 2** (bypass ponctuel) |
| Usage quotidien, sans admin | **Solution 1** (Launch-Validation.cmd) |
| Poste de dev personnel | **Solution 3** (CurrentUser RemoteSigned) |
| Poste IT administré | **Solution 5** (Unblock-File) |
| Déploiement entreprise | **Solution 4** (admin requis) |

---

## Bugs corrigés dans cette version

| Script | Bug | Correction |
|--------|-----|-----------|
| `Run-Validation.ps1` | Chemin `EA4A` au lieu de `EA4AI` | ✅ Corrigé → `EA4AI` |
| `Run-Validation.ps1` | Manque couleurs console | ✅ Ajout `-ForegroundColor` |
| `Validate-Refs.ps1` | Accolade `}` manquante après `if (-not (Test-Path...))` | ✅ Corrigé |
| `Validate-Refs.ps1` | `agent_id` (schema 1.1.0) non reconnu | ✅ Ajout `agent_id` dans `Extract-IdsFromYamlLite` |
| `Validate-Refs.ps1` | Playbook_id inconnu = erreur bloquante | ✅ Rétrogradé en WARNING |
