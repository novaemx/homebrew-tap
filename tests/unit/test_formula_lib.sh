#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$ROOT_DIR/scripts/lib/formula_lib.sh"

fixture_ok="$ROOT_DIR/tests/fixtures/Formula/sample-ok.rb"

assert_eq() {
  local got="$1"
  local expected="$2"
  local label="$3"
  if [[ "$got" != "$expected" ]]; then
    echo "FAIL: $label (got='$got' expected='$expected')"
    exit 1
  fi
}

v="$(extract_formula_field "$fixture_ok" version)"
u="$(extract_formula_field "$fixture_ok" url)"

assert_eq "$v" "1.2.3" "extract version"
assert_eq "$u" "https://example.com/downloads/sample-ok-1.2.3.tar.gz" "extract url"

if ! formula_url_contains_version "$fixture_ok"; then
  echo "FAIL: formula_url_contains_version should pass for sample-ok"
  exit 1
fi

echo "PASS: unit formula library tests"
