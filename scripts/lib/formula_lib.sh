#!/usr/bin/env bash
set -euo pipefail

extract_formula_field() {
  local formula_file="$1"
  local field="$2"
  awk -v f="$field" '
    $1 == f {
      match($0, /"[^"]+"/)
      if (RSTART > 0) {
        print substr($0, RSTART + 1, RLENGTH - 2)
        exit 0
      }
    }
  ' "$formula_file"
}

formula_url_contains_version() {
  local formula_file="$1"
  local version
  local url

  version="$(extract_formula_field "$formula_file" version || true)"
  url="$(extract_formula_field "$formula_file" url || true)"

  [[ -n "$version" && -n "$url" && "$url" == *"$version"* ]]
}
