# Scoring Rubric — The 100-Point Pitch Deck Quality Gate

> Read this when running `/pitch-deck-validate`. Five categories sum to 100. Combined ≥ 70 to publish. Hard-fails override the total.

---

## 1. Score summary

| Category | Weight | Pass minimum |
|----------|--------|--------------|
| Visual Ratio | 25 | 18 (no slide < 60%) |
| Narrative Arc | 20 | 14 |
| Ask Clarity | 15 | 10 |
| Investor Psychology | 20 | 14 |
| Anti-AI-Slop | 20 | 14 |
| **TOTAL** | **100** | **70 to publish** |

### Hard-fails (auto-reject regardless of total)

- Any slide with visual ratio < 60%
- Any banned vocabulary detected (English or Bahasa)
- Any hallucinated traction (number without source or `internal estimate` tag)
- Missing ask slide
- Closing slide is "Thank You" (not the ask)
- Generated AI faces on the team slide
- Top-down TAM with no bottom-up math

---

## 2. Category 1 — Visual Ratio (25 points)

**What it measures:** does each slide ≥ 70% visual cognitive weight?

### Scoring

For each of N slides, score:
- 0 pts if visual ratio < 60% (HARD FAIL)
- 1 pt if visual ratio 60–69%
- 2 pts if visual ratio 70–84%
- 2.5 pts if visual ratio ≥ 85%

Sum across all slides. Normalize to 25 points: `(sum / max_sum) × 25`.

### Per-slide visual ratio estimation

Use the area accounting method from `visual-language.md` §2:

| Element | Counts as |
|---------|-----------|
| Hero image / photo / illustration | Visual (full area) |
| Chart / graph / diagram (minimal labels) | Visual (full area) |
| Icon set with brief captions | 50% visual / 50% text |
| Number callout (big type) | 50% visual / 50% text |
| Headline (≤ 10 words) | Text |
| Sub-text (≤ 25 words) | Text |
| Bullet lists | Text |
| Body paragraphs | Text + HARD FAIL trigger |
| Logo / branding | Neutral (excluded) |
| White space | Neutral (excluded) |

Compute: `visual_area / (visual_area + text_area)`.

### Quick heuristic (no math)

- If you can cover the slide with a sheet of paper and only see headline + tiny logo, slide is mostly visual → likely PASS.
- If you can cover the slide and still see paragraphs, slide is text-heavy → likely FAIL.

### Per-category category scoring

| Category total | Pass? |
|----------------|-------|
| 18–25 (no slide < 60%) | Pass |
| 14–17 (one slide 60–69%) | Pass with note |
| 10–13 | Fail — fix slides under threshold |
| < 10 OR any slide < 60% | HARD FAIL — back to gen |

---

## 3. Category 2 — Narrative Arc (20 points)

**What it measures:** does the deck have a working story spine?

### Checklist (2 pts each — 10 items × 2 = 20 pts)

| # | Check | Pass criteria |
|---|-------|---------------|
| 1 | Hook in slide 1–2 | Falls in one of 6 hook formulas (per `storyline-frameworks.md` §3); not banned hook |
| 2 | Tension-build pattern declared | One of A/B/C/D explicitly used (cost-of-inaction / inevitable-wave / discovery-arc / two-worlds) |
| 3 | Emotional core is one (not mixed) | Exactly one of Fear/Greed/Identity/Curiosity/Tribe |
| 4 | Pattern match in slides 1–3 | "We are [winner] for [niche]" — comparable named |
| 5 | Setup beat hits in slides 1–2 | Vision + ask amount or ROI promise visible by slide 2 |
| 6 | Catalyst beat hits by slide 3 | Pain visualized; transformation hinted |
| 7 | Escalation peak hits in slide 6 or 7 | Proof + competition / moat surface here |
| 8 | Resolution beat hits by slide 8 | Team + traction land trust |
| 9 | Ask in slide 10 (or 11 in AI-era) | Specific number + use + deadline |
| 10 | All 10 standard investor questions mapped | Per `investor-psychology.md` §3 — none missing |

### Per-category scoring

| Total | Pass? |
|-------|-------|
| 18–20 | Pass — story spine intact |
| 14–17 | Pass with revision notes |
| 10–13 | Fail — back to storyline skill |
| < 10 | HARD FAIL — storyline skill must be re-run |

---

## 4. Category 3 — Ask Clarity (15 points)

**What it measures:** does the ask slide have specific number + specific use + specific deadline?

### Checklist (5 pts each — 3 items × 5 = 15 pts)

| # | Check | Pass criteria |
|---|-------|---------------|
| 1 | Specific number on the ask slide | VC: `Rp 30 B / $1.9M` exactly. B2B: pilot scope + commercial terms exact. No "we want to grow" |
| 2 | Specific use (4-bullet or pilot scope) | VC: 4-bucket use of funds with %. B2B: pilot duration + coverage + commercial structure |
| 3 | Specific deadline / milestones | VC: 18-month milestones with month markers. B2B: dated decision deadline 4–6 weeks out |

