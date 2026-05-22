---
name: ai-business-document-copywriting
description: Stage 3 per-page copywriting for ai-business-document-designer pipeline. Runs AFTER ai-business-document-narrative has produced an approved narrative.json. Authors headline (≤10 words), sub-text (≤25 words — numbers + proper nouns only), CTA copy per output_type (PILIH PAKET, MARI BICARA, JOIN OUR ROUND, etc.), pricing tier dual-price-slash articulation (HEMAT Rp X badge + IDR strikethrough + PPN 11% explicit), and bilingual ID+EN variants when brief.json.language="bilingual". HUMAN APPROVAL GATE before downstream visual gen — copy must be locked before image/HTML tokens are spent.
triggers: [copywriting, copy, headline, sub-text, CTA, pricing-tier, bilingual, copy-pass, tier-articulation, slogan, dual-price-slash, hemat-callout]
---

# AI Business Document Copywriting — Stage 3: Per-Page Copy Authoring

Stage 3 of 5. Reads `brief.json` (Stage 1) + `narrative.json` (Stage 2). For each page/slide, authors headline + sub-text + CTA + pricing tier articulation + bilingual variant (when requested). Emits `copy.md` (human-readable review showcase) + `copy.json` (machine-readable for `ai-business-document-gen`). HUMAN APPROVAL GATE before Stage 4 — no visual tokens are spent until copy is locked.

> **Where this fits:** `ai-business-document-brief` → `ai-business-document-narrative` → **`ai-business-document-copywriting`** → `ai-business-document-gen` → `ai-business-document-validate`. See `CLAUDE.md` for the full pipeline.

---

## Announce at Start

> "I'm using the ai-business-document-copywriting skill to write per-page copy."

Emit this verbatim at the top of the first reply when invoked. No paraphrase, no translation. This signals to the operator (and downstream agents) that Stage 3 has begun and the HUMAN APPROVAL GATE is now active.

---

## Inputs

Two required JSON files from upstream stages. Both are mandatory — the skill refuses to run if either is missing or schema-invalid.

| Flag | Default | Source | Purpose |
|------|---------|--------|---------|
| `--brief-file` | `./brief.json` | Stage 1 (`ai-business-document-brief`) | Output_type, language, pricing_tier_count, audience archetype, banned vocab overrides |
| `--narrative-file` | `./narrative.json` | Stage 2 (`ai-business-document-narrative`) | Page list with page_role + headline_pattern + visual_concept per page |
| `--output-dir` | `./` | operator | Where `copy.md` + `copy.json` are written |
| `--auto-approve` | `false` | operator (batch agent use) | Skip HUMAN APPROVAL GATE — only for trusted batch invocations |

CLI example:

```
ai-business-document-copywriting \
  --brief-file ./brief.json \
  --narrative-file ./narrative.json \
  --output-dir ./
```

If `brief.json.pricing_tier_count > 0` and `output_type ∈ [brochure-product, catalog-product]`, the Pricing Tier Articulation sub-pipeline activates automatically — no extra flag required.

---

## Outputs

Two files written to `--output-dir`. Both must exist before the HUMAN APPROVAL GATE renders.

### `copy.md` — human-readable review showcase

Page-by-page markdown. Each page section displays headline + sub-text + CTA + pricing block (if applicable) + bilingual variant (if applicable) + hard-rules checklist (pass/fail per rule). Operator scans this file to approve or request revisions.

### `copy.json` — machine-readable handoff

