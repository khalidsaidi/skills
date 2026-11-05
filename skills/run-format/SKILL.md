---
name: run-format
description: Run Prettier write if configured; otherwise print instructions
version: "1.1.0"
tags: [format, prettier]
kind: automation
risk: low
capabilities:
  shell: true
  fs_write: true
scripts:
  check: scripts/check.sh
  run: scripts/run.sh
---

# run-format

Runs Prettier on the project. If it isn't installed, prints setup instructions and fails.
