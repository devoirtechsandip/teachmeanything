# ADR 0007: Sequenced Commit Git Lifecycle & Persistent Triage Audit History

- **Status**: Accepted (Amends and supersedes parts of ADR 0005)
- **Date**: 2026-10-29
- **Decision Makers**: User, Antigravity Agent

---

## Context
In our initial operational design ([ADR 0005](file:///workspaces/teachmeanything/docs/adr/0005-operational-lifecycle-and-circuit-breaker.md)), the `.triage/` workspace was treated as an ephemeral, unversioned scratchpad ignored by git and deleted post-fix, and PR creation paused for a CLI prompt before pushing.

During our real-world resolution of the Git snapshot visualization defect ([PR #1](https://github.com/devoirtechsandip/teachmeanything/pull/1)), capturing triage artifacts directly in sequenced git commits on the fix branch proved vastly superior for transparency, reproducibility, code review clarity, and institutional knowledge retention.

---

## Decision

### 1. Early Branch Creation (Post-Triage)
- Coordinator creates and checks out the dedicated topic branch `fix/<issue-id>-<slug>` immediately upon completing Phase 1 (`bug-triage`), before QA begins writing the reproduction harness.
- If the bug is proven irreproducible within the 3-attempt budget, Coordinator switches back to `main` and deletes the local topic branch (`git checkout main && git branch -D fix/<issue-id>-<slug>`), preventing branch clutter.

### 2. The 3-Commit Gate Standard
Every bug fix branch must contain exactly three sequenced, atomic conventional commits:
1. **Commit 1 (Red Gate / QA)**: `test(<subsystem>): reproduce <issue-id> failure`
   - Stages: `.triage/<issue-id>/triage-brief.md`, `.triage/<issue-id>/reproduce.*`, `.triage/<issue-id>/reproduction-report.md`.
   - Invariant: Must capture the deterministic failing state before application code is modified.
2. **Commit 2 (Fix & RCA / Developer)**: `fix(<subsystem>): resolve <root-cause> in <components>`
   - Stages: Application/production code diff + `.triage/<issue-id>/rca.md`.
   - Invariant: Minimal surgical diff that resolves the root cause.
3. **Commit 3 (Green Gate & Security / QA & Security)**: `docs(<subsystem>): record QA verification and security audit`
   - Stages: `.triage/<issue-id>/qa-report.md` + `.triage/<issue-id>/security-audit.md`.
   - Invariant: Proves reproduction turns Green with zero regressions, and Security Agent approves threat posture.

### 3. Persistent Triage Artifacts
- The `.triage/<issue-id>/` directory is **tracked in version control** and merged into `main`.
- `.gitignore` must **not** ignore `.triage/`.
- Reproduction scripts remain permanently available for future regression testing or postmortem analysis.

### 4. Autonomous PR Open for Human Review
- Once the 3 sequenced commits are sealed and all gates are Green, the Coordinator immediately executes `git push -u origin fix/<issue-id>-<slug>` and opens a Pull Request via `gh pr create`.
- The PR description includes the full commit breakdown, reproduction evidence, and verification matrix table.
- The human acts as the final gatekeeper on GitHub prior to merging.

---

## Consequences

### Positive
- Every stage of defect resolution is immutably documented in git history.
- Pull Requests contain clean, logical, reviewable commit histories that any engineer or auditor can inspect.
- Reproduction scripts persist in the repository, making historical defects testable indefinitely.
- Seamless developer velocity: the agent team completes the entire lifecycle and delivers a ready-to-merge PR link.

### Negative / Trade-offs
- Repository storage increases slightly due to committed `.triage/` test scripts and markdown records.
- Branches are created in git immediately, requiring explicit cleanup if triage determines an issue is invalid.
