# Feature Brief: Continuous Documentation Synchronization (`continuous-doc-sync`)

- **Feature ID**: `continuous-doc-sync`
- **Scope**: Repository Architecture / Workflow
- **Date**: 2026-10-31
- **Architectural Reference**: [ADR 0010: Continuous Documentation Synchronization (`doc-sync`) and Pre-Verification Gating](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/docs/adr/0010-continuous-documentation-synchronization.md)

---

## 1. Problem Statement
In autonomous multi-agent environments ([ADR 0001](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/docs/adr/0001-native-antigravity-subagents-and-skills.md)–[ADR 0009](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/docs/adr/0009-github-pages-live-deployment-and-learning-hub.md)), agents frequently resolve defects ([`triage-orchestrator`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/.agents/skills/triage-orchestrator/SKILL.md)) and implement features ([`feature-orchestrator`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/.agents/skills/feature-orchestrator/SKILL.md)) by modifying application code and test harnesses. However, without an automated and compulsory documentation synchronization mechanism:
- Ubiquitous language ([`CONTEXT.md`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/CONTEXT.md), [`GLOSSARY.md`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/topics/_template/GLOSSARY.md)) falls out of sync with actual code interfaces.
- Operational guides ([`README.md`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/README.md)) and landing hub cards ([`index.html`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/index.html)) lag behind new commands and lessons.
- Downstream subagents operate on stale mental models, causing hallucinations and architectural drift.

---

## 2. Core Objectives & Non-Goals

### Objectives
1. **The `doc-sync` Skill**: Create a specialized documentation skill auditing git diffs across 4 tiers (Language, Architecture, User Guides, Hub Dashboard).
2. **Strict Topic Isolation**: Ensure topic-scoped changes only modify topic documentation (`topics/<topic>/`), while repository changes only modify root docs. Zero cross-topic leakage.
3. **Pre-Verification Lifecycle Integration (Phase 3.5)**: Coordinator triggers `/doc-sync` immediately following Phase 3, staging doc diffs before QA evaluation.
4. **QA Two-Axis Review Hard Gate**: Extend Axis A in [`code-review`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/.agents/skills/code-review/SKILL.md) to fail PRs if code changed without doc updates or an explicit `Documentation Impact: None` technical justification.
5. **Commit 3 Gate Packaging**: Seal all staged documentation diffs inside Commit 3 (`docs(...)`) alongside QA and Security reports.

### Non-Goals
- Generating full synthetic documentation rewrites from scratch on minor refactorings.
- Allowing documentation changes to pollute Commit 2 (`feat` / `fix`), preserving atomic git bisectability.
