# TeachMeAnything Learning Hub

[![Live Learning Hub](https://img.shields.io/badge/Live_Hub-GitHub_Pages-2ea44f?logo=github)](https://devoirtechsandip.github.io/teachmeanything/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

> 🚀 **Live Interactive Hub**: Experience all interactive lessons, visual DAG simulators, and reference guides live in your browser without any installation:  
> 👉 **[https://devoirtechsandip.github.io/teachmeanything/](https://devoirtechsandip.github.io/teachmeanything/)**

A structured, multi-topic personal learning workspace powered by Matt Pocock's **`teach`** / **`teachme`** skill and real-world engineering agent skills. Compatible with **Google Antigravity**, **Cursor**, and **GitHub Copilot**.

---

## 📁 Repository Structure

Each topic is isolated in its own self-contained directory under `topics/` with no shared state or cross-topic leakage:

```text
teachmeanything/
├── AGENTS.md                  # Central instructions for AI agents enforcing topic isolation
├── GEMINI.md                  # Antigravity/Gemini rule file
├── .agents/                   # Universal & Antigravity skills and rules
│   ├── rules/
│   │   └── topic-isolation.md
│   └── skills/                # Full suite of agent skills (Antigravity & universal)
│       ├── unslop/
│       ├── grill-with-docs/
│       ├── grill-me/
│       ├── grilling/
│       ├── domain-modeling/
│       ├── scaffold-exercises/
│       ├── to-spec/
│       ├── to-tickets/
│       ├── code-review/
│       ├── diagnosing-bugs/
│       ├── handoff/
│       ├── improve-codebase-architecture/
│       ├── teach/
│       └── teachme/
├── .cursor/                   # Cursor rules & mirrored skills
├── .github/                   # GitHub Copilot instructions & mirrored skills
├── skills-lock.json           # Lockfile tracking installed skills and integrity hashes
└── topics/
    ├── git/                   # Active Topic: Git Mastery
    │   ├── MISSION.md         # Topic goals, boundaries, and success criteria
    │   ├── RESOURCES.md       # High-trust curated learning sources
    │   ├── GLOSSARY.md        # Canonical terminology
    │   ├── NOTES.md           # Scratchpad & user preferences
    │   ├── lessons/           # Self-contained HTML interactive lessons
    │   ├── learning-records/  # Sequential insight records (0001-*.md)
    │   ├── reference/         # Cheat sheets & syntax guides
    │   └── assets/            # Reusable lesson assets
    │
    ├── dotnet/                # Active Topic: .NET & C#
    │   └── ... (same self-contained structure)
    │
    └── _template/             # Starter template for adding new topics
```

---

## 🛠️ Agent Skills Arsenal

This repository is equipped with curated agent skills to support educational authoring, architectural stress-testing, and rigorous engineering:

| Skill | Source | Purpose | Trigger / Usage |
| :--- | :--- | :--- | :--- |
| **`teach`** / **`teachme`** | `mattpocock/skills` | Guides stateful, multi-session learning with interactive lessons, learning records, and glossary grounding. | `teach me <topic>` or `/teach <topic>` |
| **`unslop`** | `cursor/plugins` (`pstack`) | Cuts AI tells, corporate puffery, superficial `-ing` phrases, and robotic crutches (banning em-dashes, mid-sentence colons, chatbot phrases, and abstract jargon) in favor of concrete mechanics and plain speech. | `/unslop`, `"cut AI tells"`, `"humanize this"` |
| **`grill-with-docs`** | `mattpocock/skills` | Socratic interview that stress-tests a plan, design, or lesson curriculum branch-by-branch while actively updating `GLOSSARY.md` and logging Architecture Decision Records (ADRs). | `/grill-with-docs <topic/plan>` |
| **`grill-me`** / **`grilling`** | `mattpocock/skills` | Socratic interrogation engine that queries decisions along the active frontier round-by-round to uncover unstated assumptions and edge cases. | `/grill-me <concept/plan>` |
| **`domain-modeling`** | `mattpocock/skills` | Actively establishes ubiquitous domain vocabulary in `GLOSSARY.md` / `CONTEXT.md` and captures architectural decisions as ADRs. | Invoked during design or via `/grill-with-docs` |
| **`scaffold-exercises`** | `mattpocock/skills` | Generates standardized exercise directory trees with `problem/`, `solution/`, and `explainer/` subdirectories and starter stubs. | `/scaffold-exercises <name>` |
| **`to-spec`** | `mattpocock/skills` | Synthesizes conversational alignment and architectural decisions into an unambiguous technical specification before writing code. | `/to-spec <title>` |
| **`to-tickets`** | `mattpocock/skills` | Breaks down specs into vertical-slice (tracer bullet) tickets with explicit dependency blocking edges sized for single agent sessions. | `/to-tickets <spec>` |
| **`code-review`** | `mattpocock/skills` | Disciplined two-axis review evaluating diffs across **Standards** (conventions) and **Spec** (requirements) independently against a fixed ref. | `/code-review [git-ref]` |
| **`diagnosing-bugs`** | `mattpocock/skills` | Gated 6-phase root-cause debugging workflow (*"No red-capable command, no Phase 2"*). | `"diagnose this"`, `"fix this bug"` |
| **`handoff`** | `mattpocock/skills` | Compacts active conversation state, active frontiers, and immediate next steps into an OS temp document for seamless multi-session handover. | `/handoff` |
| **`doc-sync`** | `workflow/doc-sync` | Continuous documentation synchronization auditing code diffs, updating ubiquitous language (`CONTEXT.md` / `GLOSSARY.md`), ADRs, and guides per [ADR 0010](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/docs/adr/0010-continuous-documentation-synchronization.md). | `/doc-sync` |
| **`triage-orchestrator`** | `workflow/triage-team` | Master multi-agent orchestrator executing autonomous bug triage, Red gate reproduction, minimal fix, doc sync, and 3-commit PR. | `/triage-orchestrator <issue>` |
| **`feature-orchestrator`** | `workflow/feature-team` | Master multi-agent orchestrator executing autonomous Socratic feature specification, acceptance Red gate, implementation, doc sync, and 3-commit PR. | `/feature-orchestrator <feature>` |
| **`improve-codebase-architecture`** | `mattpocock/skills` | Audits codebase and topic boundaries, identifies duplication or coupling, and proposes structured refactorings. | `"improve architecture"`, `"audit repo"` |

---

## 🚀 How to Start a Learning Session

### Starting with Git
Open this project in **Antigravity**, **Cursor**, or **GitHub Copilot** and prompt your agent:

> *"Let's start learning Git"* or *"/teach git"*

The agent will automatically:
1. Target `topics/git/` as the isolated workspace.
2. Ground the session in [topics/git/MISSION.md](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/topics/git/MISSION.md).
3. Conduct the kickoff interview to assess your current level and generate Lesson `0001`.

### Adding a New Topic
To add a new topic (e.g. `docker`, `rust`, `kubernetes`):
1. Copy `topics/_template/` to `topics/<new-topic>/`.
2. Or simply prompt your agent: *"I want to learn Docker"* — the agent will scaffold the new topic directory from `topics/_template/` automatically.
