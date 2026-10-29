---
name: improve-codebase-architecture
description: Survey codebase structure, identify architectural drift or duplication, and propose structured refactoring opportunities.
argument-hint: "[target-directory or module]"
disable-model-invocation: true
origin: "github.com/mattpocock/skills (MIT)"
---

# Improve Codebase Architecture

Periodically survey the repository to identify structural drift, repeated logic, tangled dependencies, or violations of workspace conventions.

## Architecture Audit Workflow

1. **Workspace Boundary & Isolation Audit**:
   - Check that topic isolation rules are upheld (e.g. `topics/<topic-a>/` does not reference or import from `topics/<topic-b>/`).
   - Verify that assets and shared components (CSS stylesheets, quiz widgets, simulators) are cleanly extracted to `./assets/` within the topic rather than duplicated across lessons.
2. **Cohesion & Coupling Analysis**:
   - Spot bloated files that handle multiple concerns (e.g. presentation, business logic, and data storage in one file).
   - Identify circular dependencies or leaky abstractions.
3. **Template & Standardization Verification**:
   - Check that all topic directories match the canonical `topics/_template/` structure.
   - Verify that lessons, learning records, and reference documents follow their respective standard formats (`MISSION-FORMAT.md`, `LEARNING-RECORD-FORMAT.md`, etc.).
4. **Actionable Proposals**:
   - Propose refactoring in small, verifiable steps.
   - Never perform destructive wholesale rewrites in a single pass; propose tracer-bullet changes backed by tests or visual checks.
