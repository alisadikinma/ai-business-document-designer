---
name: ai-business-document-narrative
description: Stage 2 narrative design (deck arc) AND modular page layout (brochure/portfolio/catalog/flyer/trifold) for the ai-business-document-designer pipeline; output_type-aware routing reads brief.json then designs hook/tension/payoff/ask story spine for deck output_types OR page-by-page wireframe with grid system + visual hierarchy + content blocks for print output_types; enforces HUMAN APPROVAL GATE before any downstream copywriting or visual generation skill runs (no tokens spent on visuals until operator approves narrative.md).
triggers: [narrative, storyline, layout, story-spine, hook, tension, modular-page, wireframe, story-design, page-sequence, deck-narrative, brochure-layout]
---

# AI Business Document Narrative — Stage 2: Narrative Design + Modular Page Layout

Stage 2 of 4 in the `ai-business-document-designer` pipeline. Reads `brief.json` (from Stage 1 `ai-business-document-brief`), routes by `output_type` field, then either (a) designs the deck narrative arc — hook, tension, payoff, ask, pattern match, emotional core, story spine — for deck output_types, or (b) designs the modular page layout — page sequence, role per page, grid system, visual hierarchy, content blocks — for print output_types. Emits `narrative.md` (human-readable) + `narrative.json` (machine-readable for downstream copywriting stage). HUMAN APPROVAL GATE before Stage 3 runs — no copywriting or visual tokens are spent until narrative is locked.

> **Where this fits:** `ai-business-document-brief` → **`ai-business-document-narrative`** → `ai-business-document-copywriting` (Stage 3) → `ai-business-document-gen` (Stage 4). See plugin `CLAUDE.md` for the full pipeline. Replaces and merges the legacy `pitch-deck-storyline` skill with multi-format layout design.

---

## Announce at Start

> "I'm using the ai-business-document-narrative skill to design the narrative/layout."

This announcement is mandatory at the start of every invocation. Operator must know which stage is active so handoffs and approval gates remain auditable.

---

## Inputs

This skill accepts `brief.json` produced by Stage 1 (`ai-business-document-brief`).

**Input sources (resolution order):**

1. `--brief-file <path>` flag — explicit absolute path to a `brief.json` file (used by batch agent or when multiple briefs co-exist).
2. `./brief.json` — default fallback if no flag is supplied. Must exist in current working directory.

**Required fields read from `brief.json`:**

- `output_type` — drives mode routing. One of: `deck-vc`, `deck-b2b`, `deck-hybrid`, `brochure-product`, `catalog-product`, `service-flyer`, `portfolio-personal`, `portfolio-agency`, `trifold-leaflet`.
- `framework.confirmed` — framework slug locked by operator in Stage 1.
- `audience.confirmed_mode` — e.g., `vc`, `b2b`, `consumer`, `recruiter`, `mixed`.
- `language` — `id`, `en`, `bilingual`.
- `product` — product name, one-line description, category.
- `market` / `traction` / `team` / `why_now` (for deck modes).
- `mandatory_pages` / `optional_pages` / `default_page_count` (for print modes; copied through from framework frontmatter).

**Optional flags:**

- `--auto-approve` — used by the batch agent / orchestrator to skip the HUMAN APPROVAL GATE. Operator must have pre-authorized batch mode.
- `--output-dir <path>` — where to write `narrative.md` + `narrative.json`. Default: same directory as `brief.json`.

If `brief.json` is missing or `output_type` is absent / malformed, STOP. Route operator back to `ai-business-document-brief`.

---

## Outputs

Both files are emitted side-by-side. Markdown is for operator review; JSON is for the downstream copywriting / gen skill.

### Files written

- `{output_dir}/narrative.md` — human-readable narrative spec. Operator reviews this at the approval gate.
- `{output_dir}/narrative.json` — machine-readable schema consumed by Stage 3 (`ai-business-document-copywriting`).

