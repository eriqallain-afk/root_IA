#!/usr/bin/env python3
"""Golden tests: ensure expected playbooks exist. Generated: 2025-12-28T19:41:16Z"""
from pathlib import Path
import sys
import yaml

ROOT = Path(__file__).resolve().parents[1]
pbs = yaml.safe_load((ROOT/"40_RUNBOOKS/playbooks.yaml").read_text(encoding="utf-8")).get("playbooks", {})
cases = sorted((ROOT/"tests/golden").glob("*.yaml"))

def fail(msg):
    print("FAIL:", msg); sys.exit(1)

for c in cases:
    data = yaml.safe_load(c.read_text(encoding="utf-8"))
    target = (data.get("expected") or {}).get("target_playbook")
    if not target:
        fail(f"{c.name} missing expected.target_playbook")
    if target not in pbs:
        fail(f"{c.name} expects missing playbook: {target}")
print("OK: golden tests passed")
