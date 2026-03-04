#!/usr/bin/env python3
"""Regenerate MEM-* files from sources (Machine). Generated: 2025-12-28T18:28:31Z"""
from pathlib import Path
import yaml
from datetime import datetime

ROOT = Path(__file__).resolve().parents[1]
NOW = datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")

def wyaml(p, d):
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(yaml.safe_dump(d, sort_keys=False, allow_unicode=True), encoding="utf-8")

playbooks = yaml.safe_load((ROOT/"40_RUNBOOKS/playbooks.yaml").read_text(encoding="utf-8")).get("playbooks", {})
routing = yaml.safe_load((ROOT/"80_MACHINES/hub_routing.yaml").read_text(encoding="utf-8"))
catalog = yaml.safe_load((ROOT/"00_INDEX/gpt_catalog.yaml").read_text(encoding="utf-8")).get("catalog", {})
agents_index = yaml.safe_load((ROOT/"00_INDEX/agents_index.yaml").read_text(encoding="utf-8")).get("agents", {})
teams_index = yaml.safe_load((ROOT/"00_INDEX/teams_index.yaml").read_text(encoding="utf-8")).get("teams", {})
intents_index = yaml.safe_load((ROOT/"00_INDEX/intents.yaml").read_text(encoding="utf-8")).get("intents", {})
cap_path = ROOT/"00_INDEX/capability_map.yaml"
capabilities = yaml.safe_load(cap_path.read_text(encoding="utf-8")).get("capabilities", {}) if cap_path.exists() else {}

MEM = ROOT/"90_MEMORY"

# MEM-PlaybooksGlobal
mem_play = {
  "schema_version":"1.0","generated_at":NOW,"memory_id":"MEM-PlaybooksGlobal","type":"registry_memory",
  "purpose":"Index global des playbooks (description, steps, actors).",
  "source":{"playbooks_file":"40_RUNBOOKS/playbooks.yaml","format":"yaml"},
  "write_policy":"regenerated","index_fields":["playbook_id","step","actor_id","tags"],"playbooks":{}
}
for pid, e in playbooks.items():
    steps = e.get("steps", [])
    mem_play["playbooks"][pid] = {
        "description": e.get("description",""),
        "steps":[{"step":s.get("step"),"actor_id":s.get("actor_id")} for s in steps],
        "actors": sorted(list({s.get("actor_id") for s in steps if s.get("actor_id")})),
        "step_count": len(steps),
        "tags":[]
    }
wyaml(MEM/"MEM-PlaybooksGlobal.yaml", mem_play)

# MEM-AgentsGlobal
mem_agents = {
  "schema_version":"1.0","generated_at":NOW,"memory_id":"MEM-AgentsGlobal","type":"registry_memory",
  "purpose":"Index global des agents (metadata + intents + paths).",
  "source":{"agents_index":"00_INDEX/agents_index.yaml","gpt_catalog":"00_INDEX/gpt_catalog.yaml"},
  "write_policy":"regenerated","index_fields":["actor_id","team_id","intent","status"],"agents":{}
}
for aid, entry in catalog.items():
    meta = agents_index.get(aid, {})
    mem_agents["agents"][aid] = {
      "display_name": entry.get("display_name",""),
      "team_id": entry.get("team_id",""),
      "status": entry.get("status",""),
      "intents": entry.get("intents", []),
      "paths": entry.get("paths", {}),
      "description": meta.get("description","")
    }
wyaml(MEM/"MEM-AgentsGlobal.yaml", mem_agents)

# MEM-TeamsGlobal
wyaml(MEM/"MEM-TeamsGlobal.yaml", {
  "schema_version":"1.0","generated_at":NOW,"memory_id":"MEM-TeamsGlobal","type":"registry_memory",
  "purpose":"Index global des équipes (missions + orchestrateurs).",
  "source":{"teams_index":"00_INDEX/teams_index.yaml","team_files":"10_TEAMS/"},
  "write_policy":"regenerated","index_fields":["team_id","name"],"teams": teams_index
})

