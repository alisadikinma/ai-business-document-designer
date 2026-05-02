# Image Prompt Templates — GeminiGen.AI / Nano Banana Pro for Pitch Decks

> Use these templates ONLY after `visual-language.md` rules are internalized. Bad prompts produce AI-slop visuals that fail `pitch-deck-validate`.

---

## 1. GeminiGen.AI API contract (authoritative)

### Endpoint
```
POST https://api.geminigen.ai/uapi/v1/generate_image
```

### Authentication
```
Header: x-api-key: <GEMINIGEN_API_KEY env var>
Content-Type: multipart/form-data
```

### Request parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `prompt` | string | Yes | 40–100 words sweet spot for slide imagery |
| `model` | string | Yes | `nano-banana-pro` (default) for slide imagery |
| `aspect_ratio` | string | No | `16:9` for landscape decks (default), `1:1` for square hero, `4:3` for legacy decks |
| `style` | string | No | See style guide below |
| `output_format` | string | No | `png` (default for slides — lossless) |
| `resolution` | string | No | `2K` (default for slides) |
| `file_urls` | array | No | URL reference images (e.g. operator photo, venue logo) |
| `ref_history` | string | No | UUID for style consistency across deck |

### Response
```json
{
  "id": 12345,
  "uuid": "img_abc",
  "model_name": "nano-banana-pro",
  "input_text": "...",
  "generate_result": "https://cdn.geminigen.ai/images/img_abc.png",
  "status": 2,
  "status_desc": "completed"
}
```

### Rate limits
| Model | Limit |
|-------|-------|
| `nano-banana-pro` | FREE — 5 req/min, 100 req/hour, 1,000 req/day |
| Other models | No rate limit (credit-based) |

> **Style consistency tip:** all 10 slides share visual identity. Generate slide 1 first, capture its `uuid`, pass as `ref_history` to slides 2–10 for consistency.

---

## 2. Style selection guide

### Photorealistic (DEFAULT for product, venue, team, before/after)
```
style=Photorealistic
prompt_pattern: [subject] [action] [environment] [time of day] [lighting] [camera framing] [mood]
```

### Editorial (for problem slide, vision slide, hero shots)
```
style=Editorial
prompt_pattern: [subject in moment of emotion] [environment with atmosphere] [editorial photography style — Magnum / NatGeo / TIME] [lighting]
```

### Infographic-flat (for charts, market sizing, business model)
```
style=Infographic
prompt_pattern: [data type] [visual encoding] [color palette using brand primary + neutral secondary] [annotation labels — concrete numbers]
```

### Illustration (when photography is impossible — abstract concepts, futures, before-photography era)
```
style=Editorial-illustration
prompt_pattern: [subject] [action] [stylistic reference — e.g. Wall Street Journal hedcut, Christoph Niemann minimalist, Tom Froese geometric] [color palette]
```

> **Avoid:** style=Anime, style=3D-render, style=Cyberpunk for investor decks. They signal hobbyist energy.

---

## 3. Per-slide-type prompt formulas

### SLIDE 1 — Title / Vision

**Goal:** place the company on a known shelf in 4 seconds. The image carries the brand promise.

#### Formula (Photorealistic — Indonesian B2B mode)
```
A {hero_subject} {hero_action} at {specific_indonesian_venue} during {time_of_day},
{lighting_quality} light, {camera_framing}, shallow depth of field,
editorial photography style reminiscent of {photography_reference},
warm color grading favoring brand primary {hex_or_color_name},
mood: {one_word_mood}.
```

#### Worked example (Indusia Merchant title slide)
```
prompt: A young Indonesian woman cashier at a food court counter in a Jakarta mall during late afternoon golden hour, warm directional sunlight from large skylight, medium-close-up at eye level with shallow depth of field on her hands operating a tablet POS terminal, editorial photography reminiscent of Magnum reportage style, warm color grading favoring deep navy and saturated orange brand accents, mood: confident-competent.
model: nano-banana-pro
aspect_ratio: 16:9
style: Photorealistic
output_format: png
resolution: 2K
```

#### Anti-pattern (DO NOT GENERATE)
```
A futuristic POS system in a modern setting with holographic UI floating in mid-air, purple-blue gradient background, abstract neural network in background, dynamic lighting.
```
*Why it fails:* zero specifics, all banned elements, generic AI-slop signals.

