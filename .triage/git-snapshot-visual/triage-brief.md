# Triage Brief: Git Lesson 0001 Visualizing Snapshot Model Not Rendering

- **Issue ID**: git-snapshot-visual
- **Severity**: Critical (Visual interactive learning module broken)
- **Target File**: `topics/git/lessons/0001-why-git-and-the-snapshot-model.html` and `topics/git/assets/components.js`
- **Reported Symptom**: In browser, section "Visualizing the Git Snapshot Model" (`#animCanvas`) does not display visuals.

## Problem Summary
When opening `topics/git/lessons/0001-why-git-and-the-snapshot-model.html` in a web browser, the interactive animation container for "Visualizing the Git Snapshot Model" remains blank / unpopulated.

## Expected vs Actual Behavior
- **Expected**: `#animCanvas` and `#animExplanation` are populated by `GitSnapshotSimulator` on load showing Stage 1 of the snapshot model with controls.
- **Actual**: Canvas is completely blank. Subsequent script execution appears halted.

## Suspected Seam
`topics/git/assets/components.js` initialization or inline script sequence in `0001-why-git-and-the-snapshot-model.html`.

## Explicit Non-Goals
- Do not redesign or modify CSS styling of the lesson.
- Do not alter lesson copy or curriculum text.
- Do not affect any other lessons or topics.
