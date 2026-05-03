---
name: pitch-deck-gen
description: Stage 3 of the 4-stage pitch-deck-designer pipeline. Use when generating the visual production spec for a pitch deck — image prompts, video prompts, speaker notes, optional Remotion configs — AFTER pitch-deck-storyline has produced an approved storyline.json. Triggers on pitch deck gen, generate pitch deck, build deck, produce deck visuals, deck image prompts, deck video prompts, generate slide spec, buat pitch deck, generate slide content. NEVER skips storyline — this skill REFUSES to run without an approved storyline.json.
---

# Pitch Deck Gen — Stage 3: Visual Production

Stage 3 of 4. Reads `storyline.json` (approved by operator in stage 2). Produces per-slide visual production spec — visual concept, on-slide text, image prompt (GeminiGen.AI nano-banana-pro format), optional Seedance 2.0 video prompt, optional Remotion config, speaker notes. Outputs `deck.md` (the consolidated deck spec) + `image-prompts.json` + `video-prompts.json` + `remotion.config.json` (optional) + `speaker-notes.md`.

> **Where this fits:** `pitch-deck-brief` → `pitch-deck-storyline` → `pitch-deck-gen` → `pitch-deck-validate`. See `CLAUDE.md` for the full pipeline.

---

## 1. Iron Law

```
NO GENERATION WITHOUT AN APPROVED STORYLINE.
EVERY SLIDE >= 70% VISUAL.
EVERY NUMBER HAS A SOURCE.
```

Three non-negotiables. Each maps to a hard fail at validate. Build the gen output to pass validate by construction.

---

## 2. Reference Files (Read On-Demand)

ALWAYS read `global-config.md` first, then layer additional references as needed.

| Task | Read first |
|------|-----------|
| ANY gen task | `references/global-config.md` (ALWAYS) |
| Visual ratio + anti-slop visual rules + structured-data exception | + `references/visual-language.md` (ALWAYS) |
| Image prompt formulas per slide type + composite reference patterns | + `references/image-prompt-templates.md` (ALWAYS) |
| Slides with face/logo refs (cover, CTA, team) | + `references/safety-filter-playbook.md` (REQUIRED for any slide with face/logo `files[]`) |
| Video prompts (when motion=true on a slide) | + `references/seedance-prompt-templates.md` |
| Programmatic motion (when programmatic_motion=true) | + `references/remotion-config-templates.md` |
| Indonesian audience | + `references/indonesian-context.md` |
| B2B-mode visual cues + dual-stakeholder framing | + `references/b2b-channel-partner-playbook.md` |

---

## 3. Hard Rules (NON-NEGOTIABLE)

These rules apply to every deck generation. Violation requires immediate correction before output.

