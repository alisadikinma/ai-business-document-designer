# Deck Frameworks — Slide Sequences by Mode and Stage

> Read this AFTER reading `storyline-frameworks.md` and `investor-psychology.md`. This file maps the agreed storyline onto a concrete slide sequence.
>
> **Source backbone:** `references/research/investor-pitch-deck-best-practices-2026.md` — DocSend 2024–25 reading-time data + 2026 moat-weight shift.

---

## 1. Three frameworks, one storyline

We support three slide sequences. The storyline determines which one to use:

| Framework | Slide count | Best for | Source |
|-----------|------------|----------|--------|
| **Classic-10 (B2B mode default)** | 10 core + ≤5 appendix | B2B channel-partner / operator pitches; pre-revenue VC | Adapted Sequoia 10-slide |
| **AI-era 11 (VC mode default for 2026)** | 11 core + ≤5 appendix | Equity VC / Series A in 2026, AI-adjacent products | DocSend 2024–25, post-2025 moat-weight shift |
| **Traction-first 13 (high-revenue VC)** | 13 core + ≤5 appendix | Companies with ARR > $1M raising Series A / B | DocSend "lead with traction" rule |

The brief skill detects which to use; the storyline skill confirms with the operator before locking it in.

---

## 2. Classic-10 (B2B mode default)

| # | Slide | Story-spine beat | Headline pattern | Cognitive job |
|---|-------|------------------|------------------|--------------|
| 1 | Title / Vision | Setup | `[Product] — [one-line ROI promise]` | Place us on the right shelf |
| 2 | Problem | Catalyst | `[Operator] loses Rp X / month to [specific cause]` | Make the pain visceral |
| 3 | Solution | Catalyst → Escalation | `Before / After [the one image]` | Show the transformation |
| 4 | Market / Traction | Escalation | `[N venues] live · Rp X GMV/month · [logos]` | Prove demand |
| 5 | Product | Escalation | `Three pillars: [POS][Wristband][Control Room]` | Show how it works |
| 6 | Business model / ROI | Escalation peak | `Operator P&L: -Rp X cost · +Rp Y uplift · [N] month payback` | Show the money math |
| 7 | Competition | Escalation peak | `[Yukk feature gap matrix or 2x2]` | Position truthfully |
| 8 | Team | Resolution | `Founders + on-the-ground deployment + 24/7 support` | Earn trust |
| 9 | Roadmap / AI agents | Resolution | `Q1: analytics agent · Q2: ads agent · Q3: social agent` | Show what compounds |
| 10 | Ask | Resolution | `Pilot scope · Commercial terms · Integration timeline · Decision deadline` | Close |

