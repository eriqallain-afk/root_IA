#!/usr/bin/env bash
set -euo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"
python3 "$REPO/00_ROOT/validate_rootIA_v2.py"
