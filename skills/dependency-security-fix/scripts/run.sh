#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/check.sh"
if [[ -f pnpm-lock.yaml ]]; then pm=pnpm; else pm=npm; fi

backup=$(mktemp -d)
trap 'rm -f "$backup"/*; rmdir "$backup"' EXIT
files=(package.json pnpm-lock.yaml package-lock.json)
for f in "${files[@]}"; do
  if [[ -f "$f" ]]; then cp "$f" "$backup/$f"; fi
done

revert() {
  for f in "${files[@]}"; do
    if [[ -f "$backup/$f" ]]; then cp "$backup/$f" "$f"; fi
  done
  "$pm" install || echo "Restored package files, but reinstalling failed. Run $pm install." >&2
}

fix_status=0
"$pm" audit fix || fix_status=$?
if [[ "$pm" == pnpm ]] && ! pnpm install; then
  revert
  echo "dependency-security-fix: install failed after the fix; changes were reverted." >&2
  exit 1
fi

if ! "$pm" test; then
  revert
  echo "dependency-security-fix: tests failed after the fix; changes were reverted." >&2
  exit 1
fi

if [[ "$fix_status" -ne 0 ]]; then
  echo "dependency-security-fix: tests pass and any changes were kept, but audit fix exited with $fix_status. Vulnerabilities may remain; run $pm audit." >&2
  exit 1
fi
echo "Audit fix applied and tests pass."
