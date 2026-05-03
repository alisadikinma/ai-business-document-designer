# Image Prompt Templates — GeminiGen.AI / Nano Banana Pro for Pitch Decks

> Use these templates ONLY after `visual-language.md` rules are internalized. Bad prompts produce AI-slop visuals that fail `pitch-deck-validate`.

> **Density mode is the most important decision.** Read `brief.json.density_mode` first.
> - `minimalist` (VC default) → use Photo formulas (slides 1–3 photo-led, charts elsewhere).
> - **`humanized-info-dense` (B2B partnership DEFAULT v8.1+) → use Formula C (Humanized Hybrid) per §2.5. 40% human face + 60% infographic per body slide. MANDATORY for slides 1-5. See Indusia POS case study referenced in §2.5.4.**
> - `info-dense` (legacy / opt-out only) → use Formula B (Infographic-flat). NO humans. Reserved for technical appendix or when operator explicitly opts out of humanization.
>
> Plugin defaults `humanized-info-dense` for `mode: b2b` and `hybrid` (changed from `info-dense` in v8.1). Operator must explicitly request `density_mode: "minimalist"` (VC) or `density_mode: "info-dense"` (no humans) to override.

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

## 2.5. Humanization Layer (validated v8.1 — DEFAULT for B2B partnership)

> **The single most important learning from Indusia POS × GO!Market deck (May 2026):** pure infographic body slides (no humans) consistently LOST at A/B selection. Humanized variants (40% face + 60% infographic) consistently WON. Pitch decks need to trigger emotion, not just transfer data. This section is mandatory reading before generating any body slide in `humanized-info-dense` mode.

### 2.5.1. The 40/60 Rule (HARD GATE)

Every body slide (typically slides 1-5 in a 10-13 slide deck) MUST allocate canvas as:
- **~40% canvas to a human face/character zone** (photographic or editorial portrait)
- **~60% canvas to infographic data zone** (bento cards, radial maps, layer flows, decision matrices)

Pure infographic slides (no humans) in body section = HARD FAIL at validate. Cover (slide 0) and CTA (slide N) follow separate Pattern B face-on-body composite rules — see §4.5.

### 2.5.2. Two layout patterns (operator chooses per slide OR generates both for A/B)

**Approach B — Split 40/60 side-by-side**
- LEFT 40% canvas: photographic/editorial character zone (mid-shot or waist-up portrait)
- RIGHT 60% canvas: existing infographic content (compressed slightly to fit)
- Subtle vertical fade between halves, no hard divider
- Character looks toward data side OR toward viewer (calls audience in)
- Best for: slides where character represents a SINGLE protagonist (operator, tenant, customer) and the data describes their world

**Approach C — Character Center + Data Radial**
- Character anchors center 35-45% of canvas
- Existing infographic data re-flows AROUND character as floating bento cards / radial labels
- Character becomes 'protagonist' of the data story
- Best for: slides with radial data structures (pain maps, decision matrices) OR when character literally represents the center of the data (e.g. "operator AT the helm of 4 AI decisions")

When in doubt, generate BOTH B and C variants per slide. Cost: 2× per slide at gen ($0.16 instead of $0.08). Saves rework if first pick misses.

### 2.5.3. Casting rules (NON-NEGOTIABLE for body slides)

1. **Generic LOCAL SME archetypes only** — match the deck's geographic context (Indonesian SMEs for Indonesian B2B; American small business owners for US B2B; etc.). NEVER generic Asian/Western stock-photo casting.
2. **NO real-face files attached for body slides** — only cover (slide 0) and CTA (slide N) attach real founder face files. Body slides generate fresh archetypes from text description.
3. **Age-locked adult, NEVER young/youthful/teen** — explicit "age 28-35 (adult lock)" or "in their late thirties" or "in their mid-forties" in prompt. NEVER use "young", "youthful", "fresh-faced" — those trigger MINOR_UPLOAD safety filters.
4. **NO duplicate character archetype across slides** — each slide gets a fresh archetype to avoid 'same person everywhere' uncanny valley.
5. **Expression must match emotional anchor** of the slide:
   - Hope / Pertemuan slide → hopeful, slight engaged smile, eye-contact pre-handshake
   - Overwhelm / Pain slide → tired-but-focused, internal weight, NOT looking at camera
   - Opportunity / Market slide → bustling crowd, candid documentary energy
   - Solution / Relief slide → focused mid-action, slight satisfied smile
   - Confidence / Co-pilot slide → confident-analytical, slight smile of recognition

### 2.5.4. The 3-layer iconography hierarchy (mandatory pairing with humans)

Every humanized body slide MUST contain THREE distinct visual layers that coexist:

1. **Human character zone** = emotional anchor (instant "this is for ME" recognition)
2. **Infographic icon zone** = scan-speed pictogram (instant category/concept recognition in <1 second)
3. **Data label / number zone** = substantive proof (rewards 5-second inspection)

Removing ANY layer breaks the slide. Human + data with NO icons = sterile. Icons + data with NO human = no emotion. Human + icons with NO data = decorative.

**Icon style locked**: flat geometric pictogram, single-color OR 2-color, 2-3px stroke, rounded-square or circular badges, brand-color tinted. NO 3D, NO gradients, NO emoji, NO photographic icons.

**Color logic** (apply consistently per deck, document in brand_palette):
- Orange (warm accent) = pain / tenant tooling / problem context
- Teal (primary) = solution / payment / core offering
- Blue-purple (secondary) = AI / data intelligence / strategic layer
- Red (warning) = alert / decline / risk

**Human-icon separation contract**: humans live in DEDICATED character zones, icons live INSIDE data cards. NEVER overlap or substitute.

### 2.5.5. TEXT RENDERING RULE template (CRITICAL — paste into every humanized prompt)

Nano Banana Pro will render layout markers and character descriptions as visible text on the slide unless explicitly forbidden. Every humanized prompt MUST include this directive near the top:

```
=== TEXT RENDERING RULE (CRITICAL) ===
Only render text strings that appear INSIDE single quotes ' ' below. Do NOT render any layout descriptions, zone names, percentage measurements, color hex codes, font names, point sizes, positioning words (top/middle/bottom/left/right), section headers, character labels, age annotations, ethnicity labels, archetype labels, or photo captions on the rendered image. The character portrait/vignette must have NO text overlay describing the character. Preserve special characters in brand names (like '!' in 'GO!MARKET') EXACTLY — never substitute with letters.
```

Validated bug pattern (Indusia POS deck): without this rule, model rendered "Generic Indonesian female F&B tenant ~25-32 years" as a caption ON the vignette. With this rule + restructured character descriptions in scene-direction language ("Show an Indonesian woman in her late twenties working at her food booth..."), captions disappeared.

### 2.5.6. Anti-caption-bleed character description pattern

