---
name: ai-business-document-gen
description: Stage 4 of the ai-business-document-designer 5-stage pipeline — visual production. Produces per-page visual spec (NB2 image prompts, optional Seedance video, optional Remotion configs) AND mode-aware render: HTML+CSS via Playwright headless Chromium PDF, full-image NB2 at 1240×1754 @ 300dpi merged via Pillow, or spec-only JSON for Canva/Figma/InDesign manual assembly. Output_type-aware aspect ratio (16:9 deck vs A4 portrait page vs A3 trifold); theme preset loaded from references/themes/ governs typography + illustration style; brand_palette hex codes injected verbatim into every prompt; print modes enforce CMYK + 3mm bleed + 300dpi + font embedding per pdf-print-production-2026.md. Triggers on gen, visual-production, image-prompt, NB2, nano-banana-pro, Gemini, PDF-render, Playwright, HTML-CSS, pitch-deck-gen, generate brochure, generate portfolio, generate catalog. REFUSES to run without approved copy.json (Stage 3).
triggers: [gen, visual-production, image-prompt, NB2, nano-banana-pro, Gemini, PDF-render, Playwright, HTML-CSS, pitch-deck-gen, generate brochure, generate portfolio, generate catalog]
---

# ai-business-document-gen — Stage 4: Visual Production

Stage 4 of 5. Reads `copy.json` (Stage 3, approved), `narrative.json` (Stage 2, approved), and `brief.json` (Stage 1). For each page or slide, produces the per-page visual production spec — NB2 image prompts, optional Seedance 2.0 video prompts, optional Remotion configs, speaker notes (deck modes only). Then renders the final artifact via one of three output modes: `html-css` (Playwright headless Chromium PDF), `full-image` (NB2-per-page + Pillow merge), or `spec-only` (layout JSON for Canva / Figma / InDesign assembly).

> **Where this fits**: `ai-business-document-brief` → `ai-business-document-narrative` → `ai-business-document-copywriting` → **`ai-business-document-gen`** → `ai-business-document-validate`. See plugin `CLAUDE.md` for the full pipeline.

> **Extends** legacy `pitch-deck-gen` with multi-output-mode routing + theme/aspect_ratio awareness. Decks continue to default to `html-css` mode; print collateral defaults to `full-image` or `spec-only` per output_type matrix.

---

## Announce at Start

Print exactly this line at the start of every invocation so the operator knows which skill is active:

> "I'm using the ai-business-document-gen skill to produce visuals."

---

## Inputs

This skill accepts three approved JSON artifacts from the upstream pipeline plus optional CLI overrides.

| Input | Source | Required | Notes |
|---|---|---|---|
| `--copy <path>` | Stage 3 output (`copy.json`) | Yes | Must have `approved_at != null` AND `approved_by` set. Refuses if either is null. |
| `--narrative <path>` | Stage 2 output (`narrative.json`) | Yes | Provides `page_role[]` and `motion`/`programmatic_motion` flags per page. |
| `--brief <path>` | Stage 1 output (`brief.json`) | Yes | Provides `output_type`, `theme`, `density_mode`, `brand_palette`, `language_default`, `founders[]`, `partner_logos[]`. |
| `--output-mode <html-css\|full-image\|spec-only>` | CLI override | Optional | If omitted, auto-detect from `brief.json.output_mode`. If brief omits it, fall back to per-output_type default (see §17 in `references/global-config.md`). |
| `--output-dir <path>` | CLI override | Optional | Defaults to same directory as `brief.json`. |
| `--anchor-only` | CLI flag | Optional | Generate ONLY the style-anchor page (page 1 minimalist / page 0 info-dense). Used by the Stage 4 style-anchor approval gate. |

Auto-detect rule (when `--output-mode` not given):
1. Read `brief.json.output_mode` — if set, use it.
2. Else lookup `brief.json.output_type` against the default-mode table in `references/global-config.md §17`.
3. Else fall back to `html-css` (the legacy deck default).

---

## Outputs

Output file set varies by mode. ALL modes emit `image-prompts.json` + `video-prompts.json` + `remotion.config.json` + `speaker-notes.md` (when relevant) regardless of render path. The render-specific artifacts differ:

### HTML+CSS mode (`output-mode: html-css`)
- `output/<doc-slug>.html` — full document HTML (multi-page via `<section>` + `page-break-before`)
- `output/<doc-slug>.css` — print CSS (`@page`, bleed, theme palette + typography injected)
- `output/<doc-slug>.pdf` — final rendered PDF via Playwright `page.pdf({ format, printBackground, preferCSSPageSize })`
- `output/render.mjs` — the Playwright Node.js render script (re-runnable)
- `image-prompts.json` — NB2 prompts for embedded `<img>` slots (operator renders separately, drops into `output/img-N.png`)
- `video-prompts.json` — Seedance prompts when `narrative.pages[i].motion = true`; `[]` otherwise
- `remotion.config.json` — when `narrative.pages[i].programmatic_motion = true`; `{ "compositions": [] }` otherwise
- `speaker-notes.md` — deck modes only; print collateral skips this file

