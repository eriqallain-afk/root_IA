#!/usr/bin/env python3
"""Fail if repo contains fabricated citation tokens like turn0news1. Generated: 2025-12-28T22:00:54Z"""
from pathlib import Path
import re, sys

ROOT = Path(__file__).resolve().parents[1]
PAT = re.compile(r'\bturn\d+(?:news|search|view|finance|forecast|image|product)\d+\b')

ignore = {".git",".github","__pycache__","node_modules"}
bad=[]
for p in ROOT.rglob("*"):
    if any(part in ignore for part in p.parts):
        continue
    if p.is_file() and p.suffix.lower() in [".md",".yaml",".yml",".txt",".json"]:
        txt = p.read_text(encoding="utf-8", errors="ignore")
        if PAT.search(txt):
            bad.append(str(p.relative_to(ROOT)))

if bad:
    print("FAIL: fabricated citation-like tokens found:")
    for b in bad: print(" -", b)
    sys.exit(1)
print("OK: no fabricated citation tokens in repo")