❌ **BAD** (triggers caption-bleed):
```
Generate a photographic vignette of generic Indonesian female F&B tenant age 25-32 (adult lock), kaos + apron, holding smartphone shooting photo of plated dish.
```
The words "generic", "(adult lock)", "age 25-32", "F&B tenant" all read as label/caption descriptors to the model.

✅ **GOOD** (scene-direction language):
```
Show an Indonesian woman in her late twenties working at her food booth — kaos polos with light apron, hijab modest, leaning over the counter shooting a smartphone photo of a plated dish on the booth surface. Focused expression, mid-action, slight satisfied smile.
```
Natural narrative voice; age conveyed implicitly via "in her late twenties"; behavioral focus over categorical labels.

### 2.5.7. MINOR_UPLOAD safety mitigation (REQUIRED)

The most common safety filter trigger in pitch deck production. Every humanized prompt with venue references OR crowd scenes MUST include:

```
=== ABSOLUTE CONTENT RULE — NO MINORS ===
All figures must read as adult only. NO children, NO teenagers, NO minors, NO families with kids. Background figures rendered at less than 8% sharpness with abstract bokeh blur.
```

Per `safety-filter-playbook.md`: highest-risk combinations are (a) real-person face files attached + venue photo with crowd attached, (b) Indonesian flag + skyline + face files attached (triggers "identifiable public figures" filter — see Indusia POS Cover v2A failure case).

**Fallback pattern** (always include in `fallback_strategy` field): "If MINOR_UPLOAD triggers: drop venue references, render synthetic adult-only crowd from scratch. If still fails: drop face files, render with logos + text + atmosphere only, composite face badges manually."

### 2.5.8. Cover (slide 0) heritage costume + national flag pattern (validated v8.1)

For Indonesian / regional B2B partnership covers, Pattern B face-on-body composite with heritage costume + national flag in atmosphere is the validated DEFAULT (Indusia POS Cover v2B Constellation case study):

- Founders rendered in heritage wardrobe (Indonesian batik mega mendung blazer for Ali, kemeja batik tulis Sogan for Johari)
- Small national flag pin on lapel/collar of each founder
- National flag billowing in background atmosphere (upper-right, ~70-85% opacity)
- Hero text + brand colors as usual
- ALWAYS provide Pattern A fallback (face-as-badge, no body) in `fallback_strategy` for safety filter retry

Adapt to local context: batik (Indonesia), barong tagalog (Philippines), áo dài (Vietnam), kanga (East Africa), guayabera (Latin America), etc.

### 2.5.9. CTA (slide N) audience crowd witness pattern (validated v8.1)

For closing CTA, founders + audience-archetype crowd witnessing the partnership in soft-focus mid-ground transforms the slide from "2 people handshake" → "2 people committing to hundreds of [target audience] who are waiting" (Indusia POS Slide 09 v2 case study):

- Founders foreground in matching heritage costume (continuity from cover slide)
- Mid-ground: 8-12 adult target-audience archetypes in soft-focus (UMKM tenants for Indusia, mall operators for ChannelOps deck, etc.)
- Crowd at <8% sharpness with abstract bokeh — no recognizable individual faces
- Crowd expression: hopeful, attentive, expectant — "we are ready, waiting for you"
- Background bazaar/venue evening atmosphere with festoon lights
- Bottom 40% preserved as contact info card strip

### 2.5.10. Style anchor pair gate (modified for humanized mode)

In `humanized-info-dense` mode, generate slide 1 BOTH variants (Approach B + Approach C) FIRST as the style anchor pair. Surface to operator. Operator picks one approach OR keeps both (rare). Selected approach propagates `ref_history` to remaining body slides 2-5.

This differs from minimalist (slide 1 single variant) and pure info-dense (slide 0 single variant) anchor patterns.

### 2.5.11. Case study reference — Indusia POS × GO!Market deck (May 2026)

Validated humanized-info-dense pattern. 13 slides total, all selected variants archived at `D:\Projects\Indusia-POS\pitch-deck\assets\` (rejected variants at `assets\backup\`):

| Slide | Selected approach | Why it won vs rejected |
|-------|-------------------|------------------------|
| 00 Cover | v2B Constellation + batik + flag | Heritage costume + flag transformed slide from generic-tech to "this is OUR Indonesia" |
| 01 Foreshadow | Approach C (character-center + arrow column) | Characters AS the literal bridge metaphor stronger than side-by-side split |
| 02 The Gap | Approach B (split portrait + radial pain map) | Editorial portrait of overwhelmed operator + 9 radial pains landed harder than character-at-center |
| 03 Market Opp | Approach B (split crowd + bento) | Real-feeling Indonesian crowd left + 6 data cards right validated "this market is real, not abstract" |
| 04 Three-Layer | Approach C (embedded vignette per layer) | One human moment per layer (tenant shoot foto + visitor scan QR + operator review dashboard) made each layer concrete |
| 05 AI Brain Action | Approach C ("AT THE HELM" + 4 corner cards) | Operator at center with 4 decisions floating around her = co-pilot metaphor literalized |
| 09 CTA | Handshake + UMKM crowd witness + flag pins | Crowd of waiting tenants behind handshake transformed "deal" → "commitment to ecosystem" |

Pure infographic v2 variants (no humans) for slides 1-5 all rejected at `assets\backup\`. Cover v1 (no batik, no flag) also rejected. CTA v1 (no crowd) also rejected.

---

## 3. Per-slide-type prompt formulas

> **CRITICAL — density mode determines default style.** Read `brief.json.density_mode` BEFORE picking a formula.
> - `density_mode: "minimalist"` → use **Formula A (Photo)** for slides 1–3.
> - `density_mode: "info-dense"` → use **Formula B (Infographic)** for slides 0–3 + 5–8. Photo reserved for team slide only.

---

### SLIDE 0 — Cover / Brand-anchor (info-dense default for B2B partnership pitches)

**Goal:** plant brand identity + decision deadline + dual-stakeholder framing in 4 seconds. Cover is NOT a single hero photo — it's the deck's brand-anchor composition with logo lockup, hero typography, founder presence (when faces available), atmospheric background, and decision context. **This slide poisons every other slide via `ref_history` if it's bad — quality-gate before propagating.**

#### Composition zones (mandatory all 6)

```
┌──────────────────────────────────────────────────────────┐
│  TOP STRIP 8–12% — logo lockup + decision deadline pill  │
│  HERO ZONE 50–60% LEFT — typography + tagline + 3 pills  │
│  RIGHT STRIP 30–35% — founder badge cards (when faces)   │
│  BOTTOM STRIP 5–8% — context / partnership thesis line   │
│  Atmospheric bg — synthetic venue/industry shot          │
│  Brand palette enforced — every zone uses declared hex   │
└──────────────────────────────────────────────────────────┘
```

#### Formula (Cover · Info-dense · partnership)
```
Pitch deck COVER slide (slide 0), 16:9 cinematic environmental cover. Premium emotional opener.

