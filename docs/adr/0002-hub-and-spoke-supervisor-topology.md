# ADR 0002: Team Topology & Orchestration — Centralized Hub-and-Spoke

- **Status**: Accepted
- **Date**: 2026-10-29
- **Decision Makers**: User, Antigravity Agent

---

## Context
When orchestrating multiple specialized agents to triage, diagnose, fix, and verify software defects, agent communication topology dictates token consumption, failure recovery, and architectural determinism.

We evaluated:
1. **Hub-and-Spoke (Supervisor Model)**: Coordinator agent mediates all communication, dispatches discrete tasks with explicit context, and validates stage gates.
2. **Linear State Machine (Pipeline)**: Hardcoded sequential transitions with simple back-decrement on failure.
3. **Peer Swarm / Shared Chatroom**: All agents debate collaboratively in an open context.

---

## Decision
We select **Option A: Centralized Hub-and-Spoke (Supervisor Model)**.
- The **Coordinator Agent** is the single orchestrator and state-holder.
- Execution agents (`Developer`, `QA`, `Security`) receive scoped task prompts and reply solely to the Coordinator with structured artifact deliverables.
- Subagents do not initiate peer-to-peer dialogues directly, preventing circular agent agreements, hallucination cascades, and uncontrolled token usage.

---

## Consequences

### Positive
- Strict isolation of agent context windows (agents only see the context relevant to their immediate task).
- Deterministic error handling: when an agent produces an invalid result, the Coordinator can inspect the diff, provide corrective feedback, or halt execution cleanly.
- Granular retry budgets can be enforced per role without restarting the entire pipeline.

### Negative / Trade-offs
- The Coordinator becomes a potential bottleneck and must maintain sufficient global state to synthesize complex handoffs.
