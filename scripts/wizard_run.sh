#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

confirm_continue() {
  local question="$1"
  local answer

  while true; do
    read -r -p "$question [y/N]: " answer
    case "$answer" in
      y|Y|yes|YES)
        return 0
        ;;
      n|N|no|NO|"")
        return 1
        ;;
      *)
        echo "Please answer y or n."
        ;;
    esac
  done
}

run_phase() {
  local label="$1"
  local cmd="$2"

  echo
  echo "== $label =="
  echo "Running: $cmd"
  eval "$cmd"
  echo "Phase completed: $label"
}

CURRENT_BRANCH="$(git branch --show-current)"
VERSION="$(tr -d '[:space:]' < VERSION)"
TAG="v$VERSION"

cat <<EOF
Tap interactive wizard
Branch: $CURRENT_BRANCH
Version: $VERSION
EOF

run_phase "Phase 1 - CI" "make ci"
if ! confirm_continue "Continue to Phase 2 (local preflight)?"; then
  echo "Stopped by user after Phase 1."
  exit 0
fi

run_phase "Phase 2 - Local preflight" "make preflight"
if ! confirm_continue "Continue to Phase 3 (strict publish checks)?"; then
  echo "Stopped by user after Phase 2."
  exit 0
fi

if [[ "$CURRENT_BRANCH" == "main" || "$CURRENT_BRANCH" == release/* || "$CURRENT_BRANCH" == hotfix/* ]]; then
  run_phase "Phase 3 - Strict publish checks" "make preflight-publish"
else
  echo
  echo "== Phase 3 - Strict publish checks (skipped) =="
  echo "Skipped for non-publish branch: $CURRENT_BRANCH"
  echo "Phase completed: Phase 3 - Strict publish checks (skipped)"
fi

if ! confirm_continue "Continue to Phase 4 (push to GitHub)?"; then
  echo "Stopped by user after Phase 3."
  exit 0
fi

if [[ "$CURRENT_BRANCH" == "main" || "$CURRENT_BRANCH" == release/* || "$CURRENT_BRANCH" == hotfix/* ]]; then
  run_phase "Phase 4 - Push release set" "make push-release"
else
  run_phase "Phase 4 - Push branch" "make push-branch"
fi

echo

echo "Wizard completed successfully."
