#!/usr/bin/env python3
"""Create/verify a registry lockfile (hashes). Generated: 2025-12-28T20:05:18Z
Usage:
  python scripts/registry_lock.py create
  python scripts/registry_lock.py verify
  python scripts/registry_lock.py diff
"""
from pathlib import Path
import sys, hashlib, json
from datetime import datetime

ROOT = Path(__file__).resolve().parents[1]
LOCK = ROOT/"REGISTRY_LOCK.json"
NOW = datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")

TARGETS = [
  "00_CONTROL_PLANE/CONTROL_PLANE.yaml",
  "00_INDEX/gpt_catalog.yaml",
  "00_INDEX/agents_index.yaml",
  "00_INDEX/teams_index.yaml",
  "00_INDEX/intents.yaml",
  "00_INDEX/capability_map.yaml",
  "00_INDEX/machines_index.yaml",
  "80_MACHINES/hub_routing.yaml",
  "40_RUNBOOKS/playbooks.yaml",
  "90_MEMORY/memory.yaml",
  "registry.yaml",
]

def sha256(p: Path) -> str:
    h = hashlib.sha256()
    h.update(p.read_bytes())
    return h.hexdigest()

def create():
    missing=[t for t in TARGETS if not (ROOT/t).exists()]
    if missing:
        print("FAIL missing:", missing); sys.exit(1)
    data={"generated_at":NOW,"hashes":{}}
    for t in TARGETS:
        data["hashes"][t]=sha256(ROOT/t)
    LOCK.write_text(json.dumps(data, indent=2), encoding="utf-8")
    print("OK: created", LOCK)

def verify():
    if not LOCK.exists():
        print("FAIL: lock missing. Run: create"); sys.exit(1)
    data=json.loads(LOCK.read_text(encoding="utf-8"))
    bad=0
    for t,h in data.get("hashes",{}).items():
        p=ROOT/t
        if not p.exists():
            print("FAIL missing:", t); bad+=1; continue
        if sha256(p)!=h:
            print("CHANGED:", t); bad+=1
    if bad: sys.exit(1)
    print("OK: lock verified")

def diff():
    if not LOCK.exists():
        print("FAIL: lock missing"); sys.exit(1)
    data=json.loads(LOCK.read_text(encoding="utf-8"))
    changes=[]
    for t,h in data.get("hashes",{}).items():
        p=ROOT/t
        if not p.exists():
            changes.append({"path":t,"type":"missing"}); continue
        nh=sha256(p)
        if nh!=h:
            changes.append({"path":t,"type":"modified","old":h,"new":nh})
    report={"generated_at":NOW,"changes":changes}
    out=ROOT/"REGISTRY_DIFF_REPORT.json"
    out.write_text(json.dumps(report, indent=2), encoding="utf-8")
    print("OK: wrote", out)

if len(sys.argv)<2:
    print("Usage: create|verify|diff"); sys.exit(2)
cmd=sys.argv[1].lower()
if cmd=="create": create()
elif cmd=="verify": verify()
elif cmd=="diff": diff()
else:
    print("Unknown command"); sys.exit(2)
