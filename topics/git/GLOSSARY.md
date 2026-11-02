# Git Glossary

The canonical terminology for the Git teaching workspace. Terms are promoted here as understanding is validated through lessons and exercises.

## Terms

**Repository (Repo)**:
A directory containing a `.git` database and a working tree, tracking changes across revisions.

**Commit**:
An immutable snapshot of the staged project state, identified by a cryptographic SHA-1/SHA-256 hash and referencing zero or more parent commits.

**Snapshot**:
A complete point-in-time picture of all tracked files in a project. If a file has not changed since the last snapshot, Git links to the existing file rather than re-storing it.

**Delta**:
A set of line-by-line differences between two revisions of a file (the model used by older systems like SVN, distinct from Git's snapshot model).

**Index (Staging Area)**:
The intermediate binary cache (`.git/index`) where changes are prepared before forming a commit.

**Working Tree (Working Directory)**:
The actual files checked out on the local disk available for editing and experimenting.

**HEAD**:
The reference pointer indicating the currently checked-out commit, branch tip, or detached commit in the working tree.

**Blob**:
Git's internal object representing binary file data without filename or metadata.

**Tree Object**:
Git's internal object representing a directory, mapping blob hashes to filenames and permissions.

**Ref (Reference)**:
A human-readable pointer stored in `.git/refs/` that holds a commit SHA (e.g., branches, tags).

**Fast-Forward Merge**:
A merge operation where the target branch has no diverging commits from the incoming branch, allowing Git to simply advance the branch pointer forward without generating an extra merge commit.

**Three-Way Merge**:
A merge operation where two branches have diverged from a common ancestor (merge base), requiring Git to synthesize changes across the ancestor and both branch tips, generating a new merge commit with two parents.

**Merge Conflict**:
A state occurring during a merge or rebase where Git encounters contradictory edits on the same lines across revisions, halting execution and inserting conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) for manual resolution.

**Remote Tracking Branch**:
A read-only local reference (e.g., `origin/main`) that mirrors the state of a branch on a remote server as of the most recent `git fetch` or `git pull`.

**Rebase**:
The mechanism of lifting a sequence of commits from their original base and re-applying them sequentially onto another commit, producing a linear history without merge commits.

**Interactive Rebase (`git rebase -i`)**:
A command-line tool allowing developers to rewrite local commit history by squashing, editing, rewording, or dropping commits before publishing changes.

**Reflog (Reference Log)**:
A local, private journal in `.git/logs/` recording every update made to `HEAD` and branch references, enabling the recovery of orphaned commits or lost branches.

**Detached HEAD**:
A state where `HEAD` points directly to a specific commit hash rather than a named branch reference, meaning subsequent commits will not belong to any branch unless a new branch is explicitly created.
