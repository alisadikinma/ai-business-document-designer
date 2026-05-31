# Nano Banana Pro (Gemini 3 Pro Image) Prompting — Professional Decks & Infographics (2026)

**Generated**: 2026-05-31 via NotebookLM fast research (Gemini 3 backend), notebook `Pitch Deck Excellence + Nano Banana Pro RAG` (`1f9dbaf4-4087-4c84-af65-c1b0b21d92d2`).
**Freshness**: 🟢 FRESH (0–6 months).
**Scope**: Best-practice prompt craft for generating professional **business infographics, pitch-deck visuals, data visualizations, and brand assets** with Nano Banana Pro (NB2 / Gemini 3 Pro Image). This is the image-generation knowledge layer feeding [`../image-prompt-templates.md`](../image-prompt-templates.md) and the `ai-business-document-gen` skill.
**Sources**: Google AI / DEV Community ("Nano-Banana Pro: Prompting Guide & Strategies" — the Golden Rules), ImagineArt (75+ prompts), APIYI (verified 3-step data-viz method, 97% text accuracy), Control Alt Achieve (infographic layouts), "Brand-Consistent Infographics with Gemini" (5-step anti-slop framework), ConceptViz (illustration-style taxonomy), AIMaster (6-component formula).

> **What changed with NB2**: It moved from "fun" image generation to **functional professional asset production**. It is a *thinking* model — it reasons about intent, physics, composition, and (with Search grounding) facts before rendering. It renders **legible, correctly-spelled text in 12+ languages at 97%+ accuracy**, holds **character/brand consistency across up to 14 reference images**, and outputs up to **4K**. Prompt it like a **creative director briefing an artist**, not with keyword "tag soup."

---

## 0. The Golden Rules (read first)

1. **Edit, don't re-roll.** If an image is ~80% right, do **not** regenerate from scratch — ask for the specific change conversationally. ("That's great, but change the lighting to sunset and make the title cyan.")
2. **Natural language, full sentences.** Brief it like a human artist with proper grammar and descriptive adjectives.
   - ❌ `cool car, neon, city, night, 8k`
   - ✅ `A cinematic wide shot of a futuristic sports car speeding through a rainy Tokyo street at night; neon signs reflect off the wet pavement and the car's metallic chassis.`
3. **Be specific** about subject, setting, lighting, mood, materials.
4. **Give context (the "why" / "for whom").** Because it reasons, context drives better artistic choices: *"…for a Brazilian high-end gourmet cookbook"* → it infers professional plating, shallow DoF, perfect lighting.
5. **Avoid vague quality words** — "cinematic," "high quality," "professional," "8k" do little. Use concrete specs instead (camera, lens, lighting, grade, style name).

---

## 1. The Six-Component Prompt Formula

Every professional prompt should specify these six (the AIMaster / ImagineArt baseline):

| # | Component | What to state | Example |
|---|---|---|---|
| 1 | **Subject** | Who/what, specifically | "a sophisticated elderly woman in a vintage Chanel-style suit"; "a circular flow diagram" |
| 2 | **Composition** | Camera framing / shot | "low-angle worm's-eye view", "cinematic wide shot", "orthographic blueprint", "flat-lay top-down" |
| 3 | **Action / Content** | What's happening / the data | "presenting a quarterly report"; "timeline of 4 stages"; "hub-and-spoke of 6 use-cases" |
| 4 | **Setting / Environment** | Location / backdrop | "futuristic office with neon accents"; "clean white studio"; "dark navy data hall" |
| 5 | **Art Style** | The look & feel (named) | "isometric 3D", "flat vector", "minimalist editorial", "technical blueprint" |
| 6 | **Lighting / Details** | Mood + technical + materials | "f/1.8, long shadows, natural daylight"; "matte finish, brushed steel"; "4K, high-fidelity textures" |

Append **aspect ratio** and **resolution** at the end (see §3).

---

## 2. Rendering Legible, Accurate Text (NB2's headline capability)

NB2 is currently the only model that reliably renders complex, correctly-spelled text (97%+ across 12+ languages, RTL + LTR, with automatic hierarchy/typesetting). To exploit it:

- **The Inverted-Comma Rule**: put the exact text you want rendered in **"quotation marks"**. `The title must be "FROM EGG TO FROG".`
- **Specify typography**: font family + weight + placement. `bold sans-serif`, `technical architectural font`, `classic serif`, `display style, top-left`.
- **Demand legibility explicitly** when text is data-critical: `All numbers and labels must be large, bold, high-contrast, and perfectly spelled.`
- **The Two-Step Strategy (kills random unwanted text)**: NB2 tends to invent stray text. Fix by splitting the prompt into two sequential turns — **(1)** give the source content / list the exact text elements and ask it to identify them; **(2)** in the follow-up, give the visual treatment. This forces "decide the text → then style it," dramatically cutting garbled/extra text.

