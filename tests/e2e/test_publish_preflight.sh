#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

tmp_repo="$(mktemp -d)"
bare_remote="$(mktemp -d)"
trap 'rm -rf "$tmp_repo" "$bare_remote"' EXIT

git init "$tmp_repo" >/dev/null
git init --bare "$bare_remote/origin.git" >/dev/null

pushd "$tmp_repo" >/dev/null

git checkout -b main >/dev/null
git config user.email "ci@example.com"
git config user.name "CI"

echo "0.1.0" > VERSION
mkdir -p Formula
cat > Formula/test-tool.rb <<'EOF'
class TestTool < Formula
  desc "Test tool"
  homepage "https://example.com/test-tool"
  version "0.1.0"
  url "https://example.com/downloads/test-tool-0.1.0.tar.gz"
  sha256 "cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc"
end
EOF

echo "# Release 0.1.0" > RELEASE_NOTES.md
git add .
git commit -m "chore: seed repo" >/dev/null
git remote add origin "$bare_remote/origin.git"
git push -u origin main >/dev/null

git tag v0.1.0
git push origin v0.1.0 >/dev/null

if ! bash "$ROOT_DIR/scripts/publish_preflight.sh" --repo "$tmp_repo" --version 0.1.0 >/dev/null; then
  echo "FAIL: publish_preflight should pass for valid release context"
  exit 1
fi

popd >/dev/null

echo "PASS: e2e publish preflight tests"
