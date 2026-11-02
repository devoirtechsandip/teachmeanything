# Feature Brief: Repository Gap Analysis & Health Audit Skill (`repo-audit`)

- **Feature ID**: `repo-gap-analysis-audit`
- **Scope**: Repository-wide (`workflow` / `orchestration`)
- **Status**: Completed / Ready for PR
- **Target Branch**: `feat/repo-gap-analysis-audit`
- **Base Branch**: `main`
- **Governing Architecture**: [ADR 0011](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/docs/adr/0011-repository-gap-analysis-and-audit-skill.md)

---

## Executive Summary

Software repositories accumulate technical debt across multiple engineering domains (documentation, test coverage, security, architecture, frontend/UI, and devops). Prior to this feature, this repository possessed robust multi-agent lifecycles for resolving defects (`triage-orchestrator`) and building features (`feature-orchestrator`), but lacked an autonomous proactive auditing mechanism to inspect codebases against modern best practices and automatically generate actionable, prioritized GitHub issues.

This feature introduces `repo-audit`, a 6-axis gap analysis and health auditing skill with:
1. **Stack Profile Autodetection**: Automatically discovers languages, frameworks, package managers, and test runners from manifests.
2. **6-Axis Evaluation Rubric**: Comprehensive evaluation across `audit:docs`, `audit:tests`, `audit:security`, `audit:arch`, `audit:ui`, and `audit:devops`.
3. **Severity & Priority Hierarchy**: Categorization of findings into P0 (Critical/Blocker), P1 (High), P2 (Medium), and P3 (Low/Polish).
4. **Interactive Dry-Run & Deduplication Gate**: Pre-flight queries via `gh issue list` to prevent duplicate issues, presenting a dry-run review table for human multi-selection.
5. **Standardized Issue Provisioning**: Auto-creation of labels and structured issue bodies linking directly to `/triage-orchestrator` and `/feature-orchestrator`.
6. **Version-Controlled History (`.audits/`)**: Persistent audit logs in `.audits/YYYY-MM-DD-audit.md` tracking gap resolution deltas over time.
7. **Tri-Platform IDE Parity**: Full registration across Antigravity (`.agents/`), Cursor (`.cursor/`), and GitHub Copilot (`.github/`) per ADR 0006.
