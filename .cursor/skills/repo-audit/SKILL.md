---
name: repo-audit
description: Proactively audits any codebase across 6 technical axes (Docs, Tests, Security, Architecture, UI, DevOps), generates an interactive dry-run health matrix, deduplicates against existing GitHub issues, and auto-provisions prioritized GitHub issues per ADR 0011.
argument-hint: "[target-path] [--docs] [--tests] [--security] [--arch] [--ui] [--devops]"
disable-model-invocation: true
origin: "workflow/repo-audit (MIT)"
---

# Repository Gap Analysis & Health Audit (`repo-audit`)

A comprehensive, multi-dimensional code and repository auditing skill per [ADR 0011](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/docs/adr/0011-repository-gap-analysis-and-audit-skill.md). Evaluates any codebase against modern best practices, generates an interactive dry-run health matrix, deduplicates against existing GitHub issues, and auto-provisions prioritized issues with autonomous agent resolution triggers.

---

## 1. Execution Workflow Overview

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

---

## 2. Command Line Arguments & Flags

The skill can be invoked with optional paths and selective axis flags:

```bash
/repo-audit                     # Full 6-axis audit of current repository
/repo-audit topics/git/         # Topic-scoped audit respecting AGENTS.md isolation
/repo-audit --security          # Targeted security & vulnerability audit only
/repo-audit --tests             # Targeted test coverage & quality audit only
/repo-audit --docs              # Targeted documentation audit only
/repo-audit --arch              # Targeted architecture & modularity audit only
/repo-audit --ui                # Targeted frontend styling & accessibility audit only
/repo-audit --devops            # Targeted CI/CD & automation audit only
```

---

## 3. Phase 1: Stack Autodetection & Environment Profiling

Before evaluating gaps, the skill establishes the repository's **Stack Profile** by inspecting root configuration manifests:
- **Languages & Frameworks**:
  - Node / TypeScript / React / Next / Vue: `package.json`, `tsconfig.json`, `next.config.js`
  - Python / FastAPI / Django / Flask: `pyproject.toml`, `requirements.txt`, `Pipfile`, `setup.py`
  - .NET / C#: `*.sln`, `*.csproj`, `global.json`
  - Rust: `Cargo.toml`, `Cargo.lock`
  - Go: `go.mod`, `go.sum`
- **Package Managers**: `npm`, `pnpm`, `yarn`, `bun`, `pip`, `poetry`, `nuget`, `cargo`.
- **Test Runners**: `jest`, `vitest`, `pytest`, `dotnet test`, `cargo test`, `playwright`, `cypress`.
- **CI/CD & Infrastructure**: `.github/workflows/`, `Dockerfile`, `docker-compose.yml`, `Makefile`.
- **Topic Isolation Check**: If targeting `topics/<topic-name>/`, verifies adherence to [AGENTS.md](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/AGENTS.md) (checking for `MISSION.md`, `GLOSSARY.md`, `lessons/`, `learning-records/`, `reference/`) without cross-topic contamination.

---

## 4. Phase 2: 6-Axis Evaluation Rubric

The audit conducts assessment passes across all requested axes:

### Axis 1: `audit:docs` (Documentation Gaps)
- **Setup & Onboarding**: Does `README.md` clearly state prerequisites, installation steps, and local launch commands?
- **Architecture & Decisions**: Are key technical choices recorded in `docs/adr/` or design specs?
- **Domain Language**: Is there an active `CONTEXT.md` (or topic `GLOSSARY.md`) defining ubiquitous terms?
- **API & Interface Specs**: Are public functions, APIs, or schemas documented with types or docstrings?

### Axis 2: `audit:tests` (Test Coverage & Quality Gaps)
- **Test Infrastructure**: Is an automated test framework installed and configured with a runnable CLI command?
- **Core Seam Coverage**: Are mission-critical business logic and edge cases backed by unit or integration tests?
- **Test Determinism**: Are tests fast, hermetic, and free from external network dependencies or race conditions?
- **Acceptance / E2E Harness**: Are there automated regression tests validating end-to-end user workflows?

### Axis 3: `audit:security` (Security & Vulnerability Gaps)
- **Secret & Credential Hygiene**: Are `.env`, credentials, API keys, or private tokens committed to version control?
- **`.gitignore` Sanity**: Are build artifacts, caches, dependencies (`node_modules/`, `bin/`, `obj/`), and secret files properly ignored?
- **Dependency Vulnerabilities**: Are there known unpatched CVEs in declared package manifests?
- **Input Sanitization & OWASP**: Are input boundaries protected against injection (SQLi, XSS, command injection, path traversal)?

### Axis 4: `audit:arch` (Architecture & Modularity Gaps)
- **Separation of Concerns**: Is business logic decoupled from presentation, transport, and persistence layers?
- **Coupling & Cohesion**: Are components modular without circular dependencies or god-classes?
- **Error Handling**: Are error boundaries, custom exceptions, and failure states gracefully handled?
- **Code Organization**: Does the directory layout follow standard idiomatic patterns for the detected stack?

