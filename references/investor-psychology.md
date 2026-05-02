# Investor Psychology — Filters, Questions, Pattern Matching

> Read this BEFORE designing storyline. The deck is a stimulus; investor psychology is the response. Design the stimulus to land the response you want.

> **Source backbone:** `references/research/investor-pitch-deck-best-practices-2026.md` — 49-source NotebookLM synthesis. Cross-reference for fresh data and Indonesian-context updates.

---

## 1. The first 2 minutes (DocSend 2024–25 data)

| Metric | Value | Implication |
|--------|-------|-------------|
| Average first-pass review time | 2 min 14 sec | Deck must work at SKIM speed before anything else |
| Slides 1–4 attention share | 60% of total | Front-load traction / hook / pattern match |
| Slide count sweet spot | 10–13 slides | Engagement drops 40% after slide 15 |
| Time on individual key slides (winning decks) | 13 sec avg | A slide must communicate its core in 8 sec or less |

**Operational consequence:** if the founder has ARR > $1M, traction MUST appear by slide 2 (the research's "lead with traction" rule for 2026). If the founder is pre-revenue, problem stays at slide 2 but it MUST be visceral enough to earn the next 11 slides.

---

## 2. The decision filter (first 90 seconds)

Investors run incoming decks through this implicit filter — fast, mostly subconscious. Decks that survive filter all 5 questions; decks that fail any are passed on.

| # | Filter question | Pre-empted by |
|---|----------------|---------------|
| F1 | "Can I place this on a known shelf?" (pattern match) | Slide 1 + 3 (named comparable) |
| F2 | "Is the problem real and large?" | Slide 2 (visceral pain + sourced size) |
| F3 | "Is there a reason this works NOW?" | Slide 4 (Why Now — specific technical/market shift, not macro cliché) |
| F4 | "Will this thing actually compound?" | Slide 7 (traction with growth rate + retention) |
| F5 | "Is this team the one to ride this?" | Slide 8 (founder–market fit + shipping credentials) |

If any of F1–F5 is unanswerable from the deck alone, the deck dies. The skill must verify all 5 are answered before storyline approval.

---

## 3. The 10 standard investor questions (slide-mapping)

Every successful deck pre-empts these 10 questions. If a question lacks a clear slide answer, the deck has a hole.

| # | Question | Where it gets answered |
|---|----------|----------------------|
| 1 | What do you do? | Slide 1 — one declarative sentence (no buzzwords) |
| 2 | Why does it matter? | Slide 2 — problem + size |
| 3 | Why now? | Slide 4 — specific shift (technical, regulatory, behavioral) |
| 4 | What's the secret? | Slide 3 / 5 — the insight that makes our solution work |
| 5 | How big is the market? | Slide 5 — bottom-up math (`customers × price × realistic share`) |
| 6 | Is anyone using it? | Slide 6 — traction (revenue, retention, logos) |
| 7 | How do you make money? | Slide 7 — unit economics (CAC, LTV, gross margin) |
| 8 | What's your moat? | Slide 8 — the 2026 weight slide (specific defense thesis) |
| 9 | Who else is competing? | Slide 9 — 2x2 with axes that flatter us truthfully |
| 10 | Why you specifically? | Slide 10 — team with shipping credentials |

Note: this is the **VC-mode** question set. B2B mode has a parallel set — see `b2b-channel-partner-playbook.md` for B2B-specific questions.

---

## 4. The 2026 moat-slide weight shift (CRITICAL)

According to the research, the moat slide carries 30–40% of underwriting weight in 2026 (vs ~15% in 2020), driven by foundation-model concerns.

### What investors actually want on the moat slide

| Moat type | Strong | Weak |
|-----------|--------|------|
| **Data moat** | Proprietary dataset growing with usage; can be queried cheaper/faster than via foundation models | "We have a lot of data" with no specifics |
| **Distribution moat** | Channel partner exclusivity, embedded SaaS, regulatory license | Generic "first-mover advantage" |
| **Workflow moat** | Multi-step user workflow that locks in habit + integrations | "Better UX" with no specific friction reduction quantified |
| **Network effects** | Each new node measurably increases value of existing nodes (numbers shown) | Vague reference to "network effects" without proof |
| **Regulatory moat** | License (BI, OJK, banking, payment institution) | "Compliance" without naming the regulation |
| **Closed-loop economics** | Wallet/wristband/closed payment loop with on/off ramp control | "Cashless" with no economic capture mechanism |
| **Vertical depth** | Deep workflow knowledge in narrow vertical, integrations no horizontal player can replicate | Generic "industry expertise" |

**The 2026 question every moat slide must answer (verbatim):** *"What happens when GPT-5 / Sora / a major foundation model lands in your space?"* If the answer is "they don't compete with us because [specific structural reason]" the moat is real. If the answer is "we'll innovate faster" the moat is weak.

### Indusia Merchant moat thesis (worked example)

Given user's product:
- **Distribution moat**: BI license + EO partnerships + mall partnerships (not replicable from foundation model)
- **Data moat**: per-venue per-tenant per-hour transaction data + closed-loop wristband behavioral data (not in any public training corpus)
- **Workflow moat**: PWA + IndexedDB offline-first POS — works without connection (foundation models don't render offline)
- **Closed-loop economics**: wristband closes payment loop within venue (foundation model can't operate hardware)

Pitch this as: *"Foundation models are commodity. The merchant operating layer in Indonesian bazaars isn't — and we own it via four compounding moats: regulation, on-the-ground data, offline-first workflow, and closed-loop hardware economics."*

---

## 5. Pattern-matching shelves

Investors decide whether to keep listening based on whether they can place the company on a known shelf. The first 3 slides must declare which shelf.

### How pattern matching works in the investor's head

```
INPUT (deck slide 1–3): name + one-line + comparable
   → INVESTOR MEMORY LOOKUP: "what does this remind me of?"
       → IF match found: pull associated mental model, judge against it
       → IF no match: deck loses 30 seconds while investor builds new mental model from scratch
```

The lookup is involuntary and fast. Founders who try to be "totally new and unprecedented" force the investor's brain to do work it doesn't want to do — and the brain pushes back by passing.

### Use the library in `storyline-frameworks.md` §6

The 20+ pre-vetted pattern matches in `storyline-frameworks.md` map cleanly to investor mental models. Pick from the library; only invent a custom pattern when nothing fits.

### Indonesian-VC pattern-recognition note

Indonesian VCs (East Ventures, AC Ventures, Alpha JWC, Intudo, Mandiri Capital, BRI Ventures) pattern-match strongest to:
1. Indonesian winners they've already backed or seen win (Tokopedia, Tiket.com, Xendit, Midtrans, GoTo)
2. SEA winners (Grab, Shopee, Sea Limited)
3. China/India winners (Ant, Paytm) — when the "Indonesia is a 5-year-behind version" thesis holds
4. US winners (Stripe, Square, Shopify) — most recognized but easiest to dismiss as "not localized"

Order your pattern matches in this priority for Indonesian-mode decks.

---

## 6. The 2020-vs-2026 shift map

The research identifies these structural changes the deck must reflect:

| Element | 2020 expectation | 2026 expectation |
|---------|-----------------|-----------------|
| Underwriting weight on moat | ~15% | **30–40%** |
| Market sizing | Top-down OK | **Bottom-up mandatory** (top-down = red flag) |
| Team slide | Ex-FAANG credentials sufficient | **Shipping credentials demanded** ("scaled X to Y") |
| Lead-with logic | Problem-first universal | **Traction-first if ARR > $1M** |
| AI defensibility | Optional | **Mandatory if AI-adjacent** |
| Why-Now slide | Optional / generic macro | **Mandatory + specific** (no "digital transformation") |
| Data room | Static Google Drive / Dropbox | **Engagement-tracked** (Peony, DocSend); engagement = buying signal |
| Indonesian VCs | Pre-eFishery: relaxed governance | **Post-eFishery: deeper diligence, tighter governance** |

Storyline skill must apply 2026 expectations by default. Falling back to 2020-style decks will hurt outcomes.

---

## 7. B2B vs VC psychology (mode differences)

| Filter | VC | B2B (channel partner / operator) |
|--------|----|-----------------------------------|
| F1 — Pattern match | "Stripe for X" / "Square for Y" | "We're the next Yukk minus the Laravel debt" / "Closed-loop like MagicBand" |
| F2 — Problem | Market-sized pain ("Rp X T market loses Y% to leakage") | Operator's daily pain (queues, shrinkage, no insight) |
| F3 — Why now | Tech / regulatory shift (BI-SNAP, AI inference cost) | "Your lease renewal is in 8 months — show foot traffic uplift now" |
| F4 — Compound | Net revenue retention, viral coefficient, GMV CAGR | Per-venue economics, payback months, expansion revenue |
| F5 — Team | Founder–market fit + ex-shipping wins | Same + on-the-ground deployment team + 24/7 support SLA |

**Mode-detection signals for the brief skill:**
- Audience description mentions: invest, equity, fundraise, valuation → VC
- Audience description mentions: deploy, adopt, ROI, pilot, integration, mall, EO → B2B
- Both → hybrid

---

## 8. Cognitive biases that work for / against the founder

### For the founder (use these)

| Bias | How to leverage |
|------|----------------|
| **Anchoring** | First number on the deck anchors expectations. If ask is Rp 30B, lead with bigger numbers (Rp 1.5T market) so 30B feels modest |
| **Availability heuristic** | Mention recent successful comparable (Xendit's $1B+ valuation in 2022) — investor remembers it, applies model |
| **Loss aversion** | "Yukk's PHP 5.6 stack will collapse before BI-SNAP enforcement deadline — incumbents lose, we win" |
| **Endowment effect** | Mid-deck, propose a small commitment (15-min pilot demo) — once they say yes, sunk-cost biases them toward the larger ask |
| **Social proof** | Named investors / partners on traction slide (logo lockup) |

### Against the founder (avoid triggering)

| Bias | Trigger to avoid |
|------|-----------------|
| **Confirmation bias** | If first 3 slides feel "AI-slop" the investor confirms "this founder is generic" for the rest — recovery is impossible |
| **Pattern matching to bad outcomes** | Avoid surface similarity to fraud cases (eFishery 2025): never claim revenue numbers without auditable source; never overstate user count |
| **Hindsight bias** | Don't claim "obvious" insights that the investor missed — phrase as your earned discovery, not their failure |
| **In-group bias** | Indonesian-mode: avoid "Western expert quotes" without local equivalents; investors want to feel local insight |

---

## 9. The "moat slide" anti-pattern catalog

These claims are auto-rejected as moat in 2026:

| Claim | Why it fails |
|-------|--------------|
| "We're first-mover" | First-mover advantage is a 2010 idea; 2026 sees first-movers eaten by fast-followers regularly |
| "We have a 2-year head start" | Foundation models compress time; head starts are shorter than ever |
| "Our team is best-in-class" | That's a team claim, not a moat |
| "Our UX is better" | UX is copyable in days |
| "We have proprietary algorithms" | Specify the algorithm and why it can't be replicated, or drop the claim |
| "We have AI" | Everyone has AI in 2026; what specifically isn't commoditizable? |
| "We have data" | Specify what data, how it grows, why it can't be assembled by a competitor |

---

## 10. Storyline-stage psychology checklist

Before approving a storyline, verify it pre-empts the 5 filters and 10 questions:

- [ ] F1 — Pattern match in slides 1–3 (named comparable)
- [ ] F2 — Visceral problem in slide 2 with sourced size in slide 5
- [ ] F3 — Specific Why Now in slide 4 (no macro clichés)
- [ ] F4 — Compounding traction or compounding mechanism in slide 6 / 7
- [ ] F5 — Founder–market fit in slide 10 (shipping credentials, not FAANG titles)
- [ ] Q1–Q10 — Each of the 10 standard questions mapped to a specific slide
- [ ] Moat slide present and answers "what happens when foundation model X lands"
- [ ] Bottom-up market sizing (no top-down)
- [ ] If ARR > $1M, traction surfaced by slide 2 not buried at slide 7

If any unchecked, storyline goes back for revision before `pitch-deck-gen` runs.
