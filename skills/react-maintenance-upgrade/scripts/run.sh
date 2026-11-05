#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/check.sh"
if [[ -f pnpm-lock.yaml ]]; then pm=pnpm; elif [[ -f yarn.lock ]]; then pm=yarn; else pm=npm; fi

script_of() {
  node -p 'JSON.parse(require("fs").readFileSync("package.json","utf8")).scripts?.[process.argv[1]] ?? ""' "$1"
}
packages=(react)
if [[ -n "$(node -p 'const p=JSON.parse(require("fs").readFileSync("package.json","utf8"));(p.dependencies?.["react-dom"]||p.devDependencies?.["react-dom"])??""')" ]]; then
  packages+=(react-dom)
fi

backup=$(mktemp -d)
trap 'rm -f "$backup"/*; rmdir "$backup"' EXIT
files=(package.json pnpm-lock.yaml package-lock.json yarn.lock)
for f in "${files[@]}"; do
  if [[ -f "$f" ]]; then cp "$f" "$backup/$f"; fi
done

revert_and_exit() {
  for f in "${files[@]}"; do
    if [[ -f "$backup/$f" ]]; then cp "$backup/$f" "$f"; fi
  done
  "$pm" install || echo "Restored package files, but reinstalling failed. Run $pm install." >&2
  echo "react-maintenance-upgrade: $1; the upgrade was reverted." >&2
  exit 1
}

if [[ "$pm" == yarn ]]; then
  yarn upgrade "${packages[@]}" || revert_and_exit "the update failed"
else
  "$pm" update "${packages[@]}" || revert_and_exit "the update failed"
fi

if [[ -n "$(script_of build)" ]]; then
  "$pm" run build || revert_and_exit "the build failed"
fi
test_script=$(script_of test)
if [[ -n "$test_script" && "$test_script" != *"no test specified"* ]]; then
  "$pm" test || revert_and_exit "tests failed"
fi
echo "React updated within your version ranges; checks pass."
