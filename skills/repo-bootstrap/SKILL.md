---
name: repo-bootstrap
description: Add ESLint, Prettier, Husky, lint-staged and basic config; commits on new branch
version: "1.1.0"
tags: [tooling, ci, quality]
kind: automation
risk: moderate
capabilities:
  shell: true
  network: true
  fs_read: true
  fs_write: true
scripts:
  check: scripts/check.sh
  run: scripts/run.sh
---

# repo-bootstrap

## When to use

Use when you want to standardize a new or existing repo with lint and format tooling.

## What it will do

- Adds ESLint, Prettier, Husky, lint-staged
- Adds basic configs, keeping any you already have
- Creates branch `skill/repo-bootstrap/<date>` and commits only the files it touched (no push)

## Safety

- Never pushes to remotes.
- Creates a new branch; does not modify main directly.
- Stops if you have uncommitted changes.
