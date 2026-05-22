# print-collateral-designer — Plugin Design Doc

> Hybrid file: `## Design` section di-tulis oleh gaspol-brainstorm. `## Implementation Plan` akan di-append oleh gaspol-plan setelah research selesai.

**Date**: 2026-05-21
**Author**: Ali Sadikin (via Claude Code + gaspol-brainstorm)
**Status**: ✅ Design locked. ✅ NotebookLM research complete (5 topics, 296 sources, 5 reports + 5 audio podcasts cached). ⏭ Next: gaspol-plan to append Implementation Plan section.

---

## Design

### 1. Purpose & Positioning

Claude Code plugin yang convert satu paragraph product/portfolio/service brief jadi **print-ready PDF collateral** (A4, 300dpi, CMYK-aware) untuk distribusi offline. Visual-first by mandate (≥70% visual / ≤30% text per page). Multi-framework adaptive: detect apakah deliverable adalah **product brochure**, **service flyer**, **portfolio (personal/agency)**, atau **catalog produk fisik** — dan reshape narrative + layout grammar + validator rubric sesuai framework.

Generates per-page image prompts (GeminiGen.AI / Nano Banana Pro), HTML+CSS print stylesheet (atau full-bleed image, atau layout-spec JSON — per output mode), persuasive Bahasa Indonesia copywriting (bilingual flag optional), dan validator gate sebelum output.

**Position dalam skill ecosystem**: sibling ke `pitch-deck-designer`. Pitch-deck = narrative pitch untuk investor/buyer (10 slide linear); print-collateral = product/portfolio catalog modular per-page untuk distribusi offline. Share 75% infrastructure (image prompt engine, anti-AI-slop rules, brand consistency) tapi narrative DNA berbeda fundamental.

### 2. Architecture (5-stage pipeline)

```
STAGE 1 — print-collateral-brief (DISCOVERY)
  Inputs: one-paragraph brief, target framework, page count, theme preset, audience
  Asks: clarifying Qs to fill product/service detail, pricing tier, CTA target, language
  Detects: framework = product-brochure | service-flyer | portfolio-personal | portfolio-agency | catalog-product
  Outputs: brief.json

STAGE 2 — print-collateral-layout (PAGE-BY-PAGE WIREFRAME)
  Reads: brief.json
  Designs: per-page layout — visual hierarchy, grid system, content blocks, image placement
  Maps: page sequence (cover → modular content → CTA/contact)
  Outputs: layout.md + layout.json

STAGE 3 — print-collateral-copywriting (COPY PER PAGE) — HUMAN APPROVAL GATE
  Reads: layout.json
  Writes: per-page copy — headline (≤10 word), sub-text (≤25 word), feature bullet, pricing detail, CTA
  Language: Bahasa Indonesia default, bilingual flag optional
  Outputs: copy.md + copy.json
  PAUSE: operator review copy, approve atau refine. No tokens spent on visuals until approval.

STAGE 4 — print-collateral-gen (VISUAL PRODUCTION)
  Reads: copy.json + layout.json + brief.json
  Per output mode (user pilih di brief):
    (a) HTML+CSS print stylesheet (multi-page, render via Playwright PDF)
    (b) Full-image NB2 per page (1240x1754px @ 300dpi, Pillow merge ke PDF)
    (c) Layout-spec JSON only (user assemble di Canva/Figma/InDesign)
  Generates: image prompts (NB2/Gemini), HTML/CSS atau image batch atau JSON spec
  Outputs: collateral.pdf (mode a/b) atau spec.json (mode c) + image-prompts.json

STAGE 5 — print-collateral-validate (QUALITY GATE)
  Reads: collateral.pdf / spec.json
  Scores: 5 categories totaling 100 points
    - Visual Ratio (25): each page ≥70%, hard-fail any < 60%
    - Print Readiness (20): bleed/safe zone, 300dpi, font embed, color space
    - Framework Fit (15): structure aligns with chosen framework
    - CTA Clarity (15): contact/pricing/action explicit
    - Anti-AI-Slop (25): no banned vocab, no AI-cliché visuals, no generic icon
  Output: validation-report.json
  Combined ≥70 = publish. Hard-fail = back to relevant upstream skill.
```

### 3. Reference files (planned)

```
references/
├── global-config.md                            # Single source of truth — language, visual ratio, banned vocab, scoring weights
├── research/
│   ├── design-fundamentals-2026.md             # NotebookLM cached — grids, type, color, anti-AI-slop
│   ├── pdf-print-production-2026.md            # NotebookLM cached — CMYK, bleed, 300dpi, font embed
│   ├── framework-structures-2026.md            # NotebookLM cached — per-framework narrative & layout
│   └── indonesian-print-culture-2026.md        # NotebookLM cached — paper stock, printer SOP, bilingual
├── frameworks/
│   ├── product-brochure.md                     # INDUSIA pattern — hero claim → modular feature → pricing → CTA
│   ├── service-flyer.md                        # 1-2 page above-the-fold + CTA
│   ├── portfolio-personal.md                   # About → case study → contact
│   ├── portfolio-agency.md                     # Brand → service → case study grid → team → contact
│   └── catalog-product.md                      # Product grid + spec table
├── themes/
│   ├── indusia-tech.md                         # Dark navy + cyan/gold + isometric 3D
│   ├── minimalist-editorial.md                 # Cream + serif + whitespace
│   ├── industrial-brutalist.md                 # Black/white/red + mono type
│   ├── premium-luxe.md                         # Gold + serif + spacious
│   ├── pastel-soft.md                          # Pastel + rounded + friendly
│   ├── brutalist-mono.md                       # Type-only + grid violation
│   └── indo-tropical.md                        # Warm + batik motif + Indonesian
├── layout-grammar.md                           # 12-col grid, z/f eye flow, visual hierarchy
├── image-prompt-templates.md                   # NB2/Gemini prompt formulas per page type, per theme
├── html-css-print-templates.md                 # @page, @media print, CMYK fallback, bleed CSS
├── copywriting-patterns.md                     # Headline formula, CTA copy, pricing tier framing
├── business-model-patterns.md                  # Pricing model library, promo tactics, revenue model, tier articulation
├── scoring-rubric.md                           # 100-point validation gate
└── indonesian-context.md                       # Bahasa convention, IDR formatting, regulatory
```

