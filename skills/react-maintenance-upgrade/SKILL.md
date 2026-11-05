---
name: react-maintenance-upgrade
description: Update react and react-dom within your version ranges; build and test; revert on failure
version: "1.1.0"
tags: [react, upgrade]
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

# react-maintenance-upgrade

Updates React and React DOM within the version ranges in package.json. Runs build and tests, and reverts if either fails. Needs at least one of those scripts.
