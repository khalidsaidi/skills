# Skills

25 agent skills for everyday development: code review, debugging, testing, Git, releases, React and Terraform.

Each skill is a folder in [`skills/`](skills) with a `SKILL.md` file and, for automation skills, a `scripts/` folder.

## Install

With the [`skills` CLI](https://skills.sh):

```bash
npx skills add khalidsaidi/skills
```

In Claude Code:

```
/plugin marketplace add khalidsaidi/skills
/plugin install knowledge-skills@khalidsaidi-skills
/plugin install automation-skills@khalidsaidi-skills
```

With [SkillRunner](https://github.com/khalidsaidi/skillrunner):

```bash
npm i -g @khalidsaidi/skillrunner
skill install khalidsaidi/skills/skills/node-doctor
skill run node-doctor
```

## Knowledge skills

Guidance only. These don't include scripts.

| Skill | Covers |
| --- | --- |
| [`code-review-checklist`](skills/code-review-checklist) | What to check in a code review |
| [`debugging-playbook`](skills/debugging-playbook) | A step-by-step approach to debugging |
| [`deployment-checklist`](skills/deployment-checklist) | What to check before a release |
| [`docs-styleguide`](skills/docs-styleguide) | Documentation style and structure |
| [`git-commit-style`](skills/git-commit-style) | Conventional commit messages |
| [`pr-description-style`](skills/pr-description-style) | Pull request descriptions |
| [`react-patterns`](skills/react-patterns) | React best practices |
| [`release-notes-style`](skills/release-notes-style) | Writing release notes |
| [`security-hygiene`](skills/security-hygiene) | Security practices for development |
| [`terraform-structure`](skills/terraform-structure) | Terraform project layout |
| [`testing-playbook`](skills/testing-playbook) | Testing strategy |

## Automation skills

These include `check.sh` and `run.sh` scripts, which run in your project.

If something a skill needs is missing, such as a test script or a lockfile, it says so and fails. Skills that change your project say so in their `SKILL.md`, and the two upgrade skills revert their changes if your checks fail.

| Skill | Does |
| --- | --- |
| [`changelog-from-commits`](skills/changelog-from-commits) | Lists commits since the last tag |
| [`dependency-audit-report`](skills/dependency-audit-report) | Runs `pnpm audit` or `npm audit` |
| [`dependency-security-fix`](skills/dependency-security-fix) | Runs `audit fix`, then your tests, and reverts if they fail |
| [`git-status-report`](skills/git-status-report) | Prints status, changed files and a suggested branch name |
| [`node-doctor`](skills/node-doctor) | Prints Node, package manager and Git versions |
| [`react-maintenance-upgrade`](skills/react-maintenance-upgrade) | Updates React, runs build and tests, and reverts if they fail |
| [`repo-bootstrap`](skills/repo-bootstrap) | Adds ESLint, Prettier, Husky and lint-staged on a new branch |
| [`run-build`](skills/run-build) | Runs the build script |
| [`run-format`](skills/run-format) | Runs Prettier |
| [`run-lint`](skills/run-lint) | Runs the lint script |
| [`run-tests`](skills/run-tests) | Runs the test script, or Vitest or Jest |
| [`run-typecheck`](skills/run-typecheck) | Runs `tsc --noEmit` |
| [`terraform-drift-audit`](skills/terraform-drift-audit) | Runs `terraform init` and `plan`, never `apply` |
| [`terraform-fmt-validate`](skills/terraform-fmt-validate) | Runs `terraform fmt` and `validate`, never `apply` |

## Packs

[`packs/`](packs) groups skills for SkillRunner: `starter`, `react` and `terraform`.

## License

[MIT](LICENSE)
