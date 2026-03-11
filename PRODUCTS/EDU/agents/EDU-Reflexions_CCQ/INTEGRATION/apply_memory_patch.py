#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""apply_memory_patch.py

Applique des mises à jour anonymisées (memory_patch) aux fichiers 10_MEMORY/*.
- Accepte un fichier résultat JSON **ou** YAML (PyYAML charge les deux).
- Supporte sorties SINGLE ou BATCH (contract.json v1.0.2).
- Évite les doublons lors des append (records, règles, guidelines).

Usage:
  python apply_memory_patch.py --memory-dir <10_MEMORY> --result-yaml <result.json|yaml>
"""

import argparse, os, sys, copy, hashlib
from datetime import datetime, timezone
import yaml

def now_iso():
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

def deep_merge(a, b):
    if b is None:
        return a
    if a is None:
        return copy.deepcopy(b)
    if isinstance(a, dict) and isinstance(b, dict):
        out = copy.deepcopy(a)
        for k, v in b.items():
            out[k] = deep_merge(out.get(k), v)
        return out
    if isinstance(a, list) and isinstance(b, list):
        out = copy.deepcopy(a)
        for item in b:
            if item not in out:
                out.append(copy.deepcopy(item))
        return out
    return copy.deepcopy(b)

def read_yaml(path):
    with open(path, "r", encoding="utf-8", errors="replace") as f:
        return yaml.safe_load(f)

def write_yaml(path, data):
    with open(path, "w", encoding="utf-8") as f:
        yaml.safe_dump(data, f, sort_keys=False, allow_unicode=True)

def stable_hash(obj) -> str:
    raw = yaml.safe_dump(obj, sort_keys=True, allow_unicode=True)
    return hashlib.sha256(raw.encode("utf-8")).hexdigest()[:16]

def collect_memory_patches(result_obj):
    patches = []

    def add_patch(mp):
        if isinstance(mp, dict) and mp.get("apply") is True and isinstance(mp.get("updates"), dict):
            patches.append(mp)

    if not isinstance(result_obj, dict):
        return patches

    add_patch(result_obj.get("memory_patch"))

    batch = result_obj.get("batch")
    if isinstance(batch, dict):
        add_patch(batch.get("memory_patch"))
        items = batch.get("items") or []
        if isinstance(items, list):
            for it in items:
                if isinstance(it, dict):
                    res = it.get("result")
                    if isinstance(res, dict):
                        add_patch(res.get("memory_patch"))

    return patches

def aggregate_updates(patches):
    """Combine plusieurs memory_patch en une seule structure updates."""
    agg = {}
    append_records = []

    for mp in patches:
        updates = mp.get("updates", {})
        if not isinstance(updates, dict):
            continue

        rs = updates.get("rolling_stats")
        if isinstance(rs, dict):
            if "append_record" in rs and rs["append_record"]:
                append_records.append(rs["append_record"])
            if "append_records" in rs and isinstance(rs["append_records"], list):
                append_records.extend([r for r in rs["append_records"] if r])

        # merge other namespaces
        for k, v in updates.items():
            if k == "rolling_stats":
                continue
            agg[k] = deep_merge(agg.get(k), v)

    if append_records:
        agg.setdefault("rolling_stats", {})
        agg["rolling_stats"]["append_records"] = append_records

    return agg

def bump_meta(doc):
    now = now_iso()
    doc["updated_at_utc"] = now
    # bump patch version naive: keep x.y.z and increment z
    mv = str(doc.get("memory_version", "0.0.0"))
    parts = mv.split(".")
    if len(parts) == 3 and all(p.isdigit() for p in parts):
        parts[2] = str(int(parts[2]) + 1)
        doc["memory_version"] = ".".join(parts)
    else:
        doc["memory_version"] = mv

def dedup_list(existing, new_items):
    seen = set(stable_hash(x) for x in existing)
    out = list(existing)
    for it in new_items:
        h = stable_hash(it)
        if h not in seen:
            out.append(it)
            seen.add(h)
    return out

def apply_updates(memory_dir, updates):
    now = now_iso()

    # Rolling stats
    rs_updates = updates.get("rolling_stats", {})
    if isinstance(rs_updates, dict) and rs_updates.get("append_records"):
        rs_path = os.path.join(memory_dir, "MEM__RollingStats.yaml")
        stats = read_yaml(rs_path)
        stats.setdefault("rolling_stats", {})
        stats["rolling_stats"].setdefault("records", [])

        # Dedup
        stats["rolling_stats"]["records"] = dedup_list(stats["rolling_stats"]["records"], rs_updates["append_records"])

        # Recompute aggregates (simple)
        recs = stats["rolling_stats"]["records"]
        totals = [r.get("total_score_on_100") for r in recs if isinstance(r, dict) and isinstance(r.get("total_score_on_100"), int)]
        if totals:
            import math
            n = len(totals)
            mean = sum(totals) / n
            stdev = math.sqrt(sum((x-mean)**2 for x in totals)/n) if n > 1 else 0
            stats["rolling_stats"]["total_on_100"] = {
                "n": n,
                "mean": round(mean, 2),
                "stdev": round(stdev, 2),
                "min": int(min(totals)),
                "max": int(max(totals)),
            }

            # section means
            sec_names = ["Introduction","Synopsis","Tensions éthiques","Choix éthiques","Conclusion"]
            sec_obj = stats["rolling_stats"].get("sections_mean_on_20", {})
            for s in sec_names:
                vals = []
                for r in recs:
                    v = None
                    if isinstance(r, dict):
                        sec = r.get("sections_on_20", {})
                        if isinstance(sec, dict):
                            v = sec.get(s)
                    if isinstance(v, int):
                        vals.append(v)
                if vals:
                    n2 = len(vals)
                    m2 = sum(vals)/n2
                    st2 = math.sqrt(sum((x-m2)**2 for x in vals)/n2) if n2 > 1 else 0
                    sec_obj[s] = {"n": n2, "mean": round(m2,2), "stdev": round(st2,2)}
            stats["rolling_stats"]["sections_mean_on_20"] = sec_obj

        bump_meta(stats)
        write_yaml(rs_path, stats)
        print(f"Updated {rs_path}")

    # Annie guidelines
    if "annie_guidelines" in updates:
        ag_path = os.path.join(memory_dir, "MEM__AnnieGuidelines.yaml")
        ag = read_yaml(ag_path)
        u = updates["annie_guidelines"] or {}

        # new_entries
        entries = u.get("new_entries") or []
        if entries:
            ag.setdefault("annie_guidelines", [])
            ag["annie_guidelines"] = dedup_list(ag["annie_guidelines"], entries)

        # feedback_style
        fs = u.get("feedback_style")
        if isinstance(fs, dict) and fs:
            ag["annie_feedback_style"] = deep_merge(ag.get("annie_feedback_style", {}), fs)

        if entries or (isinstance(fs, dict) and fs):
            ag.setdefault("annie_updates_log", [])
            ag["annie_updates_log"].append({"timestamp_utc": now, "changes": list(u.keys())})
            bump_meta(ag)
            write_yaml(ag_path, ag)
            print(f"Updated {ag_path}")

    # Calibration profile (borderline rules)
    if "calibration_profile" in updates:
        cp_path = os.path.join(memory_dir, "MEM__CalibrationProfile.yaml")
        cp = read_yaml(cp_path)
        u = updates["calibration_profile"] or {}
        rules = u.get("add_borderline_rule") or []
        if rules:
            cp.setdefault("borderline_rules", [])
            cp["borderline_rules"] = dedup_list(cp["borderline_rules"], rules)
            cp.setdefault("history", [])
            cp["history"].append({"timestamp_utc": now, "action": "add_borderline_rule", "count": len(rules)})
            bump_meta(cp)
            write_yaml(cp_path, cp)
            print(f"Updated {cp_path}")

    # Local rules
    if "local_rules" in updates:
        lr_path = os.path.join(memory_dir, "MEM__LocalRules.yaml")
        lr = read_yaml(lr_path)
        u = updates["local_rules"] or {}
        rules = u.get("new_rules") or []
        if rules:
            lr.setdefault("local_rules", [])
            lr["local_rules"] = dedup_list(lr["local_rules"], rules)
            bump_meta(lr)
            write_yaml(lr_path, lr)
            print(f"Updated {lr_path}")

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--memory-dir", required=True, help="Path to 10_MEMORY directory")
    ap.add_argument("--result-yaml", required=True, help="Path to result JSON/YAML produced by the agent")
    args = ap.parse_args()

    if not os.path.isdir(args.memory_dir):
        print(f"ERROR: memory-dir not found: {args.memory_dir}", file=sys.stderr)
        sys.exit(2)
    if not os.path.isfile(args.result_yaml):
        print(f"ERROR: result-yaml not found: {args.result_yaml}", file=sys.stderr)
        sys.exit(2)

    result_obj = read_yaml(args.result_yaml)
    patches = collect_memory_patches(result_obj)
    if not patches:
        print("No memory_patch found (nothing to apply).")
        return

    updates = aggregate_updates(patches)
    apply_updates(args.memory_dir, updates)

if __name__ == "__main__":
    main()