### Axis 5: `audit:ui` (Frontend, Styling & Accessibility Gaps)
- **Responsive Layout**: Do views adapt cleanly across mobile, tablet, and desktop viewports without horizontal scrolling?
- **Accessibility (WCAG AA)**: Are semantic HTML tags (`<main>`, `<nav>`, `<article>`), ARIA landmarks, alt texts, and color contrasts compliant?
- **Interaction & State**: Are loading, empty, and error UI states visually handled?
- **Navigation Flow**: Do all pages provide intuitive back-to-home or breadcrumb navigation links?

### Axis 6: `audit:devops` (DevOps & CI/CD Gaps)
- **Automated CI**: Does `.github/workflows/` run build, lint, and test checks automatically on pull requests?
- **Continuous Deployment**: Is deployment automated to production or staging environments?
- **Linting & Formatting**: Are tools like Prettier, ESLint, Ruff, or Black configured with pre-commit or CI gates?
- **Branch Protection Readiness**: Are rules in place or ready for required status checks before merging to main?

---

## 5. Phase 3: Severity Rubric (P0–P3)

Every identified gap is mapped to a standard severity level:

| Priority | Classification | Impact & Criteria |
| :--- | :--- | :--- |
| **`priority:P0`** | **Critical / Blocker** | Active exploitable security CVEs, exposed credentials, broken build/install commands, legal/license violations. |
| **`priority:P1`** | **High** | Core business logic completely lacking automated tests, missing CI pipeline allowing broken code on main, missing setup docs blocking onboarding, severe architectural coupling. |
| **`priority:P2`** | **Medium** | Incomplete test coverage on non-critical paths, outdated dependencies without active exploits, missing UI mobile responsiveness or WCAG accessibility landmarks, missing linter/formatter. |
| **`priority:P3`** | **Low / Polish** | Stylistic inconsistencies, minor documentation typos, non-blocking performance micro-optimizations, developer ergonomics improvements. |

---

## 6. Phase 4: Deduplication & Interactive Dry-Run Matrix

To prevent spamming the repository with redundant issues:

1. **GitHub Pre-flight Query**:
   Execute `gh issue list --state all --limit 100` to inspect all open and closed issues.
2. **Deduplication Matching**:
   Match proposed gap titles and target filenames against existing issues. If a similar issue is open or recently resolved, flag it as `[Existing #<id>]` and omit it from the creation candidates.
3. **Render Interactive Dry-Run Table**:
   Output the structured findings table:

   | # | Priority | Category | Proposed Issue Title | Status | Recommended Remediation |
   | :-: | :--- | :--- | :--- | :--- | :--- |
   | 1 | `priority:P1` | `audit:tests` | test(core): add automated tests for auth pipeline | New | Add vitest suite covering JWT validation |
   | 2 | `priority:P2` | `audit:ui` | fix(nav): resolve mobile viewport cutoff on navbar | New | Add responsive flex-wrap and hamburger menu |
   | 3 | `priority:P1` | `audit:security` | fix(deps): resolve high-severity CVE in express | Existing #14 | Already tracked in PR #15 |

4. **Human Gate**:
   Pause execution and prompt the user:
   > *"Identified **N** gaps (**X** new, **Y** already tracked). Please select which issues to create (e.g., 'all P0 and P1', '1, 2', or 'all')."*

---

## 7. Phase 5: GitHub Issue Provisioning Schema

Once confirmed by the user:

1. **Auto-Provision Labels**:
   Ensure required labels exist using:
   ```bash
   gh label create audit:docs --color 0e8a16 --description "Documentation gap identified by audit" --force
   gh label create audit:tests --color 1d76db --description "Test coverage or harness gap" --force
   gh label create audit:security --color d93f0b --description "Security vulnerability or hygiene gap" --force
   gh label create audit:arch --color 5319e7 --description "Architectural debt or coupling gap" --force
   gh label create audit:ui --color e99695 --description "Frontend styling or accessibility gap" --force
   gh label create audit:devops --color f9d0c4 --description "CI/CD or automation gap" --force
   gh label create priority:P0 --color b60205 --description "P0: Blocker / Critical" --force
   gh label create priority:P1 --color d93f0b --description "P1: High Priority" --force
   gh label create priority:P2 --color fbca04 --description "P2: Medium Priority" --force
   gh label create priority:P3 --color 0075ca --description "P3: Low / Polish" --force
   ```

2. **Standardized Issue Body**:
   Format each issue using the canonical template:
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

3. **Creation Execution**:
   Run `gh issue create --title "<Title>" --label "<category>,<priority>" --body "<Body>"`.

---

## 8. Phase 6: Version-Controlled Persistence (`.audits/`)

1. **Persist Audit Log**:
   Save the full audit report to `.audits/YYYY-MM-DD-audit.md` containing:
   - Stack profile summary.
   - Complete 6-axis gap analysis.
   - List of newly created GitHub issues (with issue numbers and links).
   - Delta progress comparing to previous audit files in `.audits/`.
2. **Git Commit**:
   Commit the new audit record:
   ```bash
   git add .audits/
   git commit -m "docs(audit): record repository gap analysis and health report for YYYY-MM-DD"
   ```
