# AI Business Document Designer — Claude Code Plugin

Visual-first AI designer for business documents across 9 output_types — pitch decks (VC, B2B partnership, hybrid), brochures, portfolios (personal + agency), product catalogs, service flyers, and trifold leaflets. Turns a one-paragraph product brief into a presentation-ready or press-ready document specification: ≥70% visual / ≤30% text per page, with image prompts (Nano Banana Pro / GeminiGen.AI), Seedance 2.0 motion prompts, optional Remotion configs, HTML+CSS print stylesheets, and persuasive Indonesian/English copy. Routes through a 5-stage pipeline with 2 human approval gates and a dual-rubric validator (Investor Deck Rubric for decks; Print-Mode Rubric for collateral).

## Why this plugin exists

The default behavior of LLMs when asked for a "pitch deck" is to dump 10 paragraphs of bullet text — the exact failure mode DocSend research identified as why investors disengage in the first 90 seconds. When asked for a "brochure" or "portfolio", LLMs produce generic stock-photo handshakes, purple gradient backdrops, light-bulb-equals-innovation clichés, and crucially miss the print-readiness contract (CMYK, bleed, 300dpi, embedded fonts) that determines whether the file survives a real print shop. This plugin enforces the opposite: a document where **the visuals carry the story**, each page ships as a structured spec with framework-validated copy, and every print output is press-ready by default. Five stages, two approval gates, dual-mode scoring — the operator nails the narrative before any image token is spent and never ships a file the print shop will reject.

## Install

```bash
# Via ai-content-suite marketplace
claude plugins marketplace add alisadikinma/ai-content-suite
claude plugins install ai-business-document-designer

# Or direct
claude plugins install alisadikinma/ai-business-document-designer
```

## Skills (5-stage pipeline)

| # | Skill | Trigger | Stage | Description |
|---|-------|---------|-------|-------------|
| 1 | `ai-business-document-brief` | `/ai-business-document-brief` | Discovery | Gather product, audience, ask/CTA, traction, theme preference. Detects output_type (one of 9), audience mode, density-mode, language, PDF output mode. Outputs `brief.json`. |
| 2 | `ai-business-document-narrative` | `/ai-business-document-narrative` | Narrative / Layout | Decks: hook + tension + payoff + ask + pattern-match + emotional core + 10-slide story spine. Print: modular page layout with fold-line safe zones. **HUMAN APPROVAL GATE #1**. Outputs `narrative.md` + `narrative.json`. |
| 3 | `ai-business-document-copywriting` | `/ai-business-document-copywriting` | Copy | Per-page headline ≤10 words, sub-text ≤25 words, CTA, pricing tier articulation, bilingual handling. **HUMAN APPROVAL GATE #2**. Outputs `copy.json`. |
| 4 | `ai-business-document-gen` | `/ai-business-document-gen` | Visual production | Per-page image prompts (GeminiGen.AI / Nano Banana Pro), Seedance 2.0 motion prompts, optional Remotion configs, HTML+CSS print stylesheets, output-type-aware aspect ratios. Outputs `deck.md` / `document.md` + asset prompt files + (optional) PDF. |
| 5 | `ai-business-document-validate` | `/ai-business-document-validate` | Quality gate | 100-point dual-rubric scoring: deck rubric (Visual Ratio + Narrative Arc + Ask Clarity + Investor Psychology + Anti-AI-Slop) OR print rubric (Visual Ratio + Framework Fit + CTA Clarity + Print Readiness + Anti-AI-Slop). Mode auto-selects from output_type. |

**Why 5 stages, 2 gates:** narrative is the soul of the document and copy is the skeleton. Folding either into visual generation (the way most AI tools do) produces documents that look polished but say nothing or break at the press. Gate 1 (post-narrative) locks the story before any copy is written. Gate 2 (post-copy) locks the headline + CTA + pricing before any image/video tokens are spent. Each stage can be re-run atomically without invalidating downstream artifacts.

**Run sequentially:**
```bash
/ai-business-document-brief          # → brief.json
/ai-business-document-narrative      # → narrative.md + narrative.json   (GATE #1)
/ai-business-document-copywriting    # → copy.json                       (GATE #2)
/ai-business-document-gen            # → deck.md / document.md + assets + (optional) PDF
/ai-business-document-validate       # → validation-report.json          (gates publication)
```

## Agent

| Agent | Description |
|-------|-------------|
| `ai-business-document-agent` | Self-contained subagent for batch document production — one master + N audience / theme / output_type variants in a single Task invocation. Approval gates consolidated. |

## What gets generated per page

Every page ships as a structured record with eight components:

1. **Page number + role** — e.g., decks: Title / Hook / Problem / Solution / Ask. Print: cover / hero claim / feature module / pricing / back-contact.
2. **Visual concept** — one-sentence brief of what the page LOOKS like (the 3-second read).
3. **On-page text caps** — headline ≤10 words, sub-text ≤25 words, numbers + nouns only, no adjectives.
4. **Image prompt** — full GeminiGen.AI nano-banana-pro prompt (40-100 words) with aspect_ratio + theme + reference images noted.
5. **Optional video prompt** — Seedance 2.0 4-block prompt when motion adds clarity (demos, animated charts, transitions).
6. **Optional Remotion JSON** — when programmatic motion needed (live data, animated counters, parallax).
7. **Copy + CTA** — finalized headline + sub-text + CTA line + (where applicable) pricing tier articulation, bilingual variant if requested.
8. **Framework pre-empt** (decks) OR **layout-grammar slot** (print) — decks: which of 10 standard investor questions this slide pre-empts. Print: which framework slot the page fills + fold-line / module position confirmation.

