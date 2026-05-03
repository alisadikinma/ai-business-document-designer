# Visual Language — Cognitive Load, Text-to-Visual Ratio, Anti-AI-Slop

> Read this BEFORE writing any slide content. Visual ratio is enforced by `scoring-rubric.md`.

---

## 1. Why visual-first (the cognitive load case)

Three independent findings make text-first decks structurally worse than visual-first decks for investor / partner pitches:

1. **Picture superiority effect** (Paivio's dual-coding theory): images are recalled at 65% accuracy after 72 hours; text + image at 65%; text-only at 10%. The *speaker* is the verbal track — the slide is the visual track. Doubling the verbal track on the slide kills the visual track.
2. **DocSend reading-time data** (millions of deck views): investors spend an average of 13 seconds per slide on a successful deck and 9 seconds on a passed-on deck. They cannot read 100 words in 9 seconds. They can absorb one image, one number, one headline.
3. **Cognitive load competition**: when slide text exists, the audience reads it instead of listening to the speaker. A speaker reading the bullets aloud is a content duplicate; a speaker filling silence around bullets is competing with the audience's own reading speed. Either way, the speaker loses.

**Operational rule:** the slide is the visual; the speaker fills the words. If the deck reads the same as a Word doc, throw it away.

---

## 2. The visual ratio rule

Every slide must score ≥ 70% visual cognitive weight. Hard-fail under 60%.

### How to estimate visual ratio

Approximate the slide's canvas as 100% area. Sum the area occupied by each element:

| Element | Counts as visual? |
|---------|------------------|
| Hero image / photo / illustration | YES — full area |
| Chart / graph / diagram (with minimal labels) | YES — full area |
| Icon set with brief captions | PARTIAL — 50% (icons visual, captions text) |
| Number callout (e.g. "92%") in big type | PARTIAL — 50% (number is visual proof, but no surrounding context) |
| Headline (≤ 10 words) | TEXT — counts against |
| Sub-text (≤ 25 words) | TEXT — counts against |
| Bullet lists | TEXT — counts against |
| Body paragraphs | TEXT — counts against AND triggers hard-fail |
| Logo / branding mark | NEUTRAL — exclude from ratio |
| White space / margins | NEUTRAL — exclude |

**Worked example — passes:**
- Slide canvas 100%
- Hero photo of operator at venue: 60% area → 60% visual
- 8-word headline at top: 10% area → 10% text
- One number callout "Rp 12 M / month": 15% area → 15% (50% visual = 7.5% visual + 7.5% text)
- Logo lockup bottom right: 5% area → neutral
- Margins: 10% area → neutral
- **Visual ratio: 60% + 7.5% = 67.5% visual / 17.5% text**, with neutral 15%. Re-normalize to non-neutral area: 67.5 / 85 = 79% visual. PASS.

**Worked example — fails:**
- 4 bullet lines: 40% area → 40% text
- Small icon next to each bullet: 10% area → 5% visual + 5% text
- Headline: 15% area → 15% text
- Margins: 35% area → neutral
- Visual ratio: 5 / 65 = 7.7% visual. HARD FAIL.

### Quick heuristic (no math)

If you cover the slide with a sheet of paper and only see headline + tiny logo at the top, the rest is likely visual. PASS.
If you cover the slide with a sheet of paper and see paragraphs of text, the rest is likely text. FAIL.

---

## 2.5. Structured-data visual category (info-dense mode only)

**Why this section exists:** when `density_mode: "info-dense"` is set in `brief.json`, the deck must function as a stand-alone reference document for B2B partnership / channel adoption pitches. In that mode, label-rich data structures (tables, math waterfalls, comparison rows) are not "text" — they are **dense data visualization** that operators rely on for due-diligence. Counting them as text would force minimalist-VC-style decks that fail the partnership pitch.

This section defines when a structured-data block counts as VISUAL in the §2 visual-ratio calculation.

### Eligible block types (count as visual when criteria below are met)

| Block type | Visual when… |
|------------|--------------|
| **Comparison table** (2-3 column, e.g. "Without Us \| With Us \| Delta") | All cells short (≤4 lines), color-coded headers, brand palette used |
| **Math waterfall** (Layer 1 → Layer 2 → Layer 3 → Total) | ≤4 layers, each layer color-banded, numbers large (≥24pt), arrows or dividers between |
| **Multi-source footnote strip** (italic 9-10pt, ≤3 lines) | Visually distinct from body, source citations cite ≥3 named sources |
| **Stat-grid card** (2×3 or 3×2 cards, big number + label + sub) | Numbers ≥48pt, colored accent stripe per card, no body paragraphs inside cards |
| **Radial pain map** (center anchor + N pain cards radiating) | ≤9 pain cards, each card ≤3 lines, connection lines visible |
| **Horizontal-band flow** (Layer A / Layer B / Layer C input → output) | Each band color-coded, ≤4 output cards per band, arrows between zones |
| **Dual-stakeholder framing** (Left panel \| Center "MATCH" \| Right panel) | Equal panel widths, colored backgrounds, ✓/❌ rows ≤4 lines per panel |
| **Pricing tier cards** (3 horizontal cards, RECOMMENDED highlighted) | ≤6 bullets per card, bullets ≤2 lines each, big price ≥36pt, one card visually emphasized |

### Mandatory criteria (ALL must hold)

| Criterion | Why |
|-----------|-----|
| Color-coded headers / accent stripes | Visual scanning > linear reading |
| Grid alignment (cells aligned vertically + horizontally) | Misaligned grids = chaos = text-perception |
| Brand palette used (≥3 declared hex codes per block) | Without palette, blocks become generic = AI-slop |
| ≤4 lines per cell / card / row | More than 4 lines = paragraph = text |
| Numbers visually emphasized (≥24pt for layer/cell totals) | Number is the visual; surrounding text is the label |
| ≤8 cells/cards/rows in any one block | More than 8 = density crashes into noise |

### Disqualifying patterns (block reverts to TEXT counting)

| Pattern | Why it fails |
|---------|--------------|
| Bullet list ≥5 items in a single cell | That's a paragraph wearing bullet-points |
| No color coding (all cells same color) | Visual scanning collapses |
| Misaligned columns or rows | Reads as prose |
| Numbers smaller than 18pt | Number must dominate the cell |
| Multi-paragraph text in any cell | Paragraph = text, full stop |
| No source line on contested numbers | Untagged numbers = hallucination signal at validate |

### Worked example — passes (revenue waterfall with split)

- Hero ecosystem header: 25% area, big number 110pt + 2 split bars → counts as visual (numbers dominate, color-coded)
- 3-layer math waterfall: 55% area, 3 color-banded rows, ≤4 cells per row, all numbers ≥24pt → counts as visual
- VS status quo strip: 20% area, 3 cards each ≤4 lines, color-outlined → counts as visual
- Source line: 2% area, 9pt italic, names ≥3 sources → counts as visual (footnote strip eligible)
- Slide title + subtitle: 5% area → text
- **Net: ~95% visual ratio. PASS.**

Without §2.5, this same slide scores ~25% visual ratio (only the hero number counts) and HARD-FAILS — even though it's a McKinsey/BCG-grade revenue waterfall that operators trust more than a single hero photo.

### Worked example — fails (looks structured but isn't)

- "3-column table" but each cell has a 4-line paragraph explanation → reverts to text-counting
- "Stat grid" but numbers are 14pt and labels are 18pt → numbers don't dominate
- "Comparison table" all cells gray, no color coding → scanning collapses, reads as prose
- "Source line" with single source name → not a multi-source strip, doesn't qualify

### Mode applicability

| Density mode | §2.5 applies? |
|--------------|---------------|
| `minimalist` (VC default) | NO. Stick with §2 photo/chart/icon-only visual definition |
| `info-dense` (B2B partnership default) | YES. §2.5 unlocks structured-data as visual |

### Plugin enforcement

`pitch-deck-validate` must check each slide marked as info-dense:
1. Identify all structured-data blocks per slide.
2. For each block, run mandatory-criteria check (6 criteria above).
3. If ALL 6 pass → block area counts as visual. If any fail → block area counts as text.
4. Sum visual ratio per §2 method.
5. Apply same 70% / 60% thresholds.

---

## 3. The 8-second rule (slide reading order)

Every slide must communicate its core message within 8 seconds of first viewing, in this order:

| Second | What viewer sees | What slide must deliver |
|--------|-----------------|------------------------|
| 0–1 | The visual (image / chart) | The emotional / factual gist |
| 1–3 | The headline | The verbal claim |
| 3–5 | The number / proof point | The credibility |
| 5–8 | The sub-text (if any) | The nuance |
| 8+ | Done — speaker takes over | Speaker fills in detail |

If a slide requires the viewer to read for more than 8 seconds, the slide is over-written.

---

## 4. Headline rules

| Rule | Why |
|------|-----|
| ≤ 10 words | DocSend: investors read first 10 words and skim the rest |
| Active voice | "We grew 12x" not "12x growth was achieved" |
| Specific number when possible | "Rp 12M MRR" not "growing fast" |
| Verb-led for action slides, noun-led for fact slides | "We process 50,000 transactions/day" vs "50,000 daily transactions" |
| No gerunds ("Growing", "Building") as the lead | Sounds like a book chapter, not a fact |
| No question headlines | Investors don't want quizzes |
| No clichéd opening words | "The Future of...", "Reimagining...", "Welcome to the Era of..." |

---

## 5. Sub-text rules

| Rule | Why |
|------|-----|
| ≤ 25 words total | Anything more is body copy |
| Numbers and proper nouns only | "Rp 12M MRR · 47 venues · 3 cities" not "rapidly growing across multiple venues" |
| No adjectives | "fastest-growing", "world-class" — drop them |
| No marketing speak | See banned vocab in `global-config.md` §4 |
| Em-dashes or middle-dots between facts, not prose | `Rp 12M · 47 venues · 3 cities` reads faster than `Rp 12M across 47 venues in 3 cities` |

---

## 6. Typography for projection

| Element | Min point size | Suggested font family |
|---------|---------------|----------------------|
| Headline | 36 pt | Plus Jakarta Sans Bold, Inter Bold, or Geist Bold |
| Sub-text | 22 pt | Same family Regular |
| Captions / labels | 16 pt | Same family Regular |
| Footer / page no. | 12 pt | Same family Regular |

**Why these:** Plus Jakarta Sans is open-source, supports Bahasa diacritics, designed for screens. Inter and Geist are similar global picks. Avoid serif fonts for projector clarity.

**Anti-pattern:** Custom display fonts (Bebas Neue, Raleway Light, anything condensed) — they look "designed" but lose legibility at distance.

---

## 7. Color rules

### Palette structure

Three colors maximum:
1. **Primary** — your brand. Used for headlines, key numbers, hero accents. ~10% of canvas.
2. **Secondary** — neutral background. Off-white (`#F8F7F3`), warm gray (`#E8E6E1`), or near-black (`#0E0E0E`). ~80% of canvas.
3. **Accent** — one signal color for callouts (urgency, gain, alert). ~5–10% of canvas.

**Indusia-specific suggestion** (B2B mode default): primary deep navy `#0F1F3D`, secondary off-white `#F8F7F3`, accent saturated orange `#F25C24` (Indonesian flag adjacent, signals "active / now / move").

### Forbidden palette patterns

| Pattern | Why forbidden |
|---------|---------------|
| Purple-to-blue gradient background | Default of every AI-generated slide deck on the planet |
| Neon multi-stop gradient | Reads as crypto / NFT cliché |
| Pastel everything | Reads as wellness brand, undermines fintech credibility |
| Pure black `#000000` background | Causes hot-spotting on projectors, kills slide photos |
| Pure white `#FFFFFF` background | Glare on screens, dates the deck to 2010 |
| Brand color as full background | Headache + your logo gets lost |

---

## 8. Chart selection

Match the message to the chart:

| Message | Chart type | Avoid |
|---------|-----------|-------|
| "We're growing" | Line chart with single line, time on X | Bar chart of one metric over time |
| "Comparison between options" | Horizontal bar | Pie chart with > 3 slices |
| "Composition / share" | Donut with 2–3 slices, biggest at 12 o'clock | Pie chart with labels everywhere |
| "Distribution" | Histogram or strip plot | Stacked area |
| "Two variables relate" | Scatter with one highlighted point | 3D bubble chart |
| "Process / flow" | Horizontal arrow chain, 4–5 steps max | Org chart with 20 boxes |
| "Map / geography" | Choropleth or pin map | Stylized 3D globe |
| "Funnel / conversion" | Stepped bar funnel, rates labeled | Inverted pyramid with stock graphics |

**Chart anti-patterns:**
- Default Excel pastel palette
- Gridlines on every chart
- 3D bars / 3D pies
- Legends in 8-point font that no one can read
- Y-axis truncated to make small differences look large (red flag for due diligence)

**Chart pro-patterns:**
- One color for non-key data, brand color for the bar / line that matters
- Direct labels on lines, not legends
- Source line in 10-point at bottom: `Source: internal data, Q1 2026` or `Source: Statista, 2025`
- Round numbers on axis (0, 25, 50, 75, 100 — not 0, 23, 46, 69, 92)

---

## 9. Icon usage

**OK to use:**
- Concrete physical things: wristband, POS terminal, kiosk, dashboard screen, server rack, mall floor plan
- Action verbs as silhouettes: scan, tap, swipe, ring up, count, alert
- Branded marks: bank logos (BCA, Mandiri), payment provider logos (Midtrans, Xendit, DOKU)

**Banned icons (AI-slop):**
- Light bulb (= "innovation")
- Gear (= "technology")
- Globe (= "international")
- Rocket (= "growth")
- Brain with circuits (= "AI")
- Shield (= "security" — too generic; show what you protect against)
- Padlock (same problem)
- Handshake (= "partnership" — show actual partner logo)
- Magnifying glass + chart (= "analytics" — show actual chart)

**Icon style:**
- One icon family for the whole deck. Pick: Lucide (open-source, ~1500 icons), Phosphor (~9000 icons), or Heroicons.
- Stroke weight consistent (1.5px or 2px throughout)
- Single color (your accent), not multi-color

---

## 10. Photography guidance

### When to use photography
- Title slide hero
- Problem slide (visceral pain — operator looking exhausted, queue at counter, broken POS)
- Solution slide ("after" state — wristband on customer's wrist, dashboard on operator's tablet)
- Team slide (real photos of real people)
- Venue slide (your actual venue, signage visible)

### How to source photos
1. **Custom photography** — gold standard. Hire a photographer for one day at your real venue. ~Rp 3–5 juta gets 50+ usable shots.
2. **Real product screenshots** — second best. The actual UI, not mockups.
3. **Generated AI photography** — third option, only with strict prompts (see `image-prompt-templates.md`). Document that it's AI in speaker notes for honesty.
4. **Stock photography** — last resort. If used, pick from underused libraries (Unsplash > Shutterstock; never the top-page results which everyone uses).

### Photo composition for slides
- Wide aspect (3:2 or 16:9), no portrait orientation in landscape decks
- Focal subject in left or right third (rule of thirds), so headline can sit in opposite third
- Mid- to high-key lighting (avoid heavy shadows that compete with text)
- Strong negative space for text overlay

---

## 11. Speaker note rules (the verbal track)

The slide is the visual track; the speaker note is the verbal track. They must NOT duplicate.

### Per-slide note structure (80–150 words)

```
[1 sentence — re-anchor the audience to the slide's visual / number]
[3–5 sentences — context the slide does not show]
[1 sentence — bridge to next slide]
```

### Examples

**BAD (duplicates slide):**
> "As you can see on this slide, we have 47 venues across 3 cities, with monthly recurring revenue of Rp 12 million."

**GOOD (adds verbal-only context):**
> "Forty-seven venues — but the number that matters is the second one: 92% of operators that we onboarded in 2024 are still on the platform today. That retention is what's letting us close enterprise deals like Lippo Mall and Senayan City without spending on outbound. Next slide — what makes that retention number happen."

The good version delivers ONE new fact (92% retention) not on the slide, builds on the visible number, and previews the next slide. That's what speaker notes should do every time.

### Avoid

- Reading the slide aloud
- Restating the headline
- Over-explaining bullets that should not have been on the slide in the first place
- Long-winded "by the way" tangents
- Filler ("So basically what I'm trying to say is...")

---

## 12. The closing slide rule

The last slide is NOT "Thank You." Last slide = the ask, in big type, with concrete numbers.

| Mode | Last slide content |
|------|-------------------|
| VC | `Round size + use of funds 4-bullet + 3 milestones + email/QR for next step` |
| B2B | `Pilot scope + commercial terms + integration timeline + decision deadline (e.g. "We can go live in 6 weeks if signed by 15 May 2026")` |
| Hybrid | The ask most relevant to the audience in the room |

**Why no "Thank You":** the audience is going to look at the last slide for 30+ seconds during Q&A. Use that real estate to keep the ask in their face. A "Thank You" slide squanders the most valuable visual real estate in the entire deck.

---

## 13. Anti-AI-slop visual self-check

Before finalizing any image prompt, run this 5-question check:

1. **Did I specify an environment?** ("at the food court counter" not "in a modern setting")
2. **Did I specify a subject identity?** ("an Indonesian woman in her 30s in casual blazer" not "a businessperson")
3. **Did I specify lighting?** ("late-afternoon golden hour, warm" not "good lighting")
4. **Did I specify camera framing?** ("medium-close-up, eye level, shallow DoF" not "nice shot")
5. **Did I avoid the cliché bank?** No purple gradients, no holographic UI, no light bulb, no handshake, no globe, no neural network blob.

If any answer is "no" or "I'm not sure," rewrite the prompt before sending to GeminiGen.AI.
