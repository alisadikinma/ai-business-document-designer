# Pitch Deck Designer — Claude Code Plugin

Visual-first investor pitch deck designer that turns a one-paragraph product brief into a presentation-ready deck spec — 10 slides, ≥70% visual / ≤30% text per slide, with image prompts (Nano Banana / GeminiGen.AI), Seedance 2.0 video animation prompts, optional Remotion motion configs, and persuasive Indonesian/English speaker notes. Dual-mode adaptive: detects whether the audience is a **B2B channel partner** (mall operator, EO, food court — adopt our SaaS) or an **equity VC** (Series A/B fundraise) and reshapes the narrative arc accordingly. Validation gate enforces the 100-point Pitch Deck Quality Score before output.

## Why this plugin exists

The default behavior of LLMs when asked for a "pitch deck" is to dump 10 paragraphs of bullet text into 10 slides — the exact failure mode that DocSend research identified as why investors disengage in the first 90 seconds. This plugin enforces the opposite: a deck where **the visuals carry the story** and the speaker fills in the words. Each slide is shipped as a structured spec (visual concept + on-slide text ≤30% of cognitive weight + image prompt + speaker notes + design specs) so the operator can render in Canva / Figma / Pitch.com / Gamma without re-inventing the visual language per slide.

## Install

```bash
# Via ai-content-suite marketplace (after pitch-deck-designer is published)
claude plugins marketplace add alisadikinma/ai-content-suite
claude plugins install pitch-deck-designer

# Or direct
claude plugins install alisadikinma/pitch-deck-designer
```

## Skills (4-stage pipeline)

| # | Skill | Trigger | Stage | Description |
|---|-------|---------|-------|-------------|
| 1 | `pitch-deck-brief` | `/pitch-deck-brief` | Discovery | Gather raw info: product, audience, ask, traction, comparables, constraints. Detects mode (VC / B2B / hybrid). Outputs `brief.json`. |
| 2 | `pitch-deck-storyline` | `/pitch-deck-storyline` | Narrative design | Reads `brief.json`. Designs the narrative arc — hook, tension build, payoff, ask, pattern-match, emotional core, 10-slide story spine with audience-mode emphasis. Outputs `storyline.md` + `storyline.json` (ready for `/pitch-deck-gen` to consume). HUMAN APPROVAL GATE before stage 3. |
| 3 | `pitch-deck-gen` | `/pitch-deck-gen` | Visual production | Reads `storyline.json`. Produces per-slide visual spec — image prompts (GeminiGen.AI / Nano Banana Pro), Seedance 2.0 video prompts (where motion adds value), optional Remotion configs, speaker notes. Outputs `deck.md` + asset prompt files. |
| 4 | `pitch-deck-validate` | `/pitch-deck-validate` | Quality gate | 100-point scoring across 5 categories: Visual Ratio (25), Narrative Arc (20), Ask Clarity (15), Investor Psychology (20), Anti-AI-Slop (20). Hard-fail under 70/100 or any slide visual ratio under 60%. |

**Why 4 stages, not 1:** the storyline is the soul of the deck. Folding it into visual generation (the way most AI tools do) produces decks that look polished but say nothing. Separating storyline as its own gated stage forces the operator to nail the narrative BEFORE spending tokens on image prompts. It also means the storyline can be refined / re-approved without regenerating the visuals, and vice-versa.

**Run sequentially:**
```bash
/pitch-deck-brief        # → brief.json
/pitch-deck-storyline    # → storyline.md + storyline.json (HUMAN APPROVAL)
/pitch-deck-gen          # → deck.md + image-prompts.json + video-prompts.json + speaker-notes.md
/pitch-deck-validate     # → validation-report.json (gates publication)
```

Or invoke any single stage atomically if upstream artifacts already exist (e.g. refine the storyline only, then re-run `/pitch-deck-gen`).

## Agent

| Agent | Description |
|-------|-------------|
| `pitch-deck-designer-agent` | Self-contained subagent for batch deck production (e.g. one master deck + 3 audience variants) |

## What gets generated per slide

Every slide ships as a markdown record with eight components:

1. **Slide number + role** (Title / Hook / Problem / Solution / etc. — one of the 10-slide narrative beats)
2. **Visual concept** — one-sentence brief of what the slide LOOKS like (this is what investors read in 3 seconds)
3. **On-slide text** — at most 6–10 words for headline, ≤25 words for any sub-text. Numbers + nouns only, no adjectives, no marketing speak
4. **Image prompt** — full GeminiGen.AI prompt (40-100 words) tuned to nano-banana-pro with aspect_ratio + style + reference images noted
5. **Optional video prompt** — Seedance 2.0 4-block prompt when motion adds clarity (e.g. demo, animated chart, transition)
6. **Optional Remotion JSON** — when programmatic motion is needed (live data, animated counter, parallax)
7. **Speaker notes** — 80–150 words in user's selected language (default: Bahasa Indonesia), persuasive, conversational, mapped to 30–45 seconds of stage time
8. **Investor pre-empt** — which of the 10 standard investor questions this slide pre-empts ("how do you make money?" → business model slide)

## The 10-slide narrative arc

Adapted from Sequoia + DocSend reading-time data, dual-mode aware:

