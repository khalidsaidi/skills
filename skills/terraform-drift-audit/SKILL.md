---
name: terraform-drift-audit
description: terraform init + plan; report drift; no apply
version: "1.1.0"
tags: [terraform, drift, infra]
kind: automation
risk: low
capabilities:
  shell: true
  fs_write: true
  network: true
scripts:
  check: scripts/check.sh
  run: scripts/run.sh
---

# terraform-drift-audit

Runs terraform init and plan, then says whether there is drift. Init writes to `.terraform`. Never applies.
