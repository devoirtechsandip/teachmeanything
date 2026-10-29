# ADR 0006: Multi-IDE Distribution — Cross-Platform Parity across Antigravity, Cursor, and Copilot

- **Status**: Accepted
- **Date**: 2026-10-29
- **Decision Makers**: User, Antigravity Agent

---

## Context
Developers work across multiple AI-assisted environments: Google Antigravity, Cursor IDE, and GitHub Copilot (VS Code / CLI). Confining bug-triage skills and agent personas to a single tool restricts developer velocity and creates workflow fragmentation.

---

## Decision
We establish **Unified Multi-IDE Agent & Skill Parity**:
1. **Skill Synchronization**:
   Every skill created for the triage workflow (`bug-triage`, `test-generation`, `security-review`, `pr-creation`, `triage-orchestrator`) is maintained identically across:
   - `.agents/skills/<skill>/SKILL.md` (Native Antigravity)
   - `.cursor/skills/<skill>/SKILL.md` (Cursor)
   - `.github/skills/<skill>/SKILL.md` (GitHub Copilot CLI / Chat)
2. **Rule & Instruction Alignment**:
   - Cursor: `.cursor/rules/bug-triage-agents.mdc` defining the 4 agent personas, handoff invariants, and the `.triage/` artifact contract.
   - GitHub Copilot: `.github/copilot-instructions.md` updated with instructions for orchestrating Coordinator, Developer, QA, and Security roles.
   - Antigravity: `AGENTS.md` and `GEMINI.md` configured with the agent definitions and slash command entrypoint.
3. **Agent Persona Definitions**:
   Agents are declared in reusable configuration files so they can be invoked in Antigravity via `invoke_subagent` or loaded into Cursor agent settings and Copilot prompts.

---

## Consequences

### Positive
- Developers get the exact same deterministic triage, diagnosis, testing, and security gating regardless of which IDE they use.
- Skills and rules are version-controlled alongside repository code.

### Negative / Trade-offs
- Triplicated skill directories requires keeping files synchronized when skills are edited.
