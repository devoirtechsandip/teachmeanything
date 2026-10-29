# Grilling Records: Feature Development Workflow

This document records the Socratic grilling interview conducted between the Coordinator and the User to stress-test requirements and finalize architecture before implementation.

---

## Round 1: Foundational Architecture & Frontier Mapping

### Question 1: Workflow Orchestration & Grilling Trigger
- **Question**: How should the feature development workflow initiate the mandatory grilling session and transition into autonomous implementation?
- **Options Explored**:
  - *(A) (Selected)* Single entrypoint `/feature-orchestrator`: Coordinator executes interactive `grill-with-docs` in the main chat with the user, logs interview records and ADRs, obtains user sign-off, cuts `feat/<feature-id>-<slug>`, and dispatches subagents.
  - *(B)* Two-step decoupled workflow: User runs `/grill-with-docs` manually to generate the spec and ADRs first, then triggers `/feature-orchestrator <spec-path>`.
  - *(C)* Subagent-driven interview: Coordinator delegates requirements gathering to an autonomous Architect subagent.
- **Decision & Rationale**: Option A chosen. Running the interview directly in the user's active session ensures natural dialogue and immediate alignment without awkward context switches or asynchronous message roundtrips.

### Question 2: The Feature Quality Gate (Acceptance Red Gate)
- **Question**: How should the quality gate (the equivalent of bug triage's Hard QA Red Gate) be enforced for new feature development?
- **Options Explored**:
  - *(A) (Selected)* Strict Acceptance Test Red Gate (QA-First): After spec approval, QA authors deterministic failing acceptance/integration test suites matching the spec (Commit 1: `test(<scope>): define acceptance criteria`). Developer is barred from feature code until tests are Red.
  - *(B)* Contract-First Implementation: Developer writes type interfaces, contracts, and implementation code together; QA validates end-to-end functionality after the initial PR draft is ready.
  - *(C)* Dual-Phase Verification: Developer writes unit tests while QA concurrently drafts integration tests.
- **Decision & Rationale**: Option A chosen. Strict separation of concerns prevents Developer from writing tests that match their implementation bugs. QA enforces test failure against the specification first.

### Question 3: Persistent Feature Storage & Topic Isolation
- **Question**: Where should persistent feature artifacts (interview records, specifications, acceptance criteria, and audit reports) be versioned?
- **Options Explored**:
  - *(A) (Selected)* Context-aware persistence: Universal features store audit trails in `.features/<feature-id>/`, while topic-specific features store them inside `topics/<topic-name>/.features/<feature-id>/` (preserving strict topic isolation), committed to git across 3 sequential commits.
  - *(B)* Root-only persistence: Always store in repository root `.features/<feature-id>/`.
  - *(C)* Documentation directory only: Store feature specs under `docs/features/<feature-id>/` and do not commit QA verification or test artifacts to git.
- **Decision & Rationale**: Option A chosen. Respects the absolute boundary rule in `AGENTS.md` (no cross-topic contamination) while maintaining a clean, versioned history for repo-wide tooling.

### Question 4: Agent Team Topology & Skill Reuse
- **Question**: How should the agent team roles and skill inventory be structured for feature development?
- **Options Explored**:
  - *(A) (Selected)* Retain 4-Agent Topology (Coordinator, QA, Developer, Security): Reuse `security-review`, `code-review`, and `pr-creation` as-is; author `feature-orchestrator`, `feature-spec` (grilling capture), and adapt `test-generation` for acceptance criteria.
  - *(B)* 5-Agent Topology: Add a dedicated Architect Agent for grilling and specifications.
  - *(C)* 3-Agent Topology: Consolidate Security responsibilities into QA.
- **Decision & Rationale**: Option A chosen. Minimizes conceptual complexity and operational friction by reusing proven agents and skills, only adding feature-specific orchestration and specification capabilities.

---

## Round 2: Operational Specifications & Commit Standards

### Question 5: Commit Structure & Convention
- **Question**: What commit convention and gating sequence should be enforced on the feature branch?
- **Decision**: Adopt the exact 3-Commit Gate Standard:
  - Commit 1: `test(<scope>): define acceptance test suite for <feature-id>` (spec, grill-record, failing tests)
  - Commit 2: `feat(<scope>): implement <feature-id> per spec` (feature code)
  - Commit 3: `docs(<scope>): record QA verification and security audit` (QA Green report, Security clearance)

### Question 6: Persistent Specification Bundle
- **Question**: What artifacts must the mandatory grilling session produce inside the feature directory before subagent execution?
- **Decision**: Complete specification bundle:
  - `feature-brief.md`: Scope, user prompt, boundaries.
  - `grilling-records.md`: Full interview transcript and trade-off analysis.
  - `spec.md`: System contracts and Gherkin acceptance scenarios.
  - `docs/adr/000X-...`: Formal architectural decisions.
  - `CONTEXT.md` / `GLOSSARY.md`: Ubiquitous language updates.

### Question 7: Circuit Breaker Policy
- **Question**: What circuit breaker policy should govern the Developer implementation and review feedback loop?
- **Decision**: Strict 3-Iteration Circuit Breaker. If implementation fails QA verification or Security clearance 3 times, halt execution, emit `failure-debrief.md`, and consult human user.

### Question 8: Multi-IDE Parity
- **Question**: How should the feature development skills and rules be distributed across IDEs for multi-platform parity?
- **Decision**: Full tri-platform sync across Antigravity (`.agents/skills/`), Cursor (`.cursor/skills/` and `.cursor/rules/`), and GitHub Copilot (`.github/skills/` and `.github/copilot-instructions.md`).
