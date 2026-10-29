# ADR 0003: Deterministic Reproduction Gate — Hard QA-First Red Test Requirement

- **Status**: Accepted
- **Date**: 2026-10-29
- **Decision Makers**: User, Antigravity Agent

---

## Context
A primary failure mode of automated LLM code fixing is speculative patching: an agent applies edits to production code for a defect that was never reproduced, yielding placebo fixes or breaking regressions.

We evaluated:
1. **Hard QA-First Red Gate**: The QA agent must craft a standalone, deterministic test script or command that fails consistently on the reported bug before any production code can be modified.
2. **Developer-Led Exploration**: Developer analyzes the codebase, formulates a hypothesis, and QA writes tests around that hypothesis.
3. **Parallel Investigation**: Both agents investigate simultaneously.

---

## Decision
We select **Hard QA-First Red Gate (Strict TDD)**.
- **Invariant**: The Developer agent is strictly blocked from touching application/production code until the QA agent has produced a deterministic reproduction test (or failing command) that turns **Red**.
- **Retry Budget**: QA has a maximum budget of **3 attempts** to reproduce the bug using the provided report, environment clues, and test suite.
- **Escalation**: If the bug cannot be reproduced within the budget, the Coordinator terminates the fix loop and reports an actionable request for clarification (logs, env variables, reproduction steps) back to the user/issue submitter.

---

## Consequences

### Positive
- Zero tolerance for speculative patches or imaginary bugs.
- Guarantees an immediate feedback loop: testing the fix is as simple as running the Red command to verify it turns **Green**.
- Automatically produces a regression test that remains in the codebase.

### Negative / Trade-offs
- Heisenbugs, race conditions, or environmental quirks that cannot be simulated via local commands fail fast and require human intervention to provide richer reproduction harnesses.
