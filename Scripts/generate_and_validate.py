#!/usr/bin/env python3
from __future__ import annotations

import json
import os
from pathlib import Path
from datetime import datetime, timezone
from typing import Any, Dict, List, Tuple

import yaml
from jsonschema import Draft202012Validator

IA_ROOT = Path(os.environ.get("IA_ROOT_PATH", "IA_ROOT")).resolve()

def load_yaml(p: Path) -> Any:
    return yaml.safe_load(p.read_text(encoding="utf-8"))

def dump_yaml(p: Path, data: Any) -> None:
    p.write_text(yaml.safe_dump(data, sort_keys=False, allow_unicode=True), encoding="utf-8")

def utc_now_iso() -> str:
    return datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")

def find_agent_files() -> List[Path]:
    return sorted(IA_ROOT.glob("20_AGENTS/**/agent.yaml"))

def validate_jsonschema(instance: Any, schema: Dict[str, Any], file_path: Path) -> List[str]:
    v = Draft202012Validator(schema)
    errors = sorted(v.iter_errors(instance), key=lambda e: e.path)
    msgs = []
    for e in errors:
        loc = ".".join([str(x) for x in e.path]) or "<root>"
        msgs.append(f"{file_path}: {loc}: {e.message}")
    return msgs

def load_schema(name: str) -> Dict[str, Any]:
    p = IA_ROOT / "SCHEMAS" / name
    return json.loads(p.read_text(encoding="utf-8"))

def load_intents() -> set[str]:
    p = IA_ROOT / "00_INDEX" / "intents.yaml"
    data = load_yaml(p) or {}
    intents = data.get("intents", []) or []
    return set(intents)

def load_playbooks() -> set[str]:
    p = IA_ROOT / "40_RUNBOOKS" / "playbooks.yaml"
    data = load_yaml(p) or {}
    playbooks = data.get("playbooks", {}) or {}
    return set(playbooks.keys())

def load_agents() -> Tuple[List[Dict[str, Any]], Dict[str, Path]]:
    agents: List[Dict[str, Any]] = []
    by_id: Dict[str, Path] = {}
    for f in find_agent_files():
        a = load_yaml(f) or {}
        agents.append(a)
        if "id" in a:
            by_id[a["id"]] = f
    return agents, by_id

def validate_intents_used(agents: List[Dict[str, Any]], known_intents: set[str]) -> List[str]:
    errs = []
    for a in agents:
        agent_id = a.get("id", "<unknown>")
        for intent in a.get("intents", []) or []:
            if intent not in known_intents:
                errs.append(f"Agent {agent_id}: intent inconnu '{intent}' (absent de 00_INDEX/intents.yaml)")
    return errs

def validate_routing(agent_ids: set[str], playbook_ids: set[str]) -> List[str]:
    p = IA_ROOT / "80_MACHINES" / "hub_routing.yaml"
    data = load_yaml(p) or {}
    routes = data.get("routes", []) or []
    errs = []
    for i, r in enumerate(routes):
        intent = r.get("intent", f"<route[{i}].intent manquant>")
        target = r.get("target", {})
        ttype = target.get("type")
        if ttype == "actor":
            actor_id = target.get("actor_id")
            if actor_id not in agent_ids:
                errs.append(f"Routing: intent '{intent}' → actor_id '{actor_id}' inexistant")
        elif ttype == "playbook":
            pb = target.get("playbook_id")
            if pb not in playbook_ids:
                errs.append(f"Routing: intent '{intent}' → playbook_id '{pb}' inexistant")
        else:
            errs.append(f"Routing: intent '{intent}' → target.type invalide (attendu 'actor'|'playbook')")
    return errs

def validate_playbooks(agent_ids: set[str]) -> List[str]:
    p = IA_ROOT / "40_RUNBOOKS" / "playbooks.yaml"
    data = load_yaml(p) or {}
    playbooks = data.get("playbooks", {}) or {}
    errs = []
    for pb_id, pb in playbooks.items():
        for step in pb.get("steps", []) or []:
            actor = step.get("actor_id")
            if actor and actor not in agent_ids:
                errs.append(f"Playbook {pb_id}: actor_id '{actor}' inexistant")
    return errs

def generate_agents_index(agents: List[Dict[str, Any]], agent_file_map: Dict[str, Path]) -> Dict[str, Any]:
    out = {
        "schema_version": "1.0",
        "generated_at": utc_now_iso(),
        "agents": []
    }
    for a in sorted(agents, key=lambda x: x.get("id", "")):
        aid = a.get("id")
        if not aid:
            continue
        path = agent_file_map[aid].relative_to(IA_ROOT).as_posix()
        out["agents"].append({
            "id": aid,
            "team_id": a.get("team_id"),
            "status": a.get("status"),
            "version": a.get("version"),
            "path": path,
            "intents": a.get("intents", []) or []
        })
    return out

def main() -> None:
    schema_agent = load_schema("agent.schema.json")
    known_intents = load_intents()
    playbook_ids = load_playbooks()

    agents, agent_files = load_agents()

    errors: List[str] = []
    # 1) schema validation
    for f in find_agent_files():
        a = load_yaml(f) or {}
        errors += validate_jsonschema(a, schema_agent, f)

    agent_ids = set(agent_files.keys())

    # 2) semantic validations
    errors += validate_intents_used(agents, known_intents)
    errors += validate_playbooks(agent_ids)
    errors += validate_routing(agent_ids, playbook_ids)

    if errors:
        print("\n".join(errors))
        raise SystemExit(1)

    # 3) generate index
    idx = generate_agents_index(agents, agent_files)
    dump_yaml(IA_ROOT / "00_INDEX" / "agents_index.yaml", idx)
    print("OK: validation + génération agents_index.yaml")

if __name__ == "__main__":
    main()
