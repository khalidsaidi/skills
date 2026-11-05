#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/check.sh"
terraform fmt -recursive
terraform init -backend=false -input=false
terraform validate
