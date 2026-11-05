#!/usr/bin/env bash
set -euo pipefail
echo "=== Node Doctor ==="
echo "Node: $(node -v 2>/dev/null || echo 'not found')"
echo "pnpm: $(pnpm -v 2>/dev/null || echo 'not found')"
echo "npm: $(npm -v 2>/dev/null || echo 'not found')"
echo "yarn: $(yarn -v 2>/dev/null || echo 'not found')"
echo "Git: $(git --version 2>/dev/null || echo 'not found')"

if [[ -f package.json ]]; then pkg=found; else pkg="not found"; fi
echo "package.json: $pkg"

lockfiles=()
for f in pnpm-lock.yaml package-lock.json yarn.lock; do
  if [[ -f "$f" ]]; then lockfiles+=("$f"); fi
done
echo "Lockfile: ${lockfiles[*]:-none}"

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then repo=yes; else repo=no; fi
echo "Git repository: $repo"

echo "Recommendations:"
recommendations=0
if ! command -v node >/dev/null; then
  echo "  - Install Node.js"
  recommendations=1
fi
if [[ -f package.json && ${#lockfiles[@]} -eq 0 ]]; then
  echo "  - Run your package manager's install to create a lockfile"
  recommendations=1
fi
if [[ ${#lockfiles[@]} -gt 1 ]]; then
  echo "  - Keep only one lockfile: ${lockfiles[*]}"
  recommendations=1
fi
if [[ $recommendations -eq 0 ]]; then echo "  - None"; fi
