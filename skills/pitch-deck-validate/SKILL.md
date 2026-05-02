---
name: pitch-deck-validate
description: Stage 4 of the 4-stage pitch-deck-designer pipeline. Use when scoring, validating, auditing, or quality-gating an existing pitch deck against the 100-point Pitch Deck Quality Score (Visual Ratio + Narrative Arc + Ask Clarity + Investor Psychology + Anti-AI-Slop). Triggers on validate pitch deck, score deck, audit deck, deck quality gate, deck check, deck validate, cek deck, validasi deck, check pitch quality, deck readiness check, or any request to review / score an existing deck before publication.
---

# Pitch Deck Validate — Stage 4: 100-Point Quality Gate

Stage 4 of 4. Reads `deck.md` (and `storyline.json` + `brief.json` for context). Scores 5 categories totaling 100 points. Emits `validation-report.json` with per-category scores, hard-fail flags, fixes, and next-action dispatch.

> **Where this fits:** `pitch-deck-brief` → `pitch-deck-storyline` → `pitch-deck-gen` → `pitch-deck-validate`. See `CLAUDE.md` for the full pipeline.

---

## 1. Iron Law

```
ANY HARD FAIL = AUTO-REJECT, REGARDLESS OF TOTAL SCORE.
```

Combined ≥ 70 / 100 is the publish threshold, but hard-fails (visual ratio < 60% on any slide, banned vocabulary, hallucinated traction, missing ask, "Thank You" closing, generated AI faces on team slide, top-down TAM only) override the total. A deck that scores 95 but has one hard-fail does not ship.

---

## 2. Reference Files (Read On-Demand)

ALWAYS read these for any validation:

| Reference | Purpose |
|-----------|---------|
| `references/global-config.md` | Banned vocabulary list, visual ratio thresholds, scoring weights |
| `references/scoring-rubric.md` | Per-category exact scoring methodology |
| `references/visual-language.md` | Visual ratio estimation method, anti-slop visual ban list |
| `references/investor-psychology.md` | F1–F5 first-90-second filters, Q1–Q10 standard questions |
| `references/storyline-frameworks.md` | Narrative-arc verification (story spine intact) |
| `references/indonesian-context.md` | Indonesian-specific validation (if `indonesian_context: true` in brief) |
| `references/b2b-channel-partner-playbook.md` | B2B-specific validation (if mode is b2b or hybrid) |

---

## 3. Hard Rules (NON-NEGOTIABLE)

1. **NEVER pass a deck with any hard-fail.** Combined score is irrelevant when hard-fails exist.
2. **ALWAYS read the artifact files** (`deck.md`, `storyline.json`, `brief.json`) — never score from memory or summary.
3. **ALWAYS use diagnostic tone**, not judgmental tone (per `scoring-rubric.md` §9).
4. **ALWAYS provide a specific fix** for every flagged issue. "Make it better" is forbidden; "Replace slide 4 background with off-white" is required.
5. **ALWAYS dispatch the next action** in the report — which upstream skill should the operator re-run, and which slides specifically.
6. **NEVER mark a category passed when sub-checks failed.** Per `scoring-rubric.md`, category-pass requires all sub-pass conditions.
7. **ALWAYS run all 5 categories.** No partial validation. If a deck file is missing, score that category 0 and flag.
8. **NEVER fabricate scores.** If a slide's visual ratio cannot be estimated (e.g. image prompt only, no rendered image), use the prompt's described area-allocation as proxy and flag uncertainty.

---

## 4. Workflow: Validation

### Step 1 — Locate input artifacts

Required:
- `deck.md` (the consolidated deck spec from `/pitch-deck-gen`)
- `image-prompts.json`
- `speaker-notes.md`
- `storyline.json` (for narrative-arc verification)
- `brief.json` (for context: mode, language, indonesian flag, FX baseline)

Optional:
- `video-prompts.json`
- `remotion.config.json`

If `deck.md` is missing or empty, stop and route to `/pitch-deck-gen`.

### Step 2 — Category 1: Visual Ratio (25 pts)

Per `scoring-rubric.md` §2:

For each slide, estimate visual ratio using the area-allocation method from `visual-language.md` §2:

```
visual_area = sum(image_area, chart_area, icon_visual_area + 0.5*icon_text_area, big_number_area*0.5)
text_area = headline_area + subtext_area + bullets_area + body_area + 0.5*icon_text_area + big_number_text_part
neutral_area = logo_area + whitespace_area
ratio = visual_area / (visual_area + text_area)  # neutral excluded
```

Per slide:
- < 60% → 0 pts AND HARD FAIL
- 60–69% → 1 pt
- 70–84% → 2 pts
- ≥ 85% → 2.5 pts

Sum and normalize: `(sum / max_sum) * 25`.

Output for this category:
- Total score (0–25)
- Per-slide ratio + verdict
- Hard-fail flags
- Fix per failing slide

### Step 3 — Category 2: Narrative Arc (20 pts)

Per `scoring-rubric.md` §3:

10 binary checks × 2 pts each:

