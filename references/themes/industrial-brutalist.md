---
slug: industrial-brutalist
name: Industrial Brutalist
mood: [raw, mechanical, declassified, utilitarian]
suitable_for: [portfolio-agency, deck-b2b, catalog-product, brochure-product]
suitable_audience: engineering firms, factory automation vendors, defense/aerospace-adjacent, developer tools, technical infrastructure brands, B2B engineering consultancies
---

## Identity & Mood

Reads like a declassified field manual or a railway timetable. No decoration, no softness, no apology. The interface tells you the data and gets out of the way. Inspired by Bloomberg Terminal, Swiss railway typography, NASA mission reports, and Linear.app's documentation aesthetic. Mood signals: factual, dense, technically rigorous, unconcerned with charm. The theme rewards information density and punishes any element that exists for "vibes" alone.

## Color Palette

| Role | Hex | Notes |
|------|-----|-------|
| Primary | `#000000` | True black — body text, rules, dense type blocks |
| Secondary | `#FFFFFF` | True white — page background, reversed type on black blocks |
| Surface alt | `#F5F5F5` | Off-white — used for alternating table rows or sidebar utility panels |
| Accent (alert red) | `#FF0000` | Used ONLY for warnings, callouts, error states, key data hotspots |
| Accent (warning yellow) | `#FFD700` | Alternate accent for highlight blocks; pick red OR yellow per project, not both |
| Rule grey | `#1A1A1A` | Used for 1pt rules where pure black is too heavy on a black-text page |

Only TWO colors per spread maximum: black + white as foundation, plus one accent (red OR yellow, never both).

## Typography

- **Display:** Helvetica Neue 95 Black or Akkurat Mono 700 Bold — used for headlines and section labels (24-64pt). Alternate display: Inter 800 ExtraBold if Helvetica unlicensed.
- **Body:** JetBrains Mono 400 Regular at 9-10pt with 1.5 line-height — running copy, captions, table cells. Alternate body: Inconsolata Regular.
- **Mono (data):** JetBrains Mono 700 Bold — used for KPI numbers and tabular data. Tabular figures mandatory.

Pairing rule: this theme prefers MONO EVERYWHERE — same family at multiple weights. If a sans is used for display, it must be a grotesk (Helvetica/Akkurat/Inter), never a humanist or geometric sans. No serifs anywhere.

## Illustration / Image Style

Technical drawings, blueprints, exploded isometric line-art, ASCII diagrams, dot-matrix and halftone effects, schematics with measurement annotations. Photography is black-and-white only, high-contrast, often grainy or low-resolution by intent. Microcopy lives in the margins like field-manual annotations. Reference anchor for NB2 prompts: "Engineering blueprint of mechanical assembly, white-on-black line drawing, dimensioned annotations with arrows and tolerance values, no color, no shading, technical isometric projection, blueprint paper texture, microcopy labels in the margins reading like a service manual."

## Layout Grammar

- **Grid:** Strict 12-column grid, 16px gutter, 32px outer margin. Grid lines visibly present on data-dense pages. No off-grid elements.
- **Spacing scale:** 4pt baseline — 4, 8, 12, 16, 24, 32, 48, 64. Tighter than other themes; the theme rewards density.
- **Heading scale (print A4):** H1 36pt, H2 18pt, H3 12pt, body 9pt, caption 7pt — small and dense.
- **Heading scale (screen):** display 64pt, H1 36pt, H2 20pt, body 14pt.
- **Rules:** rules everywhere — 1pt black between every section, 0.5pt grey between rows in tables. Hard 0px border-radius on every container.

## Anti-AI-Slop Banlist for This Theme

1. Gradients of any kind — banned absolutely. Color transitions do not exist in this theme. Solid fills only.
2. Rounded corners — banned absolutely. Every container, button, image frame, and divider uses sharp 0px border-radius.
3. Decorative icons (line-art cute icons, filled rounded-icon sets, emoji as decoration) — banned. Use Unicode geometric symbols (■ □ ▲ ▼ → ↑ ⚠ ⬢) or technical engineering glyphs only.
4. Center-aligned body copy — banned. Everything left-aligns to the grid. Center alignment is reserved for nothing.
5. Soft, friendly photography (laughing teams, golden-hour office) — banned. If photography is used, it is black-and-white, high-contrast, and depicts machinery, infrastructure, or technical detail.

## Real-World Reference

Bloomberg Terminal UI, Linear (linear.app) documentation pages, Vercel docs and changelog, Tropfest poster archive, Swiss Federal Railways (SBB) timetable system, NASA Apollo-era technical reports, the Form+Code book by Pearson/Reas/McWilliams, and Karl Gerstner's print system work for Boîte à Musique.