---

### SLIDE 2 — Problem

**Goal:** make the audience feel the pain physically. Visceral over informational.

#### Formula (Editorial — operator pain)
```
A {operator_role} in a state of {emotional_state} at {pain_environment} during {peak_pain_moment},
{lighting_creates_tension}, {camera_framing_emphasizes_isolation_or_overwhelm},
editorial photography style {reference_like_TIME_or_NYT}, slight motion blur for chaos,
muted desaturated palette except {one_accent_color_for_signal},
mood: {urgency_word}.
```

#### Worked example (Indusia problem slide — queue at peak)
```
prompt: An exhausted Indonesian female bazaar operator in her late 30s standing behind a counter during peak Saturday lunch rush at a Jakarta food bazaar, fluorescent overhead lighting creating harsh shadows, wide shot from low angle showing the long disorganized queue stretching out of frame, slight motion blur on customers gesturing impatiently, editorial photography reminiscent of TIME magazine reportage, muted desaturated palette except for one bright red "ERROR" message visible on the cracked POS screen in mid-frame, mood: overwhelm.
model: nano-banana-pro
aspect_ratio: 16:9
style: Editorial
output_format: png
resolution: 2K
```

---

### SLIDE 3 — Solution (before / after)

**Goal:** show the transformation in one frame. The audience must see the new world.

#### Formula (split-frame before/after)
```
Split-frame composition. Left half: {before_state — the pain visualized}. Right half: {after_state — the solution working}.
Subtle vertical divider. Same camera framing both halves to enable direct comparison.
{Lighting differs — left harsh / right warm to signal emotional shift}.
Same brand color palette throughout.
Style: Photorealistic editorial.
```

#### Worked example
```
prompt: Split-frame composition with subtle vertical divider. Left half: a chaotic disorganized food court counter under harsh fluorescent light with broken POS terminal, exhausted cashier, long queue. Right half: same counter under warm afternoon natural light with a clean tablet POS, calm cashier wearing wireless wristband reader, organized customer flow, three customers paying with closed-loop wristbands. Identical medium-wide camera angle both halves. Same brand color palette deep navy and saturated orange. Editorial photography style, mood: relief.
aspect_ratio: 16:9
style: Editorial
```

---

### SLIDE 4 — Why Now (VC mode) — specific shift

**Goal:** make the timing inevitable. The image shows a real-world signal that the world has changed.

#### Formula
```
A scene depicting {specific_macro_or_regulatory_or_technical_shift} happening visibly in {indonesian_setting},
documentary photography style, {real_news_photography_aesthetic},
labels in image: {one_specific_data_point_visible_in_environment}.
```

#### Worked example (BI-SNAP regulation as why-now)
```
prompt: A wide-angle photograph of a Bank Indonesia press conference podium with the BI-SNAP 2.0 regulation announcement visible on screen behind the speaker, official Indonesian government setting, formal lighting, documentary news-photography style, real journalists with cameras in foreground, the date "1 May 2026" visible on the digital display, mood: official inevitability.
aspect_ratio: 16:9
style: Editorial
```

---

### SLIDE 5 — Market (bottom-up math)

**Goal:** show the prize is large AND the math is honest. Use Infographic-flat style.

#### Formula
```
Clean infographic showing bottom-up market sizing.
3 nested rectangles or stacked bars showing TAM | SAM | SOM with concrete numbers in IDR.
Math labeled: "Customers × Price × Realistic share".
Single brand-color emphasis on SOM (the realistic capture).
Source line bottom: "Source: {actual_source}, {year}".
Sans-serif typography (Plus Jakarta Sans / Inter).
Off-white background, no gradients.
```

#### Worked example
```
prompt: Clean flat infographic on off-white background. Three nested horizontal bars from largest to smallest: top bar TAM "Rp 142 T — all Indonesian retail F&B 2026" in deep navy, middle bar SAM "Rp 28 T — bazaar / food court / event F&B segment" in lighter navy, bottom bar SOM "Rp 4.2 T — top 200 venues we can win in 36 months" in saturated orange brand color. Math caption below SOM: "200 venues × Rp 1.7 B GMV × 12% take rate = Rp 4.2 T". Source line: "Source: BI Statistik Pembayaran 2025 + internal venue analysis Q1 2026". Sans-serif Plus Jakarta Sans typography. No gradients. Mood: rigorous.
aspect_ratio: 16:9
style: Infographic-flat
```