1. **NEVER run without approved storyline.json.** First action: read `storyline.json`. If `approved_at` is `null`, refuse and route operator back to `/pitch-deck-storyline`.
2. **NEVER deviate from storyline.json's slide count or order.** The slides come from storyline. This skill writes the visual+verbal spec; it does NOT redesign the narrative.
3. **ALWAYS visual ratio ≥ 70% per slide.** Self-check using `visual-language.md` §2 method. In `info-dense` mode, structured-data blocks per `visual-language.md` §2.5 count as visual. Hard-fail at validate any slide < 60%.
4. **ALWAYS respect density-mode word limits** (per `global-config.md` §3.5). Minimalist mode: ≤10 word headline, ≤25 word sub-text. Info-dense mode: ≤12 word headline, ≤40 words per zone (≤2 zones), structured-data zones unlimited.
5. **NEVER use banned vocabulary** (per `global-config.md` §4) — English or Bahasa. The vocab ban does NOT relax in info-dense mode.
6. **NEVER produce banned visuals** (per `global-config.md` §5 + `visual-language.md` §13). Run the 5-question pre-flight check on every image prompt.
7. **ALWAYS inject brand_palette hex codes verbatim.** Read from `brief.json.brand_palette`. Inject every hex into every prompt's color descriptors. NEVER use vague terms like "warm orange" — always use `#FF8C42`. (Per `global-config.md` §3.6.)
8. **ALWAYS source-tag every number on the slide.** "Source: internal data, April 2026" or "Source: BI Statistik 2025" or "internal estimate". No untagged numbers. In info-dense mode, multi-source footnote strips (≥3 sources) are encouraged for contested numbers.
9. **NEVER generate AI faces for the team slide.** Mark slide for manual asset injection if real photos are unavailable.
10. **ALWAYS apply Pattern A or B for slides with face refs** (per `image-prompt-templates.md` §4.5). Pattern A (badge-only) is default for cover. Pattern B (face-on-body) only for closing CTA. Both REQUIRE explicit anti-deviation phrasing.
11. **ALWAYS apply safety-filter mitigation** for slides with face refs (per `safety-filter-playbook.md`). Inject `"NO recognizable people, NO minors"` + `"<8% sharpness, abstract bokeh"` automatically into every face-composite prompt.
12. **ALWAYS produce speaker notes 80–150 words per slide.** With one verbal-only insight not visible on the slide.
13. **NEVER close the deck on "Thank You".** Slide N (or 10 / 11 / 13) = the ask, with specific numbers + dated deadline.
14. **ALWAYS apply audience-mode emphasis** per `storyline.json` slides[i].audience_mode_emphasis. Don't blend modes.
15. **ALWAYS gate the style-anchor slide.** Generate slide 0 (info-dense) or slide 1 (minimalist) FIRST, surface preview to operator, wait for approval, THEN propagate `ref_history` to remaining slides. (Per `image-prompt-templates.md` §5.)
16. **ALWAYS emit ALL output files** even when slides have no motion. `video-prompts.json` is `[]` when no motion, `remotion.config.json` is `{compositions: []}` when no programmatic motion. Empty arrays beat missing files.

---

## 4. Workflow: Visual Production

### Step 1 — Read storyline.json + brief.json

Locate `storyline.json` (default: same output_dir as brief.json). Verify:

- `approved_at` is not `null`
- `approved_by` is set
- All slides have required fields (`headline`, `subtext`, `visual_concept`, `investor_preempt_question_id`, `verbal_only_insight`)

If any of these fail, STOP and route back to `pitch-deck-storyline`.

Also load `brief.json` for:
- Audience mode + language + FX baseline + compliance signals
- **`density_mode`** (`"minimalist"` | `"info-dense"`) — REQUIRED. Defaults to `"info-dense"` for `mode: b2b` and `hybrid`, `"minimalist"` for `mode: vc`. If missing, route back to `pitch-deck-brief`.
- **`brand_palette`** (object with `background`, `primary`, `accent`, `ink` minimum) — REQUIRED. If missing, route back to `pitch-deck-brief`.
- **`founders[]`** (face files + names + roles) — required for cover/CTA face composites.
- **`partner_logos[]`** (logo files) — required for cover lockup in partnership decks.

### Step 2 — Per-slide visual concept refinement

For each slide in `storyline.json`:

1. Take the storyline's `visual_concept` (one-sentence what-it-shows)
2. Refine into a concrete visual concept using `image-prompt-templates.md` per-slide-type formulas
3. Verify against `visual-language.md`:
   - Visual ratio target ≥ 70%
   - No banned visual elements
   - Specific environment + subject + lighting + camera framing
   - Anti-AI-slop pre-flight check (5 questions)

### Step 3 — On-slide text composition

For each slide:

1. Compose headline (≤ 10 words) using patterns from `deck-frameworks.md`
2. Compose sub-text (≤ 25 words) — numbers and proper nouns only
3. Add source line where any number appears
4. Run banned-vocabulary scan (auto-replace per `global-config.md` §4)
5. Apply Indonesian formatting if `indonesian_context: true` (Rp shorthand, etc.)

### Step 4 — Image prompt generation

