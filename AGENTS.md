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

---

## 3. Bug Triage & Resolution Agent Team

When working on defect resolution, triage, or running `/triage-orchestrator`:

1. **The 4 Agent Roles**:
   - **Coordinator Agent**: Oversees workflow, intake sanitization (`/bug-triage`), early topic branch creation (`fix/<issue-id>-<slug>`), persistent triage records (`.triage/<issue-id>/`), and automated PR synthesis (`/pr-creation`).
   - **QA Agent**: Responsible for the Hard Red Gate reproduction test and Commit 1 (`/test-generation`), Green verification, and Two-Axis Code Review (`/code-review`).
   - **Developer Agent**: Performs Root Cause Analysis (3–5 hypotheses) and authoring minimal fixes + Commit 2 (`/diagnosing-bugs`).
   - **Security Agent**: Pre-commit secret scanning, injection auditing, and OWASP review (`/security-review`).
2. **Hub-and-Spoke Invariant**:
   - Subagents communicate solely through the Coordinator; no unmediated peer-to-peer discussions.
3. **The Red Gate Invariant**:
   - Developer is strictly barred from editing application code until QA produces an automated failing test (Red).
4. **The 3-Commit Gate Standard & Persistent Triage**:
   - Every bug fix branch must feature exactly 3 sequenced, atomic conventional commits:
     - **Commit 1**: `test(<scope>): reproduce <issue-id> failure (Red Gate)` (Triage brief + reproduction script + Red report).
     - **Commit 2**: `fix(<scope>): resolve <root-cause> in <components>` (Application diff + RCA document).
     - **Commit 3**: `docs(<scope>): record QA verification, security audit, and doc sync` (QA Green report + Security clearance + staged repository or topic documentation updates per ADR 0010).
   - `.triage/<issue-id>/` is permanently tracked in version control and merged to `main`. Never `.gitignore` `.triage/`.
5. **Circuit Breaker**:
   - 3-iteration fix budget. On the 3rd failure, the Coordinator executes `git reset`, writes a Failure Debrief, and halts for user consultation.
6. **PR Creation & Human Review**:
   - Once all 3 commits are sealed, Coordinator pushes to `origin` and opens a PR via `gh pr create` with the full verification matrix table. The human acts as the final gatekeeper on GitHub before merge.

---

## 4. Feature Development Agent Team

When building new features, functionalities, or running `/feature-orchestrator`:

1. **The 4 Agent Roles**:
   - **Coordinator Agent**: Oversees intake, conducts interactive Socratic grilling (`/feature-spec` via `grill-with-docs`) in the main chat with the user, logs ADRs, scaffolds persistent specification bundle, cuts topic branch (`feat/<feature-id>-<slug>`), and synthesizes the PR (`/pr-creation`).
   - **QA Agent**: Translates Gherkin specifications into an executable failing acceptance test suite (Commit 1: `test(<scope>): define acceptance test suite for <feature-id>`), verifies Green acceptance status, and conducts Two-Axis Code Review (`/code-review`).
   - **Developer Agent**: Implements the minimal code diff required to satisfy the specification and turn acceptance tests Green (Commit 2: `feat(<scope>): implement <feature-id> per spec`).
   - **Security Agent**: Performs pre-commit security audits checking for credentials, injection vulnerabilities, and OWASP compliance (Commit 3: `docs(<scope>): record QA verification and security audit`).
2. **The Mandatory Grilling Gate Invariant**:
   - No subagent is dispatched and no code branch is cut until the Coordinator conducts the `grill-with-docs` interview directly with the user and the user explicitly signs off on the specification.
3. **The Acceptance Red Gate Invariant**:
   - Developer is strictly barred from modifying or creating application code until QA produces an automated failing acceptance test suite (Red).
4. **The 3-Commit Gate Standard & Context-Aware Persistence**:
   - Every feature branch must feature exactly 3 sequenced, atomic conventional commits:
     - **Commit 1**: `test(<scope>): define acceptance test suite for <feature-id>` (Spec bundle + failing tests + Red report).
     - **Commit 2**: `feat(<scope>): implement <feature-id> per spec` (Application diff + implementation notes).
     - **Commit 3**: `docs(<scope>): record QA verification, security audit, and doc sync` (QA Green report + Security clearance + staged repository or topic documentation updates per ADR 0010).
   - **Persistence Path**:
     - Repo-wide features: `.features/<feature-id>/`
     - Topic-specific features: `topics/<topic-name>/.features/<feature-id>/` (preserving topic isolation).
     - Permanently tracked in git. Never `.gitignore` `.features/`.
5. **Circuit Breaker**:
   - 3-iteration implementation budget. On the 3rd failure of QA or Security verification, Coordinator executes `git reset`, writes `failure-debrief.md`, and halts for user consultation.
6. **PR Creation & Human Review**:
   - Once all 3 commits are sealed, Coordinator pushes to `origin` and opens a PR via `gh pr create` with the full verification matrix table.

---

## 5. Continuous Documentation Synchronization (`doc-sync`)

Per ADR 0010, repository and topic documentation must never drift from code implementation:

1. **Execution Point (Phase 3.5)**:
   - Immediately following Phase 3 (Developer code changes), Coordinator executes `/doc-sync`.
2. **Context-Aware Scoping**:
   - Changes inside `topics/<topic-name>/` strictly update topic documentation (`topics/<topic-name>/GLOSSARY.md`, `reference/`, `MISSION.md`). Cross-topic or root modifications are strictly barred.
   - Changes at repository root strictly update root documentation (`CONTEXT.md`, `docs/adr/`, `README.md`, `index.html`).
3. **Hard QA Gate (Axis A)**:
   - QA Agent verifies that documentation diffs accompany all behavioral/interface changes.
   - If a code change has zero documentation impact, an explicit, justified `Documentation Impact: None` entry must be recorded in `.triage/<id>/rca.md` or `<feature-dir>/verification.md`.
4. **Commit 3 Packaging**:
   - All staged documentation changes are sealed inside Commit 3 (`docs(...)`) alongside QA and Security reports.