```json
{
  "schema_version": "1.0",
  "doc_id": "{from brief.json}",
  "output_type": "{brochure-product | catalog-product | service-flyer | portfolio-personal | portfolio-agency | deck-vc | deck-b2b | trifold | one-pager}",
  "language": "{id | en | bilingual}",
  "approved_at": null,
  "approved_by": null,
  "pages": [
    {
      "page_n": 1,
      "page_role": "{cover | hero | modular | pricing | cta | spec | testimonial | etc.}",
      "headline_formula_used": "{question_hook | promise_stake | number_driven | contrast_slash | owner_tone_direct}",
      "headline": {
        "primary": "Berapa truk berangkat tanpa Anda tahu?",
        "secondary": null,
        "bilingual": {
          "id": "Berapa truk berangkat tanpa Anda tahu?",
          "en": "How many trucks left without you knowing?"
        }
      },
      "sub_text": {
        "id": "5x EdgeLink + 2x YardSync + 5 FuelSense sensor. Garansi hardware 1 tahun. Telemetry per 15 detik.",
        "en": "5x EdgeLink + 2x YardSync + 5 FuelSense sensors. 1-year hardware warranty. Telemetry every 15 seconds."
      },
      "cta": {
        "type": "PILIH_PAKET",
        "primary_text": "PILIH PAKET — Konsultasi Pak Hendra (Sales Lead) → WA 0812-3456-7890",
        "secondary_text": "Scan QR — Pre-launch promo aktif sampai 31 Mei 2026."
      },
      "pricing_block": {
        "active": true,
        "strikethrough_price_idr": "Rp 425jt",
        "promo_price_idr": "Rp 305jt",
        "savings_callout": "HEMAT Rp 120jt",
        "ppn_disclosure": "Sudah termasuk PPN 11%",
        "urgency_tag": "Promo berakhir 31 Mei 2026 · 12 slot tersisa"
      },
      "hard_rules_check": {
        "headline_word_count": 6,
        "headline_under_10": true,
        "sub_text_word_count": 18,
        "sub_text_under_25": true,
        "banned_vocab_clean": true,
        "banned_pattern_clean": true,
        "ppn_explicit": true,
        "all_rules_passed": true
      }
    }
  ]
}
```

The JSON is the contract for `ai-business-document-gen` — that stage reads `copy.json` directly and renders into HTML/image/spec output without re-deriving copy.

---

## Pre-checks (mandatory reads)

ALWAYS load — every invocation, no exception:

1. `brief.json` (verify `output_type`, `language`, `pricing_tier_count`, `audience.archetype`)
2. `narrative.json` (verify `pages[]` array exists with `page_role` + `headline_pattern` per page; refuse if narrative not approved)
3. `references/copywriting-patterns.md` (headline formulas, sub-text discipline, CTA per output_type, banned copy patterns)
4. `references/global-config.md` §4 (banned vocab list — auto-grep target)

Conditional reads — based on brief.json fields:

| Brief.json signal | Also load |
|---|---|
| `output_type ∈ [brochure-product, catalog-product]` AND `pricing_tier_count > 0` | `references/business-model-patterns.md` + `references/research/business-model-patterns-2026.md` §7 brochure articulation |
| `language ∈ [id, bilingual]` (i.e., anything NOT English-only) | `references/indonesian-context.md` + `references/research/indonesian-print-culture-2026.md` §6 headline convention |
| `output_type ∈ [deck-vc, deck-b2b]` | `references/investor-psychology.md` §2 (first-90-second filters — informs hook/CTA tone) |
| `audience.archetype = "ethnic-chinese-batam-medan-surabaya"` | `references/research/indonesian-print-culture-2026.md` §6 Hokkien-flavored register |
| `output_type ∈ [portfolio-personal, portfolio-agency]` | `references/visual-language.md` (sub-text ≤25 word discipline reminder) |

If any mandatory file is missing → STOP. Tell the operator which file is missing and where to find it. Do not invent copy from memory.

---

## Pipeline: Per-Page Copy Authoring (10-step)

Execute sequentially for every invocation. Steps 1–9 are deterministic; step 10 emits artifacts.

### Step 1 — Iterate narrative.json pages

Load `narrative.json.pages[]`. For each page, capture `page_n`, `page_role`, `headline_pattern` (recommended formula from Stage 2), `visual_concept` (drives sub-text grounding), and any `pricing_tier_index` reference. This is the iteration spine — every subsequent step runs once per page.

### Step 2 — Determine page_role + formula constraint

`page_role` is set by Stage 2 (one of: `cover`, `hero`, `modular`, `pricing`, `cta`, `spec`, `testimonial`, `team`, `closing`). Each role narrows the eligible headline formula:

| page_role | Eligible headline formulas | Forbidden |
|---|---|---|
| cover | Question Hook, Contrast Slash, Owner-Tone Direct | Number-driven (too data-dense for a cover) |
| hero | Promise + Stake, Owner-Tone Direct | Question Hook (cover already asked it) |
| modular (interior) | Number-driven, Promise + Stake | Question Hook (loses impact in mid-document) |
| pricing | Number-driven, Promise + Stake | Question Hook, Contrast Slash |
| cta | Promise + Stake, Owner-Tone Direct | Number-driven |
| spec / catalog detail | Number-driven | Question Hook |
| testimonial | (quoted text only — no formula applies) | n/a |
| closing | Promise + Stake | Question Hook |

