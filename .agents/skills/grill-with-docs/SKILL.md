---
name: grill-with-docs
description: A relentless interview to sharpen a plan, architecture, or lesson design, which actively creates docs (ADRs and glossary definitions) as decisions solidify.
argument-hint: "[--no-adr] [--single-round] <topic or plan to grill>"
disable-model-invocation: true
origin: "github.com/mattpocock/skills (MIT)"
---

# Grill With Docs

Grill with Docs conducts a relentless, dependency-aware Socratic interview to stress-test plans and architectural designs before writing code or lessons, while actively updating persistent repository documentation (ADRs and glossary definitions) as clarity emerges.

This skill integrates two foundational disciplines:
1. **Grilling**: The dependency-aware, round-by-round interrogation engine.
2. **Domain Modeling**: The active extraction of ubiquitous terms into `GLOSSARY.md` / `CONTEXT.md` and logging key architectural decisions as ADRs.

---

## When to Reach For This

- At the start of designing a new topic, curriculum module, interactive simulator, or significant feature.
- When an architecture or learning plan has ambiguities, unstated assumptions, or untested boundary conditions.
- When you want to ensure decisions aren't lost in the chat transcript, but captured immediately in persistent repository documentation.

---

## The Workflow

### Phase 1: Context & Frontier Mapping
1. **Read Existing Context**:
   - Inspect existing `MISSION.md`, `GLOSSARY.md`, and any `docs/adr/` or `reference/` files in the current topic or workspace.
   - Ground yourself in established terms; do not reinvent or contradict canonical terminology.
2. **Map the Decision Tree**:
   - Identify the user's primary goal.
   - Deconstruct the problem into a directed tree of decisions where foundational prerequisites branch into secondary implementation details.
   - Determine the active **frontier** (decisions whose prerequisites are resolved and can be addressed now).

### Phase 2: The Grilling Rounds
1. **Ask in Structured Rounds**:
   - Group 2–4 targeted questions per round addressing the active frontier.
   - Never ask premature questions about leaves whose parent branches remain undecided.
   - Stress-test assumptions: probe edge cases, scale limits, error states, and trade-offs.
   - Offer concrete options with clear trade-offs, recommending the simplest viable path.
2. **Push for Resolution**:
   - Challenge fuzzy answers or hand-waving.
   - If the user proposes a vague solution, present the failure mode and ask how they want to handle it.

### Phase 3: Active Documentation
As decisions crystallize during the dialogue:
1. **Glossary Updates**:
   - When a new domain term is introduced or refined, add or update its canonical definition in `GLOSSARY.md` (or `CONTEXT.md` for repo-wide scope) immediately.
2. **Architecture Decision Records (ADRs)**:
   - When an irreversible or significant technical choice is made, record it as an ADR (e.g., in `docs/adr/000X-<slug>.md` or `topics/<topic>/reference/000X-adr-<slug>.md`).
   - Capture: Context, Decision, Rationale, and Consequences.
3. **Confirm with User**:
   - Briefly notify the user of documented decisions: *"Noted in GLOSSARY.md: [Term]. Recorded ADR 0002: [Decision]."*

### Phase 4: Convergence
- Once all branches of the frontier are resolved and all edge cases are addressed, provide a concise summary of the solidified design and list the next steps (e.g., transition to `/to-spec` or `/to-tickets`).
