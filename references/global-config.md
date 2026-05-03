# Global Config — Single Source of Truth

> **All other files reference this config.** To change any setting, edit THIS file only.
> SKILL.md, agent.md, CLAUDE.md, README.md, and reference docs all read this file first.

---

## How to change a setting

1. Find the setting below
2. Change the value
3. Done — every other file reads this config at runtime

---

## 1. Audience modes

| Mode | Trigger keywords (auto-detect) | Framework default | Currency primary |
|------|------------------------------|-------------------|------------------|
| `vc` | invest, equity, fundraise, Series A/B/C, valuation, exit, IPO, term sheet | Sequoia 10-slide adapted | USD (IDR parenthetical) |
| `b2b` | adopt, deploy, partner, ROI, pilot, integration, mall, EO, food court, owner-operator | B2B 10-slide adapted | IDR (USD parenthetical) |
| `hybrid` | both VC ask + B2B value claim | B2B 10-slide + appendix VC slides | IDR primary |

**Default mode if ambiguous:** `b2b` (the more common case for Indonesian SaaS / payments).

---

## 2. Language

| Setting | Value |
|---------|-------|
| `default_language` | Bahasa Indonesia |
| `bilingual_default` | Bahasa headline + English subtitle (optional) |
| `speaker_notes_language` | Same as default_language |
| `prompt_language` | Always English (AI image/video model instruction language) |
| `english_only_trigger` | Audience explicitly international (Singapore, US, EU investor) |

---

## 3. Visual ratio (HARD GATE)

| Setting | Value |
|---------|-------|
| `visual_ratio_minimum` | 70% per slide |
| `visual_ratio_hardfail` | < 60% per slide → automatic reject |
| `headline_word_max` | 10 words (minimalist) / 12 words (info-dense) |
| `subtext_word_max` | 25 words (minimalist) / 40 words per zone, ≤2 zones (info-dense) |
| `bullets_per_slide_max` | 3 (minimalist) / 6 in structured-data zones (info-dense) |
| `body_paragraph_forbidden` | true (NEVER write paragraphs on slides) |

> **Cognitive weight calculation:** approximate visual area / slide area. A slide with a hero image filling 60% of the canvas + 8-word headline = ~85% visual ratio. A slide with 4 bullet lines + small icon = ~25% visual ratio (FAIL).

> **Structured-data exception (info-dense mode only):** label-rich data structures — comparison tables, math waterfalls, multi-source footnote strips, stat-grid cards, radial pain maps — count as VISUAL when they meet the §2.5 structured-data criteria in `visual-language.md` (color-coded headers, grid alignment, brand palette, ≤4 lines per cell). See §3.5 below.

---

## 3.5. Density mode (info-dense vs minimalist)

Pitch decks have two operational modes with different word-count, structure, and visual-ratio rules. **Default is `minimalist` for VC, `info-dense` for B2B partnership and hybrid.**

| Setting | `minimalist` (VC default) | `info-dense` (B2B partnership default) |
|---------|---------------------------|----------------------------------------|
| `headline_word_max` | 10 | 12 |
| `subtext_word_max` | 25 | 40 (sub-text per zone, ≤2 zones per slide) |
| `bullets_per_slide_max` | 3 | 6 (only inside structured-data zones, color-coded) |
| `data_table_rows_max` | not allowed | 8 |
| `math_waterfall_steps_max` | not allowed | 4 (Layer 1 → Layer 2 → Layer 3 → Total) |
| `source_strip_lines_max` | 1 | 3 (multi-source footnote, italic 9–10pt) |
| `visual_ratio_minimum` | 70% (visual = photo/chart/icon) | 70% (visual = photo/chart/icon **OR** structured-data per §2.5 in `visual-language.md`) |
| `slide_zones_max` | 3 (hero, headline, footer) | 7 (top-strip, hero, left-panel, center-panel, right-panel, comparison-row, footnote-strip) |
| Default `slide_1_3_style` | Photo (Editorial / Photorealistic) | Infographic-flat (cover with brand atmosphere; problem as radial; solution as 3-band flow) |

### How to choose density mode

1. Audience reads the deck **before** the meeting? → `info-dense` (operator has time to absorb).
2. Audience reads **during** a 5-minute live pitch? → `minimalist` (cognitive load matters).
3. Deck is a **reference document** sent over email + walked through async? → `info-dense`.
4. Deck must **stand alone** without speaker narration (cold to mall ops, EO, BizDev, channel partners)? → `info-dense`.

The banned vocab in §4 below applies to BOTH modes. Word-count limits relax in info-dense mode but the AI-slop word ban does NOT relax.

---

## 3.6. Brand palette (REQUIRED, not suggestion)

Every deck MUST declare a brand palette in `brief.json.brand_palette` before `pitch-deck-gen` runs. The plugin auto-injects these hex codes into every image prompt verbatim — no inference, no "warm-orange-ish".

### Required structure

