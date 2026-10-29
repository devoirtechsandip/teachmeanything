---
name: domain-modeling
description: Build and sharpen domain terminology, ubiquitous language, and record architectural decisions (ADRs) as decisions emerge.
origin: "github.com/mattpocock/skills (MIT)"
---

# Domain Modeling

Actively build and sharpen the project's domain model as you design. This is an active discipline: challenging ambiguous terms, inventing edge-case scenarios, and capturing glossary terms and decisions in markdown files the moment they crystallize.

## Context & File Structure

Inside a learning topic (e.g. `topics/<topic>/`):
```text
topics/<topic>/
├── GLOSSARY.md               # Canonical definitions of topic nomenclature
├── MISSION.md                # Purpose and boundaries
└── reference/
    ├── 0001-adr-<slug>.md    # Architecture decision records
    └── ...
```

Across the general repository root:
```text
/
├── CONTEXT.md                # Ubiquitous domain language across the system
└── docs/
    └── adr/
        ├── 0001-<decision>.md
        └── 0002-<decision>.md
```

Files are created or updated lazily: only when terms or architectural choices are resolved.

## During the Session

1. **Challenge Against the Glossary**:
   - When a user or agent uses a term in conflict with established definitions in `GLOSSARY.md` or `CONTEXT.md`, call it out immediately.
   - Refuse synonym drift: don't call an item an "exercise" in one place and a "task" or "lab" in another unless the distinction is intentional and defined.
2. **Stress-Test Boundaries**:
   - Push back on vague definitions. Probe what an entity is *not*, where its boundary lies, and what happens at lifecycle limits.
3. **Record Decisions in Real Time**:
   - Don't leave hard design decisions buried in conversational scrollback. Draft an ADR immediately when a choice is made.
   - Standard ADR sections:
     - **Title**: `000X-short-imperative-title.md`
     - **Status**: Proposed, Accepted, Superceded
     - **Context**: Problem statement, constraints, evaluated options
     - **Decision**: The selected path
     - **Consequences**: Benefits, trade-offs, and downstream impacts
