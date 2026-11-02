# ADR 0011: Repository Gap Analysis, Health Auditing, and Automated GitHub Issue Generation

## Status
Accepted

## Context
As software projects evolve, architectural entropy, technical debt, and missing standards accumulate across multiple engineering dimensions:
- **Documentation Gaps**: Outdated setup guides, missing API specifications, undocumented architecture decisions.
- **Test Coverage Gaps**: Missing unit/integration tests on critical business logic, absent regression harnesses.
- **Security Gaps & Vulnerabilities**: Exposed credentials, unpinned dependencies, OWASP Top 10 vulnerabilities, insecure permissions.
- **Architecture Gaps**: High component coupling, lack of domain boundary isolation, missing error boundaries.
- **Frontend/UI Gaps**: Lack of responsiveness, broken mobile viewports, WCAG accessibility violations, absent semantic HTML.
- **DevOps Gaps**: Incomplete CI/CD automation, missing branch protections, unmonitored deployment pipelines, lack of automated linting/formatting.

While the repository has established robust lifecycles for bug triage ([ADR 0001](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/docs/adr/0001-native-antigravity-subagents-and-skills.md)–[0007](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/docs/adr/0007-sequenced-commit-git-lifecycle-and-persistent-triage.md)), feature development ([ADR 0008](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/docs/adr/0008-feature-development-lifecycle-and-grilling-gate.md)), and continuous documentation synchronization ([ADR 0010](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/docs/adr/0010-continuous-documentation-synchronization.md)), it currently lacks an autonomous inspection capability to proactively audit any codebase against industry best practices and systematically convert findings into actionable GitHub issues.

Following the Socratic interview (`grill-with-docs`), this ADR establishes the architectural standard for the **Repository Gap Analysis & Audit Skill (`repo-audit`)**.

---

## Decision

### 1. Unified Entrypoint & Naming (`/repo-audit`)
We introduce a master skill `repo-audit` (invoked via `/repo-audit [target-path] [flags]`). The skill operates in a Hub-and-Spoke topology ([ADR 0002](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/docs/adr/0002-hub-and-spoke-supervisor-topology.md)) where a central coordinator runs 6 specialized assessment passes.
- **Default Mode**: Full 6-axis evaluation.
- **Selective Flags**: Supports targeting specific axes via flags: `--docs`, `--tests`, `--security`, `--arch`, `--ui`, `--devops`.
- **Topic-Aware Isolation**: When evaluating `topics/<topic-name>/`, respects the Topic Isolation Mandate ([AGENTS.md](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/AGENTS.md)) by auditing topic assets (`MISSION.md`, `GLOSSARY.md`, `learning-records/`, `lessons/`) without cross-contaminating other topic universes.

```text
                  [/repo-audit Triggered]
                             │
                             ▼
               [Phase 1: Stack Autodetection]
       (Identify languages, package managers, CI/CD, tests)
                             │
                             ▼
      ┌──────────────────────┴──────────────────────┐
      ▼                      ▼                      ▼
[Pass 1: Docs]         [Pass 2: Tests]        [Pass 3: Security]
[Pass 4: Architecture] [Pass 5: Frontend/UI]  [Pass 6: DevOps]
      ▲                      ▲                      ▲
      └──────────────────────┬──────────────────────┘
                             │
                             ▼
               [Phase 3: Interactive Dry-Run Matrix]
           (Render 6-axis report + deduplicate with gh)
                             │
                             ▼
               [Phase 4: Human-Gated Multi-Select]
           (User chooses which issues to push, cap: 5-10)
                             │
                             ▼
               [Phase 5: GitHub Issue Provisioning]
            (Auto-create labels & create GitHub issues)
                             │
                             ▼
               [Phase 6: Versioned Audit Persistence]
          (Commit .audits/YYYY-MM-DD-audit.md to git)
```

### 2. 6-Axis Evaluation Taxonomy
Every repository audit investigates 6 distinct technical axes:
1. **`audit:docs` (Documentation)**:
   - README setup instructions, prerequisites, running locally, troubleshooting.
   - Architectural records (ADRs), code comments, API contracts, domain glossary.
2. **`audit:tests` (Test Coverage & Quality)**:
   - Presence of unit, integration, and end-to-end tests.
   - Deterministic execution, mock strategies, CI test runners, edge case coverage.
3. **`audit:security` (Security & Compliance)**:
   - Secret leaks, `.gitignore` safety, CVE dependency vulnerabilities, sanitized inputs, OWASP compliance.
4. **`audit:arch` (Architecture & Modularity)**:
   - Separation of concerns, domain isolation, dependency cycle absence, idiomatic design patterns.
5. **`audit:ui` (Frontend, Styling & Accessibility)**:
   - Responsive design (mobile/tablet/desktop), WCAG AA contrast/aria landmarks, layout performance.
6. **`audit:devops` (DevOps & CI/CD Pipelines)**:
   - GitHub Actions / CI workflows, automated lint/build/test checks, deployment automation, branch protection.

