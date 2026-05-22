#!/bin/bash
# lint-references.sh — Phase B reference file structure validator
#
# Asserts 4 things via grep:
#   (a) references/global-config.md has Output Types enum section with 8+ values
#   (b) references/visual-language.md has Print-Specific Visual Rules section + 5 sub-subjects
#   (c) references/scoring-rubric.md has Print-Mode Rubric section + 5 sub-categories
#   (d) references/indonesian-context.md has Print Production Specifics section
#
# Exit 0 if all pass, exit 1 with descriptive message on any miss.

set -u

# Resolve repo root: this script lives at <root>/scripts/
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REF_DIR="$ROOT_DIR/references"

GLOBAL_CONFIG="$REF_DIR/global-config.md"
VISUAL_LANG="$REF_DIR/visual-language.md"
SCORING="$REF_DIR/scoring-rubric.md"
INDO="$REF_DIR/indonesian-context.md"

FAIL=0
fail() {
  echo "FAIL: $*" >&2
  FAIL=1
}
pass() {
  echo "PASS: $*"
}

# ============================================================
# (a) global-config.md — Output Types enum with 8+ values
# ============================================================
echo "--- Check (a): global-config.md Output Types enum"

if [[ ! -f "$GLOBAL_CONFIG" ]]; then
  fail "(a) $GLOBAL_CONFIG does not exist"
else
  if ! grep -qE '^##[[:space:]]+(([0-9]+)\.[[:space:]]+)?Output Types' "$GLOBAL_CONFIG"; then
    fail "(a) global-config.md missing '## Output Types' section header"
  else
    required_output_types=(deck-vc deck-b2b deck-hybrid brochure-product portfolio-personal portfolio-agency catalog-product service-flyer trifold-leaflet)
    missing=()
    for slug in "${required_output_types[@]}"; do
      if ! grep -q "$slug" "$GLOBAL_CONFIG"; then
        missing+=("$slug")
      fi
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
      fail "(a) global-config.md Output Types missing slugs: ${missing[*]}"
    else
      pass "(a) global-config.md Output Types enum present with all 9 slugs"
    fi
  fi
fi

# ============================================================
# (b) visual-language.md — Print-Specific Visual Rules + 5 sub-subjects
# ============================================================
echo "--- Check (b): visual-language.md Print-Specific Visual Rules"

if [[ ! -f "$VISUAL_LANG" ]]; then
  fail "(b) $VISUAL_LANG does not exist"
else
  if ! grep -qE '^##[[:space:]]+(([0-9]+(\.[0-9]+)?)\.[[:space:]]+)?Print-Specific Visual Rules' "$VISUAL_LANG"; then
    fail "(b) visual-language.md missing '## Print-Specific Visual Rules' section header"
  else
    # Five sub-subjects: CMYK, bleed/safe-zone, 300dpi, font embedding, vector vs raster
    sub_patterns=("CMYK" "Bleed" "300dpi" "Font Embedding" "Vector vs Raster")
    missing=()
    for p in "${sub_patterns[@]}"; do
      if ! grep -qi "$p" "$VISUAL_LANG"; then
        missing+=("$p")
      fi
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
      fail "(b) visual-language.md Print-Specific Visual Rules missing sub-subjects: ${missing[*]}"
    else
      pass "(b) visual-language.md Print-Specific Visual Rules + 5 sub-subjects present"
    fi
  fi
fi

# ============================================================
# (c) scoring-rubric.md — Print-Mode Rubric + 5 sub-categories
# ============================================================
echo "--- Check (c): scoring-rubric.md Print-Mode Rubric"

if [[ ! -f "$SCORING" ]]; then
  fail "(c) $SCORING does not exist"
else
  if ! grep -qE '^##[[:space:]]+(([0-9]+(\.[0-9]+)?)\.[[:space:]]+)?Print-Mode Rubric' "$SCORING"; then
    fail "(c) scoring-rubric.md missing '## Print-Mode Rubric' section header"
  else
    # Five sub-categories with point values
    sub_categories=("Visual Ratio" "Framework Fit" "CTA Clarity" "Print Readiness" "Anti-AI-Slop")
    missing=()
    for cat in "${sub_categories[@]}"; do
      if ! grep -qi "$cat" "$SCORING"; then
        missing+=("$cat")
      fi
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
      fail "(c) scoring-rubric.md Print-Mode Rubric missing sub-categories: ${missing[*]}"
    else
      pass "(c) scoring-rubric.md Print-Mode Rubric + 5 sub-categories present"
    fi
  fi
fi

# ============================================================
# (d) indonesian-context.md — Print Production Specifics
# ============================================================
echo "--- Check (d): indonesian-context.md Print Production Specifics"

if [[ ! -f "$INDO" ]]; then
  fail "(d) $INDO does not exist"
else
  if ! grep -qE '^##[[:space:]]+(([0-9]+(\.[0-9]+)?)\.[[:space:]]+)?Print Production Specifics' "$INDO"; then
    fail "(d) indonesian-context.md missing '## Print Production Specifics' section header"
  else
    pass "(d) indonesian-context.md Print Production Specifics section present"
  fi
fi

LAYOUT_GRAMMAR="$REF_DIR/layout-grammar.md"
HTML_CSS_PRINT="$REF_DIR/html-css-print-templates.md"
COPYWRITING="$REF_DIR/copywriting-patterns.md"
BIZMODEL="$REF_DIR/business-model-patterns.md"

