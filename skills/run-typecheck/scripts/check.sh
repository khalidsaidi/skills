#!/usr/bin/env bash
set -euo pipefail
if [[ ! -f tsconfig.json ]]; then
  echo "run-typecheck: no tsconfig.json in $PWD; nothing was checked." >&2
  exit 1
fi
if [[ ! -x node_modules/.bin/tsc ]]; then
  echo "run-typecheck: TypeScript isn't installed in this project; nothing was checked." >&2
  exit 1
fi
