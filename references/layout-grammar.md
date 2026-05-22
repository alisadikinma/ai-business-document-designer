---
slug: layout-grammar
purpose: Universal layout principles applicable across all output_types (grids, typography hierarchy, eye flow, whitespace)
applies_to: [all output_types]
research_basis: references/research/design-fundamentals-2026.md
---

# Layout Grammar — Universal Rules

> Operationalizes the Swiss / Vignelli grid tradition for every output_type the plugin produces (decks, brochures, portfolios, catalogs, flyers, leaflets). Cite `references/research/design-fundamentals-2026.md` §2-§6 throughout — this file is the working summary; that file is the authoritative source.

---

## Grid Systems

The grid is the mathematical skeleton beneath every page. Pick the column count by orientation, not by gut feel.

### 12-column grid (default for portrait formats — brochure, portfolio, catalog, flyer)

- 12 columns divide cleanly into 2, 3, 4, 6 — covers every realistic layout decision.
- A4 portrait (210mm × 297mm) — 15mm outer margin, 5mm gutter → column width = `(210 − 30 − 11×5) / 12 = 10.42mm`.
- Use 6-column spans for hero blocks, 4-column for product cards, 3-column for spec strips.

```
A4 PORTRAIT — 12 column · 15mm margin · 5mm gutter
┌──────────────────────────────────────────────────┐
│  ┌──┐┌──┐┌──┐┌──┐┌──┐┌──┐┌──┐┌──┐┌──┐┌──┐┌──┐┌──┐│
│  │ 1││ 2││ 3││ 4││ 5││ 6││ 7││ 8││ 9││10││11││12││
│  │  ││  ││  ││  ││  ││  ││  ││  ││  ││  ││  ││  ││
│  │  ││  ││  ││  ││  ││  ││  ││  ││  ││  ││  ││  ││
│  └──┘└──┘└──┘└──┘└──┘└──┘└──┘└──┘└──┘└──┘└──┘└──┘│
└──────────────────────────────────────────────────┘
  ^15mm                                          ^15mm
```

### 6-column grid (default for landscape — decks, trifold inside panels)

- 16:9 deck (1920×1080) — 60px outer margin, 30px gutter → column width = `(1920 − 120 − 5×30) / 6 = 271.67px`.
- Hero image spans 6 columns (full bleed visual). Headline spans 3-4 columns. Footer strip spans 6 columns at 9pt.

### Baseline grid (vertical rhythm)

Every text line sits on an invisible horizontal baseline. Spacing between baselines = leading. For 11pt body → 14pt leading → 14pt baseline grid. Headings snap to multiples of 14pt (28pt, 42pt, 56pt) so cross-column text aligns.

```
BASELINE GRID — 14pt rhythm
─── BASELINE 1 ───── H1 (sits on baseline 4, ascent 42pt)
─── BASELINE 2 ───
─── BASELINE 3 ───
─── BASELINE 4 ──── H1 cap-line lands here
─── BASELINE 5 ──── body line 1
─── BASELINE 6 ──── body line 2
─── BASELINE 7 ──── body line 3
```

### CSS skeleton

```css
.page {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  gap: 5mm;
  padding: 15mm;
  width: 210mm;
  height: 297mm;
  /* baseline rhythm via line-height multiples of 14pt */
  font-size: 11pt;
  line-height: 14pt;
}
.hero { grid-column: 1 / span 12; }
.feature-card { grid-column: span 4; }
.spec-strip { grid-column: span 3; }
```

> Source: `references/research/design-fundamentals-2026.md` §2 (Layout Excellence: Grid Systems & Vertical Rhythm) — Vignelli Canon + Müller-Brockmann Swiss Style + modular grids accounting for "every fraction of space, including gutters and margins."

### Modular grid (catalog product grids, agency portfolios)

Combines horizontal columns with horizontal row bands. Used when the page hosts many uniform items (catalog SKUs, agency case-study cards). 12-col × 8-row modular grid produces 96 cells; each product card occupies 4 cols × 2 rows.

---

## Typography Hierarchy

H1-H6 form the architecture of the page. Sizes are different for print vs screen because physical leading and reading distance differ.

