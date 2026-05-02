---
name: pitch-deck-brief
description: Stage 1 of the 4-stage pitch-deck-designer pipeline. Use when starting a new pitch deck, gathering raw information, planning a deck, or scoping a fundraising / B2B-adoption pitch. Triggers on pitch deck brief, deck planning, deck discovery, plan pitch deck, scope pitch deck, brief deck, rancang pitch deck, scoping investor deck, b2b pitch scoping, planning fundraising pitch, or any request to gather product / audience / ask information before writing slides.
---

# Pitch Deck Brief — Stage 1: Discovery

Stage 1 of 4. Gathers all raw input needed for the deck — product, audience, ask, traction, comparables, constraints. Detects audience mode (VC / B2B / hybrid). Outputs `brief.json`. The `pitch-deck-storyline` skill consumes this output. NEVER skip directly from brief to gen — storyline must come in between.

> **Where this fits:** `pitch-deck-brief` → `pitch-deck-storyline` → `pitch-deck-gen` → `pitch-deck-validate`. See `CLAUDE.md` for the full pipeline.

---

## 1. Iron Law

```
NEVER assume audience mode. ASK.
```

Audience mode (VC vs B2B vs hybrid) is the single most consequential decision in the whole pipeline. Get it wrong and every downstream slide is mis-emphasized. Always confirm mode with the operator, even when keywords seem unambiguous.

---

## 2. Reference Files (Read On-Demand)

Before any task, read the relevant reference files. ALWAYS read `global-config.md` first, then layer additional references as needed.

| Task | Read first |
|------|-----------|
| ANY brief | `references/global-config.md` (ALWAYS) |
| Mode detection rules | + `references/deck-frameworks.md` §5 |
| Indonesian audience | + `references/indonesian-context.md` |
| B2B-mode keywords / questions | + `references/b2b-channel-partner-playbook.md` |
| Audience psychology | + `references/investor-psychology.md` |
| Forbidden vocabulary check | + `references/global-config.md` §4 |

---

## 3. Hard Rules (NON-NEGOTIABLE)

These rules apply to every brief. Violation requires immediate correction before output.

1. **NEVER auto-detect audience mode silently.** Even when keywords seem unambiguous, surface the inferred mode in the brief and ask the operator to confirm.
2. **NEVER fabricate traction.** If the operator does not provide a number, use `"internal estimate"` or `"founder hypothesis"` as the value, never a fabricated figure.
3. **NEVER accept top-down TAM only.** If the operator gives only top-down ("1% of $100B market"), ask for bottom-up math. Top-down TAM is a hard fail at validate.
4. **ALWAYS verify named comparable companies / venues exist.** If the operator names a partner or comparable, ask for verification artifact (logo file, contract reference, public press, etc.) before storing as fact.
5. **ALWAYS capture audit trails for every number.** Each metric in `brief.json` MUST have a `source` field — `internal data` / `founder estimate` / `[external source name + year]` / etc. Untagged numbers are auto-flagged at validate.
6. **ALWAYS detect Indonesian-mode keywords.** If audience description mentions Indonesia / Jakarta / Bahasa / IDR / mall / EO / bazaar / venue, set `indonesian_context: true`. The downstream skills will read this.
7. **ALWAYS surface the deadline.** Pitch decks have meeting dates. If the operator does not give one, ask. Without a meeting date, the storyline cannot calibrate Why Now urgency.
8. **NEVER write the storyline in this stage.** This skill only gathers information. Story design happens in `pitch-deck-storyline`.

---

## 4. Workflow: Brief Generation

### Step 1 — Initial input

Operator provides one of:

- One-paragraph free-form brief (preferred starting point)
- Filled-in brief template (if available)
- Pasted-in product spec or marketing material (we extract from it)

The skill reads the input and identifies what's covered + what's missing.

### Step 2 — Coverage check

Verify all 12 brief fields are filled. If any are missing, ASK the operator (one question at a time, except where bundling is natural):

| # | Field | Question if missing |
|---|-------|---------------------|
| 1 | Product name | "What is the product / company called?" |
| 2 | One-line description | "If you had to describe it in one sentence to a stranger at a coffee shop, what would you say?" |
| 3 | Audience description | "Who specifically is this deck for? (Named investor, named operator, or 'cold pitch to anyone in [category]')" |
| 4 | Audience mode (inferred) | Inferred from #3; surface for confirmation. |
| 5 | Ask | VC: "How much are you raising? In what round? At what valuation range?" / B2B: "What pilot scope and commercial terms?" |
| 6 | Use of ask | VC: "How will you spend it? Roughly 4-bucket %." / B2B: "What integration timeline + decision deadline?" |
| 7 | Current traction | "What real, sourceable numbers do you have today? (revenue / users / venues / GMV / etc.) — say 'pre-revenue' or 'no traction yet' if applicable" |
| 8 | Comparable companies / venues | "Name 1–3 known successful companies / venues investors will pattern-match you to" |
| 9 | Why now | "Why does this work in 2026 specifically? What changed? (Avoid macro clichés)" |
| 10 | Founder–market fit | "Why YOU specifically? What did you ship before that's relevant?" |
| 11 | Meeting date / decision deadline | "When is the pitch meeting / when does the decision need to land?" |
| 12 | Constraints | "Anything we can't say or must say? (NDA, sensitive customers, language requirement, page limit, etc.)" |

