# Research Cache Index — ai-business-document-designer

**Generated**: 2026-05-21 via NotebookLM deep research (Gemini 2.0 backend)
**Refresh recommended**: 2027-05-21 (annual) or when validation results consistently misalign
**Account**: ali.sadikincom85@gmail.com

## How skills consume these files

Each skill reads relevant research file(s) via `--append-system-prompt-file` injection. See `cheat sheet` in `../../CLAUDE.md` (once written) for per-skill mapping. The structured report markdown is the primary asset; audio podcasts are for operator listening only (not auto-injected).

## Research Files

| Slug | File | Source Count | Notebook (NotebookLM Web) | Audio |
|------|------|--------------|---------------------------|-------|
| design-fundamentals-2026 | [design-fundamentals-2026.md](./design-fundamentals-2026.md) | 66 | `pcd-design` — `ac378359-2ed6-40a2-a920-0e273e963456` | [56MB MP3](./audio/design-fundamentals-2026.mp3) |
| pdf-print-production-2026 | [pdf-print-production-2026.md](./pdf-print-production-2026.md) | 74 | `pcd-print` — `b42e9bf6-e49e-4494-b039-5e3c62255d9f` | [84MB MP3](./audio/pdf-print-production-2026.mp3) |
| framework-structures-2026 | [framework-structures-2026.md](./framework-structures-2026.md) | 59 | `pcd-frameworks` — `ff78748d-a62a-41b5-a22a-52277769cbe2` | [92MB MP3](./audio/framework-structures-2026.mp3) |
| indonesian-print-culture-2026 | [indonesian-print-culture-2026.md](./indonesian-print-culture-2026.md) | 58 | `pcd-indo` — `d75e20bc-a851-44d8-8c94-4eff4e2f5668` | [64MB MP3](./audio/indonesian-print-culture-2026.mp3) |
| business-model-patterns-2026 | [business-model-patterns-2026.md](./business-model-patterns-2026.md) | 39 | `pcd-bizmodel` — `ff5fbf31-80ae-4053-9e70-5419d7651396` | [109MB MP3](./audio/business-model-patterns-2026.mp3) |
| executive-deck-craft-2026 | [executive-deck-craft-2026.md](./executive-deck-craft-2026.md) | 10 | `Pitch Deck Excellence + Nano Banana Pro RAG` — `1f9dbaf4-4087-4c84-af65-c1b0b21d92d2` | — |
| nano-banana-pro-prompting-2026 | [nano-banana-pro-prompting-2026.md](./nano-banana-pro-prompting-2026.md) | 10 | `Pitch Deck Excellence + Nano Banana Pro RAG` — `1f9dbaf4-4087-4c84-af65-c1b0b21d92d2` | — |

**Total**: 316 imported sources across 6 notebooks. 7 markdown reports, 5 audio podcasts (403MB combined, kept locally, gitignored). (Also present: `investor-pitch-deck-best-practices-2026.md` — VC/DocSend lens.)

> **2026-05-31 addition** (Gemini 3 backend, fast research): `executive-deck-craft-2026` and `nano-banana-pro-prompting-2026` were added to fix root-cause deck-quality issues (text-heavy, non-visual decks). They are the knowledge layer behind `../deck-infographic-system.md` (deck construction) and `../image-prompt-templates.md` (NB2 prompting).

## Coverage Map

```
design-fundamentals-2026       → grids, typography, color, visual flow, anti-AI-slop banlist
  ↳ Read by: print-collateral-layout, print-collateral-gen, print-collateral-validate

pdf-print-production-2026      → CMYK, bleed, 300dpi, font embed, PDF/X, paper stock, HTML-to-PDF
  ↳ Read by: print-collateral-gen, print-collateral-validate

framework-structures-2026      → product brochure, portfolio personal/agency, service flyer, catalog, trifold
  ↳ Read by: print-collateral-brief, print-collateral-layout, print-collateral-validate

indonesian-print-culture-2026  → paper stock lokal, printer SOP, bilingual convention, PT/PPN/BPOM, owner-archetype perception
  ↳ Read by: print-collateral-brief, print-collateral-copywriting, print-collateral-validate

business-model-patterns-2026   → pricing model library, promo tactics, revenue arch, bundling, brochure articulation
  ↳ Read by: print-collateral-brief, print-collateral-copywriting, print-collateral-validate
```

## Refresh Process

To refresh any research file:

```bash
# Set alias to existing notebook (if not already aliased)
nlm alias set pcd-design ac378359-2ed6-40a2-a920-0e273e963456

# Re-run deep research (overwrites existing task)
nlm research start "<refresh query>" --notebook-id pcd-design --mode deep --force

# Wait + import + regenerate report
nlm research status pcd-design --max-wait 600
nlm research import pcd-design <new-task-id>
nlm report create pcd-design --format "Create Your Own" --prompt "<same prompt as 2026-05-21>" --confirm
nlm download report pcd-design --output references/research/design-fundamentals-2026.md

# Update frontmatter date + freshness_tier
```

Alternatively use `--refresh-research` CLI flag on plugin skills (planned, not yet implemented).

## Freshness Tiers

- 🟢 **FRESH** (0-6 months): just-generated, trust fully
- 🟡 **AMBER** (6-12 months): mostly valid, verify recent industry shifts
- 🟠 **STALE** (12-18 months): may have outdated examples, refresh recommended
- 🔴 **EXPIRED** (>18 months): high drift risk, do not trust without re-research

Current status (2026-05-21): all 5 files are 🟢 FRESH.

## Notes on Quality

- **NotebookLM "Create Your Own" report** has a soft cap around 1200-1600 words. Our requested 4000-5000 was capped — but density is high (every sentence sourced and load-bearing).
- **Audio podcasts** are deep_dive `long` format, 30-90 minutes each. NB5 (business-model-patterns) is longest at 109MB.
- **Mindmaps** were generated (5 total) but tracked under `flashcards` type in `nlm studio status` output (NotebookLM CLI quirk). Access via NotebookLM web UI using the notebook IDs above.
- **Source coverage**: NB1 design (Monteiro, Vignelli, Müller-Brockmann, Saltz, Cheng, Pentagram), NB2 print (Adobe, Prepressure, Smallpdf, Puppeteer), NB3 frameworks (Behance, Awwwards, Communication Arts, van Schneider), NB4 indo (BPS, PPN 2025, Indonesian agency portfolio), NB5 bizmodel (ProfitWell, OpenView, Tunguz, Pricing I/O).
