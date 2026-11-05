---
name: run-typecheck
description: Run tsc --noEmit if tsconfig present
version: "1.1.0"
tags: [typescript, typecheck]
kind: automation
risk: low
capabilities:
  shell: true
scripts:
  check: scripts/check.sh
  run: scripts/run.sh
---

# run-typecheck

Runs TypeScript type check (tsc --noEmit). Fails if tsconfig.json or a local TypeScript install is missing.