### 3. Stack Autodetection & Hybrid Grounding
The audit automatically identifies the target repository's technology profile by probing configuration manifests:
- **Node/TypeScript/JavaScript**: `package.json`, `tsconfig.json`, lockfiles (`npm`, `pnpm`, `yarn`).
- **Python**: `pyproject.toml`, `requirements.txt`, `Pipfile`, `setup.py`.
- **.NET / C#**: `*.sln`, `*.csproj`, `global.json`.
- **Rust / Go / Java**: `Cargo.toml`, `go.mod`, `pom.xml`, `build.gradle`.
- **DevOps & Containers**: `.github/workflows/`, `Dockerfile`, `docker-compose.yml`, `Makefile`.

Evaluations blend static tool probes (`git status`, `git log`, linter/audit commands where safe) with codified best-practice heuristics tailored to the discovered stack.

### 4. Severity Rubric & Priority Mapping
Findings are strictly categorized using a 4-tier priority scale:
- **P0 (Critical / Blocker)**: Active, exploitable security vulnerabilities; exposed secrets or credentials; completely broken build/install pipelines; legal/license violations.
- **P1 (High)**: Core business logic completely lacking automated tests; absent CI automation allowing broken code to land on main; missing setup documentation blocking onboarding; severe architectural coupling.
- **P2 (Medium)**: Incomplete test coverage on non-critical paths; outdated dependencies without known active exploits; missing UI responsiveness or accessibility landmarks; missing code formatting/linting scripts.
- **P3 (Low / Polish)**: Stylistic inconsistencies, minor documentation typos, non-blocking performance improvements, developer ergonomics enhancements.

### 5. Interactive Dry-Run Matrix & Deduplication Gate
To prevent polluting GitHub with duplicate issues or unwanted tickets:
1. **Deduplication Check**: The skill executes `gh issue list --state all --limit 100` before formulating proposals. Gaps with existing open or closed GitHub issues addressing the same seam are marked as `[Existing #<id>]` and omitted from new issue creation.
2. **Interactive Dry-Run Table**: A structured markdown table is rendered in the chat showing:
   - Gap ID, Category, Proposed Title, Priority (P0–P3), Description Summary, and Remediation Recommendation.
3. **Human Gate**: The user explicitly approves, modifies priorities, or filters out proposed issues before any remote mutation occurs.

### 6. GitHub Issue Provisioning Schema
Upon confirmation, the skill provisions issues using GitHub CLI (`gh`):
1. **Auto-Provisioning Labels**: Ensures labels exist using `gh label create <name> --color <hex> --description <desc>`:
   - Categories: `audit:docs`, `audit:tests`, `audit:security`, `audit:arch`, `audit:ui`, `audit:devops`.
   - Priorities: `priority:P0` (red), `priority:P1` (orange), `priority:P2` (yellow), `priority:P3` (blue).
2. **Standardized Issue Body**:
   ```markdown
   ## 🔍 Gap Overview
   <!-- Clear description of the missing standard or technical debt -->

   ## ⚠️ Why It Matters / Risk Impact
   <!-- What breaks, degrades, or is compromised without this fix -->

   ## 🛠️ Recommended Remediation
   <!-- Actionable, step-by-step checklist or implementation guide -->

   ## 🤖 Autonomous Resolution Trigger
   <!-- Direct command to invoke appropriate autonomous agent lifecycle -->
   - For Bug/Security/Test Fixes: `/triage-orchestrator "Fix <issue title> per issue description"`
   - For Feature/Architecture/DevOps Additions: `/feature-orchestrator "Implement <issue title> per issue description"`

   ## 📚 Standards & Best Practices Reference
   <!-- Industry links, official framework docs, or architectural patterns -->
   ```

### 7. Persistent Version-Controlled History (`.audits/`)
Every completed audit run persists its findings to `.audits/YYYY-MM-DD-audit.md`. Subsequent runs parse prior audit logs to measure repository improvement ("Gaps Resolved: 4, New Gaps Identified: 1, Lingering Gaps: 2").

### 8. Tri-Platform Parity
Per [ADR 0006](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/docs/adr/0006-multi-ide-agent-parity.md), the skill and its documentation are synchronously registered across:
- Antigravity: `.agents/skills/repo-audit/`
- Cursor: `.cursor/skills/repo-audit/`
- GitHub Copilot: `.github/skills/repo-audit/`

---

## Consequences

### Positive
- **Comprehensive Coverage**: Evaluates projects holistically across all 6 critical dimensions instead of hyper-focusing only on code.
- **Spam Prevention**: Interactive dry-run gating and automated deduplication eliminate accidental GitHub issue noise.
- **Consistent Governance**: Auto-provisions standardized labels and structured issue bodies ready for autonomous or human developers to pick up.
- **Trackable Progress**: Version-controlled `.audits/` history offers measurable metrics of technical debt reduction over time.

### Negative / Trade-offs
- **GitHub CLI Dependency**: Requires `gh` authentication to query and create issues on remote repositories (falls back to local `.audits/` report if unauthenticated).
- **Interactive Review Time**: Requires human confirmation during Phase 4 before issues are published.
