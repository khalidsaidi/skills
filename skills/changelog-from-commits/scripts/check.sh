#!/usr/bin/env bash
set -euo pipefail
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "changelog-from-commits: $PWD isn't inside a Git repository." >&2
  exit 1
fi
if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
  echo "changelog-from-commits: this repository has no commits yet." >&2
  exit 1
fi
