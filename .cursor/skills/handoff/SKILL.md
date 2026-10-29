---
name: handoff
description: Compact the current conversation and session state into a structured handoff document so a fresh agent session can resume immediately without context loss.
argument-hint: "[--out=<path>] [what will the next session be used for?]"
disable-model-invocation: true
origin: "github.com/mattpocock/skills (MIT)"
---

# Handoff

Compact active conversation state into a concise, portable markdown document to allow seamless resumption in a new, unpolluted agent session.

## Why This Exists

As coding and learning sessions extend, context window bloat degrades model reasoning and increases latency. The handoff workflow extracts essential state into a durable document so you can open a fresh session without starting from scratch.

## Output Destination

By default, write the handoff document to the OS temporary directory (`$TMPDIR`, `/tmp/agent-handoff-<timestamp>.md`, or `%TEMP%`) rather than leaving temporary clutter in the git workspace, unless the user specifies a workspace path.

## Document Structure

The generated handoff file must include:

```markdown
# Session Handoff: [Topic / Feature Name]

**Date**: [YYYY-MM-DD]
**Active Topic / Scope**: [e.g. topics/git or root]
**Primary Mission / Objective**: [Current target goal]

---

## 1. Accomplished So Far
- [Summary of completed tasks, created files, or resolved decisions]

## 2. Key Architecture & Domain Decisions Made
- [ADRs created, glossary terms pinned down, or patterns established]

## 3. Current Work in Progress & Active Frontier
- [What is partially complete or currently being addressed]

## 4. Immediate Next Steps for the Next Session
1. [First action the new agent should run or check]
2. [Second action]

## 5. Important Files & References
- `path/to/relevant/file.ext`: [Purpose/relevance]
```

## Resumption Prompt

Provide the user with a single copy-paste prompt they can feed into the new agent session to resume work immediately.