| Level | Print size (pt) | Screen size (px @ 16:9 deck) | Weight | Tracking |
|---|---|---|---|---|
| H1 — hero / cover | 56-84pt | 96-144px | 700-900 | -2% (tighten at large sizes) |
| H2 — section opener | 32-42pt | 56-72px | 700 | -1% |
| H3 — subsection | 20-24pt | 32-40px | 600 | 0 |
| H4 — card title | 14-16pt | 22-26px | 600 | 0 |
| H5 — label | 11-12pt | 16-18px | 500 SMALL CAPS | +5% |
| H6 — micro-label / caption | 8-9pt | 12-14px | 500 | +8% |
| Body | 10-11pt | 16-18px | 400 | 0 |
| Caption / footnote | 8-9pt | 12-14px | 400 italic | 0 |

### Type pairing rules (3-tier system)

1. **Display family** — used for H1-H2 only. High personality (serif, geometric, grotesque). Examples: *Austin*, *Adelle*, *BWHaasGrotesk-65Medium*.
2. **Body family** — used for H3-Body. Neutral, high legibility. Examples: *Inter*, *Söhne*, *BW Haas Text-55 Roman*.
3. **Mono family** — used for H5 labels, captions, code, numeric data. Examples: *BW Haas Text Mono A-55 Roman*, *JetBrains Mono*.

> Source: `references/research/design-fundamentals-2026.md` §3 — Ina Saltz + Karen Cheng on hierarchy + optical sizing. Grotesque + refined serif pairings.

### Leading & tracking calibration (print vs screen)

- **Print body**: leading = font-size × 1.27 (e.g., 11pt → 14pt leading). Tighter than screen because physical paper has no glow halo.
- **Screen body**: leading = font-size × 1.5 (e.g., 16px → 24px). Looser to compensate for backlight reading fatigue.
- **Print headlines >30pt**: tracking -1% to -2%. Optical compensation per Cheng — large type at default tracking looks gappy.
- **Print H5 labels in caps**: tracking +5% to +8%. All-caps without positive tracking feels cramped.

---

## Visual Flow (Z / F / Gutenberg)

The eye does not scan in random order. Three patterns dominate based on content density.

### Z-pattern (visual-heavy single-page — flyer, brochure cover, deck hero)

```
┌────────────────────────────────┐
│  [LOGO] ─────────► [TAGLINE]   │  ← top horizontal sweep
│           ╲                    │
│            ╲                   │
│             ╲                  │
│              ╲                 │
│   [HERO IMAGE / HEADLINE]      │  ← diagonal anchor
│              ╲                 │
│               ╲                │
│  [SUB-TEXT] ──►  [CTA BUTTON]  │  ← bottom horizontal sweep ending at action
└────────────────────────────────┘
```

Apply when: page has ≤4 anchor elements, primarily visual. Service flyer, brochure cover, deck hook slide, trifold front panel.

### F-pattern (text-heavy multi-page — portfolio case study, catalog spec sheet, B2B brochure interior)

Reader scans top row left-to-right, then drops down the left rail in shorter horizontal sweeps. Critical info MUST live on the left edge — that's where the eye returns repeatedly.

```
████████████████████  ← row 1 (full scan)
████████████░░░░░░░░  ← row 2 (partial)
█████░░░░░░░░░░░░░░░  ← row 3 (left rail only)
██░░░░░░░░░░░░░░░░░░  ← row 4 (drop-off)
████░░░░░░░░░░░░░░░░  ← row 5 (left rail re-engage)
```

Apply when: page has ≥4 paragraphs, sub-heads, or table rows. Catalog spec sheets, portfolio case-study narrative, deck appendix.

### Gutenberg diagram (balanced visual + text)

The page divides into 4 quadrants:
- **Primary Optical Area** (top-left) — eye enters here, must carry the most important visual or headline.
- **Strong Fallow Area** (top-right) — eye glances briefly; good for logo, secondary signal.
- **Weak Fallow Area** (bottom-left) — easily skipped; safe spot for legal fine print.
- **Terminal Area** (bottom-right) — eye lands here last; PERFECT placement for CTA, price, signature.

> Source: `references/research/design-fundamentals-2026.md` §5 — Reading Gravity + Gutenberg Principle + The Pub Test ("front panel communicates lead story in under 3 seconds").

### Mapping output_type → flow pattern