| # | Slide | VC Mode emphasis | B2B Mode emphasis |
|---|-------|------------------|-------------------|
| 1 | Title / Vision | Company name + one-line "what" + ask amount | Product name + venue logo lock-up + one-line ROI promise |
| 2 | Problem | Visceral pain in market, sized | Operator's daily pain (queues, shrinkage, no insight) — visual not stat |
| 3 | Solution | Product demo screenshot + the "secret" | Before/after operator dashboard, on-the-ground photo |
| 4 | Market / Traction | TAM / SAM / SOM bottom-up + traction | Comparable venues already running, GMV uplift % |
| 5 | Product | One headline feature, animated | Three pillars (POS + Wristband + Control Room) icon grid |
| 6 | Business Model / ROI | Unit economics, LTV/CAC | Operator P&L: cost vs uplift in IDR with payback months |
| 7 | Competition | Honest 2x2 with axes that flatter us truthfully | Yukk feature gap matrix — what they don't have |
| 8 | Team | Founder–market fit + key hires | Same + on-the-ground deployment team + support SLA |
| 9 | Roadmap / AI | What we'll ship next 12 months | What value lands at venue this quarter (analytics agent, ads agent, social agent) |
| 10 | Ask / CTA | Round size, use of funds, milestones | Pilot terms, revenue share / fee, integration timeline |

`pitch-deck-gen` auto-selects the right emphasis after detecting audience type.

## Validation gate (100-point Pitch Deck Quality Score)

A deck cannot ship until it passes `/pitch-deck-validate`. Five categories, all mandatory:

| Category | Weight | What it checks |
|----------|--------|----------------|
| Visual Ratio | 25 | Each slide ≥70% visual / ≤30% text. Hard-fail any slide under 60% |
| Narrative Arc | 20 | Hook in slide 1–2, tension built across 3–6, payoff at 7–8, ask at 10. Story spine intact. |
| Ask Clarity | 15 | Specific number, specific use of funds (or specific pilot terms for B2B), milestone attached |
| Investor Psychology | 20 | First-90-second filter passed, all 10 standard investor questions pre-empted, pattern matched to known winner |
| Anti-AI-Slop | 20 | No banned vocab (Unlock, Unleash, Empower, Supercharge, Maximize), no generic gradient backgrounds, no stock-photo handshakes, no clichéd icons (light bulb = innovation, gear = tech) |

Combined ≥70 to publish. Visual Ratio is a hard gate — under 60% = automatic reject regardless of other scores.

## Pipeline

```
[STAGE 1 — pitch-deck-brief]
brief input (one paragraph + Q&A)
   → product, audience, ask, traction, comparables, constraints
       → mode detection (VC | B2B | hybrid)
           → output: brief.json

[STAGE 2 — pitch-deck-storyline]
read brief.json
   → narrative arc design (hook + tension + payoff + ask)
       → emotional core selection (Fear/Loss vs Greed/Gain vs Identity vs Curiosity)
           → pattern-match selection ("we're [winner] for [our niche]")
               → 10-slide story spine with audience-mode emphasis
                   → output: storyline.md + storyline.json
                       → HUMAN APPROVAL GATE

[STAGE 3 — pitch-deck-gen]
read storyline.json
   → per-slide visual concept
       → image prompt (GeminiGen.AI nano-banana-pro)
           → video prompt (Seedance 2.0 4-block) where motion adds value
               → optional Remotion config (programmatic motion)
                   → speaker notes (80-150 words per slide)
                       → output: deck.md + image-prompts.json + video-prompts.json + remotion.config.json + speaker-notes.md

[STAGE 4 — pitch-deck-validate]
read deck.md
   → 100-point scoring gate
       → output: validation-report.json
           → publish (if pass) or send back to relevant upstream stage (if fail)
```

Operator's downstream workflow: feed image prompts to GeminiGen.AI, render in Canva or Pitch.com, paste speaker notes underneath each slide, present.

## Reference architecture

11 reference files as RAG knowledge base — see [CLAUDE.md](CLAUDE.md) for the full map.

| File | Used for |
|------|---------|
| `references/global-config.md` | ALWAYS read first — language, visual ratios, banned vocab, scoring thresholds |
| `references/research/investor-pitch-deck-best-practices-2026.md` | Cached NotebookLM deep-research synthesis (Sequoia, YC, Kawasaki, DocSend, Indonesian VC landscape) |
| `references/deck-frameworks.md` | The 10-slide arc, dual-mode emphasis tables, alternative frameworks |
| `references/investor-psychology.md` | First-90-second filters, the 10 standard investor questions, pattern-matching biases |
| `references/storyline-frameworks.md` | Narrative arc design — hook formulas, tension-build patterns, emotional core selection (Fear/Greed/Identity/Curiosity), pattern-match library, story spine templates |
| `references/visual-language.md` | Cognitive load research, text-to-visual ratio rules, typography for projection, anti-AI-slop visual rules |
| `references/image-prompt-templates.md` | GeminiGen.AI / Nano Banana Pro prompt formulas per slide type, with worked examples |
| `references/seedance-prompt-templates.md` | Seedance 2.0 4-block prompts adapted for slide motion (demo loops, animated charts, transitions) |
| `references/remotion-config-templates.md` | Remotion JSON templates for programmatic motion (animated counters, live data, parallax) |
| `references/indonesian-context.md` | Bahasa pitch culture, IDR formatting, Indonesian VC landscape, compliance signals (BI, OJK, ISO) |
| `references/b2b-channel-partner-playbook.md` | B2B-mode specifics: ROI calculator structure, risk-reversal, integration cost, case study format |
| `references/scoring-rubric.md` | The 100-point validation gate — exact thresholds, traffic-light bands |

## License

MIT