For each slide, build the GeminiGen.AI prompt per `image-prompt-templates.md`:

- **Density-mode-aware formula selection** (CRITICAL):
  - `density_mode: "minimalist"` → use Formula A (Photo) for slides 1-3
  - `density_mode: "info-dense"` → use Formula B (Infographic-flat) for slides 0-3 + 5-8. Photo only for team.
- **Style anchor slide depends on density mode:**
  - `info-dense` → slide 0 (cover) is the brand anchor
  - `minimalist` → slide 1 (title) is the brand anchor
- **Brand palette injection (REQUIRED):** every prompt MUST include the verbatim hex codes from `brief.json.brand_palette`. Replace any `{brand_palette.primary}`, `{brand_palette.accent}`, etc. placeholders in formulas with actual hex codes.
- **Reference image bindings** (`files[]` for local upload, `file_urls[]` for URL refs):
  - Cover slide 0 → logo lockups + founder face badges (Pattern A from §4.5)
  - Closing CTA slide N → founder face files + logos (Pattern B from §4.5, with Pattern A fallback)
  - Solution slide → product UI screenshot (Pattern D)
  - Team slide → all founder headshots (Pattern A face-only)
- **Anti-deviation phrasing (REQUIRED for face/logo refs):** inject explicit "USE EXACTLY · PRESERVE · NEVER synthesize" phrasing per `image-prompt-templates.md` §4.5.
- **Safety-filter mitigation (REQUIRED for face refs):** inject `"NO recognizable people, NO minors"` + `"<8% sharpness, abstract bokeh"` + age-locked descriptors per `safety-filter-playbook.md`. Populate `fallback_strategy` with per-error ladder.
- **Team slide:** NEVER generate faces — mark `manual_asset_required: true` if real photos are unavailable.

Each prompt must pass the 5-question pre-flight check + the safety-filter pre-flight check (per `safety-filter-playbook.md` §6) before being added to `image-prompts.json`.

### Step 4.5 — Style-anchor quality gate (NEW — applies before Step 5)

The style-anchor slide (slide 0 in info-dense mode, slide 1 in minimalist mode) propagates its aesthetic to every subsequent slide via `ref_history`. A bad anchor poisons the entire deck.

**Plugin enforcement:**

1. Generate ONLY the style-anchor slide first.
2. Render the result and surface the URL to the operator.
3. Wait for explicit operator approval (`approve` / `reroll` / `manual_anchor`).
4. Only on `approve` does the pipeline proceed to generate slides 2-N with `ref_history` set.
5. On `reroll`, regenerate the anchor slide (operator may amend the prompt). Repeat gate.
6. On `manual_anchor`, operator provides their own anchor image; plugin uses its UUID for `ref_history`.

**Why this gate matters:** if the anchor is generic stock photo instead of brand-anchored composition, every subsequent slide inherits the genericness. Burning all 10 slides on a bad anchor is worse than re-rolling the anchor 3 times.

**When operator-approved anchor still fails downstream:** if 2+ slides reject `ref_history` propagation (model judges them stylistically inconsistent), drop `ref_history` for those slides and document in `version_log`.

### Step 5 — Video prompt generation (where motion adds value)

For each slide where `video_motion_recommended: true` in storyline:

1. Apply Seedance 2.0 4-block formula (per `seedance-prompt-templates.md` §2)
2. Bind first/last frame to image prompt's expected output via `@Image1`
3. Verify loop seamlessness (Block 4 must specify "last frame matches first frame")
4. Run "is this video earning its weight?" gate per `seedance-prompt-templates.md` §10

If gate fails: drop video for that slide, mark static-only.

### Step 6 — Remotion config generation (when programmatic motion needed)

For each slide where `programmatic_motion_recommended: true`:

1. Pick template type per `remotion-config-templates.md` (counter / chart / pin map / live ticker)
2. Fill in props from `storyline.json` data + `brief.json` traction values
3. Mark `skip_if_unavailable: true` so deck publishes even without Remotion infrastructure

