# Spike: how to render an interactive figure island in mystmd

**Question:** the interactive figure needs client-side behavior (read the case
contract, show editable params, eventually re-simulate). How does that plug into
a mystmd site? **Answer: two viable mechanisms, with a real tradeoff — a
decision is needed.** This spike establishes the landscape and demonstrates one
working path.

## What does NOT work (ruled out)

- **Raw HTML from the directive.** mystmd's book-theme sanitizes raw HTML: it
  strips `data-*` attributes and `<script>` tags. An embedded `<div data-case>`
  survives only as a bare `<div class>` (verified). So the contract can't ride
  in as HTML attributes, and inline scripts vanish.
- **A config hook to add a page script.** The theme exposes only
  `analytics_google` / `analytics_plausible` — no general "add script/head"
  option. `allowDangerousHtml` exists but only inside mystmd's internal AST→HTML
  libraries; it isn't a user knob and wouldn't execute scripts through the
  theme's React render anyway.

What *does* survive sanitization: **class names**. So the directive encodes the
plot id as `mbe-plot-<id>` on the figure, and the contract is published as a
static file at `/cases/<id>.json`.

## Two viable mechanisms

### Option A — post-build injection (demonstrated here)

A Node step (`scripts/postbuild.mjs`) runs after `myst build --html`: it copies
the island assets into the built site and injects `<link>`/`<script>` into each
page *after* mystmd (bypassing sanitization). The island (`public/mbe-island.js`)
finds `.mbe-figure.interactive`, reads the id from the class, fetches
`/cases/<id>.json`, and renders the panel.

- ✅ Lightweight; no theme to maintain; wired into `npm run build` today.
- ✅ Verified end-to-end in the static build (tags injected, assets served,
  figures targetable, contract fetchable).
- ⚠️ The built site hydrates as a React (Remix) app, so the island mounts after
  `load` and appends to figure nodes React has settled. Mitigated with a
  post-load + retry schedule; robust for content pages that don't re-render, but
  it is enhancement-on-top-of-React, not part of React's tree.
- ⚠️ Does **not** run under `myst start` (dev preview) — only the built site.

### Option B — custom mystmd theme (robust, heavier)

Point `myst.yml` `site.template` at a **local theme** (mystmd supports a template
path) that extends `@myst-theme/book` and registers a React renderer for the
`mbe-figure` node. The island becomes part of React's tree.

- ✅ Idiomatic; robust against hydration; works in dev and build alike.
- ✅ Natural home for Jony's skeleton as a real component receiving the contract
  as props.
- ⚠️ The published book-theme is a **pre-built Remix app** (no source in the
  fetched template), so this means forking `myst-templates/book-theme`, adding
  the component, and building/maintaining a theme package.

## Recommendation

- **For the slice / preview:** Option A. It's in place now and lets Michael see
  a working island without a theme commitment.
- **For production:** Option B, *if* interactivity must work in dev and be fully
  hydration-safe. The generic component (Jony's skeleton: `data-state` root,
  no disclosure toggle, params from first paint, static-plot base + canvas
  overlay, `data-skin`×`data-mode` tokens) is authored once and drops into
  whichever mechanism is chosen — the skeleton is mechanism-agnostic.

**Decision needed from Michael:** ship the island via post-build (A) for now, or
invest in a local theme (B) for a dev-and-prod, hydration-safe component? The
current `mbe-island.js` is a mechanism-proof stub (still has a toggle; the real
build follows Jony's no-toggle skeleton) — intentionally minimal until the
mechanism is chosen.
