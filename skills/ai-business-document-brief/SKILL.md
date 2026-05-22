---
name: ai-business-document-brief
description: Stage 1 — Discovery for the ai-business-document-designer pipeline. Use when starting any new business document (pitch deck, brochure, portfolio, catalog, flyer, trifold leaflet) and you need to scope output_type across the 9-enum (deck-vc / deck-b2b / deck-hybrid / brochure-product / portfolio-personal / portfolio-agency / catalog-product / service-flyer / trifold-leaflet), select a theme preset from the 7-theme registry, set audience mode, choose language (Bahasa Indonesia primary / English / bilingual), and lock the ask / CTA. Outputs structured brief.json that downstream skills (storyline, copywriting, gen, validate) consume. Replaces pitch-deck-brief as the single entry point.
triggers: [pitch-deck, brochure, portfolio, flyer, catalog, trifold, leaflet, brief, discovery, scope, pitch-deck-brief, document-brief, brochure-brief, business-document, ai-business-document, ai-business-document-brief, plan-document, rancang-brosur, rancang-portfolio, rancang-deck]
---

# AI Business Document Brief — Stage 1: Discovery

Stage 1 of 5. Discovers the operator's intent across the full 9-output-type enum, selects framework + theme + language, and emits `brief.json`. Downstream skills (`ai-business-document-narrative`, `ai-business-document-copywriting`, `ai-business-document-gen`, `ai-business-document-validate`) consume this output. Never skip directly from brief to gen — narrative + copywriting must come in between.

> **Where this fits:** `ai-business-document-brief` → `ai-business-document-narrative` → `ai-business-document-copywriting` → `ai-business-document-gen` → `ai-business-document-validate`. See plugin `CLAUDE.md` for the full pipeline.

---

## Announce at Start

> "I'm using the ai-business-document-brief skill to discover the brief."

This announcement is mandatory on first turn so the operator sees which skill is driving the conversation.

---

## Inputs

The skill accepts ONE or MORE of the following on first invocation:

1. **One-paragraph operator brief** (free text) — the preferred starting point. Example: *"I need a 6-page brochure for INDUSIA's pneumatic actuator product line targeting palm oil mill engineers in Riau, Bahasa Indonesia, premium-luxe theme."*
2. **CLI flags** (any subset, all optional):
   - `--output-type <slug>` — pre-set output_type (one of 9 enum values from `references/global-config.md` §15); skips Q1-Q4
   - `--audience <text>` — short audience descriptor (skips Q5)
   - `--theme <slug>` — one of 7 themes from `references/global-config.md` §16 (skips Q6)
   - `--language <id|en|bilingual>` — locks language (skips Q8)
   - `--output-dir <path>` — where to write `brief.json` (default: current working directory or `/tmp/`)
   - `--brief-file <path>` — pre-filled `brief.json` for pipeline-CLI / batch mode; skips ALL Q&A
3. **Reference image attached** (optional) — e.g., a pattern-match brochure ("make it feel like this INDUSIA brochure but for our product"). The skill reads dominant layout grammar, palette family, and typography signal from the image and pre-fills Q6 (theme) + style notes.

If none of (1)/(2)/(3) is supplied, the skill starts with Q1.

---

## Outputs

Writes a single artifact: **`brief.json`** (path: `{--output-dir}/brief.json` or `./brief.json` or `/tmp/brief.json`).

**JSON schema (Schema 2.0 — multi-output):**

