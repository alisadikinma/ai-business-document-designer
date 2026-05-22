---
slug: html-css-print-templates
purpose: Operationalize PDF print readiness — concrete CSS + Playwright code for HTML-to-PDF render pipeline
applies_to: [brochure-product, portfolio-personal, portfolio-agency, catalog-product, service-flyer, trifold-leaflet]
research_basis: references/research/pdf-print-production-2026.md
output_mode: html-css (Playwright PDF render path)
---

# HTML + CSS Print Templates — Render Pipeline Reference

> Working code for the `html-css` output mode (see `global-config.md §17`). Every snippet here is runnable — no pseudocode. Source: `references/research/pdf-print-production-2026.md` §1-§9. This file extracts the operationally-needed pieces; that file remains the authoritative reference.

---

## @page Rules

The `@page` at-rule defines the physical page size, margins, bleed, and crop-marks. Chromium honours it under `emulateMediaType('print')`.

```css
@page {
  size: 210mm 297mm;         /* A4 portrait — Indonesian default */
  margin: 15mm;              /* outer safe margin */
  bleed: 3mm;                /* trim-bleed allowance for Surabaya/Jakarta percetakan */
  marks: crop cross;         /* crop + registration crosshairs */
}

@page :first {
  /* override for cover page only — example: no page number */
  margin-bottom: 0;
}

@page :left {
  /* even pages — wider gutter on the right (inner edge after binding) */
  margin-right: 22mm;
  margin-left: 15mm;
}

@page :right {
  /* odd pages — wider gutter on the left (inner edge after binding) */
  margin-left: 22mm;
  margin-right: 15mm;
}
```

> Source: `references/research/pdf-print-production-2026.md` §9 (CSS for Paged Media) and §2 (3mm bleed for Indonesia / EU; 5mm for US).

### Format-specific @page presets

```css
/* A4 landscape — common for deck-html output */
@page.landscape { size: 297mm 210mm; margin: 12mm; bleed: 3mm; }

/* A3 trifold leaflet (folded to DL 99×210mm — Indonesian printer default) */
@page.trifold { size: 297mm 420mm; margin: 10mm; bleed: 3mm; }

/* US Letter fallback (when shipping to US partners) */
@page.letter { size: 8.5in 11in; margin: 0.625in; bleed: 0.125in; }

/* DL flyer (210×99mm — mailer slip) */
@page.dl { size: 210mm 99mm; margin: 8mm; bleed: 3mm; }
```

---

## Bleed CSS

Full-bleed elements (hero photography, color blocks, color-strip footers) must extend 3mm beyond the trim. The `@page bleed` declaration tells the PDF engine to reserve the bleed area; element CSS must explicitly extend into it.

```css
/* Container that fills page edge-to-edge INCLUDING bleed */
.full-bleed {
  /* Bleed is 3mm on every side → element is 6mm wider/taller than page */
  width: calc(100% + 6mm);
  height: calc(100% + 6mm);
  margin: -3mm;              /* shift left+top by 3mm so element starts in the bleed */
  position: relative;
}

/* Half-bleed — image bleeds only on one side (top, for example) */
.top-bleed {
  width: 100%;
  margin-top: -3mm;
  padding-top: 3mm;          /* push content out of the bleed zone */
}

/* Safe zone — interior 3mm buffer where no critical content may sit */
.safe-zone {
  padding: 3mm;              /* reserve 3mm inside the trim line for trim drift */
}
```

> Safe zone math (per `pdf-print-production-2026.md §2`): live area = trim − bleed on every side. For A4 (210×297mm), the live area where critical text/logos may sit = 207×294mm centred.

---

## Print Color Profile

Chromium renders in sRGB. True CMYK requires post-processing (Ghostscript or PDF/X compliance via downstream tool). For digital-only output, `-webkit-print-color-adjust: exact` preserves background colors.

```css
/* Mandatory on body for any element with background-color / background-image to print */
body {
  -webkit-print-color-adjust: exact;
  print-color-adjust: exact;          /* W3C standard, also accept by Chromium */
}

/* @media print isolation — overrides screen colors for print */
@media print {
  :root {
    /* Re-declare brand palette here so sRGB→CMYK conversion is predictable */
    --brand-primary: #0F1F3D;   /* navy — converts to C100 M85 Y45 K55 approx */
    --brand-accent: #F25C24;    /* orange — converts to C0 M75 Y90 K0 */
    --brand-ink: #0E1B2E;       /* near-black — set body copy to 100K instead */
  }
  /* Force 100K on small text per pdf-print-production-2026.md §1 */
  body, p, .body-text {
    color: #000000;             /* engine reads this as 100K when CMYK profile applied */
  }
  /* Force overprint on small black text — prevents registration halos */
  .small-black {
    color: #000;
    /* Chromium has no overprint property — apply via post-processor (Ghostscript) */
  }
}
```

