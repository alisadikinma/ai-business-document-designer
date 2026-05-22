# AI Business Document Designer — Claude Project Instructions

## 🧠 Vault Context Link

Skill library — agnostic, dipakai cross-project (INDUSIA, IRN, Riau Palm Group, dll).

Pre-read kalau perlu konteks:
- `30-Knowledge/image-gen-shared.md` — NB2 prompt engineering (re-used untuk slide + print visuals)
- `30-Knowledge/content-strategy-shared.md` — narrative arc, hook design, framework selection
- `20-Projects/claude-plugin/README.md` — skill ecosystem overview
- `10-Identity/visual-identity.md` — color, font, image style untuk anti-AI-slop
- `10-Identity/voice-tone.md` — speaker notes voice + print copy voice

JANGAN hardcode project-specific values (nama klien, ask amount, comparable, pricing tier). Pakai `{{placeholder}}` syntax di SKILL.md.

## Project Overview

Claude Code plugin that converts a one-paragraph product brief into a presentation-ready business document specification across **9 output_types** spanning two families — **decks** (deck-vc, deck-b2b, deck-hybrid) and **print collateral** (brochure-product, portfolio-personal, portfolio-agency, catalog-product, service-flyer, trifold-leaflet). Visual-first by mandate (≥70% visual / ≤30% text per page). Routes through a **5-stage pipeline** (brief → narrative → copywriting → gen → validate) with **2 human approval gates** (after narrative, after copywriting) and a **dual-mode scoring rubric** (Investor Deck Rubric for decks; Print-Mode Rubric for collateral). Ships **7 theme presets** (industrial-brutalist, minimalist-editorial, premium-luxe, brutalist-mono, pastel-soft, indo-tropical, indusia-tech) and **3 PDF output modes** (html-css via Playwright, full-image via NB2 + img2pdf, spec-only for InDesign hand-off). Indonesian-first defaults; bilingual support.

Five skills + one agent + 25+ reference files. The 5-stage pipeline separates discovery from narrative from copy from visual production from validation — so each gate locks artifact integrity before the next stage spends tokens. Optimized for Indonesian audience as default but reusable for any product / market / format via `global-config.md`.

## Architecture

