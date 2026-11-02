#!/usr/bin/env bash
# ==============================================================================
# .audits/provision-issues.sh
# Auto-provisions GitHub labels and audited issues per ADR 0011 & 2026-11-03 audit
# ==============================================================================
set -euo pipefail

if ! command -v gh &> /dev/null; then
  echo "❌ Error: GitHub CLI ('gh') is not installed or not in PATH." >&2
  echo "Please install gh (e.g. 'brew install gh') and authenticate ('gh auth login') before running this script." >&2
  exit 1
fi

echo "=========================================================="
echo "Phase 1: Ensuring Standardized Audit Labels"
echo "=========================================================="

gh label create "audit:docs" --color "0e8a16" --description "Documentation gap identified by audit" --force
gh label create "audit:tests" --color "1d76db" --description "Test coverage or harness gap" --force
gh label create "audit:security" --color "d93f0b" --description "Security vulnerability or hygiene gap" --force
gh label create "audit:arch" --color "5319e7" --description "Architectural debt or coupling gap" --force
gh label create "audit:ui" --color "e99695" --description "Frontend styling or accessibility gap" --force
gh label create "audit:devops" --color "f9d0c4" --description "CI/CD or automation gap" --force

gh label create "priority:P0" --color "b60205" --description "P0: Blocker / Critical" --force
gh label create "priority:P1" --color "d93f0b" --description "P1: High Priority" --force
gh label create "priority:P2" --color "fbca04" --description "P2: Medium Priority" --force
gh label create "priority:P3" --color "0075ca" --description "P3: Low / Polish" --force

echo "✅ Standardized labels created/verified."

echo "=========================================================="
echo "Phase 2: Creating Approved GitHub Issues"
echo "=========================================================="

# Issue 1
gh issue create \
  --title "test(harness): create unified test runner script (scripts/test.sh)" \
  --label "audit:tests,priority:P1" \
  --body "## 🔍 Gap Overview
