#!/usr/bin/env python3
"""Bump version and append changelog. Generated: 2025-12-28T20:05:18Z
Usage:
  python scripts/version_bump.py patch|minor|major --note "message"
"""
from pathlib import Path
import sys, re
from datetime import datetime

ROOT = Path(__file__).resolve().parents[1]
VERSION = ROOT/"VERSION"
CHANGELOG = ROOT/"60_CHANGELOG/CHANGELOG.md"
NOW = datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")

def parse(v):
    m=re.match(r'^v?(\d+)\.(\d+)\.(\d+)', v.strip())
    if not m: return (0,0,0)
    return tuple(map(int,m.groups()))

def fmt(t): return f"v{t[0]}.{t[1]}.{t[2]}"

level = sys.argv[1].lower() if len(sys.argv)>1 else None
note = ""
if "--note" in sys.argv:
    i=sys.argv.index("--note")
    if i+1 < len(sys.argv): note=sys.argv[i+1]

cur = VERSION.read_text(encoding="utf-8").strip() if VERSION.exists() else "v0.0.0"
maj,minr,pat = parse(cur)

if level=="patch": pat += 1
elif level=="minor": minr += 1; pat = 0
elif level=="major": maj += 1; minr = 0; pat = 0
else:
    print("Usage: patch|minor|major --note "...""); sys.exit(2)

nv = fmt((maj,minr,pat))
VERSION.write_text(nv, encoding="utf-8")

CHANGELOG.parent.mkdir(parents=True, exist_ok=True)
old = CHANGELOG.read_text(encoding="utf-8") if CHANGELOG.exists() else "# CHANGELOG\n\n"
entry = f"\n## {NOW} — {nv}\n- {note or 'Version bump'}\n"
CHANGELOG.write_text(old.rstrip()+entry+"\n", encoding="utf-8")

print("OK:", cur, "->", nv)
