---
name: triage-orchestrator
description: Master orchestrator executing the autonomous bug triage, reproduction, diagnosis, verification, security audit, sequenced commits, and PR workflow.
argument-hint: "<issue-description, issue-number, or issue-url>"
disable-model-invocation: true
origin: "workflow/triage-team (MIT)"
---

# Triage Orchestrator

Master multi-agent orchestration skill coordinating the **Coordinator**, **Developer**, **QA**, and **Security** agents to ingest, reproduce, fix, verify, and resolve software bugs through an immutable sequenced commit lifecycle.

```text
               [User Submits Bug]
                       │
                       ▼
            [Phase 1: Bug Triage] ──────── (Missing Details) ──► [Halt & Request Clarification]
                       │
                       ▼
            (Create Topic Branch: fix/<issue-id>-<slug>)
                       │
                       ▼
           [Phase 2: QA Red Gate] ──────── (Fails > 3x) ────────► [Delete Branch & Halt]
                       │
                       ▼
            (Commit 1: test(<scope>): reproduce <issue-id> failure)
                       │
                       ▼
         ┌──► [Phase 3: Developer RCA & Fix]
         │             │
         │             ▼
         │    [Phase 4: QA Verification & Code Review] ──► (Rejected) ──┐
         │             │ (Passed)                                       │
         │             ▼                                                ▼
         │    [Phase 5: Security Review Audit] ──────────► (Vulnerable) ─┘
         │             │ (Approved)                       (Retry Budget < 3)
         │             ▼
         └─── (Iterative Fix Cycle)
                       │ (All Passed)
                       ▼
            (Commit 2: fix(<scope>): resolve <root-cause> + rca.md)
                       │
                       ▼
            (Commit 3: docs(<scope>): record QA verification & security audit)
                       │
                       ▼
            [Phase 6: Push Branch & Open PR for Human Review]
                       │
                       ▼
            [PR Ready on GitHub]
```

---

## The 6 Orchestration Phases

### Phase 1: Ingestion, Triage & Branch Cut (Coordinator)
1. Invoke `/bug-triage` with the input defect report.
2. Sanitize sensitive data and validate reproduction requirements.
3. Scaffold `.triage/<issue-id>/` and output `triage-brief.md`.
4. If essential parameters are missing, halt immediately and ask user for clarification.
5. Create and switch to isolated topic branch:
   ```bash
   git checkout -b fix/<issue-id>-<slug>
   ```

### Phase 2: Deterministic Reproduction Gate (QA Agent)
1. Delegate to QA Agent running `/test-generation`.
2. Construct a failing reproduction test or script (`reproduce.*`).
3. **Hard Gate**: QA must verify that the command turns **Red**.
4. Retry budget: Max 3 reproduction attempts. If QA cannot reproduce, delete local topic branch (`git checkout main && git branch -D fix/<issue-id>-<slug>`) and notify user.
5. Once verified Red, seal **Commit 1**:
   ```bash
   git add .triage/<issue-id>/triage-brief.md .triage/<issue-id>/reproduce.* .triage/<issue-id>/reproduction-report.md
   git commit -m "test(<subsystem>): reproduce <issue-id> failure (Red Gate)"
   ```

### Phase 3: Root Cause Analysis & Fix (Developer Agent)
1. Once Red command is locked, delegate to Developer Agent running `/diagnosing-bugs`.
2. Formulate 3–5 falsifiable hypotheses against the code seam.
3. Instrument minimally, isolate the root cause, and author a minimal surgical fix.
4. Save hypotheses and diagnosis to `.triage/<issue-id>/rca.md`.

### Phase 4: Verification & Two-Axis Code Review (QA Agent)
1. Delegate to QA Agent running `/code-review`.
2. Execute reproduction command: **Must turn Green**.
3. Execute repository full test suite: **Zero regressions permitted**.
4. Evaluate code diff across **Axis A (Standards)** and **Axis B (Spec)**.
5. Save evaluation to `.triage/<issue-id>/qa-report.md`.
6. If failed or regressions occur, return to Phase 3 with targeted feedback (decrement retry budget).

### Phase 5: Security Audit (Security Agent)
1. Delegate to Security Agent running `/security-review`.
2. Scan proposed diff for secret leaks, injection vectors, OWASP vulnerabilities, and unsafe dependencies.
3. Save audit verdict to `.triage/<issue-id>/security-audit.md`.
4. If vulnerabilities are flagged, return to Phase 3 for remediation.

### Iteration & Circuit Breaker Rule
- Developer fix cycles are capped at **3 iterations total**.
- If a fix fails QA verification or Security audit on iteration 3:
  - Coordinator triggers circuit breaker.
  - Executes `git reset` to clean uncommitted changes.
  - Compiles `.triage/<issue-id>/failure-debrief.md`.
  - Halts and presents failure report to the user.

### Phase 6: Sequenced Commits & PR Creation (Coordinator)
1. When all gates pass (QA Green + QA Review + Security Audit):
2. Seal **Commit 2 (Fix & RCA)**:
   ```bash
   git add <modified-application-files> .triage/<issue-id>/rca.md
   git commit -m "fix(<subsystem>): resolve <root-cause> in <components>"
   ```
3. Invoke `/pr-creation` to seal **Commit 3 (Verification & Security)**:
   ```bash
   git add .triage/<issue-id>/qa-report.md .triage/<issue-id>/security-audit.md
   git commit -m "docs(<subsystem>): record QA green verification and pre-commit security audit"
   ```
4. Push branch to remote:
   ```bash
   git push -u origin fix/<issue-id>-<slug>
   ```
5. Open Pull Request via `gh pr create` with verification matrix table.
6. Present the direct PR URL to the user in chat for final human review and merge sign-off.
