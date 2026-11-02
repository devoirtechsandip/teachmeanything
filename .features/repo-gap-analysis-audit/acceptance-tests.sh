#!/bin/bash
set -euo pipefail

echo "=========================================================="
echo "Running Acceptance Test Suite: Repository Gap Analysis (repo-audit)"
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

# 1. ADR 0011 Verification
check_test "ADR 0011 exists" "test -f docs/adr/0011-repository-gap-analysis-and-audit-skill.md"
check_test "ADR 0011 is Accepted" "grep -q 'Status' docs/adr/0011-repository-gap-analysis-and-audit-skill.md && grep -q 'Accepted' docs/adr/0011-repository-gap-analysis-and-audit-skill.md"
check_test "ADR 0011 defines 6-axis taxonomy" "grep -q '6-Axis Evaluation Taxonomy' docs/adr/0011-repository-gap-analysis-and-audit-skill.md"
check_test "ADR 0011 defines stack autodetection" "grep -q 'Stack Autodetection' docs/adr/0011-repository-gap-analysis-and-audit-skill.md"
check_test "ADR 0011 defines dry-run matrix & deduplication" "grep -q 'Interactive Dry-Run Matrix & Deduplication Gate' docs/adr/0011-repository-gap-analysis-and-audit-skill.md"
check_test "ADR 0011 defines .audits/ persistence" "grep -q 'Persistent Version-Controlled History' docs/adr/0011-repository-gap-analysis-and-audit-skill.md"
check_test "ADR 0011 defines autonomous resolution triggers" "grep -q 'Autonomous Resolution Trigger' docs/adr/0011-repository-gap-analysis-and-audit-skill.md"

# 2. Antigravity Skill Definition
check_test "Antigravity repo-audit SKILL.md exists" "test -f .agents/skills/repo-audit/SKILL.md"
check_test "Antigravity skill defines 6 evaluation axes" "grep -q 'audit:docs' .agents/skills/repo-audit/SKILL.md && grep -q 'audit:tests' .agents/skills/repo-audit/SKILL.md && grep -q 'audit:security' .agents/skills/repo-audit/SKILL.md && grep -q 'audit:arch' .agents/skills/repo-audit/SKILL.md && grep -q 'audit:ui' .agents/skills/repo-audit/SKILL.md && grep -q 'audit:devops' .agents/skills/repo-audit/SKILL.md"
check_test "Antigravity skill defines P0-P3 priority rubric" "grep -q 'priority:P0' .agents/skills/repo-audit/SKILL.md && grep -q 'priority:P3' .agents/skills/repo-audit/SKILL.md"
check_test "Antigravity skill defines deduplication query" "grep -q 'gh issue list --state all' .agents/skills/repo-audit/SKILL.md"
check_test "Antigravity skill defines dry-run table" "grep -q 'Render Interactive Dry-Run Table' .agents/skills/repo-audit/SKILL.md"
check_test "Antigravity skill defines autonomous triggers" "grep -q 'triage-orchestrator' .agents/skills/repo-audit/SKILL.md && grep -q 'feature-orchestrator' .agents/skills/repo-audit/SKILL.md"

# 3. Tri-Platform Parity (ADR 0006)
check_test "Cursor skill exists" "test -f .cursor/skills/repo-audit/SKILL.md"
check_test "Cursor rule exists" "test -f .cursor/rules/repo-audit.mdc"
check_test "GitHub Copilot skill exists" "test -f .github/skills/repo-audit/SKILL.md"
check_test "GitHub Copilot instructions include audit" "grep -q 'Repository Gap Analysis & Audit Workflow' .github/copilot-instructions.md"

# 4. Canonical Context & Ubiquitous Language
check_test "CONTEXT.md records Repository Gap Analysis & Audit System" "grep -q 'Repository Gap Analysis & Audit System' CONTEXT.md"
check_test "CONTEXT.md defines 6-Axis Gap Taxonomy" "grep -q '6-Axis Gap Taxonomy' CONTEXT.md"
check_test "CONTEXT.md defines Stack Profile" "grep -q 'Stack Profile' CONTEXT.md"
check_test "CONTEXT.md defines Interactive Dry-Run Matrix" "grep -q 'Interactive Dry-Run Matrix' CONTEXT.md"
check_test "CONTEXT.md defines Issue Deduplication Engine" "grep -q 'Issue Deduplication Engine' CONTEXT.md"

# 5. Repository Policies & Guidelines
check_test "AGENTS.md mandates repo-audit in Section 6" "grep -q '## 6. Repository Gap Analysis & Health Audit' AGENTS.md"
check_test "GEMINI.md enforces repo-audit directive" "grep -q 'Repository Gap Analysis & Audit System' GEMINI.md"

# 6. User Facing Documentation
check_test "README.md catalogs repo-audit in Skills Arsenal" "grep -q '\`repo-audit\`' README.md"

# 7. Build Site Validation
check_test "Build site validator succeeds cleanly" "./scripts/build-site.sh > /dev/null 2>&1"

echo "=========================================================="
if [ "$FAILED" -eq 0 ]; then
  echo "✅ All Acceptance Tests PASSED (Green Gate Achieved)!"
  exit 0
else
  echo "❌ $FAILED Acceptance Tests FAILED (Red Gate Active)!"
  exit 1
fi
