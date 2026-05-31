# Deck Infographic System — HTML/CSS Construction Kit for Visual-First Slides

> **READ THIS BEFORE BUILDING ANY DECK SLIDE IN `html-css` MODE.**
> `visual-language.md` tells you the *rule* (≥70% visual, one idea per slide). `image-prompt-templates.md §3 Formula B` gives infographic structures for **NB2 image** prompts. This file is the **missing middle**: copy-paste HTML/CSS components that build those same flow-infographics as *live, designed slides* — accurate numbers, brand palette, no AI color accidents.
>
> **Why this file exists (root-cause fix, v0.3.1):** decks rendered in `html-css` mode were failing as text-card walls — the model had the visual-ratio rule but no construction kit, so it defaulted to bullet lists in boxes. A bullet-card slide is a DOCUMENT, not a pitch. This file makes the visual-first build the path of least resistance.
>
> **Knowledge layer (read alongside for deck modes):** `research/executive-deck-craft-2026.md` = *why* (decision-first structure, Minto pyramid, action titles, 5-second rule, credibility killers, the word budget these components enforce). `research/nano-banana-pro-prompting-2026.md` = *how to prompt NB2* for any image slot inside these components (6-component formula, exact hex, named layout/style, text-free-background rule). This file = *how to build the live slide*. Use all three together.

---

## 0. The doctrine — what an engaging pitch slide IS (non-negotiable)

A CEO does not READ during a pitch. They glance, and listen. Therefore:

1. **The slide is the VISUAL track. The speaker is the VERBAL track.** If the slide says everything, the speaker is redundant and the audience reads instead of listens. Put the words in speaker-notes, not on the slide.
2. **One idea per slide.** One headline (≤8 words) + one diagram or one hero number. If a slide makes two points, split it.
3. **Show the FLOW, don't describe it.** "Data → AI → Revenue" is an arrow diagram with icons, never three sentences.
4. **Numbers are visuals.** A `−53%` at 90pt in signal-red IS the slide. A sentence containing "-53%" is text.
5. **Bullet lists are banned on pitch slides.** A bullet list = a paragraph wearing dots. Convert every bullet set into a diagram, a stat-grid, an icon-flow, or a comparison.
6. **8-second test.** If the core can't land in 8 seconds without reading, the slide is over-written. Redesign.
7. **Concept/data slides are DESIGNED infographics (this file), never AI mood-art.** AI abstract backgrounds drift off-palette (the magenta-blob failure). Build concept slides in HTML/CSS; use AI only for photographic atmosphere on emotional slides.

> **Litmus:** cover the slide with your hand; uncover for 2 seconds; cover again. If you retained the point → pass. If you needed to read → fail.

---

## 1. Every deck slide is ONE of two types — never a third

| Type | Use for | Built with | Text budget |
|------|---------|-----------|-------------|
| **A · Photo-hero** | emotional beats: cover, problem, traction, why-now, CTA | AI photo background (`image-prompt-templates.md`) + minimal HTML overlay | 1 headline + 1 number + ≤12 words sub |
| **B · Designed infographic** | concept/data: solution, product lines, business model, deal, moat, market | a component from §3 below (HTML/CSS) | 1 headline + diagram labels only |

**There is no type C ("bullet cards").** If you are about to put 3-4 text boxes with sentences on a slide, STOP — pick a §3 component instead.

---

## 2. Slide-role → component map (deck-vc / deck-b2b / deck-hybrid)

| Slide role | Default component (§3) | Why |
|------------|------------------------|-----|
| cover / title | §3.9 Photo-hero overlay | atmosphere + lockup + 1 line |
| problem | §3.1 Stat-trio over photo | quantified pain, glanceable |
| solution (the secret) | §3.3 Flow OR §3.6 Comparison | show the mechanism / the contrast |
| product line / use-cases | §3.8 Icon-flow grid (Data→AI→Outcome) | many use-cases, still visual |
| market / sizing | §3.2 Waterfall OR §3.1 stat-trio | bottom-up math as bars |
| business model | §3.2 Revenue waterfall (layers → total) | money flow, McKinsey-grade |
| traction | §3.1 Stat-trio over photo | proof numbers dominate |
| moat | §3.4 Hub-radial OR §3.7 Layered stack | defensibility as structure |
| deal / roadmap | §3.5 Stage timeline | phased progression |
| why-now | §3.1 Stat-trio over photo | 3 catalysts as icon-stats |
| team / founder | §3.9 Photo + §3.8 mini icon-row | real face + credential map |
| ask / CTA | §3.9 Photo + contact card | the ask, big |

---

## 3. The component library (copy-paste, brand-tokenized)

All components assume the design tokens in §4 are in `:root`. All are ≥70% visual by construction. Replace `{...}` placeholders with `copy.json` values. **Do not add sentences.** Labels only.