REFERENCE IMAGES ATTACHED:
- {logo_a_filename} → {Brand A} brand lockup. PRESERVE EXACTLY.
- {logo_b_filename} → {Brand B / Partner} brand lockup. PRESERVE EXACTLY.
- {founder_a_face_file} → Real headshot of {Founder A name + role}. USE STRICTLY as a circular portrait BADGE INSERT (faces-only). DO NOT generate body or full figure.
- {founder_b_face_file} → Real headshot of {Founder B name + role}. USE STRICTLY as a circular portrait BADGE INSERT (faces-only). DO NOT generate body or full figure.

FULL-SLIDE BACKGROUND — synthetic atmospheric environment (generate fresh, NO real event photo attached to dodge MINOR_UPLOAD safety filter):
{environment_descriptor — e.g. "evening pop-up market bazaar", "Jakarta mall food court", "trade show floor"} with soft-focus warm tents/booths/displays in muted {brand_palette.primary} / {brand_palette.background} / {brand_palette.accent} tones, abstract warm string-light bokeh creating golden glow points, dark soft-blurred deep-background shapes (NO recognizable people, NO minors, only abstract distant silhouettes far in background depth at <8% sharpness). Color grade: {brand_palette.accent} + {brand_palette.primary} + {brand_palette.ink}. Heavy depth-of-field blur, magazine cinematography. Soft dark gradient top (40% black fading to 0% at 30% slide height) + bottom (30% black fading to 0%) for text legibility.

TOP STRIP (10% slide height): Lockup composition using TWO ATTACHED LOGO FILES centered horizontally separated by × symbol. White rounded pill card with subtle drop shadow ~360px wide. Below logo, label (Plus Jakarta Sans Regular 11pt italic light cream): "{event_or_pitch_context} · {pitch_date} · Decision Deadline {deadline_date}"

LEFT-CENTER 55% — HERO EMOTIONAL TYPOGRAPHY (left-aligned, vertically centered, white text with subtle dark drop shadow):
Line 1 (Plus Jakarta Sans Bold 44pt white): "{hero_line_1}"
Line 2 (Bold 96pt {brand_palette.accent} with subtle white outline glow): "{hero_word_2}"
Line 3 (Bold 96pt {brand_palette.primary} with subtle white outline glow): "{hero_word_3}."
Decorative {brand_palette.accent} divider line (5px thick 220px wide left-aligned).
Mission statement (Regular 24pt white): "{mission_one_sentence}"
Sub-tagline (Italic 16pt light cream): "{partnership_thesis_one_sentence}"
Three pill labels below (white bg, ink text 11pt Bold side-by-side 8px gap): "{pill_1}" · "{pill_2}" · "{pill_3}"

RIGHT 35% — FOUNDER BADGE CARDS (vertically stacked right-aligned, when faces available):
BADGE 1 TOP — {brand_palette.primary} rounded card ~340px×200px white text drop shadow. Inside: {founder_a_face_file} as 140px circular crop with 5px white border. Right side text: Name Bold 22pt "{founder_a_name}" / Role 12pt "{founder_a_role}" / Tagline 10pt italic "{founder_a_credential}".
BADGE 2 BOTTOM (16px gap) — {brand_palette.accent} rounded card. Inside: {founder_b_face_file} as 140px circular crop white border. Right side text: Name Bold 22pt "{founder_b_name}" / Role 12pt "{founder_b_role}" / Tagline 10pt italic "{founder_b_credential}".

BOTTOM STRIP (5% slide height dark gradient): footer text 10pt italic light cream centered: "{deck_context_one_line}"

Style: Premium cinematic pitch deck cover. Atmospheric synthetic background + bold emotional hero text + prominent founder portrait badges. Reference: TED-talk environmental cover + premium business documentary still.
```

#### Anti-deviation phrases (REQUIRED in every cover prompt with face refs)
```
"USE STRICTLY as a circular portrait BADGE INSERT (faces-only). DO NOT generate body or full figure."
"PRESERVE EXACTLY — do not redesign or stylize."
"NEVER synthesize or alter facial features."
```

#### Fallback ladder (per `safety-filter-playbook.md`)
```
1. MINOR_UPLOAD safety filter triggers → drop face attachments, render with logos + text + atmosphere only. Composite face badges in Canva.
2. Logos render distorted → drop logos, render text + atmosphere only. Composite logos in Canva.
3. Atmosphere becomes literal/people-rich → re-prompt with "<8% sharpness for distant figures, abstract bokeh only".
```

---

### SLIDE 1 — Title / Vision (or Foreshadow in info-dense decks)

**Goal:** in minimalist mode → place the company on a known shelf in 4 seconds via single hero. In info-dense mode → bridge cover (slide 0) to body slides via dual-stakeholder framing.

#### Formula A — Minimalist (Photorealistic single hero, VC mode default)
```
A {hero_subject} {hero_action} at {specific_indonesian_venue} during {time_of_day},
{lighting_quality} light, {camera_framing}, shallow depth of field,
editorial photography style reminiscent of {photography_reference},
warm color grading favoring {brand_palette.primary} and {brand_palette.accent},
mood: {one_word_mood}.
```

#### Worked example A (minimalist VC)
```
prompt: A young Indonesian woman cashier at a food court counter in a Jakarta mall during late afternoon golden hour, warm directional sunlight from large skylight, medium-close-up at eye level with shallow depth of field on her hands operating a tablet POS terminal, editorial photography reminiscent of Magnum reportage style, warm color grading favoring #0F1F3D primary and #F25C24 accent, mood: confident-competent.
model: nano-banana-pro
aspect_ratio: 16:9
style: Photorealistic
output_format: png
resolution: 2K
```

#### Formula B — Info-dense Foreshadow / Bridge slide (B2B partnership default)
```
Pitch deck FORESHADOW slide (positioned between cover slide and body). 16:9 {brand_palette.background} background. Sets up dual-stakeholder bridge thesis.