### Step 7 — Speaker notes generation

For each slide:

1. Use `verbal_only_insight` from storyline as kernel
2. Expand to 80–150 words in language per `brief.json` `language_default`
3. Structure (per `visual-language.md` §11):
   - 1 sentence — re-anchor audience to slide visual / number
   - 3–5 sentences — context the slide does not show
   - 1 sentence — bridge to next slide
4. Avoid restating slide text
5. Apply Indonesian voice if `language_default = "id"` (conversational, persuasive, no AI-slop Bahasa)

### Step 8 — Visual ratio self-check

For each slide, estimate visual ratio:

- Sum visual element area
- Sum text element area
- Verify ≥ 70%
- If any slide < 70%, REVISE before emit
- If any slide < 60%, HARD FAIL — back to step 2 for that slide

### Step 9 — Emit output files

Save to `{output_dir}/`:

#### `deck.md` (consolidated deck spec — operator-readable)

```markdown
# Deck — {Product Name} → {Audience}

> Generated: {ISO 8601 timestamp}
> Mode: {vc/b2b/hybrid} · Framework: {classic_10/ai_era_11/traction_first_13}
> Storyline approved by: {approved_by} at {approved_at}

## Slide 1 — Title / Vision

**Visual concept:** {one-sentence}
**Headline:** {≤10 words}
**Sub-text:** {≤25 words}
**Visual ratio (estimated):** 0.82

**Image prompt:** see `image-prompts.json` slide_number=1
**Video prompt:** none (static slide)
**Programmatic motion:** none

**Speaker note (80–150 words):**
{full speaker note text}

**Investor pre-empts:** Q1 — what do you do?

---

## Slide 2 — Problem
... (same structure)

(continue per slide)

## Validation pre-check (self-reported by gen)

- All slides visual ratio ≥ 70%: {Y/N — list violations}
- All numbers source-tagged: {Y/N}
- No banned vocabulary detected: {Y/N}
- No banned visuals in image prompts: {Y/N}
- All speaker notes 80–150 words: {Y/N}
- Slide 10/11 contains the ask, not "Thank You": {Y/N}

If any N, regenerate that section before final emit.

## Next step

Run /pitch-deck-validate to score the 100-point quality gate.
```

#### `image-prompts.json` (Schema 2.0 — see `references/image-prompt-templates.md` §7)
```json
{
  "schema_version": "2.0",
  "deck_id": "{from brief.json}",
  "revision": 1,
  "rerun_reason": null,
  "density_mode": "info-dense",
  "default_provider": "geminigen.ai",
  "default_model": "nano-banana-pro",
  "default_aspect_ratio": "16:9",
  "default_resolution": "2K",
  "default_output_format": "png",
  "style_anchor_slide": 0,
  "brand_palette": {
    "background": "#F8F4ED",
    "primary":    "#1AB8B6",
    "accent":     "#FF8C42",
    "secondary":  "#5860D6",
    "warning":    "#C53030",
    "ink":        "#1A2540"
  },
  "typography": "Plus Jakarta Sans",
  "prompts": [
    {
      "slide": 0,
      "slide_role": "cover_brand_anchor",
      "visual_concept": "Cover brand-anchor: hero typography + dual founder badges + logo lockup + synthetic atmosphere",
      "prompt": "Pitch deck COVER slide (slide 0)... [full prompt with all hex codes injected verbatim]",
      "model": "nano-banana-pro",
      "aspect_ratio": "16:9",
      "style": "Cinematic-environmental",
      "output_format": "png",
      "resolution": "2K",
      "files": ["ref/founder-a-face.png", "ref/founder-b-face.png", "ref/logo-a.png", "ref/logo-b.jpg"],
      "file_urls": [],
      "ref_history": null,
      "version_log": [
        { "rev": 1, "ts": "2026-05-02T16:30:00+07:00", "reason": "initial generation" }
      ],
      "expected_filename": "slide-00-cover.png",
      "manual_asset_required": false,
      "fallback_strategy": "If MINOR_UPLOAD safety filter triggers: drop face files, render with logos+text+atmosphere only, composite face badges in Canva. See safety-filter-playbook.md §5."
    }
    // ... per slide
  ]
}
```

