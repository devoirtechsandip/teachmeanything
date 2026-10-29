---
name: test-generation
description: Build a deterministic failing reproduction test or feature acceptance test suite (Red Gate) and record Commit 1 of the sequenced lifecycle.
argument-hint: "<issue-id or feature-id, or path to brief/spec>"
disable-model-invocation: true
origin: "workflow/triage-team (MIT)"
---

# Test Generation (The Red Gate)

Enforce the Hard QA-First Red Gate: construct an automated, deterministic test suite or reproduction command that reliably fails (turns **Red**) **before** any application or feature code is touched, and seal Commit 1 on the topic branch.

> **Law of the Red Gate**: *No failing test = No code allowed. Developers cannot edit production code or implement features until QA demonstrates a deterministic Red test.*

---

## Responsibilities & Constraints
- **Role**: Executed by the **QA Agent**.
- **Boundaries**: Operates within test directories, `.triage/<issue-id>/`, or `<feature-dir>/`. Does **not** modify application/production code.

---

## Operating Modes

### Mode A: Defect Reproduction (Bug Triage)
When resolving bugs or issues:
1. **Ingest Triage Brief**: Read `.triage/<issue-id>/triage-brief.md` to identify the defect, expected behavior, and suspected seam.
2. **Select Harness**: Build minimal test file or executable script `.triage/<issue-id>/reproduce.*`.
3. **Verify Red**: Run the reproduction command. It **must fail** with the exact error described in the bug report.
4. **Budget**: Maximum 3 attempts. If irreproducible, mark in `reproduction-report.md` and escalate to Coordinator.
5. **Seal Commit 1**:
   ```bash
   git add .triage/<issue-id>/triage-brief.md .triage/<issue-id>/reproduce.* .triage/<issue-id>/reproduction-report.md
   git commit -m "test(<subsystem>): reproduce <issue-id> failure (Red Gate)"
   ```

### Mode B: Acceptance Test Generation (Feature Development)
When building new features:
1. **Ingest Feature Specification**: Read `<feature-dir>/spec.md` and `feature-brief.md` to extract the Gherkin scenarios (`Given / When / Then`).
2. **Construct Acceptance Suite**:
   - Write automated unit, integration, or contract tests matching each scenario in `spec.md`.
   - Place tests into appropriate test directories or `<feature-dir>/acceptance-tests.*`.
3. **Verify Red**: Run the acceptance suite. Because the feature is not yet implemented, the suite **must fail deterministically (Red)** on missing classes, endpoints, or unmet assertions.
4. **Budget**: Maximum 3 formulation attempts. If tests cannot be compiled or formulated, escalate to Coordinator for specification clarification.
5. **Seal Commit 1**:
   ```bash
   git add <feature-dir>/feature-brief.md <feature-dir>/grilling-records.md <feature-dir>/spec.md <test-files> docs/adr/ CONTEXT.md
   git commit -m "test(<subsystem>): define acceptance test suite for <feature-id>"
   ```

---

## Verification Artifact Template
Save the test run proof to `<artifact-dir>/reproduction-report.md` (for bugs) or `<feature-dir>/acceptance-report.md` (for features):
```markdown
# [Reproduction | Acceptance Test] Report: [ID]

- **Status**: RED (Verified Failing)
- **Execution Command**: `[Exact test runner command]`
- **Test File(s)**: `[Path to test files]`

## Failure Output
```text
[Truncated test failure / assertion trace]
```

## Gate Verification
- [x] Fails deterministically on unpatched codebase
- [x] Directly exercises target scope without external flaky dependencies
- [x] Ready for Developer implementation
```
