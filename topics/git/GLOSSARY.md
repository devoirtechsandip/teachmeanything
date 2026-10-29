# Git Glossary

The canonical terminology for the Git teaching workspace. Terms are promoted here as understanding is validated through lessons and exercises.

## Terms

**Repository (Repo)**:
A directory containing a `.git` database and a working tree, tracking changes across revisions.

**Commit**:
An immutable snapshot of the staged project state, identified by a cryptographic SHA-1/SHA-256 hash and referencing zero or more parent commits.

**Index (Staging Area)**:
The intermediate binary cache (`.git/index`) where changes are prepared before forming a commit.

**Working Tree**:
The actual files checked out on the local disk available for editing.

**HEAD**:
The reference pointer indicating the currently checked-out commit, branch tip, or detached commit in the working tree.

**Blob**:
Git's internal object representing binary file data without filename or metadata.

**Tree Object**:
Git's internal object representing a directory, mapping blob hashes to filenames and permissions.

**Ref (Reference)**:
A human-readable pointer stored in `.git/refs/` that holds a commit SHA (e.g., branches, tags).