---

### SLIDE 6 — Traction (line chart with one highlighted line)

**Goal:** prove demand. Single key metric, clean line chart, one accent color.

#### Formula
```
Clean line chart on off-white background.
Single line in brand-accent color showing {key_metric} growth over {time_period}.
Direct labels on the line at start and end (no legend).
Y-axis labeled "{metric}", X-axis "{time}".
One annotation arrow pointing to inflection point with verbal label.
Logo lockup of named partners along the bottom.
Source line: "Internal data, {month_year}".
```

#### Worked example
```
prompt: Clean line chart on off-white background. One bold orange line showing GMV processed per month from Jan 2024 to Apr 2026 — starting at "Rp 80 jt" labeled at the left endpoint and ending at "Rp 12 M" labeled at the right endpoint. Y-axis labeled "Monthly GMV processed" with values 0, 3M, 6M, 9M, 12M. X-axis labeled by month abbreviations. One annotation arrow at September 2025 pointing to the inflection with caption "First mall-wide pilot — Senayan City". Below the chart: a horizontal logo lockup of 6 partner logos (Senayan City, Kota Kasablanka, Lippo Mall Kemang, Pondok Indah Mall, BSD Junction, Plaza Indonesia). Source line bottom-right: "Internal data, April 2026". Sans-serif Plus Jakarta Sans. Mood: rigorous-credible.
aspect_ratio: 16:9
style: Infographic-flat
```

---

### SLIDE 7 — Business Model / ROI (B2B mode — operator P&L)

**Goal:** show money flows clearly. One slide. Sensitivity-aware.

#### Formula (B2B operator P&L table)
```
Clean business-model table on off-white background.
Two columns: "Without Indusia" vs "With Indusia".
Rows: Monthly GMV | Cash leakage | Insight cost | Total operator P&L delta.
Bottom: "Payback period: X months" in brand-accent color, large type.
Math footer: "Calculated on Rp X B GMV venue with Y% leakage typical".
```

#### Worked example
```
prompt: Clean two-column comparison table on off-white background. Header: "Operator Monthly P&L". Left column "Without Indusia" rows: GMV processed Rp 1.7 B, cash leakage 12% (Rp 204 jt), no booth-level insight (Rp 0 actionable), total P&L impact baseline. Right column "With Indusia" rows: GMV processed Rp 1.95 B (+15% wristband uplift), cash leakage 0.5% (Rp 9.7 jt), real-time booth insight enables Rp 60 jt menu mix optimization, total P&L impact +Rp 254 jt/month. Below table: large saturated orange callout "Payback: 2.4 months" at 64pt font. Math footer in 14pt: "Sensitivity: assumes Rp 1.7 B baseline GMV and 12% leakage typical for Jakarta food courts per BI 2025 study". Sans-serif typography. Mood: rigorous-honest.
aspect_ratio: 16:9
style: Infographic-flat
```

---

### SLIDE 8 — Moat (the 2026 weight slide)

**Goal:** answer "what happens when foundation model X ships?" with structural specifics.

#### Formula (4-quadrant moat matrix)
```
Clean 2x2 grid on off-white background.
Each quadrant labeled with one moat type and a one-line specific defense.
Bottom: callout box with the verbatim question: "What happens when GPT-5 ships?"
Below: one-line answer.
```

#### Worked example
```
prompt: Clean 2x2 grid on off-white background, four equal quadrants each with icon + label + one-line moat. Top-left: "Distribution" — BI license + 47 mall partnerships + 23 EO contracts not replicable from a model. Top-right: "Data" — per-venue per-tenant per-hour transactions + closed-loop wristband behavioral data, never in any public training corpus. Bottom-left: "Workflow" — PWA + IndexedDB offline-first POS, works without connection, foundation models cannot render offline. Bottom-right: "Hardware loop" — RFID wristbands close payment within venue, foundation model cannot operate physical hardware. Below grid: callout box in brand orange saying "When GPT-6 ships:" followed by one line "Foundation models become better text describers. None of our four moats reduce in value." Sans-serif Plus Jakarta Sans. Mood: confident-structural.
aspect_ratio: 16:9
style: Infographic-flat
```

---

### SLIDE 9 — Competition (2x2 with axes that flatter truthfully)

