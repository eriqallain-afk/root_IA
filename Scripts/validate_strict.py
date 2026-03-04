#!/usr/bin/env python3
"""Run strict validation suite for root_IA.

Generated: 2026-01-04T18:13:35Z

This script is a convenience wrapper called by QUICKSTART.md.
It runs the main validators shipped in /scripts and exits non-zero on first failure.
"""

from __future__ import annotations
from pathlib import Path
import subprocess
import sys
import shutil

ROOT = Path(__file__).resolve().parents[1]

STEPS = [
    ("validate_root_IA.sh", ["bash", "validate_root_IA.sh"]),
    ("validate_integrity.py", [sys.executable, "scripts/validate_integrity.py"]),
    ("validate_schemas.py", [sys.executable, "scripts/validate_schemas.py"]),
    ("run_golden_tests.py", [sys.executable, "scripts/run_golden_tests.py"]),
    ("validate_machine_output.py", [sys.executable, "scripts/validate_machine_output.py"]),
    ("validate_no_fake_citations.py", [sys.executable, "scripts/validate_no_fake_citations.py"]),
]

def run_step(name: str, cmd: list[str]) -> None:
    print(f"\n=== TRAD ===")
    subprocess.run(cmd, cwd=ROOT, check=True)

def main() -> int:
    for name, cmd in STEPS:
        if cmd[0] == "bash" and shutil.which("bash") is None:
            print("SKIP: bash not found; skipping validate_root_IA.sh (run it manually if needed).")
            continue
        try:
            run_step(name, cmd)
        except subprocess.CalledProcessError as e:
            print(f"\nFAIL: TRAD exited with code {e.returncode}")
            return e.returncode or 1
    print("\nOK: strict validation suite passed")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
