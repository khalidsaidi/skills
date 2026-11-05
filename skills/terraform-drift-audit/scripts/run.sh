#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/check.sh"
terraform init -input=false
status=0
terraform plan -no-color -input=false -detailed-exitcode || status=$?
case "$status" in
  0) echo "No drift: infrastructure matches the configuration." ;;
  2) echo "Drift detected: the plan above has changes. Nothing was applied." ;;
  *) echo "terraform-drift-audit: terraform plan failed." >&2; exit "$status" ;;
esac
