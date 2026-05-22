---
slug: business-model-patterns
purpose: Pricing model library, promo tactics, revenue architecture, brochure articulation patterns for B2B SaaS/product/service
applies_to: [brochure-product, catalog-product, deck-vc, deck-b2b, service-flyer]
research_basis: references/research/business-model-patterns-2026.md
status: thin-wrapper-pending-migration
migration_target: D:\Projects\indusia-skills\skills\senior-bizmodel-architect-id (skill extraction in 2026-Q3)
---

# Business Model Patterns — Thin Wrapper

## ⚠️ MIGRATION TODO (2026-Q3)

Full content lives in `references/research/business-model-patterns-2026.md` (39 sources, NotebookLM deep research, FRESH freshness tier, refresh_after 2027-05-21). This file is a local plugin reference cache until the skill `senior-bizmodel-architect-id` exists at `D:\Projects\indusia-skills\skills\senior-bizmodel-architect-id\`. When that skill is built, this file will be deleted and skill-orchestration replaces local cache.

Migration mechanism: copywriting + brief skills currently consult this file inline; post-migration they will invoke `senior-bizmodel-architect-id` via plugin-skill IPC, with the research cache file moving into the skill's `references/` folder.

---

## When to Consult Business Model Patterns

Trigger conditions during the 5-stage pipeline:

- `brief.json` mentions pricing tier, package, paket, harga, subscription, AMC, freemium, hybrid.
- `output_type` ∈ [brochure-product, catalog-product, deck-vc, deck-b2b, service-flyer].
- Copywriting stage detects pricing language in headline / sub-text and needs articulation reference.
- Validation stage scores a Pricing Articulation sub-category and needs benchmark patterns.

If none of the triggers fire → skip this file. Don't pre-load business-model context into briefs that don't need it.

---

## Quick Reference Index

| Topic | Section in research file |
|---|---|
| Pricing models (SaaS tier, one-time + AMC, usage-based, freemium, hybrid, PAYG, outcome-based) | `references/research/business-model-patterns-2026.md §1` |
| Promotional pricing tactics (anchor, decoy, dual-price slash, urgency) | `§2` |
| Revenue model architecture (financing, partnership, hardware-software combos) | `§3` |
| Bundling vs unbundling strategy | `§4` |
| Indonesian B2B pricing specifics (PPN inclusion, IDR shorthand "jt"/"rb", PT/CV legal name on quote) | `§5` |
| 2024-2026 playbook shifts (AI / Jevons paradox / hollowing middle / output-based) | `§6` |
| Brochure articulation patterns (visual style, comparison table, CTA precision, QR pricing calculator) | `§7` |
| Final pricing articulation checklist | `§8` |

---

## Integration with Copywriting Stage

The Phase F skill `ai-business-document-copywriting` (future, not yet built) will load both this wrapper + `references/research/business-model-patterns-2026.md` when authoring pricing tier copy. Until that skill exists, the existing `pitch-deck-gen` flow reads pricing copy directly from `brief.json.pricing_tier` array.

Reference flow when copywriting skill exists:

```
brief.json (pricing_tier declared)
  → copywriting skill loads business-model-patterns.md (this file)
  → cross-reference §7 brochure articulation in research file
  → output: pricing copy with dual-price slash, checklist density table, urgency tag
  → validate via scoring-rubric.md (Print-Mode Rubric > CTA Clarity sub-category)
```

---

## Banned Pricing Patterns

Adds to `references/global-config.md §4` (global banlist). Pricing-specific weak patterns that surface in Indonesian B2B brochures.

| Banned pattern | Why it fails | Replace with |
|---|---|---|
| "Mulai dari Rp X" without ceiling | Creates ambiguity — reader assumes worst case | Range "Rp X - Rp Y" OR "Mulai Rp X, lihat tiga paket di hal. 4" |
| Hidden PPN (revealed only at footnote / fine print) | Trust collapse at purchase time | Display "Sudah termasuk PPN 11%" prominently next to every price |
| "Hubungi untuk harga" as default tier | Weak signal — implies pricing is shameful | At minimum give starting price + "Request quote untuk paket Enterprise" |
| Anchor tier price spread too wide vs mid tier | Mid-tier becomes unbelievable as best-deal | Use 50-100% price spread between tiers (Rp 150jt / Rp 245jt / Rp 305jt = INDUSIA reference) |
| "Harga promo terbatas" without deadline | No urgency without absolute date | "Promo berakhir 31 Mei 2026 · 12 slot tersisa" |
| "Diskon hingga X%" without anchor | Empty % without strikethrough makes the discount feel fake | "~~Rp 425jt~~ → Rp 305jt (HEMAT Rp 120jt = 28% off)" |
| Free-trial CTA with hidden conversion mechanic | Card-required free trial framed as "gratis" loses trust | "Gratis 30 hari, tanpa kartu kredit, tanpa auto-renew" |
| Currency mixed inconsistently (USD on cover, IDR on pricing page) | Reader does mental math, drops off | Pick one primary currency per document. Use parenthetical for the other: "Rp 305jt (~$19,000)" |

> Source: `references/research/business-model-patterns-2026.md §2` (anchor pricing exact figures rule) + `§5` (Indonesian B2B specifics — PPN, PT/CV legal, IDR shorthand) + `§8` (final pricing articulation checklist).
