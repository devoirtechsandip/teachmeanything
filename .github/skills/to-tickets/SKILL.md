---
name: to-tickets
description: Breaks down a specification or design plan into vertical-slice (tracer-bullet) tickets with explicit dependency blocking edges.
argument-hint: "[spec-file-or-issue] [--out=<dir>]"
disable-model-invocation: true
origin: "github.com/mattpocock/skills (MIT)"
---

# To-Tickets

Takes a finished specification or plan and decomposes it into an execution graph of atomic development tickets.

## Principles

1. **Tracer Bullets Over Horizontal Layers**:
   - Never create tickets that produce only backend schemas or only CSS without end-to-end functionality.
   - Every ticket must represent a narrow, vertical slice connecting through all necessary layers that can be run, tested, and verified independently upon landing.
2. **Context Window Sizing**:
   - Each ticket must be sized to complete within a single fresh agent session without requiring full memory of the entire repository history.
3. **Explicit Blocking Edges**:
   - Each ticket explicitly enumerates its prerequisites (`Blocked by: Ticket X`) so parallel or sequential execution order is unambiguous.

## Ticket Format

Each generated ticket (stored in `docs/tickets/` or output as markdown) must adhere to:

```markdown
### Ticket [ID]: [Imperative Title]

**Goal**: One sentence describing what becomes possible when this ticket lands.
**Blocked by**: None (or [Ticket ID])
**Files Modified/Created**:
- `path/to/file1.ext`
- `path/to/file2.ext`

**Implementation Details**:
- Concise steps and invariants.

**Verification Criteria**:
- [ ] Command or manual action to verify success.
- [ ] Expected observable behavior.
```
