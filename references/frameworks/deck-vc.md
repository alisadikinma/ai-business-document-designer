---
slug: deck-vc
output_type: deck-vc
aspect_ratio: 16:9
default_page_count: 10
target_audience: Equity venture capital partners and seed/Series A/B investors evaluating fundability in the 2026 climate
mandatory_pages:
  - Title / Vision
  - Problem
  - Solution
  - Why Now
  - Market
  - Traction
  - Business Model
  - Moat
  - Competition
  - Team
  - Ask
optional_pages:
  - Detailed financials
  - Cohort retention
  - Use of funds breakdown
  - Cap table summary
  - Tech architecture appendix
  - Compliance signals
  - Customer testimonials with verbatim attribution
---

# Deck VC — Investor Pitch Framework (AI-Era 11 + Traction-First 13)

## Purpose & When To Use This Framework

Use this framework when the operator is raising equity capital from venture investors — pre-seed, seed, Series A, or Series B — in the 2026 climate where moat and "why now" carry disproportionate underwriting weight after the 2025 foundation-model commoditization shift. The deck must pass the DocSend first-90-second filter: an investor reads the title, problem, and solution slide in under 90 seconds before deciding whether to keep reading. Every slide must do exactly one cognitive job.

Two sub-sequences are supported:

- **AI-Era 11 (default 2026):** 11 core slides + ≤5 appendix. Adds Why Now (slide 4) and Moat (slide 8) versus the pre-2025 Sequoia 10. Use for any AI-adjacent product, Series A in 2026, or pre-revenue equity raise.
- **Traction-First 13:** 13 core slides. Used when ARR > USD 1M. Per DocSend 2024–25 data, problem-first decks are deprecated at this stage — lead with traction (slide 2) so the rest of the deck earns reading time.

The brief skill picks between the two by checking `arr_usd` and `ai_adjacent` flags; the storyline skill confirms with the operator before locking it in.

## Narrative Arc / Page Sequence

AI-Era 11 (default), in order:

1. **Title / Vision.** Place us on the right shelf in 4 seconds. One declarative sentence, no buzzwords. `[Company] — [one-line of what + for whom]`. No tagline poetry.
2. **Problem.** Make the audience feel the pain. One specific user scenario with a sized cost. If pre-revenue: visceral pain. If ARR > 1M: traction headline goes here instead and problem moves down.
3. **Solution.** Show, do not tell. Demo screenshot or a 4-second loop. The reader must understand the secret in 8 seconds.
4. **Why Now.** Erase the "why hasn't this been done before" objection. Specific technical / regulatory / behavioral shift in the last 12–18 months. No macro cliché ("AI is big").
5. **Market.** Bottom-up TAM = Customers × Price × Realistic share. No top-down "1% of a trillion." Show the math.
6. **Traction.** Growth rate, NRR, logos. Pre-revenue: pilot data, LOIs, waitlist with conversion intent. No vanity metrics.
7. **Business Model.** CAC · LTV · Gross margin · Payback. One slide. If you cannot fit on one slide, the model is not clear yet.
8. **Moat.** Defense thesis. Pre-empts "what happens when GPT-5 ships?" Carries 30–40% of underwriting weight in 2026 per the research backbone. Network effects, proprietary data, switching cost, regulatory wedge, distribution lock.
9. **Competition.** 2x2 with axes that flatter truthfully. Position in an open quadrant. Name real competitors, including incumbents.
10. **Team.** Shipping credentials per founder, not just FAANG titles. Founder–market fit in one line per founder.
11. **Ask.** Round size · use of funds · 18-month milestones · decision deadline. Specific numbers, specific dates.

Traction-First 13 reorders to: Title → Traction → Problem → Solution → Why Now → Market → Customer cohorts → Business model → Moat → Competition → Team → Roadmap → Ask. Lead with proof when ARR earns the right.

Appendix (≤5 slides, only if data exists — no fabrication): detailed financials, cohort retention, use of funds breakdown, cap table, tech architecture diagram, compliance signals (BI license, OJK, ISO 27001), customer testimonials with verbatim attribution. Hard cap 5. More appendix = signal of weak main story.

## 7-Step Content Checklist

1. **Pre-empt the 10-Q filter.** Before drafting, list the 10 questions a partner will ask in DD. Each main slide must pre-empt one. If a slide pre-empts zero, drop it.
2. **First-90-second readability.** Title + Problem + Solution must communicate the company in under 90 seconds with autoplay disabled. Test by handing the first 3 slides to someone outside the company for 90 seconds.
3. **Bottom-up market math, never top-down.** Customers × Price × Share, with each input cited (industry report, internal survey, pilot conversion). No "1% of $100B."
4. **Moat slide is non-negotiable in 2026.** Per the research backbone, moat carries 30–40% of underwriting weight after the 2025 foundation-model shift. Defense thesis must answer: "What happens when GPT-5 / Sora / [next foundation model] ships?"
5. **Traction quality over quantity.** Growth rate + NRR + named logos beats "100K users." If pre-revenue, show pilot conversion data or LOIs with sized contract value.
6. **Team credentials are shipping credentials.** "Ex-FAANG" alone is dead. Show what each founder has shipped, sold, or scaled. One concrete win per founder.
7. **Ask slide closes specifically.** Round size (Rp / USD), use of funds (% buckets), 18-month milestones (3 named), decision deadline. No "we are raising a strategic round."