> Source: `references/research/pdf-print-production-2026.md` §1 (CMYK for offset, 100K rule for text <12pt) and §9 (Chromium 132+ unified browser path).

### ICC profile embedding

Chromium does not embed ICC profiles directly. Pipeline:

1. Render HTML → PDF via Playwright (sRGB internally).
2. Post-process with Ghostscript: `gs -dPDFX -sDEVICE=pdfwrite -sOutputICCProfile=FOGRA39.icc -sOutputFile=out_cmyk.pdf in.pdf`.
3. For Indonesia → use `FOGRA39.icc` (Surabaya printers most common). For US → `GRACoL2013_CRPC6.icc`.

### sRGB fallback (digital-only PDFs)

For PDFs distributed digitally (download links, email attachments) without going to a print shop, skip the Ghostscript step. `-webkit-print-color-adjust: exact` keeps brand colors faithful enough.

---

## Font Embedding

PDF/X requires every glyph used in the document to be embedded as a subset. Chromium auto-subsets web fonts when `@font-face` resolves before render.

```css
@font-face {
  font-family: "Inter";
  src: url("/fonts/Inter-Regular.woff2") format("woff2");
  font-weight: 400;
  font-display: block;          /* MANDATORY — block until loaded; prevents FOUT */
  unicode-range: U+0000-00FF;   /* Latin Basic — subsetting hint */
}

@font-face {
  font-family: "Inter";
  src: url("/fonts/Inter-Bold.woff2") format("woff2");
  font-weight: 700;
  font-display: block;
}

@font-face {
  font-family: "JetBrains Mono";
  src: url("/fonts/JetBrainsMono-Regular.woff2") format("woff2");
  font-weight: 400;
  font-display: block;
}

body {
  font-family: "Inter", -apple-system, sans-serif;
}
code, .mono-label {
  font-family: "JetBrains Mono", monospace;
}
```

> Source: `references/research/pdf-print-production-2026.md` §4 (Subsetting Mandate) and §9 (`font-display: block` to prevent FOUT/FOIT). Chromium embeds the subset automatically when Playwright's `printBackground: true` is set.

### Self-hosted vs CDN fonts

- Self-host fonts whenever possible (`/fonts/*.woff2` in the project). Network race conditions during PDF render are the #1 cause of font fallback bugs.
- If using Google Fonts CDN — preload with `<link rel="preload" as="font" crossorigin>` in the HTML head, and add `await page.evaluate(() => document.fonts.ready)` before `page.pdf()`.

---

## Playwright PDF Options

Complete Node.js example. Drop into `scripts/render-pdf.js`, run `node render-pdf.js input.html output.pdf`.

```javascript
// scripts/render-pdf.js — Playwright HTML→PDF renderer
const { chromium } = require('playwright');
const path = require('path');

async function renderPDF(inputHtmlPath, outputPdfPath) {
  const browser = await chromium.launch({
    args: ['--font-render-hinting=none'],  // crisp print metrics
  });
  const context = await browser.newContext();
  const page = await context.newPage();

  // Load file via file:// URL so relative font/image paths resolve
  const fileUrl = 'file://' + path.resolve(inputHtmlPath);
  await page.goto(fileUrl, { waitUntil: 'networkidle' });

  // Mandatory: tell Chromium to apply @media print rules
  await page.emulateMediaType('print');

  // Wait for all webfonts to be loaded — prevents font-fallback at render time
  await page.evaluate(() => document.fonts.ready);

  // Optional: pause for any JS-driven layout (Remotion components, charts)
  await page.waitForTimeout(300);

  await page.pdf({
    path: outputPdfPath,
    format: 'A4',
    printBackground: true,            // honours background-color and -webkit-print-color-adjust
    preferCSSPageSize: true,          // let @page rule define size/margin instead of these options
    margin: {
      top: '15mm',
      bottom: '15mm',
      left: '15mm',
      right: '15mm',
    },
    displayHeaderFooter: false,        // see Cross-page Headers/Footers section below to enable
  });

  await browser.close();
}

renderPDF(process.argv[2], process.argv[3])
  .then(() => console.log('PDF rendered to', process.argv[3]))
  .catch(err => { console.error(err); process.exit(1); });
```

### Python equivalent (for plugins integrating with Python pipeline)

