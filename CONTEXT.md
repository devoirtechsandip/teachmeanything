# Ubiquitous Language: Bug Triage & Resolution Multi-Agent System

This document establishes canonical terminology and ubiquitous language for the autonomous bug triage, diagnosis, and resolution multi-agent system.

---

## 1. Execution Platform & Architecture
- **Runtime Environment**: Native Antigravity Subagent System (`invoke_subagent`, `send_message`, terminal tools) per [ADR 0001](file:///workspaces/teachmeanything/docs/adr/0001-native-antigravity-subagents-and-skills.md).
- **Topology**: Hub-and-Spoke Supervisor Model with Central Coordinator per [ADR 0002](file:///workspaces/teachmeanything/docs/adr/0002-hub-and-spoke-supervisor-topology.md).
- **Reproduction Invariant**: Hard QA-First Red Gate per [ADR 0003](file:///workspaces/teachmeanything/docs/adr/0003-hard-qa-first-reproduction-gate.md).
- **Team Structure**: 4-Agent Team with Dedicated Security Specialist per [ADR 0004](file:///workspaces/teachmeanything/docs/adr/0004-dedicated-security-agent.md).
- **Operational Lifecycle**: 3-Strike Circuit Breaker, Ephemeral `.triage/<issue-id>/` artifacts, and Gated PR creation per [ADR 0005](file:///workspaces/teachmeanything/docs/adr/0005-operational-lifecycle-and-circuit-breaker.md).
- **Cross-IDE Distribution**: Full parity across Antigravity (`.agents/`), Cursor (`.cursor/`), and GitHub Copilot (`.github/`) per [ADR 0006](file:///workspaces/teachmeanything/docs/adr/0006-multi-ide-agent-parity.md).

---

## 2. Roles & Agents

| Role | Domain Responsibility | Non-Responsibilities |
| :--- | :--- | :--- |
| **Coordinator Agent** | Workflow orchestration, issue intake/triage, requirement validation, delegating tasks to Developer, QA, and Security, progress tracking, retry budget enforcement, and final PR synthesis. | Writing production code, running deep diagnostic probes directly. |
| **Developer Agent** | Root cause analysis (RCA), surgical debugging, formulating falsifiable hypotheses, implementing minimal code fixes, and code cleanup. | Declaring a bug "resolved" without QA verification, modifying code without a failing Red test. |
| **QA Agent** | Building deterministic reproduction feedback loops (failing test / Red gate), regression test generation, verification of fixes (Green gate), and two-axis review (Standards & Spec). | Implementing bug fixes in application code, performing deep security vulnerability audits. |
| **Security Agent** | Independent pre-PR audit: credential/secret leaks, injection vulnerabilities, privilege escalation checks, dependency security audits, and CWE/OWASP surface reviews. | Writing application bug fixes, functional testing. |

---

## 3. Core Capabilities & Skills

| Skill / Capability | Description & Invariants |
| :--- | :--- |
| **Bug Triage (`bug-triage`)** | Intake analysis of incoming defect reports. Normalizes issue inputs, checks for missing reproduction data, assigns severity/priority, and outlines the target defect scope. |
| **Deterministic Reproduction (`test-generation`)** | Compulsory feedback loop requirement: application code fixes cannot proceed without a reliable, automated failing test script or reproduction command (turning Red). |
| **Root Cause Analysis (`diagnosing-bugs`)** | Gated investigation that isolates the foundational defect rather than patching symptoms. Formulates 3–5 falsifiable hypotheses against the code seam. |
| **Targeted Debugging & Fix** | Surgical instrumentation (narrow traces/assertions) without polluting production code or leaking sensitive credentials/data, applying the minimal diff to turn Red to Green. |
| **Two-Axis Review (`code-review`)** | Independent validation across **Axis A (Standards)** (repository idioms, cleanliness, maintainability) and **Axis B (Spec)** (does it fix the exact issue without scope creep?). |
| **Security Review (`security-review`)** | Automated audit for credential leaks, injection vulnerabilities, privilege escalation, or unintended attack surface introduced during the bug fix. |
| **PR Creation (`pr-creation`)** | Automated generation of a clean git branch, atomic commit, and PR description linking root cause, reproduction test evidence, and passing CI verification. |

---

## 4. Workflow State Machine

```text
               [Issue Ingested]
                      │
                      ▼
            [Coordinator: Bug Triage] ──── (Incomplete Info) ──► [Halt & Request Clarification]
                      │
                      ▼
           [QA: Red Reproduction Gate] ──── (Failed > 3x) ──────► [Halt & Escalate to User]
                      │ (Deterministic Red Command)
                      ▼
           [Developer: RCA & Minimal Fix]
                      │ (Proposed Diff)
                      ▼
       [QA: Green Verification & Two-Axis Review] ── (Rejected) ──► [Developer: Refine Fix]
                      │ (Passed Verification)
                      ▼
           [Security Agent: Audit] ──────────────── (Flagged) ───► [Developer: Remediate Security]
                      │ (Approved)
                      ▼
           [Coordinator: PR Creation]
                      │
                      ▼
                [PR Ready]
```
