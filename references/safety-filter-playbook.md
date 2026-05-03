# Safety Filter Playbook — MINOR_UPLOAD + Person Composite Mitigation

> Read when generating slides that combine real-person reference images with environmental settings (cover slide 0, CTA slide N, team slide). GeminiGen.AI / Nano Banana Pro safety filters trigger on combinations that, in isolation, look fine — knowing the patterns saves 10+ failed reruns per deck.

---

## 1. What triggers safety filters

GeminiGen.AI's nano-banana-pro applies multiple filters before generation:

| Filter | What it blocks | When it fires |
|--------|---------------|---------------|
| `MINOR_UPLOAD` | Any input image suspected of containing minors, or any output that could place a real person into a context with minors | Real-person face attached + venue photo with crowd attached + crowd contains anyone the model thinks under 18 |
| `IDENTITY_PRESERVATION` | Output where attached face has been distorted into a different person | Soft prompts ("based on the attached photo") + low-resolution face attachments |
| `DEEPFAKE_HARM` | Real face placed into harmful, sexual, political, or violent context | Real face + extreme situation prompts |
| `PROHIBITED_CONTENT` | Adult/violent/political content | Direct prompt or composition implies it |
| `LOW_QUALITY_REJECTION` | Outputs the model judges as "would fail user" | Conflicting instructions, too many requirements in single prompt |

**The most common one in pitch-deck production is `MINOR_UPLOAD`** — and it usually fires because of the **input combination**, not the output.

---

## 2. The MINOR_UPLOAD trigger pattern

`MINOR_UPLOAD` fires most often on this combination:

```
INPUT 1: Real-person face photograph (founder headshot)
INPUT 2: Real-event/venue photograph that contains crowd / passersby
PROMPT:  "Place [INPUT 1's face] into [INPUT 2's environment]"
```

The model can't verify ages of incidental crowd members in INPUT 2. To avoid placing the founder into a scene with potential minors, it refuses the whole generation.

### Confirmed triggers (from real production runs)
- Cover slide with founder face + actual bazaar/mall event photo with visible attendees
- CTA composite with founder face + actual conference photo with audience
- Team slide with founder face + actual office photo with other employees

---

## 3. Mitigation — Synthetic Atmosphere Pattern

The fix: **replace the real environmental photo with a synthetic atmospheric description** generated fresh by the model.

### Pattern (use in cover slide 0 + CTA slide N)

```
FULL-SLIDE BACKGROUND — synthetic atmospheric environment (generate fresh, NO real event photo attached):

{environment_descriptor — e.g. "evening pop-up market bazaar", "Jakarta mall food court at golden hour", "trade show floor"}
with soft-focus warm tents/booths/displays in muted {brand_palette.primary} / {brand_palette.background} / {brand_palette.accent} tones,
abstract warm string-light bokeh creating golden glow points,
dark soft-blurred deep-background shapes
(NO recognizable people, NO minors, only abstract distant silhouettes far in background depth at <8% sharpness).

Color grade: {brand_palette.accent} + {brand_palette.primary} + {brand_palette.ink}.
Heavy depth-of-field blur, magazine cinematography feel.
```

### Critical phrases that work

| Phrase | What it does |
|--------|--------------|
| `"NO real event photo attached"` | Tells the model not to expect a venue file in the input list |
| `"NO recognizable people, NO minors"` | Pre-empts the safety filter check |
| `"only abstract distant silhouettes far in background depth at <8% sharpness"` | Allows ambient crowd feel without rendering identifiable figures |
| `"abstract warm string-light bokeh"` | Creates atmosphere without literal people |
| `"deep-background shapes suggesting tent silhouettes / crowd ambience"` | Hints at vibe without rendering individuals |

### Phrases that re-trigger the filter (DO NOT use)

| Phrase | Why it fails |
|--------|--------------|
| `"with people in the background"` | Direct request to render people |
| `"crowd of customers"` | Same |
| `"family-friendly bazaar atmosphere"` | "Family" implies minors → filter check fires |
| `"young customers browsing"` | "Young" reads as ambiguous-age → filter fires |
| `"children playing"` | Direct minor reference → hard fail |