### Step 3 — Mode detection (per `deck-frameworks.md` §5)

Apply the mode-detection rules:

```
IF audience description mentions: invest / equity / fundraise / valuation / Series A/B/C / exit / IPO / term sheet:
    inferred_mode = "vc"
    IF arr_usd > 1_000_000:
        inferred_framework = "traction_first_13"
    ELIF product_is_ai_adjacent OR pitch_year >= 2026:
        inferred_framework = "ai_era_11"
    ELSE:
        inferred_framework = "classic_10"

ELIF audience description mentions: adopt / deploy / pilot / mall / EO / food court / operator / venue / owner:
    inferred_mode = "b2b"
    inferred_framework = "classic_10"

ELIF both signals present:
    inferred_mode = "hybrid"
    inferred_framework = "classic_10_plus_appendix_vc_slides"

ELSE:
    inferred_mode = "b2b"  # safe default for Indonesian SaaS
    inferred_framework = "classic_10"
```

ALWAYS surface the inferred mode + framework to the operator and ask: "Detected mode: `{mode}` with framework `{framework}`. Confirm or override?"

### Step 4 — Indonesian-context flag

If any of these appear in the brief input (case-insensitive):
- `indonesia` / `jakarta` / `surabaya` / `medan` / `bandung` / etc.
- `bahasa` / `bahasa indonesia` / `bahasa indo`
- `IDR` / `rupiah` / `Rp`
- `mall` / `EO` / `event organizer` / `food court` / `bazaar` / `venue`
- Indonesian comparable companies (Tokopedia, Tiket.com, Xendit, Midtrans, GoTo, etc.)

Set `indonesian_context: true` and add the operator note: "Indonesian-context detected. Default deck language = Bahasa Indonesia. Confirm or override (English / bilingual)?"

### Step 5 — Pre-empt the validation hard-fails

Before emitting `brief.json`, run a pre-emptive scan:

| Hard-fail trigger | Fix at brief stage |
|-------------------|-------------------|
| Top-down TAM only | Ask for bottom-up math: "Customers × Price × Realistic share = ?" |
| Unsourced traction | Tag each number with `source` field — get the source from operator |
| Banned vocabulary in input description | Rewrite the rephrased version; alert the operator |
| Missing meeting date | Ask explicitly |
| Vague ask | Re-ask: "Specific number please" |

Don't let the brief emit with a known hard-fail seed.

### Step 6 — Emit `brief.json`

Output structure:

```json
{
  "schema_version": "1.0",
  "deck_id": "{kebab-case product name}-{audience-mode}-{YYYYMMDD}",
  "created_at": "{ISO 8601 timestamp}",
  "operator": {
    "name": "{operator name}",
    "email": "{operator email}"
  },
  "product": {
    "name": "{Product name}",
    "one_line": "{One-line description}",
    "category": "{e.g. 'B2B SaaS / payments'}",
    "stage": "{pre-revenue / pre-seed / seed / series-a / series-b / etc.}"
  },
  "audience": {
    "description": "{full audience description from operator}",
    "inferred_mode": "{vc / b2b / hybrid}",
    "confirmed_mode": "{operator confirmation}",
    "specific_target": "{named investor or named operator if known, else 'cold-pitch'}"
  },
  "framework": {
    "inferred": "{classic_10 / ai_era_11 / traction_first_13 / classic_10_plus_appendix}",
    "confirmed": "{operator confirmation or override}",
    "rationale": "{why this framework was chosen}"
  },
  "ask": {
    "type": "{vc-round / b2b-pilot / b2b-rollout / hybrid}",
    "amount": "{Rp / USD amount; null if B2B-pilot}",
    "use_of_funds_or_pilot_scope": [
      {"bucket": "...", "percentage_or_scope": "..."}
    ],
    "deadline": "{ISO 8601 date — meeting date / decision deadline}",
    "milestones_or_pilot_timeline": [
      {"month_or_day": "...", "outcome": "..."}
    ]
  },
  "traction": {
    "metrics": [
      {"name": "MRR", "value": "Rp 12 M", "source": "internal data, April 2026"},
      {"name": "Live venues", "value": 47, "source": "internal data, April 2026"}
    ],
    "is_pre_revenue": false,
    "named_partners_or_customers": ["Senayan City", "Lippo Mall Kemang", "..."]
  },
  "market": {
    "tam_bottom_up": {
      "math": "Customers × Price × Realistic share",
      "tam": "Rp 142 T",
      "sam": "Rp 28 T",
      "som": "Rp 4.2 T",
      "source": "BI Statistik Pembayaran 2025 + internal venue analysis Q1 2026"
    },
    "comparable_companies_or_venues": [
      {"name": "Stripe", "geography": "global", "pattern_match_priority": 5},
      {"name": "Yukk", "geography": "indonesia", "pattern_match_priority": 1}
    ]
  },
  "why_now": {
    "specific_shift": "{specific technical / regulatory / behavioral shift}",
    "evidence": "{citation or source}"
  },
  "founder_market_fit": [
    {"founder_name": "...", "shipping_credential": "Scaled X to Y at Z (year)"}
  ],
  "context": {
    "indonesian_context": true,
    "language_default": "id",
    "language_secondary": "en",
    "fx_baseline_idr_per_usd": 16000,
    "compliance_signals_to_surface": ["BI license", "BI-SNAP", "ISO 27001", "Kominfo data residency"]
  },
  "constraints": {
    "page_limit": 11,
    "nda_terms": "{any NDA constraint}",
    "must_say": ["..."],
    "must_not_say": ["..."]
  },
  "warnings": [
    "{any pre-emptive warning surfaced — e.g. 'Top-down TAM detected; converted to bottom-up via Q&A — verify in DD'}"
  ]
}
```

