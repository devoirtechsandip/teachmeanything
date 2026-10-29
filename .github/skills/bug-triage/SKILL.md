---
name: bug-triage
description: Systematically ingest, sanitize, classify, and scope incoming software defect and issue reports, and initialize the isolated fix branch.
argument-hint: "<issue-description, error-log, or issue-number>"
disable-model-invocation: true
origin: "workflow/triage-team (MIT)"
---

# Bug Triage

Systematically ingest, sanitize, and scope incoming software defect reports, initialize the dedicated topic branch, and prepare the triage workspace before assigning tasks to diagnostic and verification agents.

## Responsibilities & Constraints
- **Role**: Executed by the **Coordinator Agent**.
- **Boundaries**: Focuses strictly on intake, data hygiene, defect boundary definition, and branch isolation. Does **not** write code fixes or reproduction tests directly.

---

## The 4-Step Triage Workflow

### Step 1: Sensitive Data Redaction
Scan the issue description, stack traces, and provided payloads for credentials, API tokens, cookies, auth headers, or private user data. 
- Replace all secrets with `<REDACTED>`.
- Invariant: No sensitive credentials may be written to triage artifacts.

### Step 2: Input Validation & Completeness Check
Check whether the report contains the minimum viable information required for reproduction:
- Expected behavior vs. actual observed behavior.
- Operating system, environment details, or runtime version.
- Step-by-step reproduction sequence or trigger payload.
- Error logs, terminal output, or stack traces.

*Decision Gate*: If the report lacks essential reproduction signals, halt the workflow immediately and output a structured **Clarification Request** detailing specifically what information is missing.

### Step 3: Scope & Severity Classification
- **Severity**:
  - `Blocker`: System crash, data loss, security exposure, or main workflow completely halted.
  - `Critical`: Key functionality broken with no workaround.
  - `Moderate`: Feature defective, but viable workaround exists.
  - `Low`: Cosmetic, edge-case warning, or minor inconsistency.
- **Affected Subsystem**: Identify suspected modules, libraries, or service seams.
- **Non-Goals**: Explicitly list items that are out of scope for this defect to prevent scope creep during fixing.

### Step 4: Topic Branch Initialization & Workspace Scaffolding
Per [ADR 0007](file:///workspaces/teachmeanything/docs/adr/0007-sequenced-commit-git-lifecycle-and-persistent-triage.md), isolate work immediately on a dedicated topic branch:
```bash
git checkout -b fix/<issue-id>-<slug>
mkdir -p .triage/<issue-id>
```
Write `.triage/<issue-id>/triage-brief.md` containing:
```markdown
# Triage Brief: [Issue ID / Title]

- **Severity**: [Blocker | Critical | Moderate | Low]
- **Target Subsystem**: [Path / Module]
- **Reported By / Source**: [Reference]

## Problem Summary
[Sanitized description of the defect]

## Expected vs Actual Behavior
- **Expected**: [Description]
- **Actual**: [Description]

## Suspected Seam
[File paths or modules suspected]

## Explicit Non-Goals
- [What not to touch]
```
*(If QA subsequently proves the bug irreproducible within 3 attempts, Coordinator switches back to `main` and deletes this local topic branch).*
