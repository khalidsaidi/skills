#!/usr/bin/env bash
set -euo pipefail
if [[ ! -f package.json ]]; then
  echo "run-tests: no package.json in $PWD; no tests were run." >&2
  exit 1
fi
script=$(node -p 'JSON.parse(require("fs").readFileSync("package.json","utf8")).scripts?.test ?? ""')
if [[ -z "$script" || "$script" == *"no test specified"* ]]; then
  if [[ ! -x node_modules/.bin/vitest && ! -x node_modules/.bin/jest ]]; then
    echo "run-tests: no test script and no local vitest or jest; no tests were run." >&2
    exit 1
  fi
fi
