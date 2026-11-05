#!/usr/bin/env bash
set -euo pipefail
if [[ ! -x node_modules/.bin/prettier ]]; then
  echo "run-format: Prettier isn't installed in this project; nothing was formatted." >&2
  echo "To set it up, add prettier as a dev dependency, then run this skill again." >&2
  exit 1
fi