**New schema fields (vs v1.0):**
| Field | Purpose |
|-------|---------|
| `revision` | Bump on every rerun. Required. |
| `rerun_reason` | One-sentence explanation when `revision > 1`. |
| `density_mode` | `"minimalist"` or `"info-dense"`. Drives all formula selection. |
| `brand_palette` | Required object with hex codes. Plugin injects verbatim into every prompt. |
| `typography` | Default font family for the deck. |
| `prompts[].files` | Local file paths for multipart upload (in addition to `file_urls` for URLs). |
| `prompts[].version_log` | Per-slide rev history. Append on rerun. |

#### `video-prompts.json`
```json
{
  "schema_version": "1.0",
  "deck_id": "...",
  "default_provider": "seedance-2.0",
  "fallback_provider": "veo-3.1",
  "prompts": [
    // entries per slide flagged motion=true
    // empty array if no motion needed
  ]
}
```

#### `remotion.config.json` (optional)
Per `remotion-config-templates.md` §4. Empty `compositions: []` if no programmatic motion needed; `skip_if_unavailable: true` always.

#### `speaker-notes.md`
```markdown
# Speaker Notes — {Product Name} → {Audience}

> Language: {id/en/bilingual}
> Total stage time: ~{N} minutes (target 5–7 min for 11 slides)

## Slide 1
{80–150 words}

## Slide 2
{80–150 words}

(continue per slide)
```

### Step 10 — Hand-off to validate

Output to operator:

```
✓ deck.md, image-prompts.json, video-prompts.json, remotion.config.json (optional), speaker-notes.md saved to {output_dir}.

Self-checked: {N} slides, all visual ratio ≥ 70%, all numbers source-tagged, {M} video slides, {K} programmatic-motion slides.

Next: run /pitch-deck-validate to score against the 100-point gate.
DO NOT publish until validation passes ≥ 70/100.
```

---

## 5. Red Flags

| Red flag | Fix |
|----------|-----|
| Storyline `approved_at` is null | Hard-stop — refuse to run, route back to storyline |
| `brief.json.density_mode` missing | Hard-stop — route back to brief |
| `brief.json.brand_palette` missing or has <4 hex codes | Hard-stop — route back to brief |
| Slide visual ratio < 60% (after applying §2.5 in info-dense mode) | Regenerate that slide before emit |
| Banned vocabulary in headline / sub-text | Auto-replace + alert |
| Image prompt contains "purple gradient" / "holographic UI" / banned visual | Regenerate prompt |
| Image prompt missing brand_palette hex codes | Inject hex codes verbatim |
| Slide with face refs missing anti-deviation phrases | Inject required phrasing per `image-prompt-templates.md` §4.5 |
| Slide with face refs missing safety-filter mitigation phrases | Inject `"NO recognizable people, NO minors"` + `"<8% sharpness, abstract bokeh"` per `safety-filter-playbook.md` |
| Slide with face refs uses "young" / "youthful" / "fresh-faced" | Replace with explicit age-lock ("adult ... late 30s/40s") |
| Generated face on team slide | Replace with manual_asset_required flag |
| Style-anchor slide generated without operator approval gate | Block propagation of `ref_history`; surface preview, wait for approval |
| Speaker note < 80 words or > 150 words | Revise to range |
| Source line missing on a number | Block emit, ask brief stage for source |
| Slide N says "Thank You" | Replace with the ask immediately |
| Headline > word limit (10 minimalist / 12 info-dense) | Cut to limit |
| Bullet list > 3 items in minimalist mode (or > 6 outside structured-data zone in info-dense) | Split into multiple slides OR convert to structured-data block |
| Partnership pitch missing dual-stakeholder framing on cover/market/money/closing | Apply patterns from `b2b-channel-partner-playbook.md` §9.5 |

