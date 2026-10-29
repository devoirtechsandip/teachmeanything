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

---

## Bug Triage & Resolution Multi-Agent Workflow

When resolving bugs, issues, or defects (or executing `/triage-orchestrator`, `/bug-triage`, `/test-generation`, `/diagnosing-bugs`, `/code-review`, `/security-review`, `/pr-creation`):

1. **Role Separation (Hub-and-Spoke)**:
   - **Coordinator**: Ingests and sanitizes the issue report (`bug-triage`), oversees transitions, manages `.triage/<issue-id>/`, and creates the final PR (`pr-creation`).
   - **QA**: Builds a deterministic reproduction test (`test-generation`), verifies that the fix turns Red into Green with zero regressions, and conducts Two-Axis Code Review (`code-review`).
   - **Developer**: Conducts Root Cause Analysis with 3–5 falsifiable hypotheses and implements the minimal surgical fix (`diagnosing-bugs`).
   - **Security**: Independently audits diffs for secrets, injection, OWASP flaws, and unpinned dependencies (`security-review`).
2. **Hard Red Gate Invariant**:
   - Never write or suggest application code fixes until QA has produced a deterministic failing test (Red).
3. **3-Strike Circuit Breaker**:
   - Cap fix attempts at 3. If QA or Security rejects 3 times, reset the working tree and halt for human guidance.
4. **Gated PR Creation**:
   - Prepare local branch and atomic commit, but require explicit user confirmation before pushing to remote remotes.
