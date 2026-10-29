---
name: diagnosing-bugs
description: Gated 6-phase root-cause debugging workflow. Halts blind guessing by enforcing a deterministic reproduction loop before writing fixes.
argument-hint: "<error description, failing test, or reproduction steps>"
disable-model-invocation: true
origin: "github.com/mattpocock/skills (MIT)"
---

# Diagnosing Bugs

A disciplined, gated 6-phase engineering workflow to diagnose and fix bugs systematically. 

> **Foundational Law**: *Build the right feedback loop, and the bug is 90% fixed. No red-capable command, no Phase 2.*

---

## The 6 Gated Phases

```text
Phase 0: Redact Sensitive Data
   ▼
Phase 1: Build Feedback Loop (Failing Red Command) ──► Gate: Must fail deterministically
   ▼
Phase 2: Reproduce & Minimise
   ▼
Phase 3: Hypothesise (Rank 3-5 Falsifiable Hypotheses)
   ▼
Phase 4: Instrument (Targeted Traces & Assertions)
   ▼
Phase 5: Fix & Add Regression Test ──► Gate: Red command must turn Green
   ▼
Phase 6: Cleanup Instrumentation & Commit
```

### Phase 0: Redact Sensitive Data
Scan all logs, stack traces, and request payloads for credentials, API tokens, cookies, or secrets. Replace them with `<REDACTED>` before storing or sharing outputs.

### Phase 1: Build Feedback Loop
- Construct a fast, deterministic command or test script that reliably reproduces the failure (**Red**).
- **Hard Gate**: You may **not** jump to editing production or application code until you have a command that fails reliably on the defect. If the bug is flaky, run it in a loop (e.g. 50x) until the failure rate is measurable.

### Phase 2: Reproduce & Minimise
- Strip out extraneous dependencies, HTML, or parameters until you find the minimum reproduction payload (minimal failing example).

### Phase 3: Formulate Hypotheses
- Propose **3 to 5 ranked, falsifiable hypotheses** explaining the root cause.
- State clearly what observable evidence would prove or disprove each hypothesis.

### Phase 4: Instrument
- Add narrow, surgical logging or assertion checks around the suspected code seam to inspect state transitions. Do not scatter log lines haphazardly.

### Phase 5: Fix & Verify
- Write a regression test verifying the fix before or alongside the solution.
- Apply the minimal change required to fix the root cause.
- Run the reproduction command from Phase 1 and confirm it turns **Green**.

### Phase 6: Cleanup
- Remove all temporary debugging code, debug logs, and extraneous instrumentation.
- Verify the entire test suite passes without regressions.
