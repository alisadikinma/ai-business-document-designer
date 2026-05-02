# Seedance 2.0 Video Prompt Templates — Slide Motion for Pitch Decks

> Use Seedance 2.0 motion sparingly. Most slides should be static. Motion is only justified when it carries information that a static image cannot.

> **Source backbone:** `d:\Projects\claude-plugin\video_seedance2\03_Seedance2_Master_Prompting_Framework.md` — Seedance 2.0 master prompting framework (4-block hierarchical architecture, multimodal references, @-syntax).

---

## 1. When to use video on a slide (and when not to)

| Slide type | Use video? | If yes, what kind |
|-----------|-----------|------------------|
| Title / Vision | NO (rare) | A 4-second hero loop ONLY if the visual identity is so distinctive that motion adds clarity (e.g. wristband activating). Default = static. |
| Problem | OPTIONAL | A 4-sec loop of the pain in motion (queue moving slowly, customer leaving frustrated). Powerful for B2B mode. |
| Solution | YES | A 4-6-sec product demo loop showing the transformation. Highest video ROI on the deck. |
| Why Now | NO | Static news-photo style is more credible than animated dramatization. |
| Market | NO | Charts don't need to animate; the data itself is the story. |
| Product | YES | A 6-8-sec UI walkthrough loop. The "wow" moment of the deck. |
| Traction | OPTIONAL | An animated counter ticking up — but Remotion serves this better than Seedance. |
| Business model | NO | Tables don't animate well. |
| Moat | NO | Structural diagram is static; motion suggests imprecision. |
| Competition | NO | 2x2 doesn't need motion. |
| Team | NO | Founders are people, not animated characters. |
| Ask | NO | Typography slide; motion is distracting. |

**Rule of thumb:** if the slide answers "what does it look like in operation?" — video. Otherwise, static.

---

## 2. Seedance 2.0 4-block prompt architecture

Every Seedance 2.0 prompt has 4 hierarchical blocks. Block order matters — early blocks anchor the model's latent attention.

### Block 1 — Subject + Action Anchor

Define WHO and WHAT in one sentence. No styling, no camera. Just the anchor.

```
A {subject} {action} {with what} {where}.
```

### Block 2 — Camera + Motion Grammar

Use Seedance's three-level camera vocabulary:

| Level | Vocabulary |
|-------|-----------|
| 1 — Fundamental | Pan, Tilt, Zoom, Dolly, Truck, Pedestal |
| 2 — Modifiers | Sudden, Cinematic, Handheld, Dreamy, Dutch Angle |
| 3 — Combinations | Orbit + Zoom In, Crane Up + Pan, Hitchcock Zoom (Dolly Zoom), Whip Pan, Rack Focus |

Pattern:
```
{Camera primary} {camera modifier} from {start framing} to {end framing}.
```

### Block 3 — Style + Consistency Constraints

Lock the visual style (matches your image-prompt slide identity).

```
{Style descriptor — Photorealistic / Editorial / Infographic-flat}, {color grading},
{lighting quality}, {brand color emphasis}, consistent with {reference image @-token}.
```

### Block 4 — Audio + Pace

Audio is supported via @-references. For pitch deck loops, audio is usually OFF (silent loops embed cleaner in slides). When used, specify rhythm.

```
{Audio: silent | subtle ambient | beat-synced to @Audio1}.
{Pace: 4-second loop | 6-second loop | 8-second loop}.
```

---

## 3. Per-slide-type prompt templates

### SOLUTION slide (the most common video use)

#### Formula
```
Block 1: A {operator_role} {actioning_the_product} at {specific_venue} during {time_of_day_with_lighting}.
Block 2: Camera does a slow Dolly + Zoom In from medium-wide framing on the operator's full workstation to medium-close-up on {product_focus_element — e.g. tablet POS / wristband scanner}, cinematic motion.
Block 3: Photorealistic editorial style, warm color grading favoring brand primary deep navy and saturated orange accent, late-afternoon natural light from skylight, consistent with @Image1 (slide 3 reference).
Block 4: Silent, 6-second loop ending exactly at the start frame for seamless looping.
```

#### Worked example (Indusia solution slide)
```
Block 1: An Indonesian woman cashier in her 30s tapping a customer's wristband on the wireless reader at a Jakarta food court counter during late afternoon golden hour.
Block 2: Camera does a slow Dolly + Zoom In from medium-wide framing on the full counter-and-customer scene to medium-close-up on the wristband-meets-reader contact point, cinematic motion, no shake.
Block 3: Photorealistic editorial style, warm color grading favoring deep navy and saturated orange brand accents, late-afternoon natural skylight, consistent with @Image1 (slide 3 reference).
Block 4: Silent, 6-second loop, last frame matches first frame for seamless re-play.
```

### PRODUCT slide (UI walkthrough)

#### Formula
```
Block 1: A close-up screen recording of the {product_name} {ui_view} as a finger {ui_action_sequence}.
Block 2: Static camera (slide 5 ≠ scene change). UI animates in place — buttons highlighting, transitions between screens, data updating.
Block 3: Photorealistic UI rendering, brand-color UI elements, off-white app background, consistent with @Image1 (product screenshot reference).
Block 4: Silent, 8-second loop, full UI workflow completes once and resets.
```

### PROBLEM slide (visceral pain in motion)