---

## 6. Rationalization Prevention Table

| What I might think | What the skill says |
|--------------------|---------------------|
| "The image prompt is generic but it'll do" | No. Run the 5-question pre-flight. Generic = AI-slop = hard-fail. |
| "I'll skip the source line; the chart looks credible" | No. Untagged numbers fail validate. Always source-tag. |
| "Speaker note is short but I'm out of time" | No. 80 words minimum; under that, the speaker has to ad-lib. |
| "The team slide should have AI-generated avatars for missing photos" | NEVER. Mark `manual_asset_required: true`. AI faces destroy trust. |
| "I'll make slide 10 a Thank You — it's nicer" | No. Slide 10 = the ask. "Thank You" is auto-fail. |
| "Visual ratio 65% is close enough to 70%" | No. 70% target, 60% hard-fail. Regenerate slide. |

---

## 7. Verification Checklist

Before emitting all output files:

- [ ] `storyline.json` was approved (approved_at not null)
- [ ] `brief.json.density_mode` is set (`minimalist` or `info-dense`)
- [ ] `brief.json.brand_palette` has ≥4 hex codes (`background`, `primary`, `accent`, `ink` minimum)
- [ ] Every slide uses density-mode-appropriate formula (slides 1-3 photo in minimalist; slides 0-3+5-8 infographic in info-dense)
- [ ] Every prompt includes brand palette hex codes verbatim (no vague "warm orange" — must be `#FF8C42`)
- [ ] Every slide has visual ratio ≥ 70% (apply §2.5 structured-data exception in info-dense mode)
- [ ] No slide has visual ratio < 60%
- [ ] Every headline ≤ word limit per density mode (10 minimalist / 12 info-dense)
- [ ] Every sub-text within zone limit per density mode
- [ ] Every number on a slide has a source line (multi-source strip ≥3 sources for contested numbers in info-dense mode)
- [ ] No banned vocabulary detected (English or Bahasa)
- [ ] No banned visuals in any image prompt (5-question pre-flight passed for each)
- [ ] Style-anchor slide (slide 0 info-dense / slide 1 minimalist) was approved by operator before propagating `ref_history`
- [ ] Every slide with face refs has anti-deviation phrasing (Pattern A or B per `image-prompt-templates.md` §4.5)
- [ ] Every slide with face refs has safety-filter mitigation injected (per `safety-filter-playbook.md` §6)
- [ ] Every slide with face refs has explicit age-locking (no "young" / "youthful" / "fresh-faced")
- [ ] Every slide with face refs has `fallback_strategy` populated with per-error ladder
- [ ] Team slide does NOT generate faces (manual_asset_required where photos absent)
- [ ] Every slide has a speaker note 80–150 words
- [ ] Speaker notes do not duplicate slide text
- [ ] Slide 10 (or 11 / 13) is the ask, not "Thank You"
- [ ] Audience-mode emphasis applied per slide
- [ ] Indonesian formatting applied if `indonesian_context: true`
- [ ] All output files emitted (even when arrays empty)

If any unchecked, revise. Do not emit.

---

## 8. Integration

| Skill | Interaction |
|-------|-------------|
| `pitch-deck-storyline` | Produces `storyline.json`. This skill REFUSES to run without it. |
| `pitch-deck-validate` | Consumes `deck.md` + `image-prompts.json` + `video-prompts.json` from this skill. |
| `ai-image-carousel-prompt-gen` | Optional hand-off — image prompts in this skill follow same GeminiGen.AI format; carousel-gen can render in batch if invoked. |
| `ai-video-promo-engine` | Optional hand-off — Seedance / VEO prompts in this skill follow the same grammar; video-gen can render. |
| `linkedin-post-writer` | Optional hand-off — slide 1 image + slide 10 ask can become a LinkedIn announcement. |
