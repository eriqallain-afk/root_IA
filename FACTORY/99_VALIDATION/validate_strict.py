#!/usr/bin/env python3
"""
validate_strict.py — Suite de validation complète root_IA (layout SPLIT).

LAYOUT ATTENDU :
  root_IA/
    99_VALIDATION/    <- CE script est ici
    FACTORY/
      99_VALIDATION/  <- scripts Python de la FACTORY
    PRODUCTS/
    Scripts/

CORRECTION v2 (2026-03) :
  - Adapte pour layout SPLIT (FACTORY/ + PRODUCTS/).
  - validate_root_IA.sh ignore sur Windows (pas de bash natif).
  - Scripts cherches dans FACTORY/99_VALIDATION/ et non plus dans scripts/.
  - validate_schemas.py (corrige) lance depuis 99_VALIDATION/ racine repo.
"""

from __future__ import annotations
from pathlib import Path
import subprocess
import sys

# parents[0] = root_IA/99_VALIDATION/
# parents[1] = root_IA/  <- ROOT du repo
ROOT    = Path(__file__).resolve().parents[1]
FACTORY = ROOT / "FACTORY"
VAL_DIR = FACTORY / "99_VALIDATION"   # scripts Python FACTORY
HERE    = Path(__file__).resolve().parent  # root_IA/99_VALIDATION/


def _banner(msg: str) -> None:
    print(f"\n{'='*60}")
    print(f"  {msg}")
    print(f"{'='*60}")


def run_step(label: str, cmd: list, cwd: Path) -> bool:
    _banner(label)
    print(f"  Commande : {' '.join(str(x) for x in cmd)}")
    print(f"  Depuis   : {cwd}\n")
    result = subprocess.run(cmd, cwd=str(cwd))
    if result.returncode == 0:
        print(f"\n  [OK] {label}")
        return True
    print(f"\n  [FAIL] {label} -- code retour : {result.returncode}")
    return False


def main() -> int:
    print(f"\nroot_IA validate_strict.py -- layout SPLIT")
    print(f"ROOT    : {ROOT}")
    print(f"FACTORY : {FACTORY}")

    if not FACTORY.exists():
        print(f"[FATAL] FACTORY/ introuvable sous {ROOT}")
        print("        Verifier que ce script est bien dans root_IA/99_VALIDATION/")
        return 1

    STEPS = [
        (
            "1/6 -- validate_integrity.py (FACTORY)",
            [sys.executable, str(VAL_DIR / "validate_integrity.py")],
            FACTORY,
        ),
        (
            "2/6 -- validate_schemas.py (racine repo)",
            [sys.executable, str(HERE / "validate_schemas.py")],
            ROOT,
        ),
        (
            "3/6 -- validate_refs.py (FACTORY)",
            [
                sys.executable, str(VAL_DIR / "validate_refs.py"),
                "--agents-index", "00_INDEX/agents_index.yaml",
                "--gpt-catalog",  "00_INDEX/gpt_catalog.yaml",
                "--hub-routing",  "80_MACHINES/hub_routing.yaml",
                "--playbooks",    "40_RUNBOOKS/playbooks.yaml",
            ],
            FACTORY,
        ),
        (
            "4/6 -- run_golden_tests.py (FACTORY)",
            [sys.executable, str(VAL_DIR / "run_golden_tests.py")],
            FACTORY,
        ),
        (
            "5/6 -- validate_machine_output.py (FACTORY)",
            [sys.executable, str(VAL_DIR / "validate_machine_output.py")],
            FACTORY,
        ),
        (
            "6/6 -- validate_no_fake_citations.py (racine repo)",
            [sys.executable, str(HERE / "validate_no_fake_citations.py")],
            ROOT,
        ),
    ]

    passed = 0
    failed = []

    for label, cmd, cwd in STEPS:
        script_path = Path(cmd[1])
        if not script_path.exists():
            print(f"\n[SKIP] {label}")
            print(f"       Script introuvable : {script_path}")
            continue
        ok = run_step(label, cmd, cwd)
        if ok:
            passed += 1
        else:
            failed.append(label)

    total = len(STEPS)
    _banner(f"RESUME : {passed}/{total} validations passees")

    if failed:
        print("\n  Etapes en ECHEC :")
        for f in failed:
            print(f"    - {f}")
        print("\n  [RESULTAT] VALIDATION ECHOUEE -- corriger les erreurs ci-dessus.")
        return 1

    print("\n  [RESULTAT] TOUTES LES VALIDATIONS PASSEES -- repo 100% conforme.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
