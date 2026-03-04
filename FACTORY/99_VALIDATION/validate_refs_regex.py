#!/usr/bin/env python3

"""
validate_refs_regex.py
Validation "sans dépendances" (regex) pour:
- hub_routing.yaml
- agents_index.yaml
- playbooks_index.yaml (optionnel)

Usage:
  python .\99_VALIDATION\validate_refs_regex.py --root "C:\Intranet_EA\EA_IA\root_IA"

Exit codes:
  0 OK
  1 errors
"""
import argparse, os, re, sys, json
from pathlib import Path

def find_file(root: Path, candidates, fallback_name):
    for c in candidates:
        p = root / c
        if p.exists():
            return p
    for p in root.rglob(fallback_name):
        return p
    return None

def parse_yaml_lite_list(path: Path):
    # Same idea as PS: detect "- ..." entries and key: value lines.
    items = []
    current = None
    start_line = 0
    keyval = re.compile(r'^\s*([A-Za-z0-9_]+)\s*:\s*(.*)$')
    with path.open('r', encoding='utf-8', errors='ignore') as f:
        for i, raw in enumerate(f, start=1):
            line = raw.rstrip('\n')
            if re.match(r'^\s*#', line) or not line.strip():
                continue
            m = re.match(r'^\s*-\s*(.*)$', line)
            if m:
                if current is not None:
                    items.append(current)
                current = {"__startLine": i}
                start_line = i
                rest = m.group(1).strip()
                m2 = keyval.match(rest)
                if m2:
                    k, v = m2.group(1), m2.group(2).strip()
                    current[k] = v.strip('"\'')

                continue
            m = keyval.match(line)
            if m and current is not None:
                k, v = m.group(1), m.group(2).strip()
                if v == "":
                    continue
                current[k] = v.strip('"\'')

    if current is not None:
        items.append(current)
    return items

def extract_ids(path: Path, keys):
    s = set()
    for it in parse_yaml_lite_list(path):
        for k in keys:
            v = it.get(k)
            if v:
                s.add(str(v))
    return s

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=r"C:\Intranet_EA\EA_IA\root_IA")
    ap.add_argument("--out", default="")
    args = ap.parse_args()

    root = Path(args.root)
    errors, warnings = [], []

    router = find_file(root, [r"00_INDEX\hub_routing.yaml", "hub_routing.yaml"], "hub_routing.yaml")
    agents = find_file(root, [r"00_INDEX\agents_index.yaml", "agents_index.yaml"], "agents_index.yaml")
    playbooks = find_file(root, [r"00_INDEX\playbooks_index.yaml", "playbooks_index.yaml", r"00_INDEX\playbooks.yaml", "playbooks.yaml"], "playbooks_index.yaml")

    if not router:
        errors.append("hub_routing.yaml introuvable")
    if not agents:
        errors.append("agents_index.yaml introuvable")
    if errors:
        for e in errors:
            print("[ERR]", e)
        return 1

    routes = parse_yaml_lite_list(router)
    agents_set = extract_ids(agents, ["actor_id","id","actorId"])
    if playbooks:
        playbooks_set = extract_ids(playbooks, ["playbook_id","id","playbookId"])
    else:
        playbooks_set = set()
        for pat in ["playbook*.yaml","playbook*.yml","*playbooks*.yaml","*playbooks*.yml"]:
            for p in root.rglob(pat):
                try:
                    playbooks_set |= extract_ids(p, ["playbook_id","id","playbookId"])
                except Exception:
                    warnings.append(f"Impossible de parser: {p}")

    intents = set()
    for r in routes:
        ln = r.get("__startLine", "?")
        intent = r.get("intent")
        actor = r.get("actor_id")
        pb = r.get("playbook_id")
        if not (intent and actor and pb):
            errors.append(f"Route incomplète ({router}:{ln})")
            continue
        if intent in intents:
            errors.append(f"Intent dupliqué '{intent}' ({router}:{ln})")
        intents.add(intent)
        if agents_set and actor not in agents_set:
            errors.append(f"actor_id inconnu '{actor}' pour intent '{intent}' ({router}:{ln})")
        if playbooks_set and pb not in playbooks_set:
            errors.append(f"playbook_id inconnu '{pb}' pour intent '{intent}' ({router}:{ln})")

    print("=== validate_refs_regex.py ===")
    print("[OK] Routes:", len(routes))
    print("[OK] Agents:", len(agents_set))
    print("[OK] Playbooks:", len(playbooks_set))
    print("[WARN] Warnings:", len(warnings))
    print("[ERR] Erreurs:", len(errors))
    for w in warnings:
        print("[WARN]", w)
    for e in errors:
        print("[ERR]", e)

    if args.out:
        report = {
            "rootPath": str(root),
            "files": {"router": str(router), "agents_index": str(agents), "playbooks_index": str(playbooks) if playbooks else None},
            "counts": {"routes": len(routes), "agents": len(agents_set), "playbooks": len(playbooks_set), "warnings": len(warnings), "errors": len(errors)},
            "warnings": warnings,
            "errors": errors
        }
        Path(args.out).write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")
        print("[OK] Rapport JSON écrit:", args.out)

    return 1 if errors else 0

if __name__ == "__main__":
    raise SystemExit(main())