```python
# scripts/render_pdf.py — Playwright HTML→PDF renderer (Python)
import asyncio
from pathlib import Path
from playwright.async_api import async_playwright

async def render_pdf(input_html: str, output_pdf: str):
    async with async_playwright() as p:
        browser = await p.chromium.launch(
            args=['--font-render-hinting=none'],
        )
        context = await browser.new_context()
        page = await context.new_page()

        file_url = Path(input_html).resolve().as_uri()
        await page.goto(file_url, wait_until='networkidle')
        await page.emulate_media(media='print')
        await page.evaluate('document.fonts.ready')
        await page.wait_for_timeout(300)

        await page.pdf(
            path=output_pdf,
            format='A4',
            print_background=True,
            prefer_css_page_size=True,
            margin={
                'top': '15mm',
                'bottom': '15mm',
                'left': '15mm',
                'right': '15mm',
            },
        )
        await browser.close()

if __name__ == '__main__':
    import sys
    asyncio.run(render_pdf(sys.argv[1], sys.argv[2]))
```

> Source: `references/research/pdf-print-production-2026.md` §9 — Puppeteer Implementation Requirements (`emulateMediaType`, `networkidle0`). Adapted to Playwright (the plugin's runtime choice).

---

## Multi-page Layout (page-break-*)

Multi-page brochures and portfolios require explicit page-break instructions. CSS Paged Media provides three properties.

```css
/* Force a new page BEFORE each top-level section */
.section {
  page-break-before: always;
  break-before: page;                /* modern syntax */
}

/* Force a new page AFTER each case study */
.case-study {
  page-break-after: always;
  break-after: page;
}

/* PREVENT a page break inside a card or table — keep it together */
.product-card,
.spec-table,
.testimonial-block {
  page-break-inside: avoid;
  break-inside: avoid;
}

/* Keep a heading with its following paragraph */
h2, h3 {
  page-break-after: avoid;
  break-after: avoid;
}

/* Orphans / widows — minimum lines that must stay together */
p {
  orphans: 3;                         /* min 3 lines at bottom of page */
  widows: 3;                          /* min 3 lines at top of page */
}
```

### Common pattern — brochure with cover + N modular product pages + back cover

```html
<body>
  <section class="cover full-bleed">...</section>           <!-- page 1 -->
  <section class="product-module">...</section>             <!-- page 2 -->
  <section class="product-module">...</section>             <!-- page 3 -->
  <section class="pricing-tier">...</section>               <!-- page 4 -->
  <section class="cta-back-cover full-bleed">...</section>  <!-- page 5 -->
</body>
```

```css
section { page-break-after: always; }
section:last-child { page-break-after: auto; }   /* no extra blank page at end */
```

---

## Cross-page Headers / Footers

Playwright supports HTML headers / footers via `headerTemplate` and `footerTemplate`. They appear on every page (except where `@page :first { ... }` overrides).

```javascript
await page.pdf({
  path: 'output.pdf',
  format: 'A4',
  printBackground: true,
  displayHeaderFooter: true,
  headerTemplate: `
    <div style="font-size: 9pt; padding: 5mm 15mm; width: 100%; color: #6b7280; font-family: Inter, sans-serif;">
      <span style="float: left;">INDUSIA · Brochure 2026</span>
      <span style="float: right;">www.indusia.ai</span>
    </div>
  `,
  footerTemplate: `
    <div style="font-size: 9pt; padding: 5mm 15mm; width: 100%; color: #6b7280; font-family: Inter, sans-serif;">
      <span style="float: left;">© 2026 INDUSIA. Hak cipta dilindungi.</span>
      <span style="float: right;">Hal. <span class="pageNumber"></span> / <span class="totalPages"></span></span>
    </div>
  `,
  margin: { top: '20mm', bottom: '18mm', left: '15mm', right: '15mm' },
});
```

> Available variables inside `headerTemplate` / `footerTemplate`: `date`, `title`, `url`, `pageNumber`, `totalPages`. Wrap each in a `<span class="X">` element.

### CSS counter alternative (pure-CSS page numbers, no Playwright header)

```css
body { counter-reset: page; }

.page-footer::after {
  counter-increment: page;
  content: "Halaman " counter(page);
  position: running(footer);
  font-size: 9pt;
}

@page {
  @bottom-right {
    content: element(footer);
  }
}
```

> Source: `references/research/pdf-print-production-2026.md` §9 (CSS counter example).

---

## Fallback Patterns

When the render pipeline misbehaves, here are the diagnostic paths.

### Failure: @page CSS ignored (older Chromium, headless-shell variant)

Symptom: PDF renders but page size is letter (US default), margins wrong, no bleed.

Fix:
1. Confirm `preferCSSPageSize: true` is set in Playwright options.
2. If still failing — drop `@page` and pass dimensions directly in `page.pdf({ width: '210mm', height: '297mm', margin: {...} })`.
3. Bleed cannot be expressed via Playwright options — must use post-processing (Ghostscript) to add bleed marks.

### Failure: Web fonts not embedded (text falls back to Times)

Symptom: Headlines render in serif default, body text metrics shifted.

Fix:
1. Check that `font-display: block` is set on every `@font-face`.
2. Add `await page.evaluate(() => document.fonts.ready)` BEFORE `await page.pdf(...)`.
3. If using Google Fonts → switch to self-hosted woff2.
4. Confirm `waitUntil: 'networkidle'` (not just `'load'`) on `page.goto()`.

### Failure: CMYK conversion needed for offset print

Symptom: Print shop rejects PDF because it contains RGB colors.

Fix: post-process via Ghostscript:

```bash
gs -dPDFX -dBATCH -dNOPAUSE \
   -sDEVICE=pdfwrite \
   -sColorConversionStrategy=CMYK \
   -dProcessColorModel=/DeviceCMYK \
   -sOutputICCProfile=FOGRA39.icc \
   -sOutputFile=output_cmyk.pdf \
   input_srgb.pdf
```

For Indonesian percetakan: FOGRA39 profile is the safest default. Surabaya / Jakarta printers all accept FOGRA39-tagged PDF/X-4.

### Failure: Background images not printing

Symptom: Colored backgrounds (brand color blocks, hero photo) render as white.

Fix:
1. Confirm `printBackground: true` in Playwright `page.pdf()` options.
2. Add `-webkit-print-color-adjust: exact; print-color-adjust: exact;` to `body` in CSS.
3. Confirm `@media print` block does not override `background: none`.

---

## End-to-End Example

Complete walkthrough: HTML brochure source → rendered PDF.

**Input file: `brochure.html`**

```html
<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <title>INDUSIA Brochure</title>
  <link rel="stylesheet" href="brochure.css">
</head>
<body>
  <section class="cover full-bleed">
    <h1>Lihat semua dari HP, 24/7.</h1>
    <p class="subtitle">5 modul fleet management untuk owner-operator logistik Batam.</p>
  </section>
  <section class="features">
    <h2>5 modul, 1 platform.</h2>
    <div class="grid">
      <div class="card"><h3>EdgeLink</h3><p>Real-time GPS + sensor.</p></div>
      <div class="card"><h3>YardSync</h3><p>Yard movement tracking.</p></div>
      <div class="card"><h3>FuelSense</h3><p>Anti-kencing solar.</p></div>
    </div>
  </section>
  <section class="pricing">
    <h2>Paket Pre-launch — HEMAT Rp 120jt</h2>
    <p><s>Rp 425jt</s> → <strong>Rp 305jt</strong></p>
    <p>Sudah termasuk PPN 11%.</p>
  </section>
</body>
</html>
```

**Stylesheet: `brochure.css`**

```css
@page { size: 210mm 297mm; margin: 15mm; bleed: 3mm; marks: crop cross; }
@font-face { font-family: "Inter"; src: url("./fonts/Inter-Regular.woff2") format("woff2"); font-display: block; }

body {
  -webkit-print-color-adjust: exact;
  font-family: "Inter", sans-serif;
  font-size: 11pt;
  line-height: 14pt;
  color: #0E1B2E;
  margin: 0;
}
.full-bleed { width: calc(100% + 6mm); margin: -3mm; padding: 18mm; background: #0F1F3D; color: #F8F4ED; }
.cover h1 { font-size: 72pt; font-weight: 800; letter-spacing: -2px; margin: 0 0 12mm; }
.cover .subtitle { font-size: 16pt; max-width: 140mm; }
.features { page-break-before: always; padding: 18mm; }
.features h2 { font-size: 40pt; margin-bottom: 18mm; }
.grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 8mm; }
.card { page-break-inside: avoid; padding: 8mm; border: 1px solid #0F1F3D; }
.card h3 { font-size: 18pt; margin: 0 0 4mm; }
.pricing { page-break-before: always; padding: 18mm; }
.pricing s { color: #9ca3af; }
.pricing strong { font-size: 56pt; color: #F25C24; }
```

**Render command:**

```bash
node scripts/render-pdf.js brochure.html brochure.pdf
```

**Optional CMYK conversion for offset print:**

```bash
gs -dPDFX -dBATCH -dNOPAUSE -sDEVICE=pdfwrite \
   -sColorConversionStrategy=CMYK -dProcessColorModel=/DeviceCMYK \
   -sOutputICCProfile=FOGRA39.icc \
   -sOutputFile=brochure_cmyk.pdf brochure.pdf
```

Output: `brochure_cmyk.pdf` — 3 pages, A4 portrait, 3mm bleed, CMYK color space, fonts embedded, ready for Surabaya / Jakarta percetakan offset press.

> Source citations: `references/research/pdf-print-production-2026.md` §1-§9 throughout. This file operationalizes the research — it does NOT duplicate the prepress theory.
