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

get_main_ahead_of_develop() {
  local value
  value="$(gitflow --json status | sed -n 's/.*"main_ahead_of_develop":[[:space:]]*\([0-9][0-9]*\).*/\1/p' | head -n 1)"
  echo "${value:-0}"
}

ensure_pre_finish_backmerge() {
  local release_branch="$1"
  local ahead

  ahead="$(get_main_ahead_of_develop)"
  if [[ "$ahead" -gt 0 ]]; then
    echo "main is ahead of develop by $ahead commit(s); running pre-finish backmerge."
    run_phase "Phase 4.5 - Pre-finish backmerge" "gitflow --json backmerge"
    run_phase "Phase 4.6 - Return to release branch" "git checkout $release_branch"
  fi
}

ensure_clean_repo() {
  if [[ -n "$(git status --porcelain)" ]]; then
    echo "Working tree is not clean. Commit or stash changes before running gitflow automation." >&2
    exit 1
  fi
}

prepare_working_tree() {
  local branch
  local auto_name

  if [[ -z "$(git status --porcelain)" ]]; then
    return 0
  fi

  branch="$(git branch --show-current)"

  case "$branch" in
    develop|main)
      auto_name="auto-formulas-$(date +%Y%m%d-%H%M%S)"
      echo "Detected uncommitted changes on $branch. Creating feature/$auto_name for GitFlow compliance."
      gitflow --json start feature "$auto_name"
      ;;
    feature/*|bugfix/*|release/*|hotfix/*)
      echo "Detected uncommitted changes on $branch. Creating checkpoint commit."
      ;;
    *)
      echo "Unsupported branch context with pending changes: $branch" >&2
      exit 1
      ;;
  esac

  git add -A
  if ! git diff --cached --quiet; then
    git commit -m "chore: checkpoint pending formula updates"
  fi
}

next_patch_version() {
  local current="$1"
  local major minor patch
  IFS='.' read -r major minor patch <<< "$current"
  patch="${patch:-0}"
  echo "${major}.${minor}.$((patch + 1))"
}

release_tag_exists() {
  local version="$1"
  git rev-parse --verify "refs/tags/v${version}^{commit}" >/dev/null 2>&1
}

ensure_release_metadata() {
  local version="$1"
  local date_now
  local current_header

  date_now="$(date +%Y-%m-%d)"

  echo "$version" > VERSION

  if [[ -f RELEASE_NOTES.md ]]; then
    current_header="$(head -n 1 RELEASE_NOTES.md || true)"
  else
    current_header=""
  fi

  if [[ "$current_header" != "# Release $version" ]]; then
    cat > RELEASE_NOTES.md <<EOF
# Release $version

**Date:** $date_now

## What's New

- GitFlow wizard automation and CI reliability improvements.

## Improvements

- Wizard now supports full end-to-end flow with release fallback.
- GitHub Actions script execution reliability improved for Linux runners.
EOF
  fi

  git add VERSION RELEASE_NOTES.md
  if ! git diff --cached --quiet; then
    git commit -m "chore: bump version to $version"
  fi
}

CURRENT_BRANCH="$(git branch --show-current)"
VERSION="$(tr -d '[:space:]' < VERSION)"
TARGET_VERSION="$VERSION"

cat <<EOF
GitFlow automation wizard
Branch: $CURRENT_BRANCH
Version: $VERSION
EOF

prepare_working_tree
CURRENT_BRANCH="$(git branch --show-current)"

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
  if release_tag_exists "$TARGET_VERSION"; then
    TARGET_VERSION="$(next_patch_version "$TARGET_VERSION")"
    while release_tag_exists "$TARGET_VERSION"; do
      TARGET_VERSION="$(next_patch_version "$TARGET_VERSION")"
    done
    echo "Release tag v$VERSION already exists. Using next available version: $TARGET_VERSION"
  fi

  if git show-ref --verify --quiet "refs/heads/release/$TARGET_VERSION"; then
    run_phase "Phase 3 - Checkout existing release" "git checkout release/$TARGET_VERSION"
  else
    run_phase "Phase 3 - Start release" "gitflow --json start release $TARGET_VERSION"
  fi

  run_phase "Phase 3.1 - Sync release metadata" "ensure_release_metadata $TARGET_VERSION"
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
  ensure_pre_finish_backmerge "$CURRENT_BRANCH"
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
