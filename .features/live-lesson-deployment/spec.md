# Functional Specification: Live Lesson Deployment (`live-lesson-deployment`)

## 1. System Architecture & Contracts

### 1.1 Directory & File Layout
```text
teachmeanything/
├── .github/
│   └── workflows/
│       └── deploy.yml              # GitHub Actions Pages deployment & PR preview workflow
├── scripts/
│   └── build-site.sh               # POSIX staging script building dist/ with link verification
├── index.html                      # Root Learning Hub Dashboard
├── dist/                           # Gitignored public distribution artifact
│   ├── .nojekyll                   # GitHub Pages Jekyll bypass marker
│   ├── index.html                  # Root Learning Hub Dashboard
│   └── topics/
│       ├── git/
│       │   ├── assets/             # Topic CSS/JS/images
│       │   ├── lessons/            # Interactive HTML lessons
│       │   └── reference/          # Interactive visual cheat sheets
│       └── dotnet/
│           ├── assets/
│           ├── lessons/
│           └── reference/
└── README.md                       # Contains live deployment badge and portal URL
```

### 1.2 Component Specifications

#### Component A: Staging Script (`scripts/build-site.sh`)
- **Executable**: `bash scripts/build-site.sh [target_dir]` (defaults to `dist`).
- **Behaviors**:
  1. Purges and recreates target directory (`dist/`).
  2. Creates `dist/.nojekyll`.
  3. Copies root `index.html` to `dist/index.html`.
  4. Recursively copies only public web deliverables (`.html`, `.css`, `.js`, `.svg`, `.png`, `.jpg`, `.webp`) from `topics/*/lessons/`, `topics/*/assets/`, and `topics/*/reference/`.
  5. Strictly excludes internal governance directories: `.git/`, `.features/`, `.triage/`, `.agents/`, `.cursor/`, and markdown notes (`MISSION.md`, `NOTES.md`, `RESOURCES.md`, `GLOSSARY.md`, `learning-records/`).
  6. **Link Sanity Gate**: Parses all `<a href="...">` and `<link href="...">` and `<script src="...">` inside `dist/index.html` and ensures target files physically exist in `dist/`. Exits with code `1` if broken links are discovered.
  7. Returns exit code `0` on successful build.

#### Component B: Learning Hub Dashboard (`index.html`)
- **Semantic HTML5**: Responsive layout with header, hero banner, topic cards grid, and footer.
- **Unified Design System**: Incorporates CSS variables and themes matching `topics/git/assets/style.css` (Dark theme default with high-contrast text and luminous accent glows).
- **Topic Cards**: Displays topic badges, topic description, and clickable lesson lists (e.g., Lesson 1: Why Git & The Snapshot Model, Lesson 2: The Three Areas & First Commit).
- **Portability**: All asset links and hrefs MUST be strictly relative (`./topics/...`) to support subpaths like `/teachmeanything/`.

#### Component C: CI/CD Workflow (`.github/workflows/deploy.yml`)
- **Triggers**:
  - `push` to `main` branch.
  - `pull_request` against `main` branch.
  - `workflow_dispatch` (manual run).
- **Permissions Required**:
  ```yaml
  permissions:
    contents: read
    pages: write
    id-token: write
  ```
- **Jobs**:
  - `build`: Runs `scripts/build-site.sh`, uploads GitHub Pages artifact via `actions/upload-pages-artifact@v3`.
  - `deploy`: (Runs only on `main` push) Deploys via `actions/deploy-pages@v4`.
  - `pr-preview`: (Runs on pull requests) If `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` are present in repository secrets, deploys preview to Cloudflare Pages; otherwise outputs informational step.

#### Component D: Repository Documentation Badges
- Root `README.md` must display:
  - Live Hub badge: `[![Live Site](https://img.shields.io/badge/Live_Hub-GitHub_Pages-2ea44f?logo=github)](https://devoirtechsandip.github.io/teachmeanything/)`
  - Direct link to `https://devoirtechsandip.github.io/teachmeanything/`.
- Topic learning records in `topics/git/learning-records/` must feature a direct "Interactive Lesson URL" linking to the GitHub Pages hosted simulator.

---

## 2. Testable Acceptance Criteria (Gherkin Format)

### Scenario 1: Clean Distribution Staging
- **Given** the repository root contains `index.html` and topic lesson directories in `topics/`
- **When** the developer executes `bash scripts/build-site.sh dist`
- **Then** the script exits with code `0`
- **And** `dist/index.html` exists
- **And** `dist/.nojekyll` exists
- **And** `dist/topics/git/lessons/0001-why-git-and-the-snapshot-model.html` exists
- **And** `dist/topics/git/assets/style.css` exists

### Scenario 2: Governance & Secret Leak Prevention
- **Given** the repository contains internal directories `.git/`, `.features/`, and `.triage/`
- **When** the developer executes `bash scripts/build-site.sh dist`
- **Then** `dist/.features` does not exist
- **And** `dist/.triage` does not exist
- **And** `dist/.git` does not exist
- **And** no `.md` files exist inside `dist/`

### Scenario 3: Broken Link Sanity Detection
- **Given** an invalid link `<a href="./topics/git/lessons/nonexistent.html">` is injected into `index.html`
- **When** `bash scripts/build-site.sh dist` is executed
- **Then** the script detects the missing target
- **And** the script exits with a non-zero exit code (`1`)
- **And** emits an error message specifying the broken path

### Scenario 4: GitHub Actions Workflow Contract
- **Given** `.github/workflows/deploy.yml` is defined
- **When** validated against the GitHub Actions schema
- **Then** it declares `pages: write` and `id-token: write` permissions
- **And** it executes `scripts/build-site.sh`
- **And** it references `actions/upload-pages-artifact` and `actions/deploy-pages`
- **And** it targets branch `main` for production deployment

### Scenario 5: Documentation & Discoverability
- **Given** `README.md` is updated
- **When** inspected for live deployment references
- **Then** it contains the URL `https://devoirtechsandip.github.io/teachmeanything/`
- **And** it includes a clickable badge or link to the Live Hub