```json
{
  "schema_version": "2.0",
  "doc_id": "{kebab-case product or document name}-{output_type}-{YYYYMMDD}",
  "created_at": "{ISO 8601 timestamp}",
  "output_type": "deck-vc | deck-b2b | deck-hybrid | brochure-product | portfolio-personal | portfolio-agency | catalog-product | service-flyer | trifold-leaflet",
  "audience": {
    "description": "{1-2 sentence operator description of who reads this}",
    "mode": "{vc | b2b | b2c | mixed}",
    "decision_action": "{what the reader is being asked to do}"
  },
  "theme": "{indusia-tech | minimalist-editorial | industrial-brutalist | premium-luxe | pastel-soft | brutalist-mono | indo-tropical | custom}",
  "theme_custom_notes": "{filled only if theme = custom}",
  "language_default": "id | en",
  "language_options": ["id", "en"],
  "bilingual_flag": false,
  "ask_or_cta": {
    "type": "vc-round | b2b-pilot | b2b-rollout | brochure-leadgen | portfolio-hire-inquiry | catalog-order | flyer-walk-in | leaflet-mailer",
    "specific_action": "{e.g. 'WhatsApp +62 813… to schedule site survey'}",
    "deadline": "{ISO 8601 date or null}"
  },
  "page_count": 8,
  "mandatory_pages": ["..."],
  "optional_pages": ["..."],
  "key_facts": [
    {"label": "Product name", "value": "..."},
    {"label": "One-line", "value": "..."},
    {"label": "Traction / proof", "value": "...", "source": "..."}
  ],
  "pattern_match_reference": "We are [X] for [Y]",
  "style_preference": "{free-text operator note — e.g. 'feels editorial, minimal motion'}",
  "mode_detection_confidence": "high | medium | low",
  "indonesian_context": true,
  "pricing_tier_present": false,
  "output_mode_hint": "html-css | full-image | spec-only",
  "warnings": []
}
```

The next skill in the pipeline (`ai-business-document-narrative`) refuses to start without a valid `brief.json` matching schema 2.0.

---

## Pre-checks (mandatory reads, before Q&A)

Before the first question is asked, load the following reference files via the Read tool. **Order matters**:

1. **ALWAYS** read first: `references/global-config.md` — confirms output_type enum (§15), theme registry (§16), forbidden vocabulary (§4), PDF output modes (§17).
2. **Output-type-conditional** — read only after Q1-Q4 narrows the slug:
   - If operator mentions "brochure" / "brosur" → `references/frameworks/brochure-product.md`
   - If "portfolio" → `references/frameworks/portfolio-personal.md` AND `references/frameworks/portfolio-agency.md` (need both to ask Q3)
   - If "catalog" / "katalog" → `references/frameworks/catalog-product.md`
   - If "flyer" / "selebaran" → `references/frameworks/service-flyer.md`
   - If "trifold" / "leaflet" / "DL envelope" → `references/frameworks/trifold-leaflet.md`
   - If "pitch deck" / "investor" / "VC" → `references/frameworks/deck-vc.md`
   - If "B2B deck" / "channel partner" / "venue operator" → `references/frameworks/deck-b2b.md`
3. **Language-conditional** — if any signal of Indonesian context (see §3 below):
   - `references/indonesian-context.md`
   - `references/research/indonesian-print-culture-2026.md`
4. **Pricing-tier-conditional** — if operator mentions tiers / paket / harga / pricing:
   - `references/business-model-patterns.md` *(thin wrapper note: future migration to `senior-bizmodel-architect-id` skill is planned; for now read this file directly)*
5. **Narrative-depth conditional** — if the operator asks for "premium narrative" / "story-led" / "editorial":
   - `references/research/framework-structures-2026.md`

Do not bulk-read all references — load by trigger only.

---

## Discovery Q&A (output_type detection logic)

Use the `AskUserQuestion` tool for each Q (single-question mode unless bundling is natural). Run questions in the order below. If a CLI flag pre-fills the answer, skip that Q silently.

### Q1 — Distribution channel
> "What is the distribution channel for this document — (a) **offline print** (handed to a prospect at a meeting or event booth, printed on A4 / A3 paper), (b) **online digital** (PDF sent via WhatsApp / email / website download), OR (c) **presentation** (slide deck shown via projector or screen-share)?"

Routes:
- `a` → continue to Q2 (print formats)
- `b` → ask Q1b: "Is the digital PDF a deck (16:9 slides) or a print-format PDF (A4 / A3 pages)?" → routes to either Q4 (deck) or Q2 (print)
- `c` → skip to Q4 (deck formats)

### Q2 — Print format type (only if Q1 = print)
> "Which print format? (a) **Multi-page brochure** (≥3 pages, modular product / service description), (b) **Single-page flyer** (1-2 pages, one core offer above-the-fold), (c) **Portfolio** (case-study showcase), (d) **Product catalog** (grid of items with SKU + price), OR (e) **Trifold leaflet** (folded A3, 6 panels, DL envelope size)?"

