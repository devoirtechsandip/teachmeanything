# GitHub Copilot Instructions: Multi-Topic Learning Hub

This repository contains independent learning topics housed under `topics/<topic-name>/` (e.g., `topics/git/`, `topics/dotnet/`).

## Core Rules for Copilot:
1. **Strict Topic Separation**:
   - Each topic under `topics/<topic-name>/` is an isolated, self-contained learning environment.
   - Never cross-pollinate, read, or reference files, learning records, or notes from one topic folder when assisting with another.
2. **Teach Skill Execution**:
   - When executing the `teach` or `teachme` skill, treat `topics/<topic-name>/` as the root workspace for that topic.
   - All relative file paths (`MISSION.md`, `RESOURCES.md`, `GLOSSARY.md`, `NOTES.md`, `lessons/`, `learning-records/`, `reference/`) must be scoped strictly within that topic's directory.
3. **Scaffolding**:
   - If asked to teach an uninitialized topic, copy `topics/_template/` into `topics/<new-topic>/` before generating lessons.
