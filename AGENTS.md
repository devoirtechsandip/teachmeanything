# Agent Instructions: Multi-Topic Learning Hub

This repository is a structured, multi-topic learning environment driven by the **`teach`** / **`teachme`** skill (Matt Pocock). It is designed to train learners across diverse topics over multi-session journeys while maintaining strict topic separation.

---

## 1. Absolute Rule: Strict Topic Isolation

Every learning topic is housed in its own dedicated directory under `topics/<topic-name>/` (e.g., `topics/git/`, `topics/dotnet/`).

### Boundary & Isolation Mandate
1. **Zero Cross-Contamination**:
   - Each topic is an isolated, self-contained universe.
   - When working on Topic A (e.g., `topics/git/`), agents **MUST NOT** read, reference, cross-link, import, or assume knowledge from Topic B (e.g., `topics/dotnet/`), and vice versa.
   - Never leak learning records, terminology, mission goals, or progress across different topic directories.
2. **Self-Contained Structure**:
   Each topic directory contains its own complete teaching workspace:
   ```text
   topics/<topic-name>/
   ├── MISSION.md           # Grounding purpose, goals, and scope for THIS topic only
   ├── RESOURCES.md         # Curated, high-trust sources and communities for THIS topic
   ├── GLOSSARY.md          # Canonical vocabulary established for THIS topic
   ├── NOTES.md             # Scratchpad for user preferences and pacing on THIS topic
   ├── lessons/             # Self-contained HTML interactive lessons (0001-slug.html, ...)
   ├── learning-records/    # Sequential insight records (0001-slug.md, ...)
   ├── reference/           # Quick-reference sheets, algorithms, and syntax guides
   └── assets/              # Reusable components shared across lessons of this topic
   ```

---

## 2. Topic Routing & Execution Flow

When a user initiates or resumes a session (e.g., "teach me git", "let's continue dotnet", or invokes `/teach` / `/teachme`):

1. **Identify the Active Topic**:
   - Resolve the target topic from the user's prompt (e.g., `git`, `dotnet`).
   - If the user runs `/teach` without specifying a topic, ask which topic they wish to work on from `topics/`, or offer to initialize a new one.
2. **New Topic Scaffolding**:
   - If the requested topic directory does not exist, scaffold it by copying `topics/_template/` to `topics/<topic-name>/`.
   - Never initialize topic files in the repository root.
3. **Workspace Scoping**:
   - Set the effective teaching workspace strictly to `topics/<topic-name>/`.
   - Workspace paths (`./lessons/`, `./learning-records/`, etc.) mentioned in the `teach` skill resolve relative to `topics/<topic-name>/`.
4. **Session Grounding**:
   - Always read `topics/<topic-name>/MISSION.md` to ground the current lesson.
   - Consult `topics/<topic-name>/learning-records/` to determine the user's current frontier (Zone of Proximal Development).
   - Draw knowledge exclusively from `topics/<topic-name>/RESOURCES.md`, not unverified parametric assumptions.
5. **Output Writing**:
   - Save all lesson files strictly to `topics/<topic-name>/lessons/`.
   - Save all learning records strictly to `topics/<topic-name>/learning-records/`.
   - Record canonical terms strictly in `topics/<topic-name>/GLOSSARY.md`.
   - Save cheat sheets/reference cards strictly to `topics/<topic-name>/reference/`.