### narrative.json schema — Deck mode (`output_type` ∈ {deck-vc, deck-b2b, deck-hybrid})

```json
{
  "schema_version": "2.0",
  "stage": "narrative",
  "mode": "deck",
  "output_type": "deck-vc",
  "framework": "ai_era_11",
  "language": "id",
  "approved_at": null,
  "approved_by": null,

  "story_spine": [
    {
      "slide_n": 1,
      "role": "title",
      "hook_or_payoff_or_ask_or_filler": "hook",
      "audience_mode_emphasis": "vc",
      "investor_preempt_question_id": "Q1",
      "verbal_only_insight": "..."
    }
  ],

  "pattern_match": {
    "primary": "We are Stripe for Indonesian bazaars",
    "secondary": null,
    "surfaces_by_slide": 3
  },

  "emotional_core": "Fear",
  "tension_pattern": "B",
  "tension_peak_slide": 5,
  "ask_slide": 11,
  "hook_formula_id": 3,

  "hard_rules_check": {
    "hook_by_slide_2": true,
    "payoff_by_slide_8": true,
    "ask_on_last_slide": true,
    "pattern_match_within_first_3": true,
    "slide_cap_respected": true,
    "all_q1_q10_mapped": true
  }
}
```

### narrative.json schema — Print mode (`output_type` ∈ {brochure-product, catalog-product, service-flyer, portfolio-personal, portfolio-agency, trifold-leaflet})

```json
{
  "schema_version": "2.0",
  "stage": "narrative",
  "mode": "print",
  "output_type": "brochure-product",
  "framework": "brochure-product",
  "language": "id",
  "approved_at": null,
  "approved_by": null,

  "page_sequence": [
    {
      "page_n": 1,
      "role": "cover-hero",
      "grid_system": "12-col",
      "visual_hierarchy": "z-pattern",
      "content_blocks": [
        { "type": "headline", "position": "top-left", "content_intent": "road-sign question, ≤10 words" },
        { "type": "image",    "position": "center-dominant", "content_intent": "single hero visual, ≥70% page area" },
        { "type": "cta",      "position": "bottom-right", "content_intent": "QR or short URL to landing page" }
      ]
    }
  ],

  "cta_pages": [1, 7],
  "mandatory_pages_satisfied": true,
  "page_count_actual": 7,
  "page_count_target": 7,

  "hard_rules_check": {
    "hook_on_page_1": true,
    "payoff_by_60_percent_mark": true,
    "cta_on_cover_and_last": true,
    "page_count_within_tolerance": true,
    "all_mandatory_pages_present": true,
    "grid_system_declared_per_page": true
  }
}
```

Both schemas include `hard_rules_check` so the Stage 4 validator can short-circuit if any rule was violated.

---

## Pre-checks (mandatory reads)

ALWAYS read these before designing anything. Output_type-conditional reads layer on top.

### Universal (every invocation)

- `brief.json` — the Stage 1 output. Every field listed under Inputs.
- `references/global-config.md` — banned vocabulary, pattern match library precedence, language norms.

### Conditional reads — Deck modes

If `output_type` starts with `deck-`:

- `references/storyline-frameworks.md` — the 6 hook formulas, 4 tension patterns, 5 emotional cores, pattern match library.
- `references/investor-psychology.md` — the 5 first-90-second filters (F1–F5) and 10 standard investor questions (Q1–Q10) that must be mapped to slides.
- `references/frameworks/deck-vc.md` — if `output_type` = `deck-vc`. Classic-10, AI-era 11, traction-first 13 slide sequences.
- `references/frameworks/deck-b2b.md` — if `output_type` = `deck-b2b` or `deck-hybrid`. B2B channel pre-empt order, ROI-first sequence.
- `references/research/investor-pitch-deck-best-practices-2026.md` — research backbone for hook + moat + Why Now patterns.
- `references/b2b-channel-partner-playbook.md` — if `audience.confirmed_mode` = `b2b` or framework is hybrid.

