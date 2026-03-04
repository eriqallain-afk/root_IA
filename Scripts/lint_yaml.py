#!/usr/bin/env python3
"""Simple YAML linter: parse all .yaml/.yml files. Generated: 2025-12-28T19:41:16Z"""
from pathlib import Path
import sys
import yaml

ROOT = Path(__file__).resolve().parents[1]
bad = 0
for p in ROOT.rglob("*"):
    if p.is_file() and p.suffix.lower() in [".yaml",".yml"]:
        try:
            yaml.safe_load(p.read_text(encoding="utf-8"))
        except Exception as e:
            bad += 1
            print("FAIL:", p, "->", e)
if bad:
    sys.exit(1)
print("OK: YAML lint passed")
