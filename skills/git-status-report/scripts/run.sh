#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/check.sh"
echo "=== Git Status ==="
git status -sb
echo ""
echo "Changed files:"
git diff --name-only HEAD 2>/dev/null || git diff --name-only
echo ""
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
echo "Suggested branch: skill/$(date +%Y-%m-%d)/${branch//\//-}"
