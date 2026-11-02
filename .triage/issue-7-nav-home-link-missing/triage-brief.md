# Triage Brief: Missing Navigation Link to Return to Home Dashboard

- **Issue ID**: issue-7-nav-home-link-missing
- **GitHub Issue**: [Issue #7](https://github.com/devoirtechsandip/teachmeanything/issues/7)
- **Severity**: High (Dead-end user experience across all topic screens)
- **Target Files**:
  - `topics/git/lessons/*.html` (15 files)
  - `topics/git/reference/*.html` (15 files)
- **Reported Symptom**: In browser, when viewing any lesson or reference card, there is no option or button to return to the root Learning Hub dashboard (`index.html`). The logo links to Lesson 0001, effectively trapping the user inside the topic directory.

## Problem Summary
When opening any lesson or reference card, the header navigation bar (`.sticky-nav`) offers navigation between lessons or reference cards, but completely lacks a link pointing back to the repository's root dashboard (`index.html`). Users must manually edit the browser URL address bar to return to the home screen.

## Expected vs Actual Behavior
- **Expected**: A prominent "🏠 Hub Home" button in `.sticky-nav .nav-controls` and an "🏠 All Topics" link in `.lesson-footer` that routes the user cleanly to `../../../index.html`.
- **Actual**: No link to root `index.html` exists on any topic screen.

## Suspected Seam
Static HTML templates in `topics/git/lessons/*.html` and `topics/git/reference/*.html`.

## Explicit Non-Goals
- Do not redesign the overall page typography or layout.
- Do not modify lesson content, curriculum text, or quiz scripts.
- Do not alter cross-topic isolation boundaries.
