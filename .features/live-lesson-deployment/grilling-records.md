# Grilling Records: Live Lesson Deployment (`live-lesson-deployment`)

- **Interview Lead**: Coordinator Agent
- **Participant**: Human User / Architect
- **Methodology**: Socratic Dependency-Aware Grilling (`grill-with-docs`)
- **Status**: Complete & Converged

---

## Round 1: Foundational & Architectural Decisions

### Question 1: Hosting Platform Selection
- **Prompt**: Which free deployment platform do you want to use for hosting the interactive lessons?
- **Options Explored**:
  1. *(Recommended)* GitHub Pages via GitHub Actions (100% free, zero external accounts or secrets required, deploys natively to `https://devoirtechsandip.github.io/teachmeanything/`).
  2. Cloudflare Pages via Cloudflare Dashboard / Wrangler (Edge CDN + instant previews, but requires linking a Cloudflare account or configuring Cloudflare API tokens in GitHub Secrets).
  3. Dual Deployment (GitHub Pages as primary + Cloudflare Pages as secondary mirror).
- **Decision**: **GitHub Pages via GitHub Actions**.
- **Rationale**: Keeps the infrastructure 100% native to GitHub, requires zero external accounts, tokens, or subscription risks, and operates seamlessly on public repositories.

### Question 2: Root Website Experience (`index.html`)
- **Prompt**: What should visitors see when landing on the root website URL?
- **Options Explored**:
  1. *(Recommended)* Static Learning Hub Dashboard (A modern, responsive landing page `index.html` at root cataloging all topics, interactive lessons, and reference guides).
  2. Dynamic Manifest Generator (A lightweight CI script that scans `topics/*/lessons` during build to auto-generate the index manifest).
  3. Direct Topic Redirect (Redirect root URL immediately to the first topic, e.g. `topics/git/lessons/0001`).
- **Decision**: **Static Learning Hub Dashboard**.
- **Rationale**: Provides learners with an attractive central portal to browse topics (Git, .NET) and jump directly into any lesson with clear progress indicators.

### Question 3: In-Repository Discoverability & GitHub UX
- **Prompt**: How should we surface live website URLs within the GitHub repository for viewers?
- **Options Explored**:
  1. *(Recommended)* Comprehensive (Live badges in READMEs & lesson records + PR preview deployment comments).
  2. Live Badges & Direct Links only (Add badges and direct live links in root README, topic READMEs, and learning records).
  3. Minimal Deployment only (Just publish the site URL without modifying repo markdown files).
- **Decision**: **Comprehensive**.
- **Rationale**: Eliminates the confusion of viewing raw HTML on GitHub by giving users immediate clickable entrypoints to the live simulators from the repository files.

---

## Round 2: Technical Constraints, Asset Staging & PR Previews

### Question 4: Asset Staging and Packaging
- **Prompt**: How should the static website assets be staged and deployed to GitHub Pages?
- **Options Explored**:
  1. *(Recommended)* Staged Artifact Build (`dist/`) (A CI staging step copies only clean public assets: `index.html`, `topics/*/lessons`, `topics/*/assets`, and adds `.nojekyll`, excluding `.git`, `.features`, `.triage`, and private notes).
  2. Direct Repository Deployment (Deploy repository root directly with `.nojekyll` to GitHub Pages).
- **Decision**: **Staged Artifact Build (`dist/`)**.
- **Rationale**: Prevents accidental leakage of private agent notes, internal triage data (`.triage`), and feature planning documents (`.features`), while ensuring the Jekyll bypass (`.nojekyll`) is always present.

### Question 5: PR Preview Support
- **Prompt**: GitHub Pages only hosts one branch (`main`). How should pull request preview links be handled?
- **Options Explored**:
  1. *(Recommended)* Free Cloudflare Pages / Surge preview action on PRs (Deploys temporary preview URLs for pull requests, while GitHub Pages serves production main).
  2. `htmlpreview.github.io` Link Generator Bot (Zero external infrastructure).
  3. Production-Only Deployment (Skip PR ephemeral previews and focus deployment solely on `main`).
- **Decision**: **Free Cloudflare Pages / Surge preview action on PRs**.
- **Rationale**: Enables PR authors to test and preview interactive changes before merging to `main`.

### Question 6: Design System Alignment
- **Prompt**: What aesthetic and design system should the Learning Hub Landing Page (`index.html`) adopt?
- **Options Explored**:
  1. *(Recommended)* Unified Design System (Inherit dark/light theme, modern typography, and responsive CSS variables consistent with existing lesson assets).
  2. Minimalist Card Grid (Simple semantic HTML with minimal styling).
- **Decision**: **Unified Design System**.
- **Rationale**: Guarantees visual continuity between the central hub and the individual topic lessons.

---

## Round 3: Credentials, Build Tooling & Acceptance Contracts

### Question 7: Staging Build Runtime
- **Prompt**: Which runtime should execute the staging and link-verification build step?
- **Options Explored**:
  1. *(Recommended)* Zero-Dependency Shell Script (`scripts/build-site.sh`) (Lightweight POSIX bash script using `rsync`/`cp` and link verification, requires no node_modules or external runtimes).
  2. Node.js Staging Script (`scripts/build-site.js`).
  3. Python Staging Script (`scripts/build_site.py`).
- **Decision**: **Zero-Dependency Shell Script (`scripts/build-site.sh`)**.
- **Rationale**: Maximum speed, zero `npm install` overhead, highly deterministic, and runs identically on macOS, Linux, and GitHub Actions runners.

### Question 8: PR Preview Credentials Handling
- **Prompt**: How should the PR preview workflow handle Cloudflare Pages credentials?
- **Options Explored**:
  1. *(Recommended)* Graceful Opt-In (Deploy PR preview if `CLOUDFLARE_API_TOKEN` secret is configured; post helpful guidance if secret is not yet set).
  2. Strict Cloudflare Pages (Fail PR preview job if credentials are not configured).
  3. Surge.sh Fallback.
- **Decision**: **Graceful Opt-In**.
- **Rationale**: Prevents PR builds from failing when third-party secrets are not yet configured in GitHub, while allowing instant activation once tokens are added.
