# Remotion Config Templates — Programmatic Motion for Slide Embeds

> Use Remotion sparingly — only for motion that requires programmatic control (live data, parallax, animated counters, scroll-driven storytelling). For organic motion (people, scenes, demos), use Seedance 2.0 instead.

---

## 1. When to use Remotion (and when not to)

| Slide type | Use Remotion? |
|-----------|--------------|
| Animated counter (traction slide ticking from Rp 0 → Rp 12 M) | YES — Remotion handles this perfectly |
| Animated chart with data revealing | YES — programmatic timing precision |
| Animated map with venue pins appearing sequentially | YES — pin-by-pin timing control |
| Live data ticker (real-time MRR, transactions/min) | YES — bound to live API at render |
| Scroll-driven story (parallax) | YES — but only on web-based decks (Pitch.com, Gamma) |
| Solution / demo / human action loops | NO — Seedance 2.0 is better |
| Static infographic | NO — image is enough |
| Title slide | NO — distracts from positioning |

---

## 2. Remotion project structure (assumed)

The plugin assumes the operator has a Remotion v4+ project scaffolded separately (see https://www.remotion.dev/docs/the-fundamentals). The plugin emits a JSON config that:

1. Names the composition (e.g. `slide-06-traction-counter`)
2. Specifies fps + duration in frames + aspect ratio
3. Lists props bound to the composition (data inputs, color palette, copy)
4. Names the React component file the operator should create (or reuse from a template library)

The actual React/TSX components live in the operator's Remotion project, not in this plugin. The plugin emits the *config that drives them*.

---

## 3. Per-slide motion type templates

### TYPE A — Animated counter (traction slide)

#### Use case
"GMV processed" tickering from Rp 0 to Rp 12 M over 4 seconds, then holding.

#### Config schema
```json
{
  "composition_id": "slide-06-traction-counter",
  "component_file": "src/compositions/TractionCounter.tsx",
  "fps": 30,
  "duration_in_frames": 240,
  "aspect_ratio": "16:9",
  "width": 1920,
  "height": 1080,
  "props": {
    "metric_label": "Monthly GMV processed",
    "start_value": 0,
    "end_value": 12000000000,
    "currency_format": "IDR_short",
    "ramp_seconds": 4,
    "hold_seconds": 4,
    "easing": "easeOutCubic",
    "annotation_text": "From first venue Jan 2024",
    "annotation_appears_at_frame": 60,
    "brand_color_hex": "#F25C24",
    "background_color_hex": "#F8F7F3",
    "font_family": "Plus Jakarta Sans"
  }
}
```

#### Reusable component spec (operator-side)
```tsx
// src/compositions/TractionCounter.tsx
// Uses Remotion's interpolate() to tween start_value → end_value over ramp_seconds
// Uses spring() for the annotation_text fade-in at annotation_appears_at_frame
// Renders metric_label above counter, annotation_text below
// IDR_short formatting: 12_000_000_000 → "Rp 12 M"
```

---

### TYPE B — Animated chart (data revealing line by line)

#### Use case
Slide 6 line chart where the line draws itself in over 3 seconds, then annotation arrows appear pointing to inflection points.

#### Config schema
```json
{
  "composition_id": "slide-06-traction-line",
  "component_file": "src/compositions/AnimatedLineChart.tsx",
  "fps": 30,
  "duration_in_frames": 240,
  "aspect_ratio": "16:9",
  "width": 1920,
  "height": 1080,
  "props": {
    "x_axis_label": "Month",
    "y_axis_label": "Monthly GMV (IDR)",
    "data_points": [
      {"x": "Jan-24", "y": 80000000},
      {"x": "Apr-24", "y": 240000000},
      {"x": "Jul-24", "y": 800000000},
      {"x": "Oct-24", "y": 2100000000},
      {"x": "Jan-25", "y": 4500000000},
      {"x": "Apr-25", "y": 7200000000},
      {"x": "Jul-25", "y": 9100000000},
      {"x": "Oct-25", "y": 10800000000},
      {"x": "Jan-26", "y": 11500000000},
      {"x": "Apr-26", "y": 12000000000}
    ],
    "line_draw_seconds": 3,
    "line_color_hex": "#F25C24",
    "annotations": [
      {"at_x_index": 4, "text": "First mall pilot — Senayan City", "appear_at_frame": 100, "arrow_direction": "down"}
    ],
    "logo_lockup_appear_at_frame": 180,
    "logo_lockup_assets": ["senayan_city.svg", "kota_kasablanka.svg", "lippo_kemang.svg", "pondok_indah.svg", "bsd_junction.svg", "plaza_indonesia.svg"],
    "background_color_hex": "#F8F7F3",
    "font_family": "Plus Jakarta Sans",
    "source_line_text": "Internal data, April 2026"
  }
}
```

---

### TYPE C — Animated map (venue pins appearing)

#### Use case
A map of Indonesia where venue pins appear sequentially, one every 200ms, illustrating geographic spread.

#### Config schema
```json
{
  "composition_id": "slide-04-market-pin-map",
  "component_file": "src/compositions/AnimatedPinMap.tsx",
  "fps": 30,
  "duration_in_frames": 180,
  "aspect_ratio": "16:9",
  "width": 1920,
  "height": 1080,
  "props": {
    "map_image_path": "src/assets/indonesia-map.svg",
    "pin_locations": [
      {"city": "Jakarta", "lat": -6.2088, "lng": 106.8456, "appear_at_frame": 30, "venue_count": 23},
      {"city": "Bandung", "lat": -6.9175, "lng": 107.6191, "appear_at_frame": 50, "venue_count": 8},
      {"city": "Surabaya", "lat": -7.2575, "lng": 112.7521, "appear_at_frame": 70, "venue_count": 11},
      {"city": "Medan", "lat": 3.5952, "lng": 98.6722, "appear_at_frame": 90, "venue_count": 5}
    ],
    "pin_color_hex": "#F25C24",
    "pin_size_px": 16,
    "pin_pulse_animation": true,
    "city_label_appear_offset_frames": 5,
    "total_count_label_appear_at_frame": 150,
    "total_count_text": "47 venues live · 4 cities",
    "background_color_hex": "#F8F7F3"
  }
}
```

---

### TYPE D — Live data ticker (advanced; web-based decks only)

#### Use case
For decks rendered in the browser (Gamma, Pitch.com), bind a live API to show current MRR / transactions per minute.

#### Config schema
```json
{
  "composition_id": "live-data-ticker",
  "component_file": "src/compositions/LiveTicker.tsx",
  "fps": 30,
  "duration_in_frames": 30,
  "aspect_ratio": "16:9",
  "props": {
    "data_source": {
      "endpoint": "https://api.indusia.id/v1/public/live-stats",
      "polling_interval_seconds": 5,
      "auth_header": "x-public-key: <PUBLIC_API_KEY>"
    },
    "metrics_to_display": [
      {"key": "current_mrr", "label": "MRR (live)", "format": "IDR_short"},
      {"key": "tx_per_minute", "label": "Tx/min", "format": "int"},
      {"key": "active_venues", "label": "Live venues", "format": "int"}
    ],
    "fallback_static_values": {
      "current_mrr": 12000000000,
      "tx_per_minute": 2400,
      "active_venues": 47
    },
    "brand_color_hex": "#F25C24"
  }
}
```

> **Caveat:** live-data tickers only work in browser-rendered decks (Gamma, Pitch.com, Reveal.js) where the slide can poll an API. They do NOT work in static PDF / PPTX exports — fall back to `fallback_static_values` in those formats.

---

## 4. Output JSON schema (remotion.config.json)

The plugin emits one consolidated `remotion.config.json` listing all slides with programmatic motion:

```json
{
  "schema_version": "1.0",
  "deck_id": "indusia-merchant-investor-deck-2026q2",
  "fps": 30,
  "default_resolution": {"width": 1920, "height": 1080},
  "compositions": [
    {
      "slide": 4,
      "type": "animated_pin_map",
      "config": { /* TYPE C config above */ }
    },
    {
      "slide": 6,
      "type": "animated_line_chart",
      "config": { /* TYPE B config above */ }
    },
    {
      "slide": 6,
      "type": "animated_counter",
      "config": { /* TYPE A config above */ }
    }
  ],
  "operator_instructions": "Run `npx remotion render` from your Remotion project root with each composition_id to produce per-slide MP4 files. Embed the MP4s into your final deck (Canva accepts MP4 embeds; Pitch.com supports MP4 backgrounds).",
  "skip_if_unavailable": true
}
```

---

## 5. The "is Remotion worth it?" gate

Remotion has setup overhead (Node project, render time, build pipeline). Before flagging a slide as `programmatic_motion: true`, answer:

1. Does this need precise timing (frame-accurate)? If no → use Seedance or static.
2. Does this need to be re-rendered with different data (annual deck refresh)? If yes → Remotion shines.
3. Does the team already have a Remotion project? If no → defer; first-time setup ≈ 1 day.
4. Will this go on a static PDF or web-only? If PDF → Remotion still works (renders to MP4 → embed in PDF page).

If 2/4 answers favor Remotion, flag the slide. Otherwise, fall back to static or Seedance.

---

## 6. Skip-if-unavailable mode

If the operator's environment doesn't have Remotion configured, the plugin's `remotion.config.json` is still emitted but with `skip_if_unavailable: true` flag. Downstream tooling sees the flag and:

- Falls back to static infographic for the slide
- Logs the skipped composition for later rendering
- Does NOT block the deck publication

This means Remotion is opt-in: decks ship without motion if no Remotion infrastructure exists.
