#!/usr/bin/env python3
"""Validate that golden outputs conform to Machine format (YAML strict). Generated: 2025-12-28T20:05:18Z"""
from pathlib import Path
import sys, yaml

ROOT = Path(__file__).resolve().parents[1]
GOLD = ROOT/"tests/golden_outputs"

REQ_TOP = ["result","artifacts","next_actions","log"]
REQ_LOG = ["decisions","risks","assumptions"]

bad = 0
for p in sorted(GOLD.glob("*.yaml")):
    try:
        obj = yaml.safe_load(p.read_text(encoding="utf-8"))
    except Exception as e:
        print("FAIL parse:", p.name, e); bad += 1; continue
    for k in REQ_TOP:
        if k not in obj:
            print("FAIL:", p.name, "missing", k); bad += 1
    if "log" in obj:
        for k in REQ_LOG:
            if k not in obj["log"]:
                print("FAIL:", p.name, "log missing", k); bad += 1

if bad:
    sys.exit(1)
print("OK: machine golden outputs validated")