### Per-category scoring

| Total | Pass? |
|-------|-------|
| 13–15 | Pass — ask is contractual-grade |
| 10–12 | Pass with revision |
| 5–9 | Fail — ask is vague |
| < 5 OR ask slide missing OR closes on "Thank You" | HARD FAIL |

---

## 5. Category 4 — Investor Psychology (20 points)

**What it measures:** does the deck pre-empt the 5 first-90-second filters and the 10 standard investor questions?

### F1–F5 first-90-second filter checklist (10 pts — 2 pts each)

| # | Filter | Pass criteria |
|---|--------|---------------|
| F1 | Pattern match in slides 1–3 | Named comparable visible by slide 3 |
| F2 | Visceral problem + sourced size | Slide 2 has visceral image; slide 5 has sourced market math |
| F3 | Specific Why Now | Slide 4 has specific shift (regulatory / technical / behavioral); no macro cliché |
| F4 | Compounding traction or compounding mechanism | Slide 6 / 7 shows growth rate or moat that compounds |
| F5 | Founder–market fit + shipping credentials | Slide 8 / 10 names what the founder shipped (verb-led) |

### Q1–Q10 question pre-empt checklist (10 pts — 1 pt each)

| # | Question | Pass criteria |
|---|----------|---------------|
| Q1 | What do you do? | Slide 1 has one declarative sentence (no buzzwords) |
| Q2 | Why does it matter? | Slide 2 problem is visceral |
| Q3 | Why now? | Slide 4 specific shift |
| Q4 | What's the secret? | Slide 3 / 5 names the insight |
| Q5 | How big is the market? | Slide 5 bottom-up math |
| Q6 | How do you make money? | Slide 6 / 7 unit economics or operator P&L |
| Q7 | Is anyone using it? | Slide 6 / 7 traction or comparables |
| Q8 | What's your moat? | Slide 8 (AI-era 11) or appendix (Classic-10) — defends against foundation models |
| Q9 | Who's competing? | Slide 9 (AI-era 11) or 7 (Classic-10) — 2x2 with honest axes |
| Q10 | Why you? | Slide 10 / 11 team with shipping credentials |

### Per-category scoring

| Total | Pass? |
|-------|-------|
| 18–20 | Pass — investor psychology pre-empted |
| 14–17 | Pass with notes on missing pre-empts |
| 10–13 | Fail — back to storyline (story has holes) |
| < 10 | HARD FAIL — re-run storyline skill |

---

## 6. Category 5 — Anti-AI-Slop (20 points)

**What it measures:** does the deck avoid the visual + verbal patterns that signal "AI-generated"?

### Sub-checks

#### 6a — Banned vocabulary (8 pts)

Scan deck.md + speaker-notes.md for banned vocabulary (per `global-config.md` §4):

**English:** Unlock, Unleash, Empower, Supercharge, Maximize, Revolutionize, Transform, Disrupt, Synergize, Leverage (as verb), Cutting-edge, World-class, Best-in-class, Game-changing, Next-generation, Paradigm shift, Seamless, Robust, Scalable solution, Holistic.

**Bahasa:** solusi terbaik, inovatif, terdepan, terbaik di kelasnya, revolusioner, mengubah cara, mendisrupsi.

Scoring: -1 pt per detection (max -8). HARD FAIL if any English Tier-1 word detected (Unlock, Unleash, Empower, Supercharge, Maximize).

#### 6b — Cliché visual ban list (8 pts)

Scan image prompts for banned visual elements (per `global-config.md` §5):

| Banned visual | -1 pt |
|---------------|-------|
| Purple-to-blue gradient | -1 |
| Stock photo handshake | -1 |
| Light bulb = innovation icon | -1 |
| Gear icon = technology | -1 |
| Globe icon = international | -1 |
| Holographic UI floating | -1 |
| Person in suit looking at chart | -1 |
| Abstract neural network blob | -1 |

Max -8 pts. HARD FAIL if 4+ banned visuals detected (auto-flag for full visual rewrite).

#### 6c — Hallucinated traction (4 pts)

Each unsourced number on traction / market / case-study slides = -1 pt. HARD FAIL if any traction number lacks source AND is not tagged `internal estimate`.

### Per-category scoring

| Total | Pass? |
|-------|-------|
| 18–20 | Pass — clean of AI-slop |
| 14–17 | Pass with revisions noted |
| 10–13 | Fail — non-trivial slop detected |
| < 10 OR any HARD FAIL trigger | HARD FAIL — back to gen / storyline |

---

## 7. Combined scoring + bands

