# Storyline Frameworks — Narrative Arc Design for Pitch Decks

> Read this BEFORE designing any storyline. The storyline is the soul of the deck. A weak storyline cannot be saved by good visuals; a strong storyline survives even amateur visuals.

---

## 1. Why storyline first

Three independent findings make narrative design the first-priority decision:

1. **DocSend reading-time data**: investors who read the entire deck spent ~3.5 minutes total. Investors who passed spent <90 seconds. The single biggest predictor of "read the whole deck" was a coherent narrative arc, not visual polish.
2. **Pixar story spine** (4 elements: setup → catalyst → escalation → resolution) is the most replicable narrative pattern in the recall literature. Decks that map cleanly to it land 2x more meetings (Garry Tan, YC Series A guide).
3. **Pattern matching**: investors decide in the first 2 minutes whether to keep listening, and that decision is heavily based on whether they can place the company on a known shelf ("Stripe for X", "Airbnb for Y"). No pattern match = no shelf = no follow-up.

**Operational rule:** before generating a single image prompt, lock in the storyline. Approve the storyline. Only then generate visuals. This is why `pitch-deck-storyline` exists as a separate skill from `pitch-deck-gen`.

---

## 2. The story spine (Pixar / Heath Brothers fusion)

Every deck must hit these four narrative beats in order. Map each to specific slide(s):

| Beat | Function | Slides | What it must do |
|------|----------|--------|-----------------|
| 1. Setup | Establish the world the audience cares about | 1–2 | Introduce subject (operator / market) + establish stakes |
| 2. Catalyst | Reveal the disruption / pain that demands action | 2–3 | Make the audience feel the problem viscerally |
| 3. Escalation | Show what happens if no one solves it + how we solve it | 3–7 | Build tension, then deliver the solution as inevitable |
| 4. Resolution | Land the new world + the ask | 8–10 | Show traction proof + team + ask = "this is happening with or without you" |

**Anti-pattern:** problem-solution-team-ask done in 4 slides. That's a pitch outline, not a story.

---

## 3. Hook formulas (slide 1–2)

The first 30 seconds determine whether the rest of the deck gets read. Pick ONE hook formula from this menu — never mix.

| # | Formula | When to use | Example |
|---|---------|-------------|---------|
| 1 | **Visceral statistic** | Market is too large/painful to ignore | `47% of food court tenants in Jakarta lose more revenue to manual cash leakage than they pay in rent.` |
| 2 | **Insider observation** | We see something most people don't | `In every bazaar I worked in 2024, the same 3 booths broke even and the rest didn't. The 3 had one thing in common.` |
| 3 | **Counter-intuitive claim** | Conventional wisdom is wrong | `Cashless venues do NOT make customers spend less. They make them spend 23% more — but only if the closed-loop is closed correctly.` |
| 4 | **Customer quote (verbatim)** | Real user pain in their words | `"I can't tell you which booth is making money until 3 weeks after the bazaar ends." — Operator, Senayan City, Q3 2025.` |
| 5 | **Personal stake** | Founder-market fit story | `My family's catering business lost Rp 280 juta in 2023 because we couldn't track which menu items were actually selling. That's why I built this.` |
| 6 | **Visual hook (no text)** | When the image alone tells the story | (No headline — just a photo of a queue at a broken POS at peak hour, slide 1; the question "What if this never happened again?" appears on slide 2) |

**Hook anti-patterns (banned):**
- "Welcome to the Future of [X]"
- "Imagine a world where..."
- "The [adjective] [noun] for [adjective] [audience]"
- Generic statistic with no source ("99% of businesses fail because...")
- "Hi, I'm [name] and we're [company]" (waste 30 seconds; introduce yourself in the speaker note, not on the slide)

---

## 4. Tension-build patterns (slides 3–6)

The middle of the deck is where most pitches die. The cure: deliberate tension build using one of these patterns:

### Pattern A — The Cost-of-Inaction Spiral

```
Slide 3: Here's the immediate pain (queues at peak hour)
Slide 4: Here's what it COSTS — quantified (Rp X juta/month per venue)
Slide 5: Here's what it costs the INDUSTRY (Rp Y triliun/year, with source)
Slide 6: Here's why nobody has solved it (regulation, infrastructure, incumbent inertia)
```
**Best for:** B2B mode (operator audience), regulated markets.

### Pattern B — The Inevitable Wave

```
Slide 3: Here's a global trend that's already real (cashless penetration in Singapore = 92%)
Slide 4: Here's where Indonesia is on that curve (38% — 5 years behind)
Slide 5: Here's the catalyst that will accelerate (BI-SNAP regulation, BI digital payment vision 2030)
Slide 6: Here's why the existing players cannot catch this wave (Yukk's PHP 5.6 stack, no offline POS)
```
**Best for:** VC mode, market-timing pitches.

### Pattern C — The Discovery Arc

```
Slide 3: Here's what we tried first (and why it didn't work)
Slide 4: Here's what we observed in production
Slide 5: Here's the insight we earned (the "secret")
Slide 6: Here's what we built because of that insight
```
**Best for:** Founder-led pitches with earned insight, second-time founders.