Routes:
- `a` → `output_type = brochure-product`; continue to Q5
- `b` → `output_type = service-flyer`; continue to Q5
- `c` → continue to Q3
- `d` → `output_type = catalog-product`; continue to Q5
- `e` → `output_type = trifold-leaflet`; continue to Q5

### Q3 — Portfolio audience (only if Q2 = portfolio)
> "Is this a **personal portfolio** (individual designer / consultant / freelancer showcasing your own work) OR an **agency portfolio** (multi-person team showcasing service offerings, with case studies attributed to the firm)?"

Routes:
- personal → `output_type = portfolio-personal`
- agency → `output_type = portfolio-agency`

Then continue to Q5.

### Q4 — Deck audience (only if Q1 = presentation or deck PDF)
> "Is this an **investor pitch** (raising an equity round — pre-seed / seed / Series A / Series B), a **B2B sale** (channel partner / venue operator / corporate adoption — pilot or rollout), OR a **hybrid** (both investors and B2B prospects will see the same deck)?"

Routes:
- investor → `output_type = deck-vc`
- b2b → `output_type = deck-b2b`
- hybrid → `output_type = deck-hybrid`

Then continue to Q5.

### Q5 — Audience description
> "Describe the target reader in 1-2 sentences — who specifically reads this, and what decision do they make after reading? (Example: 'Procurement managers at palm oil mills in Riau evaluating whether to RFQ our actuator product line within the next 60 days.')"

Stored in `audience.description` + `audience.decision_action`.

### Q6 — Theme preset
> "Pick a theme preset from the 7 named themes, OR describe a custom theme. The 7 are: **indusia-tech** (technical / premium / B2B-credible — navy + cyan + gold, isometric 3D), **minimalist-editorial** (calm / considered — cream + ink, serif display, heavy whitespace), **industrial-brutalist** (raw / mechanical — black + white + signal red, mono + grotesk, grid-violations), **premium-luxe** (gallery / wealthy — gold + ivory + warm black, thin serif), **pastel-soft** (friendly / consumer — soft pastels, rounded sans), **brutalist-mono** (type-only / anti-design — black + white + one signal), **indo-tropical** (Indonesian / warm — earth tones + batik motif accents). Or say 'custom' and describe your preference."

If `custom`, capture free-text in `theme_custom_notes`.

### Q7 — Page count
> "How many pages / slides? Default range for **{output_type}** per `references/global-config.md` §15 is **{range}** — confirm or override."

Lookup table (auto-fill in question):
- deck-vc / deck-b2b / deck-hybrid: 10-13 slides
- brochure-product: 5-10 pages
- portfolio-personal / portfolio-agency: 8-20 pages
- catalog-product: 8-24 pages
- service-flyer: 1-2 pages
- trifold-leaflet: 6 panels (fixed)

### Q8 — Language
> "Language — (a) **Bahasa Indonesia** (default for Indonesian audience), (b) **English** (cross-border / international readers), OR (c) **bilingual ID+EN** (side-by-side or sequential pages)?"

Routes:
- `a` → `language_default = "id"`, `bilingual_flag = false`
- `b` → `language_default = "en"`, `bilingual_flag = false`
- `c` → `language_default = "id"`, `language_options = ["id", "en"]`, `bilingual_flag = true`

If any of these signals appear in operator input — `indonesia` / `jakarta` / `surabaya` / `medan` / `bandung` / `riau` / `bahasa` / `IDR` / `rupiah` / `Rp` / `mall` / `EO` / `bazaar` / `venue` / `palm oil` / `sawit` — set `indonesian_context: true` automatically and surface for confirmation.

### Q9 — Pricing tier
> "Does this document show pricing? IF YES: how many tiers (e.g., 3 — Basic / Pro / Enterprise), what is the spread (lowest → highest), and what currency (IDR primary, USD secondary)?"

If yes, set `pricing_tier_present: true` and trigger pre-check #4 (read `business-model-patterns.md`).

