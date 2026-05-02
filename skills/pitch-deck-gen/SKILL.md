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
| Visual ratio + anti-slop visual rules | + `references/visual-language.md` (ALWAYS) |
| Image prompt formulas per slide type | + `references/image-prompt-templates.md` (ALWAYS) |
| Video prompts (when motion=true on a slide) | + `references/seedance-prompt-templates.md` |
| Programmatic motion (when programmatic_motion=true) | + `references/remotion-config-templates.md` |
| Indonesian audience | + `references/indonesian-context.md` |
| B2B-mode visual cues | + `references/b2b-channel-partner-playbook.md` |

---

## 3. Hard Rules (NON-NEGOTIABLE)

These rules apply to every deck generation. Violation requires immediate correction before output.

1. **NEVER run without approved storyline.json.** First action: read `storyline.json`. If `approved_at` is `null`, refuse and route operator back to `/pitch-deck-storyline`.
2. **NEVER deviate from storyline.json's slide count or order.** The slides come from storyline. This skill writes the visual+verbal spec; it does NOT redesign the narrative.
3. **ALWAYS visual ratio ≥ 70% per slide.** Self-check using `visual-language.md` §2 method. Hard-fail at validate any slide < 60%.
4. **ALWAYS headline ≤ 10 words; sub-text ≤ 25 words.** No exceptions.
5. **NEVER use banned vocabulary** (per `global-config.md` §4) — English or Bahasa.
6. **NEVER produce banned visuals** (per `global-config.md` §5 + `visual-language.md` §13). Run the 5-question pre-flight check on every image prompt.
7. **ALWAYS source-tag every number on the slide.** "Source: internal data, April 2026" or "Source: BI Statistik 2025" or "internal estimate". No untagged numbers.
8. **NEVER generate AI faces for the team slide.** Mark slide for manual asset injection if real photos are unavailable.
9. **ALWAYS produce speaker notes 80–150 words per slide.** With one verbal-only insight not visible on the slide.
10. **NEVER close the deck on "Thank You".** Slide 10 (or 11 / 13) = the ask, with specific numbers + dated deadline.
11. **ALWAYS apply audience-mode emphasis** per `storyline.json` slides[i].audience_mode_emphasis. Don't blend modes.
12. **ALWAYS emit ALL output files** even when slides have no motion. `video-prompts.json` is `[]` when no motion, `remotion.config.json` is `{compositions: []}` when no programmatic motion. Empty arrays beat missing files.

---

## 4. Workflow: Visual Production

### Step 1 — Read storyline.json

Locate `storyline.json` (default: same output_dir as brief.json). Verify:

- `approved_at` is not `null`
- `approved_by` is set
- All slides have required fields (`headline`, `subtext`, `visual_concept`, `investor_preempt_question_id`, `verbal_only_insight`)

If any of these fail, STOP and route back to `pitch-deck-storyline`.

Also load `brief.json` for context (audience, language, FX baseline, compliance signals).

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

- Slide type → formula selection
- Slide 1 generated FIRST (style anchor)
- Slides 2–N reference slide 1's UUID via `ref_history` for cross-slide consistency
- Reference image bindings (`file_urls`) where real photos exist (operator's actual venue, founder headshots)
- For team slide: NEVER generate faces — mark `manual_asset_required: true`

Each prompt must pass the 5-question pre-flight check before being added to `image-prompts.json`.

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

#### `image-prompts.json`
```json
{
  "schema_version": "1.0",
  "deck_id": "{from brief.json}",
  "default_provider": "geminigen.ai",
  "default_model": "nano-banana-pro",
  "default_aspect_ratio": "16:9",
  "default_resolution": "2K",
  "default_output_format": "png",
  "style_anchor_slide": 1,
  "prompts": [
    {
      "slide": 1,
      "slide_role": "title",
      "visual_concept": "...",
      "prompt": "...",
      "model": "nano-banana-pro",
      "aspect_ratio": "16:9",
      "style": "Photorealistic",
      "output_format": "png",
      "resolution": "2K",
      "file_urls": [],
      "ref_history": null,
      "expected_filename": "slide-01-title.png",
      "manual_asset_required": false,
      "fallback_strategy": "..."
    }
    // ... per slide
  ]
}
```

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
| Slide visual ratio < 60% | Regenerate that slide before emit |
| Banned vocabulary in headline / sub-text | Auto-replace + alert |
| Image prompt contains "purple gradient" / "holographic UI" / banned visual | Regenerate prompt |
| Generated face on team slide | Replace with manual_asset_required flag |
| Speaker note < 80 words or > 150 words | Revise to range |
| Source line missing on a number | Block emit, ask brief stage for source |
| Slide 10/11 says "Thank You" | Replace with the ask immediately |
| Headline > 10 words | Cut to ≤10 |
| Bullet list of more than 3 items | Split into multiple slides OR convert to visual |

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
- [ ] Every slide has visual ratio ≥ 70% (estimated)
- [ ] No slide has visual ratio < 60%
- [ ] Every headline ≤ 10 words
- [ ] Every sub-text ≤ 25 words
- [ ] Every number on a slide has a source line
- [ ] No banned vocabulary detected (English or Bahasa)
- [ ] No banned visuals in any image prompt (5-question pre-flight passed for each)
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
