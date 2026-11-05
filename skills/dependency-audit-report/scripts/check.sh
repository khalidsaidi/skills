#!/usr/bin/env bash
set -euo pipefail
if [[ ! -f package.json ]]; then
  echo "dependency-audit-report: no package.json in $PWD; nothing was audited." >&2
  exit 1
fi
if [[ ! -f pnpm-lock.yaml && ! -f package-lock.json && ! -f yarn.lock ]]; then
  echo "dependency-audit-report: no lockfile; run your package manager's install first. Nothing was audited." >&2
  exit 1
fi
