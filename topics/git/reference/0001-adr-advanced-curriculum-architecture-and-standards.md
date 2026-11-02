# ADR 0001: Git Advanced Curriculum Architecture and Pedagogical Standards

- **Status**: Accepted
- **Date**: 2026-11-02
- **Topic**: `git`
- **Scope**: `topics/git/`

---

## Context
Following the completion of Lesson 0001 (*Why Git & Snapshot Model*) and Lesson 0002 (*The Three Areas & First Commit*), the learner requested a comprehensive curriculum plan for intermediate and advanced Git topics. 

To ensure the roadmap directly equips the learner for professional team software development while avoiding conceptual gaps or cognitive overload, a Socratic grilling session was conducted via `/grill-with-docs`.

Key tensions analyzed:
1. **Pacing vs Prerequisites**: Whether to skip directly to advanced tools (interactive rebase, cherry-pick, internals) or follow a progressive linear path through branching, merging, and remotes.
2. **Module 2 Granularity**: Whether to keep inspecting history (`git log`), diffing (`git diff`), atomic commits, and `.gitignore` split across 3 lessons or consolidate them into a single focused bridge lesson.
3. **Merge Conflict Pedagogical Fidelity**: Whether to present conflict resolution via high-level GUI abstractions or raw terminal conflict markers.
4. **Rebase Scope**: Whether to teach the full academic rebase surface area or focus strictly on PR hygiene (`squash`, `reword`, `fixup`).
5. **Command Modernity**: Whether to prioritize Git 2.23+ verbs (`git switch`, `git restore`) or older legacy commands (`git checkout`).

---

## Decisions

### 1. Progressive Linear Pathway
The curriculum will progress systematically across 7 cohesive modules:
- **Module 1**: First Principles & The 3 Areas (Lessons 0001–0002, Completed)
- **Module 2**: Inspecting History, Diffs & Hygiene (Lesson 0003)
- **Module 3**: Branching, Merging & Conflict Resolution (Lessons 0004–0006)
- **Module 4**: Remotes & Distributed Collaboration (Lessons 0007–0008)
- **Module 5**: The Time Machine & Undoing Mistakes (Lessons 0009–0010)
- **Module 6**: Clean History & Advanced Rebasing (Lessons 0011–0013)
- **Module 7**: Recovery Safety Nets & Git Internals (Lessons 0014–0015)

### 2. Consolidated Bridge Lesson 0003
Module 2 is consolidated into a single power lesson: **Lesson 0003: History, Diffs, and Hygiene**. It integrates:
- `git log --oneline --graph --decorate`
- `git diff` (working tree vs staging) and `git diff --staged` (staging vs last commit)
- Atomic commit hygiene & message conventions
- File exclusions with `.gitignore`

This clears the runway for branching mechanics immediately in Lesson 0004.

### 3. Raw Conflict Markers in Terminal Editor
Lesson 0006 will model conflict resolution with authentic fidelity: students will read raw Git conflict markers (`<<<<<<< HEAD`, `=======`, `>>>>>>> feature`), manually resolve code in a simulated in-browser editor, stage with `git add`, and finalize the merge commit.

### 4. PR-Ready Interactive Rebase Engine
Lesson 0013 will concentrate on production PR hygiene: using `git rebase -i` to clean up messy local commits using `pick`, `squash`, `reword`, and `fixup`, paired with safe remote publication using `git push --force-with-lease`.

### 5. Modern CLI Syntax Standard
All lessons will teach Git 2.23+ dedicated verbs as the primary standard:
- `git switch <branch>` / `git switch -c <new-branch>` for branch navigation
- `git restore <file>` / `git restore --staged <file>` for discarding changes
Legacy `git checkout` syntax will be explicitly explained as historical context for reading older tutorials and StackOverflow.

### 6. Dual-Pane Offline Remote Simulation
In Module 4, the self-contained HTML simulator will present a dual-pane visualization showing the local repository and the mock `origin` remote, visualizing packets and commit graphs moving across the wire during `fetch`, `pull`, and `push`.

---

## Consequences
- **Positive**: Direct alignment with real-world production expectations; removes friction when opening PRs or resolving team conflicts.
- **Positive**: Cohesive 15-lesson trajectory without bloated micro-lessons.
- **Effort**: Interactive HTML lessons require rich DAG rendering, interactive code editing for conflict markers, and dual-pane mock remotes.