| Combined score | Band | Action |
|----------------|------|--------|
| 90–100 | A — investor-grade | Publish; share with confidence |
| 80–89 | B — ready with light polish | Publish after addressing notes |
| 70–79 | C — passes minimum bar | Publish OR iterate one more pass |
| 60–69 | D — borderline | Send back to storyline / gen for fixes |
| < 60 | F — not ready | Full re-pass needed |

Plus: any HARD FAIL → not published, regardless of combined score.

---

## 8. Validation report JSON schema (validation-report.json)

The validate skill emits this structure:

```json
{
  "schema_version": "1.0",
  "deck_id": "indusia-merchant-investor-deck-2026q2",
  "validated_at": "2026-05-02T14:32:00+07:00",
  "validator_version": "0.1.0",

  "passed": false,
  "combined_score": 64,
  "publish_threshold": 70,

  "categories": [
    {
      "name": "visual_ratio",
      "score": 17,
      "max": 25,
      "passed": false,
      "details": [
        {"slide": 4, "ratio_estimated": 0.42, "verdict": "HARD_FAIL", "fix": "Slide 4 has 4-bullet text block + small icons. Replace with single hero infographic showing bottom-up TAM bars."}
      ]
    },
    {
      "name": "narrative_arc",
      "score": 16,
      "max": 20,
      "passed": true,
      "details": [
        {"check": "all_10_questions_mapped", "verdict": "FAIL", "fix": "Q8 (moat) has no slide. Add moat slide between competition and team OR fold into competition slide."}
      ]
    },
    {
      "name": "ask_clarity",
      "score": 12,
      "max": 15,
      "passed": true,
      "details": [
        {"check": "specific_deadline", "verdict": "PARTIAL", "fix": "Ask slide says 'within Q3 2026' — sharpen to specific date (e.g. '15 May 2026')."}
      ]
    },
    {
      "name": "investor_psychology",
      "score": 13,
      "max": 20,
      "passed": false,
      "details": [
        {"check": "F3_why_now_specific", "verdict": "FAIL", "fix": "Slide 4 says 'digital transformation accelerating' — too generic. Replace with specific shift (BI-SNAP enforcement deadline / closed-loop economics curve)."}
      ]
    },
    {
      "name": "anti_ai_slop",
      "score": 6,
      "max": 20,
      "passed": false,
      "details": [
        {"slide": 1, "detection": "purple-to-blue gradient background", "verdict": "HARD_FAIL", "fix": "Replace background with off-white or branded photo of actual venue."},
        {"slide": 9, "detection": "phrase 'best-in-class platform'", "verdict": "FAIL", "fix": "Replace with concrete uptime number or remove."},
        {"slide": 6, "detection": "MRR claim 'Rp 12 M' has no source line", "verdict": "FAIL", "fix": "Add 'Source: internal data, April 2026' below the chart."}
      ]
    }
  ],

  "hard_fails": [
    {"category": "visual_ratio", "slide": 4, "issue": "ratio < 0.6"},
    {"category": "anti_ai_slop", "slide": 1, "issue": "purple gradient background"}
  ],

  "next_action": "BACK_TO_GEN",
  "next_action_targets": [
    "skills/pitch-deck-gen/SKILL.md (slides 1, 4, 6)",
    "skills/pitch-deck-storyline/SKILL.md (slide 4 why-now revision)"
  ]
}
```

---

## 9. The validator's tone

When emitting validation findings, the validator uses **diagnostic** language, not **judgmental** language:

| Diagnostic (good) | Judgmental (avoid) |
|-------------------|-------------------|
| "Slide 4 has visual ratio 0.42 — below 0.60 threshold" | "Slide 4 is bad" |
| "Replace with single hero infographic showing TAM bars" | "Make it better" |
| "F3 filter not pre-empted — slide 4 says 'digital transformation', too generic" | "This is wishy-washy" |
| "MRR claim Rp 12 M has no source line; add 'Source: internal data, April 2026'" | "You can't say this" |

Operators improve faster from specific diagnostics than from negative judgment.

---

## 10. Re-run dispatch logic

Validator output drives the next-step skill invocation:

| Failure type | Send back to |
|--------------|--------------|
| Visual ratio HARD FAIL | `/pitch-deck-gen` (regenerate failing slides only) |
| Anti-AI-slop visual detection | `/pitch-deck-gen` (regenerate image prompts on flagged slides) |
| Anti-AI-slop banned vocabulary | `/pitch-deck-gen` (rewrite slide text + speaker notes only) |
| Narrative arc fail | `/pitch-deck-storyline` (revise story spine; then re-gen) |
| Investor psychology fail | `/pitch-deck-storyline` (add missing pre-empts; then re-gen) |
| Ask clarity fail | `/pitch-deck-gen` (rewrite slide 10/11 only) |
| Hallucinated traction | `/pitch-deck-brief` (gather missing source) |

The `next_action_targets` field in the JSON tells the operator (or the agent) where to dispatch.