## Do-NOT Patterns (3+)

1. **"Thank You" slide.** Squanders 30+ seconds of Q&A staring time. Replace with the Ask slide re-stated.
2. **"Vision 2030" without traction.** Daydream slide. If you have traction, lead with it; if not, the vision slide is a placebo for missing proof.
3. **"Our Values" / "Why we'll succeed."** Investor does not care about your values until after Series B, and "why we'll succeed" reads as whining for permission. Cut both.
4. **Architecture diagram with 20 boxes.** Investor does not read it. Replace with one demo screenshot or a 4-second loop.
5. **"Use cases" with 12 examples.** Signals "we do not know who our customer is." Pick one persona, go deep, name them.
6. **Top-down market sizing.** "1% of a $100B market is $1B" is a 2018 deck pattern. Use bottom-up math with sourced inputs.

## Real-World Example Reference

- **Sequoia Capital pitch deck template** — original 10-slide skeleton, still the canonical Western VC reference. URL: https://www.sequoiacap.com/article/writing-a-business-plan/
- **DocSend 2024–25 reading-time research** — empirical data on investor scan time per slide; basis for the first-90-second filter and the deprecation of problem-first decks above USD 1M ARR. Source: DocSend Startup Index reports.
- **Airbnb seed deck (2008)** — public reference of the Problem → Solution → Traction → Market structure that became the Sequoia template foundation. Widely re-shared on SlideShare and pitch-deck galleries.
- **Stripe Series A narrative** — example of the "Why Now" slide done right (developer API monetization shift); referenced in Patrick Collison interviews and YC retrospectives.
- Cross-reference: `references/research/investor-pitch-deck-best-practices-2026.md` (NotebookLM cache, 2026 moat-weight shift).

## Anti-Slop Hard Rules

1. **Title slide must read in 4 seconds.** Hand the slide to a stranger for 4 seconds. If they cannot say what the company does, rewrite. No buzzword stacking ("AI-first SaaS platform leveraging blockchain").
2. **One cognitive job per slide.** If a slide does two jobs, split. If it does zero, drop. Validation checks this explicitly per the slide-by-slide cognitive job table defined in the `## Narrative Arc / Page Sequence` section above.
3. **No fabricated data anywhere.** Every claim is sourced or tagged "internal estimate." Made-up TAM, made-up traction, or "industry standard" without citation is an instant validate-fail.
4. **Moat slide names the foundation-model threat by name.** "Defensibility through proprietary workflow" is a 2023 phrase. 2026 moat slide says: "When [specific model / specific player] ships [specific capability] in Q-N, we still win because [specific lock]."
5. **No banned vocabulary.** "Unlock", "Unleash", "Empower", "Supercharge", "Revolutionize", "Transform", "Game-changing", "Next-gen", "Cutting-edge", "State-of-the-art", "Paradigm-shift", "Disrupt", "Synergize", "Leverage" (as verb), "Best-in-class", "World-class" — banned everywhere, including the title slide.

## Reference Loading

This framework is loaded by the narrative and validate skills when `output_type = deck-vc`. Required reference reads, in order:

1. `references/global-config.md` — banned vocab, output_type enum, scoring weights, hard rules.
2. `references/research/framework-structures-2026.md` — narrative scaffolding patterns (used for cross-format validation of one-job-per-slide rule).
3. `references/research/investor-pitch-deck-best-practices-2026.md` — primary backbone for slide sequence, moat weight, DocSend reading-time data, AI-era 11 derivation.
4. `references/investor-psychology.md` — pattern-match heuristics, 10-Q pre-empt, first-90-second filter, fundability signals.
5. `references/storyline-frameworks.md` — story-spine beats (Setup → Catalyst → Escalation → Resolution) mapped per slide.
6. `references/scoring-rubric.md` — deck-mode rubric (story logic, headline discipline, claim sourcing, anti-slop).

Optional, load on signal:

- `references/indonesian-context.md` — when audience signals Indonesian VC (East Ventures, AC Ventures, Alpha JWC, Intudo) or regulatory disclaimers needed (BI, OJK).
- `references/b2b-channel-partner-playbook.md` — only when hybrid mode flagged (rare for pure deck-vc).
