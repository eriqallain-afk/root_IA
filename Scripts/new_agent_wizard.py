#!/usr/bin/env python3
"""Wizard: scaffold a new agent folder + update indexes. Generated: 2025-12-28T20:05:18Z
Usage:
  python scripts/new_agent_wizard.py --actor_id AGENT_X --team_id TEAM__OPS --display_name "Agent X" --intents "intent.a,intent.b"
"""
import argparse
from pathlib import Path
import yaml, re
from datetime import datetime

ROOT = Path(__file__).resolve().parents[1]
NOW = datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")

def fail(msg):
    raise SystemExit("FAIL: " + msg)

def load(p):
    return yaml.safe_load(p.read_text(encoding="utf-8")) if p.exists() else {}

def dump(p, obj):
    p.write_text(yaml.safe_dump(obj, sort_keys=False, allow_unicode=True), encoding="utf-8")

parser = argparse.ArgumentParser()
parser.add_argument("--actor_id", required=True)
parser.add_argument("--team_id", required=True)
parser.add_argument("--display_name", required=True)
parser.add_argument("--intents", default="")
parser.add_argument("--status", default="active", choices=["active","inactive","deprecated"])
args = parser.parse_args()

if not re.match(r'^[A-Za-z0-9_-]+$', args.actor_id):
    fail("actor_id invalid (use A-Za-z0-9_-)")

agent_dir = ROOT/"20_AGENTS"/args.team_id/args.actor_id
agent_dir.mkdir(parents=True, exist_ok=False)

agent_yaml = {
  "schema_version":"1.0",
  "id": args.actor_id,
  "display_name": args.display_name,
  "team_id": args.team_id,
  "team_name": args.team_id.replace("TEAM__",""),
  "version":"0.1.0",
  "status": args.status,
  "description":"TODO: describe mission",
  "intents":[i.strip() for i in args.intents.split(",") if i.strip()],
  "machine":{"output_format":"yaml_machine_v1","contract_required":True,"logs_required":True},
  "interfaces":{"contract": str(agent_dir/"contract.yaml").replace(str(ROOT)+"/",""),
                "prompt": str(agent_dir/"prompt.md").replace(str(ROOT)+"/","")}
}
contract_yaml = {
  "schema_version":"1.0",
  "input":{"objective":"string","context":"object","constraints":"array","expected_output":"string"},
  "output":{"result":"object","artifacts":"array","next_actions":"array","log":"object"}
}
prompt_md = f"""# PROMPT — {args.actor_id}
## Mission
TODO

## Machine Rules
- Output YAML strict: result/artifacts/next_actions/log
- No prose outside YAML
"""

dump(agent_dir/"agent.yaml", agent_yaml)
dump(agent_dir/"contract.yaml", contract_yaml)
(agent_dir/"prompt.md").write_text(prompt_md, encoding="utf-8")

cat_p = ROOT/"00_INDEX/gpt_catalog.yaml"
agents_p = ROOT/"00_INDEX/agents_index.yaml"
intents_p = ROOT/"00_INDEX/intents.yaml"

catalog = load(cat_p)
agents = load(agents_p)
intents = load(intents_p)

catalog.setdefault("catalog", {})[args.actor_id] = {
  "display_name": args.display_name,
  "team_id": args.team_id,
  "status": args.status,
  "intents": agent_yaml["intents"],
  "paths": {
    "agent": str(agent_dir/"agent.yaml").replace(str(ROOT)+"/",""),
    "contract": str(agent_dir/"contract.yaml").replace(str(ROOT)+"/",""),
    "prompt": str(agent_dir/"prompt.md").replace(str(ROOT)+"/",""),
  }
}

agents.setdefault("agents", {})[args.actor_id] = {
  "team_id": args.team_id,
  "description": agent_yaml["description"]
}

inv = intents.setdefault("intents", {})
for it in agent_yaml["intents"]:
    inv.setdefault(it, []).append(args.actor_id)
for k,v in inv.items():
    inv[k] = sorted(list(dict.fromkeys(v)))

catalog["generated_at"] = NOW
agents["generated_at"] = NOW
intents["generated_at"] = NOW

dump(cat_p, catalog)
dump(agents_p, agents)
dump(intents_p, intents)

print("OK: agent created at", agent_dir)
