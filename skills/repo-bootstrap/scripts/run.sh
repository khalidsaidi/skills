#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/check.sh"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git init
fi
branch="skill/repo-bootstrap/$(date +%Y-%m-%d)"
git switch -c "$branch"

if [[ ! -f package.json ]]; then
  npm init -y
fi
if [[ -f pnpm-lock.yaml ]]; then pm=pnpm; elif [[ -f yarn.lock ]]; then pm=yarn; else pm=npm; fi

packages=(eslint @eslint/js prettier husky lint-staged)
case "$pm" in
  npm) npm install --save-dev "${packages[@]}" ;;
  *) "$pm" add -D "${packages[@]}" ;;
esac

# Only write what's missing, and commit only what this skill touched.
created=(package.json)
for f in pnpm-lock.yaml package-lock.json yarn.lock; do
  if [[ -f "$f" ]]; then created+=("$f"); fi
done

if ! compgen -G 'eslint.config.*' >/dev/null && ! compgen -G '.eslintrc*' >/dev/null; then
  cat > eslint.config.mjs <<'CONFIG'
import js from "@eslint/js";

export default [js.configs.recommended];
CONFIG
  created+=(eslint.config.mjs)
else
  echo "Keeping existing ESLint config."
fi

if ! compgen -G '.prettierrc*' >/dev/null && ! compgen -G 'prettier.config.*' >/dev/null; then
  echo '{}' > .prettierrc
  created+=(.prettierrc)
else
  echo "Keeping existing Prettier config."
fi

if [[ ! -f .gitignore ]]; then
  echo 'node_modules/' > .gitignore
  created+=(.gitignore)
elif ! grep -qE '^/?node_modules/?$' .gitignore; then
  echo 'node_modules/' >> .gitignore
  created+=(.gitignore)
fi

node -e '
const fs = require("fs");
const pkg = JSON.parse(fs.readFileSync("package.json", "utf8"));
pkg.scripts = pkg.scripts || {};
pkg.scripts.lint = pkg.scripts.lint || "eslint .";
pkg.scripts.format = pkg.scripts.format || "prettier --write .";
pkg.scripts.prepare = pkg.scripts.prepare || "husky";
pkg["lint-staged"] = pkg["lint-staged"] || { "*": "prettier --write --ignore-unknown" };
fs.writeFileSync("package.json", JSON.stringify(pkg, null, 2) + "\n");
'

node_modules/.bin/husky
if [[ ! -f .husky/pre-commit ]]; then
  mkdir -p .husky
  echo 'node_modules/.bin/lint-staged' > .husky/pre-commit
  created+=(.husky/pre-commit)
else
  echo "Keeping existing pre-commit hook."
fi


git add -- "${created[@]}"
git commit --no-verify -m "chore: add lint, format and hooks"
echo "Committed to $branch. Nothing was pushed."