#### Formula
```
Block 1: A {operator_role} {pain_action — e.g. trying to manually count cash, getting overwhelmed by queue} at {pain_venue} during {peak_pain_moment}.
Block 2: Handheld camera, slight Dutch angle, Whip Pan from operator's frustrated face to the chaos around them, 1.5x speed for tension.
Block 3: Editorial documentary style, harsh fluorescent lighting, desaturated palette except one bright red signal element (error message, frustrated customer's gesture), consistent with @Image2 (slide 2 reference).
Block 4: Silent, 4-second loop, ends at moment of operator's exhale (emotional landing point).
```

---

## 4. Reference image / video binding (@-syntax)

Seedance 2.0 supports up to 12 reference files. For pitch deck videos, the most common patterns:

| @-syntax usage | Strategic outcome |
|----------------|------------------|
| `@Image1 as the first frame` | Locks initial composition + character identity. Use for slide 3 / 5 / 6 to ensure the static slide image and the video first-frame match exactly. |
| `@Image2 as the last frame` | Defines clear end point. Use for transitions where the video must land on a specific composition. |
| `Reference @Image3 for character identity` | Locks specific person's face. Use when the video shows a real operator / founder. |
| `Follow @Video1's camera work` | Replicates a reference video's camera trajectory. Use to copy a specific dolly-zoom from a known reference. |

> **Binding rule:** every video prompt that depicts a person MUST bind to a real reference photo via @Image. Generating new faces from text-only descriptions produces uncanny-valley failures.

---

## 5. Camera-grammar lookup (quick reference)

| Cinematic effect | Seedance phrase |
|------------------|-----------------|
| Tension / unease | "Dutch angle, slow Tilt down, handheld" |
| Reveal / aha | "Crane Up + Pan to wider context" |
| Focus on detail | "Slow Dolly + Zoom In to {object}, rack focus from {foreground} to {detail}" |
| Energy / momentum | "Whip Pan from {A} to {B}, sudden cinematic" |
| Calm / control | "Static camera, locked-off, eye-level medium-close-up" |
| Disorientation / pain | "Handheld, slight wobble, Dutch angle, 1.5x speed" |
| Establishment / authority | "Slow Pedestal Up from low-angle medium to high-angle wide" |

---

## 6. Loop seamlessness checklist

For slide-embedded video, seamless looping is critical (otherwise the loop seam is jarring during presentation).

- [ ] First frame and last frame are visually identical (or nearly so)
- [ ] No "subject mid-action" at the boundary (e.g. don't end on a hand-mid-gesture)
- [ ] No motion blur at boundary frames
- [ ] Lighting matches at boundary
- [ ] If audio: specify silent OR loop-friendly ambient (no beats that cut)

In the Block 4 instructions, ALWAYS specify "last frame matches first frame for seamless re-play."

---

## 7. Style consistency across all video slides

If a deck has multiple Seedance video slides, enforce style consistency:

1. The first video slide generated becomes the style anchor.
2. Subsequent video slides reference the anchor video via `@Video1 for style + lighting consistency`.
3. All videos must share the same color grading, lighting quality, and brand color emphasis.

This prevents the "every slide looks like a different production" problem.

---

## 8. The Indonesian-context geofence note

**CRITICAL:** Seedance 2.0 is geofenced to Mainland China and accessed via Jimeng / Dreamina accounts. Operators in Indonesia must:

1. Have a China-supported account (Jimeng or Dreamina) for full access, OR
2. Use VEO 3.1 (Google) as fallback — different prompt grammar, but same 4-block architecture works.

The plugin emits prompts in Seedance 2.0 format by default. To switch to VEO 3.1:
- Set `video_provider: veo-3.1` in the brief output
- The skill will adapt: 4-block architecture stays the same; @-references rewrite to VEO's native syntax (which uses sequential text rather than @-tokens).

---

## 9. Output JSON schema (video-prompts.json)

The skill emits one entry per slide flagged `motion: true`:

```json
{
  "slide": 3,
  "slide_role": "solution",
  "video_provider": "seedance-2.0",
  "duration_seconds": 6,
  "aspect_ratio": "16:9",
  "block_1_subject_action": "An Indonesian woman cashier in her 30s tapping a customer's wristband on the wireless reader at a Jakarta food court counter during late afternoon golden hour.",
  "block_2_camera_motion": "Camera does a slow Dolly + Zoom In from medium-wide framing on the full counter-and-customer scene to medium-close-up on the wristband-meets-reader contact point, cinematic motion, no shake.",
  "block_3_style_consistency": "Photorealistic editorial style, warm color grading favoring deep navy and saturated orange brand accents, late-afternoon natural skylight, consistent with @Image1 (slide 3 reference).",
  "block_4_audio_pace": "Silent, 6-second loop, last frame matches first frame for seamless re-play.",
  "references": [
    {"token": "@Image1", "purpose": "first frame + character identity lock", "file_path": "slide-03-solution.png"}
  ],
  "loop_seamless": true,
  "expected_filename": "slide-03-solution.mp4",
  "fallback_provider": "veo-3.1"
}
```

`pitch-deck-gen` writes one entry per video-flagged slide. Downstream operator submits to Seedance 2.0 (via Jimeng/Dreamina) or VEO 3.1.

---

## 10. The "is this video earning its weight?" gate

Before approving any video on a slide, answer:

1. Does this video carry information a static image cannot?
2. Does the motion advance the narrative or just look "cool"?
3. Will the loop seam be invisible during a live presentation?
4. Is the file size budget acceptable (target ≤ 5MB per loop, max 10MB)?
5. If the video fails to render, does the static fallback still tell the story?

If any answer is "no" or "uncertain," cut the video. Static slide is always safer than a half-working video.
