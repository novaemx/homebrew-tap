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

ensure_clean_repo() {
  if [[ -n "$(git status --porcelain)" ]]; then
    echo "Working tree is not clean. Commit or stash changes before running gitflow automation." >&2
    exit 1
  fi
}

CURRENT_BRANCH="$(git branch --show-current)"
VERSION="$(tr -d '[:space:]' < VERSION)"

cat <<EOF
GitFlow automation wizard
Branch: $CURRENT_BRANCH
Version: $VERSION
EOF

ensure_clean_repo
run_phase "Phase 1 - Validate branch changes" "make ci"
if ! confirm_continue "Continue to next phase?"; then
  echo "Stopped by user after Phase 1."
  exit 0
fi

case "$CURRENT_BRANCH" in
  feature/*|bugfix/*)
    run_phase "Phase 2 - Finish working branch" "gitflow --json finish"
    ;;
  develop)
    echo
    echo "== Phase 2 - Finish working branch (skipped) =="
    echo "Already on develop; no feature/bugfix branch to finish."
    echo "Phase completed: Phase 2 - Finish working branch (skipped)"
    ;;
  release/*|hotfix/*|main)
    echo
    echo "== Phase 2 - Finish working branch (skipped) =="
    echo "Branch type $CURRENT_BRANCH does not require feature finish here."
    echo "Phase completed: Phase 2 - Finish working branch (skipped)"
    ;;
  *)
    echo "Unsupported branch context for automation: $CURRENT_BRANCH" >&2
    exit 1
    ;;
esac

if ! confirm_continue "Continue to release phase?"; then
  echo "Stopped by user after Phase 2."
  exit 0
fi

CURRENT_BRANCH="$(git branch --show-current)"
if [[ "$CURRENT_BRANCH" == "develop" ]]; then
  if git show-ref --verify --quiet "refs/heads/release/$VERSION"; then
    run_phase "Phase 3 - Checkout existing release" "git checkout release/$VERSION"
  else
    run_phase "Phase 3 - Start release" "gitflow --json start release $VERSION"
  fi
else
  echo
  echo "== Phase 3 - Start release (skipped) =="
  echo "Current branch is $CURRENT_BRANCH; expected develop to start release."
  echo "Phase completed: Phase 3 - Start release (skipped)"
fi

if ! confirm_continue "Continue to release checks?"; then
  echo "Stopped by user after Phase 3."
  exit 0
fi

CURRENT_BRANCH="$(git branch --show-current)"
if [[ "$CURRENT_BRANCH" == release/* || "$CURRENT_BRANCH" == hotfix/* ]]; then
  run_phase "Phase 4 - Validate release" "make release-ready"
else
  echo
  echo "== Phase 4 - Validate release (skipped) =="
  echo "Current branch is $CURRENT_BRANCH; release checks skipped."
  echo "Phase completed: Phase 4 - Validate release (skipped)"
fi

if ! confirm_continue "Continue to finish release/hotfix?"; then
  echo "Stopped by user after Phase 4."
  exit 0
fi

CURRENT_BRANCH="$(git branch --show-current)"
if [[ "$CURRENT_BRANCH" == release/* || "$CURRENT_BRANCH" == hotfix/* ]]; then
  run_phase "Phase 5 - Finish release/hotfix" "gitflow --json finish"
else
  echo
  echo "== Phase 5 - Finish release/hotfix (skipped) =="
  echo "Current branch is $CURRENT_BRANCH; nothing to finish."
  echo "Phase completed: Phase 5 - Finish release/hotfix (skipped)"
fi

if ! confirm_continue "Continue to backmerge and push?"; then
  echo "Stopped by user after Phase 5."
  exit 0
fi

run_phase "Phase 6 - Backmerge stabilization" "gitflow --json backmerge"
run_phase "Phase 7 - Push release artifacts" "make push-release"

echo

echo "GitFlow automation completed successfully."
