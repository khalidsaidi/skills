---
name: run-tests
description: Run test script or detect vitest/jest
version: "1.1.0"
tags: [test, vitest, jest]
kind: automation
risk: low
capabilities:
  shell: true
scripts:
  check: scripts/check.sh
  run: scripts/run.sh
---

# run-tests

Runs the project's test script, or local vitest or jest. Fails if there are no tests to run.
