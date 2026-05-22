---
slug: indusia-tech
name: INDUSIA Tech
mood: [industrial, technical, premium, isometric]
suitable_for: [brochure-product, deck-b2b, catalog-product, deck-hybrid]
suitable_audience: B2B owners and decision-makers in logistik, manufacturing, fleet management, palm oil downstream, industrial automation, and IoT hardware
---

## Identity & Mood

A dark, engineered look that signals technical seriousness without resorting to corporate-stock cliché. Reads like a product datasheet crossed with a flight-deck UI: precision grids, instrument typography, isometric hardware renders glowing against deep navy. Used by INDUSIA AI Logistik for the flagship product brochure — proven to differentiate against the sea of generic blue-gradient B2B SaaS decks. Mood signals: engineered, measurable, deployable, premium-but-honest. Avoid any tone that drifts into "futuristic dystopia" or generic tech-bro neon.

## Color Palette

| Role | Hex | Notes |
|------|-----|-------|
| Background (primary) | `#0B1929` | Dark navy — main slide/spread canvas |
| Background (deepest) | `#050E1A` | Used for hero/cover pages and dramatic full-bleeds |
| Secondary panel | `#1E3A8A` | Deep blue — section dividers, sidebar panels |
| Accent (cyan) | `#00D9FF` | Cyan — data highlight, callout numbers, UI edge glow |
| Accent (gold) | `#FFB800` | Warm gold — used SPARINGLY for premium emphasis and final CTA only |
| Text (light) | `#F8FAFC` | Near-white — primary body and headlines on dark bg |
| Text (muted) | `#94A3B8` | Slate — captions, metadata, footnotes |

CMYK fallback for print: convert cyan to spot Pantone 2995 C, gold to Pantone 130 C for consistent press output.

## Typography

- **Display:** Inter 700 Bold and Inter 800 ExtraBold — used for slide headlines (40-72pt), product names, and large KPI numbers. Inter ships open-source via Google Fonts and Rasmus Andersson's foundry; safe for commercial print.
- **Body:** Inter 400 Regular and Inter 500 Medium — running copy, captions, table cells. 9-11pt for print body, 14-16pt for screen.
- **Mono (technical):** JetBrains Mono 400 Regular and JetBrains Mono 700 Bold — used for technical specs, model numbers, latency metrics, code snippets, and data-table values. Alternate: IBM Plex Mono 400 if JetBrains Mono unavailable.

Pairing rule: never mix in a third sans-serif. Inter + JetBrains Mono only. Numerals always tabular-figures for spec tables.

## Illustration / Image Style

Isometric 3D renders (Blender 4.x or Cinema 4D output) on dark backdrops with controlled edge-light. Technical product visualizations — trucks, IoT sensors, racks, sawit harvesters — rendered at 30-degree isometric angles with neon cyan line-tracing along key edges. Holographic UI overlays composited above the hardware (transparent dashboard panels, telemetry numbers floating in mid-air). Materials should read as brushed aluminum, anodized navy, matte rubber — not glossy plastic. Reference anchor for NB2 prompts: "INDUSIA AI Logistik brochure cover — isometric refrigerated truck on dark navy backdrop, cyan edge-light tracing the trailer outline, holographic fleet dashboard panel floating above the cab, gold sensor LEDs along the chassis, deep shadow grounding, no human figures, 3/4 hero angle, 4k product-render quality."

## Layout Grammar

- **Grid:** 12-column on screen (deck) or 8-column on A4 print, 24px gutter, 64px outer margin. Hero pages allow full-bleed image with a 4-column overlay panel.
- **Spacing scale:** 8pt baseline — 8, 16, 24, 32, 48, 64, 96, 128. Never use intermediate values (no 12, no 20).
- **Heading scale (deck slide):** display 72pt, H1 48pt, H2 32pt, H3 24pt, body 16pt, caption 12pt. Line-height 1.15 for display, 1.4 for body.
- **Heading scale (print A4):** H1 36pt, H2 24pt, H3 18pt, body 10pt, caption 8pt.
- **Rules:** every page anchors at least one hard horizontal rule (1px cyan or 2px gold) to signal precision. Numbers in callouts are 2-3x the size of surrounding body text.

## Anti-AI-Slop Banlist for This Theme

1. Generic purple-blue gradient backdrop — banned. Use solid `#0B1929` or two-stop navy-to-deeper-navy radial only; cyan and gold are accent colors NEVER used as gradient stops on backgrounds.
2. Stock-photo handshakes, generic "business team in glass office", or smiling-diverse-staff photography — banned. Replace with a real product render, factory-floor photo, or schematic diagram. If no real photo exists, generate isometric render instead.
3. Glassmorphism overuse — maximum ONE frosted-glass panel per spread. Banned: stacking glass cards on glass cards, neon-glow rings around every element, "Y2K aero" sparkles.
4. Cyan applied to body text on dark bg — accessibility fail and reads "amateur tech blog". Cyan is for 1-3 word highlights and edge-light only.
5. Three-stop neon gradients (pink-purple-cyan or similar) — banned. This theme is two-tone foundation with disciplined accent.

## Real-World Reference

INDUSIA AI Logistik product brochure (indusia.ai) — origin of this theme. Adjacent references: Nike SNKRS app product detail pages (dark-mode isometric product renders), Notion product landing pages (calibrated dark with single bright accent), Linear.app changelog spreads (precision typography on near-black), and the Apple Pro Display XDR press deck (premium hardware photography on controlled dark backdrop).
