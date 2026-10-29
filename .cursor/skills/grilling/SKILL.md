---
name: grilling
description: The core Socratic interview primitive that stress-tests plans, designs, or ideas using dependency-aware rounds along the decision frontier.
origin: "github.com/mattpocock/skills (MIT)"
---

# Grilling

The foundational interview engine for stress-testing plans, ideas, and system architectures. No superficial nodding, no letting vague assumptions slide.

## Philosophy

- **The Design Tree**: Every complex idea is a directed graph of decisions. Upstream decisions constrain downstream options.
- **The Frontier**: Only query the active frontier—decisions whose prerequisites have already been satisfied. Never ask downstream detail questions while core architecture remains undecided.
- **Relentless Rigor**: The goal is to surface hidden flaws, unhandled edge cases, failure states, and unstated assumptions before any code or learning materials are created.

## How to Conduct the Grill

1. **Deconstruct**: Analyze the initial prompt or plan. Identify root decisions vs. dependent decisions.
2. **Formulate Rounds**:
   - Limit each round to 2–4 tightly focused questions.
   - For each decision, present actionable choices with honest trade-offs, marking the recommended choice.
   - Ask about failure modes: *"What happens if this network call times out?"*, *"How does a beginner recover if this git command fails?"*, *"What happens when state desynchronizes?"*
3. **Evaluate and Advance**:
   - Digest the user's answers. Update your mental model of the resolved tree.
   - Advance the frontier to the newly unlocked decisions.
   - Repeat until all critical paths have explicit answers.
4. **Summary**: Provide a bulleted recap of all resolved decisions, remaining assumptions, and explicit non-goals.
