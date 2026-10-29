---
name: feature-spec
description: Conduct interactive Socratic requirements grilling (grill-with-docs) for new features, scaffold persistent specification bundle, log ADRs, and initialize the topic branch.
argument-hint: "<feature-request or functionality-goal>"
disable-model-invocation: true
origin: "workflow/feature-team (MIT)"
---

# Feature Specification (The Grilling Gate)

Lead the upfront requirements interrogation for new feature or functionality requests. Uses the `/grill-with-docs` Socratic interview primitive to eliminate ambiguities, define testable acceptance criteria, log Architecture Decision Records (ADRs), update domain models, and scaffold the persistent specification bundle before cutting the feature branch.

> **Law of the Grilling Gate**: *No grilling interview + approved spec = No coding allowed. Autonomous subagents cannot be dispatched until human requirements and edge cases are formally documented.*

---

## Responsibilities & Constraints
- **Role**: Executed by the **Coordinator Agent** in direct, interactive conversation with the human user.
- **Boundaries**: Conducts the interview, logs decisions, and builds the specification bundle. Does **not** write feature code or executable test suites directly.

---

## The 5-Step Feature Specification Workflow

### Step 1: Feature Intake & Topic Boundary Check
Analyze the incoming request:
1. Determine whether the feature is:
   - **Topic-Specific**: Scoped strictly inside a single topic (e.g. `topics/<topic-name>/lessons/`, `topics/<topic-name>/assets/`).
   - **Repo-Wide**: Infrastructure, global skills, tools, or cross-cutting developer environments.
2. Invariant: If topic-specific, inspect `topics/<topic-name>/MISSION.md` and preserve absolute topic isolation per [RULE](file:///workspaces/teachmeanything/AGENTS.md).
3. Generate a unique `feature-id` (e.g., `git-undo-simulator`, `cli-json-export`) and slug.

### Step 2: Interactive Socratic Grilling (`grill-with-docs`)
Conduct a structured, dependency-aware Socratic interview with the user across 2–3 rounds:
- **Round 1 (Foundational & Architectural Decisions)**:
  - System boundary, entrypoint, interfaces, and primary user workflow.
  - Data structures, state storage, and persistent dependencies.
- **Round 2 (Edge Cases, Quality & Failure Modes)**:
  - Scalability, validation rules, timeout/error states, and error UX.
  - Non-goals (explicitly what the feature will *not* do).
- **Rules of Engagement**:
  - Always provide concrete options with trade-offs, recommending the simplest viable path.
  - Stress-test assumptions and challenge hand-wavy requirements.
  - Never ask premature questions about leaf details whose parent architecture is unresolved.

### Step 3: Active Documentation & ADR Logging
As decisions crystallize during the dialogue:
1. Update `CONTEXT.md` (or topic `GLOSSARY.md`) with any new canonical terminology.
2. If irreversible or significant architectural choices were made, record a formal ADR in `docs/adr/000X-<slug>.md` (or `topics/<topic>/reference/000X-adr-<slug>.md`) capturing Context, Decision, Rationale, and Consequences.

### Step 4: Scaffold Persistent Specification Bundle
Create the persistent feature directory:
- For repo-wide features: `.features/<feature-id>/`
- For topic-specific features: `topics/<topic-name>/.features/<feature-id>/`

Generate the following version-controlled artifacts:
1. **`feature-brief.md`**:
   ```markdown
   # Feature Brief: [Feature ID / Title]
   - **Target Scope**: [Repo-wide | topics/<topic-name>]
   - **Requested By**: User
   - **Status**: Specified (Approved for Acceptance Testing)
   
   ## Problem & Intent
   [Sanitized summary of user desire and purpose]
   
   ## Explicit Non-Goals
   - [What is out of scope]
   ```
2. **`grilling-records.md`**:
   Complete record of the interview rounds, questions asked, user answers, explored alternatives, and documented trade-offs.
3. **`spec.md`**:
   ```markdown
   # Functional Specification: [Feature ID]
   
   ## System Architecture & Contracts
   [Component diagrams, file paths, function/API signatures, schemas]
   
   ## Testable Acceptance Criteria (Gherkin Format)
   ### Scenario 1: [Happy path]
   - **Given** [preconditions]
   - **When** [action / event]
   - **Then** [expected verifiable outcome]
   
   ### Scenario 2: [Edge case / error state]
   - **Given** [preconditions]
   - **When** [invalid action / error condition]
   - **Then** [expected graceful degradation / error response]
   ```

### Step 5: User Sign-Off & Topic Branch Cut
1. Present the finalized specification summary to the user for explicit confirmation.
2. Upon user approval, create and switch to the dedicated feature branch:
   ```bash
   git checkout -b feat/<feature-id>-<slug>
   ```
3. Hand off the specification bundle to the QA Agent to enforce the Red Acceptance Gate.