| Path | Purpose |
|------|---------|
| `.claude-plugin/plugin.json` | Plugin metadata (name=ai-business-document-designer, v0.3.0) |
| `hooks/hooks.json` | SessionStart hook definition |
| `hooks/session-start.sh` | Session start script — announces available skills |
| `skills/ai-business-document-brief/SKILL.md` | Stage 1 — discovery: detect output_type, audience, ask/CTA, theme preset, output mode. Outputs `brief.json`. |
| `skills/ai-business-document-narrative/SKILL.md` | Stage 2 — narrative arc (decks) or modular page layout (print collateral). HUMAN APPROVAL GATE. Outputs `narrative.md` + `narrative.json`. |
| `skills/ai-business-document-copywriting/SKILL.md` | Stage 3 — per-page copy: headline ≤10 words, sub-text ≤25 words, CTA, pricing tier articulation, bilingual support. HUMAN APPROVAL GATE. Outputs `copy.json`. |
| `skills/ai-business-document-gen/SKILL.md` | Stage 4 — visual production: image prompts (GeminiGen.AI / Nano Banana Pro), Seedance 2.0 video prompts, optional Remotion configs, HTML+CSS print stylesheets, output-type-aware aspect ratios. Outputs `deck.md` or `document.md` + asset prompt files + (optional) PDF. |
| `skills/ai-business-document-validate/SKILL.md` | Stage 5 — 100-point quality gate, dual rubric (deck vs print). |
| `agents/ai-business-document-agent.md` | Self-contained subagent for batch / variant production across formats. |
| `references/global-config.md` | Single source of truth — language, visual ratio, banned vocab, scoring weights, §15 output_types, §16 themes, §17 PDF modes. |
| `references/scoring-rubric.md` | 100-point validation gate — §0 mode detection, §1-§9 deck rubric, §11 print rubric. |
| `references/frameworks/deck-vc.md` | VC pitch deck — 10-13 page narrative spine, Sequoia/YC/Kawasaki frameworks. |
| `references/frameworks/deck-b2b.md` | B2B partnership deck — ROI-first arc, integration timeline, commercial terms. |
| `references/frameworks/brochure-product.md` | Product brochure — cover + hero claim + feature modules + pricing + back-contact. |
| `references/frameworks/portfolio-personal.md` | Personal portfolio — about + case study × 3-5 + skills + contact. |
| `references/frameworks/portfolio-agency.md` | Agency portfolio — brand intro + service grid + case study × 3-6 + team. |
| `references/frameworks/catalog-product.md` | Product catalog — category divider + product grid + spec table + order channel. |
| `references/frameworks/service-flyer.md` | Service flyer — hero claim + 3-benefit + CTA above the fold. |
| `references/frameworks/trifold-leaflet.md` | Trifold — 6-panel structure, mailer panel, DL envelope fold. |
| `references/themes/indusia-tech.md` | Dark navy + cyan + gold + isometric 3D. |
| `references/themes/minimalist-editorial.md` | Cream + ink + serif display + whitespace. |
| `references/themes/industrial-brutalist.md` | Black + white + signal red + grid-violation. |
| `references/themes/premium-luxe.md` | Gold + ivory + serif + generous leading. |
| `references/themes/pastel-soft.md` | Soft pastels + rounded sans (Nunito). |
| `references/themes/brutalist-mono.md` | Pure black/white + extreme grotesk weights. |
| `references/themes/indo-tropical.md` | Warm earth + batik accents + display sans + body serif. |
| `references/visual-language.md` | Cognitive load research, 70% ratio rules, §2.5 structured-data exception, typography, §14 print specs (CMYK/bleed/300dpi/fonts), §15 8-pattern anti-AI-slop banlist. |
| `references/layout-grammar.md` | Page composition rules for print collateral — module sizing, fold-line safe zones, gutter math. |
| `references/copywriting-patterns.md` | Headline patterns, CTA patterns, pricing tier articulation, bilingual handling. |
| `references/html-css-print-templates.md` | Playwright `page.pdf()` CSS templates, A4/A3 trim + bleed boilerplate, `-webkit-print-color-adjust` rules. |
| `references/image-prompt-templates.md` | GeminiGen.AI / Nano Banana Pro prompt formulas, density-mode-aware, brand-anchor cover, composite reference patterns. |
| `references/seedance-prompt-templates.md` | Seedance 2.0 4-block prompts for motion (demos, animated charts, transitions). |
| `references/remotion-config-templates.md` | Remotion JSON for programmatic motion. |
| `references/indonesian-context.md` | Bahasa, IDR formatting, VC landscape, BI/OJK/ISPO/ISO compliance signals. |
| `references/investor-psychology.md` | First-90-sec filters, 10 standard investor questions, pattern-matching biases. |
| `references/b2b-channel-partner-playbook.md` | ROI calculator, risk reversal, dual-stakeholder framing. |
| `references/business-model-patterns.md` | Pricing tier articulation, revenue share, freemium/SaaS/per-seat patterns. |
| `references/storyline-frameworks.md` | Hook formulas, tension-build, emotional core, pattern-match library. |
| `references/safety-filter-playbook.md` | MINOR_UPLOAD + IDENTITY_PRESERVATION mitigation. |
| `references/research/*` | Cached NotebookLM research (refresh quarterly to annually). |
| `scripts/lint-frameworks.sh` | Lint frameworks/*.md against frontmatter contract. |
| `scripts/lint-themes.sh` | Lint themes/*.md against theme schema. |
| `scripts/lint-references.sh` | Lint references for broken cross-links + missing §refs. |
| `scripts/lint-skills.sh` | Lint SKILL.md files for required sections. |
| `scripts/compile-references.sh` | Builds compiled per-skill reference bundles for split-pipeline injection. |
| `README.md` | Repo README |
| `LICENSE` | MIT license |

## 9 output_types (per `global-config.md §15`)

| output_type | mode | framework file | default pages | typical use |
|---|---|---|---|---|
| `deck-vc` | Deck | `frameworks/deck-vc.md` | 10-13 | Series A/B fundraise, single VC audience |
| `deck-b2b` | Deck | `frameworks/deck-b2b.md` | 10-13 | Channel partner pitch (mall/EO/operator) |
| `deck-hybrid` | Deck | `frameworks/deck-vc.md` + `deck-b2b.md` | 10-13 | Mixed VC + B2B audience, dual track |
| `brochure-product` | Print | `frameworks/brochure-product.md` | 5-10 | Product spec + pricing handout |
| `portfolio-personal` | Print | `frameworks/portfolio-personal.md` | 8-20 | Designer/dev/consultant portfolio |
| `portfolio-agency` | Print | `frameworks/portfolio-agency.md` | 8-20 | Agency capability deck (print) |
| `catalog-product` | Print | `frameworks/catalog-product.md` | 8-24 | Multi-SKU catalog, distributor pack |
| `service-flyer` | Print | `frameworks/service-flyer.md` | 1-2 | Above-the-fold service pitch |
| `trifold-leaflet` | Print | `frameworks/trifold-leaflet.md` | 6 panels | DL-envelope distributable |

## 7 theme presets (per `global-config.md §16`)

| theme | aesthetic | typical use |
|---|---|---|
| `indusia-tech` | Dark navy + cyan + gold + isometric 3D | deck-b2b (tech), deck-vc, brochure-product (tech), portfolio-agency |
| `minimalist-editorial` | Cream + ink + serif + whitespace | portfolio-personal, brochure-product (premium), deck-hybrid |
| `industrial-brutalist` | Black + white + signal red + grid-violation | portfolio-agency, deck-b2b (heavy industry), brochure-product (industrial) |
| `premium-luxe` | Gold + ivory + serif + leading | brochure-product (luxury), portfolio-personal (high-fee), catalog-product (premium) |
| `pastel-soft` | Pastels + rounded sans | service-flyer (B2C), brochure-product (F&B, kids), catalog-product (consumer) |
| `brutalist-mono` | Pure black/white + extreme grotesk | portfolio-personal (designer), portfolio-agency (creative studio) |
| `indo-tropical` | Warm earth + batik + display sans + body serif | brochure-product (tourism, F&B ID), portfolio-agency (ID-rooted), catalog-product (kerajinan) |

## 3 PDF output modes (per `global-config.md §17`)

| mode | when to use | tradeoffs |
|---|---|---|
| `html-css` | Multi-page text-heavy collateral, version-control source, re-edit later (decks default) | Requires Node.js + Playwright. CMYK fidelity limited — for true CMYK use `full-image` or post-process via Ghostscript. |
| `full-image` | Photo-heavy formats (brochure-product, portfolio-personal, catalog-product); when ≥85% visual ratio mandatory (print collateral default) | Flat image per page — no live text, no a11y, file size 20-80MB for 8 pages. |
| `spec-only` | Operator wants final assembly control; print shop requires native InDesign source for offset print | No PDF artifact. Operator executes spec by hand or via Canva/Figma API. |

## Hard rules (NON-NEGOTIABLE)

These rules apply to every document generated. Violation requires immediate correction before output.

1. **Visual ratio ≥ 70% per page.** Cognitive weight of visuals must dominate text on every page. Hard-fail under 60%.
2. **Headline ≤ 10 words.** No exceptions.
3. **Sub-text ≤ 25 words per page.** Numbers and proper nouns only — no adjectives, no marketing speak.
4. **No banned vocabulary.** Permanently banned: Unlock, Unleash, Empower, Supercharge, Maximize, Revolutionize, Transform, Disrupt, Synergize, Leverage (as verb), Cutting-edge, World-class, Best-in-class, Game-changing. Print-mode additions: next-gen, state-of-the-art, industry-leading, mission-critical, paradigm-shift, synergy.
5. **No generic AI-slop visuals.** No purple-blue gradient backdrops, no stock-photo handshakes, no hexagon tech icons, no light-bulb = innovation, no gear = technology, no globe = international, no abstract neural blobs, no Corporate Memphis illustrations, no faux 3D glassmorphism overuse, no oversaturated palettes (avg saturation >80%).
6. **Every claim has a source or `internal estimate` tag.** Hallucinated traction / fabricated TAM / made-up customer counts = automatic reject.
7. **Ask / CTA is specific.** Decks: amount + use of funds + 18-month milestones (VC) OR pilot scope + commercial terms + integration timeline + decision deadline (B2B). Print: contact channel (phone + WhatsApp + email + website all visible) + named decision deadline if applicable + pricing tier visible.
8. **The 10 standard investor questions are pre-empted by slide 8** (decks only). Per `investor-psychology.md`.
9. **Story spine intact** (decks only). Hook by slide 2, tension peak around slide 6, payoff by slide 8, ask by slide 10.
10. **Pattern match to one known winner** (decks only). "We are [known successful company] for [our market]" within first 3 slides.
11. **Indonesian context honored.** IDR primary (USD parenthetical OK), Bahasa headline + English subtitle if bilingual, named Indonesian comparables, BI/OJK/ISPO/ISO compliance signals where relevant.
12. **Speaker notes 30-45 seconds per slide** (decks only). 80-150 words per slide. Total deck = 5-7 minute talk track.
13. **Print outputs MUST be press-ready.** CMYK color mode (FOGRA51 ICC for ID/EU, GRACoL/SWOP for US), 3-5mm bleed on all 4 edges, 300dpi raster minimum (600dpi line art), all fonts subset-embedded (PDF/X-4 compliance). Applies to any output_type in the print family — see `visual-language.md §14`.
14. **Visual ratio adapts per density-mode.** Minimalist = photo-led ≥70%. Info-dense = structured-data blocks count as visual ONLY when all 6 criteria from `visual-language.md §2.5` hold. Wrong density-mode for the output_type fails Framework Fit.
15. **Pricing tier articulation mandatory** for product/service catalogs and brochures with pricing. Three tiers minimum (entry / standard / enterprise) with IDR amount + 2-3 line tier-differentiator each. Per `business-model-patterns.md`.

## 5-stage pipeline (each stage = its own skill)

```
STAGE 1 — ai-business-document-brief (DISCOVERY)
  Inputs: one-paragraph brief, output_type signal, audience, ask/CTA, target language, theme preference
  Detects: output_type (deck-vc / deck-b2b / deck-hybrid / brochure-product / portfolio-* / catalog / flyer / trifold), audience mode, density-mode, language
  Selects: theme preset (7 options) + PDF output mode (html-css / full-image / spec-only)
  Outputs: brief.json (saved to working dir or /tmp/)

STAGE 2 — ai-business-document-narrative (NARRATIVE / LAYOUT) — HUMAN APPROVAL GATE #1
  Reads: brief.json
  Decks: designs hook + tension + payoff + ask + pattern-match + emotional core + 10-slide story spine
  Print: designs modular page layout — cover + N content modules + back, fold-line safe zones, page sequence
  Outputs: narrative.md (human-readable) + narrative.json (machine-readable)
  PAUSE: operator reviews narrative / layout. No tokens spent on copy or visuals until approval.

STAGE 3 — ai-business-document-copywriting (COPY) — HUMAN APPROVAL GATE #2
  Reads: brief.json + narrative.json
  Per page: headline ≤10 words + sub-text ≤25 words + CTA + pricing tier articulation + bilingual handling
  Outputs: copy.json
  PAUSE: operator reviews copy. No image/video tokens spent until approval.

STAGE 4 — ai-business-document-gen (VISUAL PRODUCTION)
  Reads: narrative.json + copy.json
  Per page:
    1. Visual concept (one-sentence what-it-shows)
    2. Image prompt (40-100 words, GeminiGen.AI nano-banana-pro)
    3. Optional video prompt (Seedance 2.0 4-block when motion adds clarity)
    4. Optional Remotion JSON (programmatic motion)
    5. HTML+CSS print stylesheet (if output_mode=html-css)
    6. Speaker note (decks only, 80-150 words)
    7. Framework pre-empt (decks: investor Q-map; print: framework slot mapping)
  Outputs: deck.md / document.md + image-prompts.json + video-prompts.json + remotion.config.json + (optional) PDF

STAGE 5 — ai-business-document-validate (QUALITY GATE)
  Reads: deck.md / document.md + narrative.json
  Mode detection: deck output_types → Investor Deck Rubric (§1-§9); print output_types → Print-Mode Rubric (§11)
  Deck rubric: Visual Ratio (25) + Narrative Arc (20) + Ask Clarity (15) + Investor Psychology (20) + Anti-AI-Slop (20) = 100
  Print rubric: Visual Ratio (25) + Framework Fit (15) + CTA Clarity (15) + Print Readiness (20) + Anti-AI-Slop (25) = 100
  Output: validation-report.json (passed/failed per category, fixes per failure)
  Combined ≥70 = publish. Hard-fail = back to relevant upstream skill.
```

## Reference files cheat sheet (per stage)

| Stage | Skill | Read first |
|-------|-------|-----------|
| 1 | `/ai-business-document-brief` | `global-config.md` (always) + `frameworks/<output_type>.md` (for the detected type) + `indonesian-context.md` (if Indonesian) |
| 2 | `/ai-business-document-narrative` | `global-config.md` + `storyline-frameworks.md` (decks) + `investor-psychology.md` (decks) + `layout-grammar.md` (print) + `frameworks/<output_type>.md` |
| 3 | `/ai-business-document-copywriting` | `global-config.md` + `copywriting-patterns.md` + `business-model-patterns.md` (catalog/flyer/brochure with pricing) + `indonesian-context.md` |
| 4 | `/ai-business-document-gen` | `global-config.md` + `visual-language.md` + `image-prompt-templates.md` + `safety-filter-playbook.md` (any face/logo files[]) + `themes/<theme>.md` + `html-css-print-templates.md` (print modes) + `seedance-prompt-templates.md` (motion=true) + `remotion-config-templates.md` (programmatic_motion=true) |
| 5 | `/ai-business-document-validate` | `global-config.md` + `scoring-rubric.md` + `visual-language.md` (anti-slop + §14 print specs) + `investor-psychology.md` (decks pre-empt check) |

Each row adds (+) to base. Multiple tasks in one step = read all listed files.

## Common failure modes

| Failure mode | Counter rule |
|--------------|--------------|
| Wall of bullet text per page | Rule 1, 2, 3 (visual ratio + word limits) |
| Generic AI-slop visuals (purple gradients, stock handshakes, Corporate Memphis) | Rule 5 (specific subjects mandated) |
| Hallucinated traction / customer counts | Rule 6 (source-or-hypothesis tagging) |
| Vague ask ("we want to grow") | Rule 7 (specificity mandated) |
| Speaker notes that just restate the slide | `visual-language.md` speaker-notes section |
| English-defaulted document for Indonesian audience | Rule 11 + `indonesian-context.md` |
| Sequoia template applied verbatim to B2B sale | Output_type detection in Stage 1 + `frameworks/deck-b2b.md` |
| 30-slide deck because every idea got its own slide | Per-output_type default_page_count cap |
| Forgot the ask / CTA slide entirely | Rule 7 |
| Closing on "Thank You" | Final-frame rule in `visual-language.md` |
| Cover page rendered as generic stock-photo | Density-mode-aware Slide 0 brand-anchor template in `image-prompt-templates.md` §3 |
| Founder face composite triggers MINOR_UPLOAD safety filter | Synthetic-atmosphere + age-locking in `safety-filter-playbook.md` |
| Brand colors drift between pages | `brand_palette` REQUIRED + verbatim hex injection per `global-config.md §3.6` |
| **CMYK not set — print shop rejects PDF as RGB** | Rule 13 + `visual-language.md §14.1` + Print Readiness check |
| **Bleed missing — print shop charges re-trim fee** | Rule 13 + `visual-language.md §14.2` |
| **Raster below 300dpi — visible pixelation on press** | Rule 13 + `visual-language.md §14.3` |
| **Fonts not embedded — substitution on viewer machine** | Rule 13 + `visual-language.md §14.4` |
| **Fold-line clips body content** (trifold) | `layout-grammar.md` fold-safe-zone rules + `frameworks/trifold-leaflet.md` |
| **Pricing tier vague or absent** (catalog/flyer/brochure) | Rule 15 + `business-model-patterns.md` |
| **Wrong density-mode for output_type** (e.g., minimalist mode used for catalog) | Rule 14 + `visual-language.md §2.5` |

## Key pipeline behaviors

- **Interactive mode** (default): hard pauses at end of Stage 2 AND Stage 3. Operator reviews narrative / layout, then copy, before any visual tokens are spent.
- **Batch / variant mode** (via `agents/ai-business-document-agent.md`): one master document + N audience/theme variants in a single Task invocation. Approval gates consolidated across variants.
- **Pipeline mode** (CLI flags `--brief-file --output-dir --narrative-pre-approved --copy-pre-approved`): fully automated, zero pauses, structured JSON to output directory. Validation failures hard-stop and exit non-zero.
- **Validate-only mode** (`/ai-business-document-validate`): scores an existing deck.md / document.md against the appropriate rubric without regenerating.
- **Refresh research mode** (`--refresh-research`): re-runs nlm-skill, overwrites cached research files in `references/research/`.

## Integration with other plugins in the suite

| Sibling plugin | How ai-business-document-designer relates |
|----------------|-------------------------------|
| `ai-image-carousel-prompt-gen` | Image prompt format + `global-config.md` philosophy mirrored. A page with image prompt can be sent to carousel-gen for batch render. |
| `ai-video-promo-engine` | Video prompts use the same Seedance 2.0 / VEO 3.1 grammar. A deck demo loop can be promoted into a full video via video-gen. |
| `article-content-writer` | When a document needs a long-form companion (one-pager, FAQ, deep-dive memo), hand off to article-gen with the narrative arc as input. |
| `linkedin-post-writer` | Cover image + final-page CTA can become a LinkedIn announcement post via linkedin-gen. |

## Refresh / maintenance

- `references/research/*` are cached NotebookLM outputs. Refresh annually or when document win rate drops noticeably (quarterly for `indonesian-print-culture-2026.md` since printer pricing + paper stock availability shift fast).
- `references/indonesian-context.md` (VC landscape, compliance) — refresh quarterly.
- Banned vocabulary list (`global-config.md §4`) — append when new AI-slop terms emerge.
- Scoring rubric thresholds (`scoring-rubric.md`) — adjust only when validation results consistently misalign with operator outcomes.
- Theme presets (`themes/*.md`) — extend the theme registry in `global-config.md §16` first, then create the preset file. Lint via `scripts/lint-themes.sh`.
- Frameworks (`frameworks/*.md`) — extend `global-config.md §15` first, then create the framework file. Lint via `scripts/lint-frameworks.sh`.
