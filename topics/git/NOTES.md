# Notes: Git Learning Workspace

Working scratchpad for capturing user preferences, pacing insights, and curriculum planning.

## Learner Profile & Preferences
- **Experience Level**: Beginner ("noob") wanting to build complete confidence from basic to advanced.
- **Tone & Style**: Plain and simple English. Start with "Why" (the real-world problem) and "How" (Git's conceptual solution).
- **Format Preference**: Animated visual concept demonstrations in interactive HTML lessons.
- **Primary Tool**: Terminal Command Line Interface (`git` CLI).

## Curated Curriculum Roadmap (15-Lesson End-to-End Master Plan)

### Module 1: The First Principles & The 3 Areas (Completed)
- **Lesson 0001 (Completed)**: Why We Need Git & The Snapshot Model (Folder Chaos vs Git Snapshots).
- **Lesson 0002 (Completed)**: The 3 Areas of Git: Working Directory, Staging Area, and Commit History.

### Module 2: History, Diffs & Hygiene (Immediate Next)
- **Lesson 0003**: Inspecting History, Diffs & Hygiene
  - *Core Concepts*: `git log --oneline --graph --decorate`, `git diff` vs `git diff --staged`, atomic commit discipline, and `.gitignore` patterns.
  - *Simulation*: Visual commit log tree inspector, diff colorizer, and `.gitignore` filter tester.

### Module 3: Branching & Merge Conflicts (Parallel Realities)
- **Lesson 0004**: Branches as Lightweight Movable Pointers
  - *Core Concepts*: What a branch actually is (a 41-byte ref file pointing to a commit SHA), `HEAD`, modern `git switch` and `git switch -c` (vs legacy `git checkout`).
  - *Simulation*: Dynamic pointer graph showing `HEAD` and branch labels moving with new commits.
- **Lesson 0005**: Fast-Forward vs Three-Way Merges
  - *Core Concepts*: The merge base, fast-forward pointer slide vs diverging branches and 3-way merge commits (`git merge`).
  - *Simulation*: Visual DAG animation contrasting fast-forward vs 2-parent merge commits.
- **Lesson 0006**: Battle-Tested Merge Conflicts
  - *Core Concepts*: Why conflicts happen, reading raw markers (`<<<<<<< HEAD`, `=======`, `>>>>>>>`), resolving in editor, staging with `git add`, and completing the merge.
  - *Simulation*: Interactive code editor with raw conflict markers, resolution validation, and `git merge --abort` fail-safe.

### Module 4: Remotes & Distributed Collaboration
- **Lesson 0007**: Remotes Demystified (`origin` & `clone`)
  - *Core Concepts*: Remote tracking branches (`origin/main`), `git remote add`, `git clone`, and upstream linking (`git push -u origin main`).
  - *Simulation*: Dual-pane view showing local repo vs mock `origin` server repository.
- **Lesson 0008**: Team Synchronization (`fetch`, `pull`, `push`)
  - *Core Concepts*: The critical difference between `git fetch` (safe inspect) and `git pull` (`fetch + merge`), handling rejected pushes.
  - *Simulation*: Animated commit packets moving over the network wire between local and remote.

### Module 5: The Time Machine (Undoing Mistakes Safely)
- **Lesson 0009**: Discarding Uncommitted Work (`git restore`)
  - *Core Concepts*: Unstaging changes (`git restore --staged <file>`) and reverting working tree edits (`git restore <file>`).
  - *Simulation*: Three-areas slider demonstrating unstage and discard actions without touching commit history.
- **Lesson 0010**: Safe Undos vs History Rewrites (`git revert` vs `git reset`)
  - *Core Concepts*: `git revert` for safe public undo commits vs `git reset` (`--soft`, `--mixed`, `--hard`) for private local branch rewinds.
  - *Simulation*: Visual comparison of moving the branch pointer backwards vs appending an inverse commit.

### Module 6: Clean History & Advanced Rebasing
- **Lesson 0011**: Shelving Work in Progress (`git stash`)
  - *Core Concepts*: Context-switching without committing, `git stash push`, `pop`, `list`, `apply`, `drop`.
  - *Simulation*: Visual clipboard shelf where dirty working state is stored and restored.
- **Lesson 0012**: Rebase vs Merge (The Clean Linear History Debate)
  - *Core Concepts*: Replaying commits on top of updated `main` (`git rebase main`), comparing merge bubbles vs linear DAGs, the Golden Rule of Rebasing (never rebase public shared branches).
  - *Simulation*: Commits detaching and re-attaching on top of updated base commit.
- **Lesson 0013**: PR-Ready Interactive Rebase (`git rebase -i`)
  - *Core Concepts*: Cleaning messy commit history before review: `pick`, `squash`, `reword`, `fixup`, and safe updating with `git push --force-with-lease`.
  - *Simulation*: Interactive rebase editor where student reorders and squashes commits into a single clean commit.

### Module 7: Recovery Safety Nets & Git Internals
- **Lesson 0014**: The Ultimate Safety Net (`git reflog` & Detached HEAD)
  - *Core Concepts*: Recovering "deleted" commits and branches using `git reflog`, understanding and rescuing detached HEAD states.
  - *Simulation*: Reflog timeline showing historical HEAD pointers and restoring an orphaned commit into a named branch.
- **Lesson 0015**: Under the Hood: The Git Object Store
  - *Core Concepts*: The `.git` directory anatomy: Blobs (content), Trees (directories), Commits (metadata & parents), Annotated Tags, and SHA hashing.
  - *Simulation*: Interactive object graph showing how Git reconstructs project directories from SHA objects.

---

## Architectural & Pedagogical Invariants
- All lessons delivered as self-contained HTML interactive lessons in `topics/git/lessons/`.
- Companion quick-reference guides stored in `topics/git/reference/`.
- Modern CLI verbs (`git switch`, `git restore`) taught as primary; legacy `git checkout` noted for historical clarity.
- Interactive labs emulate realistic terminal commands and syntax validation.
