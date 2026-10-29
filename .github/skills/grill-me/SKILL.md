---
name: grill-me
description: Interactively interrogate the user's plan, architectural choice, or topic comprehension through rigorous questioning.
argument-hint: "<plan, feature, topic, or concept to be grilled on>"
disable-model-invocation: true
origin: "github.com/mattpocock/skills (MIT)"
---

# Grill Me

User-invoked entry point for interactive interrogation. Grills the user to stress-test their plan or evaluate their comprehension of a topic.

## Usage

When invoked via `/grill-me` or requested by the user:
1. Identify the subject to test (e.g., an architectural design, a new lesson module, or testing the user's understanding of Git internal storage).
2. Invoke the **grilling** skill principles:
   - Formulate structured rounds of probing questions.
   - Challenge hand-waving or ambiguity.
   - Present edge cases, failure scenarios, and boundary limits.
   - Wait for answers after each round before advancing to the next level of depth.
3. Conclude with a clear scorecard or summary of strengths, vulnerabilities, and recommended remediations.
