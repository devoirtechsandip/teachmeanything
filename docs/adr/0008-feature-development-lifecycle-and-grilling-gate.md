# ADR 0008: Feature Development Multi-Agent Lifecycle, Mandatory Grilling Gate, and Sequenced Commits

## Status
Accepted

## Context
Following the successful implementation and verification of the autonomous 4-agent bug triage and resolution lifecycle ([ADR 0001](file:///workspaces/teachmeanything/docs/adr/0001-native-antigravity-subagents-and-skills.md) through [ADR 0007](file:///workspaces/teachmeanything/docs/adr/0007-sequenced-commit-git-lifecycle-and-persistent-triage.md)), the development workflow must be extended to new feature and functionality requests. 

Unlike bug triage (which begins with defect reports and runtime failures), feature development begins with ambiguous user desires, interface contracts, and architectural decisions. To guarantee that autonomous agents build what the user actually wants without hallucinations or scope creep, new feature development requires:
1. An upfront, interactive Socratic requirements interview (`grill-with-docs`) conducted directly with the user.
2. A formal specification bundle and persistent feature audit trail.
3. Strict QA-First acceptance test gating (the feature equivalent of the bug triage Red Gate).
4. The 3-Commit Gate Standard matching the proven git audit lifecycle.
5. Strict topic isolation and multi-IDE synchronization across Antigravity, Cursor, and GitHub Copilot.

## Decision

### 1. Unified Entrypoint (`/feature-orchestrator`)
A master command `/feature-orchestrator "<feature description>"` initiates the feature development lifecycle. The Coordinator agent oversees all 6 sequential phases:
- **Phase 1: Feature Intake & Scoping**: Identifies whether the feature is repo-wide or topic-specific (e.g. `topics/<topic-name>/`). If topic-specific, verifies `topics/<topic-name>/MISSION.md` and enforces topic isolation.
- **Phase 2: Mandatory Grilling With Docs Gate**: Coordinator conducts an interactive Socratic interview with the user in the main conversation. The interview stress-tests requirements, assumptions, and edge cases, producing a complete specification bundle in persistent storage before any code branch is cut.
- **Phase 3: Topic Branch Creation & Red Acceptance Gate**: Cuts `feat/<feature-id>-<slug>` from `main`. QA agent authors deterministic failing acceptance/integration tests matching the specification, sealing **Commit 1**.
- **Phase 4: Developer Implementation Gate**: Developer implements the minimal feature code to turn acceptance tests Green, sealing **Commit 2**.
- **Phase 5: Verification & Security Gate**: QA conducts Green verification and Two-Axis code review; Security agent audits for credential leaks, injection vectors, and OWASP compliance. Seals **Commit 3**.
- **Phase 6: PR Synthesis**: Coordinator pushes the branch and opens a Pull Request on GitHub for human review.

```text
       [User: /feature-orchestrator]
                      │
                      ▼
     [Coordinator: Scope & Topic Resolution]
                      │
                      ▼
     [Phase 1: Interactive Grilling with Docs] ──(Iterate with User)
                      │
                      ▼ (User Approval)
     (Scaffold Persistent Feature Directory & ADRs)
                      │
                      ▼
     (Create Topic Branch: feat/<feature-id>-<slug>)
                      │
                      ▼
     [Phase 2: QA Acceptance Red Gate] ─────────(Failed to write test > 3x)──► [Halt]
                      │
                      ▼
     (Commit 1: test(<scope>): define acceptance test suite for <feature-id>)
                      │
                      ▼
     ┌──► [Phase 3: Developer Implementation]
     │                │
     │                ▼
     │    [Phase 4: QA Green Verification & Two-Axis Review] ──► (Rejected) ──┐
     │                │ (Passed)                                              │
     │                ▼                                                       │
     │    [Phase 5: Security Pre-Commit Audit] ────────────────► (Vulnerable) ┘
     │                │ (Passed)                               (Retry Budget < 3)
     │                ▼
     └─── (Iterative Fix Cycle)
                      │ (All Passed)
                      ▼
     (Commit 2: feat(<scope>): implement <feature-id> per spec)
                      │
                      ▼
     (Commit 3: docs(<scope>): record QA verification and security audit)
                      │
                      ▼
     [Phase 6: Push Branch & Open PR via gh pr create]
                      │
                      ▼
     [PR Ready for Human Review & Sign-Off on GitHub]
```

### 2. Specification Bundle & Context-Aware Persistent Artifacts
Feature artifacts must be version-controlled and preserved in git history across the 3 commits:
- **Repo-wide Features**: Stored in `.features/<feature-id>/`.
- **Topic-specific Features**: Stored strictly inside `topics/<topic-name>/.features/<feature-id>/` to uphold absolute topic isolation.

The persistent directory contains:
- `feature-brief.md`: Metadata, target topic, requester prompt, initial scope boundaries.
- `grilling-records.md`: Full Q&A interview transcript, stress-tested assumptions, dismissed alternatives, and trade-offs.
- `spec.md`: Detailed functional requirements, contracts, APIs, and Given/When/Then acceptance criteria.
- `acceptance-tests.md` / test runner script: Automated test scripts validating the criteria.
- `verification.md`: QA Two-Axis Review (Standards & Spec compliance) and test execution logs.
- `security-audit.md`: Security agent scan for secrets, OWASP top 10, injection vectors, and dependency clearance.

### 3. The 3-Commit Gate Standard for Features
Every feature branch must contain exactly 3 atomic conventional commits before opening a PR:
1. **Commit 1 (The Red Acceptance Gate)**:
   - Format: `test(<scope>): define acceptance test suite for <feature-id>`
   - Payload: Persistent specification bundle (`feature-brief.md`, `grilling-records.md`, `spec.md`), ADRs, glossary updates, and deterministic failing acceptance test scripts.
2. **Commit 2 (The Implementation Gate)**:
   - Format: `feat(<scope>): implement <feature-id> per specification`
   - Payload: Application and library code diff satisfying the specification and turning all acceptance tests Green.
3. **Commit 3 (The Verification & Clearance Gate)**:
   - Format: `docs(<scope>): record QA verification and security audit for <feature-id>`
   - Payload: QA test run logs (`verification.md`), Two-Axis review sign-off, and Security audit report (`security-audit.md`).

### 4. Quality Invariant: Strict QA-First Acceptance Red Gate
Developer agents are strictly barred from modifying or creating application source files until the QA agent has written an executable acceptance test suite that fails deterministically (Red). This prevents premature coding against unverified interpretations of the specification.

### 5. Circuit Breaker
The Developer agent is granted a maximum budget of **3 attempts** to make the acceptance suite pass and clear QA/Security reviews. If the 3rd attempt fails:
- The Coordinator halts autonomous execution.
- Emits a Failure Debrief to `feature-brief.md`.
- Solicits explicit human guidance.

### 6. Tri-Platform IDE Parity
The feature development workflow is uniformly registered across all three supported developer environments:
- **Antigravity**: `.agents/skills/feature-orchestrator/SKILL.md`, `.agents/skills/feature-spec/SKILL.md`, `AGENTS.md`, `GEMINI.md`.
- **Cursor**: `.cursor/skills/feature-orchestrator/SKILL.md`, `.cursor/skills/feature-spec/SKILL.md`, `.cursor/rules/feature-development-agents.mdc`.
- **GitHub Copilot**: `.github/skills/feature-orchestrator/SKILL.md`, `.github/skills/feature-spec/SKILL.md`, `.github/copilot-instructions.md`.

## Consequences

### Positive
- **Guaranteed Alignment**: The mandatory grilling interview captures requirements and edge cases up front, eliminating guesswork.
- **Auditable & Reproducible**: Complete feature history (interview logs, specifications, tests, code, verification, security audits) is permanently tracked in version control.
- **Consistency with Bug Triage**: Reuses established conventions (4-agent Hub-and-Spoke topology, 3-Commit Gate Standard, Red Gate invariant, 3-strike circuit breaker, automated PR creation).
- **Topic Isolation Preserved**: Scopes topic-specific feature artifacts to `topics/<topic-name>/.features/<feature-id>/` without leaking context across domains.

### Negative / Trade-offs
- **Human Upfront Time**: Requires the user to engage in a structured grilling session before code is written (intentional design to prevent rework).
- **Acceptance Test Overhead**: QA must construct executable tests for new capabilities before implementation begins.
