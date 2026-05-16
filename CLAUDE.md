# Pitch Deck Designer — Claude Project Instructions

## 🧠 Vault Context Link

Skill library — agnostic, dipakai cross-project (INDUSIA, IRN, dll).

Pre-read kalau perlu konteks:
- `30-Knowledge/image-gen-shared.md` — NB2 prompt engineering (re-used untuk slide visuals)
- `30-Knowledge/content-strategy-shared.md` — narrative arc, hook design
- `20-Projects/claude-plugin/README.md` — skill ecosystem overview
- `10-Identity/visual-identity.md` — color, font, image style untuk anti-AI-slop
- `10-Identity/voice-tone.md` — speaker notes voice

JANGAN hardcode project-specific values (nama klien, ask amount, comparable). Pakai `{{placeholder}}` syntax di SKILL.md.

## Project Overview

Claude Code plugin that converts a one-paragraph product brief into a presentation-ready pitch deck specification. Visual-first by mandate (≥70% visual / ≤30% text per slide). Dual-mode adaptive: detects whether the audience is a **B2B channel partner** (mall/EO/food-court operator who'll deploy our SaaS) or an **equity VC** (Series A/B fundraise) and reshapes the 10-slide narrative arc and emphasis accordingly. Generates per-slide image prompts (GeminiGen.AI / Nano Banana Pro), Seedance 2.0 video animation prompts (where motion adds value), optional Remotion configs (programmatic motion), and persuasive Indonesian/English speaker notes. Validation gate enforces the 100-point Pitch Deck Quality Score (Visual Ratio + Narrative Arc + Ask Clarity + Investor Psychology + Anti-AI-Slop) before output.

Four skills + one agent + 12 reference files. The 4-stage pipeline (brief → storyline → gen → validate) separates narrative design from visual production — so the storyline can be locked-in and approved before any image/video tokens are spent. Optimized for Indonesian audience as default but reusable for any product / market via `global-config.md`.

## Architecture

| Path | Purpose |
|------|---------|
| `.claude-plugin/plugin.json` | Plugin metadata (name, version, author) |
| `hooks/hooks.json` | SessionStart hook definition |
| `hooks/session-start.sh` | Session start script — announces available skills |
| `skills/pitch-deck-brief/SKILL.md` | Stage 1 — discovery: gather product, audience, ask, traction, comparables, constraints. Detects mode (VC / B2B / hybrid). Outputs `brief.json`. |
| `skills/pitch-deck-storyline/SKILL.md` | Stage 2 — narrative design: reads `brief.json`, designs hook + tension arc + payoff + ask + pattern-match + emotional core + 10-slide story spine. Outputs `storyline.md` + `storyline.json`. Human approval gate before stage 3. |
| `skills/pitch-deck-gen/SKILL.md` | Stage 3 — visual production: reads `storyline.json`, produces per-slide image prompts (GeminiGen.AI), Seedance 2.0 video prompts, optional Remotion configs, speaker notes. Outputs `deck.md` + asset prompt files. |
| `skills/pitch-deck-validate/SKILL.md` | Stage 4 — 100-point quality gate scoring 5 categories with hard-fail rules. |
| `agents/pitch-deck-designer-agent.md` | Self-contained subagent for batch deck production (master + variants). |
| `references/global-config.md` | Single source of truth — language, visual ratio thresholds, banned vocab, scoring weights. |
| `references/research/investor-pitch-deck-best-practices-2026.md` | Cached NotebookLM deep-research synthesis (refresh manually every 6-12 months). |
| `references/storyline-frameworks.md` | Narrative arc design — hook formulas, tension-build patterns, emotional core selection, pattern-match library, story spine templates. |
| `references/deck-frameworks.md` | 10-slide arc + alternative frameworks (Sequoia, YC, Kawasaki, Founder Institute) with dual-mode emphasis tables. |
| `references/investor-psychology.md` | First-90-second filters, 10 standard investor questions, pattern-matching biases, B2B vs VC psychology differences. |
| `references/visual-language.md` | Cognitive load research, text-to-visual ratio rules (with §2.5 structured-data exception for info-dense mode), typography for projection, color, charts, anti-AI-slop visual rules. |
| `references/image-prompt-templates.md` | GeminiGen.AI / Nano Banana Pro prompt formulas per slide type — density-mode-aware (Photo for minimalist / Infographic-flat for info-dense), brand-anchor cover (Slide 0), CTA composite (Slide N), composite reference patterns (face-as-badge vs face-on-body), Schema 2.0 with revision tracking |
| `references/safety-filter-playbook.md` | MINOR_UPLOAD + IDENTITY_PRESERVATION mitigation — synthetic-atmosphere pattern, age-locking phrases, per-error fallback ladders. REQUIRED for any slide with face/logo `files[]` |
| `references/seedance-prompt-templates.md` | Seedance 2.0 4-block prompt framework adapted for slide motion (demos, animated charts, transitions) |
| `references/remotion-config-templates.md` | Remotion JSON templates for programmatic motion (animated counters, live data, parallax scrolling) |
| `references/indonesian-context.md` | Bahasa pitch culture, IDR formatting, Indonesian VC landscape, compliance signals (BI, OJK, ISPO, ISO) |
| `references/b2b-channel-partner-playbook.md` | B2B-mode specifics: ROI calculator, risk reversal, case study format, revenue share models, dual-stakeholder framing patterns (§9.5) |
| `references/scoring-rubric.md` | 100-point validation gate — exact thresholds, traffic-light bands, hard-fail rules |
| `scripts/compile-references.sh` | Builds compiled reference bundles for split-pipeline injection (future) |
| `README.md` | Repo README |
| `LICENSE` | MIT license |

## The 10-slide narrative arc (dual-mode)

Adapted from Sequoia template + DocSend reading-time data. Audience mode is detected during discovery and changes the emphasis on each slide — never the structure itself, so the operator can swap audiences without rewriting the deck.

| # | Slide role | VC-mode emphasis | B2B-mode emphasis |
|---|-----------|------------------|-------------------|
| 1 | Title / Vision | Company + one-line "what" + ask amount | Product + venue logo lock-up + one-line ROI promise |
| 2 | Problem | Visceral market pain, sized | Operator's daily pain (queues, shrinkage, no insight) — visual not stat |
| 3 | Solution | Product demo screenshot + the "secret" | Before/after operator dashboard + on-the-ground photo |
| 4 | Market / Traction | TAM / SAM / SOM bottom-up + traction proof | Comparable venues already running + GMV uplift % |
| 5 | Product | One headline feature animated | Three pillars (POS + Wristband + Control Room) icon grid |
| 6 | Business Model / ROI | Unit economics, LTV/CAC | Operator P&L: cost vs uplift in IDR, payback months |
| 7 | Competition | Honest 2x2 with axes that flatter us truthfully | Yukk feature gap matrix — what they don't have |
| 8 | Team | Founder–market fit + key hires | Same + on-the-ground deployment team + support SLA |
| 9 | Roadmap / AI agents | What ships next 12 months | What value lands at venue this quarter (analytics + ads + social agent) |
| 10 | Ask / CTA | Round size, use of funds, milestones | Pilot terms, revenue share / fee, integration timeline |

## Hard rules (NON-NEGOTIABLE)

These rules apply to every deck generated. Violation requires immediate correction before output.

1. **Visual ratio ≥ 70% per slide.** Cognitive weight of visuals (image, chart, icon, video frame) must dominate text on every slide. Hard-fail under 60%.
2. **Headline ≤ 10 words.** No exceptions. If you can't say it in 10 words you don't know what you're saying.
3. **Sub-text ≤ 25 words per slide.** Numbers and proper nouns only — no adjectives, no marketing speak.
4. **No banned vocabulary.** Permanently banned: Unlock, Unleash, Empower, Supercharge, Maximize, Revolutionize, Transform, Disrupt, Synergize, Leverage (as verb), Cutting-edge, World-class, Best-in-class, Game-changing. Replace with concrete numbers or remove.
5. **No generic AI-slop visuals.** No purple-blue gradient backgrounds, no stock photo handshakes, no generic "person looking at chart on holographic screen", no light bulb = innovation, no gear = technology, no globe = international, no abstract neural network blobs. Specify SPECIFIC visual subjects.
6. **Every claim has a source or "internal estimate" tag.** Hallucinated traction is automatic reject. Fabricated TAM is automatic reject. If you don't know, say "internal estimate" or "founder hypothesis".
7. **Ask is specific.** VC mode: dollar/IDR amount + use of funds breakdown + 18-month milestones. B2B mode: pilot scope + commercial terms + integration timeline + decision deadline.
8. **The 10 standard investor questions are pre-empted by slide 8.** Per `investor-psychology.md`, every standard question maps to a specific slide. If a question isn't pre-empted, that slide failed its job.
9. **Story spine intact.** Hook by slide 2, tension peak around slide 6, payoff by slide 8, ask by slide 10. No deck ships without a working narrative arc.
10. **Pattern match to one known winner.** Every deck must explicitly state "we are [known successful company] for [our market]" within the first 3 slides. Without pattern match, investor's brain has no shelf to file the company on.
11. **Indonesian context honored.** When deck is for Indonesian audience: IDR currency primary (USD parenthetical OK), Bahasa headline + English subtitle if bilingual, named Indonesian companies as comparables, BI/OJK/ISPO compliance signals where relevant.
12. **Speaker notes 30–45 seconds per slide.** Stage time matters: 80–150 words per slide of speaker notes. Total deck = 5–7 minute talk track. Anything longer means the slides are doing the speaker's job.

## 4-stage pipeline (each stage = its own skill)

```
STAGE 1 — pitch-deck-brief (DISCOVERY)
  Inputs: one-paragraph brief, target audience description, ask amount, target language
  Asks: clarifying Qs to fill traction, comparables, constraints, timeline
  Detects: mode = VC | B2B | hybrid
  Outputs: brief.json (saved to working dir or /tmp/)

STAGE 2 — pitch-deck-storyline (NARRATIVE DESIGN) — HUMAN APPROVAL GATE
  Reads: brief.json
  Designs: hook (one of 6 hook formulas) → tension build (problem → urgency → cost of inaction) → payoff (solution + proof) → ask (specific, dated)
  Selects: emotional core (Fear/Loss vs Greed/Gain vs Identity vs Curiosity vs Tribe)
  Selects: pattern match ("we are [known winner] for [our niche]") — picks from `references/investor-psychology.md` library
  Maps: 10-slide story spine with audience-mode emphasis (per `references/deck-frameworks.md`)
  Outputs: storyline.md (human-readable) + storyline.json (machine-readable)
  PAUSE: operator reviews storyline, approves or refines. No tokens spent on visuals until approval.

STAGE 3 — pitch-deck-gen (VISUAL PRODUCTION)
  Reads: storyline.json (and brief.json for context)
  Per slide:
    1. Visual concept (one-sentence what-it-shows)
    2. On-slide text (≤10 word headline + ≤25 word sub-text)
    3. Image prompt — full GeminiGen.AI nano-banana-pro format (40-100 words)
    4. Optional video prompt — Seedance 2.0 4-block when motion adds clarity
    5. Optional Remotion JSON config when programmatic motion needed
    6. Speaker note (80-150 words in storyline.json's chosen language)
    7. Investor pre-empt (which of 10 standard investor questions this slide answers)
  Outputs: deck.md + image-prompts.json + video-prompts.json + remotion.config.json (optional) + speaker-notes.md

STAGE 4 — pitch-deck-validate (QUALITY GATE)
  Reads: deck.md (and storyline.json for narrative-arc check)
  Scores: 5 categories totaling 100 points
    - Visual Ratio (25): each slide ≥70%, hard-fail any < 60%
    - Narrative Arc (20): hook in 1-2, payoff by 8, ask in 10
    - Ask Clarity (15): specific number, use of funds, milestone
    - Investor Psychology (20): first-90-sec filter, 10-Q pre-empts, pattern-match
    - Anti-AI-Slop (20): no banned vocab, no AI-cliché visuals, no hallucinated traction
  Output: validation-report.json (passed/failed per category, fixes per failure)
  Combined ≥70 = publish. Hard-fail = back to relevant upstream skill.
```

## Reference files cheat sheet (per stage)

| Stage | Skill | Read first |
|-------|-------|-----------|
| 1 | `/pitch-deck-brief` | `global-config.md` (always) + `b2b-channel-partner-playbook.md` (if B2B detected) + `indonesian-context.md` (if Indonesian) |
| 2 | `/pitch-deck-storyline` | `global-config.md` + `storyline-frameworks.md` + `investor-psychology.md` + `research/investor-pitch-deck-best-practices-2026.md` + `deck-frameworks.md` |
| 3 | `/pitch-deck-gen` | `global-config.md` + `visual-language.md` + `image-prompt-templates.md` + `safety-filter-playbook.md` (REQUIRED for any slide with face/logo `files[]`) + `b2b-channel-partner-playbook.md` (if B2B / partnership) + `seedance-prompt-templates.md` (if motion=true) + `remotion-config-templates.md` (if programmatic_motion=true) |
| 4 | `/pitch-deck-validate` | `global-config.md` + `scoring-rubric.md` + `visual-language.md` (anti-slop) + `investor-psychology.md` (pre-empt check) |

Each row adds (+) to base. Multiple tasks in one step = read all listed files.

## Common failure modes (RED phase findings)

These are the failures observed when a generic LLM is asked to "make a pitch deck" without this skill. Each is countered by a hard rule above.

| Failure mode | Counter rule |
|--------------|--------------|
| Wall of bullet text per slide | Rule 1, 2, 3 (visual ratio + word limits) |
| Generic AI-slop visuals (purple gradients, stock handshakes) | Rule 5 (specific subjects mandated) |
| Hallucinated traction numbers | Rule 6 (source-or-hypothesis tagging) |
| Vague ask ("we want to grow") | Rule 7 (specificity mandated) |
| Speaker notes that just restate the slide | Speaker notes section in `visual-language.md` |
| English-defaulted deck for Indonesian audience | Rule 11 + `indonesian-context.md` |
| Sequoia template applied verbatim to B2B sale | Mode detection in Stage 1 (`pitch-deck-brief`) + dual-mode emphasis tables in `deck-frameworks.md` |
| 30-slide deck because every idea got its own slide | 10-slide hard cap (extend only via appendix) |
| Forgot the ask slide entirely | Rule 7 + slide 10 mandate |
| Closing on "Thank You" | Final-frame rule in `visual-language.md` (last frame = the ask, not a thank-you) |
| **Cover slide rendered as generic stock-photo** (most common B2B partnership failure) | **Density-mode-aware Slide 0 brand-anchor template** in `image-prompt-templates.md` §3 |
| **Info-dense partnership deck rejected as "too text-heavy"** | **§2.5 structured-data visual exception** in `visual-language.md` |
| **Founder face composite triggers MINOR_UPLOAD safety filter** | **Synthetic-atmosphere pattern + age-locking** in `safety-filter-playbook.md` |
| **Brand colors drift between slides** | **`brand_palette` REQUIRED + verbatim hex injection** in `global-config.md` §3.6 |
| **Bad style-anchor poisons all subsequent slides via `ref_history`** | **Step 4.5 quality gate** in `pitch-deck-gen` SKILL.md |
| **Partnership deck shows only one stakeholder** | **Dual-stakeholder framing patterns §9.5** in `b2b-channel-partner-playbook.md` |

## Key Pipeline Behaviors

- **Interactive mode** (default): hard pause point at the end of Stage 2 (`pitch-deck-storyline`) — operator reviews `storyline.md` + audience-mode detection + framework choice + pattern-match selection before any image/video prompts are spent in Stage 3.
- **Batch / variant mode** (via `agents/pitch-deck-designer-agent.md`): one master deck + N audience-specific variants run in a single Task invocation. Storyline approval is consolidated across all variants.
- **Pipeline mode** (CLI flags `--brief-file --output-dir --storyline-pre-approved` etc.): fully automated, zero pauses, writes structured JSON to output directory. Validation failures hard-stop and exit non-zero.
- **Validate-only mode** (`/pitch-deck-validate`): scores an existing deck.md against the 100-point gate without regenerating.
- **Refresh research mode** (`--refresh-research`): re-runs nlm-skill, overwrites `references/research/investor-pitch-deck-best-practices-2026.md`.

## Integration with other plugins in the suite

| Sibling plugin | How pitch-deck-designer relates |
|----------------|-------------------------------|
| `ai-image-carousel-prompt-gen` | Image prompt format and `references/global-config.md` philosophy mirrored. A deck slide with image prompt can be sent to carousel-gen for batch render. |
| `ai-video-promo-engine` | Video prompts use the same Seedance 2.0 / VEO 3.1 grammar. A deck demo loop can be promoted into a full video via video-gen. |
| `article-content-writer` | When a deck needs a long-form companion (one-pager, FAQ, deep-dive memo), hand off to article-gen with the deck's narrative arc as input. |
| `linkedin-post-writer` | Title slide image + speaker note for slide 10 can become a LinkedIn announcement post via linkedin-gen. |

## Refresh / maintenance

- `references/research/investor-pitch-deck-best-practices-2026.md` is cached NotebookLM output. Refresh annually or when deck win rate drops noticeably.
- `references/indonesian-context.md` (VC landscape, compliance) — refresh quarterly; Indonesian PG/SaaS rules shift fast.
- Banned vocabulary list (`global-config.md` §4) — append when new AI-slop terms emerge.
- Scoring rubric thresholds (`scoring-rubric.md`) — adjust only when validation results consistently misalign with operator outcomes.