---

## 4. Face composite patterns (Pattern A vs Pattern B)

Two patterns for combining real founder faces with generated environments. Pick based on emotional weight needed.

### Pattern A — Face-as-badge-insert (LOW filter risk)

Use for: cover slide 0, founder badge cards, contact strips.

```
COMPOSITION:
- Founder face appears ONLY as a circular portrait badge (~140px diameter, white border, drop shadow).
- Badge sits on a colored card (brand primary or accent fill).
- Background is fully synthetic atmospheric — generated fresh, no real environment photo attached.
- Founder body is NEVER generated — only the face badge.

ANTI-DEVIATION PHRASES (REQUIRED):
"USE STRICTLY as a circular portrait BADGE INSERT (faces-only). DO NOT generate body or full figure."
"PRESERVE EXACTLY — preserve facial identity precisely."
"NEVER synthesize or alter facial features."
```

Filter risk: **LOW.** Face is decoupled from environment.

### Pattern B — Face-on-body composite (MEDIUM filter risk)

Use for: closing CTA slide N (handshake composite), product slide (founder operating real product).

```
COMPOSITION:
- Founder face mapped onto a generated body in a generated atmosphere.
- Body posture, attire, framing, environment all explicitly specified.
- Background is fully synthetic atmospheric (no real event photo).

ANTI-DEVIATION PHRASES (REQUIRED):
"USE THIS EXACT FACE on {Founder}'s body in the composite."
"PRESERVE facial identity precisely. NEVER synthesize or alter facial features."
"Both subjects CLEARLY ADULT PROFESSIONAL — NOT minors NOT children."
"Medium-wide framing (chest-up to mid-thigh) — NOT full-figure."

EXPLICIT AGE-LOCKING (REQUIRED):
"Adult Indonesian businessman late 30s" / "Adult Indonesian businesswoman mid 30s"
DO NOT use ambiguous descriptors like "young", "youthful", "fresh-faced".
```

Filter risk: **MEDIUM.** Always have Pattern A as fallback in `fallback_strategy`.

---

## 5. Per-error fallback ladder

When a generation request fails, work down this ladder.

### Error: `MINOR_UPLOAD` (the most common)

```
Step 1: Check inputs. Is there a real-event photo attached alongside the face?
  → If yes, drop the real-event photo. Replace with synthetic atmosphere description.
  → Re-run.

Step 2: Still failing? Check prompt for "young", "youthful", "fresh-faced" descriptors.
  → If found, replace with "adult ... late 30s / 40s" explicit age lock.
  → Re-run.

Step 3: Still failing? Check prompt for "family", "children", "kids", "young customers".
  → If found, remove. Replace with "professional adult attendees" or just delete.
  → Re-run.

Step 4: Still failing? Drop one face attachment.
  → Use single-founder composite (face A only, render face B in Canva/Figma manually).
  → Re-run.

Step 5: Still failing? Drop ALL face attachments.
  → Generate atmospheric environment + body posture only. Both faces composited manually downstream.
  → Re-run.

Step 6: Still failing? Set manual_asset_required=true and produce briefs for human photographer/designer.
```

### Error: `IDENTITY_PRESERVATION` (face distorted into different person)

```
Step 1: Strengthen anti-deviation language.
  → Add: "USE THIS EXACT FACE — do NOT regenerate, redraw, stylize, age-shift, or alter facial features."
  → Re-run.

Step 2: Still failing? Increase face-attachment resolution.
  → Re-shoot or re-source headshot at ≥1024×1024 with face filling ≥80% of frame.
  → Re-run.

Step 3: Still failing? Switch from Pattern B (face-on-body) to Pattern A (face-as-badge).
  → Faces become 140px badge inserts, decoupled from body generation.
  → Re-run.
```

### Error: `LOW_QUALITY_REJECTION`