### 4. Hard rules (NON-NEGOTIABLE — copied from pitch-deck-designer pattern, adapted for print)

1. **Visual ratio ≥ 70% per page.** Hard-fail under 60%.
2. **Headline ≤ 10 words.** No exceptions.
3. **Sub-text ≤ 25 words per page.** Numbers + proper nouns only.
4. **Banned vocabulary** (sama dengan pitch-deck): Unlock, Unleash, Empower, Supercharge, Revolutionize, Transform, Game-changing, dst.
5. **No generic AI-slop visuals.** No purple-blue gradient, no stock handshake, no light bulb = innovation, no hexagon icon as "tech".
6. **Every claim sourced or tagged "internal estimate".**
7. **CTA specific.** Product brochure: pricing tier + sales contact. Service flyer: contact + decision deadline. Portfolio: hire/contact. Catalog: order channel + spec sheet ref.
8. **Bleed + safe zone respected.** 3-5mm bleed margin di setiap halaman. Print-ready output mandatory.
9. **300dpi minimum** untuk semua raster image. SVG/CSS untuk vector.
10. **Font embedded** di output PDF. No system font reliance.
11. **Indonesian context honored** kalau Bahasa Indonesia: IDR primary, paper stock local, regulatory disclaimer.
12. **Anti-AI-slop visual rule per theme.** Setiap theme punya banned visual list-nya sendiri.

### 5. Data Integration Map

| Component | Data Source | Existing? | Notes |
|-----------|-----------|-----------|-------|
| Plugin metadata | `.claude-plugin/plugin.json` | New | Mirror pitch-deck-designer schema |
| Session start hook | `hooks/session-start.sh` | New | Announce skills |
| Reference files | `references/*.md` | New | Total ~20 file, 4 di-research via NotebookLM |
| Image prompt engine | NB2/Gemini API | External | Same as pitch-deck (reuse pattern) |
| PDF render engine | Playwright (HTML mode) + Pillow/img2pdf (image mode) | External | New dependency untuk plugin |
| Theme presets | `references/themes/*.md` | New | 7 named themes |
| Frameworks | `references/frameworks/*.md` | New | 5 frameworks |
| Validator rubric | `references/scoring-rubric.md` | New | 100-point gate |

### 6. Implementation Feasibility — Flags

- **NB2/Gemini API access**: requires API key (assumed available, same as pitch-deck-designer).
- **Playwright**: nodejs dependency. Plugin will need install script atau document setup in README.
- **Pillow/img2pdf**: python dependency untuk full-image PDF mode. Plugin perlu pyproject.toml atau requirements.txt.
- **Indonesian printer SOP knowledge**: butuh research deep — sebagian akan dicover NotebookLM, sebagian mungkin perlu user domain knowledge (Batam print culture).
- **Theme preset images for anchor**: setiap theme idealnya punya 1-2 anchor image (reference). Bisa generated via NB2 di plugin install script.

### 7. NotebookLM Research Queue (next step)

1. **design-fundamentals-2026.md** — brochure layout grids, typography hierarchy, color psychology, visual flow, anti-AI-slop banned visuals
2. **pdf-print-production-2026.md** — CMYK vs RGB, bleed/safe zone, 300dpi, font embedding, crop marks, paper stock standard
3. **framework-structures-2026.md** — product brochure narrative, portfolio case study structure, catalog product grid, service flyer 1-pager conventions
4. **indonesian-print-culture-2026.md** — paper stock lokal, printer SOP Batam/Jakarta, bilingual convention, regulatory disclaimer
5. **business-model-patterns-2026.md** — pricing model (SaaS tier, one-time + AMC, usage-based, freemium, hybrid), promotional tactics (anchor, decoy, dual-price), revenue model (channel partner, lease-to-own, BNPL), bundling, Indonesian B2B specifics, 2024-2026 modern playbook, brochure articulation patterns
   - ⚠️ **MIGRATION TODO (2026-Q3)**: file ini akan di-extract ke skill `senior-bizmodel-architect-id` di `D:\Projects\indusia-skills\skills\` saat extraction phase. Plugin print-collateral-designer akan trigger skill itu sebagai sub-expertise saat copywriting stage detect pricing tier di brief. Untuk MVP saat ini, file tetap di sini sebagai reference local copy.

Output dari NotebookLM akan di-cache ke `references/research/<slug>-2026.md` dan di-baca oleh skills via `--append-system-prompt-file` (mirror pitch-deck-designer pattern).

### 8. Open Questions (to revisit after research)

- Apakah perlu MCP integration untuk PDF render (mis. via Playwright MCP)?
- Apakah anchor image untuk setiap theme di-bundle as repo asset, atau generated on-demand?
- Bagaimana handle multi-page consistency (style drift antara halaman)?
- Apakah portfolio-personal vs portfolio-agency cukup berbeda sampai butuh framework terpisah, atau satu framework dengan mode flag?

### 9. Next Steps

1. ~~**Run /nlm-skill** untuk 4 research topic di atas → cache hasil ke `references/research/`~~ ✅ **DONE 2026-05-21**. 5 research files written (added `business-model-patterns-2026` as 5th topic after user feedback). Index at [references/research/INDEX.md](../../references/research/INDEX.md).
2. **Run gaspol-plan** → append `## Implementation Plan` section ke file ini (TDD-driven, per-phase verification). Plan will reference research files via `--append-system-prompt-file` injection per skill stage.
3. **Run gaspol-execute** → kerjakan plugin per phase. Mirror pitch-deck-designer architecture (`.claude-plugin/plugin.json`, `hooks/`, `skills/<stage>/SKILL.md`, `agents/`, `references/`).

