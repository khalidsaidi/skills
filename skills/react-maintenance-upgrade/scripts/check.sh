#!/usr/bin/env bash
set -euo pipefail
if [[ ! -f package.json ]]; then
  echo "react-maintenance-upgrade: no package.json in $PWD; nothing was changed." >&2
  exit 1
fi
node -e '
const pkg = JSON.parse(require("fs").readFileSync("package.json", "utf8"));
const deps = { ...pkg.dependencies, ...pkg.devDependencies };
if (!deps.react) {
  console.error("react-maintenance-upgrade: React is not a dependency of this project; nothing was changed.");
  process.exit(1);
}
const scripts = pkg.scripts || {};
const hasTest = scripts.test && !scripts.test.includes("no test specified");
if (!scripts.build && !hasTest) {
  console.error("react-maintenance-upgrade: no build or test script, so an upgrade could not be verified; nothing was changed.");
  process.exit(1);
}
'