### Q10 — Ask / CTA
> "What action should the reader take after reading? Be specific. (Examples: 'WhatsApp +62 813… to schedule a site survey', 'sign Series A term sheet by 15 July', 'walk into our showroom in Pluit', 'place an order via the order form on the back page'.)"

Stored in `ask_or_cta.specific_action` + `ask_or_cta.type` (mapped to the enum in the schema).

---

## Pipeline Modes

The skill supports three execution modes. The mode is selected at invocation; default is interactive.

### Mode A — Interactive (default)
The operator drives the conversation; the skill asks Q1-Q10 via `AskUserQuestion` tool, one at a time. This is the production mode for human-led briefs.

### Mode B — Pipeline-CLI (`--brief-file <path>`)
A pre-filled `brief.json` (schema 2.0) is supplied by the caller (e.g., a parent automation script or the `ai-business-document-agent`). The skill:
1. Validates schema 2.0 conformance
2. Runs sanity checks (output_type in enum, theme in registry, language in {id, en, bilingual})
3. Loads conditional references per §Pre-checks
4. Skips Q&A entirely
5. Emits the same `brief.json` to output_dir (passthrough + validated)

Use case: regression-test fixture playback, multi-variant batch.

### Mode C — Batch (multi-variant)
Invoked by the upstream `ai-business-document-agent` (Phase G) for parallel generation of variants (e.g., 3 brochure themes for A/B test). The agent supplies an array of `brief.json` files; this skill processes each in pipeline-CLI semantics and writes per-variant output dirs.

---

## Hard Rules

1. **ALWAYS detect output_type before any other Q.** Audience, theme, language, ask — all depend on output_type. Get the output_type wrong and every downstream framework, layout grammar, and copy pattern is mis-routed.
2. **NEVER assume audience mode without explicit user input.** Even if the operator paragraph clearly says "investor pitch," surface the inferred mode at Q4 and ask for confirmation. Operators override.
3. **Output_type enum must be one of 9 valid values** from `references/global-config.md` §15: `deck-vc`, `deck-b2b`, `deck-hybrid`, `brochure-product`, `portfolio-personal`, `portfolio-agency`, `catalog-product`, `service-flyer`, `trifold-leaflet`. Anything else is a schema violation.
4. **Theme must be one of 7 named slugs** from `references/global-config.md` §16, OR set `theme = "custom"` with mandatory `theme_custom_notes`. No silent custom themes.
5. **If `language_default = "id"` OR any Indonesian signal triggers**, set `indonesian_context: true`. This auto-loads `references/indonesian-context.md` + `references/research/indonesian-print-culture-2026.md` in the downstream `ai-business-document-narrative` and `ai-business-document-copywriting` skills.
6. **`brief.json` MUST validate against schema 2.0** (see §Outputs). The downstream `ai-business-document-narrative` skill refuses to start on schema-mismatch.
7. **NEVER write narrative, copy, or layout in this stage.** This skill only discovers. Narrative design happens in `ai-business-document-narrative`; copy happens in `ai-business-document-copywriting`. Crossing the boundary corrupts the pipeline.
8. **Banned vocabulary check** — before writing `brief.json`, scan operator-supplied text fields (`audience.description`, `pattern_match_reference`, `style_preference`, `ask_or_cta.specific_action`) against the forbidden list in `references/global-config.md` §4. Surface a warning in `warnings[]` if any banned word is detected; suggest a concrete replacement.

---

## Reference Loading Cheat Sheet (per-output_type)

After Q&A locks `output_type`, the downstream skills will load this exact reference set. The brief skill itself loads (1) `global-config.md` + (2) the framework file for the chosen output_type. The rest are passed forward as a manifest in `brief.json` (implicit via `output_type`).

