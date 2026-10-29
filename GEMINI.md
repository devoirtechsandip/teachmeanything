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
- For new feature development, follow the 4-agent team workflow orchestrated via `/feature-orchestrator`.
- Enforce the Mandatory Grilling Gate: Coordinator conducts an interactive `grill-with-docs` session directly with the user before any code branch is cut or subagents are dispatched.
- Enforce the Acceptance Red Gate: no feature code changes until QA produces an automated failing acceptance test suite (Red).
- Enforce context-aware persistence: `.features/<feature-id>/` for repo features, or `topics/<topic-name>/.features/<feature-id>/` for topic features, preserved across 3 sequential commits on `feat/<feature-id>-<slug>`.
