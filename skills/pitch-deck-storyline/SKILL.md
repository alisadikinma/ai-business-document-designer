---
name: pitch-deck-storyline
description: Stage 2 of the 4-stage pitch-deck-designer pipeline. Use when designing the narrative arc, hook, story spine, emotional core, or pattern-match for a pitch deck — AFTER pitch-deck-brief has produced brief.json. Triggers on storyline, narrative arc, story spine, deck storyline, design pitch story, hook design, deck narrative, rancang storyline deck, design narrative pitch, frame the deck story, or any request to design narrative before writing slides. NEVER skips to gen — storyline is the soul of the deck and must be approved before visuals.
---

# Pitch Deck Storyline — Stage 2: Narrative Design

Stage 2 of 4. Reads `brief.json`, designs the narrative arc — hook, tension build, payoff, ask, pattern-match, emotional core, 10-slide story spine with audience-mode emphasis. Outputs `storyline.md` (human-readable for review) + `storyline.json` (machine-readable for `pitch-deck-gen`). HUMAN APPROVAL GATE before stage 3 — no visual tokens are spent until the storyline is locked in.

> **Where this fits:** `pitch-deck-brief` → `pitch-deck-storyline` → `pitch-deck-gen` → `pitch-deck-validate`. See `CLAUDE.md` for the full pipeline.

---

## 1. Iron Law

```
NO VISUAL GENERATION WITHOUT AN APPROVED STORYLINE.
```

The single biggest mistake AI deck tools make is jumping from brief → visual generation, skipping narrative design. The result: pretty slides that say nothing. This skill enforces the gate. Storyline must be reviewed and approved by a human (operator or stakeholder) before `pitch-deck-gen` runs.

---

## 2. Reference Files (Read On-Demand)

ALWAYS read `global-config.md` first, then layer additional references as needed.

| Task | Read first |
|------|-----------|
| ANY storyline | `references/global-config.md` (ALWAYS) |
| Storyline design (core) | + `references/storyline-frameworks.md` (ALWAYS) |
| Investor psychology pre-empts | + `references/investor-psychology.md` (ALWAYS) |
| Slide-sequence selection | + `references/deck-frameworks.md` |
| Deep research backbone | + `references/research/investor-pitch-deck-best-practices-2026.md` |
| Indonesian audience | + `references/indonesian-context.md` |
| B2B-mode storyline | + `references/b2b-channel-partner-playbook.md` |

---

## 3. Hard Rules (NON-NEGOTIABLE)

These rules apply to every storyline. Violation requires immediate correction before output.

1. **NEVER skip the human approval gate.** Storyline ships to operator for review. No `pitch-deck-gen` invocation until operator confirms.
2. **ALWAYS use one of 6 hook formulas.** Pick from `storyline-frameworks.md` §3. No invented hook patterns.
3. **NEVER mix emotional cores.** Exactly one of Fear / Greed / Identity / Curiosity / Tribe per deck (per `storyline-frameworks.md` §5).
4. **ALWAYS declare a tension-build pattern.** One of A/B/C/D from `storyline-frameworks.md` §4 must be explicitly chosen.
5. **ALWAYS include pattern match in slides 1–3.** Use the library in `storyline-frameworks.md` §6. Indonesian-mode prioritizes priority-1/2 (Indonesian comparables).
6. **ALWAYS map all 10 standard investor questions to specific slides.** Per `investor-psychology.md` §3. Any unmapped question = storyline hole = back to revision.
7. **ALWAYS pre-empt all 5 first-90-second filters (F1–F5).** Per `investor-psychology.md` §2.
8. **NEVER write a "Thank You" slide.** Slide 10 / 11 = the ask, with specific numbers + dated deadline.
9. **ALWAYS use bottom-up TAM math** (per `brief.json` market section). Top-down TAM survives no DD post-eFishery.
10. **ALWAYS include a moat declaration for VC mode.** The 2026 moat slide carries 30–40% of underwriting weight. Specific defense thesis required, not generic claims.
11. **NEVER fabricate traction or comparable companies.** Use only what `brief.json` provides. If story needs a stronger pattern match than brief offers, push back to brief stage.
12. **ALWAYS apply audience-mode emphasis** (per `deck-frameworks.md` §2/3/4). Don't apply VC slide-language to a B2B audience or vice versa.