| output_type | Mandatory reads (after Q&A) |
|---|---|
| deck-vc | references/global-config.md, references/frameworks/deck-vc.md, references/investor-psychology.md, references/storyline-frameworks.md, references/research/investor-pitch-deck-best-practices-2026.md |
| deck-b2b | references/global-config.md, references/frameworks/deck-b2b.md, references/b2b-channel-partner-playbook.md, references/storyline-frameworks.md |
| deck-hybrid | references/global-config.md, references/frameworks/deck-vc.md, references/frameworks/deck-b2b.md, references/investor-psychology.md, references/b2b-channel-partner-playbook.md |
| brochure-product | references/global-config.md, references/frameworks/brochure-product.md, references/layout-grammar.md, references/copywriting-patterns.md, references/business-model-patterns.md, references/research/business-model-patterns-2026.md, references/research/framework-structures-2026.md, references/indonesian-context.md (if ID) |
| portfolio-personal | references/global-config.md, references/frameworks/portfolio-personal.md, references/layout-grammar.md, references/copywriting-patterns.md, references/research/framework-structures-2026.md |
| portfolio-agency | references/global-config.md, references/frameworks/portfolio-agency.md, references/layout-grammar.md, references/copywriting-patterns.md, references/research/framework-structures-2026.md |
| catalog-product | references/global-config.md, references/frameworks/catalog-product.md, references/layout-grammar.md, references/business-model-patterns.md, references/research/business-model-patterns-2026.md |
| service-flyer | references/global-config.md, references/frameworks/service-flyer.md, references/layout-grammar.md, references/copywriting-patterns.md, references/research/framework-structures-2026.md |
| trifold-leaflet | references/global-config.md, references/frameworks/trifold-leaflet.md, references/layout-grammar.md, references/copywriting-patterns.md, references/research/framework-structures-2026.md |

> The brief skill writes the chosen `output_type` to `brief.json`. The downstream `ai-business-document-narrative` skill reads that field and loads the matching row from this table.

---

## Hand-off to Stage 2

After emitting `brief.json`, the skill prints to operator:

```
brief.json saved to {path}.

output_type:  {output_type}
audience:     {audience.description}
theme:        {theme}
language:     {language_default} (bilingual: {bilingual_flag})
page_count:   {page_count}
ask / CTA:    {ask_or_cta.specific_action}

Next: run /ai-business-document-narrative to design the document narrative arc and page-by-page outline.
DO NOT run /ai-business-document-gen yet — narrative + copywriting must come first.
```

---

## Verification Checklist (skill self-check before emit)

Before writing `brief.json`:

- [ ] `output_type` is one of 9 enum values
- [ ] `theme` is one of 7 named OR `"custom"` with `theme_custom_notes` filled
- [ ] `audience.description` ≥ 1 sentence (not "anyone" / "everyone")
- [ ] `language_default` ∈ {`id`, `en`}; `bilingual_flag` is boolean
- [ ] `page_count` is within the per-type default range from `global-config.md` §15
- [ ] `ask_or_cta.specific_action` is concrete (specific contact, specific deadline, specific channel) — not vague
- [ ] `indonesian_context` set correctly based on signal scan
- [ ] No banned vocabulary in operator-supplied text fields (per `global-config.md` §4)
- [ ] `mode_detection_confidence` recorded (`high` if Q1-Q4 unambiguous, `medium` if one route was inferred, `low` if operator could not commit)
- [ ] `warnings[]` populated for any pre-emptive flag (e.g., banned-vocab rephrasing, missing deadline)

If any unchecked, do not emit `brief.json` — re-loop with the operator.

---

## Integration

| Skill | Interaction |
|-------|-------------|
| `ai-business-document-narrative` | CONSUMES `brief.json` from this skill. Cannot run without it. Reads `output_type` + `theme` + `language_default` to load the correct framework + theme preset + linguistic register. |
| `ai-business-document-copywriting` | Reads `brief.json` indirectly via the narrative output, but cross-checks `language_default`, `bilingual_flag`, and banned-vocab warnings. |
| `ai-business-document-gen` | DOES NOT consume `brief.json` directly — only via `narrative.json` + `copy.json` produced by upstream skills. |
| `ai-business-document-validate` | Reads `brief.json` for context (output_type, theme, language, page_count) to score the final artifact against the right framework rubric. |
| `ai-business-document-agent` (Phase G) | Orchestrates batch / multi-variant runs; supplies pre-filled `brief.json` arrays in Mode C. |
