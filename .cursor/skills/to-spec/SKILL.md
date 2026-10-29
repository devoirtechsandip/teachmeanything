---
name: to-spec
description: Synthesizes discussions, plans, and architectural decisions into a structured specification document before writing code or lessons.
argument-hint: "[--out=<path>] [spec-title or feature-description]"
disable-model-invocation: true
origin: "github.com/mattpocock/skills (MIT)"
---

# To-Spec

Synthesize the preceding conversation, research, glossary definitions, and architectural decisions into an unambiguous, formal specification document.

## Philosophy

- **Decisions Upstream**: `/to-spec` does **not** interview or interrogate the user. The deciding phase happened upstream (e.g. during `/grill-with-docs` or `/grill-me`). This skill records what was decided, with zero ambiguous placeholders.
- **Seams Before Prose**: Identify explicit verification seams (test endpoints, DOM selectors, CLI verification commands) before authoring the full prose.

## Specification Structure

When drafting the spec (saved to `docs/specs/YYYY-MM-DD-<slug>.md` or inside `topics/<topic>/reference/`):

1. **Overview & Goal**:
   - Concise summary of the feature, curriculum unit, or system capability.
   - Non-goals (explicitly what is *out* of scope).
2. **User Journey & Workflows**:
   - Step-by-step interaction paths for learners or users.
   - Edge cases, error handling, and recovery flows.
3. **Architecture & File Inventory**:
   - New files to create and existing files to modify.
   - Data structures, state representations, and schema definitions.
4. **Testing & Verification Seams**:
   - Concrete test cases, expected inputs/outputs, and automated or manual checks that prove completion.
5. **Rollout & Phasing**:
   - Suggested logical milestones for breaking the work into vertical-slice tickets via `/to-tickets`.
