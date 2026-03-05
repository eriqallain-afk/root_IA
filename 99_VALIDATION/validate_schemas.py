#!/usr/bin/env python3
"""Validate core YAML files against required keys (schema-lite). Generated: 2025-12-28T19:41:16Z"""
from pathlib import Path
import sys
import yaml

ROOT = Path(__file__).resolve().parents[1]

def fail(msg):
    print("FAIL:", msg)
    sys.exit(1)

core = {
  "ROUTING": ROOT/"80_MACHINES/hub_routing.yaml",
  "PLAYBOOKS": ROOT/"40_RUNBOOKS/playbooks.yaml",
  "MEMORY_INDEX": ROOT/"90_MEMORY/memory.yaml",
}
for k,p in core.items():
    if not p.exists():
        fail(f"missing {k}: {p}")

routing = yaml.safe_load(core["ROUTING"].read_text(encoding="utf-8"))
for req in ["schema_version","router_actor_id","routing_table","fallback"]:
    if req not in routing:
        fail("hub_routing.yaml missing key: " + req)

pbs = yaml.safe_load(core["PLAYBOOKS"].read_text(encoding="utf-8"))
if "playbooks" not in pbs or not isinstance(pbs["playbooks"], dict):
    fail("playbooks.yaml invalid: missing playbooks map")

mem = yaml.safe_load(core["MEMORY_INDEX"].read_text(encoding="utf-8"))
if "memory_objects" not in mem:
    fail("memory.yaml invalid: missing memory_objects")

agents_root = ROOT/"20_AGENTS"
if not agents_root.exists():
    fail("missing 20_AGENTS folder")
for agent_yaml in agents_root.rglob("agent.yaml"):
    base = agent_yaml.parent
    for req in ["contract.yaml","prompt.md"]:
        if not (base/req).exists():
            fail(f"missing {req} in {base}")

print("OK: schema-lite validation passed")
