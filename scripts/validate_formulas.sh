#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FORMULA_DIR="$ROOT_DIR/Formula"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --formula-dir)
      FORMULA_DIR="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

source "$ROOT_DIR/scripts/lib/formula_lib.sh"

if [[ ! -d "$FORMULA_DIR" ]]; then
  echo "Formula directory not found: $FORMULA_DIR" >&2
  exit 1
fi

failed=0
found=0

for formula in "$FORMULA_DIR"/*.rb; do
  [[ -e "$formula" ]] || continue
  found=1
  if ! formula_url_contains_version "$formula"; then
    echo "ERROR: version/url mismatch in $formula"
    failed=1
  fi

  if [[ -z "$(extract_formula_field "$formula" sha256 || true)" ]]; then
    echo "ERROR: missing sha256 in $formula"
    failed=1
  fi
done

if [[ "$found" -eq 0 ]]; then
  echo "ERROR: no formulas found in $FORMULA_DIR" >&2
  exit 1
fi

if [[ "$failed" -ne 0 ]]; then
  exit 1
fi

echo "Formula validation passed for: $FORMULA_DIR"
