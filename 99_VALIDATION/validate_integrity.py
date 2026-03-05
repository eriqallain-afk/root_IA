#!/usr/bin/env python3
"""Validate integrity of root_IA (Machine). Generated: 2025-12-28T18:28:31Z"""
import re, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def fail(msg):
    print("FAIL:", msg)
    sys.exit(1)

critical = [
  "00_CONTROL_PLANE/CONTROL_PLANE.yaml",
  "00_INDEX/gpt_catalog.yaml",
  "00_INDEX/intents.yaml",
  "80_MACHINES/hub_routing.yaml",
  "40_RUNBOOKS/playbooks.yaml",
  "90_MEMORY/memory.yaml",
  "registry.yaml",
]
for path in critical:
    if not (ROOT / path).exists():
        fail("missing critical file: " + path)

# catalog actor ids
cat_txt = (ROOT/"00_INDEX/gpt_catalog.yaml").read_text(encoding="utf-8")
catalog_ids = set(re.findall(r'^\s{2}([A-Za-z0-9_-]+):\s*$', cat_txt, flags=re.M))

# playbooks actor ids used
pb_txt = (ROOT/"40_RUNBOOKS/playbooks.yaml").read_text(encoding="utf-8")
used_ids = set(re.findall(r'actor_id:\s*"([^"]+)"', pb_txt))
missing = sorted([i for i in used_ids if i not in catalog_ids])
if missing:
    fail("unknown actor_id in playbooks: " + ", ".join(missing))

# referenced agent paths exist
agent_paths = re.findall(r'agent:\s*"([^"]+)"', cat_txt)
for ap in agent_paths:
    p = ROOT / ap.replace("REGISTRY/", "")
    if not p.exists():
        fail("missing agent file referenced in catalog: " + ap)
    base = p.parent
    for req in ["agent.yaml","contract.yaml","prompt.md"]:
        if not (base/req).exists():
            fail("missing " + req + " in " + str(base))

# memory sources exist
mem_txt = (ROOT/"90_MEMORY/memory.yaml").read_text(encoding="utf-8")
mem_sources = re.findall(r'source:\s*"([^"]+)"', mem_txt)
for s in mem_sources:
    sp = ROOT / s.replace("REGISTRY/", "")
    if not sp.exists():
        fail("memory source missing: " + s)

print("OK: integrity validation passed")