### Full-image NB2 mode (`output-mode: full-image`)
- `image-prompts.json` — **one** NB2 prompt per page at the document's native resolution (A4 portrait = 1240×1754 px @ 300 dpi; A3-landscape-folded = 2480×1754 px @ 300 dpi; 16:9 slide = 1920×1080 px @ 300 dpi for print, 2560×1440 for screen)
- `output/merge.py` — Pillow + img2pdf helper script (reads `output/img-*.png` after NB2 renders, merges into `output/<doc-slug>.pdf` with correct page size + 3mm bleed handling)
- `output/<doc-slug>.pdf` — produced after operator runs NB2 render externally then executes `python output/merge.py`
- `video-prompts.json` — same rules as HTML mode
- `remotion.config.json` — same rules as HTML mode

### Spec-only JSON mode (`output-mode: spec-only`)
- `output/<doc-slug>.spec.json` — full per-page layout spec (page size, margins, grid, content blocks, colors, fonts, image-slot references); structure is import-ready for Canva Marketplace API and Figma plugin importers
- `image-prompts.json` — NB2 prompts for each image_block (operator renders separately, places renders in Canva/Figma/InDesign by hand)
- `output/canva-import.md` — operator instructions (one-page) for importing spec into Canva
- `output/figma-import.md` — operator instructions for importing into Figma via the `figma-plugin-json-importer`
- NO PDF artifact (mode contract: operator owns final assembly)

---

## Pre-checks (mandatory reads)

Read these references in order EVERY invocation. Do not skip even when running in the same session as Stage 3 — the gen stage's reference set is the largest in the pipeline.

### Always read (every output_type, every mode)

| Reference | Why |
|---|---|
| `copy.json` | Per-page approved text content. Must verify `approved_at != null`. |
| `narrative.json` | Per-page `page_role`, `motion`, `programmatic_motion` flags. |
| `brief.json` | `output_type`, `theme`, `density_mode`, `brand_palette`, `language_default`, `founders[]`, `partner_logos[]`. |
| `references/global-config.md` | §3.5 density mode, §3.6 brand palette injection, §4 banned vocabulary, §5 banned visuals, §15 output types, §16 themes, §17 output modes. |
| `references/visual-language.md` | §2 visual-ratio method, §2.5 structured-data exception, §13 banned visual library, §15 anti-AI-slop banlist. |
| `references/themes/<theme>.md` | Theme color palette + 3-tier typography + illustration style + layout grammar + theme-specific anti-slop banlist. `theme` slug comes from `brief.json.theme`. |

### Conditional reads (per output_type, per mode)

| Condition | Read |
|---|---|
| Any page with face / logo / product-photo composite | `references/image-prompt-templates.md` (always) + `references/safety-filter-playbook.md` (face/minor risk mitigation) |
| Any deck output (`deck-vc`, `deck-b2b`, `deck-hybrid`) | `references/image-prompt-templates.md` §4 per-slide formulas |
| Mode = `html-css` | `references/html-css-print-templates.md` (primary) + `references/research/pdf-print-production-2026.md` §2 (bleed), §9 (CSS for Paged Media) |
| Mode = `full-image` AND output_type in print family | `references/research/pdf-print-production-2026.md` §1 (CMYK), §2 (bleed), §3 (300dpi), §10 (font embedding rendered-into-image) |
| Any page with `motion = true` in narrative | `references/seedance-prompt-templates.md` |
| Any page with `programmatic_motion = true` | `references/remotion-config-templates.md` |
| `brief.json.language_default = "id"` | `references/indonesian-context.md` |
| `brief.json.audience_mode = "b2b"` | `references/b2b-channel-partner-playbook.md` |
| Output_type = `trifold-leaflet` OR `service-flyer` | `references/research/indonesian-print-culture-2026.md` §3 (folding tolerances, paper-stock pairing) |

---

## Pipeline: Per-Page Visual Spec (universal, 7-step)

This pipeline runs for every page regardless of output mode. Mode-specific render steps run AFTER this pipeline completes for all pages.

### Step 1 — Load page context

For each page index `i` in `copy.json.pages[]`:

