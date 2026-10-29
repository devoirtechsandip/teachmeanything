---
name: pr-creation
description: Atomic branch creation, conventional commit preparation, and gated Pull Request synthesis with evidence verification.
argument-hint: "<issue-id> [target-branch (default: main)]"
disable-model-invocation: true
origin: "workflow/triage-team (MIT)"
---

# PR Creation

Prepare clean, isolated git branches, author atomic conventional commits, and draft Pull Requests with comprehensive verification evidence.

## Responsibilities & Constraints
- **Role**: Executed by the **Coordinator Agent**.
- **Hard Gate**: PR creation may **only** be triggered once:
  1. QA Agent confirms Red ➔ Green verification and clean test regression suite.
  2. QA Agent signs off on Two-Axis Code Review (Standards & Spec).
  3. Security Agent signs off on Security Audit.
  4. Human explicitly approves the final diff and PR summary.

---

## The 5-Step PR Workflow

### Step 1: Branch Isolation
Create and switch to a dedicated topic branch:
```bash
git checkout -b fix/<issue-id>-<slug>
```

### Step 2: Selective Staging & Hygiene
Stage only the files related to the bug fix and regression test.
- **Strict Exclusion**: Never stage ephemeral triage artifacts (`.triage/`), operating system artifacts (`.DS_Store`), or temporary logs.
```bash
git add <path/to/reproduction_test> <path/to/production_files>
git status
```

### Step 3: Conventional Commit Construction
Author an atomic, informative commit message following conventional standards:
```text
fix(<subsystem>): <imperative summary of the resolution>

Closes #<issue-id>

### Root Cause
<Summary of underlying bug isolated by Developer RCA>

### Verification
- Reproduction: <Red command verified by QA>
- Verification: <Green transition verified by QA>
- Regression: Full test suite passing
- Security: Passed pre-commit security audit
```

### Step 4: Gated Human Sign-Off
Present the complete resolution summary to the user:
- Show changed files and `git diff --stat`.
- Link `.triage/<issue-id>/` artifacts (RCA, QA report, Security audit).
- Prompt the user: *"All verification and security gates passed. Ready to push branch and open Pull Request?"*

### Step 5: Remote Push & PR Synthesis
Upon explicit user confirmation:
```bash
git push -u origin fix/<issue-id>-<slug>
gh pr create --title "fix(<subsystem>): <summary>" --body-file .triage/<issue-id>/pr-body.md
```
Clean up ephemeral triage artifacts upon successful PR creation:
```bash
rm -rf .triage/<issue-id>
```
