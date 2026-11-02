#!/usr/bin/env bash
# ==============================================================================
# .triage/issue-7-nav-home-link-missing/reproduce.sh
# Hard Red Gate Reproduction Script for GitHub Issue #7
# Validates that all topic screens provide a navigation link back to root index.html
# ==============================================================================
set -euo pipefail

echo "=========================================================="
echo "QA Reproduction Check: Issue #7 (Missing Home Navigation)"
echo "=========================================================="

FAILED=0

LESSONS=(
  "topics/git/lessons/0001-why-git-and-the-snapshot-model.html"
  "topics/git/lessons/0002-the-three-areas-and-first-commit.html"
  "topics/git/lessons/0003-history-diffs-and-hygiene.html"
  "topics/git/lessons/0004-branches-as-lightweight-pointers.html"
  "topics/git/lessons/0005-fast-forward-vs-three-way-merges.html"
  "topics/git/lessons/0006-battle-tested-merge-conflicts.html"
  "topics/git/lessons/0007-remotes-demystified-origin-and-clone.html"
  "topics/git/lessons/0008-team-synchronization-fetch-pull-push.html"
  "topics/git/lessons/0009-discarding-uncommitted-work-git-restore.html"
  "topics/git/lessons/0010-safe-undos-vs-history-rewrites-revert-vs-reset.html"
  "topics/git/lessons/0011-shelving-work-in-progress-git-stash.html"
  "topics/git/lessons/0012-rebase-vs-merge-clean-linear-history.html"
  "topics/git/lessons/0013-pr-ready-interactive-rebase.html"
  "topics/git/lessons/0014-the-ultimate-safety-net-reflog-and-detached-head.html"
  "topics/git/lessons/0015-under-the-hood-the-git-object-store.html"
)

REFERENCES=(
  "topics/git/reference/01-why-and-core-mental-model.html"
  "topics/git/reference/02-the-three-areas-and-staging.html"
  "topics/git/reference/03-history-diffs-and-hygiene.html"
  "topics/git/reference/04-branching-and-switching.html"
  "topics/git/reference/05-merging-fast-forward-and-three-way.html"
  "topics/git/reference/06-resolving-merge-conflicts.html"
  "topics/git/reference/07-remotes-and-tracking-branches.html"
  "topics/git/reference/08-syncing-fetch-pull-push.html"
  "topics/git/reference/09-undoing-with-git-restore.html"
  "topics/git/reference/10-revert-vs-reset.html"
  "topics/git/reference/11-git-stash-handbook.html"
  "topics/git/reference/12-rebase-vs-merge.html"
  "topics/git/reference/13-interactive-rebase-pr-hygiene.html"
  "topics/git/reference/14-git-reflog-and-recovery.html"
  "topics/git/reference/15-git-object-store-internals.html"
)

echo "1. Checking Lessons for Home navigation link (../../../index.html)..."
for file in "${LESSONS[@]}"; do
  if [ ! -f "${file}" ]; then
    echo "  ❌ File not found: ${file}"
    FAILED=$((FAILED + 1))
    continue
  fi

  if grep -q 'href="../../../index.html"' "${file}" && grep -q 'Hub Home' "${file}"; then
    echo "  ✓ PASS: ${file}"
  else
    echo "  ❌ FAIL (No Home Link): ${file}"
    FAILED=$((FAILED + 1))
  fi
done

echo "2. Checking Reference Cards for Home navigation link (../../../index.html)..."
for file in "${REFERENCES[@]}"; do
  if [ ! -f "${file}" ]; then
    echo "  ❌ File not found: ${file}"
    FAILED=$((FAILED + 1))
    continue
  fi

  if grep -q 'href="../../../index.html"' "${file}" && grep -q 'Hub Home' "${file}"; then
    echo "  ✓ PASS: ${file}"
  else
    echo "  ❌ FAIL (No Home Link): ${file}"
    FAILED=$((FAILED + 1))
  fi
done

echo "=========================================================="
if [ "${FAILED}" -gt 0 ]; then
  echo "❌ RED GATE TRIGGERED: ${FAILED} of 30 files are missing Home link!"
  exit 1
else
  echo "✅ GREEN GATE VERIFIED: All 30 files contain Home navigation link."
  exit 0
fi