### Conditional reads — Print modes

If `output_type` is a print format:

- `references/layout-grammar.md` — grid systems, Z/F/Gutenberg flow, visual hierarchy rules per page.
- `references/research/framework-structures-2026.md` — research backbone for page-count tolerance, mandatory page logic.
- One matching framework file based on `output_type`:
  - `brochure-product` → `references/frameworks/brochure-product.md`
  - `catalog-product` → `references/frameworks/catalog-product.md`
  - `service-flyer` → `references/frameworks/service-flyer.md`
  - `portfolio-personal` → `references/frameworks/portfolio-personal.md`
  - `portfolio-agency` → `references/frameworks/portfolio-agency.md`
  - `trifold-leaflet` → `references/frameworks/trifold-leaflet.md`

If any required reference file fails to load, STOP and surface the missing path to the operator.

---

## Pipeline: Narrative Arc Mode (for deck-vc / deck-b2b / deck-hybrid)

Run this 6-step flow only when `output_type` starts with `deck-`.

### Step 1 — Detect framework variant from brief.json

Read `framework.confirmed`. Map to one of three deck sequences per `references/frameworks/deck-vc.md` and `references/frameworks/deck-b2b.md`:

- `classic_10` — 10-slide template. B2B default + pre-revenue VC.
- `ai_era_11` — 11 slides. VC default for 2026. Adds explicit Why Now (slide 4) + Moat (slide 8).
- `traction_first_13` — 13 slides. High-revenue VC (ARR > $1M) leading with traction at slide 2.

Confirm the variant matches `audience.confirmed_mode` and `traction.metrics`. If brief locked `ai_era_11` but ARR > $1M, surface the mismatch to the operator before continuing.

### Step 2 — Select hook formula from 6-option library

From `references/research/investor-pitch-deck-best-practices-2026.md` and `references/storyline-frameworks.md` §3, pick exactly one of:

1. **Visceral statistic** — sourced number that lands in the gut. Best when brief contains a strong third-party-sourced market or pain statistic.
2. **Insider observation** — "Most people don't realize..." opening from a founder with credibility in the domain.
3. **Counter-intuitive claim** — conventional wisdom inverted, then defended. Best for category-redefining theses.
4. **Customer quote (verbatim)** — single named buyer in their exact words. Best when brief has attributable quote.
5. **Personal stake** — founder origin story tied to the problem. Best when founder-market fit is the moat.
6. **Visual hook (no text)** — one image carries the story. Best when product is photogenic or before/after is dramatic.

Output one recommended formula + one alternative + rationale. Operator confirms.

### Step 3 — Build tension arc (problem → urgency → cost of inaction)

Select one of four tension patterns from `references/storyline-frameworks.md` §4:

- **A — Cost-of-Inaction Spiral.** B2B default; regulated markets. Each slide raises the cost the buyer pays for delay.
- **B — Inevitable Wave.** VC default; market-timing pitches. The market is moving; you are either in front or run over.
- **C — Discovery Arc.** Founder-led, second-time founders, insight-driven theses. Tension comes from the unfolding insight.
- **D — Two-Worlds Comparison.** B2B ROI-driven. Side-by-side before/after.

Define the tension peak — which slide has the highest emotional load. Default tension peak: slide 5 for `classic_10`, slide 5 for `ai_era_11`, slide 6 for `traction_first_13`. The payoff slide must follow the peak by ≤3 slides.

### Step 4 — Select pattern match

Pattern match formula: **"We are [known winner] for [our niche]."**

From `references/storyline-frameworks.md` §6 pattern match library, select per priority order (mirrors `references/indonesian-context.md` §7 when language is `id` or `bilingual`):

1. Indonesian winners — Tokopedia, Tiket.com, Xendit, Midtrans, GoTo, Ruangguru, Halodoc.
2. Adjacent Indonesian — Bukalapak, Akulaku, Kopi Kenangan, Mamikos.
3. SEA winners — Grab, Sea / Shopee, Carousell.
4. India / China comparables — Paytm, Ant — only if the "Indonesia is N years behind" thesis is explicit in brief.
5. US winners — Stripe, Airbnb, Toast POS, Shopify, Square — last resort, only if no closer comparable exists.

