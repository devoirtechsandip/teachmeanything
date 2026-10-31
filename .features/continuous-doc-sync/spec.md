# Specification: Continuous Documentation Synchronization (`continuous-doc-sync`)

- **Feature ID**: `continuous-doc-sync`
- **Target Subsystem**: `workflow` / `orchestration`
- **Standards Baseline**: ADR 0001–0010, `AGENTS.md`, `GEMINI.md`

---

## Acceptance Criteria (Gherkin Scenarios)

### Scenario 1: Pre-Verification Documentation Sync Execution (Phase 3.5)
```gherkin
Given a Developer Agent completes Phase 3 code authoring for a bug fix or feature
When the Coordinator transitions to Phase 3.5
Then the Coordinator executes "/doc-sync" before Phase 4 QA review begins
And any necessary documentation diffs are generated and staged in the working tree
```

### Scenario 2: Strict Topic Isolation Boundary
```gherkin
Given code modifications located strictly within "topics/<topic-name>/"
When "/doc-sync" analyzes the git diff
Then documentation updates are strictly confined to "topics/<topic-name>/GLOSSARY.md", "reference/", or "MISSION.md"
And root "CONTEXT.md", "README.md", and other topic directories remain untouched
```

### Scenario 3: Repository Scope Synchronization
```gherkin
Given code modifications located at the repository root, scripts, or ".agents/"
When "/doc-sync" analyzes the git diff
Then documentation updates synchronize "CONTEXT.md", "docs/adr/", "README.md", and "index.html"
And topic-specific "GLOSSARY.md" files remain untouched
```

### Scenario 4: QA Two-Axis Review Hard Gate (Axis A)
```gherkin
Given a code diff that modifies application contracts, CLI commands, or architecture
When the QA Agent performs Phase 4 Two-Axis Code Review
Then Axis A evaluates documentation freshness alongside coding standards
And the QA Agent rejects the review if documentation diffs are absent without a justified "Documentation Impact: None" entry
```

### Scenario 5: Exemption Rationale Verification
```gherkin
Given a surgical defect fix with zero API, behavioral, or architectural impact
When "/doc-sync" completes inspection
Then an explicit "Documentation Impact: None" block with technical justification is appended to ".triage/<id>/rca.md" or "<feature-dir>/verification.md"
And the QA Agent validates this rationale before approving Phase 4 Green status
```

### Scenario 6: The 3-Commit Gate Packaging
```gherkin
Given all Phase 4 and Phase 5 gates have passed
When the Coordinator seals Commit 3
Then Commit 3 message follows "docs(<scope>): record QA verification, security audit, and doc sync"
And Commit 3 stages all synchronized documentation files alongside the QA report and Security audit
```