### 3.1 — Stat-trio / hero numbers (the workhorse)
Three giant numbers carry the slide. Each number ≥64pt; label ≤6 words.
```html
<div class="stat-row">
  <div class="stat"><div class="num up">+20%</div><div class="lbl">revenue, 1H FY26</div></div>
  <div class="stat"><div class="num down">−53%</div><div class="lbl">net profit, same period</div></div>
  <div class="stat"><div class="num warn">S$11.8M</div><div class="lbl">copper provision</div></div>
</div>
```
```css
.stat-row{display:flex;gap:7%;align-items:flex-start}
.stat .num{font-family:var(--display);font-weight:900;font-size:72pt;line-height:.9;color:var(--cyan)}
.stat .num.up{color:var(--cyan)} .stat .num.down,.stat .num.warn{color:#FF6B6B} .stat .num.go{color:var(--gold)}
.stat .lbl{font-size:12pt;color:var(--muted);margin-top:3mm;max-width:46mm}
```

### 3.2 — Revenue waterfall / layered bars (business model, sizing)
Money flow as stacked, color-banded bars with big numbers — NOT a table of text.
```html
<div class="wf">
  <div class="wf-bar" style="--h:38%"><span class="wf-tag">Layer 1 · Platform</span><span class="wf-val">floor</span></div>
  <div class="wf-arrow">+</div>
  <div class="wf-bar" style="--h:62%"><span class="wf-tag">Layer 2 · Value capture</span><span class="wf-val">gainshare</span></div>
  <div class="wf-arrow">+</div>
  <div class="wf-bar go" style="--h:100%"><span class="wf-tag">Layer 3 · Outward royalty</span><span class="wf-val">scale</span></div>
  <div class="wf-arrow">=</div>
  <div class="wf-total"><div class="wf-from">S$480M</div><div class="wf-to">→ S$960M</div></div>
</div>
```
```css
.wf{display:flex;align-items:flex-end;gap:3%;height:78mm}
.wf-bar{flex:1;height:var(--h);background:linear-gradient(180deg,var(--primary),#16284f);
  border-top:3px solid var(--cyan);border-radius:6px 6px 0 0;display:flex;flex-direction:column;
  justify-content:flex-end;padding:5mm;position:relative}
.wf-bar.go{border-top-color:var(--gold)}
.wf-tag{font-size:11pt;font-weight:700;color:var(--ink)} .wf-val{font-size:10pt;color:var(--muted);font-family:var(--mono)}
.wf-arrow{font-family:var(--display);font-weight:900;font-size:34pt;color:var(--muted);padding-bottom:6mm}
.wf-total{display:flex;flex-direction:column;justify-content:flex-end;padding-bottom:6mm}
.wf-from{font-size:16pt;color:var(--muted);text-decoration:line-through}
.wf-to{font-family:var(--display);font-weight:900;font-size:40pt;color:var(--gold);line-height:1}
```

### 3.3 — Horizontal flow (input → engine → output) — THE "explain it simply" component
The single most important pattern for "show the flow." Icons + arrows, ≤3 words per node.
```html
<div class="flow">
  <div class="node"><div class="ic">▦</div><div class="nt">Sensor & telemetry data</div></div>
  <div class="arr">→</div>
  <div class="node engine"><div class="ic">◆</div><div class="nt">INDUSIA AI engine</div></div>
  <div class="arr">→</div>
  <div class="node out"><div class="ic">$</div><div class="nt">Recurring revenue</div></div>
</div>
```
```css
.flow{display:flex;align-items:center;justify-content:space-between;gap:2%;margin-top:6mm}
.node{flex:1;background:var(--card);border:1px solid var(--line);border-radius:14px;padding:8mm 5mm;text-align:center}
.node.engine{border-color:var(--cyan);box-shadow:0 0 0 2px rgba(0,217,255,.25)}
.node.out{border-left:4px solid var(--gold)}
.node .ic{font-size:30pt;color:var(--cyan);margin-bottom:3mm}
.node.out .ic{color:var(--gold)}
.node .nt{font-size:12pt;font-weight:700;color:var(--ink)}
.arr{font-size:26pt;color:var(--cyan);font-weight:900}
```

