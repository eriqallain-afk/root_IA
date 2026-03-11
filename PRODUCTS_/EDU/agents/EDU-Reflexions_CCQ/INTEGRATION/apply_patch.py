import argparse
import copy
import yaml

MERGE_KEYS = ("id", "name", "slug", "key")

def merge(a, b):
    """Merge b into a (recursive).
    - dict: deep merge
    - list of dicts: merge by id/name/slug/key when possible, else append unique
    - list: append unique
    - scalar/type mismatch: b wins
    """
    if b is None:
        return a
    if a is None:
        return copy.deepcopy(b)

    if isinstance(a, dict) and isinstance(b, dict):
        out = copy.deepcopy(a)
        for k, v in b.items():
            out[k] = merge(out.get(k), v)
        return out

    if isinstance(a, list) and isinstance(b, list):
        if all(isinstance(x, dict) for x in a + b) and (a or b):
            key = None
            for candidate in MERGE_KEYS:
                if any(candidate in x for x in a + b):
                    key = candidate
                    break
            if key:
                out = copy.deepcopy(a)
                pos_by_key = {x.get(key): i for i, x in enumerate(out) if x.get(key) is not None}
                for item in b:
                    k = item.get(key)
                    if k is not None and k in pos_by_key:
                        out[pos_by_key[k]] = merge(out[pos_by_key[k]], item)
                    else:
                        out.append(copy.deepcopy(item))
                return out

        out = copy.deepcopy(a)
        for item in b:
            if item not in out:
                out.append(copy.deepcopy(item))
        return out

    return copy.deepcopy(b)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("base")
    ap.add_argument("patch")
    ap.add_argument("--inplace", action="store_true")
    args = ap.parse_args()

    with open(args.base, "r", encoding="utf-8") as f:
        base = yaml.safe_load(f)
    with open(args.patch, "r", encoding="utf-8") as f:
        patch = yaml.safe_load(f)

    merged = merge(base, patch)

    out_path = args.base if args.inplace else args.base + ".merged.yaml"
    with open(out_path, "w", encoding="utf-8") as f:
        yaml.safe_dump(merged, f, sort_keys=False, allow_unicode=True)

    print(f"OK -> {out_path}")

if __name__ == "__main__":
    main()
