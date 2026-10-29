# Gemini / Antigravity Rule: Strict Topic Isolation

This workspace enforces strict topic isolation across all learning domains.

See [AGENTS.md](./AGENTS.md) for the complete multi-topic policy.

## Key Directives:
- All topics are strictly isolated in `topics/<topic-name>/`.
- Never read, cross-reference, or leak files between different topic directories.
- All `/teach` and `/teachme` workflows must resolve paths inside `topics/<topic-name>/`.
- Store lessons in `topics/<topic-name>/lessons/` and learning records in `topics/<topic-name>/learning-records/`.
- For bug triage & resolution, follow the 4-agent team workflow (Coordinator, QA, Developer, Security) defined in `AGENTS.md` and orchestrated via `/triage-orchestrator`.
- Enforce the Hard QA-First Red Gate: no production code changes until a deterministic failing reproduction test is verified.
- Enforce the 3-Commit Gate Standard: early branch creation `fix/<issue-id>-<slug>`, 3 sequenced conventional commits (reproduce, fix, verify), persistent `.triage/` tracking, and automated PR creation for human review.
