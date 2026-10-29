---
name: test-generation
description: Build a deterministic failing reproduction test or script (Red Gate) before any bug fix code is authored.
argument-hint: "<issue-id or path to triage-brief.md>"
disable-model-invocation: true
origin: "workflow/triage-team (MIT)"
---

# Test Generation (The Red Gate)

Enforce the Hard QA-First Red Gate: construct an automated, deterministic test or command that reliably triggers the defect **before** any application code is touched.

> **Law of the Red Gate**: *No reproduction command = No fix allowed. Developers cannot edit production code until QA demonstrates a reproducible failure.*

---

## Responsibilities & Constraints
- **Role**: Executed by the **QA Agent**.
- **Boundaries**: Operates within test directories or ephemeral scripts. Does **not** modify application/production code.

---

## The 4-Step Reproduction Workflow

### Step 1: Ingest Triage Brief
Read `.triage/<issue-id>/triage-brief.md` to understand the reported defect, expected behavior, and suspected seam.

### Step 2: Select the Fastest Deterministic Harness
Inspect the repository's existing test infrastructure:
- Unit / Integration Test suites (`pytest`, `jest`, `vitest`, `dotnet test`, `cargo test`, `go test`).
- Shell scripts or minimal standalone CLI invocations.
- Write a minimal failing test file (e.g. `tests/repro_<issue-id>.*`) or an executable script `.triage/<issue-id>/reproduce.sh`.

### Step 3: Verify Deterministic Failure (Red)
Run the reproduction command. It **must fail** with the exact error, symptom, or assertion failure described in the bug report.
- **Flakiness Check**: If the defect involves asynchronous timing or concurrency, run the reproduction command multiple times (e.g. 10x) to confirm a measurable failure rate.
- **Budget**: QA has a maximum of **3 attempts** to formulate a successful reproduction script.
  - If reproduction fails on attempt 3, QA writes `.triage/<issue-id>/reproduction-report.md` marking the bug as **Irreproducible** with diagnostics, and halts for Coordinator escalation.

### Step 4: Record Reproduction Artifact
Once verified Red, write `.triage/<issue-id>/reproduction-report.md`:
```markdown
# Reproduction Report: [Issue ID]

- **Status**: RED (Verified Failing)
- **Reproduction Command**: `[Exact command to run]`
- **Reproduction File**: `[Path to test file]`

## Failure Output
```text
[Truncated stack trace / assertion failure]
```

## Gate Verification
- [x] Fails reliably on current codebase
- [x] Does not depend on undocumented external state
- [x] Ready for Developer RCA and fix
```
