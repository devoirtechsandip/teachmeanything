# Feature Brief: Git Advanced Curriculum (Modules 2–7, Lessons 0003–0015)

## 1. Executive Summary
Expand the Git Mastery Hub from basic foundational lessons (Lessons 0001 & 0002) to complete command-line interface (CLI) mastery spanning 7 comprehensive modules. Deliver self-contained, interactive HTML lessons featuring runnable simulators (DAG trees, diff inspectors, conflict resolvers, dual-pane remote simulators, and object store explorers), paired with companion quick-reference cheat sheets, learning records, and verified build pipelines.

## 2. Problem Statement
Learners who understand initial staging and commits frequently stumble when transitioning to team workflows:
- Unclear mental model of branches as movable pointers vs directory copies.
- Anxiety and paralysis when encountering raw merge conflicts (`<<<<<<<`, `=======`, `>>>>>>>`).
- Ambiguity surrounding `git fetch` vs `git pull` and remote tracking branches (`origin/main`).
- Fear of breaking repository history when undoing mistakes or cleaning commits with interactive rebasing.

## 3. Scope & Target Curriculum
- **Module 2: Daily Workflow & Hygiene**
  - Lesson 0003: Inspecting History, Diffs & Hygiene
- **Module 3: Branching & Merge Conflicts**
  - Lesson 0004: Branches as Lightweight Movable Pointers
  - Lesson 0005: Fast-Forward vs Three-Way Merges
  - Lesson 0006: Battle-Tested Merge Conflicts
- **Module 4: Remotes & Distributed Collaboration**
  - Lesson 0007: Remotes Demystified (`origin`, `clone`, tracking branches)
  - Lesson 0008: Team Synchronization (`fetch`, `pull`, `push`)
- **Module 5: The Time Machine (Undoing Mistakes)**
  - Lesson 0009: Discarding Uncommitted Work (`git restore`)
  - Lesson 0010: Safe Undos vs History Rewrites (`git revert` vs `git reset`)
- **Module 6: Clean History & Advanced Rebasing**
  - Lesson 0011: Shelving Work in Progress (`git stash`)
  - Lesson 0012: Rebase vs Merge (The Clean Linear History Debate)
  - Lesson 0013: PR-Ready Interactive Rebase (`git rebase -i`)
- **Module 7: Recovery Safety Nets & Git Internals**
  - Lesson 0014: The Ultimate Safety Net (`git reflog` & Detached HEAD)
  - Lesson 0015: Under the Hood: The Git Object Store & Plumbing

## 4. Key Constraints & Non-Negotiables
- Strict Topic Isolation: All assets, references, records, and lessons reside exclusively within `topics/git/`.
- Modern CLI Verbs: Prioritize `git switch` and `git restore` as primary; contextualize legacy `git checkout`.
- Authentic Fidelity: Merge conflicts must teach raw conflict markers in simulated code views.
- Zero External Dependencies: All interactive visualizers are pure HTML/CSS/vanilla JS.
