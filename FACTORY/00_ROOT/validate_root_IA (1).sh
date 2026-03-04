#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
CAT="$ROOT/00_INDEX/gpt_catalog.yaml"
PB="$ROOT/40_RUNBOOKS/playbooks.yaml"

[ -f "$CAT" ] || { echo "FAIL: missing $CAT"; exit 1; }
[ -f "$PB" ]  || { echo "FAIL: missing $PB"; exit 1; }

CAT_IDS="$(grep -E '^[ ]{2}[A-Za-z0-9_-]+:' "$CAT" | sed 's/^  \([A-Za-z0-9_-]\+\):.*/\1/' | sort -u)"
USED_IDS="$(grep -E 'actor_id:' "$PB" | sed -E 's/.*actor_id:[[:space:]]*"?([^"[:space:]]+)"?.*/\1/' | sort -u)"

MISSING=0
for id in $USED_IDS; do
  echo "$CAT_IDS" | grep -qx "$id" || { echo "FAIL: playbook uses unknown actor_id: $id"; MISSING=1; }
done

if [ "$MISSING" -eq 1 ]; then
  exit 1
fi

echo "OK: validation passed"