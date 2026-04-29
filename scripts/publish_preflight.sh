#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_DIR="$ROOT_DIR"
VERSION_OVERRIDE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)
      REPO_DIR="$2"
      shift 2
      ;;
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

cd "$REPO_DIR"

if [[ -n "$VERSION_OVERRIDE" ]]; then
  version="$VERSION_OVERRIDE"
else
  if [[ ! -f VERSION ]]; then
    echo "VERSION file not found" >&2
    exit 1
  fi
  version="$(tr -d '[:space:]' < VERSION)"
fi

tag="v$version"

git rev-parse --verify "refs/tags/$tag^{commit}" >/dev/null

remote_tag_count="$(git ls-remote --tags origin "refs/tags/$tag" "refs/tags/$tag^{}" | wc -l | tr -d '[:space:]')"
if [[ "$remote_tag_count" -lt 1 ]]; then
  echo "Remote tag missing: $tag" >&2
  exit 1
fi

git fetch origin main >/dev/null
tag_commit="$(git rev-list -n 1 "$tag")"
if ! git branch -r --contains "$tag_commit" | grep -q "origin/main"; then
  echo "Tag commit is not reachable from origin/main: $tag" >&2
  exit 1
fi

current_branch="$(git branch --show-current)"
if [[ -n "$current_branch" ]]; then
  case "$current_branch" in
    main|release/*|hotfix/*)
      ;;
    *)
      echo "Invalid publish branch context: $current_branch" >&2
      exit 1
      ;;
  esac
fi

echo "Publish preflight passed for tag: $tag"
