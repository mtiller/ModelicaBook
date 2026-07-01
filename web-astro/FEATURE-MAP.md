# Sphinx → Astro/Starlight feature parity map

Every Sphinx feature the book actually uses (counted across `text/source/**/*.rst`)
mapped to its Astro + Starlight equivalent. Status legend:

- **Native** — built into Astro/Starlight, no extra work.
- **Plugin** — an npm remark/rehype plugin + config (not a fork).
- **Component** — an MDX component we author (like `SimFigure`).
- **Gap** — no drop-in; needs a custom plugin or a product decision. Flagged.

## Directives

| Sphinx directive | Uses | Astro/Starlight equivalent | Status | Notes |
|---|---:|---|---|---|
| `code-block` | 293 | Fenced ` ```lang ` via Expressive Code | **Native** | Shipped with Starlight. Modelica has no Shiki grammar → renders as plain text (add a TextMate grammar later; mystmd is no better). |
| `literalinclude` | 285 | `?raw` import + `<Code>` | **Native** | Demonstrated in the slice — code stays sourced from the `.mo` files. `:lines:`/`:emphasize-lines:` = a slice/mark helper. |
| `index` | 232 | Pagefind full-text search (built in) | **Gap→decision** | Starlight ships site search, which largely supersedes a hand-maintained index. A literal back-of-book index page would need a small remark plugin. Recommend: drop in favor of search unless a print index is required. |
| `math` (block) / `:math:` (inline) | 106 / 404 | `remark-math` + `rehype-katex` | **Plugin** | Wired in the slice; renders via KaTeX. |
| `plot` + `:class: interactive` | 104 | `<SimFigure>` MDX component | **Component** | The bake-off centerpiece — native MDX component, no fork. |
| `figure` | 80 | Markdown image / `<Figure>` component | **Native** | Rendering is native; **auto-numbering** ties to the cross-ref gap below. |
| `toctree` | 21 | Starlight `sidebar` (manual or `autogenerate`) | **Native** | Different model — nav is site config, not in-content. |
| `topic` | 18 | `:::note` / `<Aside>` | **Native** | Starlight asides. |
| `todo` / `todolist` | 18 / 1 | — | **Decision** | Author-only tooling. Recommend dropping (or a remark comment stripped at build). |
| `note` | 4 | `:::note` aside | **Native** | |
| `only` | 3 | MDX conditional / build flag | **Native** | MDX handles conditional content directly. |
| `raw` | 2 | Inline HTML in MDX | **Native** | Astro passes HTML through (no sanitization). |
| `ifconfig` | 1 | MDX conditional | **Native** | |

## Roles

| Sphinx role | Uses | Astro/Starlight equivalent | Status | Notes |
|---|---:|---|---|---|
| `:math:` | 404 | `remark-math` inline `$...$` | **Plugin** | Same plugin as block math. |
| `:ref:` | 310 | Cross-references via `plugins/remark-xref.mjs` | **Resolved (plugin built)** | The custom remark plugin now: records `{/* #label */}` heading anchors (RST labels), numbers sections + figures, and resolves empty-text `[](#label)` refs to the target **title** (Sphinx `:ref:` default) or "Figure N". Verified: `[](#first-order-doc)`→"Adding Some Documentation", `[](#FO)`→"Figure 1". Remaining scale-up: persist the label map across pages for cross-**document** refs (trivial extension). |

## Cross-cutting

| Concern | Astro/Starlight | Status |
|---|---|---|
| Site search | Pagefind (built in) | **Native** |
| Sidebar / nav / prev-next | Starlight built-ins | **Native** |
| Syntax highlighting | Expressive Code (Shiki) | **Native** (no Modelica grammar) |
| Dark/light mode | Starlight built-in + our `data-mode` tokens | **Native** |
| i18n / translations | po4a bridge to gettext (see `i18n/`) | **Tooling** — see `i18n/README.md` |
| PDF / ebook export | Pandoc (see `print/`) | **Resolved (scaffolded)** — not Astro's job; the same Markdown source → Pandoc → PDF (Typst/xelatex) + EPUB. `print/build-print-md.mjs` lowers MDX components to print form (interactive figure → static plot). Print toolchain is a dependency exactly as xelatex is today (MIC-85). |

## Summary

- **Native or one-plugin-install:** code, literalinclude, math, figures, admonitions, toctree/nav, search, conditional content, raw HTML — the bulk of the book.
- **Author once as a component:** interactive figures (done).
- **Previously-open items, now closed:**
  1. **`:ref:` cross-references + auto-numbering** (310 uses) — `plugins/remark-xref.mjs`, built + verified.
  2. **PDF / eBook** — Pandoc pipeline scaffolded in `print/` (MDX lowered to print Markdown; components → static figures).
  3. **i18n** — the po4a bridge (`i18n/`), reusing existing translations with zero re-translation.
- **Decisions, not work:** `index` (→ search), `todo` (→ drop).
- **Remaining true gap:** none of the *used* features. The only scale-ups are cross-**document** ref numbering (persist the label map across pages) and a Modelica syntax grammar.