| # | Check | Source |
|---|-------|--------|
| 1 | Hook in slide 1–2 from one of 6 formulas | `storyline.json.storyline_choices.hook_formula` ∈ [1..6] AND surfaced in slide 1–2 headline |
| 2 | Tension-build pattern declared | `storyline.json.storyline_choices.tension_pattern` ∈ {A,B,C,D} |
| 3 | Single emotional core (not mixed) | `storyline.json.storyline_choices.emotional_core` set + verifiable in slide content |
| 4 | Pattern match in slides 1–3 | `storyline.json.storyline_choices.pattern_match_primary` set + present in slide 1–3 text |
| 5 | Setup beat hits in slides 1–2 | `slides[0..1]` story_spine_beat = "setup" |
| 6 | Catalyst beat by slide 3 | `slides[1..2]` story_spine_beat ∈ ["catalyst", "catalyst → escalation"] |
| 7 | Escalation peak in slide 6/7 | `slides[5..6]` contains escalation peak |
| 8 | Resolution by slide 8 | `slides[7..]` story_spine_beat = "resolution" |
| 9 | Ask in slide 10/11/13 | last slide is the ask, not "Thank You" |
| 10 | All 10 standard questions mapped | `storyline.json.preempt_verification.Q1_through_Q10_mapped.passed = true` AND verifiable in slide content |

Output: 0–20 pts + per-check verdict + fix per failing check.

### Step 4 — Category 3: Ask Clarity (15 pts)

Per `scoring-rubric.md` §4:

3 checks × 5 pts each:

| # | Check | Pass criteria |
|---|-------|---------------|
| 1 | Specific number on ask slide | Exact amount visible (Rp X B / $Y M) for VC; pilot scope+commercial for B2B |
| 2 | Specific use (4-bullet or pilot scope) | Use of funds bullets with %, OR pilot duration+coverage+terms |
| 3 | Specific deadline / milestones | 18-month milestones for VC; dated decision deadline for B2B |

HARD FAIL if: ask slide missing OR closes on "Thank You" OR amount is "as much as possible" / "tbd".

### Step 5 — Category 4: Investor Psychology (20 pts)

Per `scoring-rubric.md` §5:

#### F1–F5 first-90-second filter (10 pts — 2 pts each)
- F1 Pattern match in slides 1–3 (named comparable)
- F2 Visceral problem + sourced size
- F3 Specific Why Now (no macro cliché)
- F4 Compounding traction or compounding mechanism
- F5 Founder–market fit + shipping credentials

Verify each from `deck.md` content + `storyline.json` mapping.

#### Q1–Q10 question pre-empt (10 pts — 1 pt each)
Map each question to a slide and verify the slide actually answers it (not just role-tagged).

Output: 0–20 + per-filter + per-question verdicts + fixes.

### Step 6 — Category 5: Anti-AI-Slop (20 pts)

Per `scoring-rubric.md` §6:

#### 6a — Banned vocabulary scan (8 pts max deduction)

Run regex over `deck.md` + `speaker-notes.md` for:

**English Tier-1 (any = HARD FAIL):** Unlock, Unleash, Empower, Supercharge, Maximize.

**English Tier-2 (-1 pt each, max -4):** Revolutionize, Transform, Disrupt, Synergize, Leverage (verb), Cutting-edge, World-class, Best-in-class, Game-changing, Next-generation, Paradigm shift, Seamless, Robust, Scalable solution, Holistic.

**Bahasa Tier-1 (-1 pt each, max -4):** solusi terbaik, inovatif, terdepan, terbaik di kelasnya, revolusioner, mengubah cara, mendisrupsi.

#### 6b — Cliché visual scan (8 pts max deduction)

Run keyword scan over `image-prompts.json` for:

| Banned phrase | -1 pt |
|---------------|-------|
| "purple gradient" / "purple-blue gradient" / "blue-purple gradient" | -1 |
| "stock photo handshake" / "handshake silhouette" | -1 |
| "light bulb" + "innovation" | -1 |
| "gear icon" + "technology" | -1 |
| "globe icon" + "international" | -1 |
| "holographic UI" / "floating in mid-air" | -1 |
| "person in suit" + "looking at chart" | -1 |
| "neural network blob" / "abstract circuits" | -1 |

HARD FAIL if 4+ banned visuals detected (auto-flag for full visual rewrite).

#### 6c — Hallucinated traction scan (4 pts max deduction)

For each number on traction / market / case-study slides:
- If `Source: ...` or `internal estimate` or `founder hypothesis` tag is present → OK
- If untagged → -1 pt + HARD FAIL flag

Combined: 20 - deductions = 6c score (clamped at 0).

### Step 7 — Hard fails roll-up

Collect ALL hard-fail flags from steps 2–6:

| Hard-fail trigger | From category |
|-------------------|---------------|
| Any slide visual ratio < 60% | Cat 1 |
| Ask slide missing OR "Thank You" close | Cat 3 |
| English Tier-1 banned word | Cat 5 |
| 4+ banned visuals | Cat 5 |
| Untagged traction number | Cat 5 |
| Top-down TAM only (per `brief.json`) | Cat 4 |
| Generated AI faces on team slide (per `image-prompts.json`) | Cat 5 |

