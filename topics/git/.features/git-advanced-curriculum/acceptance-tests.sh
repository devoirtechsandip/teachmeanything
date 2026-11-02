#!/usr/bin/env bash
# ==============================================================================
# topics/git/.features/git-advanced-curriculum/acceptance-tests.sh
# Automated Acceptance Test Suite for Git Advanced Curriculum (Modules 2–7)
# ==============================================================================
set -euo pipefail

echo "=========================================================="
echo "Running QA Acceptance Tests: Git Advanced Curriculum"
echo "=========================================================="

FAILED=0

# 1. Verify all 15 Lessons exist
EXPECTED_LESSONS=(
  "0001-why-git-and-the-snapshot-model.html"
  "0002-the-three-areas-and-first-commit.html"
  "0003-history-diffs-and-hygiene.html"
  "0004-branches-as-lightweight-pointers.html"
  "0005-fast-forward-vs-three-way-merges.html"
  "0006-battle-tested-merge-conflicts.html"
  "0007-remotes-demystified-origin-and-clone.html"
  "0008-team-synchronization-fetch-pull-push.html"
  "0009-discarding-uncommitted-work-git-restore.html"
  "0010-safe-undos-vs-history-rewrites-revert-vs-reset.html"
  "0011-shelving-work-in-progress-git-stash.html"
  "0012-rebase-vs-merge-clean-linear-history.html"
  "0013-pr-ready-interactive-rebase.html"
  "0014-the-ultimate-safety-net-reflog-and-detached-head.html"
  "0015-under-the-hood-the-git-object-store.html"
)

echo "1. Checking presence of all 15 HTML lessons..."
for lesson in "${EXPECTED_LESSONS[@]}"; do
  file="topics/git/lessons/${lesson}"
  if [ -f "${file}" ]; then
    echo "  ✓ Found: ${lesson}"
  else
    echo "  ❌ Missing: ${lesson}"
    FAILED=$((FAILED + 1))
  fi
done

# 2. Verify all 15 Reference cards exist
EXPECTED_REFS=(
  "01-why-and-core-mental-model.html"
  "02-the-three-areas-and-staging.html"
  "03-history-diffs-and-hygiene.html"
  "04-branching-and-switching.html"
  "05-merging-fast-forward-and-three-way.html"
  "06-resolving-merge-conflicts.html"
  "07-remotes-and-tracking-branches.html"
  "08-syncing-fetch-pull-push.html"
  "09-undoing-with-git-restore.html"
  "10-revert-vs-reset.html"
  "11-git-stash-handbook.html"
  "12-rebase-vs-merge.html"
  "13-interactive-rebase-pr-hygiene.html"
  "14-git-reflog-and-recovery.html"
  "15-git-object-store-internals.html"
)

echo "2. Checking presence of all 15 reference cards..."
for ref in "${EXPECTED_REFS[@]}"; do
  file="topics/git/reference/${ref}"
  if [ -f "${file}" ]; then
    echo "  ✓ Found: ${ref}"
  else
    echo "  ❌ Missing: ${ref}"
    FAILED=$((FAILED + 1))
  fi
done

# 3. Verify ADR 0001 presence
echo "3. Checking ADR 0001..."
if [ -f "topics/git/reference/0001-adr-advanced-curriculum-architecture-and-standards.md" ]; then
  echo "  ✓ ADR 0001 verified"
else
  echo "  ❌ Missing ADR 0001"
  FAILED=$((FAILED + 1))
fi

# 4. Verify Site Staging & Link Integrity
echo "4. Executing site distribution build and sanity link check..."
if bash scripts/build-site.sh; then
  echo "  ✓ Distribution build and links verified"
else
  echo "  ❌ Build script failed"
  FAILED=$((FAILED + 1))
fi

# 5. Verify Topic Isolation
echo "5. Verifying Strict Topic Isolation..."
LEAKS=$(grep -rn "topics/dot""net" --exclude="*.sh" topics/git/ 2>/dev/null || true)
if [ -z "${LEAKS}" ]; then
  echo "  ✓ Topic isolation verified (zero cross-topic contamination)"
else
  echo "  ❌ Cross-topic leaks detected!"
  FAILED=$((FAILED + 1))
fi

echo "=========================================================="
if [ "${FAILED}" -eq 0 ]; then
  echo "✅ ALL ACCEPTANCE TESTS PASSED!"
  exit 0
else
  echo "❌ ${FAILED} ACCEPTANCE TEST(S) FAILED!"
  exit 1
fi