### Pattern D — The Two-Worlds Comparison

```
Slide 3: Here's the world WITHOUT our solution (operator P&L, before)
Slide 4: Here's the world WITH our solution (operator P&L, after)
Slide 5: Here's how we get from one to the other (the integration / rollout)
Slide 6: Here's the proof it works (case study with named operator)
```
**Best for:** B2B mode, ROI-driven pitches.

---

## 5. Emotional core (pick ONE)

Every deck delivers ONE dominant emotional core. Mixing emotions dilutes them all.

| Emotion | Trigger | Best for | Failure mode |
|---------|---------|----------|--------------|
| **Fear / Loss** | "If you don't act, you lose [specific thing]" | Regulated markets, urgent timing, declining incumbents | Sounds desperate if overdone |
| **Greed / Gain** | "If you act, you gain [specific outcome]" | Growth markets, ROI-driven B2B | Sounds salesy if not specific |
| **Identity** | "People like you back this kind of thing" | Mission-driven products, social impact, regional pride | Sounds preachy if abstract |
| **Curiosity** | "Here's a secret most don't know" | Insight-led, technical-edge plays | Wears off if no payoff |
| **Tribe / Belonging** | "Join the people building this future" | Community products, ecosystem plays | Sounds cult-y if not earned |

**Indonesian-mode default:** Fear/Loss for B2B (Yukk's lock-in, mall lease at risk if foot traffic dies), Identity for VC (Indonesian fintech pride, BI-SNAP era leaders).

---

## 6. Pattern match library

Every deck must position itself with ONE pattern match in the first 3 slides. Pick from the library or invent a new one (rare).

### Pattern match formula

`We are [known-winner] for [our specific niche/market].`

### Library (proven, investor-recognized)

**Payments / Fintech:**
- `Stripe for [X market]` — global benchmark
- `Square for [X segment]` — small-biz POS benchmark
- `Adyen for [X region]` — enterprise PG benchmark
- `Midtrans for [X vertical]` — Indonesian PG benchmark
- `Nium for [X corridor]` — cross-border benchmark

**SaaS / Vertical:**
- `Toast for [X cuisine type]` — restaurant SaaS
- `Lightspeed for [X retail vertical]` — POS SaaS
- `Shopify for [X commerce type]` — commerce platform
- `Gojek for [X non-transport service]` — Indonesian super-app

**Marketplaces:**
- `Airbnb for [X asset class]` — share-economy benchmark
- `Tiket.com for [X experience type]` — Indonesian travel benchmark
- `Tokopedia for [X niche product]` — Indonesian commerce benchmark

**Indonesian-specific (high pattern-recognition with local VCs):**
- `Yukk minus the Laravel debt` (anti-pattern positioning, only if accurate)
- `Goers for [X event vertical]`
- `Tiket for [X non-travel category]`

### Anti-patterns (banned)

- `The Apple of [X]` — used by every cocky pitch; investors have allergies
- `The Tesla of [X]` — same
- `The Uber for [X]` — overused 2014–2018, now signals "I'm not original"
- `The Netflix of [X]` — same
- `Multi-pattern stacking` ("Stripe + Shopify + Salesforce for retail") — pick ONE

### How to invent a new pattern match

If no existing winner fits, build a 2-axis comparison:
> `We are [trait of company A] + [trait of company B] for [niche]`

Example: `We are the offline-first reliability of Square + the closed-loop wristband economics of Disney MagicBand for Indonesian bazaars.`

Use sparingly — single-pattern matches are stickier.

---

## 7. The 10-slide story spine (mode-aware)

Every deck has these 10 slides in this order. Audience mode shifts the **emphasis** per slide, never the **structure**.

### Master template

| # | Slide | Story spine beat | Cognitive job |
|---|-------|------------------|--------------|
| 1 | Title / Vision | Setup | "Who you are + one-line what" |
| 2 | Hook / Problem framing | Catalyst | "Why I should keep listening" |
| 3 | Solution overview | Catalyst → Escalation | "What you do, in one image" |
| 4 | Market / Why now | Escalation | "Why this is a category, not a feature" |
| 5 | Product detail | Escalation | "How it works (one demo / three pillars)" |
| 6 | Business model / ROI | Escalation peak | "How money flows + how you get paid" |
| 7 | Traction / Competition | Escalation peak | "Proof it's working + why we win" |
| 8 | Team | Resolution | "Why you specifically — founder-market fit" |
| 9 | Roadmap | Resolution | "What lands next + what compounds" |
| 10 | Ask | Resolution | "Specific number + specific use + specific deadline" |

### VC-mode emphasis

| # | What carries the weight |
|---|------------------------|
| 1 | Company name + ask amount on the slide |
| 2 | TAM-flavored visceral statistic (size of pain × global comparable) |
| 3 | Product screenshot or short loop (showing the "secret") |
| 4 | Bottom-up TAM/SAM/SOM with sourced math + traction proof point |
| 5 | One headline feature, animated (the "wow" moment) |
| 6 | Unit economics: LTV/CAC, gross margin, payback months |
| 7 | Honest 2x2 with axes that flatter us truthfully + traction chart |
| 8 | Founder photos + 1-line founder–market fit each + key hires |
| 9 | 12-month + 24-month roadmap with milestone dates |
| 10 | Round size + pre/post valuation + use of funds 4-bullet + 18-month milestones |

### B2B-mode emphasis

| # | What carries the weight |
|---|------------------------|
| 1 | Product name + venue logo lock-up + ROI promise headline |
| 2 | Operator's daily pain in a photo (queue, broken POS, exhausted manager) |
| 3 | Before/after operator dashboard side-by-side |
| 4 | Comparable venues already running + GMV uplift % (named operators) |
| 5 | Three pillars (POS + Wristband + Control Room) icon grid + one demo |
| 6 | Operator P&L: cost vs uplift in IDR, payback months, sensitivity table |
| 7 | Yukk feature gap matrix + traction with named partner logos |
| 8 | On-the-ground deployment team + support SLA + escalation path |
| 9 | What value lands at venue THIS quarter (analytics agent, ads agent, social agent) |
| 10 | Pilot scope + commercial terms + integration timeline + decision deadline |

### Hybrid-mode emphasis (when single deck must serve both VC + B2B audiences)

Pick the B2B-emphasis template as the base, then add 3 appendix slides:
- A1: Company-level financials (MRR, growth rate, gross margin)
- A2: Use of funds if VC ask
- A3: Cap table summary

The core 10 stays B2B-flavored; appendix surfaces the VC ask only when an actual VC is in the room.

---

## 8. Pre-empting the 10 standard investor questions

Every successful deck pre-empts these 10 questions before the investor asks. Map each to a slide.

| # | Question | Pre-empted by |
|---|----------|---------------|
| 1 | What do you do? | Slide 1 (one-line vision) |
| 2 | Why does it matter? | Slide 2 (problem) |
| 3 | What's your secret? | Slide 3 (solution) |
| 4 | How big is the market? | Slide 4 (market) |
| 5 | How does it actually work? | Slide 5 (product) |
| 6 | How do you make money? | Slide 6 (business model) |
| 7 | Is anyone using it? | Slide 7 (traction) |
| 8 | Who's competing? | Slide 7 (competition matrix) |
| 9 | Why you? | Slide 8 (team) |
| 10 | What do you want from me? | Slide 10 (ask) |

If any question lacks a slide, the deck has a hole. Storyline skill must verify all 10 are covered before approval.

---

## 9. The closing principle (slide 10)

The last slide is NOT "Thank You." It's the ask, in big type, with concrete numbers.

**VC-mode last slide template:**
```
We're raising [Rp X B / $Y M] Series [A/B]
to [primary use of funds — one phrase]

Use of funds:
- [Bucket 1]: [percent]%
- [Bucket 2]: [percent]%
- [Bucket 3]: [percent]%
- [Bucket 4]: [percent]%

Milestones (next 18 months):
- Month 6: [milestone]
- Month 12: [milestone]
- Month 18: [milestone]

[Founder name] · [email] · [QR code to data room]
```

**B2B-mode last slide template:**
```
Pilot offer

Scope: [number of venues / locations / customers covered]
Commercial: [Rp X / month per venue + Y% GMV revenue share]
Integration: live in [N weeks] from contract signing
Decision deadline: [specific date 4-6 weeks out]

Next step: [specific call-to-action — e.g. "Sign pilot MOU by 15 May 2026"]

[Lead's name] · [email] · [WhatsApp]
```

**Why this works:**
- During Q&A the audience stares at the last slide for 30+ seconds — that real estate is for the ask, not pleasantries
- The deadline creates urgency without being pushy
- Specific numbers signal preparedness; vague numbers signal the founder hasn't done the math

---

## 10. Story spine validation checklist (to pass `pitch-deck-validate`)

Before approving a storyline, verify ALL of these:

- [ ] Hook chosen from one of 6 formulas (no banned hooks)
- [ ] Tension-build pattern (A / B / C / D) explicitly selected
- [ ] Emotional core named (Fear / Greed / Identity / Curiosity / Tribe — exactly one)
- [ ] Pattern match present in slides 1–3 ("we are [winner] for [niche]")
- [ ] All 10 standard investor questions mapped to specific slides
- [ ] Slide 1 = setup (vision + ask amount or ROI promise)
- [ ] Slide 2 = catalyst (the hook)
- [ ] Slide 6 or 7 = escalation peak (proof + competition)
- [ ] Slide 10 = ask (specific number + use + deadline; never "Thank You")
- [ ] Audience mode declared (VC / B2B / hybrid) and emphasis applied
- [ ] Indonesian-context signals present (if Indonesian audience)
- [ ] No banned vocabulary in storyline draft (check `global-config.md` §4)

If any box is unchecked, storyline goes back for revision before `pitch-deck-gen` runs.
