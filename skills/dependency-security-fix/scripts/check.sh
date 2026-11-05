#!/usr/bin/env bash
set -euo pipefail
if [[ ! -f package.json ]]; then
  echo "dependency-security-fix: no package.json in $PWD; nothing was changed." >&2
  exit 1
fi
if [[ ! -f pnpm-lock.yaml && ! -f package-lock.json ]]; then
  echo "dependency-security-fix: needs pnpm-lock.yaml or package-lock.json; nothing was changed." >&2
  exit 1
fi
script=$(node -p 'JSON.parse(require("fs").readFileSync("package.json","utf8")).scripts?.test ?? ""')
if [[ -z "$script" || "$script" == *"no test specified"* ]]; then
  echo "dependency-security-fix: no test script, so a fix couldn't be verified; nothing was changed." >&2
  exit 1
fi
