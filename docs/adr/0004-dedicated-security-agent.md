# ADR 0004: Agent Team Structure & Dedicated Security Specialist

- **Status**: Accepted
- **Date**: 2026-10-29
- **Decision Makers**: User, Antigravity Agent

---

## Context
Automated code modifications present security risks including accidental credential leaks, insecure regex or SQL injection introductions, privilege escalations, or dangerous package installations. We evaluated whether to embed security scanning inside QA's review phase or introduce an autonomous Security Specialist Agent.

---

## Decision
We establish a **4-Agent Team** with a **Dedicated Security Agent**:
1. **Coordinator Agent**: Supervision, bug triage, task dispatching, artifact collection, and final PR synthesis.
2. **Developer Agent**: Root cause analysis, targeted debugging, and minimal fix implementation.
3. **QA Agent**: Deterministic reproduction test generation (Red gate), regression verification (Green gate), and Two-Axis Code Review (Standards & Spec).
4. **Security Agent**: Pre-commit security audit, credential leakage scanning, dependency vulnerability audit, and OWASP Top 10 surface analysis on the proposed diff.

---

## Consequences

### Positive
- Strict separation of concerns: QA focuses on functional correctness and specifications; Security focuses on threat modeling and vulnerability auditing.
- Dedicated prompt and specialized tooling for security heuristics prevents "reviewer fatigue" or superficial security sign-offs.
- Final PR gate requires independent approval from both QA (functional/spec) and Security (vulnerability/secrets).

### Negative / Trade-offs
- Adds an additional subagent invocation step prior to PR creation, increasing token expenditure slightly.