#### Formula
```
Clean 2x2 scatter on off-white.
X-axis label: {differentiator_1 — e.g. "Offline-first capability"}
Y-axis label: {differentiator_2 — e.g. "Closed-loop economics"}
Plot competitors honestly:
  - Indusia in top-right quadrant
  - Yukk somewhere mid-low
  - Midtrans / Xendit / DOKU as labeled dots
  - Square / Stripe as labeled dots in low-Y high-X (offline strong but no closed-loop)
Brand-color highlight on Indusia dot only.
Bottom source line.
```

---

### SLIDE 10 — Team (real photos, not avatars)

#### Formula
```
3-row layout. Each row: {founder_photo_300x300} {name + role} {ONE shipping credential — verb-led}
Photos are real (not AI-generated avatars), professional but not corporate-glossy.
Plain background or actual workspace.
Below: one-line "Advisors / key hires" with 3-5 logos.
```

> **Critical:** if real photos are unavailable, mark this slide for manual asset injection. NEVER generate AI faces for the team slide — investors detect immediately and the trust hit is fatal.

---

### SLIDE 11 — Ask (typography-first, no image)

The ask slide is typography-driven. Image generation is OPTIONAL and limited to:
- A subtle background texture (off-white paper grain, subtle Indonesian batik watermark at 3% opacity)
- A QR code placeholder (real QR rendered separately)

**Forbidden on the ask slide:**
- Any photo competing with the numbers
- Any decoration that obscures the typography
- A "Thank You" anywhere on the slide

---

## 4. Reference image patterns (when to use `file_urls`)

GeminiGen.AI accepts up to several reference images via `file_urls`. Use them for:

| Slide | Reference image |
|-------|-----------------|
| Title | Operator photo (real) — for face identity-lock |
| Problem | Actual venue photo — for environment fidelity |
| Solution | Actual product UI screenshot — for screen accuracy |
| Traction | Brand color swatch — for palette consistency |
| Team | Each founder's headshot — never generate faces from scratch |

> **The face-fidelity rule:** if the slide shows a specific person, ALWAYS pass their real photo as `file_urls`. Never describe them in text-only — AI generation will get features wrong and the deck reads as deepfake-amateur.

---

## 5. Cross-slide style consistency

To enforce visual coherence across all 11 slides:

1. Generate slide 1 first (the brand-anchor slide).
2. Capture the response `uuid`.
3. For slides 2–11, pass that uuid as `ref_history` parameter.
4. The model uses slide 1's color grading, lighting, and overall aesthetic as a style guide for the rest.

This eliminates the "every slide looks like a different stock library" problem.

---

## 6. The 5-question pre-flight check

Before submitting any prompt to GeminiGen.AI, answer all 5:

1. **Did I specify a SPECIFIC environment?** ("at the Senayan City food court counter" not "modern setting")
2. **Did I specify a subject identity?** ("Indonesian woman in her 30s in casual blazer" not "businessperson")
3. **Did I specify lighting?** ("late-afternoon golden hour, warm directional" not "good lighting")
4. **Did I specify camera framing?** ("medium-close-up at eye level, shallow depth of field" not "close shot")
5. **Did I avoid the cliché bank?** No purple gradients, no holographic UI, no light bulb, no handshake, no globe, no neural network blob, no abstract circuits.

If any answer is "no" or "I'm not sure," REWRITE THE PROMPT before sending. Each unspecified field is where the model defaults to AI-slop.

---

## 7. Output JSON schema (image-prompts.json)

The skill emits this for each generated slide:

```json
{
  "slide": 3,
  "slide_role": "solution",
  "visual_concept": "Split-frame before/after of food court counter — left chaos, right calm",
  "prompt": "Split-frame composition with subtle vertical divider. Left half: a chaotic disorganized food court counter...",
  "model": "nano-banana-pro",
  "aspect_ratio": "16:9",
  "style": "Editorial",
  "output_format": "png",
  "resolution": "2K",
  "file_urls": [],
  "ref_history": "img_<slide1_uuid>",
  "expected_filename": "slide-03-solution.png",
  "fallback_strategy": "If primary generation produces banned visual elements, regenerate once with explicit negative-prompt suffix; if still failing, flag for manual photography brief"
}
```

`pitch-deck-gen` writes one entry per slide in this schema; downstream tooling can submit each entry directly to GeminiGen.AI.
