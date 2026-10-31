#!/bin/bash
set -euo pipefail

echo "=========================================================="
echo "Running Acceptance Test Suite: Continuous Doc Sync"
echo "=========================================================="

FAILED=0

check_test() {
  local desc="$1"
  local cmd="$2"
  echo -n "Checking: $desc ... "
  if eval "$cmd" > /dev/null 2>&1; then
    echo "PASS"
  else
    echo "FAIL"
    FAILED=$((FAILED + 1))
  fi
}

# 1. ADR 0010 Verification
check_test "ADR 0010 exists" "test -f docs/adr/0010-continuous-documentation-synchronization.md"
check_test "ADR 0010 is Accepted" "grep -q 'Accepted' docs/adr/0010-continuous-documentation-synchronization.md"
check_test "ADR 0010 defines doc-sync" "grep -q 'The \`doc-sync\` Skill' docs/adr/0010-continuous-documentation-synchronization.md"

# 2. doc-sync Skill Definition
check_test "doc-sync SKILL.md exists" "test -f .agents/skills/doc-sync/SKILL.md"
check_test "doc-sync defines topic boundary" "grep -q 'Strict Boundary' .agents/skills/doc-sync/SKILL.md"
check_test "doc-sync defines 4-tier inspection" "grep -q 'Tier 1: Ubiquitous Language' .agents/skills/doc-sync/SKILL.md"
check_test "doc-sync defines exemption rationale" "grep -q 'Exemption Rationale Policy' .agents/skills/doc-sync/SKILL.md"

# 3. Triage Orchestrator Integration
check_test "triage-orchestrator defines Phase 3.5" "grep -q 'Phase 3.5: Continuous Documentation Synchronization' .agents/skills/triage-orchestrator/SKILL.md"
check_test "triage-orchestrator enforces QA doc review in Axis A" "grep -q 'Axis A (Standards & Documentation Freshness per ADR 0010)' .agents/skills/triage-orchestrator/SKILL.md"
check_test "triage-orchestrator packages doc sync in Commit 3" "grep -q 'docs(<subsystem>): record QA verification, security audit, and doc sync' .agents/skills/triage-orchestrator/SKILL.md"

# 4. Feature Orchestrator Integration
check_test "feature-orchestrator defines Phase 3.5" "grep -q 'Phase 3.5: Continuous Documentation Synchronization' .agents/skills/feature-orchestrator/SKILL.md"
check_test "feature-orchestrator enforces QA doc review in Axis A" "grep -q 'Axis A (Standards & Documentation Freshness per ADR 0010)' .agents/skills/feature-orchestrator/SKILL.md"
check_test "feature-orchestrator packages doc sync in Commit 3" "grep -q 'docs(<subsystem>): record QA verification, security audit, and doc sync' .agents/skills/feature-orchestrator/SKILL.md"

# 5. Code Review Gate
check_test "code-review skill includes Documentation Freshness Gate" "grep -q 'Documentation Freshness Gate (ADR 0010)' .agents/skills/code-review/SKILL.md"

# 6. Repository Rules
check_test "AGENTS.md mandates continuous doc sync in Section 5" "grep -q '## 5. Continuous Documentation Synchronization' AGENTS.md"
check_test "GEMINI.md enforces doc sync directive" "grep -q 'Continuous Documentation Synchronization' GEMINI.md"

# 7. Context & Language
check_test "CONTEXT.md records Continuous Documentation Synchronization" "grep -q 'Continuous Documentation Synchronization' CONTEXT.md"
check_test "CONTEXT.md includes doc-sync capability" "grep -q 'Doc Sync (\`doc-sync\`)' CONTEXT.md"

# 8. Operational Readme
check_test "README.md catalogs doc-sync skill" "grep -q '\`doc-sync\`' README.md"

echo "=========================================================="
if [ "$FAILED" -eq 0 ]; then
  echo "✅ All Acceptance Tests PASSED!"
  exit 0
else
  echo "❌ $FAILED Acceptance Test(s) FAILED!"
  exit 1
fi