### Step 3 — Select headline formula from copywriting-patterns.md

Reference: `references/copywriting-patterns.md` §"Headline Formula". Pick from the five formulas — never invent a sixth:

1. **Question Hook** — visceral pain question, owner-tone (e.g., "Berapa truk berangkat tanpa Anda tahu?")
2. **Promise + Stake** — outcome + delivery mechanism (e.g., "Lihat semua dari HP, 24/7.")
3. **Number-driven** — integers replace adjectives (e.g., "5 modul, 1 platform, 0 telpon manual.")
4. **Contrast Slash** — three short clauses, full stops or em-dashes (e.g., "Truk jalan. BBM jalan. Data tidak.")
5. **Owner-Tone Direct** — you-vs-them comparison (e.g., "Anda menebak. INDUSIA = Anda tahu.")

Cross-check the tonal register decision matrix in `copywriting-patterns.md` against `brief.json.audience.archetype`:

- Owner-operator B2B → Question Hook → Owner-Tone Direct → Contrast Slash
- Tech B2B SaaS buyer → Promise + Stake → Number-driven
- Indonesian VC investor → Number-driven → Promise + Stake (no Question Hook)
- B2C consumer → Contrast Slash → Promise + Stake
- Ethnic-Chinese Batam/Medan/Surabaya → Owner-Tone Direct + Hokkien-flavored

### Step 4 — Write headline (≤10 words, language_default)

Write the headline in `brief.json.language_default` first. Constraints:

- **Hard cap**: 10 words. Count includes articles + prepositions. Going over = HARD FAIL, rewrite.
- **No banned vocab**: cross-check `references/global-config.md §4` (Indonesian: `solusi terbaik`, `inovatif`, `terdepan`, `terbaik di kelasnya`, `revolusioner`, `mengubah cara`, `mendisrupsi`).
- **Specificity over poetry**: a concrete noun + a concrete verb beats an abstract aspiration.

If `brief.json.language = "bilingual"`, write the English variant immediately after. The EN line is the *subtitle* (60% smaller in render), NOT a literal translation — it preserves the meaning while sounding native in English. Example pair from `copywriting-patterns.md`:

- ID: "Lihat semua dari HP, 24/7."
- EN: "See everything from your phone. 24/7."

### Step 5 — Write sub-text (≤25 words, numbers + proper nouns only)

Formula from `copywriting-patterns.md` §"Sub-text Discipline":

```
<what> + <quantification> + <proof>
```

Constraints:

- **Hard cap**: 25 words. Over = HARD FAIL, rewrite.
- **Numbers + proper nouns only**: adjectives die. "Garansi hardware 1 tahun" survives; "garansi hardware terpercaya" gets cut.
- **Three components**: if any one of `what / quantification / proof` is missing, the sub-text is filler — rewrite.

Real example (INDUSIA brochure pricing page):

- ID: "5x EdgeLink + 2x YardSync + 5 FuelSense sensor. Garansi hardware 1 tahun. Telemetry per 15 detik."
- EN: "5x EdgeLink + 2x YardSync + 5 FuelSense sensors. 1-year hardware warranty. Telemetry every 15 seconds."

If the page is a pricing-tier page, sub-text proves the tier's contents (units, warranty, SLA) rather than restating headline.

### Step 6 — Pricing tier articulation (when page_role = "pricing" OR pricing_tier_index is set)

Trigger this sub-pipeline if `brief.json.pricing_tier_count > 0` AND current page references a tier. Run the 5-step Pricing Tier Articulation flow below (see next H2 section). Output gets attached as `pricing_block` in the page's JSON entry.

For non-pricing pages, set `pricing_block.active = false` and skip this step.

### Step 7 — Write CTA copy per output_type pattern

CTA copy is rigidly mapped to `brief.json.output_type`. Reference: `copywriting-patterns.md` §"CTA Patterns". One pattern per output_type — never mix.

