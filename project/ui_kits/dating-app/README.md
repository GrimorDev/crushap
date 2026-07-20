# Crushap — Dating App UI Kit

Interactive click-through recreation of the core Crushap mobile app flow, built from Crushap design system components (`../../components/`) and tokens (`../../styles.css`).

Screens: Onboarding (welcome → name → interests) → Discover (swipe cards, like/pass/superlike) → Match overlay → Chat → Profile → Filters. A small route switcher (top-right, once past onboarding) jumps between screens directly; the Discover screen's like button also triggers the Match overlay.

Photos are `<image-slot>` placeholders — drop real photos onto the swipe card and profile photo to preview with real imagery.

Built from scratch (no attached codebase/Figma) per `readme.md` at the project root — this is a design proposal, not an extraction from an existing Crushap product.
