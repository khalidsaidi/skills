#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/check.sh"
script=$(node -p 'JSON.parse(require("fs").readFileSync("package.json","utf8")).scripts?.test ?? ""')
if [[ -n "$script" && "$script" != *"no test specified"* ]]; then
  if [[ -f pnpm-lock.yaml ]]; then pm=pnpm; elif [[ -f yarn.lock ]]; then pm=yarn; else pm=npm; fi
  exec "$pm" test
fi
if [[ -x node_modules/.bin/vitest ]]; then
  exec node_modules/.bin/vitest run
fi
exec node_modules/.bin/jest
