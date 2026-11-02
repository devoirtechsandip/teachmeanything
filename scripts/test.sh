#!/usr/bin/env bash
# ==============================================================================
# scripts/test.sh
# Unified Test Runner for TeachMeAnything Learning Hub
# Discovers and executes all feature and topic acceptance test suites per ADR 0003 & 0011.
# ==============================================================================
set -euo pipefail

echo "=========================================================="
echo "TeachMeAnything Unified Test Runner"
echo "=========================================================="

FAILED_SUITES=0
PASSED_SUITES=0
TOTAL_SUITES=0

run_suite() {
  local suite_path="$1"
  local suite_name
  suite_name="$(basename "$(dirname "${suite_path}")")"
  TOTAL_SUITES=$((TOTAL_SUITES + 1))

  echo ""
  echo "----------------------------------------------------------"
  echo "▶ Running Suite [${TOTAL_SUITES}]: ${suite_name} (${suite_path})"
  echo "----------------------------------------------------------"

  if bash "${suite_path}"; then
    echo "✅ SUITE PASSED: ${suite_name}"
    PASSED_SUITES=$((PASSED_SUITES + 1))
  else
    echo "❌ SUITE FAILED: ${suite_name}" >&2
    FAILED_SUITES=$((FAILED_SUITES + 1))
  fi
}

# 1. Feature acceptance test suites
while IFS= read -r -d '' test_script; do
  run_suite "${test_script}"
done < <(find .features -name "acceptance-tests.sh" -type f -print0 | sort -z)

# 2. Topic-specific acceptance test suites
while IFS= read -r -d '' test_script; do
  run_suite "${test_script}"
done < <(find topics -name "acceptance-tests.sh" -type f -print0 | sort -z)

# 3. Distribution Staging & Link Integrity Verification
TOTAL_SUITES=$((TOTAL_SUITES + 1))
echo ""
echo "----------------------------------------------------------"
echo "▶ Running Suite [${TOTAL_SUITES}]: Distribution Build & Relative Link Sanity Gate"
echo "----------------------------------------------------------"
TEMP_DIST="test-dist-runner"
if bash scripts/build-site.sh "${TEMP_DIST}"; then
  rm -rf "${TEMP_DIST}"
  echo "✅ SUITE PASSED: Distribution Build & Relative Link Integrity"
  PASSED_SUITES=$((PASSED_SUITES + 1))
else
  rm -rf "${TEMP_DIST}"
  echo "❌ SUITE FAILED: Distribution Build & Relative Link Integrity" >&2
  FAILED_SUITES=$((FAILED_SUITES + 1))
fi

echo ""
echo "=========================================================="
echo "Test Execution Summary"
echo "=========================================================="
echo "Total Suites Executed : ${TOTAL_SUITES}"
echo "Passed                : ${PASSED_SUITES}"
echo "Failed                : ${FAILED_SUITES}"
echo "=========================================================="

if [ "${FAILED_SUITES}" -gt 0 ]; then
  echo "❌ Unified Test Run FAILED with ${FAILED_SUITES} failing suite(s)." >&2
  exit 1
fi

echo "✅ All ${TOTAL_SUITES} test suites PASSED successfully!"
exit 0