---

## 4. Workflow: Storyline Design

### Step 1 — Read brief.json

Locate `brief.json` (default: current working directory or `/tmp/`). Read all fields. Confirm:

- `audience.confirmed_mode` is set (not just inferred)
- `framework.confirmed` is set
- `traction.metrics` all have `source` fields
- `market.tam_bottom_up` is bottom-up math (not top-down)
- `why_now.specific_shift` is specific, not macro cliché

If any of these are missing or violate hard rules, STOP and route back to `pitch-deck-brief`.

### Step 2 — Hook design

Pick one of the 6 hook formulas (per `storyline-frameworks.md` §3):

1. Visceral statistic
2. Insider observation
3. Counter-intuitive claim
4. Customer quote (verbatim)
5. Personal stake
6. Visual hook (no text)

**Heuristic for selection:**

| Brief signal | Suggested hook |
|--------------|---------------|
| Strong sourced market statistic in brief | Visceral statistic (#1) |
| Founder has insider experience in domain | Insider observation (#2) |
| Conventional wisdom in space is wrong | Counter-intuitive claim (#3) |
| Brief includes verbatim customer quote with attribution | Customer quote (#4) |
| Founder has personal-stake story | Personal stake (#5) |
| One image alone tells story | Visual hook (#6) |

Surface the recommendation + 1 alternative to the operator. Operator picks.

### Step 3 — Tension-build pattern

Pick A / B / C / D (per `storyline-frameworks.md` §4):

| Pattern | Best for |
|---------|----------|
| A — Cost-of-Inaction Spiral | B2B mode, regulated markets |
| B — Inevitable Wave | VC mode, market-timing pitches |
| C — Discovery Arc | Founder-led, second-time founders |
| D — Two-Worlds Comparison | B2B mode, ROI-driven |

Surface recommendation + rationale. Operator confirms.

### Step 4 — Emotional core

Pick exactly ONE of: Fear / Greed / Identity / Curiosity / Tribe.

Default heuristics:
- Indonesian B2B mode → Fear/Loss (Yukk lock-in, foot-traffic decline)
- Indonesian VC mode → Identity (Indonesian fintech pride, BI-SNAP era leaders)
- Pre-revenue + insight-led → Curiosity
- Mature + ROI-driven → Greed
- Mission / community / ecosystem play → Tribe

Surface the recommendation + reasoning to operator.

### Step 5 — Pattern match

From `storyline-frameworks.md` §6 library, select one or two pattern matches.

Indonesian-mode priority order (per `indonesian-context.md` §7):
1. Indonesian winners (Tokopedia, Tiket.com, Xendit, Midtrans, GoTo, Ruangguru, Halodoc)
2. Strong adjacent Indonesian (Bukalapak, Akulaku, Kopi Kenangan, Mamikos)
3. SEA winners (Grab, Sea/Shopee, Carousell)
4. India / China comparables (Paytm, Ant) — only when "Indonesia is N years behind" thesis applies
5. US winners (Stripe, Square, Shopify) — last resort

VC-mode default: priority 1–3.
B2B-mode default: priority 1–2.

Pattern match must surface verbatim by slide 3.

### Step 6 — Story spine mapping

Apply the audience-mode emphasis tables (per `deck-frameworks.md` §2/3/4):

- **Classic-10** (B2B default + pre-revenue VC): 10-slide template
- **AI-era 11** (VC default for 2026): adds Why Now (slide 4) + Moat (slide 8)
- **Traction-first 13** (high-revenue VC, ARR > $1M): leads with traction at slide 2

Map per slide:

| Slide # | Role | Headline pattern | Investor pre-empt | Visual concept (one-sentence) | Verbal-only insight (speaker note) |
|---------|------|------------------|-------------------|------------------------------|-----------------------------------|

Apply mode-specific emphasis at the slide level (not just the framework level).

### Step 7 — Pre-empt verification

Run through the verification checklist (per `investor-psychology.md` §10):

- [ ] F1 — Pattern match in slides 1–3 (named comparable)
- [ ] F2 — Visceral problem in slide 2 with sourced size in slide 5
- [ ] F3 — Specific Why Now in slide 4 (no macro clichés)
- [ ] F4 — Compounding traction or compounding mechanism in slide 6 / 7
- [ ] F5 — Founder–market fit in slide 8 / 10 (shipping credentials, not FAANG titles)
- [ ] Q1–Q10 — Each of the 10 standard questions mapped to a specific slide
- [ ] Moat slide present and answers "what happens when foundation model X lands" (VC mode)
- [ ] Bottom-up market sizing (no top-down)
- [ ] If ARR > $1M, traction surfaced by slide 2 not buried

If any unchecked, revise the storyline. Do NOT emit until all checks pass.

### Step 8 — Emit `storyline.md` (human-readable)

Single markdown file structured for human review:

```markdown
# Storyline — {Product Name} → {Audience}

> Generated: {ISO 8601 timestamp}
> Mode: {vc / b2b / hybrid} · Framework: {classic_10 / ai_era_11 / traction_first_13}
> Language: {id / en / bilingual}

## The Macro Story (3 sentences)

{One-paragraph summary of the entire deck in 3 sentences:
sentence 1 = the catalyst (what's broken)
sentence 2 = the resolution (what we built)
sentence 3 = the ask (what we want)}

## Storyline Choices

| Element | Choice | Rationale |
|---------|--------|-----------|
| Hook formula | {1–6} | {why this works for this audience} |
| Tension pattern | {A/B/C/D} | {why this works} |
| Emotional core | {Fear/Greed/Identity/Curiosity/Tribe} | {why this is the dominant one} |
| Pattern match (primary) | "We are {Winner} for {Niche}" | {why this lands with this audience} |

## 10/11/13-Slide Story Spine

### Slide 1 — Title / Vision
- **Story spine beat:** Setup
- **Headline:** {≤10 words}
- **Visual concept:** {one-sentence what-it-shows}
- **Investor pre-empt:** Q1 — what do you do?
- **Verbal-only insight (speaker note kernel):** {one new fact not on the slide}

### Slide 2 — Problem
...

(continue per slide)

## Pre-Empt Verification

- [x] F1 pattern match in slides 1–3 — yes, "{name}" surfaced in slide 1 headline
- [x] F2 visceral problem + sourced size — yes, slide 2 photo + slide 5 source line
- [x] F3 specific Why Now — yes, BI-SNAP enforcement deadline 1 May 2026 cited
- [x] F4 compounding mechanism — yes, slide 7 closed-loop wristband data moat
- [x] F5 founder–market fit — yes, slide 10 shipping credentials per founder
- [x] Q1–Q10 all mapped — yes, see slide table above

## Approval Gate

Operator: please review the storyline above. To approve, reply `/pitch-deck-storyline approve`. To revise, describe what should change. To re-do from scratch, run `/pitch-deck-brief` again.

Once approved, run `/pitch-deck-gen` to generate the visual production spec.
```

### Step 9 — Emit `storyline.json` (machine-readable for gen)

```json
{
  "schema_version": "1.0",
  "deck_id": "{from brief.json}",
  "approved_at": null,
  "approved_by": null,

  "macro_story": {
    "catalyst_sentence": "...",
    "resolution_sentence": "...",
    "ask_sentence": "..."
  },

  "storyline_choices": {
    "hook_formula": 3,
    "tension_pattern": "B",
    "emotional_core": "Fear",
    "pattern_match_primary": "Stripe for Indonesian bazaars",
    "pattern_match_secondary": null
  },

  "framework": "ai_era_11",

  "slides": [
    {
      "slide_number": 1,
      "role": "title",
      "story_spine_beat": "setup",
      "headline": "...",
      "subtext": "...",
      "visual_concept": "...",
      "investor_preempt_question_id": "Q1",
      "verbal_only_insight": "...",
      "audience_mode_emphasis": "vc",
      "video_motion_recommended": false,
      "programmatic_motion_recommended": false
    }
    // ... slides 2..N
  ],

  "preempt_verification": {
    "F1_pattern_match": {"passed": true, "evidence": "slide 1 + slide 3"},
    "F2_visceral_problem": {"passed": true, "evidence": "slide 2 photo + slide 5 source"},
    "F3_why_now": {"passed": true, "evidence": "slide 4: BI-SNAP enforcement deadline 1 May 2026"},
    "F4_compounding": {"passed": true, "evidence": "slide 7: closed-loop wristband data moat"},
    "F5_founder_market_fit": {"passed": true, "evidence": "slide 10: shipping credentials"},
    "Q1_through_Q10_mapped": {"passed": true, "missing": []}
  }
}
```

Save to: `{output_dir}/storyline.md` and `{output_dir}/storyline.json`.

### Step 10 — Hand-off to operator

Output to operator:

```
✓ storyline.md saved to {path} (review this — full narrative arc)
✓ storyline.json saved to {path} (machine-readable for /pitch-deck-gen)

⚠ HUMAN APPROVAL GATE
Review storyline.md. Confirm or revise.

Once approved, run /pitch-deck-gen to spend tokens on visuals.
DO NOT run /pitch-deck-gen before storyline is approved.
```

The skill stops here. `pitch-deck-gen` reads `storyline.json` only after the operator runs it.

---

## 5. Red Flags

| Red flag | Fix |
|----------|-----|
| Hook formula not in 1–6 list | Reject — pick from library |
| Mixed emotional core ("Fear AND Greed") | Reject — pick exactly one |
| Pattern match is "The Apple of X" or banned | Reject — pick valid pattern |
| Slide 10 contains "Thank You" | Reject — slide 10 = ask |
| Some Q1–Q10 unmapped | Reject — fix before emit |
| TAM is top-down only | Route back to brief skill |
| Storyline emitted without `verbal_only_insight` per slide | Reject — speaker notes need verbal-only kernel |
| `pitch-deck-gen` invoked before approval | Hard-stop — refuse to proceed |

---

## 6. Rationalization Prevention Table

| What I might think | What the skill says |
|--------------------|---------------------|
| "The brief mentions traction; I'll skip Q4 traction pre-empt" | No. Map every Q1–Q10 explicitly. |
| "Two emotional cores would be richer" | No. Exactly one. Mixing dilutes. |
| "I can write the hook freely" | No. Use one of the 6 formulas. |
| "The storyline is obvious; I'll skip the approval gate" | No. The gate is the point. Without it, gen burns tokens on un-vetted story. |
| "Pattern match is optional if the product is novel" | No. Investors pattern-match anyway. Surface the right shelf or they'll pick a wrong one. |

---

## 7. Verification Checklist

Before emitting `storyline.md` + `storyline.json`:

- [ ] Read `brief.json` and verified all fields
- [ ] Hook from one of 6 formulas, no banned hooks
- [ ] Tension pattern declared (A / B / C / D)
- [ ] Exactly one emotional core
- [ ] Pattern match surfaces by slide 3
- [ ] All 10 questions mapped to slides
- [ ] All 5 first-90-second filters pre-empted
- [ ] Slide 10 (or 11) is the ask, not "Thank You"
- [ ] Bottom-up TAM (not top-down)
- [ ] Moat slide present (VC mode, AI-era framework)
- [ ] Audience-mode emphasis applied per slide
- [ ] Each slide has a `verbal_only_insight` for speaker notes
- [ ] No banned vocabulary in storyline text
- [ ] Indonesian-mode signals applied if `indonesian_context: true`

If any unchecked, revise. Do not emit.

---

## 8. Integration

| Skill | Interaction |
|-------|-------------|
| `pitch-deck-brief` | Produces `brief.json` — input to this skill. Cannot run without it. |
| `pitch-deck-gen` | Consumes `storyline.json` from this skill. Will refuse to run without approved storyline. |
| `pitch-deck-validate` | Reads `storyline.json` as ground truth for narrative-arc scoring (category 2). |
| Other plugins | n/a directly; storyline is internal to pitch-deck workflow. |
