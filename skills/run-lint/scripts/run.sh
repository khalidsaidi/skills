#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/check.sh"
if [[ -f pnpm-lock.yaml ]]; then pm=pnpm; elif [[ -f yarn.lock ]]; then pm=yarn; else pm=npm; fi
exec "$pm" run lint
