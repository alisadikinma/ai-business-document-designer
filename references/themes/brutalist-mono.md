---
slug: brutalist-mono
name: Brutalist Mono
mood: [raw, unapologetic, type-driven, anti-design]
suitable_for: [portfolio-personal, service-flyer, brochure-product, portfolio-agency]
suitable_audience: contemporary art galleries, music labels and record imprints, indie zines and small-press publishers, fashion challenger brands, experimental design studios, cultural events and underground festivals
---

## Identity & Mood

The anti-design tradition made systematic. Wolfgang Weingart's Basel work, David Carson's Ray Gun, Bloomberg Businessweek covers under Richard Turley, the MetaLabel.xyz visual system, and the long lineage of zine culture from Riot Grrrl to contemporary independent publishing. Type at extreme scale (200pt+ headlines are normal here), intentional grid violations, photocopy and risograph texture, found imagery collaged without apology. The theme expects the viewer to lean in and decode rather than be served pre-chewed information. The fail-state is when brutalism gets mistaken for laziness — every grid violation must look deliberate, not accidental.

## Color Palette

| Role | Hex | Notes |
|------|-----|-------|
| Primary | `#000000` | True black — the workhorse |
| Secondary | `#FFFFFF` | True white — page background |
| Accent (optional) | `#FF1F1F` | Risograph red — used ONCE per spread, never twice |
| Accent alternate | `#1F4FFF` | Risograph blue — alternate single-accent option |
| Accent alternate | `#FFE100` | Risograph yellow — alternate single-accent option |
| Texture overlay | `#D9D9D9` | Photocopy grain grey, low-opacity texture layer only |

Discipline: TWO-color minimum (black + white). If accent is used, ONE accent only per spread, applied ONCE — not as a system color repeating across elements. Pick red OR blue OR yellow per project and commit to it.

## Typography

- **Display (raw):** ABC Diatype Bold or Times New Roman 900 Black at extreme scale (120-360pt) — headlines that bleed off the page edge are encouraged. Free fallback: Arial Black at 900 weight.
- **Body:** Arial Regular or Helvetica 55 Roman at 8-11pt — intentionally generic, intentionally not-precious. Body type stays small to amplify display contrast.
- **Mono (optional):** JetBrains Mono Regular for footnotes and microcopy in margins. Use sparingly.

Pairing rule: mixed display weights WITHIN one hierarchy ARE allowed in this theme (the only theme where this is true) — a headline can mix Times Roman 900 with Arial Black inside the same line as a deliberate clash. Body stays uniform and unremarkable.

## Illustration / Image Style

Photocopy distortion, risograph misregistration, paper texture overlays, intentional misalignment with the underlying grid, found imagery (collaged from print archives, screenshots, scanned objects), no rendered 3D, no AI-looking illustrations. Photography is processed through high-contrast threshold, halftone, or duotone to flatten tonal range. Reference anchor for NB2 prompts: "High-contrast black-and-white photocopy of a found object, blown out shadows and clipped highlights, visible photocopy distortion and toner streaks along one edge, paper texture, slight rotation off-axis, zine aesthetic, no color, no shading, no graphic decoration, reads like a 1990s independent music magazine cover."

## Layout Grammar

- **Grid:** an underlying 12-column grid exists, BUT elements deliberately break it. Headlines run off the page. Body text columns shift mid-column. The grid is a referee, not a fence.
- **Spacing scale:** 4pt baseline used WHEN spacing follows the grid; spacing breaks are encouraged for emphasis (a single 200pt gap mid-page is valid).
- **Heading scale (screen):** display 240pt, H1 96pt, H2 32pt, body 11pt, caption 8pt. Extreme contrast between display and body is the theme's signature move.
- **Heading scale (print A4):** display 180pt (bleeds edge-to-edge), H1 64pt, H2 18pt, body 9pt, caption 7pt.
- **Rules:** thick black bars (4-12pt) as section dividers, often running edge-to-edge. Or no rules at all and let whitespace + type do the work.

## Anti-AI-Slop Banlist for This Theme

1. Smooth gradients — banned absolutely. Color transitions happen via risograph misregistration or halftone dot patterns only, never via smooth CSS gradient.
2. Anti-aliased smooth edges on every element — banned. Some pixelation, some toner streak, some photocopy edge degradation IS the aesthetic. Crisp Bezier curves everywhere reads as "vector art trying to look brutalist".
3. "Tasteful" decoration — banned in its entirety. No subtle ornamental flourishes, no soft accent dots, no decorative thin lines. The theme is unapologetic; tasteful restraint belongs in `minimalist-editorial`.
4. Symmetrical center-balanced layouts — banned. The grid is broken on purpose; symmetry signals corporate compromise.
5. Three or more accent colors — banned. The discipline is one accent per project, applied once per spread.

## Real-World Reference

Bloomberg Businessweek covers (Richard Turley era), Idea Magazine (Japan), MetaLabel.xyz publishing platform, Tunnel Bar and Sub Pop Records print materials, Pen+ magazine layouts, the Brutalist Websites archive (brutalist-websites.com), Wolfgang Weingart's Basel School work, and David Carson's Ray Gun magazine 1992-1995.
