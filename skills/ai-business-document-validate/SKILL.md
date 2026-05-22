---
name: ai-business-document-validate
description: Stage 5 multi-mode quality gate for the ai-business-document-designer pipeline; 100-point scoring with deck rubric (Visual Ratio 25 + Narrative Arc 20 + Ask Clarity 15 + Investor Psychology 20 + Anti-AI-Slop 20) applied to deck-vc / deck-b2b / deck-hybrid output_types; print rubric (Visual Ratio 25 + Framework Fit 15 + CTA Clarity 15 + Print Readiness 20 + Anti-AI-Slop 25) applied to brochure-product / portfolio-personal / portfolio-agency / catalog-product / service-flyer / trifold-leaflet output_types; mode auto-routed from brief.json.output_type per references/scoring-rubric.md §0; emits validation-report.json + validation-report.md with per-failure fix dispatches.
triggers: [validate, quality-gate, scoring, rubric, pitch-deck-validate, document-validate, print-readiness, anti-slop, audit-deck, score-deck, cek-deck, validasi-deck, print-preflight]
---

# ai-business-document-validate — Stage 5: Multi-Mode 100-Point Quality Gate

Stage 5 of 5. Reads the Stage 4 deliverable (deck.md, rendered PDF, HTML+CSS, or spec.json — auto-detected) plus the upstream narrative.json (Stage 2) and brief.json (Stage 1). Detects mode from `brief.json.output_type`, routes to the deck rubric OR the print rubric per `references/scoring-rubric.md §0`, scores all 5 categories totaling 100, applies hard-fail rules, emits `validation-report.json` + `validation-report.md` with per-failure fix instructions that name the specific upstream skill + page/slide to re-run.

> **Where this fits:** `ai-business-document-brief` → `ai-business-document-narrative` → `ai-business-document-copywriting` → `ai-business-document-gen` → **`ai-business-document-validate`** (you are here).

---

## Announce at Start

> "I'm using the ai-business-document-validate skill to score the deliverable."

Emit this exact line on first activation, before any Pre-checks read. No paraphrasing.

---

## Inputs

Required (auto-detected by output mode declared in `brief.json.output_type` + `brief.json.gen_mode`):

| Input | Provided by | Notes |
|---|---|---|
| Stage 4 deliverable | `ai-business-document-gen` | One of: `deck.md`, `<output>.pdf`, `<output>.html` + `<output>.css`, `spec.json` |
| `narrative.json` | `ai-business-document-narrative` | Story spine (deck modes) OR modular page layout (print modes) |
| `brief.json` | `ai-business-document-brief` | Output_type, language, audience, indonesian_context, fx_baseline |
| `copy.json` (print modes only) | `ai-business-document-copywriting` | Page-by-page body copy for banned-vocab scan |
| `image-prompts.json` (when generated) | `ai-business-document-gen` | Source for cliché-visual scan |
| `speaker-notes.md` (deck modes only) | `ai-business-document-gen` | Co-scanned with deck.md for banned vocab |

CLI flags (when invoked headless):

```
ai-business-document-validate \
  --brief <path/to/brief.json> \
  --narrative <path/to/narrative.json> \
  --deliverable <path/to/deck.md|file.pdf|file.html> \
  [--copy <path/to/copy.json>] \
  [--image-prompts <path/to/image-prompts.json>] \
  [--speaker-notes <path/to/speaker-notes.md>] \
  --out <output_dir>
```

If a required input is missing for the detected mode, stop and dispatch back to the producing skill (do not score from memory).

---

## Outputs

Two files written to `<output_dir>/`:

1. `validation-report.json` — machine-readable, schema below
2. `validation-report.md` — human-readable summary with terse top-fixes block

### validation-report.json schema

