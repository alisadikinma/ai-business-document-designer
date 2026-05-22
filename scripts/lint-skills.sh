#!/bin/bash
# lint-skills.sh — Phase F skill-file structure validator
#
# Asserts per-skill file at skills/ai-business-document-<slug>/SKILL.md:
#   1. File exists at skills/ai-business-document-{brief,narrative,copywriting,gen,validate}/SKILL.md
#   2. YAML frontmatter present (delimited by ---), with keys:
#      name, description (>= 100 chars), triggers (array)
#   3. Required H2 sections present:
#      - Announce at Start
#      - Inputs
#      - Outputs
#      - Pre-checks (or Pre-checks variant w/ parenthetical)
#      - Pipeline (>= 1 section starting with "Pipeline")
#      - Hard Rules (or "Hard-Fail Rules" variant for validate skill)
#      - Reference Loading Cheat Sheet
#   4. Skill-specific sections:
#      - narrative + copywriting: must contain "HUMAN APPROVAL GATE"
#      - validate: must contain "Hard-Fail Rules"
#
# Exit 0 if all 5 skill files pass; exit 1 with descriptive failure on any miss.
# Reports PARTIAL when only some skills exist (during parallel execution).

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_DIR="$ROOT_DIR/skills"

SKILLS=(
  brief
  narrative
  copywriting
  gen
  validate
)

# Required H2 sections (common to all 5 skills)
REQUIRED_SECTIONS_COMMON=(
  "Announce at Start"
  "Inputs"
  "Outputs"
  "Reference Loading Cheat Sheet"
)

# Frontmatter required keys
FRONTMATTER_KEYS=(name description triggers)

FAIL=0
PASS_COUNT=0
MISSING_COUNT=0
FAIL_COUNT=0

fail() {
  echo "FAIL: $*" >&2
  FAIL=1
}
pass() {
  echo "PASS: $*"
  PASS_COUNT=$((PASS_COUNT + 1))
}
missing() {
  echo "MISSING: $*" >&2
  MISSING_COUNT=$((MISSING_COUNT + 1))
}