| output_type | Default flow pattern |
|---|---|
| brochure-product cover | Z-pattern |
| brochure-product interior modules | F-pattern |
| portfolio-personal case study | F-pattern |
| catalog-product spec sheet | F-pattern |
| service-flyer | Z-pattern |
| trifold-leaflet front panel | Z-pattern |
| trifold-leaflet inside panels | F-pattern |
| deck-vc / deck-b2b hook slide | Z-pattern |

---

## White Space Discipline

White space is functional, not empty. Two scales matter.

### Macro white space (margins, gutters, page breathing room)

Formula: **page-width / 12 = minimum margin**. For A4 portrait (210mm) → minimum 15mm outer margin. For premium / luxury feel → use 21mm (page-width / 10). For info-dense catalog → can compress to 12mm (page-width / 17.5) but no tighter.

Density calibration:
- **B2B technical** (catalog spec, industrial brochure) — dense, 12-15mm margins, 5mm gutters. Page should feel "earned" with information.
- **B2C aspirational** (premium brochure, lifestyle portfolio) — generous, 21-25mm margins, 8mm gutters. Page should feel "expensive."
- **B2B partnership / VC deck** — balanced, 60-90px margin equivalents on 1920×1080.

> Source: `references/research/design-fundamentals-2026.md` §6 — Macro vs Micro white space. "High density often feels cheap, while generous macro space conveys premium quality."

### Micro white space (kerning, leading, icon padding)

- Headlines >30pt → manual kerning. Default tracking always leaves gaps between AV, To, Wa pairs.
- Icon + label pair → padding between icon and label = 0.5× icon height.
- Card padding → inner padding = card width / 16 minimum (40px on a 640px-wide card).
- Button padding → vertical = font-size × 0.75; horizontal = font-size × 1.5.

---

## Heading Scale Reference

Exact display sizes for the most common page-types in print contexts. These are starting points — adjust ±2pt for brand voice but never break the relative hierarchy.

| Context | H1 (pt) | H2 (pt) | H3 (pt) | Body (pt) |
|---|---|---|---|---|
| Brochure cover hero | 72-84 | — | — | — |
| Brochure modular product (interior) | 28-32 | 18-20 | 14-16 | 10-11 |
| Portfolio case study cover | 56-64 | 24-28 | 16-18 | 10-11 |
| Portfolio case study narrative | 32-40 | 20-24 | 14-16 | 10-11 |
| Deck slide headline (1920×1080) | 56-72 (96-128px) | 32-42 (56-72px) | 20-24 (32-40px) | 14-16 (22-26px) |
| Catalog product name | 14-16 | — | — | 9-10 spec body |
| Catalog category divider | 56-72 | 18-20 | — | 10-11 |
| Service flyer above-the-fold | 64-84 | 24-28 | — | 11-12 |
| Trifold front panel | 48-60 | 18-22 | — | 10-11 |
| Trifold inside panel | 24-28 | 16-18 | 12-14 | 9-10 |

> Source: `references/research/design-fundamentals-2026.md` §3 — typography hierarchy with print sizes calibrated 10-12pt body. Larger sizes scale per the modular scale (1.25× to 1.414× ratios per level).

---

## Grid-Breaking Rules

The grid is a tool, not a religion. Two conditions justify breaking it.

### Intentional grid violation (enhances design)

- **Brutalist-mono theme** (see `references/themes/brutalist-mono.md`) — entire visual identity rests on grid violation. Headlines bleed into margins, type rotates 90°, columns collide. The violation IS the design statement.
- **Hero moment** — once per document, you can let the H1 overflow the column it nominally lives in, breaking into the margin. Cover only. Never on interior pages.
- **Photo bleed** — full-bleed hero photography extends 3mm past the trim line (bleed zone). This is grid-extension, not grid-violation — required by print mechanics.

> Source: `references/research/design-fundamentals-2026.md` §2 — Denise Bosler's "Creative Anarchy" framework. "Intentional rule-breaking for success" — but only AFTER the designer demonstrates mastery of the grid first.

### Grid violation = amateur mistake

- Headlines that wrap awkwardly because they were sized without checking column width.
- Body text columns of irregular width on the same page (3-col + 5-col on facing pages).
- Cards on a card grid where 2 are 4-col-wide and 1 is 5-col-wide for no reason.
- Image captions that float left of their image instead of below/above on the baseline.

Test: if you can articulate WHY a grid violation strengthens the page, it's intentional. If your answer is "it looked good," it's a mistake.
