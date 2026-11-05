#!/usr/bin/env bash
set -euo pipefail
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "git-status-report: $PWD isn't inside a Git repository." >&2
  exit 1
fi
