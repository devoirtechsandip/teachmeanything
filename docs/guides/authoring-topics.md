# Guide: Authoring & Registering New Learning Topics

A comprehensive guide for learners, educators, and autonomous agents authoring new topic tracks within the **TeachMeAnything Learning Hub**, adhering strictly to [AGENTS.md](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/AGENTS.md) and [ADR 0001](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/docs/adr/0001-native-antigravity-subagents-and-skills.md).

---

## 1. The Core Principle: Strict Topic Isolation

Every learning domain is an isolated universe housed strictly under its own directory: `topics/<topic-name>/`.

### Rules of Isolation
1. **Zero Cross-Contamination**:
   - When working on Topic A (e.g. `topics/git/`), agents and authors **MUST NOT** import, link, reference, or assume knowledge from Topic B (e.g. `topics/dotnet/`).
   - Learning records, terminology, and mission goals must never leak between topic workspaces.
2. **Decoupled Assets**:
   - Topic assets (`topics/<topic-name>/assets/`) are strictly private to that topic.
   - The root hub landing page uses root assets (`assets/css/hub.css`) and never depends on internal topic styles.

---

## 2. Canonical Directory Structure

Each topic must mirror the standardized anatomy scaffolded from `topics/_template/`:

```text
topics/<topic-name>/
├── MISSION.md           # Grounding purpose, success criteria, and out-of-scope boundaries
├── RESOURCES.md         # Curated, high-trust sources and official documentation
├── GLOSSARY.md          # Canonical vocabulary established and promoted for THIS topic
├── NOTES.md             # Working scratchpad for learner preferences and pacing
├── lessons/             # Self-contained HTML interactive lessons (0001-slug.html, ...)
├── learning-records/    # Sequential insight records (0001-slug.md, ...)
├── reference/           # Visual cheat sheets, algorithm guides, and syntax cards
└── assets/              # Topic-specific reusable components, simulators, or styles
```

---

## 3. Step-by-Step Onboarding Lifecycle

### Step 1: Scaffold Workspace
To create a new topic (e.g. `kubernetes`):

```bash
cp -r topics/_template/ topics/kubernetes/
```

Or prompt your AI assistant in chat:
> *"I want to learn Kubernetes"* (The agent automatically scaffolds `topics/kubernetes/` from `topics/_template/`).

### Step 2: Establish the Mission & Resources
1. Edit `topics/<topic-name>/MISSION.md` with:
   - **Why**: The core motivation for learning this topic.
   - **Success looks like**: 4–6 concrete competency milestones.
   - **Constraints**: Versions, target frameworks, or hardware limits.
   - **Out of scope**: What is deliberately excluded to maintain focus.
2. Populate `topics/<topic-name>/RESOURCES.md` with official documentation, books, and high-trust specifications.

### Step 3: Interactive Lesson Authoring
- Lessons are self-contained HTML5 files located in `topics/<topic-name>/lessons/`.
- **Naming Convention**: `0001-slug.html`, `0002-slug.html`, etc.
- **Design Tokens**: Inherit design variables (`--bg-surface`, `--text-primary`, `--accent-cyan`) and support both light/dark themes.
- **Accessibility**: All interactive simulator buttons, inputs, and tab stops must support keyboard navigation (`:focus-visible`).

### Step 4: Staging Build Validation
The public deliverables (`lessons/`, `reference/`, and `assets/`) are packaged into `dist/` by the staging engine:

```bash
bash scripts/build-site.sh dist
```

Internal governance files (`MISSION.md`, `GLOSSARY.md`, `NOTES.md`, and `learning-records/`) are automatically excluded from the public web build.

### Step 5: Dashboard Registration
Once a topic has initial lessons or reference cards:
1. Open `index.html`.
2. Add a new `<article class="topic-card">` entry inside `<main id="main-content" class="topic-grid">`.
3. Provide topic title, badge status (`Active Track` or `Scaffolding`), and links to available lessons and cheat sheets.
4. Run `bash scripts/test.sh` to confirm link integrity.

---

## 4. Verification Checklist

Before opening a pull request for a new topic:
- [ ] Topic files reside strictly under `topics/<topic-name>/`.
- [ ] No relative paths reach outside `topics/<topic-name>/` (except linking back to `./index.html`).
- [ ] All HTML lessons use semantic markup and high-contrast `:focus-visible` focus rings.
- [ ] Staging and link verification succeeds: `bash scripts/test.sh`.
