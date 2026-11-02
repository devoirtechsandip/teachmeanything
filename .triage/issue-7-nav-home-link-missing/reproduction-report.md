# QA Reproduction Report: Issue #7 (Red Gate)

- **Execution Command**: `bash .triage/issue-7-nav-home-link-missing/reproduce.sh`
- **Exit Code**: 1 (FAILURE / RED)
- **Timestamp**: 2026-11-03

## Failure Summary
- **Tested Files**: 30 (15 lesson files, 15 reference files)
- **Failing Files**: 30
- **Passing Files**: 0

## Findings
All 15 lesson pages (`topics/git/lessons/0001` through `0015`) and all 15 reference cards (`topics/git/reference/01` through `15`) lack any link or anchor pointing to `../../../index.html` with label or title `Hub Home`. 
The brand link points to `0001-why-git-and-the-snapshot-model.html` (or `#`), creating a navigation dead-end that traps learners within the topic workspace.

## Hard Red Gate Verdict
**RED GATE CONFIRMED**. Deterministic failing reproduction established. Developer Agent is authorized to implement the fix.
