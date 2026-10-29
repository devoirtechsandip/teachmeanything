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
   - **Coordinator**: Ingests and sanitizes the issue report (`bug-triage`), initializes the topic branch (`fix/<issue-id>-<slug>`), manages `.triage/<issue-id>/`, and creates the final PR (`pr-creation`).
   - **QA**: Builds a deterministic reproduction test (`test-generation`), seals Commit 1, verifies that the fix turns Red into Green with zero regressions, and conducts Two-Axis Code Review (`code-review`).
   - **Developer**: Conducts Root Cause Analysis with 3–5 falsifiable hypotheses and implements the minimal surgical fix (`diagnosing-bugs`).
   - **Security**: Independently audits diffs for secrets, injection, OWASP flaws, and unpinned dependencies (`security-review`).
2. **Hard Red Gate Invariant**:
   - Never write or suggest application code fixes until QA has produced a deterministic failing test (Red).
3. **The 3-Commit Gate Standard & Persistent Triage**:
   - Every bug fix branch must feature exactly 3 sequenced, atomic conventional commits:
     1. `test(<scope>): reproduce <issue-id> failure (Red Gate)` (Triage brief + repro script + Red report).
     2. `fix(<scope>): resolve <root-cause> in <components>` (Application diff + RCA document).
     3. `docs(<scope>): record QA verification and security audit` (QA Green report + Security clearance).
   - `.triage/<issue-id>/` is permanently tracked in version control and merged into `main`. Never `.gitignore` `.triage/`.
4. **3-Strike Circuit Breaker**:
   - Cap fix attempts at 3. If QA or Security rejects 3 times, reset the working tree, compile `failure-debrief.md`, and halt for human guidance.
5. **Autonomous PR Creation & Human Review**:
   - Once all 3 commits are sealed, Coordinator pushes the branch to `origin` and runs `gh pr create` with the full verification matrix table. The human acts as the final gatekeeper on GitHub before merge.
