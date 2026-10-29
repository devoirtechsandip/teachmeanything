---
name: feature-orchestrator
description: Master orchestrator executing the autonomous feature specification, acceptance testing, implementation, verification, security audit, sequenced commits, and PR workflow.
argument-hint: "<feature-request or functionality-goal>"
disable-model-invocation: true
origin: "workflow/feature-team (MIT)"
---

# Feature Orchestrator

Master multi-agent orchestration skill coordinating the **Coordinator**, **Developer**, **QA**, and **Security** agents to specify, acceptance-test, implement, verify, and deliver new features through an immutable 3-commit sequenced lifecycle.

```text
               [User Requests Feature via /feature-orchestrator]
                                      │
                                      ▼
             [Phase 1: Feature Intake & Socratic Grilling] ◄──(Iterate with User)
                                      │
                                      ▼ (User Approves Spec & ADRs)
             (Scaffold Persistent Spec Bundle & Cut Branch: feat/<feature-id>-<slug>)
                                      │
                                      ▼
             [Phase 2: QA Acceptance Red Gate] ──(Failed to generate test > 3x)──► [Halt]
                                      │
                                      ▼
             (Commit 1: test(<scope>): define acceptance test suite for <feature-id>)
                                      │
                                      ▼
          ┌──► [Phase 3: Developer Implementation per Spec]
          │             │
          │             ▼
          │    [Phase 4: QA Green Verification & Two-Axis Review] ──► (Rejected) ──┐
          │             │ (Passed)                                                 │
          │             ▼                                                          │
          │    [Phase 5: Security Pre-Commit Audit] ────────────────► (Vulnerable) ┘
          │             │ (Approved)                                  (Retry Budget < 3)
          │             ▼
          └─── (Iterative Implementation Cycle)
                        │ (All Passed)
                        ▼
             (Commit 2: feat(<scope>): implement <feature-id> per spec)
                        │
                        ▼
             (Commit 3: docs(<scope>): record QA verification & security audit)
                        │
                        ▼
             [Phase 6: Push Branch & Open PR for Human Review]
                        │
                        ▼
             [Feature PR Ready on GitHub]
```

---

## The 6 Orchestration Phases

### Phase 1: Interactive Grilling, Specification & Branch Cut (Coordinator)
1. Run `/feature-spec` directly in conversation with the human user.
2. Conduct Socratic interview (`grill-with-docs`) to probe requirements, edge cases, contracts, and non-goals.
3. Record new ubiquitous language in `CONTEXT.md` (or `topics/<topic>/GLOSSARY.md`) and log any architectural decisions in `docs/adr/000X-...`.
4. Scaffold the persistent feature directory:
   - Topic features: `topics/<topic-name>/.features/<feature-id>/`
   - Repo features: `.features/<feature-id>/`
   Populate `feature-brief.md`, `grilling-records.md`, and `spec.md` with Gherkin acceptance criteria.
5. Obtain explicit user sign-off on the spec.
6. Create and switch to the isolated feature topic branch:
   ```bash
   git checkout -b feat/<feature-id>-<slug>
   ```

### Phase 2: Acceptance Test Red Gate (QA Agent)
1. Delegate to QA Agent running `/test-generation` in feature acceptance mode.
2. Translate Gherkin scenarios in `spec.md` into automated, executable test suites or harness scripts (`acceptance-tests.*`).
3. **Hard Acceptance Red Gate**: QA executes the test suite against the codebase. It **must fail deterministically (Red)** because the feature is not yet implemented.
4. Retry budget: Max 3 test formulation attempts. If QA cannot build a failing acceptance suite, Coordinator halts and requests clarification.
5. Once verified Red, seal **Commit 1**:
   ```bash
   git add <feature-dir>/feature-brief.md <feature-dir>/grilling-records.md <feature-dir>/spec.md <test-files> docs/adr/ CONTEXT.md
   git commit -m "test(<subsystem>): define acceptance test suite for <feature-id>"
   ```

### Phase 3: Minimal Feature Implementation (Developer Agent)
1. Once Commit 1 is locked, delegate to Developer Agent.
2. Developer reads `spec.md` and the failing acceptance test suite.
3. Developer implements the minimal application/library code diff required to satisfy the acceptance tests without scope creep or extraneous additions.
4. Developer verifies locally that acceptance tests pass.

### Phase 4: Verification & Two-Axis Code Review (QA Agent)
1. Delegate to QA Agent running `/code-review`.
2. Run the acceptance test suite: **Must turn completely Green**.
3. Run the repository's full regression test suite: **Zero regressions permitted**.
4. Perform Two-Axis Code Review:
   - **Axis A (Standards)**: Code style, cleanliness, idiomatic conventions, documentation.
   - **Axis B (Spec Compliance)**: Complete coverage of all Gherkin criteria in `spec.md` without undeclared scope additions.
5. Output review results to `<feature-dir>/verification.md`.
6. If tests fail or review rejects, return to Phase 3 with actionable remediation feedback (decrement retry budget).

### Phase 5: Pre-Commit Security Audit (Security Agent)
1. Delegate to Security Agent running `/security-review`.
2. Scan the feature diff for credential leaks, injection vulnerabilities (SQL, shell, XSS), authorization checks, OWASP Top 10 surface, and insecure dependencies.
3. Output audit clearance to `<feature-dir>/security-audit.md`.
4. If vulnerabilities are identified, return to Phase 3 for immediate remediation.

### Iteration & Circuit Breaker Rule
- Developer implementation cycles are strictly capped at **3 iterations total**.
- If a feature implementation fails QA verification or Security audit on iteration 3:
  - Coordinator triggers the circuit breaker.
  - Executes `git reset` to clean uncommitted changes.
  - Compiles `<feature-dir>/failure-debrief.md`.
  - Halts autonomous execution and presents the failure report to the user for guidance.

### Phase 6: Sequenced Commits & PR Synthesis (Coordinator)
1. When all gates pass (QA Green + QA Review + Security Clearance):
2. Seal **Commit 2 (Implementation Gate)**:
   ```bash
   git add <modified-application-files>
   git commit -m "feat(<subsystem>): implement <feature-id> per specification"
   ```
3. Invoke `/pr-creation` to seal **Commit 3 (Verification & Security Gate)**:
   ```bash
   git add <feature-dir>/verification.md <feature-dir>/security-audit.md
   git commit -m "docs(<subsystem>): record QA verification and security audit for <feature-id>"
   ```
4. Push the branch to remote:
   ```bash
   git push -u origin feat/<feature-id>-<slug>
   ```
5. Open Pull Request on GitHub using `gh pr create` with the full verification matrix table linking spec, acceptance tests, and security clearance.
6. Present the PR link in chat for final human review and merge approval.