## 9 output_types

| output_type | mode | default pages | typical use |
|---|---|---|---|
| `deck-vc` | Deck | 10-13 | Series A/B fundraise |
| `deck-b2b` | Deck | 10-13 | Channel partner pitch (mall/EO/operator) |
| `deck-hybrid` | Deck | 10-13 | Mixed VC + B2B audience |
| `brochure-product` | Print | 5-10 | Product spec + pricing handout |
| `portfolio-personal` | Print | 8-20 | Designer/dev/consultant portfolio |
| `portfolio-agency` | Print | 8-20 | Agency capability deck |
| `catalog-product` | Print | 8-24 | Multi-SKU catalog |
| `service-flyer` | Print | 1-2 | Above-the-fold service pitch |
| `trifold-leaflet` | Print | 6 panels | DL-envelope distributable |

7 named theme presets pair with any output_type: `indusia-tech`, `minimalist-editorial`, `industrial-brutalist`, `premium-luxe`, `pastel-soft`, `brutalist-mono`, `indo-tropical`. See [CLAUDE.md](CLAUDE.md) for the full theme map.

## Validation gate — DUAL RUBRIC

The validator auto-selects between two 100-point rubrics based on `output_type`:

**Deck mode** (deck-vc, deck-b2b, deck-hybrid):

| Category | Weight | What it checks |
|----------|--------|----------------|
| Visual Ratio | 25 | Each slide ≥70% visual; hard-fail any < 60% |
| Narrative Arc | 20 | Hook in 1-2, payoff by 8, ask in 10 |
| Ask Clarity | 15 | Specific number + use of funds + milestone (VC) OR pilot scope + terms + deadline (B2B) |
| Investor Psychology | 20 | First-90-sec filter passed, 10 standard Qs pre-empted, pattern-matched |
| Anti-AI-Slop | 20 | No banned vocab, no AI-cliché visuals, no hallucinated traction |

**Print mode** (brochure-product, portfolio-*, catalog-product, service-flyer, trifold-leaflet):

| Category | Weight | What it checks |
|----------|--------|----------------|
| Visual Ratio | 25 | Each page ≥70% visual; hard-fail any < 60% |
| Framework Fit | 15 | Mandatory pages present, page sequence matches framework, modular content per spec |
| CTA Clarity | 15 | Cover CTA + back-cover contractual CTA + per-page CTA on multi-page collateral |
| Print Readiness | 20 | CMYK + 3-5mm bleed + 300dpi raster + embedded fonts + no overprint errors |
| Anti-AI-Slop | 25 | No banned vocab (incl. print-mode additions), no 8-pattern visual cliches, no unsourced stats |

Combined ≥70 to publish. Visual Ratio under 60% on any page = automatic reject regardless of other scores. Print Readiness missing any one of CMYK / bleed / 300dpi / fonts = automatic reject.

## Pipeline diagram

```
[STAGE 1 — ai-business-document-brief]
brief input (paragraph + Q&A)
   → output_type detection (one of 9)
       → audience + density-mode + language + theme + PDF mode
           → output: brief.json

[STAGE 2 — ai-business-document-narrative]
read brief.json
   → decks: hook + tension + payoff + ask + pattern-match + 10-slide spine
   → print: modular page layout + fold-line safe zones + page sequence
       → output: narrative.md + narrative.json
           → HUMAN APPROVAL GATE #1

[STAGE 3 — ai-business-document-copywriting]
read narrative.json
   → per-page headline + sub-text + CTA + pricing tier articulation
       → output: copy.json
           → HUMAN APPROVAL GATE #2

[STAGE 4 — ai-business-document-gen]
read narrative.json + copy.json
   → per-page visual concept + image prompt + video prompt + Remotion + HTML/CSS + speaker notes
       → output: deck.md / document.md + image-prompts.json + video-prompts.json + (optional) PDF

[STAGE 5 — ai-business-document-validate]
read deck.md / document.md
   → mode detection (deck rubric vs print rubric)
       → 100-point scoring gate
           → output: validation-report.json
               → publish (if pass) or send back to relevant upstream stage
```

Operator's downstream workflow: feed image prompts to GeminiGen.AI, render via Playwright (html-css mode), img2pdf (full-image mode), or hand off to InDesign (spec-only mode).

## Reference architecture

25+ reference files as a layered RAG knowledge base — `global-config.md` is single source of truth (visual ratios, banned vocab, output_types, themes, PDF modes); `scoring-rubric.md` holds dual rubrics; `frameworks/*.md` (8 framework files, one per output_type) hold per-format narrative + layout contracts; `themes/*.md` (7 theme files) declare palette + typography + illustration; supporting files cover visual language, layout grammar, copywriting patterns, image/video/Remotion prompt templates, HTML+CSS print stylesheets, safety filter mitigation, business model patterns, investor psychology, B2B playbook, Indonesian context, and cached research. See [CLAUDE.md](CLAUDE.md) for the full per-stage cheat sheet.

## License

MIT
