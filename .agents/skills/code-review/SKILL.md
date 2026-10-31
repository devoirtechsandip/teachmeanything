---
name: code-review
description: Perform a disciplined two-axis code review evaluating changes across Standards (conventions & quality) and Spec (originating requirements) independently.
argument-hint: "[fixed-point-ref (e.g. main, HEAD~1, commit-hash)]"
disable-model-invocation: true
origin: "github.com/mattpocock/skills (MIT)"
---

# Code Review

Perform an objective, rigorous code review of pending diffs against a fixed git reference point.

## The Two Independent Axes

Code reviews frequently fail because reviewers conflate personal stylistic preferences with whether the code actually does what was requested. This skill strictly splits evaluation into two isolated axes:

```text
                  ┌───────────────────────┐
                  │      Git Diff         │
                  └──────────┬────────────┘
                             │
            ┌────────────────┴────────────────┐
            ▼                                 ▼
   Axis A: Standards                  Axis B: Spec
   - Repository Conventions           - Does it meet requirements?
   - Clean Code & Maintainability    - Are edge cases handled?
   - Architecture & Idioms            - Are non-goals respected?
```

### Axis A: Standards
- Inspect repository documentation (e.g., `CONTRIBUTING.md`, `CODING_STANDARDS.md`, rule files, or existing canonical patterns).
- Evaluate naming, abstraction levels, accessibility, semantic HTML, modularity, and error handling.
- **Documentation Freshness Gate (ADR 0010)**:
  - Verify that living documentation was synchronized via `/doc-sync` for all behavioral/architectural/API changes.
  - Check that relevant terms are added to `CONTEXT.md` / `GLOSSARY.md`, new patterns are captured in ADRs, and guides (`README.md`, `index.html`) are updated.
  - If code changed without accompanying documentation updates, verify that an explicit, justified `Documentation Impact: None` rationale is recorded in `.triage/<id>/rca.md` or `<feature-dir>/verification.md`. Reject if unjustified or missing.
- Surface antipatterns or regressions.

### Axis B: Spec
- Cross-reference the changes with the originating issue, spec (`docs/specs/*.md`), ticket, or user prompt.
- Verify that all requested functionality is present and correctly hooked up.
- Check that the implementation does not introduce out-of-scope bloat or scope creep.

---

## Review Execution Rules

1. **Require a Fixed Point**: Prompt for or resolve a fixed git reference (e.g. `main`, `HEAD~1`, branch name) before proceeding. Never review an ambiguous or undefined diff.
2. **Never Merge or Average Scores**: A diff can be 100% compliant with Standards while failing the Spec (building the wrong thing cleanly), or satisfy the Spec while violating Standards. Report both axes side-by-side without blending them into a single muddy verdict.
3. **Actionable Findings**:
   - Categorize issues by severity: **Critical (Blocker)**, **Major (Fix Before Merge)**, and **Minor / Suggestion**.
   - Provide concrete file paths, line references, and suggested replacements.
