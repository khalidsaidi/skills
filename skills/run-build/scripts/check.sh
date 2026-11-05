#!/usr/bin/env bash
set -euo pipefail
if [[ ! -f package.json ]]; then
  echo "run-build: no package.json in $PWD; nothing was run." >&2
  exit 1
fi
script=$(node -p 'JSON.parse(require("fs").readFileSync("package.json","utf8")).scripts?.build ?? ""')
if [[ -z "$script" ]]; then
  echo "run-build: package.json has no \"build\" script; nothing was run." >&2
  exit 1
fi
