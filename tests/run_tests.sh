#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash "$ROOT_DIR/tests/unit/test_formula_lib.sh"
bash "$ROOT_DIR/tests/integration/test_validate_formulas.sh"
bash "$ROOT_DIR/tests/e2e/test_publish_preflight.sh"

echo "PASS: all test suites"
