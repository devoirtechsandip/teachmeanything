---
name: test-generation
description: Build a deterministic failing reproduction test or script (Red Gate) and record Commit 1 of the sequenced lifecycle.
argument-hint: "<issue-id or path to triage-brief.md>"
disable-model-invocation: true
origin: "workflow/triage-team (MIT)"
---

# Test Generation (The Red Gate)

Enforce the Hard QA-First Red Gate: construct an automated, deterministic test or command that reliably triggers the defect **before** any application code is touched, and seal Commit 1 on the fix branch.

> **Law of the Red Gate**: *No reproduction command = No fix allowed. Developers cannot edit production code until QA demonstrates a reproducible failure.*

---

## Responsibilities & Constraints
- **Role**: Executed by the **QA Agent**.
- **Boundaries**: Operates within test directories or `.triage/<issue-id>/`. Does **not** modify application/production code.

---

## The 4-Step Reproduction Workflow

### Step 1: Ingest Triage Brief
Read `.triage/<issue-id>/triage-brief.md` to understand the reported defect, expected behavior, and suspected seam.

### Step 2: Select the Fastest Deterministic Harness
Inspect the repository's existing test infrastructure:
- Unit / Integration Test suites (`pytest`, `jest`, `vitest`, `dotnet test`, `cargo test`, `go test`).
- Shell scripts or minimal standalone CLI invocations.
- Write a minimal failing test file or an executable script `.triage/<issue-id>/reproduce.*`.

### Step 3: Verify Deterministic Failure (Red)
Run the reproduction command. It **must fail** with the exact error, symptom, or assertion failure described in the bug report.
- **Flakiness Check**: If the defect involves asynchronous timing or concurrency, run the reproduction command multiple times (e.g. 10x) to confirm a measurable failure rate.
- **Budget**: QA has a maximum of **3 attempts** to formulate a successful reproduction script.
  - If reproduction fails on attempt 3, QA writes `.triage/<issue-id>/reproduction-report.md` marking the bug as **Irreproducible** with diagnostics, and halts for Coordinator escalation (Coordinator will switch to `main` and delete the local topic branch).

### Step 4: Record Reproduction Artifact & Seal Commit 1
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

Per [ADR 0007](file:///workspaces/teachmeanything/docs/adr/0007-sequenced-commit-git-lifecycle-and-persistent-triage.md), seal **Commit 1** of the sequenced git lifecycle:
```bash
git add .triage/<issue-id>/triage-brief.md .triage/<issue-id>/reproduce.* .triage/<issue-id>/reproduction-report.md
git commit -m "test(<subsystem>): reproduce <issue-id> failure (Red Gate)"
```
