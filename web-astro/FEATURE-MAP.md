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
| `:ref:` | 310 | Cross-references | **Gap→plugin** | **The heaviest gap.** Same-page anchor links are native (`[text](#anchor)`). But Sphinx `:ref:` also resolves the *target's title* and produces auto-numbered cross-document references ("see Section 3.2", "Figure 4.1"). That requires a **custom remark plugin** that builds a label→{title,number} map across all docs and rewrites refs. Figure/equation/section auto-numbering rides on the same plugin. This is the one item worth building/validating before committing to full migration. |

## Cross-cutting

| Concern | Astro/Starlight | Status |
|---|---|---|
| Site search | Pagefind (built in) | **Native** |
| Sidebar / nav / prev-next | Starlight built-ins | **Native** |
| Syntax highlighting | Expressive Code (Shiki) | **Native** (no Modelica grammar) |
| Dark/light mode | Starlight built-in + our `data-mode` tokens | **Native** |
| i18n / translations | po4a bridge to gettext (see `i18n/`) | **Tooling** — see `i18n/README.md` |
| PDF / ebook export | — | **Gap** — Sphinx's LaTeX/epub path has no Astro equivalent; a separate concern (was MIC-85). If print output is still required, keep a Sphinx/Pandoc export path or add one. |

## Summary

- **Native or one-plugin-install:** code, literalinclude, math, figures, admonitions, toctree/nav, search, conditional content, raw HTML — the bulk of the book.
- **Author once as a component:** interactive figures (done).
- **Real work, two items:**
  1. **`:ref:` cross-references + auto-numbering** (310 uses) — a custom remark plugin. The heaviest parity item.
  2. **i18n** — the po4a bridge (scaffolded in `i18n/`), reusing existing translations.
- **Decisions, not work:** `index` (→ search), `todo` (→ drop), print export (separate track, MIC-85).
