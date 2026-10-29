# Gemini / Antigravity Rule: Strict Topic Isolation

This workspace enforces strict topic isolation across all learning domains.

See [AGENTS.md](./AGENTS.md) for the complete multi-topic policy.

## Key Directives:
- All topics are strictly isolated in `topics/<topic-name>/`.
- Never read, cross-reference, or leak files between different topic directories.
- All `/teach` and `/teachme` workflows must resolve paths inside `topics/<topic-name>/`.
- Store lessons in `topics/<topic-name>/lessons/` and learning records in `topics/<topic-name>/learning-records/`.