### 10. Research Cache Summary (2026-05-21)

| Slug | Source Count | Skills That Read It |
|------|--------------|---------------------|
| design-fundamentals-2026 | 66 | layout, gen, validate |
| pdf-print-production-2026 | 74 | gen, validate |
| framework-structures-2026 | 59 | brief, layout, validate |
| indonesian-print-culture-2026 | 58 | brief, copywriting, validate |
| business-model-patterns-2026 | 39 | brief, copywriting, validate |
| **Total** | **296 sources** | All 5 skills covered |

Reports: 5 markdown files (~46KB combined). Audio podcasts: 5 MP3s (403MB, gitignored).

---

## Implementation Plan

> **For Claude:** REQUIRED SKILL: Use `gaspol-execute` to implement this plan.
> **CRITICAL:** This plan specifies real integrations (NotebookLM cached research, existing pitch-deck reference files, real plugin manifest). During execution, NEVER substitute placeholders for real data sources without explicit user approval. If a data source doesn't exist yet, STOP and ask.

### Goal

Convert existing `pitch-deck-designer` plugin into `ai-business-document-designer` — a multi-format visual-first AI designer that handles pitch decks (VC + B2B), brochures (product/service), portfolios (personal + agency), product catalogs, service flyers, and trifold leaflets. Reuses 75% of pitch-deck-designer infrastructure (image prompt engine, anti-AI-slop rules, Indonesian context, validator architecture, subagent pattern). Adds: 5-stage pipeline (with new copywriting stage), 6 new frameworks, 7 named themes, print-readiness gates (CMYK/bleed/300dpi), HTML-to-PDF render pipeline, multi-mode validator.

### Architecture Context (pulled from existing pitch-deck-designer/CLAUDE.md)

Existing assets that will be REUSED or EXTENDED:

| Asset | Current Path | Reuse Mode |
|-------|--------------|------------|
| Plugin manifest | `.claude-plugin/plugin.json` | ✅ Already updated (v0.3.0, scope extended) |
| SessionStart hook | `hooks/session-start.sh` | ✅ Already updated (5-skill announce) |
| Global config | `references/global-config.md` | 🔧 EXTEND (output_type enum, theme registry, banned vocab) |
| Visual language | `references/visual-language.md` | 🔧 EXTEND (add print-specific section: CMYK, bleed, 300dpi) |
| Image prompt templates | `references/image-prompt-templates.md` | ✅ REUSE as-is (NB2 grammar same across formats) |
| Safety filter playbook | `references/safety-filter-playbook.md` | ✅ REUSE as-is |
| Indonesian context | `references/indonesian-context.md` | 🔧 EXTEND (print-specific: paper stock, printer SOP, regulatory) — research cache available |
| Investor psychology | `references/investor-psychology.md` | ✅ REUSE for pitch-deck-vc / pitch-deck-b2b frameworks |
| Storyline frameworks | `references/storyline-frameworks.md` | ✅ REUSE for narrative-arc output types |
| Deck frameworks | `references/deck-frameworks.md` | 🔧 SPLIT into `frameworks/deck-vc.md` + `frameworks/deck-b2b.md` |
| B2B channel partner | `references/b2b-channel-partner-playbook.md` | ✅ REUSE |
| Seedance templates | `references/seedance-prompt-templates.md` | ✅ REUSE |
| Remotion templates | `references/remotion-config-templates.md` | ✅ REUSE |
| Scoring rubric | `references/scoring-rubric.md` | 🔧 EXTEND (multi-mode: deck rubric + print rubric) |
| Research cache | `references/research/` | ✅ ALREADY MIGRATED (5 new files + 1 existing investor-pitch) |
| 4 existing skills | `skills/pitch-deck-{brief,storyline,gen,validate}/SKILL.md` | 🔄 REBUILD as `skills/ai-business-document-{brief,narrative,gen,validate}/` + NEW `copywriting/` |
| Agent | `agents/pitch-deck-designer-agent.md` | 🔄 REBUILD as `agents/ai-business-document-agent.md` |
| Compile script | `scripts/compile-references.sh` | 🔧 EXTEND (handle new framework/theme folders) |
| CLAUDE.md | `CLAUDE.md` | 🔄 REWRITE for merged scope |
| README.md | `README.md` | 🔄 REWRITE |

### Tech Stack

- **Plugin format**: Claude Code plugin (`.claude-plugin/plugin.json` v0.3.0)
- **Skill format**: SKILL.md per stage (5 stages)
- **Reference format**: Markdown with YAML frontmatter where applicable
- **Image gen**: GeminiGen.AI / Nano Banana Pro (existing pattern)
- **Video gen**: Seedance 2.0 (existing pattern)
- **Programmatic motion**: Remotion (existing pattern, optional)
- **PDF render**: Playwright (headless Chromium) HTML-to-PDF + Pillow/img2pdf untuk full-image mode + JSON spec untuk Canva/Figma/InDesign assembly mode
- **Validation**: Multi-mode 100-point gate (deck mode vs print mode sub-rubrics)
- **Research source**: 6 NotebookLM cached references (5 new + 1 existing) — total 296+ sources

### Data Integration Map

