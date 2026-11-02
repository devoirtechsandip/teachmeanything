# Grilling Records: Git Advanced Curriculum Specification

## Grilling Session Metadata
- **Driver**: `/grill-with-docs`
- **Topic**: `git`
- **Date**: 2026-11-02
- **Objective**: Stress-test curriculum sequencing, pedagogical fidelity, and module granularity.

---

## Round 1: Curriculum Sequencing & Target Persona
- **Q1 (Progression Strategy)**: How should we sequence the curriculum from baseline (Lessons 1 & 2)?
  - *Options*: Progressive Linear Flow (Recommended) vs Accelerated Advanced Focus vs Emergency/Disaster First.
  - *Selection*: **Progressive Linear Flow** (Branching -> Merging -> Remotes -> Undos -> Rebase -> Internals).
- **Q2 (Practical Focus)**: What is your primary practical objective for these advanced topics?
  - *Selection*: **Professional Team Collaboration & Clean History** (Multi-branch workflows, painless conflict resolution, interactive rebase for PRs, atomic commits).
- **Q3 (Delivery Format)**: What format and practice depth do you want for upcoming lessons?
  - *Selection*: **Interactive Visual HTML Lessons** (Matching Lessons 0001 & 0002 with animated DAG simulators, interactive labs, and quizzes).

---

## Round 2: Granularity, Conflicts & Rebase Depth
- **Q1 (Module 2 Granularity)**: How should we handle Module 2 before entering Branching?
  - *Selection*: **Consolidated Power-Bridge (1 Lesson)**: Pack `git log --oneline --graph`, `git diff` (unstaged vs staged), atomic commits, and `.gitignore` into Lesson 0003.
- **Q2 (Conflict Simulation)**: For Lesson 0006 (Merge Conflicts), what hands-on resolution experience do you want in the simulator?
  - *Selection*: **Raw Conflict Markers in Simulated Editor**: Emulate true terminal reality with `<<<<<<< HEAD`, `=======`, `>>>>>>>`, manual editing, and staging.
- **Q3 (Rebase Scope)**: When we reach Module 6 (Interactive Rebase), what level of depth should we target?
  - *Selection*: **PR-Ready Core**: Focus on `squash`, `reword`, and `fixup` to transform messy local commits into clean, reviewable PR branches.

---

## Round 3: Command Modernity & Remote Simulation
- **Q1 (CLI Modernity)**: How should we approach branch switching and file restoration commands?
  - *Selection*: **Modern CLI First**: Teach `git switch` and `git restore` as primary, noting legacy `git checkout` for historical context.
- **Q2 (Remote Simulation)**: For Module 4 (Remotes), how should the offline interactive HTML lesson simulate remote repositories?
  - *Selection*: **Simulated Dual-Pane Remote Visualizer**: Visual side-by-side display of Local Repo and Remote Origin to watch commits fly across the wire during push/fetch/pull.

---

## Documentation Synchronization Record
- Recorded ADR: `topics/git/reference/0001-adr-advanced-curriculum-architecture-and-standards.md`
- Added 8 canonical domain terms to `topics/git/GLOSSARY.md`
- Updated roadmap in `topics/git/NOTES.md`
