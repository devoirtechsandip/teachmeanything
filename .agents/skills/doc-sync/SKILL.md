---
name: doc-sync
description: Autonomous multi-layer documentation synchronization skill updating ubiquitous language, architecture ADRs, user guides, and topic references per ADR 0010.
argument-hint: "[--scope=topic:<topic-name> | --scope=repo] [--check-only]"
disable-model-invocation: true
origin: "workflow/doc-sync (MIT)"
---

# Continuous Documentation Synchronization (`doc-sync`)

Specialized documentation synchronization skill invoked during bug triage ([`triage-orchestrator`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/.agents/skills/triage-orchestrator/SKILL.md)) and feature enhancement ([`feature-orchestrator`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/.agents/skills/feature-orchestrator/SKILL.md)) to audit git diffs, synchronize living repository documentation, and prevent documentation drift per [ADR 0010](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/docs/adr/0010-continuous-documentation-synchronization.md).

---

## 1. Scope Resolution & Topic Boundary Mandate

Before inspecting or editing files, `doc-sync` determines the active change seam from `git status` / `git diff`:

### Case A: Topic-Scoped Change (`topics/<topic-name>/...`)
- **Strict Boundary**: All edits are strictly confined to `topics/<topic-name>/`.
- **Target Documentation**:
  - `topics/<topic-name>/GLOSSARY.md` (Domain terminology, acronyms, data types)
  - `topics/<topic-name>/MISSION.md` (Curriculum goals, learning objectives)
  - `topics/<topic-name>/reference/` (Cheat sheets, visual reference cards, ADRs)
  - `topics/<topic-name>/RESOURCES.md` (Curated external references)
- **Forbidden**: Never touch root `CONTEXT.md`, root `README.md`, or files belonging to other topics.

### Case B: Repository-Scoped Change (root scripts, orchestrators, `.agents/`, root dashboard)
- **Target Documentation**:
  - `CONTEXT.md` (Ubiquitous language, multi-agent roles, capabilities, state machines)
  - `docs/adr/` (Architectural decision records)
  - `README.md` (System capabilities, setup, slash command guides)
  - `index.html` (Learning hub catalog, lesson cards, status badges)
- **Forbidden**: Do not alter topic-specific `GLOSSARY.md` or topic `lessons/`.

---

## 2. Multi-Layer Adaptive Synchronization Workflow

`doc-sync` executes a 4-tier inspection against the unstaged and staged code diffs:

```text
               [Inspect git diff & modified files]
                                │
       ┌────────────────────────┼────────────────────────┐
       ▼                        ▼                        ▼
[Tier 1: Terms & APIs]  [Tier 2: Architecture]   [Tier 3: User Guides]
  CONTEXT.md /             docs/adr/ /              README.md /
  GLOSSARY.md              reference/               index.html
       │                        │                        │
       └────────────────────────┼────────────────────────┘
                                │
                                ▼
               [Documentation Impact Assessment]
                     │                    │
          (Changes Detected)       (No Changes Needed)
                     │                    │
                     ▼                    ▼
             [Stage Doc Diffs]    [Write Exemption Rationale]
```

### Tier 1: Ubiquitous Language & APIs
- Inspect modified function signatures, classes, commands, flags, or configuration keys.
- If a new concept, role, state, or term is introduced or refined:
  - Add canonical entry to [`CONTEXT.md`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/CONTEXT.md) (Repo scope) or `topics/<topic>/GLOSSARY.md` (Topic scope).
  - Update state machine ASCII/mermaid diagrams if lifecycle states changed.

### Tier 2: Architecture Decision Records (ADRs)
- If a structural decision, new dependency, lifecycle change, or protocol invariant was established:
  - Scaffold the next sequential ADR in `docs/adr/000X-<slug>.md` (Repo) or `topics/<topic>/reference/000X-adr-<slug>.md` (Topic).
  - Capture: Status, Context, Decision, and Consequences.

### Tier 3: Operational Guides & Readme
- If user-facing CLI commands, agent skills, scripts, or operational procedures were modified:
  - Update syntax and usage examples in [`README.md`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/README.md).
  - Verify all markdown links remain valid.

### Tier 4: Learning Hub Dashboard & Catalogs
- If interactive lessons, exercises, or visual simulators were added/modified:
  - Update lesson cards, badges, and links in [`index.html`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/index.html).
  - Update topic `MISSION.md` status metrics.

---

## 3. Exemption Rationale Policy

If `doc-sync` determines that a bug fix or refactoring has **zero documentation impact** (e.g., internal algorithmic bug fix, off-by-one correction, styling adjustment):
1. **Never exit silently.**
2. Record an explicit justification in the active triage or feature record:
   - For Bugs: Append to `.triage/<issue-id>/rca.md`
   - For Features: Append to `<feature-dir>/verification.md`
3. **Format**:
   ```markdown
   ### Documentation Impact Assessment
   - **Status**: None
   - **Rationale**: The defect fix was restricted to internal loop indexing in `component.js` with zero behavioral, API, or architectural changes. Existing user guides and ubiquitous terms in CONTEXT.md remain completely accurate.
   ```

---

## 4. Lifecycle Integration & Git Staging

1. **Execution Point (Phase 3.5)**:
   - Run immediately after Phase 3 (Developer code authoring) and before Phase 4 (QA review).
2. **Review Point (Phase 4)**:
   - QA Agent inspects staged documentation changes (or verified exemption rationale) in **Axis A (Standards & Documentation)**.
3. **Sealing Point (Phase 6)**:
   - Coordinator stages all updated documentation files together with `qa-report.md` and `security-audit.md`:
   ```bash
   git add <updated-docs> .triage/<issue-id>/qa-report.md .triage/<issue-id>/security-audit.md
   git commit -m "docs(<scope>): record QA verification, security audit, and doc sync"
   ```
