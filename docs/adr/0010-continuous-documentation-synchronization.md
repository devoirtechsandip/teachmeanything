# ADR 0010: Continuous Documentation Synchronization (`doc-sync`) and Pre-Verification Gating

## Status
Accepted

## Context
In our multi-agent architecture ([ADR 0001](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/docs/adr/0001-native-antigravity-subagents-and-skills.md)–[0009](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/docs/adr/0009-github-pages-live-deployment-and-learning-hub.md)), autonomous bug resolution ([`triage-orchestrator`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/.agents/skills/triage-orchestrator/SKILL.md)) and feature enhancement ([`feature-orchestrator`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/.agents/skills/feature-orchestrator/SKILL.md)) systematically produce reproduction/acceptance tests, implementation diffs, and persistent verification records (`.triage/`, `.features/`).

However, without an enforced, automated synchronization mechanism for living repository documentation ([`CONTEXT.md`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/CONTEXT.md), [`README.md`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/README.md), topic [`GLOSSARY.md`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/topics/_template/GLOSSARY.md), topic `reference/`, and [`index.html`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/index.html)), documentation inevitably drifts from code reality. When documentation becomes stale, downstream agents make incorrect assumptions, fail to leverage newly introduced capabilities, or violate updated invariants.

Following the Socratic interview (`grill-with-docs`), this ADR establishes a compulsory **Continuous Documentation Synchronization (`doc-sync`)** standard across all bug resolution and feature lifecycles.

---

## Decision

### 1. The `doc-sync` Skill & Multi-Layer Adaptive Sync
We introduce a dedicated skill ([`doc-sync`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/.agents/skills/doc-sync/SKILL.md)) invoked during every bug resolution and feature development lifecycle. 

`doc-sync` performs a multi-layer adaptive audit of the active git diff against four documentation tiers:
1. **Ubiquitous Language & APIs**: Synchronizes canonical terms, interfaces, flags, and data structures in [`CONTEXT.md`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/CONTEXT.md) (or topic [`GLOSSARY.md`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/topics/_template/GLOSSARY.md)).
2. **Architecture Decision Records**: If an architectural pattern, lifecycle stage, or dependency was introduced or modified, drafts or updates an ADR in [`docs/adr/`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/docs/adr/) or topic `reference/`.
3. **Operational & Setup Guides**: Synchronizes CLI commands, workflow triggers, and configuration guides in [`README.md`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/README.md).
4. **Learning Hub & Topic Catalogs**: Updates the landing page dashboard ([`index.html`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/index.html)) and topic `MISSION.md` whenever topics, lessons, or exercises are added or altered.

### 2. Strict Context-Aware Boundary & Topic Isolation
To preserve the absolute Topic Isolation Mandate ([AGENTS.md](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/AGENTS.md)):
- **Topic-Scoped Changes** (`topics/<topic-name>/...`): `doc-sync` operates strictly inside `topics/<topic-name>/` (`GLOSSARY.md`, `MISSION.md`, `reference/`, lessons). It is strictly barred from modifying root files or other topic directories.
- **Repository-Scoped Changes** (root scripts, orchestrators, `.agents/`, root dashboard): `doc-sync` operates on root docs ([`CONTEXT.md`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/CONTEXT.md), [`README.md`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/README.md), [`docs/adr/`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/docs/adr/), [`index.html`](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/index.html)).

### 3. Pre-Verification Execution Flow
To ensure documentation is rigorously reviewed prior to landing:
1. **Developer Finishes Phase 3**: Code fix or feature implementation is completed.
2. **Coordinator Triggers `doc-sync` (Phase 3.5)**: Coordinator runs `/doc-sync` to generate and stage necessary documentation diffs.
3. **QA Two-Axis Review in Phase 4**: QA inspects both application code diffs *and* staged documentation diffs together.
4. **Phase 6 Commit Sealing**: The staged documentation diffs are sealed inside **Commit 3** (`docs(...)`) alongside the QA verification report and Security audit clearance.

```text
  [Phase 3: Developer Code Implementation]
                     │
                     ▼
       [Phase 3.5: Coordinator invokes /doc-sync] ──► (Staged Doc Diffs)
                     │
                     ▼
  [Phase 4: QA Two-Axis Review (Axis A verifies docs)]
                     │ (Passed)
                     ▼
  [Phase 5: Security Audit]
                     │ (Passed)
                     ▼
  (Commit 2: feat/fix: implementation diffs)
                     │
                     ▼
  (Commit 3: docs: staged doc diffs + qa-report + security-audit)
                     │
                     ▼
  [Phase 6: PR Creation & Human Review]
```

### 4. QA Two-Axis Review Hard Gate (Axis A)
The QA Agent's **Axis A (Standards & Documentation)** review enforces a hard gate:
- If functional or behavioral code changed without accompanying documentation updates, QA **must reject** the review with an explicit request for doc synchronization.
- **Exemption Rationale Standard**: If a fix is purely internal (e.g. fixing a typo, refactoring internal logic with zero contract or behavioral changes), `doc-sync` must generate an explicit `Documentation Impact: None` entry with a 1–2 sentence technical rationale in `.triage/<id>/rca.md` or `<feature-dir>/verification.md`. QA explicitly audits this rationale before approving.

### 5. The 3-Commit Gate Standard Integration
The 3-Commit Gate Standard defined in [ADR 0007](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/docs/adr/0007-sequenced-commit-git-lifecycle-and-persistent-triage.md) and [ADR 0008](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/docs/adr/0008-feature-development-lifecycle-and-grilling-gate.md) is updated so that:
- **Commit 1**: `test(<scope>): ...` (Reproduction/acceptance tests & spec).
- **Commit 2**: `fix(<scope>): ...` or `feat(<scope>): ...` (Application code & RCA/implementation diffs).
- **Commit 3**: `docs(<scope>): record QA verification, security audit, and doc sync` (Verification report + Security audit + Synchronized repository/topic documentation).

---

## Consequences

### Positive
- **Zero Documentation Drift**: Documentation is continuously maintained with every single PR, eliminating outdated docs.
- **Future Agent Acceleration**: Downstream agents will always find accurate ubiquitous terms, current architecture diagrams, and synchronized operational guides.
- **Clean Commit History**: Code changes stay in Commit 2, while all documentation and verification artifacts remain logically packaged in Commit 3 (`docs(...)`).
- **Topic Isolation Guaranteed**: Strict boundary scoping prevents cross-topic leakage during automated sync.

### Negative / Trade-offs
- Slight increase in execution time per triage/feature cycle to perform doc diff analysis and staging.
- QA review checklist expands to include verification of documentation accuracy and exemption rationales.