| Output_type | CTA pattern | Example |
|---|---|---|
| brochure-product | `PILIH PAKET` + sales contact sticker + WhatsApp QR | "PILIH PAKET — Konsultasi Pak Hendra (Sales Lead) → WA 0812-3456-7890" |
| catalog-product | `REQUEST QUOTE` + multi-channel | "REQUEST QUOTE — Email sales@indusia.ai atau WA 0812-xxx" |
| service-flyer | Single dominant CTA (>60% below-fold) | "BOOK INTRO CALL — 30 menit. Gratis. Slot terbatas. → indusia.ai/intro" |
| portfolio-personal | Soft-CTA, relational | "MARI BICARA — alisadikinma@gmail.com" |
| portfolio-agency | Soft-CTA, relational | "LIHAT KASUS LENGKAP — Request case study PDF via WhatsApp" |
| deck-vc | The ask slide | "JOIN OUR ROUND — Raising USD 2M seed at $12M pre. Use of funds: 60% eng, 30% GTM, 10% ops." |
| deck-b2b | Commercial timeline | "INTEGRATION TIMELINE — 4-week pilot, 8-week rollout, 12-week pricing review. SLA 99.5%." |
| trifold | `PILIH PAKET` (small variant — trifold = brochure-class) | "PILIH PAKET — Scan QR untuk kalkulator harga." |
| one-pager | Single dominant CTA | "KONSULTASI GRATIS — WA 0812-xxx, jawab dalam 2 jam kerja." |

Every CTA includes: (a) a verb in ALL CAPS, (b) a specific channel (WhatsApp number, email, URL, calendar link), (c) a human name OR named role when possible, (d) a time-bounded promise when one applies ("2 jam kerja", "Slot Q2 2026 tinggal 12 dari 50").

### Step 8 — Cross-check banned vocabulary (auto-grep)

Run grep against all written copy on this page (headline + sub-text + CTA + pricing block). Targets:

- Indonesian banned vocab from `global-config.md §4`: `solusi terbaik`, `inovatif`, `terdepan`, `terbaik di kelasnya`, `revolusioner`, `mengubah cara`, `mendisrupsi`
- Pricing-specific banned patterns from `business-model-patterns.md`: "Mulai dari Rp X" (no ceiling), "Hubungi untuk harga" (no anchor), "Diskon hingga X%" (no strikethrough), "Harga promo terbatas" (no deadline)

Any hit = HARD FAIL on that page. Rewrite the offending field. Re-grep until clean.

### Step 9 — Cross-check banned copy patterns

From `copywriting-patterns.md` §"Banned Copy Patterns" table:

| Banned phrase | Replace with |
|---|---|
| "Hub kami sekarang" | Specific channel + named human + role |
| "Untuk informasi lebih lanjut" | Cut entirely, jump to action |
| "Solusi terbaik untuk bisnis Anda" | Concrete archetype + named pain |
| "Dapatkan penawaran spesial" | Quantified savings + absolute deadline |
| "Kami berkomitmen melayani Anda" | Quantified SLA + named channel |
| "Tingkatkan produktivitas bisnis" | Specific time-saved figure |
| "Bergabunglah dengan kami" | Specific onboarding URL + slot count |
| "Sebagai mitra terpercaya" | Numbered partner list + named clients |

These patterns survive global-vocab grep (no single banned word) but signal weak copy. Reject + rewrite per the table.

### Step 10 — Emit copy.md + copy.json

After all pages clear steps 1–9, write both files to `--output-dir`. `copy.md` opens with the document title + output_type + language + a "Pages overview" table (page_n / page_role / formula_used / word_counts), then renders each page section with the full copy + hard_rules_check checklist. `copy.json` follows the schema in the Outputs section.

After emit, render the HUMAN APPROVAL GATE block (see below). The skill stops there. Do not invoke Stage 4.

---

## Pipeline: Pricing Tier Articulation (when applicable)

Sub-flow that runs inside Step 6 when `pricing_tier_count > 0` AND page references a tier. Five steps:

### Step (a) — Load business-model-patterns.md Quick Reference Index

Read `references/business-model-patterns.md` §"Quick Reference Index" — locate the topic relevant to the current tier (SaaS / one-time + AMC / hybrid / usage-based / freemium). Follow the link into `references/research/business-model-patterns-2026.md §1` for the pricing model details.

### Step (b) — Read research file §7 brochure articulation

Open `references/research/business-model-patterns-2026.md §7` for the brochure articulation patterns: anchor pricing exact-figures rule, checklist density rule, asymmetric dominance (decoy effect), CTA precision, QR pricing calculator pattern. These are the visual + copy specs the pricing block must satisfy.

### Step (c) — Write tier comparison table copy

