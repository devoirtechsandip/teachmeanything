# TeachMeAnything Learning Hub

A structured, multi-topic personal learning workspace powered by Matt Pocock's **`teach`** / **`teachme`** skill. Compatible with **Google Antigravity**, **Cursor**, and **GitHub Copilot**.

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
│   └── skills/
│       ├── teach/
│       └── teachme/
├── .cursor/                   # Cursor rules & skills
│   ├── rules/
│   │   └── topic-isolation.mdc
│   └── skills/
├── .github/                   # GitHub Copilot instructions & skills
│   ├── copilot-instructions.md
│   └── skills/
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
