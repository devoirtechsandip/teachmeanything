# Specification: Repository Gap Analysis & Health Audit Skill (`repo-audit`)

- **Feature ID**: `repo-gap-analysis-audit`
- **Target Subsystem**: `skills` / `auditing` / `orchestration`
- **Governing ADR**: [ADR 0011](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/docs/adr/0011-repository-gap-analysis-and-audit-skill.md)

---

## Acceptance Criteria (Gherkin Scenarios)

### Scenario 1: Stack Profile Autodetection
```gherkin
Given a repository containing build manifests or language configuration files
When the agent executes "/repo-audit"
Then the skill automatically detects languages, package managers, test runners, and CI workflows
And compiles an accurate Stack Profile without requiring manual stack flags
```

### Scenario 2: 6-Axis Comprehensive Evaluation Rubric
```gherkin
Given a target repository to audit
When "/repo-audit" executes in default full mode
Then it evaluates the repository across 6 distinct technical axes:
  | Axis | Label | Focus Area |
  | 1 | audit:docs | Setup guides, ADRs, glossary, API docs |
  | 2 | audit:tests | Test framework, core seam coverage, CI test runs |
  | 3 | audit:security | Secret leaks, .gitignore sanity, CVEs, OWASP |
  | 4 | audit:arch | Modularity, separation of concerns, coupling |
  | 5 | audit:ui | Mobile responsiveness, WCAG AA accessibility, navigation |
  | 6 | audit:devops | CI workflows, continuous deployment, linters/formatters |
```

### Scenario 3: Targeted Single-Axis Execution
```gherkin
Given a developer wishing to audit a single area
When the agent invokes "/repo-audit --security" (or any other axis flag: --docs, --tests, --arch, --ui, --devops)
Then the skill executes only the requested evaluation pass
And reports findings specific to that axis
```

### Scenario 4: Severity & Priority Classification (P0–P3)
```gherkin
Given identified gaps across any axis
When the skill compiles findings
Then each gap is mapped to a priority level matching the criteria:
  | Priority | Classification | Impact |
  | priority:P0 | Critical / Blocker | Active CVE, exposed secrets, broken build |
  | priority:P1 | High | Untested core logic, missing CI, missing setup docs |
  | priority:P2 | Medium | Incomplete coverage, outdated deps, UI a11y gaps |
  | priority:P3 | Low / Polish | Style inconsistencies, minor doc typos |
```

### Scenario 5: Deduplication Against Existing GitHub Issues
```gherkin
Given existing open or closed GitHub issues in the repository
When the skill compiles proposed issues
Then it executes "gh issue list --state all --limit 100"
And flags matching existing tickets as "[Existing #<id>]"
And omits existing issues from the new issue creation candidates
```

### Scenario 6: Interactive Dry-Run Matrix & Human Gate
```gherkin
Given completed gap evaluations and deduplication
When the skill prepares to file issues
Then it renders a structured markdown Dry-Run table
And halts execution to prompt the user to select which issues to create
And does not call "gh issue create" until the user explicitly confirms
```

### Scenario 7: Standardized Issue Provisioning & Autonomous Linkage
```gherkin
Given user-selected issues to push to GitHub
When the skill provisions issues via "gh issue create"
Then it ensures "audit:<category>" and "priority:P*" labels exist
And structures the issue body with Overview, Risk, Remediation, and Standards Reference
And embeds direct Autonomous Resolution Triggers for "/triage-orchestrator" or "/feature-orchestrator"
```

### Scenario 8: Version-Controlled Persistence (`.audits/`)
```gherkin
Given a completed audit run
When findings are finalized
Then the report is written to ".audits/YYYY-MM-DD-audit.md"
And staged for version control tracking over time
```

### Scenario 9: Tri-Platform IDE Parity
```gherkin
Given the multi-IDE architecture established in ADR 0006
When the "repo-audit" skill is registered
Then full parity is maintained across:
  - Antigravity: ".agents/skills/repo-audit/SKILL.md"
  - Cursor: ".cursor/skills/repo-audit/SKILL.md" and ".cursor/rules/repo-audit.mdc"
  - GitHub Copilot: ".github/skills/repo-audit/SKILL.md" and ".github/copilot-instructions.md"
```
