#!/usr/bin/env bash
# lint-themes.sh — Validate references/themes/*.md theme preset files.
# Exits 0 if all 7 themes pass; exits 1 with descriptive failure otherwise.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
THEMES_DIR="$PLUGIN_ROOT/references/themes"

EXPECTED_THEMES=(
  "indusia-tech"
  "minimalist-editorial"
  "industrial-brutalist"
  "premium-luxe"
  "pastel-soft"
  "brutalist-mono"
  "indo-tropical"
)

REQUIRED_SECTIONS=(
  "## Identity & Mood"
  "## Color Palette"
  "## Typography"
  "## Illustration / Image Style"
  "## Layout Grammar"
  "## Anti-AI-Slop Banlist for This Theme"
  "## Real-World Reference"
)

FRONTMATTER_KEYS=(
  "slug:"
  "name:"
  "mood:"
  "suitable_for:"
  "suitable_audience:"
)

FONT_PATTERN='Inter|Helvetica|Arial|Times|JetBrains|Söhne|Sohne|Playfair|Didot|Bodoni|Garamond|Cormorant|General Sans|Manrope|Saira|Akkurat|Diatype|IBM Plex|Inconsolata|Suisse|Mrs Eaves|Trajan|ABC|Söhne Buch'

errors=0
pass=0

fail() {
  echo "FAIL [$1]: $2" >&2
  errors=$((errors + 1))
}

ok() {
  echo "PASS [$1]"
  pass=$((pass + 1))
}

if [ ! -d "$THEMES_DIR" ]; then
  echo "FAIL: themes directory not found: $THEMES_DIR" >&2
  exit 1
fi

for slug in "${EXPECTED_THEMES[@]}"; do
  file="$THEMES_DIR/$slug.md"

  if [ ! -f "$file" ]; then
    fail "$slug" "file missing: $file"
    continue
  fi

  # 1. YAML frontmatter at top
  first_line="$(head -n 1 "$file")"
  if [ "$first_line" != "---" ]; then
    fail "$slug" "must start with YAML frontmatter delimiter '---' (got: '$first_line')"
    continue
  fi

  # extract frontmatter block (between first and second --- lines)
  frontmatter="$(awk '/^---[[:space:]]*$/{c++; next} c==1{print}' "$file")"
  if [ -z "$frontmatter" ]; then
    fail "$slug" "empty or unterminated YAML frontmatter"
    continue
  fi

  # 2. Required frontmatter keys
  for key in "${FRONTMATTER_KEYS[@]}"; do
    if ! echo "$frontmatter" | grep -q "^${key}"; then
      fail "$slug" "frontmatter missing key: ${key}"
    fi
  done

  # 3. slug matches filename
  fm_slug="$(echo "$frontmatter" | grep '^slug:' | head -n1 | sed 's/^slug:[[:space:]]*//' | tr -d ' "'"'"'')"
  if [ "$fm_slug" != "$slug" ]; then
    fail "$slug" "slug in frontmatter ('$fm_slug') does not match filename ('$slug')"
  fi

  # 4. All required H2 sections present in order-agnostic check
  for section in "${REQUIRED_SECTIONS[@]}"; do
    if ! grep -qF "$section" "$file"; then
      fail "$slug" "missing required section: $section"
    fi
  done

  # 5. Color Palette has >=4 unique hex codes
  color_section="$(awk '/^## Color Palette/{flag=1; next} /^## /{flag=0} flag' "$file")"
  hex_count=$(echo "$color_section" | grep -oE '#[0-9A-Fa-f]{6}' | sort -u | wc -l)
  if [ "$hex_count" -lt 4 ]; then
    fail "$slug" "Color Palette has only $hex_count unique hex codes (need >=4)"
  fi

  # 6. Typography has >=3 specific font name matches
  typo_section="$(awk '/^## Typography/{flag=1; next} /^## /{flag=0} flag' "$file")"
  font_count=$(echo "$typo_section" | grep -oE "$FONT_PATTERN" | wc -l)
  if [ "$font_count" -lt 3 ]; then
    fail "$slug" "Typography has only $font_count font-name pattern matches (need >=3)"
  fi

  # 7. Anti-AI-Slop banlist has >=3 numbered/bulleted items
  banlist_section="$(awk '/^## Anti-AI-Slop Banlist for This Theme/{flag=1; next} /^## /{flag=0} flag' "$file")"
  banlist_items=$(echo "$banlist_section" | grep -cE '^[[:space:]]*([0-9]+\.|[-*])[[:space:]]+')
  if [ "$banlist_items" -lt 3 ]; then
    fail "$slug" "Anti-AI-Slop Banlist has only $banlist_items items (need >=3)"
  fi

  # 8. Real-World Reference has >=1 attribution (non-empty content line)
  ref_section="$(awk '/^## Real-World Reference/{flag=1; next} /^## /{flag=0} flag' "$file")"
  ref_lines=$(echo "$ref_section" | grep -cE '[A-Za-z]')
  if [ "$ref_lines" -lt 1 ]; then
    fail "$slug" "Real-World Reference section appears empty"
  fi

  ok "$slug"
done

echo ""
echo "Themes passed: $pass / ${#EXPECTED_THEMES[@]}"
echo "Errors: $errors"

if [ "$errors" -gt 0 ]; then
  exit 1
fi
exit 0
