# Grilling Records: Repository Gap Analysis & Audit Skill

- **Feature ID**: `repo-gap-analysis-audit`
- **Skill Invocation**: `/grill-with-docs`
- **Participants**: User & Antigravity Assistant (Coordinator)
- **Outcome**: Unanimously approved architecture captured in [ADR 0011](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/docs/adr/0011-repository-gap-analysis-and-audit-skill.md)

---

## Round 1: Foundational Scope, Topology, and Safety Gates

### Question 1: Target Scope & Reusability
- **Options Evaluated**:
  1. *(Recommended)* Hybrid Universal with Stack Autodetection: Detects languages, package managers, CI/CD, and frameworks automatically, auditing against industry standard practices for that stack.
  2. Repo-Specific: Strictly tailored to 'teachmeanything'.
  3. Fully Universal Pure Checklist: Strictly generic software engineering standards agnostic of framework.
- **Decision**: Hybrid Universal with Stack Autodetection.
- **Rationale**: Provides maximum utility by allowing the skill to audit both the current multi-topic repository and external projects while maintaining domain awareness.

### Question 2: Agent and Skill Orchestration Topology
- **Options Evaluated**:
  1. *(Recommended)* Hub-and-Spoke Multi-Inspector: Master orchestrator skill (`repo-audit`) that runs specialized evaluation passes (Docs, QA/Tests, Security, Architecture, UI, DevOps) aligned with ADR 0002.
  2. Two-Stage Skill Pair: One skill for audit report, companion skill for issue creation.
  3. Single Monolithic Skill: A single prompt pass without specialized sub-axes.
- **Decision**: Hub-and-Spoke Multi-Inspector (`repo-audit`).
- **Rationale**: Aligns directly with proven architecture in ADR 0002 and isolates evaluation domain concerns.

### Question 3: GitHub Issue Creation & Deduplication
- **Options Evaluated**:
  1. *(Recommended)* Interactive Dry-Run Matrix with Deduplication: Generates audit table first, checks existing GitHub issues (`gh issue list`) to avoid duplicates, and prompts user to select issues and priorities.
  2. Automated Direct Issue Creation: Instantly files issues without manual confirmation.
  3. Offline Staging Only: Creates local issue files without pushing to GitHub.
- **Decision**: Interactive Dry-Run Matrix with Deduplication.
- **Rationale**: Prevents backlog spam, eliminates duplicate tickets, and guarantees human oversight before modifying remote issue trackers.

### Question 4: Gap Detection & Best-Practice Grounding
- **Options Evaluated**:
  1. *(Recommended)* Codified Evaluation Rubrics + Tool Probes: Evaluates against standard checklists across the 6 categories, augmented by safe static probes (git log, npm test/audit, workflow checks).
  2. Pure LLM Inspection: Reviews file trees solely through LLM reasoning without diagnostic CLI probes.
- **Decision**: Codified Evaluation Rubrics + Tool Probes.
- **Rationale**: Combines grounded empirical validation with codified best-practice heuristics.

---

## Round 2: Severity Hierarchy, Schema, Persistence, and IDE Parity

### Question 1: Severity Hierarchy & Priority Assignment (P0–P3)
- **Options Evaluated**:
  1. *(Recommended)* Standard Severity Hierarchy: P0 (Active vuln / broken build), P1 (Missing tests on core logic / missing CI / missing setup docs), P2 (Partial coverage / outdated deps / UI a11y), P3 (Stylistic polish / non-blocking improvements).
  2. Strict Security-First Hierarchy: Any security/dep flaw is P0/P1; all others P2/P3.
  3. User-Calibrated at Runtime: Skill suggests initial priority, user adjusts before filing.
- **Decision**: Standard Severity Hierarchy (P0–P3).
- **Rationale**: Provides consistent, objective severity scoring across all 6 axes.

### Question 2: GitHub Issue Labeling & Schema
- **Options Evaluated**:
  1. *(Recommended)* Auto-Provisioning Audit Labels: Uses `audit:<category>` and `priority:P0-P3`; automatically creates missing labels in the repo using `gh label create`.
  2. Reuse Existing Repository Labels: Maps gaps exclusively to existing repo labels.
  3. Label-Free with Title Prefixes: Prefixes titles with `[AUDIT-SECURITY][P1]`.
- **Decision**: Auto-Provisioning Audit Labels (`audit:*`, `priority:P*`).
- **Rationale**: Ensures uniform labeling and easy GitHub filterability.

### Question 3: Audit Report Persistence & History
- **Options Evaluated**:
  1. *(Recommended)* Version-Controlled Audit History (`.audits/`): Saves dated reports (`.audits/YYYY-MM-DD-audit.md`) so subsequent runs track resolved vs lingering gaps over time.
  2. Single Living State (`AUDIT.md`): Overwrites single dashboard.
  3. Ephemeral Chat/Artifact Only: No files committed.
- **Decision**: Version-Controlled Audit History in `.audits/`.
- **Rationale**: Preserves historical audit records and enables delta progress computation.

### Question 4: Tri-Platform IDE Parity
- **Options Evaluated**:
  1. *(Recommended)* Tri-Platform Parity: Maintain parity across Antigravity (`.agents/`), Cursor (`.cursor/`), and GitHub Copilot (`.github/`) per ADR 0006.
  2. Antigravity Native Only: Restrict to `.agents/`.
- **Decision**: Tri-Platform Parity.
- **Rationale**: Adheres strictly to ADR 0006 multi-IDE parity invariant.

---

## Round 3: Execution Flags, Batching, Topic Boundaries, and Resolution Links

### Question 1: Single-Axis vs Full Audit Modes
- **Decision**: Full Audit by Default with Optional Axis Flags (`--docs`, `--tests`, `--security`, `--arch`, `--ui`, `--devops`).
- **Rationale**: Allows comprehensive reviews or fast targeted probes.

### Question 2: Issue Creation Batching & Selection
- **Decision**: Multi-Select Interactive Triage with suggested cap of 5–10 issues per run.
- **Rationale**: Gives users fine-grained control and prevents backlog inundation.

### Question 3: Topic-Aware Isolation
- **Decision**: Respects `AGENTS.md` topic boundaries when auditing `topics/<topic-name>/`.
- **Rationale**: Upholds the Absolute Topic Isolation Mandate.

### Question 4: Autonomous Resolution Lifecycles Linkage
- **Decision**: Embed direct triggers for `/triage-orchestrator` and `/feature-orchestrator` in issue bodies.
- **Rationale**: Provides a seamless pipeline from gap detection to automated resolution.
