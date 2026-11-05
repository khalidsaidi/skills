#!/usr/bin/env bash
set -euo pipefail
if [[ ! -f package.json ]]; then
  echo "run-lint: no package.json in $PWD; nothing was run." >&2
  exit 1
fi
script=$(node -p 'JSON.parse(require("fs").readFileSync("package.json","utf8")).scripts?.lint ?? ""')
if [[ -z "$script" ]]; then
  echo "run-lint: package.json has no \"lint\" script; nothing was run." >&2
  exit 1
fi
