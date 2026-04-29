#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

ok_dir="$(mktemp -d)"
bad_dir="$(mktemp -d)"
trap 'rm -rf "$ok_dir" "$bad_dir"' EXIT

mkdir -p "$ok_dir/Formula" "$bad_dir/Formula"
cp "$ROOT_DIR/tests/fixtures/Formula/sample-ok.rb" "$ok_dir/Formula/"
cp "$ROOT_DIR/tests/fixtures/Formula/sample-ok.rb" "$bad_dir/Formula/"
cp "$ROOT_DIR/tests/fixtures/Formula/sample-bad.rb" "$bad_dir/Formula/"

if ! bash "$ROOT_DIR/scripts/validate_formulas.sh" --formula-dir "$ok_dir/Formula" >/dev/null; then
  echo "FAIL: validate_formulas should pass for valid fixtures"
  exit 1
fi

if bash "$ROOT_DIR/scripts/validate_formulas.sh" --formula-dir "$bad_dir/Formula" >/dev/null 2>&1; then
  echo "FAIL: validate_formulas should fail when any formula URL/version mismatches"
  exit 1
fi

echo "PASS: integration formula validation tests"
