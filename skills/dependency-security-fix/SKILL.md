---
name: dependency-security-fix
description: Apply non-breaking audit fixes; run tests; revert on failure
version: "1.1.0"
tags: [security, dependencies]
kind: automation
risk: moderate
capabilities:
  shell: true
  network: true
  fs_write: true
scripts:
  check: scripts/check.sh
  run: scripts/run.sh
---

# dependency-security-fix

Runs audit fix (non-breaking fixes only), then your tests. Reverts package files if tests fail. Needs a test script and an npm or pnpm lockfile.
