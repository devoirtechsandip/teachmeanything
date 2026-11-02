# Root Cause Analysis: Issue #7 (Missing Home Navigation)

## 1. Problem Description
Users navigating any lesson (`topics/git/lessons/*.html`) or reference card (`topics/git/reference/*.html`) encountered a dead-end navigation experience: there was no link or button to return to the root Learning Hub dashboard (`index.html`).

---

## 2. Hypothesis Analysis

### Hypothesis 1: Topic Isolation Over-Enforcement (Confirmed)
- **Investigation**: Per repository rules, topics are isolated, self-contained units under `topics/<topic-name>/`.
- **Finding**: During lesson templating, navigation headers were strictly populated with intra-topic links (previous lesson, next lesson, topic reference card). Inter-tier navigation linking back up to repository root (`../../../index.html`) was inadvertently omitted to avoid breaking isolation rules, failing to recognize that user-facing breadcrumb navigation back to root `index.html` is necessary.

### Hypothesis 2: Nav-Brand Overloading (Contributing Factor)
- **Investigation**: Inspected `.nav-brand` across all HTML files.
- **Finding**: The brand container `<a href="..." class="nav-brand">Git Mastery Hub</a>` was configured to link to `0001-why-git-and-the-snapshot-model.html` (or `#` in Lesson 1). While this allowed returning to the topic's first lesson, it gave users no mechanism to return to the multi-topic dashboard.

### Hypothesis 3: Template Omission (Confirmed)
- **Investigation**: Inspected lesson and reference templates in `topics/_template/` and existing assets.
- **Finding**: The navigation control bar (`.nav-controls`) had slots for theme toggle and intra-topic jumping, but lacked a dedicated global dashboard breadcrumb button.

---

## 3. Minimal Targeted Solution
1. In all 15 lessons (`topics/git/lessons/*.html`), add:
   - `<a href="../../../index.html" class="btn" style="padding: 0.4rem 0.85rem; font-size: 0.82rem;" title="Return to Learning Hub Home">🏠 Hub Home</a>` as the first item in `.sticky-nav .nav-controls`.
   - `<a href="../../../index.html" class="btn" style="margin-left: 0.5rem;">🏠 All Topics</a>` in `.lesson-footer`.
2. In all 15 reference cards (`topics/git/reference/*.html`), add:
   - `<a href="../../../index.html" class="btn" style="padding: 0.4rem 0.85rem; font-size: 0.82rem;" title="Return to Learning Hub Home">🏠 Hub Home</a>` in `.sticky-nav .nav-controls`.
3. In `scripts/build-site.sh`, verify reciprocal links from lessons/references to `dist/index.html`.

## 4. Documentation Impact
- Topic Documentation: None (internal curriculum terminology and records unaffected).
- Root Documentation: Updates to site navigation build and triage verification records.