check_skill() {
  local slug="$1"
  local file="$SKILLS_DIR/ai-business-document-${slug}/SKILL.md"
  local file_fail=0

  if [[ ! -f "$file" ]]; then
    missing "[ai-business-document-${slug}] SKILL.md does not exist at $file (sibling implementer may still be in progress)"
    return
  fi

  # Frontmatter check: must start with --- and have closing ---
  local first_line
  first_line=$(head -n 1 "$file")
  if [[ "$first_line" != "---" ]]; then
    fail "[ai-business-document-${slug}] missing YAML frontmatter opener (first line must be '---')"
    file_fail=1
  fi

  # Extract frontmatter block (lines 2..N until next ---)
  local fm
  fm=$(awk 'NR==1 && /^---$/ {flag=1; next} flag && /^---$/ {exit} flag {print}' "$file")
  if [[ -z "$fm" ]]; then
    fail "[ai-business-document-${slug}] frontmatter block empty or unterminated"
    file_fail=1
  fi

  # Frontmatter keys present
  for key in "${FRONTMATTER_KEYS[@]}"; do
    if ! echo "$fm" | grep -qE "^${key}:"; then
      fail "[ai-business-document-${slug}] frontmatter missing key: ${key}"
      file_fail=1
    fi
  done

  # name matches expected
  local name_val
  name_val=$(echo "$fm" | grep -E '^name:' | head -n 1 | sed -E 's/^name:[[:space:]]*//' | tr -d '"' | tr -d "'" | tr -d '[:space:]')
  local expected_name="ai-business-document-${slug}"
  if [[ "$name_val" != "$expected_name" ]]; then
    fail "[ai-business-document-${slug}] frontmatter name '$name_val' does not match expected '$expected_name'"
    file_fail=1
  fi

  # description must be >= 100 chars
  # Extract description: may be multi-line; take everything between "description:" and next top-level key or end of frontmatter
  local desc
  desc=$(echo "$fm" | awk '/^description:/{flag=1; sub(/^description:[[:space:]]*/, ""); print; next} flag && /^[a-zA-Z_]+:/{flag=0} flag {print}')
  local desc_len=${#desc}
  if [[ "$desc_len" -lt 100 ]]; then
    fail "[ai-business-document-${slug}] frontmatter description is only ${desc_len} chars (need >= 100)"
    file_fail=1
  fi

  # triggers must be array notation [ ... ] or YAML list
  if ! echo "$fm" | grep -qE '^triggers:[[:space:]]*\['; then
    # Check for YAML list form (triggers:\n  - foo)
    if ! echo "$fm" | grep -qE '^triggers:[[:space:]]*$'; then
      fail "[ai-business-document-${slug}] triggers must be array notation [...] or YAML list"
      file_fail=1
    fi
  fi

  # Required H2 sections (common)
  for section in "${REQUIRED_SECTIONS_COMMON[@]}"; do
    if ! grep -qF "## $section" "$file"; then
      fail "[ai-business-document-${slug}] missing required section: ## $section"
      file_fail=1
    fi
  done

  # Pre-checks: accept "## Pre-checks" or "## Pre-checks (...)" variants
  if ! grep -qE '^## Pre-checks( |$|\()' "$file"; then
    fail "[ai-business-document-${slug}] missing required section: ## Pre-checks (any variant)"
    file_fail=1
  fi

  # Pipeline: at least one section starting with "## Pipeline"
  local pipeline_count
  pipeline_count=$(grep -cE '^## Pipeline' "$file")
  if [[ "$pipeline_count" -lt 1 ]]; then
    fail "[ai-business-document-${slug}] missing required section: ## Pipeline (need >= 1 section starting with this)"
    file_fail=1
  fi

  # Hard Rules: accept "## Hard Rules" or "## Hard-Fail Rules" or with parenthetical
  if ! grep -qE '^## Hard[- ](Rules|Fail Rules)' "$file"; then
    fail "[ai-business-document-${slug}] missing required section: ## Hard Rules or ## Hard-Fail Rules"
    file_fail=1
  fi

  # Skill-specific section requirements
  case "$slug" in
    narrative|copywriting)
      if ! grep -qE '^## HUMAN APPROVAL GATE' "$file"; then
        fail "[ai-business-document-${slug}] missing required section: ## HUMAN APPROVAL GATE"
        file_fail=1
      fi
      ;;
    validate)
      if ! grep -qE '^## Hard-Fail Rules' "$file"; then
        fail "[ai-business-document-${slug}] missing required section: ## Hard-Fail Rules"
        file_fail=1
      fi
      ;;
  esac

  if [[ "$file_fail" -eq 0 ]]; then
    pass "[ai-business-document-${slug}] all checks passed"
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
}

echo "Linting ${#SKILLS[@]} ai-business-document-* SKILL.md files in $SKILLS_DIR..."
echo ""

for slug in "${SKILLS[@]}"; do
  check_skill "$slug"
done

echo ""
TOTAL=${#SKILLS[@]}
EXISTING=$((TOTAL - MISSING_COUNT))
echo "Summary: $PASS_COUNT / $EXISTING existing files passed (${MISSING_COUNT} missing of $TOTAL total expected)"

if [[ $MISSING_COUNT -gt 0 ]] && [[ $FAIL_COUNT -eq 0 ]]; then
  echo "PARTIAL: $MISSING_COUNT skill(s) not yet created (parallel implementation in progress). Existing skills all pass."
  exit 0
fi

if [[ $FAIL -eq 0 ]]; then
  echo "ALL SKILL CHECKS PASSED."
  exit 0
else
  echo "ONE OR MORE SKILL CHECKS FAILED."
  exit 1
fi