3-column layout. Default tier names: Bronze / Silver / Gold (Indonesian B2B) OR Free / Pro / Enterprise (SaaS). Set the middle tier as the anchor — apply "★ BEST DEAL" badge — unless `brief.json.pricing_anchor_tier` overrides. INDUSIA reference pricing for tier-spread benchmarking:

| Tier | Price (IDR) | Use as |
|---|---|---|
| Bronze | Rp 150jt | Entry tier — limited modules |
| Silver ★ BEST DEAL | Rp 245jt | Anchor tier — pushed by sales |
| Gold | Rp 305jt | Top tier — full modules + SLA hotline |

Per-row copy uses the sub-text discipline (numbers + proper nouns). `Modul EdgeLink: ✓ 3 unit` beats `Modul EdgeLink: tersedia`.

### Step (d) — Write dual-price-slash + promo prominent

INDUSIA prelaunch reference for the anchor tier:

```
HEMAT Rp 120jt
~~Rp 425jt~~  →  Rp 305jt
Sudah termasuk PPN 11%.
```

Visual rules carried into `pricing_block` JSON:

- `strikethrough_price_idr`: original price (greyed-out in render)
- `promo_price_idr`: promo price (brand accent, 56–72pt in render)
- `savings_callout`: "HEMAT Rp X" (red banner OR brand-accent badge)
- `ppn_disclosure`: "Sudah termasuk PPN 11%" (mandatory — never hide PPN)

Numbers must be exact figures from `brief.json.pricing_tier[]`. No "mulai dari" abstractions. Reference: `business-model-patterns-2026.md §2` (Accurate Online benchmark: `~~Rp 4.262.400~~ → Rp 3.219.000 (Diskon 25%)`).

### Step (e) — Write HEMAT savings callout + urgency tag (if launch/expiry)

Urgency tag is conditional — apply only if `brief.json.promo_deadline_iso` is set AND `brief.json.urgency_tag_allowed = true`. Format:

```
PROMO BERAKHIR 31 MEI 2026 · 12 SLOT TERSISA
```

Rules:

- ONE urgency tag per document. Never two. Never on every page.
- Deadline must be an absolute date in ALL CAPS.
- Slot/inventory scarcity number must be specific ("12 slot tersisa"), not vague ("terbatas").
- If `brief.json.promo_deadline_iso` is null, set `urgency_tag = null` — don't invent urgency.

> **Migration note (2026-Q3):** When the skill `senior-bizmodel-architect-id` exists at `D:\Projects\indusia-skills\skills\senior-bizmodel-architect-id\`, this sub-pipeline will delegate pricing-articulation Q&A to that skill via plugin-skill IPC (operator confirms pricing model + tier names + anchor decoy choice, then this skill consumes the answer and writes copy). Until that skill is built, the sub-pipeline runs inline using `references/business-model-patterns.md` + research cache. See `business-model-patterns.md` frontmatter `migration_target` for the migration contract.

---

## HUMAN APPROVAL GATE

After `copy.md` + `copy.json` are emitted, render the gate block to the operator:

```
✓ copy.md saved to {path} (review this — per-page headline + sub-text + CTA + pricing)
✓ copy.json saved to {path} (machine-readable for /ai-business-document-gen)

⚠ HUMAN APPROVAL GATE — Stage 3 / 5

Review copy.md. Visual generation in Stage 4 will spend significant tokens
(image prompts, HTML render, OR layout-spec rendering). Copy must be locked
before that cost is incurred.

Operator options:
  1. APPROVE — Reply "/ai-business-document-copywriting approve"
  2. REFINE — Describe what to change (specific page, specific field)
  3. REDO — Re-run from scratch with revised inputs