```json
{
  "schema_version": "1.0",
  "document_id": "indusia-merchant-brochure-2026q2",
  "output_type": "brochure-product",
  "mode_detected": "print",
  "validated_at": "2026-05-22T10:14:00+07:00",
  "validator_version": "0.2.0",

  "passed": false,
  "verdict": "fail",
  "pass_threshold": 70,
  "total_score": 64,
  "band": "D",

  "category_scores": {
    "visual_ratio": {"score": 17, "max": 25, "passed": false},
    "framework_fit": {"score": 11, "max": 15, "passed": true},
    "cta_clarity": {"score": 9, "max": 15, "passed": false},
    "print_readiness": {"score": 12, "max": 20, "passed": false},
    "anti_slop": {"score": 15, "max": 25, "passed": false}
  },

  "hard_fails": [
    {"category": "visual_ratio", "page": 4, "issue": "ratio 0.42 < 0.60"},
    {"category": "print_readiness", "page": "all", "issue": "PDF in RGB mode; CMYK required"}
  ],

  "soft_fails": [
    {"category": "cta_clarity", "page": "back-cover", "issue": "WhatsApp number missing"}
  ],

  "fixes_per_failure": [
    {
      "category": "visual_ratio",
      "page": 4,
      "score_deducted": 2.5,
      "fix": "Fix in ai-business-document-gen: page 4 has 4-bullet text block; replace with single hero infographic per references/visual-language.md §2."
    },
    {
      "category": "print_readiness",
      "page": "all",
      "score_deducted": 4,
      "fix": "Fix in ai-business-document-gen: re-export PDF with CMYK color mode + FOGRA51 ICC profile per references/research/pdf-print-production-2026.md §10."
    },
    {
      "category": "anti_slop",
      "page": 2,
      "score_deducted": 1,
      "fix": "Fix in ai-business-document-copywriting: replace 'cutting-edge' on page 2 with concrete benefit number per references/global-config.md §4."
    }
  ],

  "next_action": "BACK_TO_GEN",
  "next_action_targets": [
    "skills/ai-business-document-gen/SKILL.md (page 4, full PDF re-export)",
    "skills/ai-business-document-copywriting/SKILL.md (page 2 vocab swap)"
  ]
}
```

For deck modes (`deck-vc`, `deck-b2b`, `deck-hybrid`), `category_scores` keys are: `visual_ratio`, `narrative_arc`, `ask_clarity`, `investor_psychology`, `anti_slop`. For print modes, keys are: `visual_ratio`, `framework_fit`, `cta_clarity`, `print_readiness`, `anti_slop`.

### validation-report.md format

Terse, diagnostic, operator-facing. Echoes the JSON in human form, with top-fixes section ordered by impact (highest score-deducted first).

---

## Pre-checks (mandatory reads)

ALWAYS read before any scoring (no exceptions, no scoring from memory):

| Read order | File | Purpose |
|---|---|---|
| 1 | Stage 4 deliverable (deck.md / PDF / HTML+CSS / spec.json) | The artifact under review |
| 2 | `narrative.json` | Ground truth for narrative-arc verification (deck) OR modular layout fit (print) |
| 3 | `brief.json` | Mode detection input — `output_type`, `language`, `indonesian_context`, audience |
| 4 | `references/global-config.md` | Banned vocabulary master list (§4), visual ratio thresholds (§3), scoring weights |
| 5 | `references/scoring-rubric.md` | Read §0 (Mode Detection) AND the matching rubric (§1-§9 deck OR §11 print) |

Conditional reads (mode-dependent):

| Mode | Additional refs |
|---|---|
| Deck (deck-vc / deck-b2b / deck-hybrid) | `references/investor-psychology.md` (F1-F5 + Q1-Q10), `references/visual-language.md` (area-allocation method §2 + anti-slop §15), `references/storyline-frameworks.md` (story spine), `references/b2b-channel-partner-playbook.md` (if b2b/hybrid), `references/indonesian-context.md` (if `indonesian_context: true`) |
| Print (brochure / portfolio / catalog / flyer / trifold) | `references/visual-language.md` §14 (Print-Specific Visual Rules: CMYK, bleed, dpi, fonts) + §15 (8-pattern anti-slop banlist), `references/research/pdf-print-production-2026.md` (full preflight checklist, esp §7 overprint and §10 print-ready checklist), `references/frameworks/<output_type>.md` (mandatory_pages + 7-step content checklist for Framework Fit check), `references/indonesian-context.md` (if `indonesian_context: true`) |

