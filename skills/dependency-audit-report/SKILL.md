---
name: dependency-audit-report
description: Run pnpm, npm or yarn audit and report the results (no repo edits)
version: "1.1.0"
tags: [security, audit, dependencies]
kind: automation
risk: low
capabilities:
  shell: true
  network: true
scripts:
  check: scripts/check.sh
  run: scripts/run.sh
---

# dependency-audit-report

Runs your package manager's audit. Fails if the audit finds vulnerabilities. No changes to the repo.
