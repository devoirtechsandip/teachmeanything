# ADR 0005: Operational Lifecycle, Circuit Breaker & Ephemeral Artifacts

- **Status**: Accepted
- **Date**: 2026-10-29
- **Decision Makers**: User, Antigravity Agent

---

## Context
Running an autonomous multi-agent bug-resolution workflow requires strict operational boundaries to avoid runaway loops, dirty git states, and opaque failure modes.

We evaluated:
1. Rejection iteration budgets (3-strike limit vs infinite prompts).
2. State handoff storage (in-memory ephemeral messages vs file-based scratchpad directory).
3. PR creation gating (autonomous remote push vs interactive human sign-off).

---

## Decision
1. **3-Strike Circuit Breaker**:
   - Developer has a maximum of 3 iterative fix attempts against QA verification and Security audit.
   - On the 3rd consecutive failure, the Coordinator halts, executes `git reset` to keep the working tree clean, writes a **Failure Debrief Report**, and yields control to the human.
2. **Ephemeral Workspace Contract (`.triage/<issue-id>/`)**:
   - Inter-agent communication is anchored to structured files in `.triage/<issue-id>/`:
     - `triage-brief.md` (Coordinator)
     - `reproduce.sh` / `test_repro.*` (QA Red gate)
     - `rca.md` (Developer hypotheses & seam trace)
     - `qa-report.md` (QA Green verification & two-axis review)
     - `security-audit.md` (Security Agent clearance)
   - `.triage/` is ignored by git and automatically archived or cleaned up once the PR is finalized.
3. **Gated PR Creation**:
   - Coordinator stages the verified fix, commits to a local branch `fix/<issue-id>-<slug>`, displays the full audit report and git diff to the user, and requires explicit user confirmation before executing `git push` and `gh pr create`.

---

## Consequences

### Positive
- Transparent, inspectable audit trail stored directly on disk during the run.
- Zero risk of uncontrolled git commits or dirty branches escaping into remote repos.
- Halts runaway token consumption when an agent encounters an architectural deadlock.

### Negative / Trade-offs
- Requires one click or confirmation from the user to finalize the remote PR.