```
Step 1: Count instructions in prompt.
  → If >25 explicit composition requirements, split into 2 prompts (e.g. background-only first, then composite face on top via image edit).

Step 2: Check for conflicting requirements.
  → e.g. "warm tropical setting" + "cool corporate atmosphere" — pick one.

Step 3: Still failing? Reduce density.
  → Drop secondary elements (decorative dividers, secondary callouts). Keep only the primary 5 zones.
```

### Error: `PROHIBITED_CONTENT`

```
Investigate prompt for:
  - Political symbols / flags / partisan content
  - Violent imagery (even if metaphorical: "battlefield", "war", "fight")
  - Adult content descriptors (inadvertent: "exposed", "intimate")
Remove and re-run. If unclear, escalate to human.
```

---

## 6. Pre-flight checklist for face-composite slides

Before submitting any slide with attached face references, verify:

- [ ] Background is described as **synthetic** — no real event/venue photo attached
- [ ] Phrase `"NO recognizable people, NO minors"` is in the prompt
- [ ] Distant figures are limited to `"<8% sharpness, abstract bokeh"`
- [ ] All subject descriptions explicitly age-locked: `"adult ... late 30s / 40s"`, NEVER `"young"` or `"youthful"`
- [ ] Composite pattern declared (A: badge-only, or B: face-on-body)
- [ ] Anti-deviation phrasing present per Pattern A or B requirements
- [ ] `fallback_strategy` field populated with the per-error ladder above
- [ ] If Pattern B used, Pattern A fallback documented

If any unchecked, expect MINOR_UPLOAD or IDENTITY_PRESERVATION failures on first run.

---

## 7. Recovery cost estimation

Each failed generation costs ~10-30s + rate-limit budget on `nano-banana-pro` (FREE tier: 5 req/min, 100 req/hour, 1000 req/day).

| Mistake | Average rerun cost |
|---------|---------------------|
| Real venue photo attached + face → MINOR_UPLOAD | 4-6 reruns to discover + remove venue photo |
| Soft anti-deviation language ("based on photo") | 2-3 reruns until face stops drifting |
| Ambiguous age descriptors ("young professional") | 2-3 reruns until filter accepts |
| No fallback ladder documented | Unbounded reruns until operator gives up |

**Investing 30 seconds to check this playbook saves 5-15 failed runs per cover/CTA slide.**

---

## 8. When to bypass the model entirely

Some compositions are easier in Canva/Figma than in nano-banana-pro:

| Composition | Easier in Canva? |
|-------------|------------------|
| Face badges over a text-heavy slide | YES — generate text+atmosphere in NB pro, composite face badges in Canva |
| Logo lockups with exact spacing | YES — generate atmosphere only, place logos in Canva |
| QR codes | ALWAYS YES — never generate, always render in Canva |
| Multi-page layouts where same face appears 5+ times | YES — generate face once, paste into Canva slides 5 times |

Set `manual_asset_required: true` on these slides in `image-prompts.json` and provide a Canva-ready brief in `fallback_strategy`.

---

## 9. Plugin enforcement

`pitch-deck-gen` MUST:

1. Apply Pattern A (face-as-badge) by default for cover slide 0.
2. Apply Pattern B (face-on-body composite) only for closing CTA slide N when emotional weight is needed.
3. Inject required anti-deviation phrases automatically (operator should not have to remember).
4. Inject `"NO recognizable people, NO minors"` + `"<8% sharpness, abstract bokeh"` automatically into every prompt with face refs.
5. Populate `fallback_strategy` field with the per-error ladder from §5 automatically.
6. Surface `manual_asset_required=true` recommendation when face composite slide has >2 face attachments + venue context.

`pitch-deck-validate` MUST:

1. Flag any slide with face refs that lacks anti-deviation phrasing.
2. Flag any slide with face refs that includes "young" / "youthful" / "fresh-faced" descriptors.
3. Flag any slide with face refs but missing fallback_strategy.
