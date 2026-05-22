#!/bin/bash
# lint-frameworks.sh — Phase C framework file structure validator
#
# Asserts per-framework file at references/frameworks/<slug>.md:
#   1. File exists
#   2. YAML frontmatter present (delimited by ---), with keys:
#      slug, output_type, aspect_ratio, default_page_count,
#      target_audience, mandatory_pages, optional_pages
#   3. output_type value matches enum (one of 9 known slugs)
#   4. Required H2 sections all present (7 sections)
#   5. ## Do-NOT Patterns (3+) has at least 3 numbered/bulleted items
#   6. ## Real-World Example Reference has at least 1 URL or attribution
#   7. ## Reference Loading mentions framework-structures-2026.md and global-config.md
#
# Exit 0 if all 8 framework files pass; exit 1 with descriptive failure on any miss.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
FW_DIR="$ROOT_DIR/references/frameworks"

FRAMEWORKS=(
  deck-vc
  deck-b2b
  brochure-product
  portfolio-personal
  portfolio-agency
  service-flyer
  catalog-product
  trifold-leaflet
)

VALID_OUTPUT_TYPES="deck-vc deck-b2b deck-hybrid brochure-product portfolio-personal portfolio-agency catalog-product service-flyer trifold-leaflet"

REQUIRED_SECTIONS=(
  "Purpose & When To Use This Framework"
  "Narrative Arc / Page Sequence"
  "7-Step Content Checklist"
  "Do-NOT Patterns"
  "Real-World Example Reference"
  "Anti-Slop Hard Rules"
  "Reference Loading"
)

FRONTMATTER_KEYS=(slug output_type aspect_ratio default_page_count target_audience mandatory_pages optional_pages)

FAIL=0
PASS_COUNT=0

fail() {
  echo "FAIL: $*" >&2
  FAIL=1
}
pass() {
  echo "PASS: $*"
  PASS_COUNT=$((PASS_COUNT + 1))
}

check_framework() {
  local slug="$1"
  local file="$FW_DIR/${slug}.md"
  local file_fail=0

  if [[ ! -f "$file" ]]; then
    fail "[$slug] file does not exist at $file"
    return
  fi

  # Frontmatter check: must start with --- and have closing ---
  local first_line
  first_line=$(head -n 1 "$file")
  if [[ "$first_line" != "---" ]]; then
    fail "[$slug] missing YAML frontmatter opener (first line must be '---')"
    file_fail=1
  fi

  # Extract frontmatter block (lines 2..N until next ---)
  local fm
  fm=$(awk 'NR==1 && /^---$/ {flag=1; next} flag && /^---$/ {exit} flag {print}' "$file")
  if [[ -z "$fm" ]]; then
    fail "[$slug] frontmatter block empty or unterminated"
    file_fail=1
  fi

  # Frontmatter keys
  for key in "${FRONTMATTER_KEYS[@]}"; do
    if ! echo "$fm" | grep -qE "^${key}:"; then
      fail "[$slug] frontmatter missing key: ${key}"
      file_fail=1
    fi
  done

  # output_type value valid
  local ot
  ot=$(echo "$fm" | grep -E '^output_type:' | head -n 1 | sed -E 's/^output_type:[[:space:]]*//' | tr -d '"' | tr -d "'" | tr -d '[:space:]')
  if [[ -n "$ot" ]]; then
    if ! echo "$VALID_OUTPUT_TYPES" | grep -qw "$ot"; then
      fail "[$slug] output_type '$ot' not in enum ($VALID_OUTPUT_TYPES)"
      file_fail=1
    fi
  fi

  # slug matches filename
  local slug_val
  slug_val=$(echo "$fm" | grep -E '^slug:' | head -n 1 | sed -E 's/^slug:[[:space:]]*//' | tr -d '"' | tr -d "'" | tr -d '[:space:]')
  if [[ "$slug_val" != "$slug" ]]; then
    fail "[$slug] frontmatter slug '$slug_val' does not match filename '$slug'"
    file_fail=1
  fi

  # Required H2 sections
  for section in "${REQUIRED_SECTIONS[@]}"; do
    if ! grep -qF "## $section" "$file"; then
      fail "[$slug] missing required section: ## $section"
      file_fail=1
    fi
  done

  # Do-NOT Patterns: count bullet/numbered list items in that section
  local donot_block
  donot_block=$(awk '/^## Do-NOT Patterns/{flag=1; next} flag && /^## /{exit} flag {print}' "$file")
  local donot_items
  donot_items=$(echo "$donot_block" | grep -cE '^[[:space:]]*([0-9]+\.|[-*])[[:space:]]+')
  if [[ "$donot_items" -lt 3 ]]; then
    fail "[$slug] Do-NOT Patterns has only $donot_items items (need >= 3)"
    file_fail=1
  fi

  # Real-World Example Reference: at least 1 URL or named attribution
  local rw_block
  rw_block=$(awk '/^## Real-World Example Reference/{flag=1; next} flag && /^## /{exit} flag {print}' "$file")
  if ! echo "$rw_block" | grep -qE '(https?://|www\.|Communication Arts|Sequoia|DocSend|Stripe|Airbnb|Pentagram|Frank Chimero|Tobias|IKEA|Apple|B&O|Bang & Olufsen|Behance|Wolff Olins|R/GA|Yukk|INDUSIA|SlideShare|Awwwards|Dribbble|Smithsonian|British Museum|Cooper Hewitt|Afrimax|Mallorca|Biterite|LEGO|NHG|Privy|Aircall|Accurate)'; then
    fail "[$slug] Real-World Example Reference missing URL or recognizable attribution"
    file_fail=1
  fi

  # Reference Loading must mention research/framework-structures-2026.md and global-config.md
  local rl_block
  rl_block=$(awk '/^## Reference Loading/{flag=1; next} flag && /^## /{exit} flag {print}' "$file")
  if ! echo "$rl_block" | grep -qF "research/framework-structures-2026.md"; then
    fail "[$slug] Reference Loading missing 'references/research/framework-structures-2026.md'"
    file_fail=1
  fi
  if ! echo "$rl_block" | grep -qF "global-config.md"; then
    fail "[$slug] Reference Loading missing 'references/global-config.md'"
    file_fail=1
  fi

  if [[ "$file_fail" -eq 0 ]]; then
    pass "[$slug] all checks passed"
  fi
}

echo "Linting ${#FRAMEWORKS[@]} framework files in $FW_DIR..."
echo ""

for slug in "${FRAMEWORKS[@]}"; do
  check_framework "$slug"
done

echo ""
echo "Summary: $PASS_COUNT / ${#FRAMEWORKS[@]} files passed"
if [[ $FAIL -eq 0 ]]; then
  echo "ALL FRAMEWORK CHECKS PASSED."
  exit 0
else
  echo "ONE OR MORE FRAMEWORK CHECKS FAILED."
  exit 1
fi
