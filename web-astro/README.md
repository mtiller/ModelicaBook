# `web-astro/` — Astro + Starlight slice (MIC-84 bake-off)

The same first-order chapter as the mystmd slice (`../web`), rebuilt on **Astro +
Starlight** so the two platforms can be compared head-to-head — tracked in
[MIC-126](https://linear.app/mtiller/issue/MIC-126).

## Quick start

```bash
cd web-astro
npm install
npm run dev      # http://localhost:4321
npm run build    # static site into dist/
```

Node 20+ (CI uses 26).

## Why this exists / what it proves

The open question from the mystmd slice was the **interactive figure**. In mystmd
it can't be a drop-in component (no MDX; the "renderer" plugin type is
unimplemented; the theme sanitizes raw HTML), so it needed either a theme fork or
a post-build injection hack.

In Astro it's a **native MDX component** — the thing you wanted:

```mdx
import SimFigure from '../../components/SimFigure.astro';

<SimFigure id="FO" interactive caption="Simulation of FirstOrder" />
```

Verified in the built HTML (`dist/first-order/index.html`):

- the structured contract rides straight through as `data-case` on the figure
  (Astro does **not** sanitize component output — this is precisely what mystmd
  stripped);
- the island `<script>` is **bundled and shipped by Astro** (no injection step);
- all four static plots, KaTeX math, and Modelica code sourced from the actual
  `.mo` files via `?raw` import (single source of truth, parity with
  `literalinclude`).

**No theme fork. No post-build step. No sanitizer fight.** Additional figure or
island types = more components you import — upstream is never touched.

## Layout

| Path | Purpose |
|------|---------|
| `astro.config.mjs` | Starlight + math plugins (`remark-math`/`rehype-katex`) + `?raw` fs access |
| `src/content/docs/first-order.mdx` | The converted chapter (MDX; imports the figure component + `.mo` code) |
| `src/components/SimFigure.astro` | The interactive figure island (Jony's skeleton; `data-skin`×`data-mode` skinnable) |
| `src/cases/*.json` + `index.ts` | The structured figure contract (from `_generate_casedata`, MIC-87) |
| `src/styles/skins.css` | Jony's A/B/C token system + structural CSS |
| `public/plots/*.svg` | Static plots (from the sim pipeline; fetched from the live site for the slice) |

## Native-component win vs. plugin-fill gaps

Native / out-of-the-box (no forks):

- MDX custom components (the island) — the decisive win.
- Math — `remark-math` + `rehype-katex` (npm install + config).
- Code from source files — `?raw` import + Starlight `<Code>`.
- Skinning — CSS custom properties (`data-skin` × `data-mode`).
- i18n, search (Pagefind), sidebar/nav — Starlight built-ins.

Gaps vs. mystmd's native scientific authoring (bridgeable, but real):

- **Auto figure/equation numbering + `:ref:`-style cross-references.** mystmd does
  this natively; here it needs a remark plugin (a build-time plugin, not a fork).
  The heaviest known gap — validate before full migration.
- **Modelica syntax highlighting.** Shiki has no Modelica grammar, so code is
  rendered as plain text (`lang="text"`); mystmd is no better here. A TextMate
  grammar can be added later.

## Deferred (same as the mystmd slice)

Bulk chapter conversion; i18n (see the PR for the translation analysis); live sim
API (MIC-86); final visual design pick.
