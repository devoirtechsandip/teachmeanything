#!/usr/bin/env bash
set -uo pipefail

echo "=========================================================="
echo "Running Acceptance Test Suite for: live-lesson-deployment"
echo "=========================================================="

FAILURES=0
TOTAL=5

pass() {
  echo "  ✅ PASS: $1"
}

fail() {
  echo "  ❌ FAIL: $1"
  FAILURES=$((FAILURES + 1))
}

# Scenario 1: Staging Script and Artifact Generation
echo "[Scenario 1] Validating clean staging build into dist/..."
if [ ! -f "scripts/build-site.sh" ]; then
  fail "scripts/build-site.sh does not exist"
else
  rm -rf test-dist
  if bash scripts/build-site.sh test-dist > /dev/null 2>&1; then
    if [ -f "test-dist/index.html" ] && \
       [ -f "test-dist/.nojekyll" ] && \
       [ -f "test-dist/topics/git/lessons/0001-why-git-and-the-snapshot-model.html" ] && \
       [ -f "test-dist/topics/git/assets/style.css" ]; then
      pass "Staging script builds valid dist/ with index, .nojekyll, and topic assets"
    else
      fail "Staging script executed but missing expected output files in dist/"
    fi
  else
    fail "scripts/build-site.sh failed during execution"
  fi
  rm -rf test-dist
fi

# Scenario 2: Leak Prevention (No .features, .triage, .git, or .md in dist/)
echo "[Scenario 2] Validating internal governance leak prevention in dist/..."
if [ ! -f "scripts/build-site.sh" ]; then
  fail "Cannot test leak prevention: scripts/build-site.sh missing"
else
  rm -rf test-dist-leak
  bash scripts/build-site.sh test-dist-leak > /dev/null 2>&1 || true
  if [ -d "test-dist-leak/.git" ] || [ -d "test-dist-leak/.features" ] || [ -d "test-dist-leak/.triage" ]; then
    fail "Internal governance directories (.git, .features, .triage) leaked into dist/"
  else
    MD_COUNT=$(find test-dist-leak -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$MD_COUNT" -gt 0 ]; then
      fail "Private markdown notes leaked into dist/ ($MD_COUNT markdown files found)"
    else
      pass "No internal directories (.git, .features, .triage) or markdown files leaked into dist/"
    fi
  fi
  rm -rf test-dist-leak
fi

# Scenario 3: Broken Link Sanity Detection
echo "[Scenario 3] Validating broken link sanity gate..."
if [ ! -f "scripts/build-site.sh" ] || [ ! -f "index.html" ]; then
  fail "Cannot test link sanity: scripts/build-site.sh or index.html missing"
else
  # Create a temporary corrupted index.html with a broken href
  cp index.html index.html.bak
  sed -i.tmp 's|</body>|<a href="./topics/git/lessons/nonexistent-broken-file.html">Broken</a></body>|' index.html
  rm -f index.html.tmp
  
  rm -rf test-dist-broken
  if bash scripts/build-site.sh test-dist-broken > /dev/null 2>&1; then
    fail "scripts/build-site.sh did not fail when broken links were injected"
  else
    pass "scripts/build-site.sh properly detected broken link and exited non-zero"
  fi
  
  mv index.html.bak index.html
  rm -rf test-dist-broken
fi

# Scenario 4: GitHub Actions Workflow Contract
echo "[Scenario 4] Validating GitHub Actions deploy workflow contract..."
WORKFLOW_FILE=".github/workflows/deploy.yml"
if [ ! -f "$WORKFLOW_FILE" ]; then
  fail "$WORKFLOW_FILE does not exist"
else
  HAS_PAGES_PERM=$(grep -E 'pages:\s*write' "$WORKFLOW_FILE" || true)
  HAS_TOKEN_PERM=$(grep -E 'id-token:\s*write' "$WORKFLOW_FILE" || true)
  HAS_BUILD_STEP=$(grep -E 'scripts/build-site.sh' "$WORKFLOW_FILE" || true)
  HAS_DEPLOY_ACTION=$(grep -E 'actions/deploy-pages@v4' "$WORKFLOW_FILE" || true)
  
  if [ -n "$HAS_PAGES_PERM" ] && [ -n "$HAS_TOKEN_PERM" ] && [ -n "$HAS_BUILD_STEP" ] && [ -n "$HAS_DEPLOY_ACTION" ]; then
    pass "$WORKFLOW_FILE satisfies schema, permissions, staging, and deploy-pages contract"
  else
    fail "$WORKFLOW_FILE missing required permissions or action steps"
  fi
fi

# Scenario 5: Documentation & In-Repo Badges
echo "[Scenario 5] Validating README.md live deployment badges..."
LIVE_URL="https://devoirtechsandip.github.io/teachmeanything/"
if grep -F "$LIVE_URL" README.md > /dev/null 2>&1; then
  pass "README.md contains live GitHub Pages URL"
else
  fail "README.md does not reference live GitHub Pages URL ($LIVE_URL)"
fi

echo "=========================================================="
echo "Summary: $((TOTAL - FAILURES))/$TOTAL scenarios passed ($FAILURES failed)"
echo "=========================================================="

if [ "$FAILURES" -gt 0 ]; then
  exit 1
fi
exit 0