Pattern match MUST surface verbatim no later than slide 3. Record `pattern_match.primary` and optional `secondary` in narrative.json.

### Step 5 — Select emotional core (exactly one)

One and only one of:

- **Fear / Loss** — default for Indonesian B2B (Yukk lock-in, foot-traffic decline, kencing solar).
- **Greed / Gain** — mature, ROI-driven, recurring-revenue pitches.
- **Identity** — default for Indonesian VC (BI-SNAP era pride, fintech nationalism, "Indonesian unicorn" identity).
- **Curiosity** — pre-revenue + insight-led theses, novel category.
- **Tribe** — mission / community / ecosystem play.

Mixing emotional cores dilutes the deck. If brief evidence supports two, pick the dominant one and demote the other to a single supporting slide.

### Step 6 — Map slide story spine with audience-mode emphasis

Lay out N slides (10 / 11 / 13 per framework variant) into the story spine. Each slide entry:

- `slide_n` — number.
- `role` — title / problem / solution / market / product / business model / traction / why now / moat / team / ask / appendix.
- `hook_or_payoff_or_ask_or_filler` — narrative function for that slide.
- `audience_mode_emphasis` — `vc` or `b2b` or `mixed` per `audience.confirmed_mode`. VC mode emphasizes moat + Why Now + market; B2B mode emphasizes ROI + integration + reference customers.
- `investor_preempt_question_id` — one of Q1–Q10 from `references/investor-psychology.md` §3. All ten must be mapped across the deck.
- `verbal_only_insight` — one fact reserved for the speaker note (never on the slide).

Verify all 5 first-90-second filters (F1–F5 from `investor-psychology.md` §2) are pre-empted before slide 5. If any filter unmapped, revise.

---

## Pipeline: Modular Page Layout Mode (for brochure / portfolio / catalog / flyer / trifold)

Run this 7-step flow only when `output_type` is a print format.

### Step 1 — Detect framework from brief.json and load matching framework file

Read `output_type`. Load the matching `references/frameworks/<output_type>.md` (see Pre-checks table). Read the YAML frontmatter — `mandatory_pages`, `optional_pages`, `default_page_count`, `aspect_ratio`, `target_audience` — these are the spec contract for this skill.

### Step 2 — Extract mandatory_pages and optional_pages

From the framework frontmatter, build two lists:

- `mandatory_pages[]` — every page that MUST appear in the final document. Missing any one = validator hard-fail.
- `optional_pages[]` — pages the operator may insert based on brief evidence. Use the brief's product complexity, regulatory needs, and tier count to decide which optional pages get included.

Compute `page_count_actual` = `mandatory_pages.length` + selected optional pages. Confirm `page_count_actual` is within ±20% of `default_page_count`.

### Step 3 — Assign role per page

Per page, pick exactly one role from the framework vocabulary:

- **cover-hero** — page 1; carries the hook; ≤10-word headline; visual ≥70% page area.
- **problem-articulation** — names buyer pains in operator vocabulary (optional but recommended for brochure / flyer / trifold front panels).
- **solution-reveal** — single-image transformation moment.
- **modular-showcase** — feature pinnules; 1–3 modules per page; grouped into ≤3 pillars total.
- **pricing-tier** — penultimate page for brochure / catalog / flyer; Bronze/Silver/Gold or equivalent escalation; dual-price slash + PPN disclosure for Indonesian market.
- **case-study** — for portfolio formats; one project per page with outcome metric.
- **cta-closer** — last page; named human sales contact with face photo + WhatsApp + role + QR code.
- **contact-block** — supplemental contact-only page for trifold or portfolio (when CTA is separate from contact).

Each role is drawn from the loaded framework file — invented roles are not allowed.