> ⚠️ **Plugin-relevant caveat**: in our `html-css` deck pipeline, NB2 should generate **text-free backgrounds/heroes only** — live text is composited via HTML/CSS overlay (no AI-rendered text, no faces to the API). The text-rendering techniques above apply when generating **`full-image` mode** pages/infographics where text is baked into the image. Always check `render_mode` before relying on in-image text. (See [`../image-prompt-templates.md`](../image-prompt-templates.md) and [`../safety-filter-playbook.md`](../safety-filter-playbook.md).)

---

## 3. Composition, Layout & Aspect Ratio Control

- **Composition vocabulary** (use camera terms): `cinematic wide shot`, `low-angle worm's-eye view`, `orthographic blueprint`, `exploded isometric view`, `flat-lay (knolling)`, `cross-section / cutaway`.
- **Layout vocabulary** — name the structure explicitly (see §5 for which to pick):
  `Bento Grid`, `Hub and Spoke`, `Comparison Matrix`, `Step-by-Step Flow`, `Horizontal Timeline`, `Funnel`, `Concentric Circle (target)`, `Dashboard`, `Pyramid`, `Venn`, `Winding Roadmap`, `Anatomical Call-out`.
- **Sketch-to-Image (precise layout control)**: upload a rough sketch/wireframe (even stick-figure boxes) and add `Follow the structure/layout of the attached reference image exactly.`
- **Aspect ratio**: state it at the end. `Format: 16:9 landscape` (decks), `Vertical 9:16 portrait` (social/infographic), `Square 1:1`.
- **Resolution**: request **≥1K, ideally 2K–4K**; never accept low-res. NB2 supports native 1K–4K.

---

## 4. Brand Consistency, Hex Codes & Style Reuse

- **Always use exact hex codes**, never color names alone. Define **primary, 2–3 secondary, and background** (e.g. `Primary #0B1929, accent #00D9FF, gold #FFB800, background #FFFFFF`). This is the same hard rule as the plugin's `global-config.md §3.6` brand-palette injection — NB2 honors hex precisely; "deep navy" drifts.
- **Build a 6-attribute style guide** before generating a set: (1) aspect ratio, (2) resolution, (3) color palette w/ hex, (4) typography, (5) layout preference, (6) **illustration style** (most critical — describe line work, shading, color treatment; you may reference known styles like "HBR editorial illustrations" / "New Yorker style").
- **Derive a style guide from references**: upload 2–3 existing brand images and ask the model to *"generate a prompt-ready style guide describing these six attributes."* Reuse that block verbatim across every slide for consistency.
- **Reference-image conditioning**: NB2 accepts up to **14 reference images** (≈6 at high fidelity). Mark each input's role (`character`, `style`, `background`, `environment`).
- **Identity locking** (faces/characters): `Keep the person's facial features exactly the same as Image 1, but change their expression to look confident.`
- **Consistency anchor pattern** (matches our `ref_history` / `style_anchor_uuid` mechanism): approve one anchor image, then chain every subsequent image off it so palette + style + lighting stay locked across the deck.

---

## 5. Choosing the Right Professional Layout / Style

**Match infographic goal → style** (ConceptViz):

| Goal | Best style | Why |
|---|---|---|
| Explain a process | Flat design / line art | Clear shapes + labels scan fast |
| Show systems / spatial relationships | Isometric illustration | Structure + depth without full-3D noise |
| Make a complex topic approachable | Hand-drawn / sketch | Feels human, less formal |
| Present data / research findings | **Minimalist editorial** | Strips decoration, keeps focus on evidence |
| Modern product / AI / software visual | 3D / soft dimensional | Adds polish for tech topics |

**Corporate deck layouts → when to use** (Control Alt Achieve):

| Layout | Use when |
|---|---|
| **Bento Grid** | Modular, scannable data — several distinct points in tidy boxes |
| **Dashboard** | Numbers/KPIs — mimics an analytics screen |
| **Comparison Matrix / Split (Versus)** | Comparing items across the same criteria; instant contrast |
| **Step-by-Step Flow / Funnel** | Processes, conversion paths, "input → AI → output" |
| **Hub and Spoke / Concentric** | One core with many attributes; layered moat |
| **Horizontal / Winding Timeline** | Roadmaps, staged deals, history |
| **Exploded Isometric / Cutaway** | Technical / engineering "how it fits together" |

For executive decks, default to **Bento Grid, Dashboard, Comparison Matrix, and Minimalist Editorial** — they read as boardroom-grade, not clip-art.

---

## 6. Verified 3-Step Data-Visualization Method (APIYI)

For data-driven business infographics:

1. **Data preparation & structuring** — clarify core indicators, categorization dimensions (time/region/category), reference points (max/min/avg), and annotations. **Cap at 5–8 main data points per image** for clarity, and give the *business meaning*, not just numbers.
2. **Prompt design & chart-type selection** — map data → chart (see §5 of [`executive-deck-craft-2026.md`](./executive-deck-craft-2026.md): comparison→bar, proportion→pie/donut, trend→line/area, process→flow/funnel, hierarchy→tree). State chart type at the *start* of the prompt; specify color semantics, element positions ("left to right"), and text legibility.
3. **Generation, verification & iteration** — generate, verify accuracy, then conversationally fix. Known fixes:
   - *Unclear text* → "large, bold, high-contrast text", bump to 4K, add "ensure all numbers and labels are perfectly readable."
   - *Wrong data-point positions* → specify each position + directional order; enable thinking/reasoning so it plans layout first.
   - *Wrong colors* → exact hex + reference image + explain the color's semantic meaning.

