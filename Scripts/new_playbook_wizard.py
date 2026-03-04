#!/usr/bin/env python3
"""Wizard: scaffold a new playbook entry + runbook MD. Generated: 2025-12-28T20:05:18Z
Usage:
  python scripts/new_playbook_wizard.py --playbook_id MY_PLAYBOOK --description "..." --steps "Step1:AGENT_A,Step2:AGENT_B"
"""
import argparse
from pathlib import Path
import yaml, re
from datetime import datetime

ROOT = Path(__file__).resolve().parents[1]
NOW = datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")

def load(p):
    return yaml.safe_load(p.read_text(encoding="utf-8")) if p.exists() else {}

def dump(p, obj):
    p.write_text(yaml.safe_dump(obj, sort_keys=False, allow_unicode=True), encoding="utf-8")

parser = argparse.ArgumentParser()
parser.add_argument("--playbook_id", required=True)
parser.add_argument("--description", required=True)
parser.add_argument("--steps", required=True, help="Comma-separated Step:ACTOR")
args = parser.parse_args()

if not re.match(r'^[A-Za-z0-9_-]+$', args.playbook_id):
    raise SystemExit("FAIL: playbook_id invalid")

pb_path = ROOT/"40_RUNBOOKS/playbooks.yaml"
pbs = load(pb_path)
pbs.setdefault("playbooks", {})

steps=[]
for chunk in [c.strip() for c in args.steps.split(",") if c.strip()]:
    if ":" not in chunk:
        raise SystemExit("FAIL: step format must be Step:ACTOR")
    step, actor = chunk.split(":",1)
    steps.append({"step": step.strip(), "actor_id": actor.strip()})

pbs["playbooks"][args.playbook_id] = {"description": args.description, "steps": steps}
pbs["generated_at"] = NOW
dump(pb_path, pbs)

rb_dir = ROOT/"40_RUNBOOKS/RUNBOOKS_MD"
rb_dir.mkdir(parents=True, exist_ok=True)
md = f"""# RUNBOOK — {args.playbook_id}
Generated: {NOW}

## Description
{args.description}

## Steps
""" + "\n".join([f"- {s['step']} -> {s['actor_id']}" for s in steps]) + "\n"
(rb_dir/f"RUNBOOK__{args.playbook_id}.md").write_text(md, encoding="utf-8")

print("OK: playbook added:", args.playbook_id)