Once approved, run /ai-business-document-gen to spend tokens on visuals.
DO NOT run /ai-business-document-gen before copy is approved.
```

Then invoke `AskUserQuestion` with the three options. Capture the response:

- `approve` → set `approved_at` (ISO 8601) + `approved_by` (operator handle) in `copy.json`. Save the updated JSON. Stop.
- `refine` → operator describes the change. Apply edits to the specific page(s). Re-run steps 8–10 for affected pages. Re-render gate.
- `redo` → discard outputs, re-run pipeline from Step 1.

**Override**: if invoked with `--auto-approve`, skip the AskUserQuestion call, set `approved_by = "auto-approve-batch"`, and proceed. This flag is for trusted batch-agent invocations only — never the default.

---

## Hard Rules

These rules are non-negotiable. Each one is auto-checked in `copy.json.pages[].hard_rules_check`. Any rule violation = the page does not pass.

1. **Headline ≤10 words on EVERY page.** Count includes articles + prepositions. ≥1 word over = HARD FAIL on that page — rewrite before emit.
2. **Sub-text ≤25 words on EVERY page.** Same rule. ≥1 word over = HARD FAIL.
3. **No banned vocabulary anywhere.** Auto-grep at end of pipeline against `global-config.md §4` Indonesian banlist (`solusi terbaik`, `inovatif`, `terdepan`, `terbaik di kelasnya`, `revolusioner`, `mengubah cara`, `mendisrupsi`) AND pricing-specific banlist from `business-model-patterns.md` §"Banned Pricing Patterns".
4. **Numbers and proper nouns only in sub-text.** No adjectives like "amazing", "fantastic", "terbaik", "luar biasa". Concrete units, prices, durations, brand names — nothing else.
5. **Every claim sourced or tagged "internal estimate".** If sub-text says "92% merchant retention after 90 days", `brief.json.evidence[]` must contain the source. If not, tag the figure with `(internal estimate)` inline.
6. **IDR primary for Indonesian audience.** USD parenthetical is OK for export-targeted docs ("Rp 305jt (~$19,000)"). Never mix currencies inconsistently across pages.
7. **PPN inclusion explicit on every price.** "Rp X jt incl. PPN 11%" OR a visible "Sudah termasuk PPN 11%" line next to every price. Hidden PPN = trust collapse — auto-reject.
8. **Pricing tier dual-price-slash MANDATORY for brochure-product / catalog-product when a tier exists.** Strikethrough original price + promo price prominent + HEMAT savings callout. Skipping the slash = HARD FAIL when `pricing_tier_count > 0`.
9. **Bilingual format: ID primary + EN subtitle.** When `language = "bilingual"`, Bahasa goes top (large), English goes underneath (60% smaller in render, 50% ink opacity). Never invert. Never duplicate — EN must paraphrase meaning, not transliterate.
10. **Hokkien-flavored register only if archetype matches.** Apply Hokkien-flavored Bahasa (`cengli`, "Coba sebulan. Kalau cocok, lanjut.") only when `brief.json.audience.archetype = "ethnic-chinese-batam-medan-surabaya"`. Applying elsewhere = tonal failure.

If any rule fails on any page → DO NOT emit `copy.json` with `all_rules_passed: true`. Fix the offending page first.

---

## Reference Loading Cheat Sheet

Which references to pre-load per `brief.json.output_type`. ALL invocations load the core 4 (`brief.json`, `narrative.json`, `copywriting-patterns.md`, `global-config.md`); this table lists ADDITIONAL refs.

| output_type | Additional refs to load |
|---|---|
| brochure-product | `business-model-patterns.md` + `research/business-model-patterns-2026.md` §7, `indonesian-context.md`, `research/indonesian-print-culture-2026.md` §6 |
| catalog-product | `business-model-patterns.md` + `research/business-model-patterns-2026.md` §7 + §2 (anchor pricing), `indonesian-context.md` |
| service-flyer | `indonesian-context.md`, `research/indonesian-print-culture-2026.md` §6 |
| portfolio-personal | `visual-language.md` (sub-text discipline reminder), `indonesian-context.md` (if language ≠ en) |
| portfolio-agency | `visual-language.md`, `research/indonesian-print-culture-2026.md` §6 |
| deck-vc | `investor-psychology.md` §2 first-90-second filters, `research/indonesian-print-culture-2026.md` §3 (bilingual convention if international round) |
| deck-b2b | `investor-psychology.md` §2, `business-model-patterns.md` (if commercial terms include pricing) |
| trifold | Same as brochure-product (trifold is a brochure subclass) |
| one-pager | `indonesian-context.md`, `visual-language.md` |

Conditional layers (apply on top of the row above):

- `language ∈ [id, bilingual]` → ALWAYS add `indonesian-context.md` + `research/indonesian-print-culture-2026.md` §6
- `pricing_tier_count > 0` → ALWAYS add `business-model-patterns.md` + research §7
- `audience.archetype = "ethnic-chinese-batam-medan-surabaya"` → ALWAYS add research §6 Hokkien-flavored register

If a reference fails to load, log the failure and stop. Do not invent copy patterns from memory — the references are the source of truth.
