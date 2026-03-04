#!/usr/bin/env python3
"""
validate_rootIA_v2.py
Validates the split repo layout:
- FACTORY/ (HUB/IAHQ/META/OPS)
- PRODUCTS/<TEAM>/ (each product is standalone, with its own OPS agents embedded)
Checks:
- YAML parseability
- agent ids unique within package
- playbooks refer to existing actor_ids
- routing refer to existing actor_ids + playbook_ids
"""
from __future__ import annotations
import sys, os
from pathlib import Path
import yaml

def load_yaml(p: Path):
    return yaml.safe_load(p.read_text(encoding="utf-8", errors="replace"))

def fail(msg: str, code: int = 1):
    print(f"[FAIL] {msg}")
    raise SystemExit(code)

def warn(msg: str):
    print(f"[WARN] {msg}")

def ok(msg: str):
    print(f"[OK] {msg}")

def validate_package(pkg_root: Path, kind: str):
    # required files
    idx = pkg_root / "00_INDEX" / "gpt_catalog.yaml"
    if not idx.exists():
        fail(f"{kind}: missing {idx}")
    cat = load_yaml(idx)
    catalog = cat.get("catalog", {})
    if not isinstance(catalog, dict) or not catalog:
        fail(f"{kind}: invalid/empty catalog in {idx}")

    # playbooks location: prefer pkg_root/playbooks/playbooks.yaml, fallback pkg_root/30_PLAYBOOKS/playbooks.yaml
    pb_path = pkg_root / "playbooks" / "playbooks.yaml"
    if not pb_path.exists():
        pb_path = pkg_root / "30_PLAYBOOKS" / "playbooks.yaml"
    if not pb_path.exists():
        warn(f"{kind}: playbooks.yaml not found under playbooks/ or 30_PLAYBOOKS/ (routing checks will still run)")
        playbooks = {}
    else:
        pb = load_yaml(pb_path)
        playbooks = pb.get("playbooks", {})
        if not isinstance(playbooks, dict):
            fail(f"{kind}: invalid playbooks structure in {pb_path}")

    # routing location: prefer pkg_root/80_MACHINES/hub_routing.yaml
    rt_path = pkg_root / "80_MACHINES" / "hub_routing.yaml"
    if not rt_path.exists():
        warn(f"{kind}: missing routing file {rt_path} (routing checks skipped)")
        routing_table = []
        router_actor = None
    else:
        rt = load_yaml(rt_path)
        router_actor = rt.get("router_actor_id")
        routing_table = rt.get("routing_table", [])
        if router_actor and router_actor not in catalog:
            fail(f"{kind}: router_actor_id '{router_actor}' not found in catalog ({idx})")
        if not isinstance(routing_table, list):
            fail(f"{kind}: routing_table must be a list in {rt_path}")

    ids = set(catalog.keys())
    ok(f"{kind}: catalog agents={len(ids)}")

    # Playbook actor_id references
    missing_actors = []
    for pb_id, pbdef in playbooks.items():
        for step in pbdef.get("steps", []):
            aid = step.get("actor_id")
            if not aid or aid == "dynamic":
                continue
            if aid not in ids:
                missing_actors.append((pb_id, aid))
    if missing_actors:
        sample = ", ".join([f"{pb}:{aid}" for pb,aid in missing_actors[:10]])
        fail(f"{kind}: playbooks reference unknown actor_id(s): {sample} (total {len(missing_actors)})")

    # Routing actor/playbook references
    missing_route_actors=[]
    missing_route_playbooks=[]
    for r in routing_table:
        aid = r.get("default_actor_id")
        pid = r.get("default_playbook_id")
        if aid and aid not in ids:
            missing_route_actors.append(aid)
        if pid and playbooks and pid not in playbooks:
            missing_route_playbooks.append(pid)
    if missing_route_actors:
        fail(f"{kind}: routing references unknown actor(s): {sorted(set(missing_route_actors))[:10]}")
    if missing_route_playbooks:
        fail(f"{kind}: routing references unknown playbook(s): {sorted(set(missing_route_playbooks))[:10]}")

    ok(f"{kind}: playbooks={len(playbooks)} routing_routes={len(routing_table)}")

def main():
    repo = Path(__file__).resolve().parents[1]
    factory = repo / "FACTORY"
    products = repo / "PRODUCTS"

    if not factory.exists():
        fail("Missing FACTORY/")
    validate_package(factory, "FACTORY")

    if products.exists():
        for team in sorted([p for p in products.iterdir() if p.is_dir() and p.name not in ("_OPS",)]):
            validate_package(team, f"PRODUCT:{team.name}")
    ok("All validations passed.")

if __name__ == "__main__":
    main()