### 3.4 — Hub-and-spoke / radial (moat, outward reach, ecosystem)
Center anchor + spokes. Each spoke ≤3 words. Use for "one core → many" stories.
```html
<div class="hub">
  <div class="core">CAST<br>data core</div>
  <div class="spoke s1">Data flywheel</div>
  <div class="spoke s2">On-prem edge</div>
  <div class="spoke s3">Exclusive channel</div>
  <div class="spoke s4">CoE status</div>
</div>
```
```css
.hub{position:relative;height:80mm;display:flex;align-items:center;justify-content:center}
.core{width:46mm;height:46mm;border-radius:50%;background:radial-gradient(circle,var(--primary),#0b1f44);
  border:2px solid var(--cyan);display:flex;align-items:center;justify-content:center;text-align:center;
  font-weight:800;font-size:13pt;color:var(--ink);box-shadow:0 0 40px rgba(0,217,255,.3)}
.spoke{position:absolute;background:var(--card);border:1px solid var(--line);border-radius:30px;
  padding:3mm 6mm;font-size:11pt;font-weight:700;color:var(--ink)}
.spoke.s1{top:6mm;left:18%} .spoke.s2{top:6mm;right:18%}
.spoke.s3{bottom:6mm;left:18%} .spoke.s4{bottom:6mm;right:18%}
```

### 3.5 — Stage timeline (deal phasing, roadmap)
Horizontal track, 3-4 nodes, final node accented gold. ≤4 words per stage.
```html
<div class="track">
  <div class="step"><div class="dot">1</div><div class="st">LAND · 0–6mo</div><div class="sd">Paid pilot</div></div>
  <div class="line"></div>
  <div class="step"><div class="dot">2</div><div class="st">PROVE · 6–12mo</div><div class="sd">Gainshare</div></div>
  <div class="line"></div>
  <div class="step"><div class="dot go">3</div><div class="st">EXPAND · 12–24mo</div><div class="sd">SG AI CoE JV</div></div>
</div>
```
```css
.track{display:flex;align-items:flex-start;margin-top:10mm}
.step{display:flex;flex-direction:column;align-items:center;text-align:center;width:42mm}
.dot{width:16mm;height:16mm;border-radius:50%;background:var(--primary);border:2px solid var(--cyan);
  display:flex;align-items:center;justify-content:center;font-weight:900;font-size:18pt;color:var(--ink)}
.dot.go{border-color:var(--gold);background:linear-gradient(135deg,var(--gold),#b98400);color:#0b1929}
.st{font-weight:800;font-size:12pt;margin-top:4mm} .sd{font-size:10pt;color:var(--muted)}
.line{flex:1;height:3px;background:linear-gradient(90deg,var(--cyan),var(--gold));margin-top:8mm}
```

### 3.6 — Comparison / VS (the secret, before/after)
Two columns, the winning side accented. One row of contrast, big.
```html
<div class="vs">
  <div class="col"><div class="ct">Cable revenue</div><div class="cn">~3¢</div><div class="cl">net profit per $1</div></div>
  <div class="vmid">vs</div>
  <div class="col win"><div class="ct">AI revenue</div><div class="cn">~45¢</div><div class="cl">net profit per $1</div></div>
</div>
```
```css
.vs{display:flex;align-items:stretch;gap:4%;margin-top:8mm}
.col{flex:1;background:var(--card);border:1px solid var(--line);border-radius:16px;padding:9mm;text-align:center}
.col.win{border:2px solid var(--gold);box-shadow:0 0 30px rgba(255,184,0,.18)}
.ct{font-size:13pt;color:var(--muted)} .cn{font-family:var(--display);font-weight:900;font-size:64pt;color:var(--cyan);line-height:1}
.col.win .cn{color:var(--gold)} .cl{font-size:11pt;color:var(--muted)}
.vmid{display:flex;align-items:center;font-weight:900;font-size:24pt;color:var(--muted)}
```

### 3.7 — Layered architecture stack (intelligence layer, tech stack)
```html
<div class="stack">
  <div class="layer go">AI Intelligence Layer — INDUSIA</div>
  <div class="layer">Telemetry · PowerIQ · SIRI · OT/ICS</div>
  <div class="layer">LKH hardware & distribution</div>
</div>
```
```css
.stack{display:flex;flex-direction:column;gap:4mm;margin-top:8mm}
.layer{padding:8mm;border-radius:12px;background:var(--card);border:1px solid var(--line);
  font-weight:700;font-size:14pt;color:var(--ink);text-align:center}
.layer.go{background:linear-gradient(135deg,rgba(255,184,0,.18),rgba(255,184,0,.04));border-color:var(--gold)}
```

### 3.8 — Icon-flow grid (MANY use-cases, still visual)
For "lots of AI use-cases per line" without a text wall: a grid of icon tiles, ≤3 words each.
```html
<div class="ug">
  <div class="tile"><div class="ti">◉</div><span>Visual inspection</span></div>
  <div class="tile"><div class="ti">∿</div><span>Predictive maintenance</span></div>
  <div class="tile"><div class="ti">⚡</div><span>Energy / OEE</span></div>
  <div class="tile"><div class="ti">⛨</div><span>OT/ICS anomaly</span></div>
  <div class="tile"><div class="ti">◷</div><span>SIRI-AI diagnostic</span></div>
  <div class="tile"><div class="ti">≈</div><span>Power-quality forecast</span></div>
</div>
```
```css
.ug{display:grid;grid-template-columns:repeat(3,1fr);gap:5mm;margin-top:7mm}
.tile{background:var(--card);border:1px solid var(--line);border-radius:12px;padding:6mm;display:flex;
  align-items:center;gap:4mm}
.tile .ti{font-size:22pt;color:var(--cyan);min-width:10mm;text-align:center}
.tile span{font-size:11.5pt;font-weight:600;color:var(--ink)}
```

