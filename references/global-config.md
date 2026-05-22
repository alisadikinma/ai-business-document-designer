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

## 3.5. Density mode (humanized-info-dense vs info-dense vs minimalist)

Pitch decks have THREE operational modes. **Default is `humanized-info-dense` for B2B partnership and hybrid (validated v8.1 from Indusia POS × GO!Market deck — see §3.5.1 case study). `minimalist` for VC. Pure `info-dense` only when operator explicitly opts out of humanization (rare).**

| Setting | `minimalist` (VC default) | `humanized-info-dense` (B2B partnership DEFAULT v8.1+) | `info-dense` (legacy / opt-out only) |
|---------|---------------------------|---------------------------------------------------------|--------------------------------------|
| `headline_word_max` | 10 | 12 | 12 |
| `subtext_word_max` | 25 | 40 | 40 |
| `bullets_per_slide_max` | 3 | 6 | 6 |
| `data_table_rows_max` | not allowed | 8 | 8 |
| `math_waterfall_steps_max` | not allowed | 4 | 4 |
| `source_strip_lines_max` | 1 | 3 | 3 |
| `visual_ratio_minimum` | 70% | 70% (face counts as visual) | 70% (per §2.5 visual-language.md) |
| `slide_zones_max` | 3 | 7 (face zone + 6 data zones) | 7 |
| **`face_infographic_split`** | N/A (face-led) | **40% face + 60% infographic per body slide (HARD RULE)** | N/A (pure infographic) |
| Default `slide_1_5_style` | Photo (Editorial / Photorealistic) | **Humanized Hybrid — Approach B (split 40/60) OR Approach C (character-center radial). See `image-prompt-templates.md` §2.5** | Infographic-flat (no humans) |
| `cover_slide_style` | Hero photo + brand mark | **Pattern B face-on-body composite + heritage costume + national flag (where applicable)** | Brand atmosphere + face badge |
| `cta_slide_style` | Hero photo + ask | **Founders + audience-archetype crowd witness + heritage costume** | Logo + ask |

### 3.5.1. Why humanized-info-dense is the new B2B default (case study)

Validated against Indusia POS × GO!Market pitch deck (May 2026). Pure `info-dense` Formula B (no humans) was REJECTED by operator at A/B selection. Humanized variants (with 40% face + 60% infographic) selected for ALL 5 body slides. Cover slide also rejected v1 (synthetic atmosphere only) in favor of v2B (founders in batik wardrobe + Indonesian flag + AI Constellation hub). CTA slide rejected handshake-only in favor of handshake + UMKM crowd witness in matching heritage costume.

**Reason humans win**: Pitch decks need to trigger emotion, not just transfer data. Pure infographic communicates competence; humans communicate "this is for ME". B2B partnership pitches especially — the reader must SEE themselves (or their team / their customers) in the deck before they sign.

### How to choose density mode

1. Audience is VC reading 5-min live pitch? → `minimalist`.
2. Audience is B2B operator / channel partner / ecosystem partner reading async? → `humanized-info-dense` (DEFAULT).
3. Audience is internal technical review / appendix-only? → `info-dense` (legacy, no emotion needed).
4. Audience reads deck before the meeting? → `humanized-info-dense` (operator has time to absorb both human + data).

The banned vocab in §4 below applies to ALL modes. Humanization layer applies to `humanized-info-dense` only — see `image-prompt-templates.md` §2.5 for the 40/60 rule, casting, iconography, and anti-caption-bleed pattern.

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

### Print-mode vocabulary additions (extending §4 for multi-format scope)

The base list above applies to ALL output types (decks AND print collateral). When generating brochure / portfolio / catalog / flyer / leaflet copy, ALSO ban these recurring consultant-deck markers that frequently surface in B2B Indonesian print collateral:

`next-gen` · `cutting-edge` · `best-in-class` · `state-of-the-art` · `industry-leading` · `mission-critical` · `paradigm-shift` · `synergy`

These overlap partially with §4 (Cutting-edge, Best-in-class, Next-generation already listed) but are repeated here as a flat scannable lint target. Print copywriting skill must reject any of these on `copy.json` review before the gen stage runs.

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

---

## 15. Output Types (multi-format)

The plugin handles 9 distinct output types across two families: **decks** (narrative pitch, slide format) and **print collateral** (modular page, A4/A3 format). Each output_type slug maps to one framework file in `references/frameworks/<slug>.md` and routes through the same 5-stage pipeline with stage-specific behavior per type.

| output_type slug | display name | aspect ratio | default page count | mandatory pages | optional pages |
|---|---|---|---|---|---|
| `deck-vc` | VC Pitch Deck | 16:9 | 10-13 | hook, problem, solution, market, traction, business-model, competition, team, ask | why-now, moat, roadmap, appendix-financials |
| `deck-b2b` | B2B Partnership Deck | 16:9 | 10-13 | hook, pain, solution, ROI, integration, traction, team, commercial-terms, deadline | proof-points, case-study, appendix-tech |
| `deck-hybrid` | VC + B2B Hybrid Deck | 16:9 | 10-13 | hook, problem, solution, market, traction, business-model, team, ask | b2b-pilot-track, vc-round-track, appendix |
| `brochure-product` | Product Brochure | A4-portrait | 5-10 | cover, hero-claim, feature-modules, pricing, CTA, back-contact | testimonial, spec-sheet, comparison |
| `portfolio-personal` | Personal Portfolio | A4-portrait | 8-20 | cover, about, case-study (×3-5), skills, contact | testimonial, process-page, awards |
| `portfolio-agency` | Agency Portfolio | A4-portrait | 8-20 | cover, brand-intro, service-grid, case-study (×3-6), team, contact | client-logo-strip, process, awards |
| `catalog-product` | Product Catalog | A4-portrait | 8-24 | cover, category-divider, product-grid, spec-table, order-channel, back-contact | promo-strip, distributor-list, regulatory-strip |
| `service-flyer` | Service Flyer | A4-portrait | 1-2 | hero-claim, 3-benefit, CTA, contact | secondary-detail, pricing-tier |
| `trifold-leaflet` | Trifold Leaflet | A3-landscape-folded | 6 panels | front-panel-cover, inside-panel-1, inside-panel-2, inside-panel-3, back-panel-CTA, mailer-panel | promo-strip |

