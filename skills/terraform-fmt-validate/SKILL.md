---
name: terraform-fmt-validate
description: Run terraform fmt -recursive and terraform validate; no apply
version: "1.1.0"
tags: [terraform, infra]
kind: automation
risk: low
capabilities:
  shell: true
  fs_write: true
scripts:
  check: scripts/check.sh
  run: scripts/run.sh
---

# terraform-fmt-validate

Runs terraform fmt, which rewrites files, then validate. Never applies.
