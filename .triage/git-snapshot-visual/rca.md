# Root Cause Analysis: git-snapshot-visual

- **Target File**: `topics/git/assets/components.js`
- **Symptom**: "Visualizing the Git Snapshot Model" (`#animCanvas`) fails to render in browser.

---

## Ranked Falsifiable Hypotheses

### Hypothesis 1 (Confirmed Primary Root Cause)
- **Statement**: In `MiniTerminalSimulator` (line 203) and `ThreeTreesPipelineSimulator` (line 273), the constructor performs a guard clause `if (!container) return;` instead of `if (!this.container) return;`.
- **Mechanism**: Because `container` is not declared or in scope, JavaScript throws a `ReferenceError: container is not defined`. In `0001-why-git-and-the-snapshot-model.html`, `new MiniTerminalSimulator('terminalDemo')` is executed before `GitSnapshotSimulator`. The runtime unhandled exception terminates execution of the `<script>` block, preventing `GitSnapshotSimulator` from ever being initialized or rendering to `#animCanvas`.
- **Observable Evidence**: Node/browser runtime throws `ReferenceError: container is not defined` at `components.js:203:9`.

### Hypothesis 2 (Disproven)
- **Statement**: The DOM ID `#animCanvas` or `#animExplanation` is mismatched between HTML and JS.
- **Evidence**: Inspected HTML line 204 and JS line 435; both match `'animCanvas'` and `'animExplanation'` exactly.

### Hypothesis 3 (Disproven)
- **Statement**: CSS hides `#animCanvas` with `display: none` or `visibility: hidden`.
- **Evidence**: `style.css` defines `.stage-canvas { min-height: 280px; ... }` with no display:none. The element DOM content itself is completely empty because JS aborted prior to injection.

---

## Surgical Fix Plan
In `topics/git/assets/components.js`:
1. Line 203: Change `if (!container) return;` to `if (!this.container) return;` in `MiniTerminalSimulator`.
2. Line 273: Change `if (!container) return;` to `if (!this.container) return;` in `ThreeTreesPipelineSimulator` (preventing identical crash in Lesson 0002).