**Search Grounding**: because NB2 can use Google Search, it can render **factually accurate, up-to-date** infographics (live stocks, current events) and reason about results before drawing — reducing hallucination on timely topics. (For our plugin, prefer supplying vetted source data in-prompt over relying on grounding for client numbers.)

---

## 7. Anti-"AI Slop" Checklist

Asking NB2 to "create an infographic" yields cluttered clip-art with random text — *AI slop*. To get brand-grade assets:

- ✅ Build the **6-attribute style guide** first (§4); reuse it every time.
- ✅ Use the **Two-Step text strategy** (§2) to suppress invented text.
- ✅ Put exact copy in **"quotes"**; demand "perfectly spelled, legible."
- ✅ Specify **exact hex** colors and a **named layout + named style**.
- ✅ **Negative prompting** as an always-on quality filter: explicitly exclude `low resolution, garbled text, cluttered, generic clip art, random watermarks, extra fingers`.
- ✅ Provide **vetted content** (paste the report/figures) rather than letting it improvise data.
- ✅ Prefer **isometric / flat-vector / minimalist-editorial / bento** over default "stocky" renders.
- ❌ Don't tag-soup. ❌ Don't accept <1K. ❌ Don't rely on color names. ❌ Don't let it auto-generate faces of real people (composite real photos in post — see safety playbook).

---

## 8. Conversational / Iterative Editing ("Golden Rules" in practice)

- **Edit, don't re-roll** — refine the 80%-right image.
- **Preservation prompting**: `Leave everything else exactly the same, but [one change].` — protects the parts you like.
- **Targeted edits**: "Make the red circle only on the most important title word"; "Update to a two-across grid"; "Replace the illustration in section 3 with [X]"; "No robots — use human figures."
- **Annotated feedback**: download → circle/annotate the area → re-upload → "update this section per the note."
- **Consolidate**: once perfect, ask `Please update my original prompt to include all these refinements for future use.` Save the result as a reusable **Gemini Gem** / template (our equivalent: store the finalized prompt block in `image-prompts.json` and chain via the style anchor).

---

## 9. Quality Control After Generation

- **OCR text check** — run OCR on the render; confirm rendered text matches source exactly (catches subtle misspellings at 97%, not 100%).
- **Numerical accuracy** — compare every data point against the source spreadsheet; verify trends are drawn correctly (a "Q4 up" must not render as down).
- **Multiple candidates** — generate a few, pick the best, **record the winning prompt + params** into a template library.
- **Brand check** — palette matches hex, typography hierarchy correct, layout matches the named structure, no slop artifacts.

---

## 10. Recommended Master Prompt Template (business infographic / deck visual)

```
[Topic & audience]  Create a professional business infographic about <DATA TOPIC>
                    for a <C-suite / board> audience.
[Core data]         Include these data points: <list 5–8 specific numbers/trends + business meaning>.
[Text]              Title must be "<TITLE>". Label sections "<L1>", "<L2>", "<L3>".
                    All text large, bold, high-contrast, perfectly spelled and legible.
[Chart & layout]    Use a <Bento Grid / Dashboard / Comparison Matrix / Flow> layout
                    with <bar / line / donut / funnel> charts mapped to the data.
[Brand]             Primary <#HEX>, accent <#HEX>, background <#HEX>.
                    Style: <minimalist editorial / isometric 3D / flat vector>.
                    Typography: <font family + weights>.
[Negative]          Exclude: low resolution, garbled text, cluttered clip art,
                    random watermarks, generic stock imagery.
[Format]            <16:9 landscape>, high-resolution <2K–4K>.
```
For a **multi-image deck set**: generate/approve one **style-anchor** image from this template, then chain every subsequent slide off it with `Match the style, palette, and typography of the anchor exactly; change only the content to <…>.`

---

## 11. Quick Reference Card

```
MODEL       NB2 = thinking model. Brief like a creative director, not tag-soup.
FORMULA     Subject · Composition · Action/Content · Setting · Style · Lighting/Details (+AR +res)
TEXT        exact copy in "quotes"; demand legible+spelled; TWO-STEP to kill stray text
LAYOUT      name it: Bento / Dashboard / Comparison / Flow / Hub-Spoke / Timeline
STYLE       data→minimalist-editorial; process→flat/line; systems→isometric; tech→3D
BRAND       exact HEX (never color names); 6-attribute style guide; reuse verbatim
CONSISTENCY ≤14 ref images; identity-lock faces; style-anchor + chain
DATA-VIZ    3-step: prep (5–8 pts) → chart-match → verify+iterate; Search grounding for facts
ANTI-SLOP   style guide + two-step text + hex + named layout + negative prompt + vetted data
EDIT        edit don't re-roll; "leave everything else the same, but…"; OCR + number check
PLUGIN      html-css = text-FREE bg only (text via CSS); full-image = bake text w/ rules above
```
