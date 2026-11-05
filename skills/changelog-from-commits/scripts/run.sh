#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/check.sh"
if tag=$(git describe --tags --abbrev=0 2>/dev/null); then
  echo "## Changes since $tag"
  git log "$tag"..HEAD --oneline
else
  echo "## All changes (no tags yet)"
  git log --oneline
fi
