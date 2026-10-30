# Feature Brief: Live Lesson Deployment & Learning Hub

- **Feature ID**: `live-lesson-deployment`
- **Target Scope**: Repo-Wide Infrastructure
- **Requested By**: User
- **Status**: Specified (Approved for Acceptance Testing)
- **Reference ADR**: [ADR 0009: GitHub Pages Live Deployment Pipeline, Learning Hub Dashboard, and Clean Staging](file:///Users/sandipkumbhar/Documents/Personal/teachmeanything/docs/adr/0009-github-pages-live-deployment-and-learning-hub.md)

## Problem & Intent
When users visit the GitHub repository on `github.com/devoirtechsandip/teachmeanything`, clicking on interactive lesson files (e.g., `topics/git/lessons/0001-why-git-and-the-snapshot-model.html`) displays raw HTML/JS code rather than rendering the interactive web applications. 

This feature establishes an automated, free live deployment pipeline using **GitHub Pages** (via GitHub Actions) along with a root **Learning Hub Dashboard** (`index.html`), clean staging script (`scripts/build-site.sh`), and in-repo discoverability badges. This enables learners to experience all interactive lessons as live websites directly from browser URLs.

## Core Capabilities
1. **Automated GitHub Pages Deployment**: GitHub Actions workflow deploying to `https://devoirtechsandip.github.io/teachmeanything/` on push to `main`.
2. **Clean Staging (`dist/`)**: Shell script copying only public assets (`index.html`, `.nojekyll`, `topics/*/lessons/`, `topics/*/assets/`, `topics/*/reference/`), excluding `.git`, `.features`, `.triage`, and private notes.
3. **Learning Hub Dashboard**: Modern, responsive `index.html` cataloging all active learning topics with direct lesson links and visual indicators.
4. **Live Badges & In-Repo Links**: Badges in `README.md` and topic learning records pointing to the live web versions.
5. **PR Preview Support**: Ephemeral preview deployment workflow for pull requests with graceful opt-in.

## Explicit Non-Goals
- Server-side rendering (SSR) or dynamic backend databases (architecture remains 100% static client-side).
- Violating topic boundaries (each topic's assets and lessons remain self-contained under `topics/<topic>/`).
- Heavy node/npm build dependencies (the staging script uses zero-dependency POSIX shell tools).
