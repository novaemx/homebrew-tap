#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION_OVERRIDE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --version)
      VERSION_OVERRIDE="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

bash "$ROOT_DIR/scripts/validate_formulas.sh"

if [[ -n "$VERSION_OVERRIDE" ]]; then
  bash "$ROOT_DIR/scripts/publish_preflight.sh" --version "$VERSION_OVERRIDE"
else
  bash "$ROOT_DIR/scripts/publish_preflight.sh"
fi

echo "Tap publish checks passed. Safe to publish."