Individual acceptance test suites currently exist in \`.features/continuous-doc-sync/acceptance-tests.sh\`, \`.features/live-lesson-deployment/acceptance-tests.sh\`, \`.features/repo-gap-analysis-audit/acceptance-tests.sh\`, and \`topics/git/.features/git-advanced-curriculum/acceptance-tests.sh\`. However, the repository lacks a unified root test runner (\`scripts/test.sh\`) to execute all suites in a single pass.

## ⚠️ Why It Matters / Risk Impact
Developers must manually seek out and execute individual bash scripts. Without a single CLI test entrypoint, tests are prone to being skipped during development, leading to untested regressions entering the codebase.

## 🛠️ Recommended Remediation
1. Author \`scripts/test.sh\` that scans for and executes all feature and topic acceptance test scripts.
2. Implement summary reporting showing test counts, pass/fail status, and an aggregate non-zero exit code on failure.
3. Grant execute permissions (\`chmod +x scripts/test.sh\`).

## 🤖 Autonomous Resolution Trigger
\`/feature-orchestrator \"Create unified test runner script scripts/test.sh per issue description\"\`

## 📚 Standards & Best Practices Reference
- ADR 0003: Hard QA-First Reproduction Gate
- ADR 0008: Feature Development Lifecycle and Grilling Gate"

# Issue 2
gh issue create \
  --title "ci(workflows): execute automated test suites on pull requests in deploy.yml" \
  --label "audit:devops,priority:P1" \
  --body "## 🔍 Gap Overview
\`.github/workflows/deploy.yml\` triggers on pull requests and pushes to \`main\`, but only runs \`scripts/build-site.sh dist\`. It does not execute the acceptance test suites.

## ⚠️ Why It Matters / Risk Impact
Code that breaks governance rules, corrupts learning records, or introduces broken links can be merged to \`main\` without CI failing, defeating the purpose of automated test harnesses.

## 🛠️ Recommended Remediation
1. Add a \`test\` job or step in \`.github/workflows/deploy.yml\` prior to the \`build\` and \`deploy\` jobs.
2. Execute \`bash scripts/test.sh\` within GitHub Actions.
3. Enforce that pull requests cannot deploy or merge if test execution fails.

## 🤖 Autonomous Resolution Trigger
\`/feature-orchestrator \"Execute automated test suites on pull requests in deploy.yml per issue description\"\`

## 📚 Standards & Best Practices Reference
- ADR 0005: Operational Lifecycle and Circuit Breaker
- ADR 0009: GitHub Pages Live Deployment and Learning Hub"

# Issue 3
gh issue create \
  --title "refactor(assets): decouple root index.html from topics/git/assets/style.css" \
  --label "audit:arch,priority:P2" \
  --body "## 🔍 Gap Overview
The root landing page \`index.html\` references \`./topics/git/assets/style.css\` directly for its styling tokens and layout rules.

## ⚠️ Why It Matters / Risk Impact
This violates the Topic Isolation Mandate (AGENTS.md) and architectural modularity. If \`topics/git/\` is refactored, renamed, or isolated, the root learning hub landing page breaks.

## 🛠️ Recommended Remediation
1. Create a root \`assets/css/hub.css\` containing design tokens and hub layout styles.
2. Update \`index.html\` to reference \`./assets/css/hub.css\`.
3. Update \`scripts/build-site.sh\` to stage root \`assets/\` into \`dist/assets/\`.
4. Ensure \`topics/git/assets/style.css\` remains strictly scoped to Git lessons and references.

## 🤖 Autonomous Resolution Trigger
\`/feature-orchestrator \"Decouple root index.html from topics/git/assets/style.css per issue description\"\`

## 📚 Standards & Best Practices Reference
- AGENTS.md: Section 1 (Strict Topic Isolation Mandate)
- ADR 0002: Hub-and-Spoke Supervisor Topology"

# Issue 4
gh issue create \
  --title "fix(a11y): add focus-visible keyboard navigation and skip-to-content link" \
  --label "audit:ui,priority:P2" \
  --body "## 🔍 Gap Overview
The styling system lacks \`:focus-visible\` outline definitions, and \`index.html\` lacks a skip-to-content navigation landmark.

## ⚠️ Why It Matters / Risk Impact
Keyboard-only and screen reader users cannot visually track focus when tabbing across interactive lesson simulators, quiz buttons, or navigation links, violating WCAG 2.1 AA accessibility guidelines.

## 🛠️ Recommended Remediation
1. Define high-contrast \`:focus-visible\` styling (2px solid outline with offset/glow) for buttons, links, and input elements.
2. Add \`<a href=\"#main\" class=\"skip-link\">Skip to main content</a>\` at the top of \`index.html\`.
3. Verify keyboard tab order through all interactive lesson components.

## 🤖 Autonomous Resolution Trigger
\`/triage-orchestrator \"Fix missing focus-visible keyboard navigation and skip link per issue description\"\`

## 📚 Standards & Best Practices Reference
- WCAG 2.1 Success Criterion 2.4.7 (Focus Visible - Level AA)
- WCAG 2.1 Success Criterion 2.4.1 (Bypass Blocks - Level A)"

# Issue 5
gh issue create \
  --title "fix(security): purge tracked .DS_Store files from version control index" \
  --label "audit:security,priority:P2" \
  --body "## 🔍 Gap Overview
\`.DS_Store\` and \`topics/.DS_Store\` are currently tracked in the version control index despite \`.gitignore\` rules.

## ⚠️ Why It Matters / Risk Impact
Tracking OS-specific metadata files clutters pull request diffs, causes unexpected merge conflicts, and leaks local workstation metadata.

## 🛠️ Recommended Remediation
1. Purge cached \`.DS_Store\` files from git using \`git rm --cached .DS_Store topics/.DS_Store\`.
2. Confirm \`.gitignore\` prevents future staging.
3. Verify clean working tree.

## 🤖 Autonomous Resolution Trigger
\`/triage-orchestrator \"Purge tracked .DS_Store files from version control index per issue description\"\`

## 📚 Standards & Best Practices Reference
- ADR 0004: Dedicated Security Agent
- AGENTS.md: Section 3 (Security Agent)"

# Issue 6
gh issue create \
  --title "docs(onboarding): add local development and test execution guide to README" \
  --label "audit:docs,priority:P2" \
  --body "## 🔍 Gap Overview
\`README.md\` documents learning commands and the agent skills arsenal, but lacks step-by-step developer onboarding instructions for local testing and building.

## ⚠️ Why It Matters / Risk Impact
Contributors and developers cannot easily discover how to build the site locally (\`bash scripts/build-site.sh dist\`), preview it in a browser, or run automated acceptance tests before submitting PRs.

## 🛠️ Recommended Remediation
1. Add a \"Local Development & Testing\" section to \`README.md\`.
2. Provide commands for local staging build, local preview server (\`python3 -m http.server 8080 -d dist\`), and running tests (\`bash scripts/test.sh\`).
3. Document prerequisite requirements.

## 🤖 Autonomous Resolution Trigger
\`/feature-orchestrator \"Add local development and test execution guide to README per issue description\"\`

## 📚 Standards & Best Practices Reference
- ADR 0010: Continuous Documentation Synchronization"

# Issue 7
gh issue create \
  --title "sec(headers): configure Content-Security-Policy meta tags in public pages" \
  --label "audit:security,priority:P2" \
  --body "## 🔍 Gap Overview
\`index.html\` and topic lessons currently do not declare Content Security Policy (CSP) headers or meta tags.

## ⚠️ Why It Matters / Risk Impact
Without CSP, browser clients lack defense-in-depth protection against cross-site scripting (XSS), rogue external script execution, or unauthorized network calls.

## 🛠️ Recommended Remediation
1. Formulate a tight CSP policy allowing Google Fonts and local simulator scripts.
2. Inject \`<meta http-equiv=\"Content-Security-Policy\" content=\"...\">\` into \`index.html\` and lesson templates.
3. Validate that simulators, SVG renderers, and style tokens function without CSP console errors.

## 🤖 Autonomous Resolution Trigger
\`/feature-orchestrator \"Configure Content-Security-Policy meta tags in public pages per issue description\"\`

## 📚 Standards & Best Practices Reference
- OWASP Top 10 A03:2021 (Injection)
- ADR 0004: Dedicated Security Agent"

# Issue 8
gh issue create \
  --title "ci(lint): add shellcheck and markup validation job in GitHub Actions" \
  --label "audit:devops,priority:P2" \
  --body "## 🔍 Gap Overview
Shell scripts (\`scripts/build-site.sh\`, acceptance tests) and HTML deliverables lack automated syntax, linting, and style validation in CI.

## ⚠️ Why It Matters / Risk Impact
Shell script bugs (unbound variables, syntax errors) or HTML markup defects can slip through pull requests without automated linting gates.

## 🛠️ Recommended Remediation
1. Create a \`lint\` job in GitHub Actions executing \`shellcheck\` across \`scripts/*.sh\` and \`.features/**/*.sh\`.
2. Integrate basic HTML link and markup validation.
3. Gate pull requests on linting clearance.

## 🤖 Autonomous Resolution Trigger
\`/feature-orchestrator \"Add shellcheck and markup validation job in GitHub Actions per issue description\"\`

## 📚 Standards & Best Practices Reference
- ADR 0005: Operational Lifecycle and Circuit Breaker"

# Issue 9
gh issue create \
  --title "docs(topics): add new topic onboarding and asset registration guide" \
  --label "audit:docs,priority:P3" \
  --body "## 🔍 Gap Overview
The repository lacks developer documentation outlining how to author, structure, and register new topics beyond copying \`topics/_template/\`.

## ⚠️ Why It Matters / Risk Impact
Without clear authoring guidelines, newly added topics (e.g. \`dotnet\`) may diverge in structure, omit required assets, or fail to be properly linked in \`index.html\` and \`scripts/build-site.sh\`.

## 🛠️ Recommended Remediation
1. Author \`docs/guides/authoring-topics.md\` outlining the topic lifecycle, required directories, naming conventions, and staging rules.
2. Link the guide from \`README.md\` and \`topics/_template/MISSION.md\`.

## 🤖 Autonomous Resolution Trigger
\`/feature-orchestrator \"Add new topic onboarding and asset registration guide per issue description\"\`

## 📚 Standards & Best Practices Reference
- AGENTS.md: Section 1 & Section 2 (Topic Routing & Scaffolding)
- ADR 0001: Native Antigravity Subagents and Skills"

# Issue 10
gh issue create \
  --title "ci(dependabot): configure dependabot for automated GitHub Actions version bumps" \
  --label "audit:devops,priority:P3" \
  --body "## 🔍 Gap Overview
No Dependabot configuration exists to monitor and automate updates for GitHub Actions workflows.

## ⚠️ Why It Matters / Risk Impact
Action versions (e.g. \`actions/checkout@v4\`, \`actions/deploy-pages@v4\`) can fall out of date, missing security patches or new runner features.

## 🛠️ Recommended Remediation
1. Create \`.github/dependabot.yml\` configured for \`package-ecosystem: \"github-actions\"\`.
2. Configure monthly or weekly update schedules with conventional commit prefixes.

## 🤖 Autonomous Resolution Trigger
\`/feature-orchestrator \"Configure dependabot for automated GitHub Actions version bumps per issue description\"\`

## 📚 Standards & Best Practices Reference
- GitHub Security Best Practices for GitHub Actions"

echo "=========================================================="
echo "✅ All 10 GitHub issues successfully provisioned!"
echo "=========================================================="