1. Read `narrative.json.pages[i].page_role` (e.g. `cover`, `hook`, `feature-module-1`, `case-study-2-page-1`, `back-contact`).
2. Read `narrative.json.pages[i].motion` and `narrative.json.pages[i].programmatic_motion` flags.
3. Read `copy.json.pages[i].headline`, `subtext`, `body_blocks`, `proof_strip`, `cta` (all density-mode-validated by Stage 3).
4. Read `brief.json.output_type` to look up aspect_ratio and base resolution from the §15 matrix.

### Step 2 — Load theme palette and typography

Read `references/themes/<theme>.md` (where `<theme>` = `brief.json.theme`). Extract:
- Color palette (4-6 hex codes)
- 3-tier typography (display / body / mono or label)
- Illustration style anchor (e.g. `isometric 3D` for `indusia-tech`, `editorial serif` for `minimalist-editorial`)
- Layout grammar (grid columns, whitespace ratio)
- Theme-specific anti-slop banlist (additions to global §5)

**Override rule** (per `global-config.md §3.6`): if `brief.json.brand_palette` is set, it overrides the theme palette. Theme still provides typography + illustration style + layout grammar. Brand palette injection is non-negotiable.

### Step 3 — Author NB2 image prompt (40-100 words)

Build the prompt per the formulas in `references/image-prompt-templates.md`:
- Density-mode-aware formula selection (Formula A photo, B infographic-flat, C grid-isometric, D product-UI, per density + page_role)
- Inject theme `style_anchor` from Step 2 verbatim into the prompt
- Inject `brand_palette` hex codes verbatim — NEVER use vague color terms like "warm orange" or "deep navy"; ALWAYS use `#FF8C42`, `#0F1F3D` etc. (per `global-config.md §3.6` hard rule)
- Inject aspect_ratio per output_type (16:9 for decks; A4-portrait → 5:7 ratio framing for `full-image` mode; A3 panel composition for `trifold-leaflet`)
- 40-100 words target length (per `image-prompt-templates.md §3`)
- Run the 5-question anti-AI-slop pre-flight check before adding to `image-prompts.json`

### Step 4 — Brand palette hex injection verification

Lint the assembled prompt for vague color terms. If ANY of these substrings appear without a hex code: `"blue"`, `"red"`, `"orange"`, `"green"`, `"navy"`, `"cream"`, `"gold"`, `"ivory"`, `"black"`, `"white"`, `"pastel"` — replace with the exact hex from `brief.json.brand_palette` (with the role name in parentheses for traceability, e.g. `"#0F1F3D (brand primary)"`).

This step is a hard gate. A prompt that ships with "warm orange" instead of "#FF8C42" fails Stage 5 validation automatically.

### Step 5 — Safety-filter check

If the prompt references face files (`founders[]`), logo files (`partner_logos[]`), or any composite involving recognizable people:

1. Apply Pattern A (badge-only) or Pattern B (face-on-body) per `references/image-prompt-templates.md §4.5`. Pattern A is default; Pattern B reserved for closing CTA.
2. Inject mandatory safety phrases per `references/safety-filter-playbook.md §6`:
   - `"NO recognizable people, NO minors"`
   - `"<8% sharpness, abstract bokeh"` (for backgrounds with extras)
   - Explicit age-lock descriptors (`"adult, late 30s/40s"`) — NEVER `"young"`, `"youthful"`, `"fresh-faced"` (those trigger MINOR_UPLOAD)
3. Populate `fallback_strategy` in the prompt entry with the per-error ladder (MINOR_UPLOAD → drop face files, composite in Canva; FILTERED → reduce composite count; etc.).
4. For team pages: NEVER auto-generate faces. Set `manual_asset_required: true` and emit text-only theme on team page; operator drops real photos in post.

### Step 6 — Optional Seedance video prompt (when motion adds value)

If `narrative.json.pages[i].motion = true`:

1. Apply Seedance 2.0 4-block formula per `references/seedance-prompt-templates.md §2`.
2. Bind first frame to the NB2 prompt's expected output via `@Image1` reference.
3. Verify loop seamlessness (Block 4 must specify "last frame matches first frame").
4. Run the "is this video earning its weight?" gate per `seedance-prompt-templates.md §10`. If gate fails: drop video, mark static-only in `video-prompts.json` with a `dropped_reason` field.

### Step 7 — Optional Remotion config (when programmatic motion needed)

If `narrative.json.pages[i].programmatic_motion = true`:

1. Pick template type per `references/remotion-config-templates.md` (counter / chart / pin-map / live-ticker).
2. Fill props from `copy.json.pages[i]` data and `brief.json.traction` values.
3. Set `skip_if_unavailable: true` so the deck publishes even if the operator has no Remotion infrastructure.

### Style-anchor approval gate (runs BEFORE Step 1 propagates to all pages)

The style-anchor page (page 0 in info-dense / page 1 in minimalist) governs every subsequent page via `ref_history`. A bad anchor poisons the entire document.

