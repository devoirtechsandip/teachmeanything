# Topic Isolation Rule

## Context
This workspace contains multiple independent learning topics stored under `topics/<topic-name>/`.

## Rules
1. **Scope to Single Topic**: When assisting with a learning topic, scope all tool operations, file reads, and edits exclusively to `topics/<topic-name>/`.
2. **No Cross-Contamination**: Never read or import context, learning records, mission statements, or terminology from one topic folder into another.
3. **Teach Skill Execution**: Resolve workspace paths for `/teach` (`./lessons/`, `./learning-records/`, `./reference/`, `MISSION.md`, `RESOURCES.md`, `GLOSSARY.md`, `NOTES.md`) relative to `topics/<topic-name>/`.
4. **New Topics**: If a new topic is requested, scaffold it from `topics/_template/` into `topics/<topic-name>/`.