**Use when:** B2B mode confirmed by brief; product is operational tool for adopter; ARR is irrelevant to the pitch (we're selling a deployment, not a stake).

---

## 3. AI-era 11 (VC mode default for 2026)

Adapted from the research's 11-slide skeleton (DocSend / 2026 underwriting). Key changes vs Classic-10:
- Adds **slide 4: Why Now** (specific shift, not macro cliché)
- Adds **slide 8: Moat** (carries 30–40% of underwriting weight in 2026)
- Splits **competition** into its own slide (slide 9)

| # | Slide | Story-spine beat | Headline pattern | What it must answer |
|---|-------|------------------|------------------|---------------------|
| 1 | Title | Setup | `[Company] — [one declarative sentence, no buzzwords]` | "What do you do?" — readable in 4 seconds |
| 2 | Problem / Traction | Catalyst | If pre-revenue: `[Specific user pain in one scenario]`<br>If ARR>$1M: `[Traction headline]` | "Why does it matter?" / lead with proof |
| 3 | Solution | Catalyst → Escalation | `[Demo screenshot or 4-second loop]` | "What's the secret?" |
| 4 | Why Now | Escalation | `[Specific technical / regulatory / behavioral shift]` | "Why couldn't this work 12 months ago?" |
| 5 | Market | Escalation | `Bottom-up TAM: Customers × Price × Realistic share` | "How big is the market?" |
| 6 | Traction | Escalation | `Growth rate · NRR · Logos` | "Is anyone using it?" |
| 7 | Business model | Escalation peak | `CAC · LTV · Gross margin · Payback` (single slide) | "How do you make money?" |
| 8 | Moat | Escalation peak | `[Specific defense thesis vs foundation models / commoditization]` | "What happens when GPT-5 / Sora / [foundation model] ships?" |
| 9 | Competition | Resolution | `[2x2 with axes that flatter us truthfully]` | "Who else is competing?" |
| 10 | Team | Resolution | `[Shipping credentials per founder, not just FAANG titles]` | "Why you specifically?" |
| 11 | Ask | Resolution | `[Round size · use of funds · 18-month milestones]` | "What do you want from me?" |

**Use when:** VC mode + AI-adjacent product OR raising in 2026 climate (which is now). The moat slide is non-negotiable.

---

## 4. Traction-first 13 (high-revenue VC, ARR > $1M)

For Series A / B raises with substantial revenue. Per DocSend 2024–25, problem-first decks are deprecated when ARR > $1M; lead with traction.

| # | Slide | Function |
|---|-------|----------|
| 1 | Title | One declarative sentence + ARR / growth rate on slide |
| 2 | Traction | Top-line: ARR, growth rate, NRR, logo lockup |
| 3 | Problem | Sized + visceral (now that interest is earned) |
| 4 | Solution | Demo screenshot / loop |
| 5 | Why Now | Specific shift |
| 6 | Market | Bottom-up math |
| 7 | Customer cohorts | Retention curves, expansion revenue, top-10 logos detail |
| 8 | Business model | Unit economics deep-dive |
| 9 | Moat | Defense thesis |
| 10 | Competition | 2x2 + win/loss data if available |
| 11 | Team | Shipping credentials + key hires roadmap |
| 12 | Roadmap | 12-month + 24-month milestones |
| 13 | Ask | Round size + use + milestones |

**Use when:** ARR > $1M (USD) AND raising Series A or later. Below that threshold, AI-era 11 serves.

---

## 5. Mode detection rules (used by `pitch-deck-brief`)

The brief skill applies these rules to pick the framework:

```
IF audience has explicit equity / fundraise / valuation language:
    mode = vc
    IF arr_usd > 1_000_000:
        framework = traction_first_13
    ELIF product_is_ai_adjacent OR pitch_year >= 2026:
        framework = ai_era_11
    ELSE:
        framework = classic_10

ELIF audience has adopt / deploy / pilot / mall / EO / operator language:
    mode = b2b
    framework = classic_10  # B2B always uses Classic-10 baseline

ELIF both signals present:
    mode = hybrid
    framework = classic_10 + 3 vc-appendix slides (financials, use of funds, cap table)

DEFAULT (ambiguous):
    mode = b2b
    framework = classic_10
```

Operator can override mode + framework choice during storyline approval.

---

## 6. Appendix slides (when to add)

Appendix is for "convince me later" detail — never the main story. Add only if data exists; no fabrication.

| Appendix slide | Add when |
|----------------|----------|
| A1 — Detailed financials | VC mode + 3+ years of data |
| A2 — Cohort retention | VC mode + ≥6 months of cohorts |
| A3 — Use of funds breakdown | VC mode + raising > Rp 30 B |
| A4 — Cap table summary | VC mode + Series B+ |
| A5 — Tech architecture | Asked in DD — pre-empt with appendix slide |
| A6 — Compliance signals | Indonesian-mode (BI license, OJK, ISO 27001) |
| A7 — Press / awards | Only when there are ≥3 named pieces |
| A8 — Customer testimonials | Only when verbatim with attribution |
| A9 — Pilot results data | B2B mode, when ≥2 pilots completed |
| A10 — Sensitivity analysis | B2B mode, when ROI claim is in slide 6 |

Hard cap: 5 appendix slides. More = signal of weak storyline.

---

## 7. Slides explicitly forbidden

These slides appear in 80% of bad decks. None of them survive validation.

| Forbidden slide | Why | What to do instead |
|-----------------|-----|-------------------|
| "Thank You" | Squanders 30+ seconds of Q&A staring time | Re-state the ask with specific numbers |
| "Vision 2030" without traction | Daydream slide | If you have traction, lead with it; if not, drop the vision slide |
| "Our values" | Investor doesn't care about your values until after Series B | Cut |
| "Why we'll succeed" | Whining for permission | Show the data; let them conclude |
| "The Founder's journey" | Memoir, not pitch | One line of founder–market fit on team slide |
| Org chart | Suggests hierarchy matters when it doesn't | Cut |
| Architecture diagram with 20 boxes | Investor doesn't read it | One demo screenshot or 4-sec loop |
| "Use cases" with 12 examples | Says "we don't know who our customer is" | Pick one persona, go deep |
| "Press logos" with no story | Looks insecure | Cut unless there's a recent named win |

---

## 8. Slide-by-slide cognitive job summary (for storyline-stage validation)

Each slide must do exactly ONE job. If a slide tries to do two, split or drop one.

| Slide | The ONE job |
|-------|------------|
| Title | Place us on a known shelf in 4 seconds |
| Problem | Make the audience feel the pain |
| Solution | Show (not tell) the transformation |
| Why Now | Erase "why hasn't this been done before" |
| Market | Prove the prize is large via bottom-up math |
| Traction | Prove demand is real and accelerating |
| Business model | Show that money flows AND keeps flowing (unit economics) |
| Moat | Pre-empt "what about [foundation model / fast follower]?" |
| Competition | Position truthfully in an open quadrant |
| Team | Earn trust via shipping credentials + founder–market fit |
| Ask | Specific number + specific use + specific deadline |

If a slide has more than one job, split. If a slide has no job (e.g. "Our values"), drop.