1. Run Steps 1-5 for ONLY the anchor page first (use `--anchor-only` flag).
2. Render preview (operator's responsibility — surface the NB2 result URL).
3. Wait for explicit operator choice: `approve` / `reroll` / `manual_anchor`.
4. On `approve` → propagate the anchor's UUID into `ref_history` for all subsequent pages, then run Steps 1-7 for remaining pages.
5. On `reroll` → regenerate the anchor (operator may amend the prompt). Repeat gate.
6. On `manual_anchor` → operator provides their own anchor image; plugin uses that UUID for `ref_history`.

---

## Pipeline: HTML+CSS Mode (when output-mode=html-css)

Runs AFTER the universal per-page pipeline completes. 8 steps.

### Step A — Load HTML+CSS print template

Read `references/html-css-print-templates.md` and select the appropriate `@page` preset per `brief.json.output_type`:
- `deck-*` → 16:9 landscape (use the `@page.landscape` preset; size: 297mm 210mm; margin: 12mm; bleed: 3mm)
- `brochure-product`, `portfolio-*`, `catalog-product` → A4-portrait (210mm 297mm; margin: 15mm; bleed: 3mm)
- `service-flyer` → A4-portrait OR letter per `brief.json.region` (Indonesia/EU = A4; US = letter)
- `trifold-leaflet` → A3-landscape-folded (297mm × 420mm, fold-line CSS rules per §3)

### Step B — Generate HTML structure (per page)

Per page, emit a `<section>` element with:
- `class` reflecting page_role + theme (e.g. `<section class="page cover full-bleed theme-indusia-tech">`)
- `style="page-break-before: always"` on all sections except the first
- Headline + subtext + body_blocks from `copy.json.pages[i]` placed in grid containers matching the theme's layout grammar
- `<img src="output/img-N.png" alt="...">` placeholders for NB2-rendered images (operator drops actual renders here after NB2 batch completes)
- Source lines for every numeric claim (per `global-config.md §6`)

### Step C — Generate CSS (theme palette + typography injection)

Emit `output/<doc-slug>.css` containing:
- `@page` rules per Step A
- Bleed CSS for `.full-bleed` containers (per `html-css-print-templates.md` §2)
- CSS custom properties for brand palette (`--brand-primary: #0F1F3D;` etc.) — injected verbatim from `brief.json.brand_palette`
- Typography rules per theme's 3-tier (display / body / mono)
- Grid utilities matching the theme's layout grammar (12-col for `indusia-tech`, asymmetric editorial for `minimalist-editorial`, broken grid for `industrial-brutalist`)

### Step D — Font embedding (`@font-face` + subset load)

Per `html-css-print-templates.md §4`:
- Self-host fonts in `output/fonts/` (preferred over Google Fonts CDN for offset-print fidelity)
- Emit `@font-face` rules with `font-display: block` (NOT `swap` — swap causes flash-of-fallback during PDF render)
- If using CDN: preload via `<link rel="preload" as="font" crossorigin>` in `<head>` AND add `await page.evaluate(() => document.fonts.ready)` before `page.pdf()` in the render script

### Step E — Image slot wiring

For each NB2 prompt in `image-prompts.json`:
- Reserve an `<img>` slot in the HTML with `src="output/img-<page>-<slot>.png"` (relative path)
- Set explicit `width`/`height` attributes matching the prompt's target resolution (prevents reflow during PDF render)
- Add `loading="eager"` (NOT `lazy` — lazy-load images may not appear in PDF render)

The operator renders NB2 prompts externally (GeminiGen.AI nano-banana-pro batch), saves PNGs to `output/img-*.png`, then runs the Playwright script.

### Step F — Playwright render script (`output/render.mjs`)

Emit a Node.js script using the canonical pattern from `html-css-print-templates.md §6`:

```js
import { chromium } from 'playwright';
const browser = await chromium.launch();
const page = await browser.newPage();
await page.goto(`file://${process.cwd()}/output/<doc-slug>.html`, { waitUntil: 'networkidle' });
await page.evaluate(() => document.fonts.ready);
await page.emulateMedia({ media: 'print' });
await page.pdf({
  path: 'output/<doc-slug>.pdf',
  format: 'A4',                       // override per output_type
  printBackground: true,
  preferCSSPageSize: true,
  margin: { top: '15mm', bottom: '15mm', left: '15mm', right: '15mm' },
});
await browser.close();
```

Notes:
- `preferCSSPageSize: true` lets `@page` from the CSS govern dimensions (per `html-css-print-templates.md §6`).
- `printBackground: true` is mandatory — without it, theme color blocks and `full-bleed` backgrounds drop out.
- For decks: `format: undefined` and let `@page.landscape` rule govern.

### Step G — Optional Ghostscript CMYK post-process

If `brief.json.print_shop_offset = true` OR output is destined for offset printing in Indonesia (Surabaya / Jakarta percetakan):
- Emit `output/cmyk-convert.sh` with the Ghostscript command from `html-css-print-templates.md §5`:
  `gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sColorConversionStrategy=CMYK -sProcessColorModel=DeviceCMYK -sOutputFile=output/<doc-slug>_cmyk.pdf output/<doc-slug>.pdf`
- Operator runs this AFTER Playwright PDF render. Emit instruction in `output/print-shop-handoff.md`.

### Step H — Emit all artifacts

Write to `{output_dir}/`:
- `output/<doc-slug>.html`
- `output/<doc-slug>.css`
- `output/<doc-slug>.pdf` (will exist after operator runs `render.mjs`)
- `output/render.mjs`
- `output/cmyk-convert.sh` (when print_shop_offset)
- `image-prompts.json`
- `video-prompts.json` (`[]` if no motion)
- `remotion.config.json` (`{ compositions: [] }` if no programmatic motion)
- `speaker-notes.md` (deck modes only)

---

## Pipeline: Full-Image NB2 Mode (when output-mode=full-image)

Runs AFTER the universal per-page pipeline. 5 steps.

### Step A — Per-page single NB2 prompt covering entire page layout

For each page, author ONE NB2 prompt that renders the entire page as a single flat image (text-as-image, not separate HTML layer):
- Target resolution by output_type:
  - A4-portrait → `1240×1754 px @ 300dpi` (210mm × 297mm at print density)
  - A3-landscape-folded → `2480×1754 px @ 300dpi` (297mm × 420mm)
  - 16:9 slide for print → `1920×1080 px @ 300dpi`
- Include ALL `copy.json.pages[i]` content rendered as part of the image (headline + subtext + body + CTA all baked in as typography)
- Specify exact typography from `references/themes/<theme>.md` 3-tier (display font, body font, mono font)
- Specify exact hex codes from `brief.json.brand_palette` per Step 4 of universal pipeline
- 3mm bleed handling — describe the bleed area as "trim-safe background extends 3mm beyond final image edge" so the print shop has bleed to crop
- Aspect ratio descriptor matches the page format ("A4 portrait 5:7 ratio composition")

### Step B — Include all copy content (text-as-image)

Each prompt explicitly describes the typography hierarchy AS PART OF the image content. Example pattern:
- `"Headline '<exact copy>' rendered in <theme.display_font> 64pt #0F1F3D positioned top-left at 15mm margin from edge."`
- `"Body block 1 '<exact copy>' rendered in <theme.body_font> 14pt #1A2540 positioned in left column at 15mm margin, line-height 1.6."`
- `"Source line '<exact copy>' rendered in <theme.mono_font> 9pt #5C6473 positioned bottom-left."`

This is the trade-off: full-image mode produces visually consistent print collateral but text is not live (no a11y, no later edits).

### Step C — Emit `image-prompts.json` with batch jobs

Schema: same Schema 2.0 as deck mode, plus a `full_image_render: true` flag at root + per-prompt `target_resolution` and `bleed_mm: 3` fields.

The operator runs NB2 batch externally (GeminiGen.AI nano-banana-pro), saves PNGs as `output/img-<page>.png` (one per page).

### Step D — Emit `output/merge.py` (Pillow + img2pdf helper)

Generate a Python script that:
1. Loads `output/img-*.png` in page order
2. Verifies each image matches the expected `target_resolution` (logs warning if NB2 returned different dims)
3. Uses `img2pdf.convert()` with explicit `pagesize` argument matching the page format (A4 = `(2480, 3508)` at 300dpi, but the trim is `(1240, 1754)` after bleed crop)
4. Writes `output/<doc-slug>.pdf`

Pattern (operator runs `python output/merge.py` after NB2 batch completes):

```python
from PIL import Image
import img2pdf
from pathlib import Path

pages = sorted(Path('output').glob('img-*.png'))
page_size_mm = (210, 297)   # A4 portrait — override per output_type
layout = img2pdf.get_layout_fun(
    img2pdf.in_to_pt(page_size_mm[0] / 25.4),
    img2pdf.in_to_pt(page_size_mm[1] / 25.4),
)
with open('output/<doc-slug>.pdf', 'wb') as f:
    f.write(img2pdf.convert([str(p) for p in pages], layout_fun=layout))
```

### Step E — Pillow merge with bleed handling

The merge script crops each input image to trim (removes 3mm bleed on all sides if NB2 rendered the bleed area) OR retains bleed if `brief.json.print_shop_offset = true` (the print shop needs the bleed to crop themselves).

Emit `output/print-shop-handoff.md` with instructions:
- If digital-only PDF: bleed is cropped, file is `output/<doc-slug>.pdf`
- If offset print: bleed retained, file is `output/<doc-slug>_with_bleed.pdf` + send `output/crop-marks.pdf` alongside

---

## Pipeline: Spec-Only JSON Mode (when output-mode=spec-only)

Runs AFTER the universal per-page pipeline. 4 steps.

### Step A — Per-page layout spec emission

For each page, emit a layout spec object with:

```json
{
  "page_index": 1,
  "page_role": "cover",
  "page_size_mm": [210, 297],
  "margins_mm": { "top": 15, "bottom": 15, "left": 15, "right": 15 },
  "bleed_mm": 3,
  "grid": { "columns": 12, "gutter_mm": 5 },
  "content_blocks": [
    {
      "type": "headline",
      "position_mm": { "x": 15, "y": 30 },
      "size_mm": { "w": 180, "h": 40 },
      "content": "<exact headline copy>",
      "style": {
        "font_family": "Plus Jakarta Sans Bold",
        "font_size_pt": 64,
        "color": "#0F1F3D",
        "line_height": 1.1
      }
    },
    {
      "type": "image",
      "position_mm": { "x": 15, "y": 80 },
      "size_mm": { "w": 180, "h": 180 },
      "image_prompt_ref": "image-prompts.json#prompts[0]",
      "placeholder": "Operator renders NB2 prompt, places PNG here"
    },
    {
      "type": "source_line",
      "position_mm": { "x": 15, "y": 282 },
      "content": "Source: internal data, April 2026",
      "style": { "font_family": "JetBrains Mono", "font_size_pt": 9, "color": "#5C6473" }
    }
  ]
}
```

### Step B — Top-level color_palette + font_stack reference

The root of `spec.json` includes the full brand palette + font stack so Canva/Figma importers can register them as the document's design tokens upfront:

```json
{
  "schema_version": "1.0",
  "doc_id": "...",
  "output_type": "brochure-product",
  "theme": "indusia-tech",
  "brand_palette": { /* all hex codes from brief.json */ },
  "typography": {
    "display": "Plus Jakarta Sans Bold",
    "body": "Inter",
    "mono": "JetBrains Mono"
  },
  "pages": [ /* per-page layout specs */ ]
}
```

### Step C — NB2 prompts for image_blocks

For each `content_blocks[].type = "image"`, emit a corresponding entry in `image-prompts.json` with `image_block_ref` back-pointing to the spec block. Operator runs NB2 separately (via GeminiGen.AI) and places renders in Canva/Figma by hand.

### Step D — Import-ready structure

The spec is structured to be importable by:
- **Canva Marketplace API** — `content_blocks[]` map to Canva text/image elements; `page_size_mm` maps to Canva custom-size; brand palette imports as Canva brand kit colors. Emit `output/canva-import.md` with operator step-by-step (Canva → File → Import → JSON; or use the Canva Connect API for programmatic import).
- **Figma plugin importer** — `figma-plugin-json-importer` (open-source) accepts this schema; emit `output/figma-import.md` with operator instructions (Figma → Plugins → Run JSON Importer → select `spec.json`).
- **InDesign** — operator opens InDesign, runs Tagged Text or IDML import (manual; no fully-automated path); emit `output/indesign-handoff.md` with positions table for paste-and-position workflow.

---

## Hard Rules

These rules apply to every gen run regardless of output mode. Violation = immediate correction before output.

1. **Visual ratio ≥ 70% per page** (validator gate enforced at Stage 5). Use `visual-language.md §2` method. In info-dense mode, structured-data blocks per `§2.5` count as visual. Hard-fail at < 60%.
2. **Brand palette hex injection verbatim into ALL NB2 prompts.** No vague color terms — never `"blue"`, always `"#1E3A8A"`. Same rule for HTML+CSS mode (CSS custom properties must be hex) and spec-only mode (style.color must be hex). Per `global-config.md §3.6`.
3. **Safety-filter applied for all face/logo composites.** Pattern A or B from `image-prompt-templates.md §4.5` + safety-filter-playbook.md §6 mitigation phrases + age-locked descriptors + populated `fallback_strategy`. Team page NEVER auto-generates faces — `manual_asset_required: true` instead.
4. **Print modes (html-css OR full-image with print_shop_offset=true) enforce CMYK + 3mm bleed + 300dpi + font embedding.** Per `references/research/pdf-print-production-2026.md §1, §2, §3, §10`. Validator at Stage 5 hard-fails if any of these four are missing.
5. **Anti-AI-slop banlist applied to all NB2 prompts** per `visual-language.md §15` and the theme-specific banlist from `references/themes/<theme>.md`. Banned: purple-blue gradient, stock handshake, generic isometric, neon multi-stop, pure-black background, etc. 5-question pre-flight check on every prompt.
6. **Per-page asset reuse via `ref_history`** per `image-prompt-templates.md` brand-anchor pattern. Style-anchor page is approved by operator first; only then does `ref_history` propagate to subsequent pages. Surface preview gate is non-skippable.
7. **Mode-specific format verification** before emit:
   - HTML mode: render the Playwright PDF, open it, verify page count matches `copy.json.pages.length` and page size matches output_type (A4 = 210×297mm; deck = 297×210mm landscape) and bleed marks present (when print_shop_offset).
   - Full-image mode: verify `image-prompts.json` has exactly one entry per page AND each prompt's `target_resolution` matches the output_type's print resolution. Verify `merge.py` produces a PDF with the correct page count.
   - Spec mode: verify `spec.json` validates against the spec schema; verify Canva/Figma importer dry-run succeeds (smoke test loads spec into the importer without errors).
8. **Banned vocabulary scan** per `global-config.md §4` applied to ALL text inside NB2 prompts (not just on-page copy — prompt text matters because some image models will render the prompt as visible text if it ends up in a chart label). No `"leverage"`, `"synergies"`, `"paradigm shift"`, `"game-changing"`, `"next-generation"`, `"world-class"`, `"cutting-edge"`, `"seamless"`, `"robust"`, `"holistic"`, `"transform"`, `"unlock"`, `"empower"`, `"supercharge"`. Indonesian banlist: no `"solusi terbaik"`, `"inovatif"`, `"terdepan"`, `"terbaik di kelasnya"`, `"revolusioner"`, `"mengubah cara"`, `"mendisrupsi"`.
9. **Every numeric claim has a source line** per `global-config.md §6`. Applies to all on-page text from `copy.json` (Stage 3 should already enforce this; gen re-checks because some numbers appear in visual elements like chart labels that come from gen-stage prompt authoring).
10. **NEVER deviate from `copy.json` text content.** The gen stage adds visual production spec; it does NOT rewrite the copy. If copy is broken, route back to Stage 3.

---

## Reference Loading Cheat Sheet (per output_type × output_mode)

Use this table to know which references load for each combination. `+` = additional to the always-read base set. Always-read base = `copy.json`, `narrative.json`, `brief.json`, `global-config.md`, `visual-language.md`, `references/themes/<theme>.md`.

| output_type | html-css mode | full-image mode | spec-only mode |
|---|---|---|---|
| `deck-vc` | +image-prompt-templates.md §4, +html-css-print-templates.md §1 (landscape), +safety-filter-playbook.md (cover/CTA), +seedance-templates (motion slides), +remotion-templates (counters/charts) | +image-prompt-templates.md §4 (per-slide), +safety-filter-playbook.md, +pdf-print-production-2026.md §3 (300dpi for print export), +seedance-templates (motion) | +image-prompt-templates.md §4, +safety-filter-playbook.md (cover/CTA prompts only) |
| `deck-b2b` | +image-prompt-templates.md §4, +html-css-print-templates.md §1, +b2b-channel-partner-playbook.md (dual-stakeholder framing), +safety-filter-playbook.md, +seedance-templates | +image-prompt-templates.md §4, +b2b-channel-partner-playbook.md, +safety-filter-playbook.md, +pdf-print-production-2026.md §3 | +image-prompt-templates.md §4, +b2b-channel-partner-playbook.md, +safety-filter-playbook.md |
| `deck-hybrid` | +image-prompt-templates.md §4, +html-css-print-templates.md §1, +b2b-channel-partner-playbook.md, +safety-filter-playbook.md, +seedance-templates, +remotion-templates | +image-prompt-templates.md §4, +b2b-channel-partner-playbook.md, +safety-filter-playbook.md, +pdf-print-production-2026.md §3 | +image-prompt-templates.md §4, +b2b-channel-partner-playbook.md, +safety-filter-playbook.md |
| `brochure-product` | +image-prompt-templates.md (product photo + module grid), +html-css-print-templates.md (A4-portrait + bleed), +pdf-print-production-2026.md §1+§2+§9 (CMYK, bleed, paged CSS), +safety-filter-playbook.md (if product shot includes hands/people) | +image-prompt-templates.md, +pdf-print-production-2026.md §1+§2+§3+§10 (full print stack), +indonesian-print-culture-2026.md §2 (paper stock pairing), +safety-filter-playbook.md | +image-prompt-templates.md, +safety-filter-playbook.md, +indonesian-print-culture-2026.md §2 |
| `portfolio-personal` | +image-prompt-templates.md (case study + headshot), +html-css-print-templates.md (A4-portrait), +pdf-print-production-2026.md §1+§2, +safety-filter-playbook.md (cover/about + case-study people shots) | +image-prompt-templates.md, +pdf-print-production-2026.md (full print stack), +safety-filter-playbook.md (face-heavy), +indonesian-print-culture-2026.md §2 | +image-prompt-templates.md, +safety-filter-playbook.md |
| `portfolio-agency` | +image-prompt-templates.md (service grid + case study + team), +html-css-print-templates.md (A4-portrait), +pdf-print-production-2026.md §1+§2, +safety-filter-playbook.md (team page), +b2b-channel-partner-playbook.md (client framing) | +image-prompt-templates.md, +pdf-print-production-2026.md (full print stack), +safety-filter-playbook.md (team page critical), +b2b-channel-partner-playbook.md, +indonesian-print-culture-2026.md §2 | +image-prompt-templates.md, +safety-filter-playbook.md, +b2b-channel-partner-playbook.md |
| `catalog-product` | +image-prompt-templates.md (product grid + spec tables), +html-css-print-templates.md (A4-portrait, multi-page), +pdf-print-production-2026.md §1+§2+§9 (paged CSS for 8-24 pages), +indonesian-print-culture-2026.md §2 (paper stock) | +image-prompt-templates.md (per-product shot), +pdf-print-production-2026.md (full print stack), +indonesian-print-culture-2026.md §2, +safety-filter-playbook.md (if model shots) | +image-prompt-templates.md, +indonesian-print-culture-2026.md §2 |
| `service-flyer` | +image-prompt-templates.md (hero + 3-benefit icons), +html-css-print-templates.md (A4-portrait OR letter per region), +pdf-print-production-2026.md §1+§2, +safety-filter-playbook.md (if hero has people) | +image-prompt-templates.md, +pdf-print-production-2026.md (full print stack), +safety-filter-playbook.md, +indonesian-print-culture-2026.md §3 (folding + paper) | +image-prompt-templates.md, +safety-filter-playbook.md |
| `trifold-leaflet` | +image-prompt-templates.md (panel composition), +html-css-print-templates.md (A3-landscape-folded + fold-line CSS), +pdf-print-production-2026.md §1+§2+§9, +indonesian-print-culture-2026.md §3 (folding tolerances + paper stock pairing) | +image-prompt-templates.md (panel-aware composition), +pdf-print-production-2026.md (full print stack), +indonesian-print-culture-2026.md §3, +safety-filter-playbook.md (if mailer-panel has people) | +image-prompt-templates.md, +indonesian-print-culture-2026.md §3 |

Conditional adders for ANY row above:
- `brief.json.language_default = "id"` → +`indonesian-context.md`
- `narrative.json.pages[i].motion = true` (any page) → +`seedance-prompt-templates.md`
- `narrative.json.pages[i].programmatic_motion = true` (any page) → +`remotion-config-templates.md`
- `brief.json.print_shop_offset = true` → +`pdf-print-production-2026.md §1` (CMYK) MANDATORY regardless of mode

---

## Hand-off to Stage 5

Output to operator after emit:

```
Stage 4 complete. Artifacts in {output_dir}.

Mode: {html-css | full-image | spec-only}
Output_type: {output_type}
Theme: {theme}
Pages: {N}
Style-anchor page: {idx} (approved by operator at {timestamp})

Files:
  - image-prompts.json ({N} prompts; {K} with face/logo composites)
  - video-prompts.json ({M} motion entries; {N-M} static)
  - remotion.config.json ({P} programmatic compositions)
  - speaker-notes.md (deck modes only)
  - output/<doc-slug>.html + .css + render.mjs (html-css mode only)
  - output/<doc-slug>.pdf (after operator runs render.mjs OR merge.py)
  - output/<doc-slug>.spec.json (spec-only mode only)

Self-check pre-flight:
  - All pages visual ratio ≥ 70%: {Y/N — list violations}
  - All numbers source-tagged: {Y/N}
  - No banned vocabulary in prompts: {Y/N}
  - No banned visuals in prompts: {Y/N}
  - All face composites have safety-filter mitigation + fallback_strategy: {Y/N}
  - Brand palette hex injected verbatim in every prompt: {Y/N}
  - Print mode: CMYK + 3mm bleed + 300dpi + font embedded: {Y/N or N/A for screen-only}

Next: run /ai-business-document-validate to score against the rubric (deck-rubric for deck-* output_types; print-rubric for print collateral).
DO NOT publish until validation passes the threshold per output_type (deck ≥ 70/100; print ≥ 75/100 — see global-config.md §6).
```