```json
"brand_palette": {
  "background": "#F8F4ED",     // Required — slide canvas (off-white / cream / near-black)
  "primary":    "#1AB8B6",     // Required — brand identity (logos, headers, hero)
  "accent":     "#FF8C42",     // Required — signal/callout (numbers, CTAs)
  "secondary":  "#5860D6",     // Optional — second-tier highlight (sparingly)
  "warning":    "#C53030",     // Optional — alert/risk callouts only
  "ink":        "#1A2540"      // Required — primary text color (titles, body)
}
```

### Hard rules

| Rule | Why |
|------|-----|
| ≥ 4 hex codes (`background`, `primary`, `accent`, `ink`) MANDATORY | Without these, prompts default to AI-slop palettes |
| Hex codes injected **verbatim** into every image prompt | "Use deep teal" → AI guesses → inconsistent. "Use #1AB8B6" → exact match |
| Same palette on every slide of the deck | Cross-slide consistency = brand recall |
| Reject palettes containing forbidden patterns from §5 below | Purple-blue gradients, neon multi-stops, pure-black bg = banned |

### Default palettes (when operator has no preference)

| Mode | Default palette |
|------|----------------|
| Indonesian B2B partnership | `bg #F8F4ED · primary #0F1F3D · accent #F25C24 · ink #0E1B2E` (Indonesian-flag adjacent) |
| Indonesian VC | `bg #F8F7F3 · primary #0F1F3D · accent #F25C24 · ink #0E1B2E` |
| International VC | `bg #FAFAF9 · primary #18181B · accent #2563EB · ink #09090B` |

> **Operator override always wins.** Defaults are last-resort fallbacks if the operator has no opinion.

---

## 4. Forbidden vocabulary

**DO NOT USE these words in any slide text or speaker note:**

`Unlock` · `Unleash` · `Empower` · `Supercharge` · `Maximize` · `Revolutionize` · `Transform` · `Disrupt` · `Synergize` · `Leverage (as verb)` · `Cutting-edge` · `World-class` · `Best-in-class` · `Game-changing` · `Next-generation` · `Paradigm shift` · `Seamless` · `Robust` · `Scalable solution` · `Holistic`

**Why:** these are AI-slop and consultant-deck signals. Investors pattern-match them to "no real substance underneath."

**Replacements:**
| Instead of | Use |
|-----------|-----|
| Unlock new revenue | Add Rp X juta / month |
| Empower merchants | Cut merchant onboarding from 7 days to 2 hours |
| Game-changing platform | First Indonesian POS with closed-loop wristband |
| Scalable solution | Handles 10,000 transactions/hour at one venue |
| Best-in-class UX | 92% merchant retention after 90 days |

**Indonesian banned words:** `solusi terbaik`, `inovatif`, `terdepan`, `terbaik di kelasnya`, `revolusioner`, `mengubah cara`, `mendisrupsi`. Replace with concrete numbers or remove.

---

## 5. AI-slop visual ban list

These visual clichés are forbidden in image prompts:

| Banned visual | Reason | Use instead |
|--------------|--------|-------------|
| Purple-blue gradient background | Default for every AI image, screams "I gave up" | Specific environment (mall corridor, food court, control room) |
| Stock photo handshake | Says nothing, signals "I don't know what to show" | Real workflow moment (cashier scanning wristband, operator reading dashboard) |
| Light bulb = innovation | Children's-book metaphor | The actual innovation (wristband on wrist, offline POS without connection) |
| Gear icon = technology | Means nothing | Specific tech component (RFID antenna, edge device, dashboard screen) |
| Globe = international | Generic | Specific geography (Indonesia map with venue pins) |
| Abstract neural network blob | "AI = mysterious blue tendrils" | Real AI output (heatmap, sales chart with anomaly markers) |
| Holographic UI floating in mid-air | Sci-fi cliché | Real screen on real device (tablet, kiosk, phone) |
| Person in suit looking at chart | Stock-photo theatre | Operator at the venue with the actual product running |
| Generic city skyline | Says nothing about your business | Your actual venues (mall names visible, real cities) |
| AI-generated faces with extra fingers | Visible defect | Real photography or carefully prompted human assets |

---

## 6. Scoring thresholds (validation gate)

| Category | Weight | Pass minimum |
|----------|--------|--------------|
| Visual Ratio | 25 pts | 18 pts (no slide < 60%) |
| Narrative Arc | 20 pts | 14 pts |
| Ask Clarity | 15 pts | 10 pts |
| Investor Psychology | 20 pts | 14 pts |
| Anti-AI-Slop | 20 pts | 14 pts |
| **Combined total** | 100 | **70** to publish |

**Hard fails (auto-reject regardless of total):**
- Any slide with visual ratio < 60%
- Any banned vocabulary detected
- Hallucinated traction (claim without source or "internal estimate" tag)
- Missing ask slide
- Closing on "Thank You" instead of the ask

---

## 7. Slide count

