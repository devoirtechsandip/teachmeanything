---
name: scaffold-exercises
description: Create exercise directory structures with sections, problems, solutions, and explainers for learning topics and courses.
argument-hint: "<section-name or exercise-title> [--topic=<topic-name>]"
disable-model-invocation: true
origin: "github.com/mattpocock/skills (MIT)"
---

# Scaffold Exercises

Create structured, progressive exercise directories for hands-on learning across topics, complete with problem descriptions, stubs, tests, solutions, and explanatory walkthroughs.

## Directory Structure

Exercises are organized within the active topic (e.g. `topics/<topic>/exercises/`) or workspace root:

```text
exercises/
└── 01-foundations/                           # Section: 2-digit number + dash-case slug
    ├── 01.01-first-commit/                   # Exercise: Section.Exercise + slug
    │   ├── readme.md                         # Exercise overview, goals & prerequisites
    │   ├── problem/                          # Student workspace (stubs, comments, TODOs)
    │   │   ├── readme.md                     # Specific challenge instructions
    │   │   └── index.html (or code files)    # The starter code
    │   ├── solution/                         # Reference implementation
    │   │   ├── readme.md                     # Solution walkthrough & rationale
    │   │   └── index.html (or code files)    # Verified passing code
    │   └── explainer/                        # Optional: deep conceptual dive
    │       └── readme.md                     # Explanations without spoilers
    └── 01.02-branching-basics/
        └── ...
```

## Conventions & Rules

1. **Section Naming**:
   - `XX-<section-slug>` where `XX` is a zero-padded two-digit integer starting at `01`.
2. **Exercise Naming**:
   - `XX.YY-<exercise-slug>` where `XX` matches the section number and `YY` is the exercise index within that section.
3. **Completeness**:
   - Every `readme.md` must contain real, non-empty instructional text, learning objectives, and clear instructions.
   - The `problem/` directory must contain runnable/testable stubs with explicit `// TODO:` or `<!-- TODO: -->` markers.
   - The `solution/` directory must contain fully implemented, verified, working solutions.
4. **Pedagogical Alignment**:
   - Exercises should adhere to desirable difficulty: start with guided scaffolding, then gradually fade prompts.
   - Connect exercise objectives directly to the topic's [MISSION.md](./MISSION.md) and [GLOSSARY.md](./GLOSSARY.md).
