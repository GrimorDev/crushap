# Crushap Design System

## Context

Crushap is a mobile dating app. This design system was built from scratch — no codebase, Figma file, or brand guidelines were attached, so there is no existing product to ground against. Everything here (visual direction, tone, component set, screens) was designed based on the user's brief: a modern, simpler alternative to Tinder/Badoo/Boo, dark and premium with neon accents, confident/flirty in tone.

**Sources:** none attached. If a codebase, Figma file, or brand deck exists, attach it and this system should be rebuilt/reconciled against it — right now every value here is a design decision, not an extraction.

No logo was supplied. Wherever a mark would go, the wordmark "crushap" is set in plain type (Space Grotesk). Do not use, recreate, or approximate any other dating app's logo or trade dress.

## Content fundamentals

- **Voice**: confident and a little flirty, never crude. Short, punchy sentences. Talks like a clever friend hyping you up before a date, not a corporate product.
- **Person**: second person ("you/your") in-product copy ("Find your spark tonight"); first person plural only for policy/safety copy ("We verify every profile").
- **Casing**: sentence case everywhere — headlines, buttons, labels. No ALL CAPS except tiny caption-level tags (e.g. "NEW MATCH") which use letter-spacing instead of shouting.
- **Emoji**: not used in UI chrome, system copy, or buttons. A single 🔥 is acceptable only inside user-generated content mockups (bios, chat), never in Crushap's own voice.
- **Examples**: "It's a match!" / "Find your spark tonight" / "You and Mia liked each other." / "Send a Message" / "Not now".
- **Errors/empty states**: warm, not alarmist — reassure, then give the next action.

## Visual foundations

- **Palette**: near-black plum background (`--black-1 #0B0710`) with layered dark surfaces for elevation, one saturated neon-pink accent (`--pink-1 #FF2E63`) for all primary actions, and a warm gold (`--gold-1 #FFC145`) reserved for premium/superlike moments. Semantic mapping: pink = like/primary, gold = superlike/premium, green = online/verified, red = pass.
- **Type**: two-family system. Space Grotesk (display/headings) — geometric, confident, used for names/titles/screen headers. Manrope (body/UI) — warm and highly readable, used for bios, buttons, captions. No serif anywhere. Both are Google Fonts CDN-loaded as stand-ins (see Iconography/Fonts note below).
- **Spacing**: 4px base scale (`--space-1` 4px … `--space-10` 72px). Generous padding on cards and screens; nothing feels cramped.
- **Corner radii**: soft but not childish — 10/16/24/32px scale plus a full pill for buttons/chips/nav. Photo cards use the largest radius (`--radius-xl`, 32px).
- **Backgrounds**: full-bleed photography on swipe cards and match screens with a bottom-to-top dark scrim gradient for text legibility — no patterns, no illustration textures, no busy gradients on UI chrome itself.
- **Gradients**: exactly one, `--gradient-primary` (pink → deep pink), reserved for primary buttons, active chips, and the match-overlay glow. Never used as a full-screen background.
- **Animation**: fast and physical, not bouncy-cartoonish. Standard ease `cubic-bezier(.22,1,.36,1)` for most transitions (120–220ms); a springier ease reserved for icon-button taps and card actions to feel tactile.
- **Hover states**: subtle lift (`translateY(-1px/-2px)`) plus a touch of `brightness()`, not a color swap. Buttons/icon-buttons only — this is primarily a touch/mobile system.
- **Press states**: scale down to ~0.96, no color change. Immediate, no delay.
- **Borders**: 1px hairlines at low opacity (`--border-subtle` 8%, `--border-strong` 16% white) — never a solid brand-colored border on containers.
- **Shadows**: soft, warm-black elevation shadows for cards/modals; a distinct pink "glow" shadow (`--shadow-glow-primary`) used only on primary actions and the match overlay, doubling as a focus/emphasis cue.
- **Blur/glass**: frosted glass (`blur(20px)` + translucent dark fill) on the bottom nav and the match overlay scrim — the only two places blur appears, both because content scrolls/sits behind them.
- **Imagery color vibe**: warm-toned, natural light, no B&W, no heavy grain — imagery is the emotional/human layer against an otherwise dark, graphic UI. (No real photography is bundled; UI kit screens use placeholder photo slots for the user to drop real images into.)
- **Layout**: mobile-first, single-column, bottom-anchored primary actions (nav bar, swipe buttons) so they sit under the thumb; screens designed at a 390px mobile width.
- **Transparency**: used sparingly — nav bar, tag pills over photos, and modal scrims only.

## Iconography

- Icon set: [Lucide](https://lucide.dev) (open-source, MIT), copied directly into `assets/icons/` as SVGs — not hand-drawn, not emoji, not a webfont. This is a substitution (no icon system was provided) and is flagged here.
- Icons are consumed as monochrome glyphs via the `Icon` component, which CSS-masks the SVG so it can be tinted with any token color (`currentColor` by default).
- Copied set: arrow-left, bell, camera, check, chevron-left, flame, heart, image, map-pin, message-circle, search, send, settings, shield-check, sliders-horizontal, sparkles, star, undo-2, user, x, zap.
- No emoji, no unicode-character icons, in Crushap's own UI.

## Fonts note

Space Grotesk and Manrope are loaded from Google Fonts CDN (`tokens/fonts.css`) as a stand-in — no brand font files were provided. **Flag for the user**: if Crushap has actual brand typefaces, please attach the font files (and any brand guideline) so this can be corrected.

## Intentional additions

No source defined a component inventory, so a standard set was authored, sized to a dating app's needs: `Icon`, `Button`, `IconButton`, `Input`, `Chip`, `Avatar`, `Badge`, `BottomNav`, `SwipeCard`, `MatchOverlay`.

## Index

- `styles.css` — root stylesheet (imports only). `tokens/` — colors, typography, spacing, effects, fonts.
- `assets/icons/` — Lucide SVG icon set.
- `guidelines/` — foundation specimen cards (Colors, Type, Spacing, Brand groups).
- `components/core/` — Icon, Button, IconButton, Chip, Avatar, Badge.
- `components/forms/` — Input.
- `components/navigation/` — BottomNav.
- `components/dating/` — SwipeCard, MatchOverlay (Crushap-specific primitives).
- `ui_kits/dating-app/` — interactive click-through recreation: onboarding, swipe/discover, match, chat, profile, filters.
- `thumbnail.html` — project homepage tile.
- `SKILL.md` — portable skill file for use outside this environment.