# MEM-IntentsGlobal
wyaml(MEM/"MEM-IntentsGlobal.yaml", {
  "schema_version":"1.0","generated_at":NOW,"memory_id":"MEM-IntentsGlobal","type":"registry_memory",
  "purpose":"Index inversé intent -> agents.",
  "source":{"intents_file":"00_INDEX/intents.yaml"},
  "write_policy":"regenerated","index_fields":["intent","actor_id"],"intents": intents_index
})

# MEM-RoutingGlobal
wyaml(MEM/"MEM-RoutingGlobal.yaml", {
  "schema_version":"1.0","generated_at":NOW,"memory_id":"MEM-RoutingGlobal","type":"registry_memory",
  "purpose":"Table de routage globale (match intents -> actor/playbook + fallback).",
  "source":{"routing_file":"80_MACHINES/hub_routing.yaml"},
  "write_policy":"regenerated","index_fields":["intent","default_actor_id","default_playbook_id"],
  "routing": routing
})

# MEM-CapabilitiesGlobal
wyaml(MEM/"MEM-CapabilitiesGlobal.yaml", {
  "schema_version":"1.0","generated_at":NOW,"memory_id":"MEM-CapabilitiesGlobal","type":"registry_memory",
  "purpose":"Catalogue des capacités (capability -> default actor/team).",
  "source":{"capability_map":"00_INDEX/capability_map.yaml"},
  "write_policy":"regenerated","index_fields":["capability_id","team_id","default_actor_id"],
  "capabilities": capabilities
})

# MEM-RunbooksGlobal
rb_files = [str(p.relative_to(ROOT)) for p in (ROOT/"40_RUNBOOKS").rglob("*.md")]
wyaml(MEM/"MEM-RunbooksGlobal.yaml", {
  "schema_version":"1.0","generated_at":NOW,"memory_id":"MEM-RunbooksGlobal","type":"registry_memory",
  "purpose":"Index global des runbooks (MD).",
  "source":{"runbooks_dir":"40_RUNBOOKS/"},
  "write_policy":"regenerated","index_fields":["path","category"],
  "runbooks":[{"path":p, "category": ("INCIDENTS" if "INCIDENTS" in p else "RUNBOOK")} for p in sorted(rb_files)]
})

# MEM-IntegrationPackagesGlobal
pkg_dir = ROOT/"70_INTEGRATION_PACKAGES"
packages=[]
if pkg_dir.exists():
    for d in sorted([p for p in pkg_dir.iterdir() if p.is_dir()]):
        packages.append({"package_id": d.name, "files":[str(f.relative_to(ROOT)) for f in d.rglob("*") if f.is_file()]})
wyaml(MEM/"MEM-IntegrationPackagesGlobal.yaml", {
  "schema_version":"1.0","generated_at":NOW,"memory_id":"MEM-IntegrationPackagesGlobal","type":"registry_memory",
  "purpose":"Index global des packages d’intégration.",
  "source":{"packages_dir":"70_INTEGRATION_PACKAGES/"},
  "write_policy":"regenerated","index_fields":["package_id","file"],
  "packages": packages
})

# MEM-QualityGatesGlobal
qg_path = ROOT/"90_KNOWLEDGE/META_FACTORY/rubrics/quality_gates.yaml"
gates={}
if qg_path.exists():
    qg = yaml.safe_load(qg_path.read_text(encoding="utf-8"))
    if isinstance(qg, dict):
        gates = qg.get("gates", {}) or {}
wyaml(MEM/"MEM-QualityGatesGlobal.yaml", {
  "schema_version":"1.0","generated_at":NOW,"memory_id":"MEM-QualityGatesGlobal","type":"registry_memory",
  "purpose":"Quality gates pour QA Machine.",
  "source":{"quality_gates_file":"90_KNOWLEDGE/META_FACTORY/rubrics/quality_gates.yaml"},
  "write_policy":"regenerated","index_fields":["gate_id","rule"],
  "quality_gates": gates
})

print("OK: MEM-* regenerated at", NOW)