TOP 18% — TITLE STRIP:
Slide title (Plus Jakarta Sans Bold 52pt {brand_palette.ink} centered): "{bridge_thesis_headline}"
Subtitle (20pt italic regular gray #4A5568 centered): "{both_sides_meet_subtitle}"

MIDDLE 60% — TWO-SIDE BRIDGE FRAMING (3-panel horizontal):

LEFT PANEL 35% ({brand_palette.secondary} background white text rounded card):
- Top icon area: Stylized icon — {stakeholder_a_visual_metaphor}. White outlined flat illustration.
- Header (Bold 24pt white): "{stakeholder_a_label}"
- Sub-header (16pt italic): "{stakeholder_a_essence_one_line}"
- 3 pain bullets (white 13pt with red ❌):
  ❌ {stakeholder_a_pain_1}
  ❌ {stakeholder_a_pain_2}
  ❌ {stakeholder_a_pain_3}
- Bottom callout (white bg secondary text Bold 14pt rounded): "{stakeholder_a_what_they_need}"

CENTER PANEL 30% ({brand_palette.background} bg with strong vertical visual):
- Top header (Bold 20pt {brand_palette.accent} centered): "{bridge_label}"
- Visual: large vertical arrow icon flowing top to bottom ({brand_palette.accent} thick 16px) with text labels at top tip / middle / bottom tail.
- Below arrow central icon: hexagonal {brand_palette.primary} logo placeholder with white "{brand_initial}" letterform.
- Below logo callout ({brand_palette.primary} bg white Bold 14pt rounded): "{three_layer_summary}"

RIGHT PANEL 35% ({brand_palette.accent} background white text rounded card):
- Top icon area: Stylized icon — {stakeholder_b_visual_metaphor}.
- Header (Bold 24pt white): "{stakeholder_b_label}"
- Sub-header (16pt italic): "{stakeholder_b_essence_one_line}"
- 3 pain bullets (white 13pt with red ❌):
  ❌ {stakeholder_b_pain_1}
  ❌ {stakeholder_b_pain_2}
  ❌ {stakeholder_b_pain_3}
- Bottom callout (white bg accent Bold 14pt rounded): "{stakeholder_b_what_they_need}"

BOTTOM 22% — THESIS CALLOUT STRIP:
Full-width {brand_palette.ink} background card white text:
- Header (Bold 22pt centered): "{commitment_to_prove}"
- Sub-header (14pt italic centered): "{N_slide_journey_preview}"

FOOTER source line (10pt italic gray): "{slide_role_label}"

Style: Foreshadow / bridge slide. Dual-stakeholder framing with central brand bridge. Business-grade infographic. NO photos. Pure flat design with icons.
```

#### Anti-pattern (DO NOT GENERATE — both modes)
```
A futuristic POS system in a modern setting with holographic UI floating in mid-air, purple-blue gradient background, abstract neural network in background, dynamic lighting.
```
*Why it fails:* zero specifics, all banned elements, generic AI-slop signals.

---

### SLIDE 2 — Problem

**Goal:** in minimalist mode → make the audience feel the pain physically (visceral photo). In info-dense mode → quantify the pain via radial pain map with N concrete points around a central anchor.

#### Formula A — Minimalist (Editorial photo of operator pain, VC mode)
```
A {operator_role} in a state of {emotional_state} at {pain_environment} during {peak_pain_moment},
{lighting_creates_tension}, {camera_framing_emphasizes_isolation_or_overwhelm},
editorial photography style {reference_like_TIME_or_NYT}, slight motion blur for chaos,
muted desaturated palette except {one_accent_color_for_signal},
mood: {urgency_word}.
```

#### Worked example A (minimalist VC)
```
prompt: An exhausted Indonesian female bazaar operator in her late 30s standing behind a counter during peak Saturday lunch rush at a Jakarta food bazaar, fluorescent overhead lighting creating harsh shadows, wide shot from low angle showing the long disorganized queue stretching out of frame, slight motion blur on customers gesturing impatiently, editorial photography reminiscent of TIME magazine reportage, muted desaturated palette except for one bright red "ERROR" message visible on the cracked POS screen in mid-frame, mood: overwhelm.
model: nano-banana-pro
aspect_ratio: 16:9
style: Editorial
```

#### Formula B — Info-dense Radial Pain Map (B2B partnership default)
```
Center-radial info-dense pitch deck slide 16:9 {brand_palette.background} background.

CENTER (40% slide width centered):
Hexagonal solid {brand_palette.primary} shape with white text 3 lines:
Line 1 (Plus Jakarta Sans Bold 22pt): "{anchor_label}"
Line 2 (Bold 32pt): "{quantified_anchor_metric}"
Line 3 (Regular 18pt): "{anchor_implication}"

UPPER HALF — {N_stakeholder_a} {stakeholder_a} PAIN LABELS ({brand_palette.accent} cards arranged as fan/radial above center):
Each card: red ❌ icon left + bold label + small explanatory text below.
Card 1: "❌ {pain_a_1_short}" / "{pain_a_1_explainer}"
Card 2: "❌ {pain_a_2_short}" / "{pain_a_2_explainer}"
... (up to 5 cards)

LOWER HALF — {N_stakeholder_b} {stakeholder_b} PAIN LABELS ({brand_palette.secondary} cards arranged as fan below center):
Card N+1: "❌ {pain_b_1_short}" / "{pain_b_1_explainer}"
... (up to 4 cards)

Connection lines (thin gray #94A3B8) from center hexagon radiating to each pain card.

SLIDE TITLE (top-left Plus Jakarta Sans Bold 48pt {brand_palette.ink}): "{quantified_pain_total_headline}"
Subtitle (20pt gray #4A5568): "{baseline_solution_inadequate_subtitle}"

FRESHNESS BADGE (top-right {brand_palette.primary} pill white Bold 11pt): "DATA UPDATED · {month_year}"

BOTTOM source line (10pt italic gray multi-line): "Source: {source_1} · {source_2} · {source_3}"

Style: Clean infographic radial layout label-rich structured cards. NO photographs NO 3D. Pure flat design.
```

---

### SLIDE 3 — Solution / Architecture

**Goal:** in minimalist mode → show transformation as before/after photo. In info-dense mode → show layered architecture as horizontal-band flow with input → process → output per band.

#### Formula A — Minimalist (split-frame photo, VC mode)
```
Split-frame composition. Left half: {before_state — the pain visualized}. Right half: {after_state — the solution working}.
Subtle vertical divider. Same camera framing both halves to enable direct comparison.
{Lighting differs — left harsh / right warm to signal emotional shift}.
Same brand color palette throughout.
Style: Photorealistic editorial.
```

#### Worked example A (minimalist VC)
```
prompt: Split-frame composition with subtle vertical divider. Left half: a chaotic disorganized food court counter under harsh fluorescent light with broken POS terminal, exhausted cashier, long queue. Right half: same counter under warm afternoon natural light with a clean tablet POS, calm cashier wearing wireless wristband reader, organized customer flow. Identical medium-wide camera angle both halves. Same brand color palette deep navy and saturated orange. Editorial photography style, mood: relief.
aspect_ratio: 16:9
style: Editorial
```

#### Formula B — Info-dense Horizontal-band Flow (B2B partnership default)
```
Horizontal 3-band flow diagram pitch deck slide 16:9 {brand_palette.background} background.

LAYOUT: Three full-width horizontal bands stacked vertically, each band 28-34% slide height. Each band shows flow diagram from left (input) → middle (process) → right (output cards).

BAND 1 ({brand_palette.accent} top, height 28%):
Header label (left white Plus Jakarta Sans Bold 24pt): "{layer_1_label}"
LEFT INPUT (left 15%): icon + label below white "INPUT: {layer_1_input}"
ARROW → (white)
RIGHT OUTPUT (right 70%): N small white cards horizontally:
- {output_1_icon} + "{output_1_label} · {output_1_price_or_metric}"
- {output_2_icon} + "{output_2_label} · {output_2_price_or_metric}"
- ... (up to 4)
Bottom strip label (white): "{layer_1_pricing_or_summary}"

BAND 2 ({brand_palette.primary} middle, height 28%):
[same structure as Band 1 with layer_2 fields]

BAND 3 ({brand_palette.secondary} bottom, height 34% — slightly thicker for emphasis):
Header (left white Bold 28pt): "{layer_3_label}"
SUB-LABEL (white 14pt italic): "{layer_3_differentiator_one_line}"
[input → output as above]
Bottom strip (white): "{layer_3_strategic_summary}"

SLIDE TITLE (top-left Plus Jakarta Sans Bold 48pt {brand_palette.ink}): "{architecture_one_sentence_headline}"
Subtitle (20pt gray): "{baseline_vs_us_subtitle}"

BOTTOM source line (10pt italic gray): "Source: {source_1} · {source_2}"

Style: clean horizontal info-dense flow diagram label-rich structured bands. NO photos. Reference: industrial value-chain diagram style.
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

**Goal:** show the prize is large AND the math is honest.

#### Formula A — Minimalist TAM/SAM/SOM (VC mode)
```
Clean infographic showing bottom-up market sizing.
3 nested rectangles or stacked bars showing TAM | SAM | SOM with concrete numbers in IDR.
Math labeled: "Customers × Price × Realistic share".
Single brand-color emphasis on SOM (the realistic capture).
Source line bottom: "Source: {actual_source}, {year}".
Sans-serif typography (Plus Jakarta Sans / Inter).
Off-white background, no gradients.
```

#### Worked example A
```
prompt: Clean flat infographic on off-white background. Three nested horizontal bars from largest to smallest: top bar TAM "Rp 142 T — all Indonesian retail F&B 2026" in deep navy, middle bar SAM "Rp 28 T — bazaar / food court / event F&B segment" in lighter navy, bottom bar SOM "Rp 4.2 T — top 200 venues we can win in 36 months" in saturated orange brand color. Math caption below SOM: "200 venues × Rp 1.7 B GMV × 12% take rate = Rp 4.2 T". Source line: "Source: BI Statistik Pembayaran 2025 + internal venue analysis Q1 2026". Sans-serif Plus Jakarta Sans typography. No gradients. Mood: rigorous.
aspect_ratio: 16:9
style: Infographic-flat
```

#### Formula B — Info-dense Hero-Stat Grid + Match Framing (B2B partnership default)
```
Pitch deck slide Market Opportunity 16:9 {brand_palette.background} background. Show GIANT market with refreshed data + dual-stakeholder MATCH framing.

TOP 15% — TITLE STRIP:
Slide title (Plus Jakarta Sans Bold 48pt {brand_palette.ink}): "{market_grab_one_sentence}"
Subtitle (20pt regular gray): "{market_size_plus_adoption_gap_subtitle}"
FRESHNESS BADGE (top-right {brand_palette.primary} pill white Bold 11pt): "DATA REFRESHED · {month_year}"

MIDDLE 50% — HERO STATS GRID (6 big stat cards in 2 rows × 3 columns, white card backgrounds with strong colored accent stripes):

ROW 1:
Card 1 ({brand_palette.primary} left accent): Big number Bold 64pt primary "{stat_1_value}" / Label "{stat_1_label}" / Sub "{stat_1_explainer}" / Source italic 9pt: "{stat_1_source}"
Card 2 ({brand_palette.accent} left accent): Big 64pt accent "{stat_2_value}" / "{stat_2_label}" / "{stat_2_explainer}" / Source: "{stat_2_source}"
Card 3 ({brand_palette.warning} left accent): Big 64pt warning "{stat_3_value}" / "{stat_3_label}" / "{stat_3_explainer}" / Source: "{stat_3_source}"

ROW 2:
Card 4 ({brand_palette.secondary} left accent): "{stat_4_value}" / "{stat_4_label}" / "{stat_4_explainer}" / Source: "{stat_4_source}"
Card 5 ({brand_palette.primary} left accent): "{stat_5_value}" / "{stat_5_label}" / "{stat_5_explainer}" / Source: "{stat_5_source}"
Card 6 ({brand_palette.accent} left accent): "{stat_6_value}" / "{stat_6_label}" / "{stat_6_explainer}" / Source: "{stat_6_source}"

BOTTOM 30% — THE MATCH FRAMING (3-panel horizontal):

LEFT PANEL 35% ({brand_palette.primary} bg white text rounded card):
- Header (Bold 22pt): "{stakeholder_a_label}"
- Sub-header (14pt italic): "{stakeholder_a_essence}"
- 4 bullet rows (white ✓ 11pt): {stakeholder_a_strength_1} / 2 / 3 / 4

CENTER PANEL 12% ({brand_palette.background}):
Giant 80pt {brand_palette.ink}: "="
Below (16pt italic): "MATCH"
Below (10pt gray italic): "perfect collaboration"

RIGHT PANEL 35% ({brand_palette.accent} white text rounded card):
- Header (Bold 22pt): "{stakeholder_b_label}"
- Sub-header (14pt italic): "{stakeholder_b_essence}"
- 4 bullet rows (white ✓ 11pt): {stakeholder_b_strength_1} / 2 / 3 / 4

FOOTNOTE strip (full-width {brand_palette.ink} white Bold 14pt centered): "{combined_market_thesis_one_sentence}"

FOOTER source (9pt italic gray multi-line): "Sources {month_year}: {source_1} · {source_2} · {source_3}"

Style: Info-dense market opportunity infographic. Hero stats grid + match framing. Business-grade data visualization. NO photos.
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

### SLIDE 7 — Business Model / ROI

**Goal:** show money flows clearly. One slide. Sensitivity-aware.

#### Formula A — Minimalist Operator P&L Table (B2B VC mode)
```
Clean business-model table on off-white background.
Two columns: "Without Indusia" vs "With Indusia".
Rows: Monthly GMV | Cash leakage | Insight cost | Total operator P&L delta.
Bottom: "Payback period: X months" in brand-accent color, large type.
Math footer: "Calculated on Rp X B GMV venue with Y% leakage typical".
```

#### Worked example A
```
prompt: Clean two-column comparison table on off-white background. Header: "Operator Monthly P&L". Left column "Without Indusia" rows: GMV processed Rp 1.7 B, cash leakage 12% (Rp 204 jt), no booth-level insight (Rp 0 actionable), total P&L impact baseline. Right column "With Indusia" rows: GMV processed Rp 1.95 B (+15% wristband uplift), cash leakage 0.5% (Rp 9.7 jt), real-time booth insight enables Rp 60 jt menu mix optimization, total P&L impact +Rp 254 jt/month. Below table: large saturated orange callout "Payback: 2.4 months" at 64pt font. Math footer in 14pt: "Sensitivity: assumes Rp 1.7 B baseline GMV and 12% leakage typical for Jakarta food courts per BI 2025 study". Sans-serif typography. Mood: rigorous-honest.
aspect_ratio: 16:9
style: Infographic-flat
```

#### Formula B — Info-dense 3-Layer Revenue Waterfall (B2B partnership default)

**When to use:** ecosystem revenue with explicit dual-stakeholder split (e.g. partner share vs platform share). Use when the deck must defend the math under DD with per-source citations and show both sides who gets what.

```
Pitch deck slide The Money 16:9 {brand_palette.background} background. Hero number + 3-layer waterfall + per-stakeholder split.

TOP 25% — HERO ECOSYSTEM HEADER:
Left 50% ({brand_palette.background}): label (Bold 18pt gray) "TOTAL ECOSYSTEM REVENUE / TAHUN" + massive hero number (Bold 110pt {brand_palette.ink}) "{ecosystem_total_range}" + sub-label (16pt italic gray) "{conservative_mid_aggressive_caption}".
Right 50% (split visualization, 2 vertical bars side-by-side):
- Bar A ({brand_palette.primary} fill 50% height, white text): top label Bold 14pt "{stakeholder_a_label} SHARE" + big number Bold 36pt "{stakeholder_a_share_range}" + sub 12pt "{stakeholder_a_split_pct} ekosistem · {stakeholder_a_revenue_type}".
- Bar B ({brand_palette.accent} fill 50% height, white text): top label Bold 14pt "{stakeholder_b_label} SHARE" + big number Bold 36pt "{stakeholder_b_share_range}" + sub 12pt "{stakeholder_b_split_pct} ekosistem · {stakeholder_b_revenue_type}".

MIDDLE 55% — 3-LAYER MATH BREAKDOWN (full-width vertical stack of 3 transparent rows):

LAYER 1 ROW ({brand_palette.primary} left header band, white background body):
- Left header (white on primary Bold 18pt): "LAYER 1 / {layer_1_label}"
- 4-column flow: TARIFF "{layer_1_tariff}" / Source "{layer_1_tariff_source}" → ECOSYSTEM "{layer_1_ecosystem_range}" / Math "{layer_1_math}" → SPLIT "{layer_1_split_pct}" → STAKEHOLDER A "{layer_1_a_share}" + STAKEHOLDER B "{layer_1_b_share}"

LAYER 2 ROW ({brand_palette.accent} left header band — emphasis, slightly thicker):
- Left header (white on accent Bold 18pt): "LAYER 2 / {layer_2_label}"
- [same 4-column structure with layer_2 fields]

LAYER 3 ROW ({brand_palette.secondary} left header band):
- Left header: "LAYER 3 / {layer_3_label}"
- [same 4-column structure with layer_3 fields]

TOTAL ROW ({brand_palette.ink} bg, white Bold text):
- Left label (Bold 16pt): "TOTAL TO STAKEHOLDERS"
- 3 split totals: STAKEHOLDER A 3-scenario · STAKEHOLDER B 3-scenario · TOTAL ECOSYSTEM 3-scenario

BOTTOM 20% — VS STATUS QUO COMPARISON STRIP (3 horizontal cards):
CARD 1 ({brand_palette.warning} outline): "{baseline_competitor_label}" — N ❌ rows showing what they don't deliver.
CARD 2 ({brand_palette.primary} outline): "{your_solution_label}" — N ✓ rows showing what you deliver.
CARD 3 ({brand_palette.accent} outline): "DELTA (Net New)" — explicit delta callouts.

SOURCE LINE bottom (8pt italic gray multi-line): "Sources: {source_1} · {source_2} · {source_3} · {source_4}"

SLIDE TITLE (top Plus Jakarta Sans Bold 36pt {brand_palette.ink}): "{ecosystem_total_one_sentence_headline}"
Subtitle (16pt gray): "{defensible_math_disclaimer}"

Style: Info-dense financial transparency infographic. McKinsey/BCG-style executive split-revenue dashboard. CLEAR DELINEATION between ecosystem total + stakeholder A share + stakeholder B share. NO photos.
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

### SLIDE N — Closing CTA / Handshake composite (info-dense partnership decks)

**Goal:** the LAST slide stays on screen 30+ seconds during Q&A — use that real estate for sahabat-grade emotional close + dual contact details + decision-deadline pill. NEVER "Thank You". Combines hero composite photograph (founders shaking hands at synthetic venue atmosphere) + contact card strip below.

#### Composition zones (mandatory all 5)
```
┌──────────────────────────────────────────────────────────┐
│  HERO COMPOSITE 60% TOP — handshake photo + overlays     │
│   • Founders A + B shaking hands, bodies visible (chest- │
│     to-thigh framing), faces match attached photos       │
│   • Top-left overlay: hero CTA typography                │
│   • Top-right overlay: logo lockup pill                  │
│   • Bottom-center overlay: decision deadline pill        │
│  CONTACT STRIP 40% BOTTOM                                │
│   • Two side-by-side cards (Founder A primary | B accent)│
│   • Avatar 64px + name + role + WhatsApp + socials       │
│  FOOTER STRIP 3%                                         │
│   • Partnership tagline + next-step CTA                  │
└──────────────────────────────────────────────────────────┘
```

#### Formula (CTA · composite · partnership)
```
Pitch deck CLOSING CTA slide (slide N), 16:9. Hero composite handshake photograph + contact info strip below.

REFERENCE IMAGES ATTACHED (mandatory — preserve facial identity exactly):
- {founder_a_face_file} → Real photograph of {Founder A name + age + features}. Use this EXACT face on Founder A's body in the composite.
- {founder_b_face_file} → Real photograph of {Founder B name + age + features}. Use this EXACT face on Founder B's body in the composite.
- {logo_a_filename} → Brand A lockup. PRESERVE EXACTLY.
- {logo_b_filename} → Brand B / Partner lockup. PRESERVE EXACTLY.

TOP 60% — HERO HANDSHAKE PHOTOGRAPH (full-bleed cinematic):
Generate a cinematic environmental composite photograph (medium-wide shot framing chest-up to mid-thigh visible both subjects facing camera at slight 3/4 angles leaning slightly toward each other) showing TWO ADULT BUSINESSMEN/WOMEN standing side-by-side and shaking hands warmly in the foreground.

LEFT SUBJECT — {Founder A} (use face from attached {founder_a_face_file} exactly): {founder_a_age_descriptor + attire_descriptor + posture}. Right hand extended forward in handshake gripping {Founder B}'s right hand. Body angled toward {Founder B} at slight 3/4 turn to camera looking warmly at {Founder B} with confident sincere smile. Posture: relaxed shoulders professional businessman/woman stance.

RIGHT SUBJECT — {Founder B} (use face from attached {founder_b_face_file} exactly): {founder_b_age_descriptor + attire_descriptor + posture}. Right hand extended forward in handshake gripping {Founder A}'s right hand. Body angled toward {Founder A} at slight 3/4 turn to camera looking warmly at {Founder A} with friendly genuine smile.

The handshake itself is the visual anchor: hands clasped at center frame arms forming horizontal line. Both subjects smiling at each other (not at camera) — sahabat + business partner imagery warm and authentic.

FRAMING: medium-wide shot both subjects from chest-up to mid-thigh visible equal prominence (50/50 split) occupying central 60% horizontally. NOT full-figure NOT minors NOT children — both clearly ADULT PROFESSIONAL in business attire.

BACKGROUND BEHIND THEM (synthetic atmosphere — generate fresh, no event photo attached): {environment_descriptor — e.g. evening pop-up market, mall food court, trade show floor} setting soft-focus warm tents/booths and string-light bokeh creating warm {brand_palette.accent} + amber glow points blurred deep-background silhouettes (NO recognizable people NO minors only abstract distant silhouettes far in depth at <8% sharpness). Color palette {brand_palette.accent} + {brand_palette.primary} + {brand_palette.ink} backdrop tones. Heavy depth-of-field blur (f/2.0 feel). Subjects sharp foreground environment soft. Soft golden-hour lighting from upper-left key + gentle {brand_palette.primary} rim light from behind.

TOP-LEFT corner OVERLAY (text on photo with subtle dark drop shadow): Plus Jakarta Sans Bold 44pt white: "{cta_emotional_headline}"
Directly below (Regular 18pt italic light cream): "{partnership_tagline}"

TOP-RIGHT corner OVERLAY (white pill card with subtle drop shadow): Lockup using TWO ATTACHED LOGO FILES side-by-side separated by × symbol.

BOTTOM-CENTER OVERLAY on hero photo ({brand_palette.ink} rounded pill ~480px wide centered white Bold 16pt): "⏱ DECISION DEADLINE · {deadline_date}"

BOTTOM 40% — CONTACT INFO STRIP ({brand_palette.background} solid bg two contact cards side-by-side 50/50 split + center divider):

LEFT CARD 48% ({brand_palette.primary} rounded card 24px radius white text drop shadow 24px padding):
- Top row: small circular avatar 64px diameter using {founder_a_face_file} 4px white border (RIGHT side of card)
- Name (Bold 26pt white): "{founder_a_name}"
- Role (Bold 13pt): "{founder_a_role}"
- Divider (white 1px 80% width)
- Contact rows (white 13pt 8px row gap each prefixed by small flat icon):
  Row 1 — globe icon · Web: {founder_a_web}
  Row 2 — Instagram icon · IG: {founder_a_ig}
  Row 3 — LinkedIn icon · LinkedIn: {founder_a_linkedin}
  Row 4 — WhatsApp green icon · WA: {founder_a_wa} (Bold 16pt emphasized)

CENTER DIVIDER (1px wide vertical gray line full height with 'PARTNERSHIP' label centered vertically {brand_palette.accent} pill).

RIGHT CARD 48% ({brand_palette.accent} rounded card 24px radius white text drop shadow 24px padding):
- Top row: small circular avatar 64px diameter using {founder_b_face_file} 4px white border
- Name (Bold 26pt white): "{founder_b_name}"
- Role (Bold 13pt): "{founder_b_role}"
- Divider (white 1px 80% width)
- Contact rows (white 13pt 8px row gap):
  Row 1 — WhatsApp green icon · WA: {founder_b_wa} (Bold 16pt emphasized)
  Row 2 — small 11pt italic: "{founder_b_pic_role_1}"
  Row 3 — small 11pt italic: "{founder_b_pic_role_2}"

FOOTER STRIP (3% slide height {brand_palette.ink} bg white Bold 11pt italic centered): "{partnership_lockup} · {next_step_cta} · {contact_email}"

Style: Premium B2B closing CTA slide. Cinematic environmental handshake photograph hero (REAL composite NOT iconographic). Both faces MUST match attached reference photos exactly. Both subjects CLEARLY ADULT PROFESSIONAL in formal-casual attire. Medium-wide framing (chest to thigh).
```

#### Anti-deviation phrases (REQUIRED in every CTA prompt with face refs)
```
"USE THIS EXACT FACE on {Founder A}'s body in the composite."
"PRESERVE facial identity precisely. NEVER synthesize or alter facial features."
"Both subjects CLEARLY ADULT PROFESSIONAL — NOT minors NOT children."
"Medium-wide framing (chest-up to mid-thigh) — NOT full-figure."
```

#### Fallback ladder
```
1. MINOR_UPLOAD safety filter triggers on Founder B → re-attempt without Founder B face attachment, composite manually in Canva.
2. Both faces trigger filter → drop both face attachments, generate generic businessmen handshake composite, both faces composited in Canva.
3. Persistent failure → revert to iconographic handshake (no real composite) with manual_asset_required=true.
```

---

## 4. Reference image patterns (when to use `file_urls`)

GeminiGen.AI accepts up to several reference images via `file_urls`. Use them for:

| Slide | Reference image | Anti-deviation phrase |
|-------|-----------------|------------------------|
| Cover (slide 0) | Logo lockups + founder face badges | "USE STRICTLY as a circular portrait BADGE INSERT (faces-only). DO NOT generate body or full figure." |
| Title (minimalist) | Operator photo (real) — face identity-lock | "USE THIS EXACT FACE — preserve facial identity precisely. NEVER synthesize." |
| Problem | Actual venue photo (when not subject to safety filter) — environment fidelity | "PRESERVE EXACTLY — do not redesign or stylize." |
| Solution | Actual product UI screenshot — screen accuracy | "PRESERVE UI elements exactly as rendered — no modifications." |
| Traction | Brand color swatch — palette consistency | "Use these exact hex values throughout: {hex_list}." |
| Team | Each founder's headshot — never generate faces from scratch | "USE EXACT FACE. Preserve facial identity precisely. NEVER synthesize." |
| CTA / Closing (slide N) | Founder face files + logos — full composite | See CTA composite formula above. |

> **The face-fidelity rule:** if the slide shows a specific person, ALWAYS pass their real photo as `file_urls`. Never describe them in text-only — AI generation will get features wrong and the deck reads as deepfake-amateur.

> **Anti-deviation rule:** any prompt with attached face/logo refs MUST include explicit "USE EXACTLY · PRESERVE · NEVER synthesize" phrasing. Soft language like "based on the attached photo" gets ignored by the model under load.

---

## 4.5. Composite reference patterns

For slides combining multiple references (cover + CTA), the binding pattern matters:

### Pattern A — Face-as-badge-insert (cover, slide 0)
- Face used **only** as a circular portrait badge ~140px diameter with white border.
- Background generated synthetically (no real venue photo attached).
- **Why:** dodges MINOR_UPLOAD safety filter that triggers when real-person photos are placed in real-environment photos.
- Anti-deviation: "USE STRICTLY as a circular portrait BADGE INSERT (faces-only). DO NOT generate body or full figure."

### Pattern B — Face-on-body composite (CTA, slide N)
- Face mapped onto a generated body in a generated atmosphere.
- Body posture, attire, framing, environment all explicitly specified.
- **Why:** emotional closing requires the founders **as people**, not just badges.
- Anti-deviation: "USE THIS EXACT FACE on {Founder}'s body" + "Both subjects CLEARLY ADULT PROFESSIONAL — NOT minors NOT children" + "Medium-wide framing (chest-up to mid-thigh) — NOT full-figure."
- **Higher safety-filter risk** than Pattern A. Always have Pattern A fallback in `fallback_strategy`.

### Pattern C — Logo-lockup-only (footer, source strips)
- Logo files used as graphic elements without faces.
- Lowest safety-filter risk. Use freely.
- Anti-deviation: "PRESERVE EXACTLY — do not redesign, stylize, or restyle. Maintain original logo proportions."

### Pattern D — UI-screenshot-only (solution, traction)
- Product screenshot used as design reference.
- Anti-deviation: "PRESERVE UI elements exactly as rendered — no modifications." + position the screenshot inside a generated device frame (tablet, laptop, phone).

> See `references/safety-filter-playbook.md` for per-error fallback ladders.

---

## 5. Cross-slide style consistency (with quality gate)

To enforce visual coherence across the deck:

1. Generate the **brand-anchor slide first** (slide 0 cover for info-dense decks; slide 1 for minimalist).
2. **Quality gate** — operator reviews the anchor slide. Approve before propagating.
3. Capture the response `uuid` after approval.
4. For all subsequent slides, pass that uuid as `ref_history` parameter.
5. The model uses the anchor's color grading, lighting, and overall aesthetic as a style guide for the rest.

> **Why the gate matters:** if the anchor slide is generic stock photo (a common failure mode in info-dense B2B decks where the operator wants a brand-anchored cover but the photo formula triggered), every subsequent slide inherits that genericness. Burning all 10 slides on a bad anchor is worse than re-rolling slide 0 three times.

> **Plugin enforcement:** `pitch-deck-gen` MUST surface the anchor preview to the operator before generating slides 2-N. Implementations: render slide 0/1 → display URL → wait for operator "approve" or "reroll" → only on "approve" does pipeline propagate `ref_history`.

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

The skill emits the following schema. **Schema 2.0** adds revision tracking, per-slide history, brand palette anchor, and density-mode awareness.

```json
{
  "schema_version": "2.0",
  "deck_id": "{from brief.json}",
  "revision": 1,
  "rerun_reason": null,
  "density_mode": "info-dense",
  "default_provider": "geminigen.ai",
  "default_model": "nano-banana-pro",
  "default_aspect_ratio": "16:9",
  "default_resolution": "2K",
  "default_output_format": "png",
  "style_anchor_slide": 0,
  "brand_palette": {
    "background": "#F8F4ED",
    "primary":    "#1AB8B6",
    "accent":     "#FF8C42",
    "secondary":  "#5860D6",
    "warning":    "#C53030",
    "ink":        "#1A2540"
  },
  "typography": "Plus Jakarta Sans",
  "prompts": [
    {
      "slide": 3,
      "slide_role": "solution",
      "visual_concept": "Horizontal 3-band flow diagram (Layer A · Layer B · Layer C) with input → process → output cards per band",
      "prompt": "Horizontal 3-band flow diagram pitch deck slide 16:9 #F8F4ED background...",
      "model": "nano-banana-pro",
      "aspect_ratio": "16:9",
      "style": "Infographic-flat",
      "output_format": "png",
      "resolution": "2K",
      "files": ["ref/product-ui-screenshot.png"],
      "file_urls": [],
      "ref_history": "img_<slide0_uuid>",
      "version_log": [
        { "rev": 1, "ts": "2026-05-02T16:30:00+07:00", "reason": "initial generation" }
      ],
      "expected_filename": "slide-03-solution.png",
      "manual_asset_required": false,
      "fallback_strategy": "If band 3 too cramped, increase its height to 40% and reduce bands 1+2 to 25% each. If safety filter triggers, see safety-filter-playbook.md."
    }
  ]
}
```

### Schema field reference

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `schema_version` | string | Yes | Always "2.0" for current schema |
| `revision` | integer | Yes | Bump on every rerun. Starts at 1 |
| `rerun_reason` | string \| null | No | One-sentence explanation when `revision > 1` |
| `density_mode` | enum | Yes | `"minimalist"` \| `"info-dense"` |
| `style_anchor_slide` | integer | Yes | Slide number used as `ref_history` source (0 for cover-anchored info-dense decks; 1 for minimalist) |
| `brand_palette` | object | Yes | Full palette object — required, not optional |
| `typography` | string | No | Default font family for the deck |
| `prompts[].files` | array | No | Local file paths for multipart upload (faces, logos, screenshots) |
| `prompts[].file_urls` | array | No | URL refs (alternative to local files) |
| `prompts[].ref_history` | string \| null | No | Anchor slide UUID for cross-slide consistency |
| `prompts[].version_log` | array | Yes | Rev history per slide — append on each rerun |
| `prompts[].manual_asset_required` | boolean | Yes | true if AI cannot render this slide cleanly (team slide, custom diagrams) |
| `prompts[].fallback_strategy` | string | Yes | Per-slide fallback when generation fails |

### Targeted-rerun support

To re-run a single slide:
```bash
/pitch-deck-gen --slide=3 --rerun-reason="Layer C band cramped — need taller emphasis band"
```

The plugin must:
1. Load existing `image-prompts.json`
2. Bump top-level `revision`
3. Append entry to `prompts[3].version_log`
4. Update `prompts[3].prompt` per the new rerun reason
5. Leave all other slides untouched

`pitch-deck-gen` writes one entry per slide in this schema; downstream tooling can submit each entry directly to GeminiGen.AI.