### 3.9 — Photo-hero overlay (emotional slides only)
AI photo background + dark scrim + minimal overlay. (Render plumbing: `html-css-print-templates.md`.)
```html
<div class="bg" style="background-image:url('img/NN.png')"></div>
<div class="scrim"></div>
<div class="wrap"><h1>{≤8 words}</h1><div class="rule"></div><div class="one-num">{1 hero number}</div></div>
```
Scrim must keep text contrast ≥ 4.5:1. Left- or right-third gradient per `visual-language.md §10`.

---

## 4. Design tokens (paste into every deck `:root`)
Pull hex from `brief.json.brand_palette` verbatim. Example (indusia-tech dark):
```css
:root{
  --bg:#0B1929; --bg-deep:#050E1A; --primary:#1E3A8A; --cyan:#00D9FF;
  --gold:#FFB800; --ink:#F8FAFC; --muted:#94A3B8;
  --card:rgba(17,34,58,.72); --line:rgba(0,217,255,.30);
  --display:'Inter',sans-serif; --mono:'JetBrains Mono',monospace;
}
```
Rules: cyan = data highlight (1-3 words / numbers only, never body). gold = emphasis + final CTA only. Muted = labels. Never put cyan on long text (a11y + amateur signal).

---

## 5. Word budget per slide (HARD CAP — enforced at validate)
| Element | Max |
|---------|-----|
| Headline | 8 words |
| Diagram node / tile / stat label | 6 words |
| Sub-line (only on photo-hero) | 14 words |
| Sentences/paragraphs anywhere on a slide | **0** |
| Total readable words per slide | **≤ 25** |

If a slide exceeds 25 words, you are writing a document. Move the words to `speaker-notes.md`.

---

## 6. Pre-render visual self-check (run on EVERY slide before render — MANDATORY)
For each slide, answer. Any "no" → rebuild before rendering the PDF.
1. Is the slide Type A (photo-hero) or Type B (a named §3 component)? (If "neither / bullet cards" → FAIL.)
2. Is there exactly ONE idea? (Two ideas → split.)
3. Readable words ≤ 25 and zero full sentences? (Count them.)
4. Is there a dominant visual (diagram or hero number or photo) occupying ≥60% of the canvas?
5. Does it pass the 8-second / hand-cover test?
6. Concept slide built in HTML/CSS (not AI mood-art)? Palette = brand tokens only?

Log the per-slide answers in `image-prompts.json` under `visual_self_check`. `ai-business-document-validate` re-runs this.

---

## 7. Anti-patterns (the exact failures this file prevents)
| Anti-pattern | Why it fails | Fix |
|--------------|-------------|-----|
| 3-4 text cards with sentences | document, not pitch; <30% visual | §3 component |
| Bullet list (any) | paragraph wearing dots | convert to icon-flow / stat-grid |
| Paragraph inside a card | text-counting, fails ratio | one ≤6-word label max |
| AI abstract background for a concept slide | drifts off-palette (magenta blobs), says nothing | build the infographic in HTML/CSS |
| Headline + sub-text + 4 cards + paragraph | five things, zero focus | one idea, one component |
| Cyan body text on dark | a11y fail, "amateur tech blog" | cyan only on numbers/1-3 words |
| Same number repeated in headline AND a card | redundant text | number lives once, as a visual |

---

## 8. Icons
Use a single icon family — **Lucide** (open-source, ~1500 icons) inline-SVG, 2px stroke, single color (`--cyan`, or `--gold` for the "output/win" node). The unicode glyphs in §3 examples are placeholders; replace with Lucide SVG paths for production. Banned (per `visual-language.md §9`): light bulb, gear, globe, rocket, brain-with-circuits, generic shield/padlock, handshake.

---

## 9. Integration
- `ai-business-document-gen` (html-css mode, deck-*): MUST read this file; concept/data slides MUST use a §3 component; run §6 self-check before render.
- `ai-business-document-validate`: re-runs §6 + §5 word cap per slide; a bullet-card / text-wall slide is a HARD FAIL.
- Cross-ref: `visual-language.md §2/§2.5/§2.6` (the rule), `image-prompt-templates.md §3` (the NB2 equivalent for full-image mode), `html-css-print-templates.md` (render plumbing).
