---
name: triage-orchestrator
description: Master orchestrator executing the autonomous bug triage, diagnosis, verification, security audit, and resolution team workflow.
argument-hint: "<issue-description, issue-number, or issue-url>"
disable-model-invocation: true
origin: "workflow/triage-team (MIT)"
---

# Triage Orchestrator

Master multi-agent orchestration skill coordinating the **Coordinator**, **Developer**, **QA**, and **Security** agents to ingest, reproduce, fix, verify, and resolve software bugs.

```text
               [User Submits Bug]
                       │
                       ▼
            [Phase 1: Bug Triage] ──────── (Missing Details) ──► [Halt & Request Clarification]
                       │
                       ▼
           [Phase 2: QA Red Gate] ──────── (Fails > 3x) ────────► [Halt & Escalate to User]
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
            [Phase 6: Gated PR Creation] ──► (Awaits Human Sign-Off) ──► [PR Created]
```

---

## The 6 Orchestration Phases

### Phase 1: Ingestion & Triage (Coordinator)
1. Invoke `/bug-triage` with the input report.
2. Sanitize sensitive data and validate reproduction requirements.
3. Scaffold `.triage/<issue-id>/` and output `triage-brief.md`.
4. If essential parameters are missing, halt immediately and ask the user for clarification.

### Phase 2: Deterministic Reproduction Gate (QA Agent)
1. Delegate to QA Agent running `/test-generation`.
2. Construct a failing reproduction test or script (`reproduce.sh`).
3. **Hard Gate**: QA must verify that the command turns **Red**.
4. Retry budget: Max 3 reproduction attempts. If QA cannot reproduce, halt and notify the user.

### Phase 3: Root Cause Analysis & Fix (Developer Agent)
1. Once Red command is locked, delegate to Developer Agent running `/diagnosing-bugs`.
2. Formulate 3–5 falsifiable hypotheses against the code seam.
3. Instrument minimally, isolate the root cause, and author a minimal surgical fix.
4. Save hypotheses and diagnosis to `.triage/<issue-id>/rca.md`.

### Phase 4: Verification & Two-Axis Code Review (QA Agent)
1. Delegate to QA Agent running `/code-review`.
2. Execute the reproduction command: **Must turn Green**.
3. Execute repository full test suite: **Zero regressions permitted**.
4. Evaluate code diff across **Axis A (Standards)** and **Axis B (Spec)**.
5. Save evaluation to `.triage/<issue-id>/qa-report.md`.
6. If failed or regressions occur, return to Phase 3 with targeted feedback (decrement retry budget).

### Phase 5: Security Audit (Security Agent)
1. Delegate to Security Agent running `/security-review`.
2. Scan the proposed diff for secret leaks, injection vectors, OWASP vulnerabilities, and unsafe dependencies.
3. Save audit verdict to `.triage/<issue-id>/security-audit.md`.
4. If vulnerabilities are flagged, return to Phase 3 for remediation.

### Iteration & Circuit Breaker Rule
- Developer fix cycles are capped at **3 iterations total**.
- If a fix fails QA verification or Security audit on iteration 3:
  - Coordinator triggers the circuit breaker.
  - Executes `git reset` to clean uncommitted changes.
  - Compiles `.triage/<issue-id>/failure-debrief.md`.
  - Halts and presents the failure report to the user.

### Phase 6: Gated PR Creation (Coordinator)
1. When all gates pass (QA Green + QA Review + Security Audit):
2. Invoke `/pr-creation`.
3. Create local branch `fix/<issue-id>-<slug>` and stage validated changes.
4. Present the complete resolution summary and diff to the user in chat.
5. Await explicit human confirmation.
6. Upon approval, execute `git push` and open the Pull Request.