Save to: `{output_dir}/brief.json` (default: current working directory or `/tmp/`).

### Step 7 — Hand-off to storyline

After emitting `brief.json`, output the next-step instruction to the operator:

```
✓ brief.json saved to {path}.

Next: run /pitch-deck-storyline to design the narrative arc.
DO NOT run /pitch-deck-gen yet — storyline must come first.
```

---

## 5. Red Flags (specific, observable behaviors)

| Red flag | Fix |
|----------|-----|
| Operator describes audience as "anyone interested" | Refuse — push for named target or category |
| Operator gives ask as "as much as possible" or "we'll discuss" | Refuse — push for specific number / range |
| Operator gives traction without source ("we have a lot of users") | Refuse — push for "what number, where measured" |
| Operator gives comparable as "we're like Apple of X" | Banned pattern (per `storyline-frameworks.md` §6) — push for valid comparable |
| Operator skips meeting date | Hard-stop — without date the storyline cannot calibrate |
| Brief input contains banned vocabulary | Rephrase + alert operator before storing |
| Two skills running in parallel | Hard-stop — brief must complete before storyline starts |

---

## 6. Rationalization Prevention Table

| What I might think | What the skill says |
|--------------------|---------------------|
| "Audience mode is obvious" | Surface and confirm anyway. Operator overrides happen. |
| "I can fill in the meeting date later" | No. Without date, no Why Now urgency calibration. |
| "Bottom-up TAM is too much friction at brief stage" | Required. Skipping it now hard-fails at validate later. |
| "The operator named a comparable, that's enough" | Verify it's a valid pattern match (priority 1–4 per Indonesian context, not banned). |
| "I'll just write the storyline inline" | NO. Storyline is a separate skill with its own approval gate. |

---

## 7. Verification Checklist

Before emitting `brief.json`:

- [ ] All 12 brief fields populated (or explicitly tagged "operator declined to provide")
- [ ] Mode + framework confirmed (not just inferred)
- [ ] Indonesian-context flag set correctly
- [ ] Every traction number has a `source` field
- [ ] Bottom-up TAM math present (not top-down only)
- [ ] Meeting date / decision deadline is specific (ISO 8601)
- [ ] Comparable companies are valid pattern matches (not banned)
- [ ] No banned vocabulary in operator-rephrased text
- [ ] Constraints captured (NDA, page limit, must-say, must-not-say)
- [ ] Warnings array populated for any pre-emptive flags

If any unchecked, do not emit. Re-run with the operator.

---

## 8. Integration

| Skill | Interaction |
|-------|-------------|
| `pitch-deck-storyline` | CONSUMES `brief.json` from this skill. Cannot run without it. |
| `pitch-deck-gen` | DOES NOT consume `brief.json` directly — only via `storyline.json` produced by `pitch-deck-storyline`. |
| `pitch-deck-validate` | Reads `brief.json` for context (e.g. mode confirmation, source-line audit) but does not score it directly. |
| Other plugins (article-content-writer, linkedin-post-writer) | A finished pitch can be repurposed via these skills; they consume the deck output, not the brief. |