### Step 4 — Assign visual hierarchy per page (Z / F / Gutenberg)

Per `references/layout-grammar.md` §"Visual Flow":

- **Z-pattern** — visual-heavy single-page reads: brochure cover, flyer, trifold front panel, deck hook slide.
- **F-pattern** — text-heavy multi-page reads: portfolio case-study interior, catalog spec sheets, brochure interior modules.
- **Gutenberg diagram** — balanced visual + text; default for pricing-tier and contact-block pages.

Record `visual_hierarchy` per page in narrative.json. Use the cheat sheet at the bottom of `layout-grammar.md` (line 165+) when in doubt.

### Step 5 — Define content blocks per page

For each page, declare a content block list. Each block has three properties:

- `type` — one of `headline`, `subheadline`, `image`, `copy`, `bullet-list`, `table`, `pricing-tier`, `cta`, `qr-code`, `contact-card`, `logo-wall`, `disclaimer`.
- `position` — one of `top-left`, `top-center`, `top-right`, `center-dominant`, `mid-left`, `mid-right`, `bottom-left`, `bottom-center`, `bottom-right`, `full-bleed`.
- `content_intent` — one sentence describing what the block should communicate (NOT the final copy — that's Stage 3's job).

Block discipline: the cover-hero page has at most 3 blocks (headline + image + CTA). Interior pages cap at 6 blocks. More than 6 = visual clutter, reject and re-decompose.

### Step 6 — Confirm grid system

Declare grid per page:

- **12-col** — default for A4 brochure, catalog, portfolio, flyer interior. Allows 3-col, 4-col, and 6-col subdivisions.
- **6-col** — simpler grid for portfolio-personal case studies, brochure interior with single dominant image.
- **panel-based** — exclusive to trifold-leaflet. Each panel (front / inside-1 / inside-2 / back) is treated as a self-contained grid.

Vertical rhythm follows `references/layout-grammar.md` §"Grid Systems" — baseline grid + gutter discipline. Document the grid choice per page; downstream copy stage will respect it.

### Step 7 — Verify CTA placement (cover AND last page)

Print formats MUST have a CTA on both the cover page (entry) and the last page (exit). The cover CTA is usually a QR code or short URL. The last-page CTA is usually a named human sales contact + WhatsApp + email + QR linking to a deeper conversion surface.

If the operator's brief lacks contact identity, STOP and route back to brief stage — CTA cannot be fabricated.

Record `cta_pages[]` in narrative.json — must include `1` and the last page index at minimum.

---

## HUMAN APPROVAL GATE

After both `narrative.md` and `narrative.json` are emitted, present `narrative.md` to the operator and pause for explicit approval.

**Gate behavior:**

1. Surface `narrative.md` contents (or its absolute path if the file is long) to the operator.
2. Call AskUserQuestion (or the equivalent operator prompt mechanism) with three options:
   - **Approve** — write `approved_at` ISO timestamp + `approved_by` operator identifier into `narrative.json`. Hand off to Stage 3 (`ai-business-document-copywriting`).
   - **Refine** — operator describes what should change. Re-enter Step 6 (deck) or Step 3 (print) with the revision; do not start over.
   - **Start over** — discard narrative output, route operator back to Stage 1 (`ai-business-document-brief`).
3. No downstream skill — copywriting, gen, validate — runs until the approval is recorded.

**`--auto-approve` override:** when the batch agent / orchestrator passes the `--auto-approve` flag, skip the gate. This flag is reserved for batch runs where the operator has already pre-authorized the narrative pattern. The flag MUST be passed explicitly; never default to auto-approve.

**Hand-off message after approval:**

```
narrative.md saved to {path} — review captured.
narrative.json saved to {path} — locked for Stage 3.

Approved at: {ISO 8601 timestamp}
Approved by: {operator id}

Next: run ai-business-document-copywriting to draft per-slide / per-page copy.
```

---

## Hard Rules

