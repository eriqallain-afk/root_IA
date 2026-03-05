#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
validate_refs.py
Cross-check:
- hub_routing.yaml: default_actor_id/default_playbook_id (+ fallback)
- playbooks.yaml: steps[].actor_id
- agents_index.yaml + gpt_catalog.yaml: actor_id presence + intents consistency

Exit codes:
  0: OK (no errors)
  2: Errors found
  1: Fatal runtime error (file parse, etc.)
"""

from __future__ import annotations

import argparse
import dataclasses
import os
import sys
from typing import Any, Dict, Iterable, List, Optional, Set, Tuple

try:
    import yaml  # PyYAML
except Exception as e:
    print("FATAL: PyYAML est requis. Installe: pip install pyyaml", file=sys.stderr)
    raise


# -----------------------------
# Models
# -----------------------------

@dataclasses.dataclass
class AgentInfo:
    actor_id: str
    team_id: Optional[str] = None
    intents: Set[str] = dataclasses.field(default_factory=set)
    status: Optional[str] = None
    source: str = ""  # agents_index | gpt_catalog


@dataclasses.dataclass
class RouteInfo:
    idx: int
    match_any_intents: Set[str]
    default_actor_id: Optional[str]
    default_playbook_id: Optional[str]


@dataclasses.dataclass
class Findings:
    errors: List[str] = dataclasses.field(default_factory=list)
    warnings: List[str] = dataclasses.field(default_factory=list)

    def has_errors(self) -> bool:
        return len(self.errors) > 0

    def add_error(self, msg: str) -> None:
        self.errors.append(msg)

    def add_warn(self, msg: str) -> None:
        self.warnings.append(msg)


# -----------------------------
# Helpers
# -----------------------------

def read_yaml(path: str) -> Any:
    if not os.path.exists(path):
        raise FileNotFoundError(path)
    with open(path, "r", encoding="utf-8") as f:
        return yaml.safe_load(f)


def _as_set_str(v: Any) -> Set[str]:
    if v is None:
        return set()
    if isinstance(v, str):
        return {v}
    if isinstance(v, list):
        return {str(x).strip() for x in v if str(x).strip()}
    if isinstance(v, set):
        return {str(x).strip() for x in v if str(x).strip()}
    return set()


def _normalize_intent(s: str) -> str:
    return str(s).strip()


def _maybe_get(d: Dict[str, Any], *keys: str) -> Any:
    for k in keys:
        if k in d:
            return d[k]
    return None


# -----------------------------
# Extractors (indexes)
# -----------------------------

def extract_agents_from_index(data: Any, source_name: str) -> Dict[str, AgentInfo]:
    """
    Heuristique stable:
      - data["agents"] (list of dicts with 'id') OR
      - data["items"]  (list of dicts with 'id') OR
      - data is list of dicts with 'id'
    """
    agents: List[Dict[str, Any]] = []

    if isinstance(data, dict):
        if isinstance(data.get("agents"), list):
            agents = data["agents"]
        elif isinstance(data.get("items"), list):
            agents = data["items"]
        elif isinstance(data.get("gpts"), list):  # parfois catalogue
            agents = data["gpts"]
        elif isinstance(data.get("catalog"), list):
            agents = data["catalog"]
        else:
            # fallback: some indexes are dicts keyed by id
            # ex: { "IT-CloudMaster": {...}, ... }
            # We'll accept if values look like agent dicts.
            all_values = list(data.values())
            if all_values and all(isinstance(v, dict) for v in all_values):
                # check if at least one has 'id' or 'team_id'
                if any(("id" in v) or ("team_id" in v) for v in all_values):
                    # If keys look like ids, inject them if missing
                    for k, v in data.items():
                        vv = dict(v)
                        vv.setdefault("id", k)
                        agents.append(vv)

    elif isinstance(data, list):
        agents = [x for x in data if isinstance(x, dict)]

    out: Dict[str, AgentInfo] = {}
    for a in agents:
        actor_id = _maybe_get(a, "id", "actor_id", "actorId")
        if not actor_id:
            continue
        actor_id = str(actor_id).strip()
        intents = {_normalize_intent(x) for x in _as_set_str(_maybe_get(a, "intents", "intent", "capabilities"))}
        team_id = _maybe_get(a, "team_id", "team", "teamId")
        status = _maybe_get(a, "status")
        out[actor_id] = AgentInfo(
            actor_id=actor_id,
            team_id=str(team_id).strip() if team_id else None,
            intents=intents,
            status=str(status).strip() if status else None,
            source=source_name,
        )
    return out


# -----------------------------
# Extractors (playbooks)
# -----------------------------

def extract_playbooks(data: Any) -> Tuple[Set[str], Set[str], Dict[str, Set[str]]]:
    """
    Returns:
      playbook_ids
      referenced_actor_ids (in steps)
      playbook_to_actor_refs
    Supports shapes:
      - {schema_version, playbooks: {PB_ID: {steps:[{actor_id:..}]}}}
      - {PB_ID: {steps:[...]}, ...}
      - {playbooks: [...]} (less common)
    """
    pb_map: Dict[str, Any] = {}

    if isinstance(data, dict):
        if isinstance(data.get("playbooks"), dict):
            pb_map = data["playbooks"]
        elif isinstance(data.get("playbooks"), list):
            # list form: each has id
            for x in data["playbooks"]:
                if isinstance(x, dict):
                    pid = _maybe_get(x, "id", "playbook_id", "name")
                    if pid:
                        pb_map[str(pid).strip()] = x
        else:
            # treat top-level keys as playbooks if they look like playbooks
            # e.g. INTAKE_ROUTE_EXECUTE: {steps: [...]}
            for k, v in data.items():
                if isinstance(v, dict) and ("steps" in v or "description" in v):
                    pb_map[str(k).strip()] = v

    playbook_ids: Set[str] = set(pb_map.keys())
    referenced_actors: Set[str] = set()
    pb_to_refs: Dict[str, Set[str]] = {pid: set() for pid in playbook_ids}

    for pid, pb in pb_map.items():
        steps = None
        if isinstance(pb, dict):
            steps = pb.get("steps")
        if not isinstance(steps, list):
            continue

        for step in steps:
            if not isinstance(step, dict):
                continue
            actor_id = _maybe_get(step, "actor_id", "actor", "agent_id")
            if actor_id:
                aid = str(actor_id).strip()
                referenced_actors.add(aid)
                pb_to_refs[pid].add(aid)

    return playbook_ids, referenced_actors, pb_to_refs


# -----------------------------
# Extractors (routing)
# -----------------------------

def extract_routes(data: Any) -> Tuple[List[RouteInfo], Optional[Tuple[str, str]]]:
    """
    Returns:
      routes list
      fallback (actor_id, playbook_id) if present
    Supports shape:
      - {routing_table:[{match_any_intents:[], default_actor_id:"", default_playbook_id:""}], fallback:{...}}
    """
    if not isinstance(data, dict):
        return [], None

    table = None
    for k in ("routing_table", "routes", "routing", "table"):
        if isinstance(data.get(k), list):
            table = data[k]
            break

    routes: List[RouteInfo] = []
    if isinstance(table, list):
        for i, r in enumerate(table):
            if not isinstance(r, dict):
                continue
            intents = _as_set_str(_maybe_get(r, "match_any_intents", "intents", "match_any", "match"))
            routes.append(
                RouteInfo(
                    idx=i,
                    match_any_intents={_normalize_intent(x) for x in intents},
                    default_actor_id=str(_maybe_get(r, "default_actor_id", "actor_id", "route_to_actor_id")).strip()
                    if _maybe_get(r, "default_actor_id", "actor_id", "route_to_actor_id")
                    else None,
                    default_playbook_id=str(_maybe_get(r, "default_playbook_id", "playbook_id", "route_to_playbook_id")).strip()
                    if _maybe_get(r, "default_playbook_id", "playbook_id", "route_to_playbook_id")
                    else None,
                )
            )

    fb = None
    fallback = data.get("fallback")
    if isinstance(fallback, dict):
        fa = _maybe_get(fallback, "default_actor_id", "actor_id")
        fp = _maybe_get(fallback, "default_playbook_id", "playbook_id")
        if fa and fp:
            fb = (str(fa).strip(), str(fp).strip())

    return routes, fb


# -----------------------------
# Validation logic
# -----------------------------

def validate(
    agents_index_path: str,
    gpt_catalog_path: str,
    hub_routing_path: str,
    playbooks_path: str,
    strict_index_sync: bool,
    fail_on_warn: bool,
) -> Tuple[Findings, Dict[str, Any]]:
    findings = Findings()

    agents_index = extract_agents_from_index(read_yaml(agents_index_path), "agents_index")
    gpt_catalog = extract_agents_from_index(read_yaml(gpt_catalog_path), "gpt_catalog")

    hub_routing = read_yaml(hub_routing_path)
    playbooks = read_yaml(playbooks_path)

    routes, fallback = extract_routes(hub_routing)
    pb_ids, pb_actor_refs, pb_to_actor_refs = extract_playbooks(playbooks)

    # Sets
    idx_ids = set(agents_index.keys())
    cat_ids = set(gpt_catalog.keys())

    # Index sync
    only_in_catalog = sorted(cat_ids - idx_ids)
    only_in_index = sorted(idx_ids - cat_ids)

    if only_in_catalog:
        msg = f"INDEX_SYNC: présents dans gpt_catalog mais absents dans agents_index: {only_in_catalog}"
        (findings.add_error if strict_index_sync else findings.add_warn)(msg)
    if only_in_index:
        msg = f"INDEX_SYNC: présents dans agents_index mais absents dans gpt_catalog: {only_in_index}"
        (findings.add_error if strict_index_sync else findings.add_warn)(msg)

    # Intent divergences (same actor in both)
    common = sorted(cat_ids & idx_ids)
    for aid in common:
        ci = gpt_catalog[aid].intents
        ai = agents_index[aid].intents
        if ci != ai:
            # show small diff
            added = sorted(ai - ci)
            removed = sorted(ci - ai)
            findings.add_warn(
                f"INTENTS_DIVERGE: {aid} intents diff | agents_index(+){added} | gpt_catalog(-){removed}"
            )

    # Routing references -> must exist
    routing_actor_refs: Set[str] = set()
    routing_playbook_refs: Set[str] = set()
    intent_to_targets: Dict[str, Set[Tuple[Optional[str], Optional[str]]]] = {}

    for r in routes:
        if r.default_actor_id:
            routing_actor_refs.add(r.default_actor_id)
        if r.default_playbook_id:
            routing_playbook_refs.add(r.default_playbook_id)

        tgt = (r.default_actor_id, r.default_playbook_id)
        for intent in r.match_any_intents:
            intent_to_targets.setdefault(intent, set()).add(tgt)

    if fallback:
        routing_actor_refs.add(fallback[0])
        routing_playbook_refs.add(fallback[1])

    # Missing actors referenced by routing
    missing_routing_actors = sorted(a for a in routing_actor_refs if a not in idx_ids and a not in cat_ids)
    if missing_routing_actors:
        findings.add_error(f"ROUTING_REF_MISSING_ACTORS: {missing_routing_actors}")

    # Missing playbooks referenced by routing
    missing_routing_pbs = sorted(p for p in routing_playbook_refs if p not in pb_ids)
    if missing_routing_pbs:
        findings.add_error(f"ROUTING_REF_MISSING_PLAYBOOKS: {missing_routing_pbs}")

    # Duplicate intents -> different targets
    for intent, targets in intent_to_targets.items():
        if len(targets) > 1:
            findings.add_error(f"ROUTING_INTENT_CONFLICT: intent '{intent}' pointe vers plusieurs cibles: {sorted(list(targets))}")

    # Routing intent overlap with target agent intents (warning)
    # Only check when actor exists in index (preferred)
    for r in routes:
        aid = r.default_actor_id
        if not aid:
            continue
        agent = agents_index.get(aid) or gpt_catalog.get(aid)
        if not agent or not agent.intents or not r.match_any_intents:
            continue
        overlap = agent.intents & r.match_any_intents
        if not overlap:
            findings.add_warn(
                f"ROUTING_TARGET_INTENT_MISMATCH: route[{r.idx}] cible '{aid}' "
                f"mais aucun overlap entre match_any_intents et intents déclarés par l'agent."
            )

    # Playbooks -> missing actors referenced
    missing_pb_actors = sorted(a for a in pb_actor_refs if a not in idx_ids and a not in cat_ids)
    if missing_pb_actors:
        # include where referenced
        where = []
        for pid, refs in pb_to_actor_refs.items():
            miss = sorted([a for a in refs if a in set(missing_pb_actors)])
            if miss:
                where.append(f"{pid}:{miss}")
        findings.add_error(f"PLAYBOOK_REF_MISSING_ACTORS: {missing_pb_actors} | where={where}")

    # Actor lifecycle checks (warn if deprecated but referenced)
    # (if status field exists in index)
    deprecated = {aid for aid, info in agents_index.items() if (info.status or "").lower() == "deprecated"}
    referenced_all = routing_actor_refs | pb_actor_refs
    used_deprecated = sorted(list(deprecated & referenced_all))
    if used_deprecated:
        findings.add_warn(f"DEPRECATED_ACTOR_REFERENCED: {used_deprecated}")

    # Build summary dict
    summary = {
        "counts": {
            "agents_index": len(agents_index),
            "gpt_catalog": len(gpt_catalog),
            "routes": len(routes),
            "playbooks": len(pb_ids),
            "routing_actor_refs": len(routing_actor_refs),
            "routing_playbook_refs": len(routing_playbook_refs),
            "playbook_actor_refs": len(pb_actor_refs),
        },
        "only_in_catalog": only_in_catalog,
        "only_in_index": only_in_index,
        "missing_routing_actors": missing_routing_actors,
        "missing_routing_playbooks": missing_routing_pbs,
        "missing_playbook_actors": missing_pb_actors,
    }

    if fail_on_warn and findings.warnings:
        findings.add_error(f"FAIL_ON_WARN: {len(findings.warnings)} warning(s) escaladées en erreur (option --fail-on-warn).")

    return findings, summary


def render_report_md(findings: Findings, summary: Dict[str, Any]) -> str:
    c = summary.get("counts", {})
    lines: List[str] = []
    lines.append("# validate_refs.py — Rapport\n")
    lines.append("## Résumé\n")
    lines.append(f"- Agents (agents_index): **{c.get('agents_index', 0)}**")
    lines.append(f"- Agents (gpt_catalog): **{c.get('gpt_catalog', 0)}**")
    lines.append(f"- Routes (hub_routing): **{c.get('routes', 0)}**")
    lines.append(f"- Playbooks: **{c.get('playbooks', 0)}**")
    lines.append(f"- Erreurs: **{len(findings.errors)}**")
    lines.append(f"- Warnings: **{len(findings.warnings)}**\n")

    def section(title: str, items: List[str]) -> None:
        lines.append(f"## {title}\n")
        if not items:
            lines.append("- (aucun)\n")
            return
        for it in items:
            lines.append(f"- {it}")
        lines.append("")

    section("Erreurs", findings.errors)
    section("Warnings", findings.warnings)

    # Key deltas
    lines.append("## Deltas index\n")
    lines.append(f"- Uniquement gpt_catalog: `{summary.get('only_in_catalog', [])}`")
    lines.append(f"- Uniquement agents_index: `{summary.get('only_in_index', [])}`\n")

    lines.append("## Références manquantes\n")
    lines.append(f"- Routing → actors: `{summary.get('missing_routing_actors', [])}`")
    lines.append(f"- Routing → playbooks: `{summary.get('missing_routing_playbooks', [])}`")
    lines.append(f"- Playbooks → actors: `{summary.get('missing_playbook_actors', [])}`\n")

    return "\n".join(lines)


# -----------------------------
# CLI
# -----------------------------

def main() -> int:
    p = argparse.ArgumentParser(
        description="Cross-check hub_routing.yaml, playbooks.yaml, agents_index.yaml, gpt_catalog.yaml",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    p.add_argument("--agents-index", default="00_INDEX/agents_index.yaml", help="Chemin agents_index.yaml")
    p.add_argument("--gpt-catalog", default="00_INDEX/gpt_catalog.yaml", help="Chemin gpt_catalog.yaml")
    p.add_argument("--hub-routing", default="80_MACHINES/hub_routing.yaml", help="Chemin hub_routing.yaml")
    p.add_argument("--playbooks", default="40_RUNBOOKS/playbooks.yaml", help="Chemin playbooks.yaml")
    p.add_argument("-o", "--out-md", default=None, help="Écrire un rapport Markdown à ce chemin")
    p.add_argument("--strict-index-sync", action="store_true", help="Index sync = ERROR (sinon WARN)")
    p.add_argument("--fail-on-warn", action="store_true", help="Convertit les warnings en erreur de build")
    args = p.parse_args()

    try:
        findings, summary = validate(
            agents_index_path=args.agents_index,
            gpt_catalog_path=args.gpt_catalog,
            hub_routing_path=args.hub_routing,
            playbooks_path=args.playbooks,
            strict_index_sync=args.strict_index_sync,
            fail_on_warn=args.fail_on_warn,
        )
    except Exception as e:
        print(f"FATAL: {e}", file=sys.stderr)
        return 1

    # Console output
    counts = summary.get("counts", {})
    print("== validate_refs.py ==")
    print(f"agents_index: {counts.get('agents_index', 0)} | gpt_catalog: {counts.get('gpt_catalog', 0)}")
    print(f"routes: {counts.get('routes', 0)} | playbooks: {counts.get('playbooks', 0)}")
    print(f"ERRORS: {len(findings.errors)} | WARNINGS: {len(findings.warnings)}\n")

    if findings.errors:
        print("ERRORS:")
        for e in findings.errors:
            print(f" - {e}")
        print("")

    if findings.warnings:
        print("WARNINGS:")
        for w in findings.warnings:
            print(f" - {w}")
        print("")

    if args.out_md:
        report = render_report_md(findings, summary)
        os.makedirs(os.path.dirname(args.out_md) or ".", exist_ok=True)
        with open(args.out_md, "w", encoding="utf-8") as f:
            f.write(report)
        print(f"Rapport écrit: {args.out_md}")

    return 2 if findings.has_errors() else 0


if __name__ == "__main__":
    sys.exit(main())
