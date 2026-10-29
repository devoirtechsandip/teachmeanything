---
name: pr-creation
description: Seal Commit 3 (verification & security audit), push branch, and open Pull Request against main for human review.
argument-hint: "<issue-id> [target-branch (default: main)]"
disable-model-invocation: true
origin: "workflow/triage-team (MIT)"
---

# PR Creation

Seal the final verification commit, push the topic branch to `origin`, and open a comprehensive Pull Request against `main` for human review and sign-off.

## Responsibilities & Constraints
- **Role**: Executed by the **Coordinator Agent**.
- **Prerequisites**:
  1. Commit 1 (`test: reproduce ...`) sealed by QA.
  2. Commit 2 (`fix: resolve ...`) sealed by Developer.
  3. QA Agent confirms Red ➔ Green verification with zero regressions across repository test suite.
  4. Security Agent approves threat posture with zero vulnerabilities or leaks.

---

## The 4-Step PR Workflow

### Step 1: Seal Commit 3 (Verification & Security Audit)
Per [ADR 0007](file:///workspaces/teachmeanything/docs/adr/0007-sequenced-commit-git-lifecycle-and-persistent-triage.md), commit the final verification and security clearance records:
```bash
git add .triage/<issue-id>/qa-report.md .triage/<issue-id>/security-audit.md
git commit -m "docs(<subsystem>): record QA green verification and pre-commit security audit"
```

### Step 2: Validate 3-Commit History
Verify that `git log --oneline -3` matches the canonical 3-Commit Gate Standard:
```text
[Commit 3] docs(<subsystem>): record QA green verification and pre-commit security audit
[Commit 2] fix(<subsystem>): resolve <root-cause> in <components>
[Commit 1] test(<subsystem>): reproduce <issue-id> failure (Red Gate)
```

### Step 3: Remote Push
Push the isolated branch to the remote repository:
```bash
git push -u origin fix/<issue-id>-<slug>
```

### Step 4: Autonomous Pull Request Creation for Human Review
Synthesize the comprehensive PR description and open the Pull Request against `main`:
```bash
gh pr create --base main --head fix/<issue-id>-<slug> \
  --title "fix(<subsystem>): <concise fix description>" \
  --body "## Summary

[Summary of the bug resolved]

All diagnostic, reproduction, root-cause, verification, and security artifacts produced by our multi-agent triage team are included directly in this branch under \`.triage/<issue-id>/\`.

---

## Sequenced Commit History
1. \`test(<subsystem>): reproduce <issue-id> failure\` — Triage brief + failing reproduction script + Red Gate report.
2. \`fix(<subsystem>): resolve <root-cause> in <components>\` — Minimal surgical code fix + Developer Root Cause Analysis (\`rca.md\`).
3. \`docs(<subsystem>): record QA verification and pre-commit security audit\` — QA Green verification report + Security Agent clearance.

---

## Agent Verification & Clearance Matrix

| Gate | Agent Role | Artifact | Status |
| :--- | :--- | :--- | :--- |
| **Intake & Triage** | Coordinator | \`triage-brief.md\` | Verified |
| **Red Gate Reproduction** | QA Agent | \`reproduction-report.md\` | RED (Verified Failing) |
| **Root Cause Analysis** | Developer Agent | \`rca.md\` | Isolated |
| **Green Verification** | QA Agent | \`qa-report.md\` | GREEN (Passed, Zero Regressions) |
| **Two-Axis Review** | QA Agent | \`qa-report.md\` | APPROVED |
| **Security Audit** | Security Agent | \`security-audit.md\` | APPROVED |
"
```

Notify the user in chat with the direct clickable PR URL:
*"Pull Request created and ready for your review and merge sign-off: [PR URL]"*
