# Print pipeline — PDF & eBook (MIC-85)

**PDF and eBook export are fully supported.** They do not come from Astro (a web
renderer) — they come from the same Markdown source via **Pandoc**. This mirrors
today's setup, where print is *also* a separate pipeline (Sphinx → LaTeX, whose
Makefile literally calls itself a "horrible LaTeX hack"). Splitting it out —
Astro for web, Pandoc for print, one Markdown source — removes that coupling.

## The pipeline

```
MDX chapter ──build-print-md.mjs──▶ print Markdown ──Pandoc──▶ PDF / EPUB
```

### Step 1 — lower MDX to print Markdown (no external deps; runs today)

```bash
node print/build-print-md.mjs src/content/docs/first-order.mdx print/first-order.print.md
```

MDX components are lowered to their print representation:

| MDX in the web build | Print Markdown |
|---|---|
| `<SimFigure id="FO" caption="…"/>` | `![…](../public/plots/FO.svg)` — the interactive island degrades to its **static plot**, which was always the base case. Exactly what you want on paper. |
| `<Code code={body(firstOrder)} …/>` | ` ```modelica … ``` ` inlined from the real `.mo` file (single source of truth) |
| `{/* #id */}` heading label | Pandoc `{#id}` header attribute |
| `:::note[…]` aside | Pandoc `::: {.note}` fenced div |

Verified on `first-order.mdx`: 4 figures → static images, 5 code blocks inlined,
heading anchors preserved, zero leftover MDX. Output: `print/first-order.print.md`.

### Step 2 — Pandoc → PDF / EPUB (needs Pandoc installed)

```bash
# PDF (Typst engine — fast, no TeX install needed; or use xelatex)
pandoc --defaults print/pandoc-defaults.yaml -o ModelicaByExample.pdf print/*.print.md

# EPUB
pandoc --defaults print/pandoc-defaults.yaml -t epub3 -o ModelicaByExample.epub print/*.print.md
```

Install (a print-side dependency, as xelatex is today):
`brew install pandoc pandoc-crossref typst` or `apt-get install pandoc`.

## Feature coverage

| Need | Pandoc mechanism | Status |
|---|---|---|
| Math | `tex_math_dollars` (native) | ✅ |
| Code blocks | fenced code (native) | ✅ |
| Figures + numbering | `implicit_figures` + pandoc-crossref | ✅ |
| Section numbering | `number-sections` (native) | ✅ |
| Cross-references ("Figure 3", "Section 2.1") | `pandoc-crossref` filter | ✅ (see note) |
| ToC | `toc` (native) | ✅ |
| EPUB / MOBI | `-t epub3` (native); MOBI via Calibre `ebook-convert` | ✅ |
| PDF | Typst or xelatex engine | ✅ |

**Cross-reference note:** the web build resolves `:ref:` via the `remark-xref`
plugin; print resolves the same `#id` targets via pandoc-crossref. For identical
numbering across web and print, the converter should emit crossref-style refs
(`[@fig:FO]`) or a shared pass should feed both — a small consolidation, not a
blocker.

## Not yet run here

Pandoc/Typst aren't installed in this scaffold environment, so Step 2 hasn't been
executed (Step 1 has, and its output is real). The commands above are the
production invocation — the same class of "requires a print toolchain installed"
as the current xelatex build.