If a required reference is missing or unreadable, stop and report the missing file path. Do not proceed with partial reference loading — scoring without full criteria is forbidden.

---

## Pipeline: Mode Detection & Rubric Routing (3-step)

### Step 1 — Read brief.json.output_type

```
mode_input = brief.json.output_type
```

### Step 2 — Route per references/scoring-rubric.md §0 Mode Detection table

| `output_type` value | Route to |
|---|---|
| `deck-vc`, `deck-b2b`, `deck-hybrid` | **Deck Rubric** (this skill's "Pipeline: Deck Rubric Scoring" section) |
| `brochure-product`, `portfolio-personal`, `portfolio-agency`, `catalog-product`, `service-flyer`, `trifold-leaflet` | **Print Rubric** (this skill's "Pipeline: Print Rubric Scoring" section) |

Edge case: if `brief.json.print_export == true` AND mode is deck-*, run the Deck Rubric AND additionally evaluate Print Readiness (§11.4) from the Print Rubric as a hard-fail gate. Other Print-Rubric categories are advisory only in that case.

### Step 3 — Emit mode_detected field

Write `mode_detected: "deck"` or `mode_detected: "print"` to the output JSON before any category scoring begins. This makes the downstream report self-describing and tells the operator which rubric was applied.

---

## Pipeline: Deck Rubric Scoring (5 categories totaling 100)

Apply when `mode_detected == "deck"`. Follow `references/scoring-rubric.md §2-§6` exactly. The 5 categories sum to 100 (25+20+15+20+20).

### Category 1 — Visual Ratio (25 pts)

Per `scoring-rubric.md §2`. For each of N slides, score per the area-allocation method in `references/visual-language.md §2`:

- 0 pts if slide visual ratio < 60% (HARD FAIL on that slide)
- 1 pt if 60-69%
- 2 pts if 70-84%
- 2.5 pts if ≥ 85%

Sum and normalize: `(sum / max_sum) × 25`. Any single slide < 60% triggers a hard-fail flag regardless of category total.

### Category 2 — Narrative Arc (20 pts)

Per `scoring-rubric.md §3`. 10 binary checks × 2 pts each:

| # | Check | Source |
|---|---|---|
| 1 | Hook in slide 1-2 from one of 6 hook formulas | `narrative.json.storyline_choices.hook_formula` ∈ [1..6] AND surfaced in slide 1-2 headline |
| 2 | Tension-build pattern declared (A/B/C/D) | `narrative.json.storyline_choices.tension_pattern` ∈ {A,B,C,D} |
| 3 | Single emotional core (Fear / Greed / Identity / Curiosity / Tribe) | `narrative.json.storyline_choices.emotional_core` set + verifiable in slides |
| 4 | Pattern match present in slides 1-3 | `narrative.json.storyline_choices.pattern_match_primary` set + named comparable visible by slide 3 |
| 5 | Setup beat hits slides 1-2 | Vision + ask-amount or ROI promise visible by slide 2 |
| 6 | Catalyst beat by slide 3 | Pain visualized; transformation hinted |
| 7 | Escalation peak in slide 6/7 | Proof + competition / moat surface |
| 8 | Resolution by slide 8 | Team + traction land trust |
| 9 | Ask in slide 10/11/13 | Last content slide is the ask, NOT "Thank You" |
| 10 | All Q1-Q10 standard questions mapped | `narrative.json.preempt_verification.Q1_through_Q10_mapped.passed == true` AND verifiable in slide content |

### Category 3 — Ask Clarity (15 pts)

Per `scoring-rubric.md §4`. 3 checks × 5 pts each:

| # | Check | Pass criteria |
|---|---|---|
| 1 | Specific number on ask slide | VC: exact amount (`Rp 30 B`, `$1.9M`). B2B: pilot scope + commercial terms exact. No "as much as possible" / "tbd" |
| 2 | Specific use (4-bullet or pilot scope) | VC: 4-bucket use of funds with %. B2B: pilot duration + coverage + commercial structure |
| 3 | Specific deadline / milestones | VC: 18-month milestones with month markers. B2B: dated decision deadline 4-6 weeks out |

HARD FAIL if: ask slide missing OR closes on "Thank You" OR amount is vague.

### Category 4 — Investor Psychology (20 pts)

Per `scoring-rubric.md §5`. Two sub-checks:

#### F1-F5 first-90-second filter (10 pts — 2 pts each)

- **F1 Pattern match** in slides 1-3 (named comparable visible by slide 3)
- **F2 Visceral problem + sourced size** — slide 2 visceral image; slide 5 sourced market math
- **F3 Specific Why Now** — slide 4 specific shift (regulatory / technical / behavioral); no macro cliché
- **F4 Compounding traction or compounding mechanism** — slide 6/7 shows growth rate or moat that compounds
- **F5 Founder-market fit + shipping credentials** — slide 8/10 names what the founder shipped (verb-led)

#### Q1-Q10 question pre-empt (10 pts — 1 pt each)

Map each of the 10 standard investor questions (per `references/investor-psychology.md §3`) to a slide and verify the slide actually answers it (not just role-tagged in narrative.json).

### Category 5 — Anti-AI-Slop (20 pts)

Per `scoring-rubric.md §6`. Three sub-checks:

#### 5a — Banned vocabulary (8 pts max deduction)

Scan `deck.md` + `speaker-notes.md` for banned vocab per `references/global-config.md §4`:

- **English Tier-1 (any = HARD FAIL)**: Unlock, Unleash, Empower, Supercharge, Maximize
- **English Tier-2 (-1 pt each, max -4)**: Revolutionize, Transform, Disrupt, Synergize, Leverage (as verb), Cutting-edge, World-class, Best-in-class, Game-changing, Next-generation, Paradigm shift, Seamless, Robust, Scalable solution, Holistic
- **Bahasa Tier-1 (-1 pt each, max -4)**: solusi terbaik, inovatif, terdepan, terbaik di kelasnya, revolusioner, mengubah cara, mendisrupsi

#### 5b — Cliché visual scan (8 pts max deduction)

Scan `image-prompts.json` for the 8 banlist patterns from `references/visual-language.md §15`. -1 pt per detection. HARD FAIL if 4+ banned visuals on the deck.

#### 5c — Hallucinated traction scan (4 pts max deduction)

For each number on traction / market / case-study slides: if `Source: ...` OR `internal estimate` OR `founder hypothesis` tag is present → OK. Untagged → -1 pt + HARD FAIL flag.

Combined: `cat5_score = max(0, 20 - 5a_deductions - 5b_deductions - 5c_deductions)`.

---

## Pipeline: Print Rubric Scoring (5 categories totaling 100)

Apply when `mode_detected == "print"`. Follow `references/scoring-rubric.md §11` exactly. The 5 categories sum to 100 (25+15+15+20+25).

### Category 1 — Visual Ratio (25 pts)

Per `scoring-rubric.md §11.1`. Same area-allocation method as deck mode but applied per printed page. Print collateral is even more visual-first than decks (no speaker filling verbal track — page must stand alone).

For each of N pages:
- 0 pts if page visual ratio < 60% (HARD FAIL on that page)
- 1 pt if 60-69%
- 2 pts if 70-84%
- 2.5 pts if ≥ 85%

Sum, normalize: `(sum / max_sum) × 25`. Use `references/visual-language.md §2` area-accounting method. Treat structured-data blocks per `§2.5` as visual ONLY when all 6 mandatory criteria hold.

### Category 2 — Framework Fit (15 pts)

Per `scoring-rubric.md §11.2`. 7-step content checklist (~2.14 pts per step × 7 = 15):

| # | Check | Pass criteria |
|---|---|---|
| 1 | Cover / hero page hits framework brief | Cover follows framework's mandatory-page spec (cover + hero claim + visual anchor) |
| 2 | Mandatory pages all present | Per `references/global-config.md §15` mandatory_pages column for this output_type |
| 3 | Page sequence matches framework's narrative arc | Order follows `references/frameworks/<output_type>.md` page sequence |
| 4 | Modular content blocks executed per framework | E.g., brochure feature module = visual + headline + 1-2 line proof; portfolio case study = hero image + problem + solution + result number |
| 5 | Framework-specific do-NOT patterns avoided | Each framework defines 3+ anti-patterns; none triggered |
| 6 | Output type's audience tone honored | Matches `target_audience` declared in framework frontmatter |
| 7 | Page count within framework default range | Per `references/global-config.md §15` default_page_count column |

HARD FAIL: if mandatory pages missing → back to ai-business-document-narrative.

### Category 3 — CTA Clarity (15 pts)

Per `scoring-rubric.md §11.3`. 3 checks × 5 pts each:

| # | Check | Pass criteria |
|---|---|---|
| 1 | Cover CTA present | Cover has clear action prompt or value hook (e.g., "Scan QR for live demo" / "Pricing from Rp 150jt — see page 4") |
| 2 | Back-cover or final-page CTA contractual | Specific contact channel (phone + WhatsApp + email + website all visible), with named decision deadline if applicable (e.g., "Promo berlaku s/d 30 Juni 2026") |
| 3 | Per-page CTA on multi-page collateral | Brochure-product / catalog-product: every feature module or product card has a price tier or order channel visible. Portfolio: every case study has a "next steps" or "want similar?" line |

HARD FAIL: missing CTA anywhere in document → back to ai-business-document-copywriting. For `service-flyer` + `trifold-leaflet` (1-2 page formats), CTA MUST appear above the fold on page 1.

### Category 4 — Print Readiness (20 pts)

Per `scoring-rubric.md §11.4`. 5 checks × 4 pts each. Cross-reference `references/research/pdf-print-production-2026.md §10` automated preflight checklist when feasible.

| # | Check | Pass criteria | -pts on fail |
|---|---|---|---|
| 1 | CMYK color mode | All raster assets tagged CMYK; FOGRA51 ICC profile (or GRACoL/SWOP for US shops). See `references/visual-language.md §14.1` | -4 if RGB-only |
| 2 | Bleed 3-5mm on all edges | Trim + 3mm Indonesia/EU OR trim + 5mm US, all 4 sides. See `references/visual-language.md §14.2` | -4 if missing |
| 3 | 300dpi raster minimum | All photographic raster ≥ 300dpi at final size; line art ≥ 600dpi. See `references/visual-language.md §14.3` | -4 if any image < 300dpi |
| 4 | Fonts embedded (subset) | All fonts subset-embedded in PDF; PDF/X-4 compliance passes Acrobat Preflight or Ghostscript `-dPDFA` check. See `references/visual-language.md §14.4` | -4 if un-embedded |
| 5 | No overprint / knockout errors | Black text uses overprint; spot colors handled per `references/research/pdf-print-production-2026.md §7`; no white-on-white knockout traps | -4 on detected error |

HARD FAIL: any item scoring 0/4 → back to ai-business-document-gen with technical fix list.

### Category 5 — Anti-AI-Slop (25 pts)

Per `scoring-rubric.md §11.5`. Three sub-checks:

#### 5a — Banned vocabulary (8 pts max deduction)

Scan `copy.json` + all rendered text for banned vocab per `references/global-config.md §4` PLUS print-mode additions: `next-gen`, `cutting-edge`, `best-in-class`, `state-of-the-art`, `industry-leading`, `mission-critical`, `paradigm-shift`, `synergy`.

- -1 pt per detection (max -8)
- HARD FAIL if any English Tier-1 word (Unlock, Unleash, Empower, Supercharge, Maximize, Revolutionize, Transform, Disrupt) OR any print-mode addition detected

#### 5b — 8-pattern visual banlist (12 pts max deduction)

Scan all image prompts + rendered pages for 8 banlist patterns from `references/visual-language.md §15`. -1.5 pts per detection (max -12):

| Banned pattern | Detection signal |
|---|---|
| Purple-blue gradient backdrop | Background color analysis or NB2 prompt scan |
| Stock photo handshake | Image content classifier or prompt scan |
| Hexagon tech icon | Vector / SVG scan for hex-grid pattern |
| Light bulb innovation cliché | Image content classifier |
| Faux 3D glassmorphism overuse | CSS / image scan; flag if > 1 element per page |
| Oversaturated palette | Color saturation analysis; flag if avg saturation > 80% |
| Broken kerning / lazy tracking | Visual inspection of display type |
| Lazy stock illustrations (Corporate Memphis) | Image content classifier |

HARD FAIL if 3+ patterns detected on the same document.

#### 5c — Hallucinated stats / unsourced claims (5 pts max deduction)

Each unsourced quantitative claim (revenue, customer count, market size, retention rate, "trusted by N customers") on the document = -1 pt. HARD FAIL if any quantitative claim lacks a source line or `internal estimate` tag.

Combined: `cat5_score = max(0, 25 - 5a_deductions - 5b_deductions - 5c_deductions)`.

---

## Hard-Fail Rules (immediate REJECT regardless of score)

Any of the following triggers `verdict: fail` and `passed: false`, even if `total_score ≥ 70`. Hard-fails override band assignment.

1. **Headline > 10 words on ANY page/slide** — per `references/visual-language.md §2` text-area threshold; flag the specific page index in `hard_fails[]`
2. **Visual ratio < 60% on ANY page/slide** — per-page hard-fail; flag every offending page
3. **Banned vocabulary present** (auto-grep) — English Tier-1 (Unlock, Unleash, Empower, Supercharge, Maximize) OR Bahasa Tier-1 (solusi terbaik, inovatif, terdepan, terbaik di kelasnya, revolusioner, mengubah cara, mendisrupsi) OR print-mode additions when in print mode (next-gen, cutting-edge, best-in-class, state-of-the-art, industry-leading, mission-critical, paradigm-shift, synergy)
4. **Hallucinated traction / unsourced quantitative claim** — any number on traction / market / case-study / product-claim block without `Source: ...` OR `internal estimate` OR `founder hypothesis` tag
5. **Print modes only**: bleed missing OR raster < 300dpi OR fonts not embedded OR RGB-only PDF (no CMYK) — any of the four = hard-fail
6. **Deck modes only**: ask slide missing OR pattern match missing from first 3 slides OR closing slide is "Thank You" instead of the ask
7. **Forbidden AI-slop visuals on any page**: purple-blue gradient backdrop, stock handshake, hexagon tech icon, light bulb innovation cliché, Corporate Memphis stock illustration (per `references/visual-language.md §15`) — flag each occurrence
8. **Generated AI faces on team / about / testimonial pages** — face validation per `references/safety-filter-playbook.md`; AI-generated faces of named persons = hard-fail regardless of consent claim

Roll-up: collect all hard-fail flags into `hard_fails[]`. If `len(hard_fails) > 0`, set `passed: false` AND `verdict: "fail"` regardless of `total_score`.

---

## Reporting Format

Both human-readable Markdown AND machine-readable JSON, written to `<output_dir>/`.

### validation-report.md (human-readable)

```
Validation result for {document_id}: {PASS / FAIL}

Mode detected: {deck / print}
Output type: {output_type}
Total: {N}/100   Band: {A/B/C/D/F}   Hard fails: {count}

[Deck mode rubric]
Cat 1 Visual Ratio:        {N}/25  {pass/fail}
Cat 2 Narrative Arc:       {N}/20  {pass/fail}
Cat 3 Ask Clarity:         {N}/15  {pass/fail}
Cat 4 Investor Psychology: {N}/20  {pass/fail}
Cat 5 Anti-AI-Slop:        {N}/20  {pass/fail}

[Print mode rubric]
Cat 1 Visual Ratio:    {N}/25  {pass/fail}
Cat 2 Framework Fit:   {N}/15  {pass/fail}
Cat 3 CTA Clarity:     {N}/15  {pass/fail}
Cat 4 Print Readiness: {N}/20  {pass/fail}
Cat 5 Anti-AI-Slop:    {N}/25  {pass/fail}

Top fixes (ordered by impact):
1. [page/slide N, cat X, -{pts}] Fix in ai-business-document-{skill}: {specific change}
2. ...
3. ...

Next action: {BACK_TO_BRIEF / BACK_TO_NARRATIVE / BACK_TO_COPYWRITING / BACK_TO_GEN / PUBLISH}
Targets: {list of skills + pages/slides to regenerate}

Full report: validation-report.json
```

### Per-failure fix recommendation rules

Every failure in `fixes_per_failure[]` MUST:
- Name the **category** (e.g., `visual_ratio`)
- Name the **page or slide index** (`"page": 4` or `"slide": 1`)
- Name the **score_deducted** (numeric)
- Name the **upstream skill** to fix it in — exact pointer: `"Fix in ai-business-document-gen: ..."` or `"Fix in ai-business-document-copywriting: ..."` or `"Fix in ai-business-document-narrative: ..."` or `"Fix in ai-business-document-brief: ..."`
- Name the **specific change** (vague "improve this" is forbidden)

Examples:
- "Fix in ai-business-document-copywriting: shorten headline on page 4 from 14 words to ≤ 10 per references/visual-language.md §2."
- "Fix in ai-business-document-gen: regenerate slide 1 background — current purple-blue gradient violates references/visual-language.md §15 banlist pattern 1."
- "Fix in ai-business-document-brief: gather source for 'Rp 12 M MRR' claim OR re-tag as 'internal estimate, April 2026'."

### Next-action dispatch logic

| Failure type | next_action | Target skill |
|---|---|---|
| Visual ratio hard-fail | `BACK_TO_GEN` | `ai-business-document-gen` (regenerate failing pages) |
| Anti-slop visual hard-fail | `BACK_TO_GEN` | `ai-business-document-gen` (regenerate image prompts) |
| Banned vocabulary | `BACK_TO_COPYWRITING` | `ai-business-document-copywriting` (rewrite copy) |
| Narrative arc fail (deck) | `BACK_TO_NARRATIVE` | `ai-business-document-narrative` (revise story spine; then re-gen) |
| Investor psychology fail (deck) | `BACK_TO_NARRATIVE` | `ai-business-document-narrative` (add missing pre-empts) |
| Framework fit fail (print) | `BACK_TO_NARRATIVE` | `ai-business-document-narrative` (revise modular layout) |
| Ask clarity fail (deck) | `BACK_TO_COPYWRITING` | `ai-business-document-copywriting` (rewrite ask slide) |
| CTA clarity fail (print) | `BACK_TO_COPYWRITING` | `ai-business-document-copywriting` (add CTA blocks) |
| Print readiness fail | `BACK_TO_GEN` | `ai-business-document-gen` (re-export with correct print spec) |
| Hallucinated traction | `BACK_TO_BRIEF` | `ai-business-document-brief` (gather missing source) |

Diagnostic tone, not judgmental tone. "Slide 4 visual ratio 0.42 — below 0.60 threshold" not "Slide 4 is bad."

---

## Reference Loading Cheat Sheet (per output_type)

| `output_type` | Rubric (scoring-rubric.md sections) | Visual-language refs | Framework / psychology refs | Indonesian refs |
|---|---|---|---|---|
| `deck-vc` | §0 + §1-§9 (deck) | §2 area-allocation, §15 anti-slop | `investor-psychology.md` F1-F5 + Q1-Q10, `storyline-frameworks.md` story spine | `indonesian-context.md` if `indonesian_context: true` |
| `deck-b2b` | §0 + §1-§9 (deck) | §2 area-allocation, §15 anti-slop | `investor-psychology.md`, `b2b-channel-partner-playbook.md`, `storyline-frameworks.md` | `indonesian-context.md` if `indonesian_context: true` |
| `deck-hybrid` | §0 + §1-§9 (deck) + dual ask-clarity tracks | §2 area-allocation, §15 anti-slop | `investor-psychology.md`, `b2b-channel-partner-playbook.md`, `storyline-frameworks.md` | `indonesian-context.md` if `indonesian_context: true` |
| `brochure-product` | §0 + §11 (print) | §14 print rules, §15 anti-slop | `frameworks/brochure-product.md`, `research/pdf-print-production-2026.md` §10 | `indonesian-context.md` if `indonesian_context: true` |
| `portfolio-personal` | §0 + §11 (print) | §14 print rules, §15 anti-slop | `frameworks/portfolio-personal.md`, `research/pdf-print-production-2026.md` §10 | `indonesian-context.md` if `indonesian_context: true` |
| `portfolio-agency` | §0 + §11 (print) | §14 print rules, §15 anti-slop | `frameworks/portfolio-agency.md`, `research/pdf-print-production-2026.md` §10 | `indonesian-context.md` if `indonesian_context: true` |
| `catalog-product` | §0 + §11 (print) | §14 print rules, §15 anti-slop | `frameworks/catalog-product.md`, `research/pdf-print-production-2026.md` §10 | `indonesian-context.md` if `indonesian_context: true` |
| `service-flyer` | §0 + §11 (print) | §14 print rules, §15 anti-slop | `frameworks/service-flyer.md`, `research/pdf-print-production-2026.md` §10 | `indonesian-context.md` if `indonesian_context: true` |
| `trifold-leaflet` | §0 + §11 (print) | §14 print rules, §15 anti-slop | `frameworks/trifold-leaflet.md`, `research/pdf-print-production-2026.md` §10 | `indonesian-context.md` if `indonesian_context: true` |

Cross-cutting: ALWAYS read `references/global-config.md` (banned vocab + visual-ratio thresholds + scoring weights) regardless of mode. Read `references/safety-filter-playbook.md` for face / consent / claim validation when team / testimonial / case-study pages present.

---

## Red Flags (self-check before emit)

| Red flag | Fix |
|---|---|
| Deliverable file missing | Hard-stop; route to `ai-business-document-gen` |
| Wrong rubric applied (e.g., deck rubric used on brochure-product) | Re-run mode detection from `brief.json.output_type` |
| Validator marks all categories pass but combined < 70 | Math error — recompute |
| Category passed despite a hard-fail in its checks | Bug — fix scoring logic |
| Vague fix language ("improve this page") | Rewrite to specific page-level change |
| Validator skips a category | Run again; all 5 mandatory per mode |
| Skipped source-line check on quantitative claim | Re-run anti-slop sub-check 5c |
| Print mode: skipped CMYK / bleed / dpi / fonts preflight | Re-run print readiness category 4 |
| Output JSON missing `mode_detected` field | Bug — emit before scoring |

Before emitting, run the Verification Checklist.

---

## Verification Checklist (before emit)

- [ ] `mode_detected` set in output JSON
- [ ] All 5 categories scored for the detected mode
- [ ] All hard-fail rules checked
- [ ] Per-slide / per-page visual ratio estimated (not skipped)
- [ ] Banned vocabulary scan covered all text artifacts (deck.md + speaker-notes.md for deck, copy.json + rendered text for print)
- [ ] Image prompts scanned for banned visuals
- [ ] Quantitative claims all checked for source tag
- [ ] Print modes: CMYK + bleed + 300dpi + font-embed + overprint all preflight-checked
- [ ] Combined `total_score` = sum of all 5 category scores (no math errors)
- [ ] Band assigned correctly (A/B/C/D/F)
- [ ] `next_action` populated with specific skill + page/slide targets
- [ ] Every `fixes_per_failure[]` entry names category + page + score_deducted + specific upstream skill + specific change
- [ ] Tone is diagnostic, not judgmental
- [ ] Output written to both `validation-report.json` AND `validation-report.md`

If any unchecked, do not emit. Re-run.

---

## Integration

| Skill | Interaction |
|---|---|
| `ai-business-document-brief` | Reads `brief.json` for mode detection (`output_type`), language, audience, indonesian flag. Dispatches back on hallucinated-traction failures (source gathering). |
| `ai-business-document-narrative` | Reads `narrative.json` for narrative-arc ground truth (deck modes) OR modular page layout (print modes). Dispatches back on narrative-arc / investor-psychology / framework-fit failures. |
| `ai-business-document-copywriting` | Reads `copy.json` (print modes) for banned-vocab scan. Dispatches back on banned-vocab / ask-clarity / CTA-clarity failures. |
| `ai-business-document-gen` | Consumes deliverable (deck.md / PDF / HTML+CSS / spec.json). Dispatches back on visual-ratio / anti-slop visual / print-readiness failures. |
| Other plugins | n/a — validate is internal to the ai-business-document-designer pipeline. |
