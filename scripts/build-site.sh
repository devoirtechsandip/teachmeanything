#!/usr/bin/env bash
# ==============================================================================
# scripts/build-site.sh
# Staging and link-verification script for TeachMeAnything Learning Hub
# Packages public web assets into dist/ while preventing internal governance leaks.
# ==============================================================================
set -euo pipefail

TARGET_DIR="${1:-dist}"

echo "=========================================================="
echo "Staging TeachMeAnything Learning Hub -> ${TARGET_DIR}/"
echo "=========================================================="

# 1. Clean target directory
rm -rf "${TARGET_DIR}"
mkdir -p "${TARGET_DIR}"

# 2. Add Jekyll bypass marker for GitHub Pages
touch "${TARGET_DIR}/.nojekyll"

# 3. Copy root Learning Hub Dashboard
if [ ! -f "index.html" ]; then
  echo "❌ Error: Root index.html not found!" >&2
  exit 1
fi
cp index.html "${TARGET_DIR}/index.html"

# 4. Copy topic public web deliverables (lessons, assets, reference)
for topic_dir in topics/*; do
  if [ ! -d "${topic_dir}" ]; then
    continue
  fi
  topic_name=$(basename "${topic_dir}")

  # Skip internal template scaffolding
  if [ "${topic_name}" = "_template" ]; then
    continue
  fi

  for section in lessons assets reference; do
    src_section="${topic_dir}/${section}"
    dest_section="${TARGET_DIR}/topics/${topic_name}/${section}"

    if [ -d "${src_section}" ]; then
      mkdir -p "${dest_section}"
      # Copy only public web assets, strictly excluding markdown notes or hidden files
      find "${src_section}" -maxdepth 1 -type f \( \
        -name "*.html" -o \
        -name "*.css" -o \
        -name "*.js" -o \
        -name "*.svg" -o \
        -name "*.png" -o \
        -name "*.jpg" -o \
        -name "*.jpeg" -o \
        -name "*.webp" -o \
        -name "*.json" \
      \) -exec cp {} "${dest_section}/" \; 2>/dev/null || true
    fi
  done
done

echo "✅ Web assets staged into ${TARGET_DIR}/"

# 5. Sanity Verification: Check internal links in index.html
echo "🔍 Validating relative links in ${TARGET_DIR}/index.html..."
BROKEN_LINKS=0

# Extract href and src paths that start with ./
LINKS=$(grep -oE '(href|src)="\./[^"]+"' "${TARGET_DIR}/index.html" | sed -E 's/(href|src)="\.\/([^"#?]+).*/\2/' | sort -u || true)

for link in $LINKS; do
  target_file="${TARGET_DIR}/${link}"
  if [ ! -f "${target_file}" ] && [ ! -d "${target_file}" ]; then
    echo "  ❌ Broken link detected in index.html: ./${link} -> ${target_file} not found" >&2
    BROKEN_LINKS=$((BROKEN_LINKS + 1))
  else
    echo "  ✓ Verified link: ./${link}"
  fi
done

if [ "${BROKEN_LINKS}" -gt 0 ]; then
  echo "❌ Build failed: ${BROKEN_LINKS} broken link(s) found in index.html" >&2
  exit 1
fi

echo "=========================================================="
echo "✅ Build completed successfully! Distribution ready in ${TARGET_DIR}/"
echo "=========================================================="
exit 0
