#!/usr/bin/env python3
"""
scripts/rebuild_indexes.py
Rebuilds:
- FACTORY/00_INDEX from FACTORY/20_AGENTS
- PRODUCTS/<TEAM>/00_INDEX from PRODUCTS/<TEAM>/agents (+ embedded OPS if present)
- root_ia_index.yaml counts (split only)
This script is intentionally conservative: it doesn't delete legacy folders.
"""
from __future__ import annotations
from pathlib import Path
import datetime
import yaml

def load_yaml(p: Path):
    return yaml.safe_load(p.read_text(encoding="utf-8", errors="replace"))

def dump_yaml(data, p: Path):
    p.parent.mkdir(parents=True, exist_ok=True)
    with p.open("w", encoding="utf-8") as f:
        yaml.safe_dump(data, f, sort_keys=False, allow_unicode=True, width=120)

def agent_meta(agent_yaml: Path):
    d = load_yaml(agent_yaml)
    return d["id"], d

def build_indexes(agent_yaml_paths, pkg_root: Path):
    agents_yaml=[]
    agents_index={"schema_version":"1.0","generated_at":datetime.datetime.now().isoformat(),"agents":{}}
    catalog={"schema_version":"1.0","generated_at":datetime.datetime.now().isoformat(),"catalog":{}}
    for ay in sorted(agent_yaml_paths, key=lambda x: str(x)):
        aid, d = agent_meta(ay)
        team_id = d.get("team_id")
        team_name = d.get("team_name")
        display = d.get("display_name", aid)
        desc = d.get("description","")
        intents = d.get("intents",[])
        status = d.get("status","active")
        folder_rel = ay.parent.relative_to(pkg_root).as_posix()
        agents_yaml.append({"actor_id":aid,"team_id":team_id,"name":display,"status":status,"path":folder_rel})
        agents_index["agents"][aid]={"display_name":display,"team_id":team_id,"team_name":team_name,"description":desc,"intents":intents}
        contract = ay.parent/"contract.yaml"
        prompt = ay.parent/"prompt.md"
        catalog["catalog"][aid]={"display_name":display,"team_id":team_id,"status":status,"intents":intents,
                                 "paths":{"agent":(ay.relative_to(pkg_root)).as_posix(),
                                          "contract":(contract.relative_to(pkg_root)).as_posix() if contract.exists() else "",
                                          "prompt":(prompt.relative_to(pkg_root)).as_posix() if prompt.exists() else ""}}
    return {"agents":{"agents":agents_yaml}, "agents_index":agents_index, "gpt_catalog":catalog}

def main():
    repo = Path(__file__).resolve().parents[1]

    # FACTORY
    factory = repo/"FACTORY"
    f_agent_files = list((factory/"20_AGENTS").rglob("agent.yaml"))
    f_idx = build_indexes(f_agent_files, factory)
    dump_yaml(f_idx["agents"], factory/"00_INDEX/agents.yaml")
    dump_yaml(f_idx["agents_index"], factory/"00_INDEX/agents_index.yaml")
    dump_yaml(f_idx["gpt_catalog"], factory/"00_INDEX/gpt_catalog.yaml")

    # PRODUCTS
    products = repo/"PRODUCTS"
    if products.exists():
        for team in sorted([p for p in products.iterdir() if p.is_dir() and p.name not in ("_OPS",)]):
            agent_files = list((team/"agents").rglob("agent.yaml")) if (team/"agents").exists() else []
            if not agent_files:
                continue
            idx = build_indexes(agent_files, team)
            dump_yaml(idx["agents"], team/"00_INDEX/agents.yaml")
            dump_yaml(idx["agents_index"], team/"00_INDEX/agents_index.yaml")
            dump_yaml(idx["gpt_catalog"], team/"00_INDEX/gpt_catalog.yaml")

    # root_ia_index counts (split scope)
    def count_agents(path: Path, glob: str):
        return len(list(path.rglob(glob)))
    factory_count = count_agents(factory/"20_AGENTS", "agent.yaml")
    products_count = sum(count_agents(t/"agents","agent.yaml") for t in products.iterdir() if t.is_dir() and t.name not in ("_OPS",))
    total = factory_count + products_count

    root_idx_path = repo/"root_ia_index.yaml"
    if root_idx_path.exists():
        idx = load_yaml(root_idx_path)
    else:
        idx = {"version":"1.0","date":datetime.date.today().isoformat(),
               "factory":{"location":"FACTORY/","teams":["HUB","META","IAHQ","OPS"]},
               "products":{"location":"PRODUCTS/","teams":[]},
               "statistics":{}}
    idx["date"]=datetime.date.today().isoformat()
    idx.setdefault("factory",{})["total_agents"]=factory_count
    idx.setdefault("products",{})["total_agents"]=products_count
    idx.setdefault("statistics",{})["total_agents"]=total
    idx["statistics"]["factory_pct"]=round(100*factory_count/total,1) if total else 0
    idx["statistics"]["products_pct"]=round(100*products_count/total,1) if total else 0
    dump_yaml(idx, root_idx_path)

    print("OK: indexes rebuilt.")

if __name__ == "__main__":
    main()