> Aspect ratio note: `A4-portrait` = 210×297mm, `A3-landscape-folded` = 297×420mm folded twice to 99×210mm (DL envelope size, the Indonesian printer default). See `references/research/pdf-print-production-2026.md §2` for trim/safe/bleed math per format and `references/research/indonesian-print-culture-2026.md §1` for paper stock pairings.

> Page count rationale: deck range follows DocSend median (10-13 active core, see §7 above). Brochure 5-10 = front-cover + 3-8 modular content + back. Portfolio 8-20 accommodates 3-6 case studies at 1-3 pages each. Catalog scales with SKU count. Flyer is 1-2 page above-the-fold. Trifold is structurally fixed at 6 panels.

---

## 16. Theme Registry

7 named themes available. Each theme has its own preset file at `references/themes/<slug>.md` (created in Phase D) declaring color palette (4-6 hex), typography (3-tier), illustration style, layout grammar, and theme-specific anti-AI-slop banlist.

| theme slug | mood | color signature | typography signature | suitable_for |
|---|---|---|---|---|
| `indusia-tech` | technical, premium, B2B-credible | dark navy `#0F1F3D` + cyan + gold accent | sans-serif display + mono labels + isometric 3D illustration | deck-b2b, deck-vc, brochure-product (tech), portfolio-agency |
| `minimalist-editorial` | calm, considered, editorial | cream `#F8F4ED` + ink black | serif display + sans body + heavy whitespace | portfolio-personal, brochure-product (premium), deck-hybrid |
| `industrial-brutalist` | raw, mechanical, declassified | black + white + signal red | mono display + grotesk body + grid-violation layouts | portfolio-agency, deck-b2b (industrial vertical), brochure-product (B2B heavy industry) |
| `premium-luxe` | wealthy, spacious, gallery | gold + ivory + warm black | serif display + thin sans body + generous leading | brochure-product (luxury), portfolio-personal (high-fee), catalog-product (premium goods) |
| `pastel-soft` | friendly, accessible, consumer | soft pastels + rounded forms | rounded sans (Nunito, Quicksand) + friendly body | service-flyer (B2C), brochure-product (F&B, kids, lifestyle), catalog-product (consumer) |
| `brutalist-mono` | type-only, anti-design, intentional | pure black + pure white + one signal | grotesk display in extreme weights + grid-violation | portfolio-personal (designer), portfolio-agency (creative studio) |
| `indo-tropical` | warm, rooted, Indonesian | warm earth tones + batik motif accents | display sans + body serif + batik pattern fill | brochure-product (tourism, F&B Indonesian), portfolio-agency (Indonesian-rooted), catalog-product (kerajinan, kuliner) |

See `references/research/design-fundamentals-2026.md §4` for color psychology guidance per audience archetype, `§3` for typography pairing logic, and `references/research/indonesian-print-culture-2026.md §5` for `indo-tropical` cultural-signal mapping.

> Operator override: brand palette declared in `brief.json.brand_palette` always overrides theme palette. Theme provides skeleton (typography, illustration style, layout grammar); brand palette overrides color. See §3.6 above.

---

## 17. PDF Output Modes

The gen stage emits one of three output modes per `brief.json.output_mode`. Each mode has different downstream tooling, time-to-render, and operator-edit-ability after generation.

| mode slug | description | render path | best for | trade-offs |
|---|---|---|---|---|
| `html-css` | HTML + print CSS rendered to PDF via headless Chromium | Playwright `page.pdf({ printBackground: true, format: 'A4', margin: { ... } })` | Multi-page text-heavy collateral, when operator wants version-control friendly source + ability to re-edit later | Requires Node.js + Playwright install. CMYK fidelity depends on `-webkit-print-color-adjust`; for true CMYK use mode `full-image` or post-process via Ghostscript. See `references/research/pdf-print-production-2026.md §9`. |
| `full-image` | One NB2-generated image per page at 1240×1754px @ 300dpi (A4 portrait), Pillow / img2pdf merge to single PDF | Python: NB2 per-page batch → Pillow → img2pdf → output.pdf | Photo-heavy formats (brochure-product, portfolio-personal, catalog-product), when visual ratio must be ≥85% per page and HTML+CSS would feel template-y | Each page is a flat image — no live text, no a11y, no post-edit without re-render. Larger file size (~20-80MB for 8 pages). |
| `spec-only` | JSON layout spec + image prompt array — no PDF rendered; operator assembles manually in Canva / Figma / InDesign | Output `spec.json` + `image-prompts.json` only | When the operator wants final assembly control, or when print shop requires native InDesign source for offset printing | No PDF artifact. Operator must execute the spec by hand or via Canva/Figma API. Longer total turnaround. |

> Default mode per output_type (when operator does not specify):
> - decks (deck-vc, deck-b2b, deck-hybrid) → `html-css` (legacy default, current `pitch-deck-gen` behavior)
> - brochure-product, catalog-product → `full-image` (photo-heavy)
> - portfolio-personal, portfolio-agency → `full-image` (visual-led)
> - service-flyer, trifold-leaflet → `html-css` (text+layout dense)
> - any output_type with `print_shop_offset: true` in brief → `spec-only` (let the shop assemble in InDesign)