# ============================================================
# (e) layout-grammar.md — 6 required H2 sections
# ============================================================
echo "--- Check (e): layout-grammar.md required H2 sections"

if [[ ! -f "$LAYOUT_GRAMMAR" ]]; then
  fail "(e) $LAYOUT_GRAMMAR does not exist"
else
  required_h2_e=("Grid Systems" "Typography Hierarchy" "Visual Flow" "White Space Discipline" "Heading Scale Reference" "Grid-Breaking Rules")
  missing=()
  for h2 in "${required_h2_e[@]}"; do
    if ! grep -qE "^## .*${h2}" "$LAYOUT_GRAMMAR"; then
      missing+=("$h2")
    fi
  done
  if [[ ${#missing[@]} -gt 0 ]]; then
    fail "(e) layout-grammar.md missing H2 sections: ${missing[*]}"
  else
    pass "(e) layout-grammar.md all 6 H2 sections present"
  fi
fi

# ============================================================
# (f) html-css-print-templates.md — 8 H2 + ≥5 CSS blocks + ≥2 Playwright blocks
# ============================================================
echo "--- Check (f): html-css-print-templates.md required H2 + code blocks"

if [[ ! -f "$HTML_CSS_PRINT" ]]; then
  fail "(f) $HTML_CSS_PRINT does not exist"
else
  required_h2_f=("@page Rules" "Bleed CSS" "Print Color Profile" "Font Embedding" "Playwright PDF Options" "Multi-page Layout" "Cross-page Headers" "Fallback Patterns")
  missing=()
  for h2 in "${required_h2_f[@]}"; do
    if ! grep -qE "^## .*${h2}" "$HTML_CSS_PRINT"; then
      missing+=("$h2")
    fi
  done
  if [[ ${#missing[@]} -gt 0 ]]; then
    fail "(f) html-css-print-templates.md missing H2 sections: ${missing[*]}"
  else
    pass "(f) html-css-print-templates.md all 8 H2 sections present"
  fi
  # Count CSS code fences (```css)
  css_blocks=$(grep -c '^```css' "$HTML_CSS_PRINT" || true)
  if [[ $css_blocks -lt 5 ]]; then
    fail "(f) html-css-print-templates.md has only $css_blocks CSS code blocks (need ≥5)"
  else
    pass "(f) html-css-print-templates.md has $css_blocks CSS code blocks (≥5)"
  fi
  # Count Playwright code blocks (javascript OR python)
  pw_blocks=$(grep -cE '^```(javascript|python)' "$HTML_CSS_PRINT" || true)
  if [[ $pw_blocks -lt 2 ]]; then
    fail "(f) html-css-print-templates.md has only $pw_blocks Playwright (js/python) code blocks (need ≥2)"
  else
    pass "(f) html-css-print-templates.md has $pw_blocks Playwright code blocks (≥2)"
  fi
fi

# ============================================================
# (g) copywriting-patterns.md — 6 H2 + ≥10 headline examples
# ============================================================
echo "--- Check (g): copywriting-patterns.md required H2 + headline examples"

if [[ ! -f "$COPYWRITING" ]]; then
  fail "(g) $COPYWRITING does not exist"
else
  required_h2_g=("Headline Formula" "Sub-text Discipline" "CTA Patterns" "Pricing Tier Articulation" "Bilingual Convention" "Banned Copy Patterns")
  missing=()
  for h2 in "${required_h2_g[@]}"; do
    if ! grep -qE "^## .*${h2}" "$COPYWRITING"; then
      missing+=("$h2")
    fi
  done
  if [[ ${#missing[@]} -gt 0 ]]; then
    fail "(g) copywriting-patterns.md missing H2 sections: ${missing[*]}"
  else
    pass "(g) copywriting-patterns.md all 6 H2 sections present"
  fi
  # Count headline examples — lines starting with "- ID:" or "- EN:"
  headline_count=$(grep -cE '^- (ID|EN):' "$COPYWRITING" || true)
  if [[ $headline_count -lt 10 ]]; then
    fail "(g) copywriting-patterns.md has only $headline_count headline example lines (need ≥10)"
  else
    pass "(g) copywriting-patterns.md has $headline_count headline example lines (≥10)"
  fi
fi

# ============================================================
# (h) business-model-patterns.md — MIGRATION TODO marker + Quick Reference Index
# ============================================================
echo "--- Check (h): business-model-patterns.md thin wrapper markers"

if [[ ! -f "$BIZMODEL" ]]; then
  fail "(h) $BIZMODEL does not exist"
else
  if ! grep -qE 'MIGRATION TODO' "$BIZMODEL"; then
    fail "(h) business-model-patterns.md missing MIGRATION TODO marker"
  else
    pass "(h) business-model-patterns.md MIGRATION TODO marker present"
  fi
  if ! grep -qE '^## .*Quick Reference Index' "$BIZMODEL"; then
    fail "(h) business-model-patterns.md missing '## Quick Reference Index' section"
  else
    pass "(h) business-model-patterns.md Quick Reference Index section present"
  fi
fi

# ============================================================
# Summary
# ============================================================
echo ""
if [[ $FAIL -eq 0 ]]; then
  echo "ALL CHECKS PASSED."
  exit 0
else
  echo "ONE OR MORE CHECKS FAILED."
  exit 1
fi
