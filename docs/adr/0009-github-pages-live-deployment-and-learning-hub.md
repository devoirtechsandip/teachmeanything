# ADR 0009: GitHub Pages Live Deployment Pipeline, Learning Hub Dashboard, and Clean Staging

## Status
Accepted

## Context
Interactive lessons, simulators, and visual reference guides across topics (e.g., `topics/git/lessons/0001-why-git-and-the-snapshot-model.html`) are constructed as self-contained HTML/CSS/JavaScript web applications. 

When users browse the GitHub repository on `github.com/devoirtechsandip/teachmeanything`, clicking on `.html` files displays raw source code rather than executing the interactive web applications. To fulfill the platform's educational mission, learners must be able to run and interact with all lessons directly via live web URLs without needing to clone the repository or set up a local development environment.

Following the Socratic interview (`grill-with-docs`) in feature `live-lesson-deployment`, this ADR codifies the deployment architecture, root landing hub, staging script, and in-repo discoverability mechanisms.

## Decision

### 1. Primary Hosting: GitHub Pages via GitHub Actions
- The production learning hub will be hosted on **GitHub Pages** at `https://devoirtechsandip.github.io/teachmeanything/`.
- Deployed automatically on every push to `main` via a native GitHub Actions workflow (`.github/workflows/deploy.yml`) utilizing official GitHub Pages actions (`actions/configure-pages`, `actions/upload-pages-artifact`, `actions/deploy-pages`).
- Zero external secrets or third-party paid accounts are required for production hosting.

### 2. Clean Public Asset Staging (`dist/`) & Jekyll Bypass
- Direct publishing of repository root is forbidden to prevent leaking internal files (such as `.git/`, `.features/`, `.triage/`, and private agent notes).
- A zero-dependency POSIX shell script (`scripts/build-site.sh`) will stage clean public assets into an isolated `dist/` directory:
  - Root Learning Hub: `index.html`
  - Jekyll bypass marker: `.nojekyll` (ensuring directories starting with `_` or containing modern assets are not filtered by Jekyll)
  - Topic public assets: `topics/*/lessons/`, `topics/*/assets/`, and `topics/*/reference/`
- The script includes an automated link and asset sanity check to prevent broken relative paths.

### 3. Root Learning Hub Dashboard (`index.html`)
- A responsive, accessible dashboard at the root URL cataloging all active learning topics (e.g., Git, .NET) with cards displaying:
  - Topic title, badge, and mission statement.
  - Links to interactive lessons with status badges (e.g., Lesson 1, Lesson 2).
  - Quick-reference cards and visual guides.
- Adopts the project's unified dark/light modern UI design system (modern typography, CSS variables, interactive transitions).
- Uses strictly relative links (`./topics/<topic>/lessons/...`) ensuring total portability across subpaths (`/teachmeanything/`) and local preview servers.

### 4. Repository Discoverability & Live Badges
- The root `README.md` will feature a prominent "🚀 Live Interactive Curriculum Hub" badge and link pointing to the GitHub Pages deployment.
- Each topic `README.md` and learning record will provide direct "View Live Lesson" links to allow viewers browsing GitHub to jump to the rendered simulator with one click.

### 5. Ephemeral PR Preview Support (Opt-In)
- The GitHub Actions workflow will feature a dual-mode trigger:
  - Push to `main`: Deploys production to GitHub Pages.
  - Pull Requests: If `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` secrets are configured in GitHub Secrets, builds and deploys an ephemeral preview branch to Cloudflare Pages, posting the live preview URL as a PR comment. If secrets are not present, the PR check builds and validates `dist/` sanity without error, providing helpful setup instructions.

## Consequences

### Positive
- **Instant Learner Accessibility**: All interactive HTML simulators run immediately in any web browser.
- **Zero Cost & Minimal Maintenance**: GitHub Pages is free for public repositories and runs natively without managing server infrastructure.
- **Leak Prevention**: Clean staging (`dist/`) guarantees internal `.triage` and `.features` governance files are never publicly exposed on the web.
- **Total Portability**: Relative asset paths preserve functionality locally, on GitHub Pages subpaths, or under custom domains.

### Negative / Trade-offs
- **Subpath URL Structure**: GitHub Pages hosts at `/teachmeanything/` rather than root `/`, requiring discipline to use relative paths (`./topics/...` and `../assets/...`) rather than absolute paths (`/assets/...`).
- **PR Preview Dependency**: Dynamic PR previews on Cloudflare Pages require optional GitHub Secrets configuration.
