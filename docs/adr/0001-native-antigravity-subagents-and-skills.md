# ADR 0001: Target Execution Runtime — Native Antigravity Subagents & Skills

- **Status**: Accepted
- **Date**: 2026-10-29
- **Decision Makers**: User, Antigravity Agent

---

## Context
We need to design an automated, multi-agent workflow for defect triage, diagnosis, verification, and resolution consisting of three distinct agent roles (Coordinator, Developer, QA) utilizing a suite of specialized skills (Triage, Root Cause Analysis, Reproduction/Test Generation, Debugging, Security Review, Code Review, PR Creation).

We evaluated three potential execution runtimes:
1. **Native Antigravity Subagents & Modular Skills**: Defined natively in `.agents/skills/` and orchestrating specialized subagents (`Coordinator`, `Developer`, `QA`) using native environment tools (`invoke_subagent`, `run_command`, `read_file`, `write_file`).
2. **Headless GitHub Action / CI Bot**: Event-driven container runs triggered on GitHub issue events.
3. **External Python/TypeScript Multi-Agent Framework**: A custom LangGraph or CrewAI backend service.

---

## Decision
We select **Option A: Native Antigravity Subagents & Modular Skills**.
- Skills will be structured as modular skill directories under `.agents/skills/` conforming to the Antigravity skill specification.
- Agents will be declared as dedicated subagent roles with tightly scoped capabilities, tools, and system prompts.
- Workflows will be triggerable interactively and verifiable directly within the development workspace.

---

## Consequences

### Positive
- Deep, zero-latency integration with local codebases, terminal execution, and diff viewing.
- Leverages existing repo skills directly (e.g. `diagnosing-bugs`, `code-review`).
- Strict local sandboxing protects against unconstrained token or credential leakage.
- Modular skill files can be executed either manually by a human or delegated to subagents.

### Negative / Trade-offs
- Requires interactive initiation from within an Antigravity workspace or CLI session (not a fully detached headless SaaS bot by default).
- State transitions must be coordinated explicitly via agent-to-agent messaging protocols and structured scratchpad/file artifacts.
