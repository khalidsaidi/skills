#!/usr/bin/env bash
set -euo pipefail
command -v terraform >/dev/null || { echo "terraform-fmt-validate: terraform not installed." >&2; exit 1; }
if ! compgen -G '*.tf' >/dev/null; then
  echo "terraform-fmt-validate: no .tf files in $PWD; nothing was checked." >&2
  exit 1
fi
