# Feature Brief: Multi-Agent Feature Development Workflow

- **Feature ID**: `feature-development-workflow`
- **Scope**: Repo-wide Multi-Agent System & Cross-IDE Tooling
- **Target Platform**: Antigravity (`.agents/`), Cursor (`.cursor/`), GitHub Copilot (`.github/`)
- **Status**: Implemented & Verified
- **Reference ADR**: [ADR 0008](file:///workspaces/teachmeanything/docs/adr/0008-feature-development-lifecycle-and-grilling-gate.md)

---

## 1. Intent & Problem Statement
Following the codification of the autonomous 4-agent bug triage and resolution lifecycle ([ADR 0001](file:///workspaces/teachmeanything/docs/adr/0001-native-antigravity-subagents-and-skills.md) through [ADR 0007](file:///workspaces/teachmeanything/docs/adr/0007-sequenced-commit-git-lifecycle-and-persistent-triage.md)), the repository required an equivalent autonomous workflow for user feature requests.

Unlike bug triage, which begins with deterministic stack traces and failure logs, new feature development inherently begins with ambiguous user desires, interface contracts, and architectural decisions. Without a structured grilling interview upfront, autonomous agents risk hallucinations, unverified assumptions, and scope creep.

---

## 2. Key Objectives
1. **Mandatory Grilling Gate (`grill-with-docs`)**: Coordinator must lead a dependency-aware Socratic interview directly with the user before cutting branches or dispatching subagents.
2. **Context-Aware Persistent Feature Storage**: Version-controlled feature audit trail stored in `.features/<feature-id>/` (for repo features) or `topics/<topic-name>/.features/<feature-id>/` (for topic features).
3. **Hard QA-First Acceptance Red Gate**: QA must produce an automated, failing acceptance test suite (Red) from `spec.md` before Developer writes code.
4. **3-Commit Gate Standard**: Exactly 3 atomic conventional commits sealing (1) Spec & Red tests, (2) Feature implementation, and (3) QA Green verification and Security audit.
5. **Circuit Breaker**: Strict 3-iteration implementation budget before halting for human guidance.
6. **Autonomous PR Creation**: Automated push to `origin` and PR opening via `gh pr create` with the full verification matrix table.
7. **Tri-Platform IDE Parity**: Identical operational capabilities in Antigravity, Cursor, and GitHub Copilot.

---

## 3. Explicit Non-Goals
- Allowing Developer agents to write application code without an approved specification and failing acceptance test suite.
- Storing feature specifications in uncommitted ephemeral scratchpads.
- Cross-contaminating learning topic directories during topic-specific feature development.