Non-negotiable. Each rule is checked into `hard_rules_check` in `narrative.json`. Any violation = STOP and revise before emit.

1. **Hook lands by slide 2 (deck) or page 1 (print).** First impression burns fast. Deck hook can ride slide 1 title, but no later than slide 2 problem. Print hook is the cover — never pushed inside.
2. **Payoff lands by slide 8 (deck) or 60% mark (print).** Deck payoff is the solution + traction beat; do not bury past slide 8 in any framework variant. Print payoff is the solution-reveal page; must appear by page ⌈0.6 × total_pages⌉.
3. **Ask / CTA on last slide (deck) or last page (print).** Mandatory. No "Thank You" filler slide. Last slide = ask with specific numbers + dated deadline (deck) or named contact + WhatsApp + QR (print).
4. **Pattern match for decks within first 3 slides.** Verbatim "We are [winner] for [niche]" must surface by slide 3. Pattern from library only — no invented comparables.
5. **Print: CTA also on cover (not only last page).** Cover CTA is QR or short URL to landing page. Last page CTA is named human + WhatsApp.
6. **Slide cap respected.** Deck max is 13 slides (`traction_first_13`). Extending the body beyond cap = move content to appendix. Cap is 10 for `classic_10`, 11 for `ai_era_11`, 13 for `traction_first_13`.
7. **Print: page count matches default_page_count ±20%.** Page count below tolerance = under-spec; above tolerance = bloat. Re-decompose pages or remove optional pages.
8. **Mandatory pages from framework all satisfied.** Every page in the loaded framework's `mandatory_pages` list must appear. Validator gate later in Stage 4 will re-confirm.
9. **One emotional core only (deck mode).** No mixed Fear+Greed. Pick dominant; demote others to single supporting slide.
10. **No banned vocabulary anywhere in narrative.md or narrative.json.** Banned terms listed in `references/global-config.md` plus the carousel-wide bans. See the no-placeholder rule below.

---

## Reference Loading Cheat Sheet

Per output_type, exactly which reference files this skill reads. Mirrors the brief skill's cheat sheet but at narrative depth.

| output_type | Mode | Framework file | Other refs (in addition to global-config.md) |
|-------------|------|----------------|----------------------------------------------|
| `deck-vc` | narrative-arc | `references/frameworks/deck-vc.md` | `storyline-frameworks.md`, `investor-psychology.md`, `research/investor-pitch-deck-best-practices-2026.md` |
| `deck-b2b` | narrative-arc | `references/frameworks/deck-b2b.md` | `storyline-frameworks.md`, `investor-psychology.md`, `b2b-channel-partner-playbook.md`, `research/investor-pitch-deck-best-practices-2026.md` |
| `deck-hybrid` | narrative-arc | `references/frameworks/deck-vc.md` + `references/frameworks/deck-b2b.md` | `storyline-frameworks.md`, `investor-psychology.md`, `b2b-channel-partner-playbook.md`, `research/investor-pitch-deck-best-practices-2026.md` |
| `brochure-product` | modular-page-layout | `references/frameworks/brochure-product.md` | `layout-grammar.md`, `research/framework-structures-2026.md` |
| `catalog-product` | modular-page-layout | `references/frameworks/catalog-product.md` | `layout-grammar.md`, `research/framework-structures-2026.md` |
| `service-flyer` | modular-page-layout | `references/frameworks/service-flyer.md` | `layout-grammar.md`, `research/framework-structures-2026.md` |
| `portfolio-personal` | modular-page-layout | `references/frameworks/portfolio-personal.md` | `layout-grammar.md`, `research/framework-structures-2026.md` |
| `portfolio-agency` | modular-page-layout | `references/frameworks/portfolio-agency.md` | `layout-grammar.md`, `research/framework-structures-2026.md` |
| `trifold-leaflet` | modular-page-layout | `references/frameworks/trifold-leaflet.md` | `layout-grammar.md`, `research/framework-structures-2026.md` |