If any hard-fail: `passed: false` regardless of combined score.

### Step 8 — Combined score + band

```
combined_score = cat1 + cat2 + cat3 + cat4 + cat5
```

| Band | Range | Action |
|------|-------|--------|
| A | 90–100 | Publish; share with confidence |
| B | 80–89 | Publish after addressing notes |
| C | 70–79 | Publish OR iterate one more pass |
| D | 60–69 | Send back to gen / storyline |
| F | < 60 | Full re-pass needed |

Plus: any hard-fail → `passed: false`.

### Step 9 — Next-action dispatch

Per `scoring-rubric.md` §10:

| Failure type | Send back to |
|--------------|--------------|
| Visual ratio HARD FAIL | `/pitch-deck-gen` (regenerate failing slides) |
| Anti-AI-slop visual detection | `/pitch-deck-gen` (regenerate image prompts on flagged slides) |
| Banned vocabulary | `/pitch-deck-gen` (rewrite slide text + speaker notes only) |
| Narrative arc fail | `/pitch-deck-storyline` (revise story spine; then re-gen) |
| Investor psychology fail | `/pitch-deck-storyline` (add missing pre-empts; then re-gen) |
| Ask clarity fail | `/pitch-deck-gen` (rewrite slide 10/11 only) |
| Hallucinated traction | `/pitch-deck-brief` (gather missing source) |
| Top-down TAM | `/pitch-deck-brief` (gather bottom-up math) |

Populate `next_action` + `next_action_targets` in the report.

### Step 10 — Emit `validation-report.json`

Per `scoring-rubric.md` §8 schema. Save to `{output_dir}/validation-report.json`.

Console output to operator (terse summary):

```
Validation result for {deck_id}: {PASS/FAIL}

Combined: {N}/100   Band: {A/B/C/D/F}   Hard fails: {count}

Cat 1 Visual Ratio:        {N}/25  {pass/fail}
Cat 2 Narrative Arc:       {N}/20  {pass/fail}
Cat 3 Ask Clarity:         {N}/15  {pass/fail}
Cat 4 Investor Psychology: {N}/20  {pass/fail}
Cat 5 Anti-AI-Slop:        {N}/20  {pass/fail}

Top fixes (in order of impact):
1. [slide N, cat X] Specific fix description
2. ...
3. ...

Next action: {BACK_TO_BRIEF / BACK_TO_STORYLINE / BACK_TO_GEN / PUBLISH}
Targets: {list of skills + slides to regenerate}
Full report: validation-report.json
```

---

## 5. Red Flags

| Red flag | Fix |
|----------|-----|
| `deck.md` missing | Hard-stop — route to `/pitch-deck-gen` |
| Validator marks all categories pass but combined < 70 | Math error — recompute |
| Category passed despite a hard-fail in its checks | Bug — fix scoring logic |
| Vague fix language ("improve this slide") | Rewrite to specific change |
| Validator skips a category | Run again; all 5 mandatory |
| Validator marks pass without verifying source-line on every number | Re-run cat 5 sub-check 6c |

---

## 6. Rationalization Prevention Table

| What I might think | What the skill says |
|--------------------|---------------------|
| "Hard fail is too strict for one purple gradient" | No. The cliché bank is a hard fail because it signals AI-slop pattern matching. Replace it. |
| "Combined score is 88, ship it" | Check hard-fails first. 88 with a hard-fail = no ship. |
| "The fix description can be 'tighten the slide'" | No. Specific changes only ("Replace slide 4 background with off-white"). |
| "I'll skip cat 4 since cat 1–3 already failed" | No. Run all 5. The full report tells the operator what else to fix in the same pass. |
| "Untagged number is a minor issue" | No. Post-eFishery, untagged traction is a deal-killer. Hard fail. |

---

## 7. Verification Checklist

Before emitting `validation-report.json`:

- [ ] All 5 categories scored
- [ ] All hard-fail triggers checked
- [ ] Per-slide visual ratio estimated (not skipped)
- [ ] Banned vocabulary scan covered both deck.md AND speaker-notes.md
- [ ] Image prompts scanned for banned visuals
- [ ] Traction numbers all checked for source tag
- [ ] Top-down TAM check vs `brief.json.market.tam_bottom_up`
- [ ] Combined score = sum of all 5 categories (no math errors)
- [ ] Band assigned correctly
- [ ] Next-action dispatch populated with specific skill + slide targets
- [ ] Tone is diagnostic, not judgmental
- [ ] Fixes are specific, not vague

If any unchecked, do not emit. Re-run.

---

## 8. Integration

| Skill | Interaction |
|-------|-------------|
| `pitch-deck-brief` | Reads `brief.json` for context (mode, indonesian flag, TAM source). Does not score this directly. |
| `pitch-deck-storyline` | Reads `storyline.json` for narrative-arc ground truth. Sends back to storyline if narrative-arc fails. |
| `pitch-deck-gen` | Consumes `deck.md` + `image-prompts.json` + `video-prompts.json`. Sends back to gen for visual-ratio / anti-slop / ask-clarity fails. |
| Other plugins | n/a — validate is internal to pitch-deck workflow. |
