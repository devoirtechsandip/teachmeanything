# Ubiquitous Language: Bug Triage & Feature Development Multi-Agent System

This document establishes canonical terminology and ubiquitous language for the autonomous bug triage, diagnosis, resolution, and feature development multi-agent system.

---

## 1. Execution Platform & Architecture
- **Runtime Environment**: Native Antigravity Subagent System (`invoke_subagent`, `send_message`, terminal tools) per [ADR 0001](file:///workspaces/teachmeanything/docs/adr/0001-native-antigravity-subagents-and-skills.md).
- **Topology**: Hub-and-Spoke Supervisor Model with Central Coordinator per [ADR 0002](file:///workspaces/teachmeanything/docs/adr/0002-hub-and-spoke-supervisor-topology.md).
- **Reproduction & Quality Invariant**: Hard QA-First Red Gate (deterministic reproduction test for bugs, deterministic failing acceptance test for features) per [ADR 0003](file:///workspaces/teachmeanything/docs/adr/0003-hard-qa-first-reproduction-gate.md) and [ADR 0008](file:///workspaces/teachmeanything/docs/adr/0008-feature-development-lifecycle-and-grilling-gate.md).
- **Team Structure**: 4-Agent Team with Dedicated Security Specialist per [ADR 0004](file:///workspaces/teachmeanything/docs/adr/0004-dedicated-security-agent.md).
- **Operational Lifecycle**: 3-Strike Circuit Breaker, Ephemeral/Persistent Artifacts, and Gated PR creation per [ADR 0005](file:///workspaces/teachmeanything/docs/adr/0005-operational-lifecycle-and-circuit-breaker.md).
- **Sequenced Commits & Audit History**: Early topic branch creation, 3-Commit Gate Standard, persistent `.triage/` or `.features/` tracking, and automated PR opening for human review per [ADR 0007](file:///workspaces/teachmeanything/docs/adr/0007-sequenced-commit-git-lifecycle-and-persistent-triage.md) and [ADR 0008](file:///workspaces/teachmeanything/docs/adr/0008-feature-development-lifecycle-and-grilling-gate.md).
- **Cross-IDE Distribution**: Full parity across Antigravity (`.agents/`), Cursor (`.cursor/`), and GitHub Copilot (`.github/`) per [ADR 0006](file:///workspaces/teachmeanything/docs/adr/0006-multi-ide-agent-parity.md).

---

## 2. Roles & Agents

| Role | Domain Responsibility | Non-Responsibilities |
| :--- | :--- | :--- |
| **Coordinator Agent** | Workflow orchestration, issue/feature intake, interactive Socratic grilling (`grill-with-docs`), specification synthesis, delegating tasks to Developer, QA, and Security, progress tracking, retry budget enforcement, and final PR synthesis. | Writing production code, running deep diagnostic probes directly. |
| **Developer Agent** | Root cause analysis (RCA) or feature implementation per spec, surgical debugging, formulating falsifiable hypotheses, implementing minimal code fixes/features, and code cleanup. | Declaring a bug or feature "resolved/complete" without QA verification, modifying code without a failing Red test. |
| **QA Agent** | Building deterministic reproduction feedback loops (bug Red gate) or executable acceptance test suites (feature Red gate), regression test generation, verification of fixes/features (Green gate), and two-axis review (Standards & Spec). | Implementing bug fixes/features in application code, performing deep security vulnerability audits. |
| **Security Agent** | Independent pre-PR audit: credential/secret leaks, injection vulnerabilities, privilege escalation checks, dependency security audits, and CWE/OWASP surface reviews. | Writing application bug fixes/features, functional testing. |

---

## 3. Core Capabilities & Skills

| Skill / Capability | Description & Invariants |
| :--- | :--- |
| **Bug Triage (`bug-triage`)** | Intake analysis of incoming defect reports. Normalizes issue inputs, checks for missing reproduction data, assigns severity/priority, and outlines the target defect scope. |
| **Feature Intake & Spec (`feature-spec`)** | Interactive requirements interrogation via `grill-with-docs`. Scaffolds specification bundle (`feature-brief.md`, `grilling-records.md`, `spec.md`), logs ADRs, and updates glossary before cutting branch. |
| **Feature Orchestrator (`feature-orchestrator`)** | Master entrypoint coordinating the 6-phase feature development lifecycle, 3-Commit Gate Standard, and 3-strike circuit breaker. |
| **Deterministic Reproduction (`test-generation`)** | Compulsory feedback loop requirement: application code fixes cannot proceed without a reliable, automated failing test script or reproduction command (turning Red). |
| **Acceptance Test Suite (`test-generation`)** | For feature development: QA translates `spec.md` acceptance criteria into deterministic failing acceptance/integration tests (Red Gate) before Developer writes code. |
| **Root Cause Analysis (`diagnosing-bugs`)** | Gated investigation that isolates the foundational defect rather than patching symptoms. Formulates 3–5 falsifiable hypotheses against the code seam. |
| **Targeted Debugging & Fix** | Surgical instrumentation without polluting production code or leaking sensitive credentials/data, applying the minimal diff to turn Red to Green. |
| **Two-Axis Review (`code-review`)** | Independent validation across **Axis A (Standards)** (repository idioms, cleanliness, maintainability) and **Axis B (Spec)** (does it meet the exact specification without scope creep?). |
| **Security Review (`security-review`)** | Automated audit for credential leaks, injection vulnerabilities, privilege escalation, or unintended attack surface introduced during code changes. |
| **Sequenced Commit Lifecycle** | Strict progression of 3 atomic conventional git commits: (1) Red tests + brief/spec, (2) Code implementation, (3) Green verification + security audit. |
| **Persistent Artifacts** | Version-controlled records (`.triage/<id>/` for bugs; `.features/<id>/` or `topics/<topic>/.features/<id>/` for features) committed directly to topic branch. |
| **PR Creation (`pr-creation`)** | Automated generation of a clean git branch, atomic commits, and PR description with the complete verification matrix for human review on GitHub. |

---

## 4. Bug Triage State Machine

```text
               [Issue Ingested]
                      │
                      ▼
             [Coordinator: Bug Triage] ──── (Incomplete Info) ──► [Halt & Request Clarification]
                      │
                      ▼
             (Create Topic Branch: fix/<issue-id>-<slug>)
                      │
                      ▼
            [QA: Red Reproduction Gate] ──── (Failed > 3x) ──────► [Delete Branch & Halt]
                      │
                      ▼
             (Commit 1: test(<scope>): reproduce <issue-id> failure)
                      │
                      ▼
          ┌──► [Developer: RCA & Minimal Fix]
          │             │
          │             ▼
          │    [QA: Green Verification & Two-Axis Review] ──► (Rejected) ──┐
          │             │ (Passed)                                         │
          │             ▼                                                  │
          │    [Security Agent: Pre-Commit Audit] ─────────► (Vulnerable) ─┘
          │             │ (Approved)                         (Retry Budget < 3)
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
             [Coordinator: Push Branch & Open PR for Human Review]
                        │
                        ▼
             [PR Ready on GitHub]
```

---

## 5. Feature Development State Machine

```text
               [Feature Request Ingested via /feature-orchestrator]
                                      │
                                      ▼
             [Coordinator: Scope & Topic Resolution]
                                      │
                                      ▼
             [Coordinator: Mandatory Grilling with Docs] ◄──(Iterate with User)
                                      │
                                      ▼ (User Approves Spec & ADRs)
             (Scaffold Persistent Spec Bundle & ADRs)
                                      │
                                      ▼
             (Create Topic Branch: feat/<feature-id>-<slug>)
                                      │
                                      ▼
             [QA: Red Acceptance Gate] ────── (Failed to write test > 3x) ──► [Halt & Consult]
                                      │
                                      ▼
             (Commit 1: test(<scope>): define acceptance test suite for <feature-id>)
                                      │
                                      ▼
          ┌──► [Developer: Minimal Implementation per Spec]
          │             │
          │             ▼
          │    [QA: Green Verification & Two-Axis Review] ──► (Rejected) ──┐
          │             │ (Passed)                                         │
          │             ▼                                                  │
          │    [Security Agent: Pre-Commit Audit] ─────────► (Vulnerable) ─┘
          │             │ (Approved)                         (Retry Budget < 3)
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
             [Coordinator: Push Branch & Open PR for Human Review]
                        │
                        ▼
             [Feature PR Ready on GitHub]
```