| Setting | Value |
|---------|-------|
| `core_slide_count` | 10 (mandatory) |
| `appendix_slide_max` | 5 (optional, only if data supports) |
| `total_slide_hardcap` | 15 |
| `presentation_time_target` | 5–7 minutes core + Q&A |

> **Why 10 + 5:** DocSend research shows median successful seed/Series-A deck = 19 slides, but the 10 core slides receive 80% of investor reading time. Appendix is for "convince me later" data — never the main story.

---

## 8. Speaker notes

| Setting | Value |
|---------|-------|
| `words_per_slide` | 80–150 |
| `seconds_per_slide` | 30–45 (matches 80–150 word delivery at conversational pace) |
| `tone` | persuasive + conversational, not formal |
| `avoid` | restating slide text, reading bullets aloud, business-school jargon |
| `must_include` | one verbal-only data point per slide (something not on the slide) |

---

## 9. Image generation defaults

| Setting | Value |
|---------|-------|
| `image_provider` | GeminiGen.AI |
| `default_model` | nano-banana-pro |
| `default_aspect_ratio` | 16:9 (landscape — standard slide format) |
| `default_resolution` | 2K |
| `default_style` (minimalist mode) | Photorealistic (product / venue / team), Editorial (problem / vision), Infographic-flat (charts / data) |
| `default_style` (info-dense mode) | **Infographic-flat for slides 0–3 and 5–8** (cover, problem, solution, market, product, ROI). Photo only for team slide (real founder photos via `file_urls`). |
| `default_output_format` | png (lossless for slides) |
| `safety_filter_aware` | true — apply `references/safety-filter-playbook.md` patterns when prompts include real-person reference images |

See `image-prompt-templates.md` for per-slide-type formulas and `safety-filter-playbook.md` for MINOR_UPLOAD / safety-filter mitigation.

---

## 10. Video generation defaults

| Setting | Value |
|---------|-------|
| `video_provider` | Seedance 2.0 (preferred), VEO 3.1 (fallback) |
| `default_duration` | 4–8 seconds (loop-friendly) |
| `default_aspect_ratio` | 16:9 |
| `use_video_when` | demo loop (product UI motion), animated chart (number reveals), transition between major sections (problem → solution) |
| `do_not_use_video_when` | static fact slide, headshot, single chart, ask slide |

See `seedance-prompt-templates.md` for per-slide-type formulas.

---

## 11. Remotion (programmatic motion)

| Setting | Value |
|---------|-------|
| `use_remotion_when` | live data (counter ticking up), scroll-driven storytelling, parallax hero, animated map with pins appearing |
| `default_fps` | 30 |
| `default_duration_frames` | 240 (8 seconds at 30fps) |
| `output_format` | mp4 |

See `remotion-config-templates.md`.

---

## 12. Indonesian-mode defaults

When mode is `b2b` and audience is Indonesian (default):

| Setting | Value |
|---------|-------|
| `currency_primary` | IDR |
| `currency_format` | `Rp 1,5 M` (juta) / `Rp 2 T` (triliun) — Indonesian shorthand |
| `usd_parenthetical` | `Rp 1,5 T (~$95M)` — when comparing to global benchmarks |
| `comparable_companies_priority` | Indonesian first (Yukk, Midtrans, Xendit, GoTo, Tiket.com) → SEA (Grab, Sea, ShopBack) → Global last (Square, Stripe, Shopify) |
| `compliance_signals` | BI license, OJK, ISO 27001, ISPO/RSPO (where relevant), PCI DSS, BI-SNAP — name them on Team / Roadmap slides |
| `relationship_signals` | Named EO partnerships, named mall partnerships, government partners (where applicable) |

See `indonesian-context.md` for full guidance.

---

## 13. Output file structure

When `pitch-deck-gen` completes, it writes the following files into the user's chosen output directory:

```
output-dir/
├── deck.md                  # Full deck spec — one slide per H2 section
├── outline.md               # Slide-by-slide outline + audience-mode emphasis
├── image-prompts.json       # Array: [{slide: 1, prompt: "...", model: "nano-banana-pro", aspect_ratio: "16:9"}, ...]
├── video-prompts.json       # Array of Seedance 2.0 prompts (only for slides flagged motion=true)
├── remotion.config.json     # Optional — only if any slide flagged programmatic_motion=true
├── speaker-notes.md         # All speaker notes in order, ready to paste into Canva/Pitch presenter view
└── validation-report.json   # 100-point gate output (passed: true/false, scores per category, fixes if any)
```

---

## 14. Schema versions

| Artifact | Schema version |
|----------|---------------|
| `deck.md` | v1.0 |
| `image-prompts.json` | v1.0 |
| `video-prompts.json` | v1.0 |
| `remotion.config.json` | v1.0 |
| `validation-report.json` | v1.0 |

Bump on any breaking change. See `scripts/compile-references.sh` (future) for downstream tooling that depends on these schemas.
