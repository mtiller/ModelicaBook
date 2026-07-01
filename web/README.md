# `web/` — MyST rendering (MIC-84 vertical slice)

A [mystmd](https://mystmd.org) site that renders the book, replacing the legacy
Sphinx → `.fjson` → re-parse-into-React (`nextgen`) pipeline. This directory is
the **vertical slice** from [MIC-125](https://linear.app/mtiller/issue/MIC-125):
one chapter (`content/first-order.md`) converted end-to-end to prove the
pipeline before bulk conversion.

## Quick start

```bash
cd web
npm install
npm start          # dev server at http://localhost:3000
npm run build      # static HTML into _build/html
```

Node 20+ (CI uses 26).

## Layout

| Path | Purpose |
|------|---------|
| `myst.yml` | Project + site config; registers the figure plugin |
| `content/first-order.md` | The converted chapter (was `text/source/behavior/equations/first_order.rst`) |
| `content/_plots/*.svg` | Static plots. In the real pipeline these come from the specs DSL → DVC → matplotlib chain (MIC-87). For the slice they were fetched from the live site. |
| `public/cases/<id>.json` | **Structured figure contract** (model name, stopTime, tol, ncp, mods, vars) — emitted by `_generate_casedata` (MIC-87). |
| `plugins/mbe-figure.mjs` | Custom `mbe-figure` directive (see below) |
| `public/mbe-island.{js,css}` | Client-side interactive island — ready but not yet wired (see "next step") |

## What the slice proves (working today)

`npm run build` produces a static site containing the chapter with:

- prose, headings, cross-references, admonitions;
- math via KaTeX (`$...$`, `$$...$$`);
- Modelica source via `{literalinclude}` (with `:lines:` / `:emphasize-lines:`);
- all four static plots rendered through the `mbe-figure` directive.

### The `mbe-figure` directive

Replaces the legacy `.. plot::` + `:class: interactive` + `nextgen`
`interactiveInjector`. That injector recovered a model id by string-slicing an
image `src` (`src.slice(16, src.length-4)`). Here the id is explicit and the
figure is backed by the **structured contract** in `public/cases/<id>.json` —
the same data the old build already generated and then discarded.

```markdown
```{mbe-figure} FO
:interactive:
:caption: Simulation of FirstOrder
```
```

**Byte-verify done:** the directive's id maps to the case `name` exactly as the
specs DSL declares —
`FO → ModelicaByExample.BasicEquations.SimpleExample.FirstOrder`,
`FOE → …FirstOrderExperiment` (`text/specs.py:13,24`). The new contract is
provably correct.

## Interactive island (next step — needs a theme component)

The "adjust parameters" island is **not yet hydrated in the built site.**
mystmd's book-theme sanitizes raw HTML (strips `data-*` and `<script>`) and does
not auto-serve a `public/` dir, so JS + data can't be drop-injected. The
supported path is a **custom mystmd theme component** registered for a figure
node, which can bundle its JS and receive the contract as props.

Groundwork already in place for that component:

- interactive figures are tagged `mbe-figure interactive mbe-plot-<id>` (class
  survives sanitization), so the component/script can find them and read the id;
- `public/cases/<id>.json` holds the contract;
- `public/mbe-island.{js,css}` implements the progressive-enhancement panel
  (static plot stays as the base case; panel shows model + experiment params;
  "Re-run" disabled pending the live sim API, MIC-86).

This step is intentionally paired with Jony's figure-interaction design.

## Adding another chapter

1. Convert `text/source/<...>.rst` → `content/<name>.md` (`rst-to-myst` + cleanup
   of directives: `.. plot::` → `{mbe-figure}`, `:ref:` → `[](#target)`,
   `.. topic::` → `{admonition}`).
2. Add the chapter to `toc:` in `myst.yml`.
3. Drop its plots in `content/_plots/` and any interactive contracts in
   `public/cases/`.

## Not in this slice (deferred)

- Bulk conversion of the other 91 chapters.
- i18n / gettext catalogs (MIC-92) — slice is English-only.
- Live simulation API (MIC-86).
- Final visual design (Jony); slice uses the default book-theme.
