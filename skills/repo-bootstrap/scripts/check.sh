#!/usr/bin/env bash
set -euo pipefail
if ! command -v git >/dev/null; then
  echo "repo-bootstrap: git not installed." >&2
  exit 1
fi
if [[ -z "$(git config user.email || true)" || -z "$(git config user.name || true)" ]]; then
  echo "repo-bootstrap: set git user.name and user.email first, so it can commit; nothing was changed." >&2
  exit 1
fi
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if [[ -n "$(git status --porcelain)" ]]; then
    echo "repo-bootstrap: commit or stash your changes first; nothing was changed." >&2
    exit 1
  fi
  branch="skill/repo-bootstrap/$(date +%Y-%m-%d)"
  if git show-ref --verify --quiet "refs/heads/$branch"; then
    echo "repo-bootstrap: branch $branch already exists; nothing was changed." >&2
    exit 1
  fi
fi