| Feature | Data Source | Path | Exists? | Action |
|---------|-------------|------|---------|--------|
| Brief stage discovery questions | global-config output_type enum | `references/global-config.md` (EXTEND) | Partial | EXTEND existing |
| Narrative arc (deck output types) | storyline-frameworks.md + investor-psychology.md | `references/{storyline-frameworks,investor-psychology}.md` | Yes | REUSE existing |
| Modular page layout (brochure/portfolio/etc.) | layout-grammar.md | `references/layout-grammar.md` | No | CREATE new |
| Framework per output type | frameworks/*.md library | `references/frameworks/*.md` (8 files) | Partial (2 from split) | CREATE 6 new + SPLIT 2 from deck-frameworks.md |
| Theme preset (color/font/illustration style) | themes/*.md library | `references/themes/*.md` (7 files) | No | CREATE 7 new |
| Copywriting patterns (headline, CTA, pricing tier) | copywriting-patterns.md | `references/copywriting-patterns.md` | No | CREATE new |
| Business model articulation | research/business-model-patterns-2026.md (cache) + copywriting-patterns.md (apply) | `references/research/business-model-patterns-2026.md` (cached) | Yes (research) | REUSE research + CREATE thin wrapper in copywriting-patterns.md (note migration to skill `senior-bizmodel-architect-id` later) |
| Image prompt formulas | image-prompt-templates.md | `references/image-prompt-templates.md` | Yes | REUSE as-is |
| Anti-AI-slop visual rules | research/design-fundamentals-2026.md + visual-language.md (EXTEND) | `references/research/design-fundamentals-2026.md` + `references/visual-language.md` | Yes (research) | REUSE research + EXTEND visual-language.md to cite |
| Print readiness rules (CMYK, bleed, 300dpi) | research/pdf-print-production-2026.md + html-css-print-templates.md (new) | `references/research/pdf-print-production-2026.md` + `references/html-css-print-templates.md` | Yes (research) | REUSE research + CREATE html-css-print-templates.md to operationalize |
| Indonesian print context | research/indonesian-print-culture-2026.md + indonesian-context.md (EXTEND) | both | Yes (research) | REUSE research + EXTEND indonesian-context.md |
| Framework structures | research/framework-structures-2026.md | `references/research/framework-structures-2026.md` | Yes | REUSE research to inform 6 framework files |
| Per-skill ref loading | SKILL.md cheat sheet table | each `skills/<stage>/SKILL.md` | No (new structure) | DEFINE per skill in SKILL.md |
| Validator rubric (multi-mode) | scoring-rubric.md (EXTEND) | `references/scoring-rubric.md` | Yes | EXTEND with print-mode rubric |
| Plugin manifest | plugin.json | `.claude-plugin/plugin.json` | Yes | ✅ Already updated v0.3.0 |
| Session start announce | session-start.sh | `hooks/session-start.sh` | Yes | ✅ Already updated |

**CONTRACT**: Executor uses listed paths verbatim. If any "Yes" file is missing or doesn't have expected content, STOP and ask Ali — do NOT silently create a stub.

### Phase Overview

| Phase | Scope | Files Touched | Est. Time | Status (2026-05-22) |
|-------|-------|---------------|-----------|---------------------|
| A | Pre-flight (Ali manual rename + restart + state check) | 0 (Ali action) + 1 validation script | 10 min Ali + 5 min agent | ⏸ DEFERRED — Ali manual rename pending |
| B | Extend 4 existing references for multi-format scope | 4 files + 1 lint script | 60 min | ✅ DONE — Spec-Compliant + plan-verified |
| C | Build 8 framework files (6 new + 2 from deck-frameworks split) | 8 files + 1 lint + 1 deletion | 120 min | ✅ DONE — Spec-Compliant + plan-verified |
| D | Build 7 theme files | 7 files + 1 lint | 90 min | ✅ DONE — Spec-Compliant + plan-verified |
| E | Build 4 new top-level reference files | 4 files + extend lint (4→8 assertions) | 80 min | ✅ DONE — Spec-Compliant + plan-verified |
| F | Build 5 skill files (rebuild 4 + new copywriting) | 5 files + delete 4 old | 150 min | ⏳ QUEUED for next session |
| G | Rebuild agent | 1 file | 30 min | ⏳ QUEUED |
| H | Rewrite CLAUDE.md + README.md + update compile script | 3 files | 60 min | ⏳ QUEUED |
| I | Smoke test + git commit + final verification | sample runs + commit | 30 min | ⏳ QUEUED |
| **Total** | | **~30 new + 8 modified files** | **~10 hours focused work** | **B/C/D/E ✅ done · F-I queued** |

Phases B/C/D/E are independent (parallel-eligible) — executed via /gaspol-parallel mode=plan-phases on 2026-05-22 with 3-way parallel (B sequenced first, then C+D+E concurrent). F-I are sequential.

### Phase B-E Execution Report (2026-05-22)

| Metric | Result |
|---|---|
| Implementer agents | 4 (1 sequential B + 3 parallel C/D/E) |
| Spec reviewer agents | 4 (gaspol-dev:spec-reviewer) |
| Plan verifier | 1 (gaspol-dev:plan-verifier) blocking gate |
| Total files created | 23 markdown + 3 lint scripts |
| Total files modified | 4 references extended |
| Total files deleted | 1 (deck-frameworks.md after split) |
| Lint script assertions | 19 total (8 references + 8 frameworks + 7 themes) |
| Plan-verifier item count | FOUND=39 / PARTIAL=0 / MISSING=0 / DIVERGED=0 |
| Verdict | PASS ✅ |
| Wall-time | ~3 hours (vs ~5.5 hours sequential — 1.8× speedup) |

---

### Phase A: Pre-flight + State Check

**Estimated time:** 10 min Ali manual + 5 min agent validation

**Files:**
- Test: `scripts/check-merge-state.sh` (new validation script)

**Steps:**

1. **(Ali)** Close current Claude Code session.
2. **(Ali)** Run in PowerShell: `Rename-Item "D:\Projects\claude-plugin\pitch-deck-designer" "ai-business-document-designer"`
3. **(Ali)** Run in PowerShell: `Remove-Item "D:\Projects\claude-plugin\print-collateral-designer" -Recurse -Force` (if not already deleted)
4. **(Ali)** Re-open Claude Code in project. Verify SessionStart hook announces `ai-business-document-designer loaded. Skills available: ai-business-document-{brief,narrative,copywriting,gen,validate}`.
5. **(Agent)** Write failing test `scripts/check-merge-state.sh` that asserts: (a) folder exists at new name, (b) plugin.json name field = "ai-business-document-designer", (c) all 6 NotebookLM research files exist in `references/research/`, (d) old print-collateral-designer folder absent. Expected error initially: bash assertion fails because script doesn't exist.
6. **(Agent)** Run check, see fail.
7. **(Agent)** Implement validation script, run it. See pass.
8. **(Agent)** Commit: "chore(merge): add merge-state validation script + verify post-rename state"

**Verification:**
- [ ] `scripts/check-merge-state.sh` exits 0
- [ ] Folder is at `D:\Projects\claude-plugin\ai-business-document-designer\`
- [ ] `print-collateral-designer/` is deleted
- [ ] SessionStart hook announces ai-business-document-* skills (will fail until Phase F creates skill folders — re-verify after F)

---

### Phase B: Extend Existing References for Multi-Format Scope

**Estimated time:** 60 min

**Files:**
- Modify: `references/global-config.md`
- Modify: `references/visual-language.md`
- Modify: `references/scoring-rubric.md`
- Modify: `references/indonesian-context.md`
- Test: `scripts/lint-references.sh` (new — checks frontmatter, required sections)

**Steps:**

1. Write failing lint check `scripts/lint-references.sh` that asserts: `global-config.md` contains `output_type` enum with 8 values (deck-vc, deck-b2b, deck-hybrid, brochure-product, portfolio-personal, portfolio-agency, catalog-product, service-flyer, trifold-leaflet). Expected error: grep fails because enum doesn't exist yet.
2. Run lint, see fail.
3. Edit `references/global-config.md`: add `## Output Types (multi-format)` section with 8-value enum + aspect ratio + page count default per output_type + theme registry section with 7 named themes. Append print-specific banned vocab additions to existing banned list (e.g., "next-gen", "cutting-edge"). Add `## PDF Output Modes` section: HTML+CSS (Playwright), full-image (NB2 per page), spec-only (JSON for Canva/Figma).
4. Run lint, see pass for `global-config.md` check.
5. Add lint check for `visual-language.md`: must contain section `## Print-Specific Visual Rules` with subsections (CMYK, bleed/safe-zone, 300dpi, font embedding, vector vs raster). Expected fail.
6. Edit `references/visual-language.md`: add `## Print-Specific Visual Rules` section that summarizes + cites `research/design-fundamentals-2026.md` and `research/pdf-print-production-2026.md`. Add §3 "Anti-AI-Slop Banlist for Print" with 8 patterns from research/design-fundamentals-2026 §7.
7. Run lint, see pass.
8. Add lint check for `scoring-rubric.md`: must contain `## Print-Mode Rubric` distinct from existing investor-deck rubric, with 5 sub-categories (Visual Ratio 25 + Framework Fit 15 + CTA Clarity 15 + Print Readiness 20 + Anti-AI-Slop 25 = 100). Expected fail.
9. Edit `references/scoring-rubric.md`: append Print-Mode Rubric. Add Mode Detection table at top (how to pick rubric based on output_type).
10. Run lint, see pass.
11. Add lint check for `indonesian-context.md`: must contain section `## Print Production Specifics` (paper stock, printer SOP, regulatory disclaimer). Expected fail.
12. Edit `references/indonesian-context.md`: append Print Production Specifics, citing `research/indonesian-print-culture-2026.md`.
13. Run lint, see pass.
14. Commit: "feat(refs): extend global-config + visual-language + scoring-rubric + indonesian-context for multi-format scope"

**Verification:**
- [ ] `scripts/lint-references.sh` passes all 4 checks
- [ ] All 4 files reference research cache via path `references/research/<slug>-2026.md`
- [ ] No banned vocabulary in new sections
- [ ] No TODO/placeholder language
- [ ] Markdown renders correctly (preview check in VSCode)

---

### Phase C: Build Framework Library (8 Files)

**Estimated time:** 120 min (15 min/file)

**Files:**
- Create: `references/frameworks/deck-vc.md` (split from deck-frameworks.md VC section)
- Create: `references/frameworks/deck-b2b.md` (split from deck-frameworks.md B2B section)
- Create: `references/frameworks/brochure-product.md` (NEW — INDUSIA pattern)
- Create: `references/frameworks/portfolio-personal.md` (NEW)
- Create: `references/frameworks/portfolio-agency.md` (NEW)
- Create: `references/frameworks/service-flyer.md` (NEW)
- Create: `references/frameworks/catalog-product.md` (NEW)
- Create: `references/frameworks/trifold-leaflet.md` (NEW)
- Delete: `references/deck-frameworks.md` (after split)
- Test: `scripts/lint-frameworks.sh` (checks per-file schema: 7-step content checklist, do-NOT patterns, real example reference, YAML frontmatter)

**Per-framework schema (validated by lint):**
```yaml
---
slug: <slug>
output_type: <enum>
aspect_ratio: <16:9 | A4-portrait | A4-landscape | trifold-A3>
default_page_count: <int or range>
target_audience: <description>
mandatory_pages: [list]
optional_pages: [list]
---
```

Plus required sections: `## Narrative Arc / Page Sequence`, `## 7-Step Content Checklist`, `## Do-NOT Patterns (3+)`, `## Real-World Example Reference`, `## Anti-Slop Hard Rules`.

**Steps (per file — repeat 8 times):**
1. Write failing lint check for the file. Expected: file doesn't exist or missing required section.
2. Run lint, see fail.
3. Author file content (15 min): pull narrative structure from `research/framework-structures-2026.md`, copywriting patterns from `research/business-model-patterns-2026.md` (for pricing-tier frameworks), Indonesian context from `research/indonesian-print-culture-2026.md`.
4. Run lint, see pass.
5. Commit after each file: `feat(frameworks): add <slug>.md framework definition`

**Final step**: Delete old `references/deck-frameworks.md` after both deck-vc.md and deck-b2b.md verified equivalent + extended. Commit: "refactor(frameworks): split deck-frameworks.md into per-framework files"

**Verification:**
- [ ] `scripts/lint-frameworks.sh` passes for all 8 files
- [ ] Each file has YAML frontmatter with valid output_type enum value
- [ ] Each file has 7-step content checklist
- [ ] Each file has ≥3 do-NOT patterns
- [ ] Each file cites ≥1 real-world example (with source URL)
- [ ] `references/deck-frameworks.md` deleted
- [ ] No banned vocabulary
- [ ] No TODO/placeholder language

---

### Phase D: Build Theme Library (7 Files)

**Estimated time:** 90 min (12 min/theme)

**Files:**
- Create: `references/themes/indusia-tech.md`
- Create: `references/themes/minimalist-editorial.md`
- Create: `references/themes/industrial-brutalist.md`
- Create: `references/themes/premium-luxe.md`
- Create: `references/themes/pastel-soft.md`
- Create: `references/themes/brutalist-mono.md`
- Create: `references/themes/indo-tropical.md`
- Test: `scripts/lint-themes.sh`

**Per-theme schema (validated):**
```yaml
---
slug: <slug>
name: <display name>
mood: <2-4 keywords>
suitable_for: [output_type list]
suitable_audience: <description>
---
```

Required sections: `## Color Palette` (4-6 hex values + roles: primary/secondary/accent/text/background), `## Typography` (3-tier pairing — display/body/mono — with specific font names), `## Illustration Style` (isometric/flat/photographic/etc + reference anchor description), `## Layout Grammar` (grid rules, spacing scale), `## Anti-AI-Slop Banlist for This Theme` (3+ patterns specific to theme), `## Real-World Reference` (brand/agency that exemplifies this theme).

**Steps (per theme — repeat 7 times):**
1. Write failing lint check.
2. Run, see fail.
3. Author theme file. Pull color psychology from `research/design-fundamentals-2026.md §4`, typography guidance from §3, anti-AI-slop banlist from §7.
4. Run lint, see pass.
5. Commit: `feat(themes): add <slug> theme preset`

**Verification:**
- [ ] `scripts/lint-themes.sh` passes
- [ ] Each theme has exact hex color codes (no "blue" — must be `#1E3A8A`)
- [ ] Each theme cites specific font names with weight/style (e.g., `Inter 600 Semibold`)
- [ ] Each theme has theme-specific anti-AI-slop rules (not just copy of global)
- [ ] Each theme has at least 1 real-brand reference

---

### Phase E: Build New Top-Level Reference Files

**Estimated time:** 80 min

**Files:**
- Create: `references/layout-grammar.md`
- Create: `references/html-css-print-templates.md`
- Create: `references/copywriting-patterns.md`
- Create: `references/business-model-patterns.md` (thin wrapper — migration TODO marker)
- Test: extend `scripts/lint-references.sh` with checks for these 4 new files

**Steps:**
1. Write failing lint check for `layout-grammar.md`: requires sections `## Grid Systems`, `## Typography Hierarchy`, `## Visual Flow (Z/F/Gutenberg)`, `## White Space Discipline`. Expected fail.
2. Run, see fail.
3. Author `layout-grammar.md` (~250 lines): synthesize from `research/design-fundamentals-2026.md §2-§6`. Add concrete CSS examples + ASCII grid diagrams.
4. Run lint, see pass. Commit: `feat(refs): add layout-grammar.md`
5. Write failing lint check for `html-css-print-templates.md`: requires sections `## @page Rules`, `## Bleed CSS`, `## Print Color Profile`, `## Playwright PDF Options`, `## Fallback Patterns`. Expected fail.
6. Author `html-css-print-templates.md` (~300 lines): synthesize from `research/pdf-print-production-2026.md`. Include actual CSS code blocks + Playwright code snippets.
7. Run lint, see pass. Commit: `feat(refs): add html-css-print-templates.md`
8. Write failing lint check for `copywriting-patterns.md`: requires sections `## Headline Formula`, `## Sub-text Discipline`, `## CTA Patterns`, `## Pricing Tier Articulation`, `## Bilingual Convention`. Expected fail.
9. Author `copywriting-patterns.md` (~250 lines): synthesize from `research/business-model-patterns-2026.md §7 (brochure articulation)` + `research/indonesian-print-culture-2026.md §6 (headline convention)`.
10. Run lint, see pass. Commit: `feat(refs): add copywriting-patterns.md`
11. Author `business-model-patterns.md` as THIN wrapper that points to `research/business-model-patterns-2026.md` + adds top-level note: "⚠️ MIGRATION TODO (2026-Q3): full content will move to skill `senior-bizmodel-architect-id` in `D:\Projects\indusia-skills\skills\`. This file is local cache for plugin until that skill exists."
12. Commit: `feat(refs): add business-model-patterns.md (thin wrapper, migration TODO)`

**Verification:**
- [ ] `scripts/lint-references.sh` passes all 4 new file checks
- [ ] `html-css-print-templates.md` has runnable CSS + Playwright code samples (not pseudocode)
- [ ] `copywriting-patterns.md` includes ≥10 headline formula examples in Bahasa Indonesia + English
- [ ] `business-model-patterns.md` has explicit MIGRATION TODO marker
- [ ] No banned vocabulary
- [ ] No TODO/placeholder beyond intentional migration markers

---

### Phase F: Build 5 Skill Files

**Estimated time:** 150 min (30 min/skill)

**Files:**
- Create: `skills/ai-business-document-brief/SKILL.md`
- Create: `skills/ai-business-document-narrative/SKILL.md`
- Create: `skills/ai-business-document-copywriting/SKILL.md` (NEW — no precedent)
- Create: `skills/ai-business-document-gen/SKILL.md`
- Create: `skills/ai-business-document-validate/SKILL.md`
- Delete: `skills/pitch-deck-brief/`, `skills/pitch-deck-storyline/`, `skills/pitch-deck-gen/`, `skills/pitch-deck-validate/` (after new skills verified)
- Test: `scripts/lint-skills.sh` (validates SKILL.md structure)

**Per-SKILL.md schema (validated):**
- Frontmatter with `name`, `description` (≥100 char), `triggers` (keyword list)
- `## Announce at Start` (exact phrase template)
- `## Inputs` (file paths/CLI flags)
- `## Outputs` (file paths + JSON schema reference)
- `## Pre-checks` (mandatory reads — output_type-aware)
- `## Pipeline Modes` (interactive vs pipeline-CLI vs batch)
- `## Hard Rules` (per-stage rules)
- `## Reference Loading Cheat Sheet` (per-output_type, which refs to inject)

**Steps for brief skill (F1):**
1. Write failing lint check for `skills/ai-business-document-brief/SKILL.md`. Expected: file doesn't exist.
2. Run lint, see fail.
3. Author SKILL.md (~250-350 lines). Pattern: read existing `skills/pitch-deck-brief/SKILL.md` as starting point, then extend with multi-output-type detection logic. Output_type detection questions in `## Discovery Q&A` section: target audience, content type, distribution channel (offline vs online), page count, language.
4. Run lint, see pass.
5. Commit: `feat(skill): add ai-business-document-brief (Stage 1 discovery)`

**Steps for narrative skill (F2):** Same pattern. Merge storyline (deck narrative arc) + layout (multi-page wireframe). Output_type routes to: narrative-arc mode (for deck-*) or modular-page mode (for brochure/portfolio/catalog/flyer/trifold). HUMAN APPROVAL GATE before next stage.

**Steps for copywriting skill (F3 — NEW):** No precedent — author from scratch. Reads `copywriting-patterns.md` + `business-model-patterns.md` (if pricing tier in brief) + `indonesian-context.md`. HUMAN APPROVAL GATE before gen.

**Steps for gen skill (F4):** Read existing `skills/pitch-deck-gen/SKILL.md` as starting point. Add output_type-aware routing: HTML+CSS Playwright path / full-image NB2 path / spec-JSON path. Read existing `image-prompt-templates.md`, plus new `html-css-print-templates.md`.

**Steps for validate skill (F5):** Read existing `skills/pitch-deck-validate/SKILL.md` as starting point. Add mode-detection routing to pick rubric: deck-rubric vs print-rubric. Hard-fail rules per mode.

**After all 5 verified, delete old skill folders:**
6. Lint check that asserts 5 new SKILL.md exist + 0 old pitch-deck-* skill folders exist. Expected fail (old folders still there).
7. Delete 4 old skill folders.
8. Run lint, see pass.
9. Commit: `refactor(skills): remove deprecated pitch-deck-* skill folders (superseded by ai-business-document-*)`

**Verification:**
- [ ] `scripts/lint-skills.sh` passes all 5 new SKILL.md
- [ ] Each SKILL.md has frontmatter + 8 required sections
- [ ] Each SKILL.md has `## Reference Loading Cheat Sheet` table specifying which refs load per output_type
- [ ] Brief skill has `## Discovery Q&A` with output_type detection logic
- [ ] Narrative skill has HUMAN APPROVAL GATE section
- [ ] Copywriting skill has HUMAN APPROVAL GATE section
- [ ] Gen skill has 3 output-mode paths (HTML / image / spec)
- [ ] Validate skill has mode-detection routing
- [ ] All 4 old pitch-deck-* skill folders deleted
- [ ] SessionStart hook re-runs and announces 5 ai-business-document-* skills (no error)

---

### Phase G: Rebuild Agent

**Estimated time:** 30 min

**Files:**
- Create: `agents/ai-business-document-agent.md`
- Delete: `agents/pitch-deck-designer-agent.md`
- Test: extend `scripts/lint-skills.sh` to validate agent file structure

**Steps:**
1. Write failing lint check that requires `agents/ai-business-document-agent.md` to exist and contain inlined all 5 SKILL.md (self-contained pattern). Expected fail.
2. Run, see fail.
3. Author agent file. Pattern: read existing `agents/pitch-deck-designer-agent.md`, then extend with multi-output-type handling + variant batch (e.g., 1 product brochure + 3 portfolio variants in single invocation).
4. Run lint, see pass.
5. Delete old `agents/pitch-deck-designer-agent.md`.
6. Commit: `refactor(agent): rebuild as ai-business-document-agent with multi-format batch support`

**Verification:**
- [ ] Agent file has all 5 SKILL.md content inlined
- [ ] Agent supports batch (multi-variant) mode
- [ ] Old agent file deleted
- [ ] SessionStart hook announces `ai-business-document-agent` (not pitch-deck-designer-agent)

---

### Phase H: Rewrite CLAUDE.md + README.md + Compile Script

**Estimated time:** 60 min

**Files:**
- Modify: `CLAUDE.md` (heavy rewrite)
- Modify: `README.md` (heavy rewrite)
- Modify: `scripts/compile-references.sh` (extend to handle frameworks/ + themes/ subfolders)
- Test: `scripts/lint-claude-md.sh` (validates CLAUDE.md structure)

**Steps:**
1. Write failing lint check `scripts/lint-claude-md.sh`: requires sections `## Project Overview`, `## Architecture` (with 30+ row file table), `## Output Types & Frameworks Matrix`, `## 5-stage pipeline`, `## Hard Rules`, `## Reference files cheat sheet (per stage, per output_type)`, `## Common failure modes`, `## Refresh / maintenance`. Expected fail (existing CLAUDE.md has pitch-deck-only scope).
2. Run, see fail.
3. Rewrite `CLAUDE.md`: keep top-level Vault Context Link, then rewrite Project Overview for multi-format, expand Architecture table to 30+ rows covering all new files, add Output Types & Frameworks Matrix (table mapping output_type → framework file → mandatory refs), expand Hard Rules to include print-readiness (CMYK, bleed, 300dpi), rewrite Reference files cheat sheet to be per-stage AND per-output_type, expand Common failure modes table with print-specific failures.
4. Run lint, see pass.
5. Rewrite `README.md`: similar scope expansion. Show 6 example use cases (one per major framework). Include rendered demo links.
6. Extend `scripts/compile-references.sh`: handle `frameworks/` and `themes/` subfolders for compiled bundle generation.
7. Test compile script: run it, verify output exists in `references/compiled/`.
8. Commit: `docs: rewrite CLAUDE.md + README.md for ai-business-document-designer multi-format scope`
9. Commit: `chore(scripts): extend compile-references.sh for frameworks/ + themes/`

**Verification:**
- [ ] `scripts/lint-claude-md.sh` passes
- [ ] CLAUDE.md Architecture table has ≥30 rows
- [ ] CLAUDE.md has Output Types & Frameworks Matrix
- [ ] README.md has ≥6 example use cases
- [ ] compile-references.sh produces valid bundles
- [ ] No banned vocabulary
- [ ] No TODO/placeholder

---

### Phase I: Smoke Test + Final Verification + Git Commit

**Estimated time:** 30 min

**Files:**
- Test: `scripts/smoke-test.sh` (orchestrates sample runs)
- No new files; final commit + tag

**Steps:**
1. Write `scripts/smoke-test.sh` that runs 3 sample workflows:
   - **Regression**: pitch-deck-vc with sample brief → narrative → gen → validate (expect ≥70 score)
   - **New**: brochure-product with sample brief (mimicking INDUSIA) → narrative (modular layout) → copywriting (with pricing tier from business-model-patterns) → gen → validate (expect ≥70 score)
   - **New**: portfolio-personal with sample brief → narrative → copywriting → gen → validate (expect ≥70 score)
2. Run smoke-test, see fails (expected — running real skills may need API keys for image gen; if so, mock the gen stage with `--dry-run` flag).
3. Iterate until smoke test passes all 3 workflows OR confirms expected-fail (e.g., gen stage skipped due to no API).
4. Commit: `test: add smoke-test.sh covering regression + 2 new format workflows`
5. Tag git release: `git tag v0.3.0-merge-print-collateral` + push: `git push origin v0.3.0-merge-print-collateral` (Ali approval needed for push)
6. Update design doc: mark all phases as ✅ DONE in this file.

**Verification:**
- [ ] `scripts/smoke-test.sh` passes (or documents skipped stages with rationale)
- [ ] Regression workflow (pitch-deck-vc) still works — no breaking change
- [ ] 2 new workflows (brochure-product + portfolio-personal) produce expected outputs
- [ ] All lint scripts pass: `lint-references.sh`, `lint-frameworks.sh`, `lint-themes.sh`, `lint-skills.sh`, `lint-claude-md.sh`
- [ ] Git tagged + pushed (if Ali approves)
- [ ] Design doc updated with Phase Status table

---

### Red Flag Self-Check (Plan Quality)

| Check | Status |
|-------|--------|
| Data Integration Map present | ✅ Yes — 16 rows |
| Per-phase verification block present | ✅ All 9 phases |
| References to CLAUDE.md (existing pitch-deck) | ✅ Phase B + Phase H |
| Vague data sources | ❌ All paths explicit |
| Test/lint steps in every phase | ✅ Per-phase lint or smoke check |
| Phase >15 min code-time | ⚠️ Phases C/D/E/F exceed for doc-writing pace — broken into sub-steps per file (file = 12-30 min) |
| Placeholder language | ❌ Only intentional migration TODO marker for business-model-patterns.md (linked to skill `senior-bizmodel-architect-id`) |

### Execution Handoff

**Option 1 — Execute in this session**: ❌ Not recommended. 9 phases × ~10 hours total work would exhaust context window. Phase A requires Ali manual action first.

**Option 2 — Parallel execution**: ✅ Phases B/C/D/E are independent — can be dispatched in parallel via `gaspol-parallel` once Phase A done. Phase F-I sequential after parallel block.

**Option 3 — Separate session (Recommended)**: Save plan, Ali does Phase A manually + restarts session, then run `gaspol-execute` (or `gaspol-parallel` for B-E batch). The plan file at `docs/plans/2026-05-21-ai-business-document-designer.md` has everything the executor needs (Data Integration Map + per-phase verification).

**Recommended next command in fresh session after Phase A**: `/gaspol-parallel` with mode=plan-phases targeting Phases B+C+D+E (estimated 4× wall-time speedup since independent), then sequentially `/gaspol-execute` for F → G → H → I.