Indonesian context layer (`references/indonesian-context.md`) loads on top whenever `language` is `id` or `bilingual`, regardless of mode.

---

## Anti-Placeholder Discipline

This skill emits decision artifacts, not boilerplate. To keep output real:

- Every hook formula referenced is one of the 6 in `references/storyline-frameworks.md` §3 — drawn from `references/research/investor-pitch-deck-best-practices-2026.md`. No invented hook patterns.
- Every pattern match comparable is a real company from the library (Tokopedia, Xendit, Stripe, Airbnb, Toast POS, etc.). No invented comparables.
- Every page role is a real framework concept from the loaded framework file. No invented roles.
- Banned vocabulary check before emit — these words must NOT appear in `narrative.md` or `narrative.json`: Unlock, Unleash, Empower, Supercharge, Revolutionize, Transform, Disrupt, Synergize, Leverage (as verb), Cutting-edge, World-class, Best-in-class, Game-changing, Next-gen, State-of-the-art, Paradigm-shift.
- No TODO markers, no `[fill later]` blanks, no `<example>` filler. If a brief field is missing, STOP and route back to Stage 1.

---

## Red Flags (Self-Check Before Emit)

| Red flag | Fix |
|----------|-----|
| Hook not in formulas 1–6 | Reject; pick from library. |
| Mixed emotional core | Reject; pick exactly one for deck mode. |
| Pattern match invented or "Apple of X" | Reject; pick valid comparable from library. |
| Last slide / last page contains "Thank You" filler | Reject; replace with ask + dated deadline (deck) or contact + CTA (print). |
| Q1–Q10 unmapped (deck) | Reject; map every standard investor question. |
| F1–F5 first-90-second filters unmapped (deck) | Reject; pre-empt before slide 5. |
| Mandatory page from framework missing (print) | Reject; insert before emit. |
| Page count outside ±20% of default | Reject; re-decompose or trim optional pages. |
| CTA missing from cover page (print) | Reject; add QR or short URL block to cover. |
| Banned vocabulary detected | Reject; rewrite block before emit. |
| `narrative.json` emitted without `hard_rules_check` populated | Reject; populate all check booleans. |

---

## Integration

| Skill | Interaction |
|-------|-------------|
| `ai-business-document-brief` (Stage 1) | Produces `brief.json` — required input. Cannot run this skill without it. |
| `ai-business-document-copywriting` (Stage 3) | Consumes `narrative.json` after approval. Will refuse to run on unapproved narrative (no `approved_at` timestamp). |
| `ai-business-document-gen` (Stage 4) | Reads `narrative.json` for layout / story spine constraints when emitting visual production spec. |
| `ai-business-document-validate` | Reads `narrative.json` as ground truth for narrative + layout scoring. |
| Legacy `pitch-deck-storyline` | Superseded by this skill; orchestrator handles deprecation. |

---

## Verification Checklist (Before Emit)

- [ ] `brief.json` read; `output_type` and `framework.confirmed` confirmed present.
- [ ] Correct mode routed (narrative-arc for deck-, modular-page-layout for print).
- [ ] All conditional reference files loaded for the routed mode.
- [ ] Deck mode: hook formula from 1–6, tension pattern A/B/C/D, exactly one emotional core, pattern match by slide 3, all Q1–Q10 mapped, all F1–F5 pre-empted, slide cap respected.
- [ ] Print mode: framework framematter loaded, mandatory pages all present, page count within ±20% of default, grid + visual hierarchy declared per page, CTA on cover AND last page, content blocks within per-page caps.
- [ ] `narrative.md` written for operator review.
- [ ] `narrative.json` written with `hard_rules_check` fully populated.
- [ ] Banned vocabulary scan clean.
- [ ] HUMAN APPROVAL GATE invoked (unless `--auto-approve` is explicitly set).
- [ ] No downstream skill triggered before approval recorded.

If any checkbox unchecked, revise before emitting.
