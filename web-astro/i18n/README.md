# Translations — reusing the existing gettext catalogs (MIC-92)

**Goal:** move content to MDX **without** re-translating anything and **without**
switching to a hand-maintained parallel tree of translated Markdown files. Keep
the current gettext model — one English source + per-language `.po` overlays,
string-delta translations, fuzzy-marking on change — and just retarget it at
Markdown.

## Why the naive path fails

Starlight's *native* i18n is a parallel per-locale file tree — you'd maintain a
full translated `.mdx` per language. That's a real regression from gettext.

And you can't drop the existing `.po` files in unchanged: they were extracted by
**Sphinx from RST**, so the `msgid`s (and many `msgstr`s) contain RST markup —
`` :math:`x` ``, double-backtick ``` ``literal`` ```, `` :ref:`label` ``, RST
`\ ` null-escapes. po4a extracts from **Markdown**, whose msgids use `$x$`,
`` `code` ``, `[text](#label)`. Mismatched msgids ⇒ everything looks untranslated.

## The two-part solution

### 1. One-time migration — `migrate-gettext.mjs`

Rewrites the RST markup inside each `.po` (both `msgid` and `msgstr`) to the
Markdown forms po4a expects. Prose units are already identical and pass through
untouched; marked-up units get re-keyed; **all translated text is preserved.**

```bash
# one file
node i18n/migrate-gettext.mjs ../text/locale/cn/LC_MESSAGES/behavior/equations/first_order.po \
    --out i18n/po/cn/first-order.po --stats

# whole tree (example)
for f in $(find ../text/locale -name '*.po'); do
  lang=$(echo "$f" | sed -E 's#.*/locale/([^/]+)/.*#\1#')
  base=$(basename "$f" .po)
  mkdir -p "i18n/po/$lang"
  node i18n/migrate-gettext.mjs "$f" --out "i18n/po/$lang/$base.po"
done
```

**Measured on `cn/first_order.po`** (a fully-translated chapter, 35 units):

| | count |
|---|---:|
| translation units | 35 |
| already-matching prose units (untouched) | 20 |
| marked-up msgids re-keyed to MD | 15 |
| msgstrs with RST markup rewritten to MD | 25 |
| **human re-translations required** | **0** |

Example: `` 变量\ :math:`x`\ 。 `` → `变量$x$。`, and `` ``model`` `` → `` `model` ``.

### 2. Reconcile + go forward — po4a (`po4a.cfg`)

After migration, po4a owns the lifecycle against the MDX source:

```bash
po4a --no-translations i18n/po4a.cfg   # refresh .pot/.po from English MDX
po4a i18n/po4a.cfg                      # emit translated MDX for Starlight
```

`po4a`/`msgmerge` aligns the migrated `.po` with the freshly-extracted `.pot`.
Exact msgid matches reuse silently; near-misses become **fuzzy** (translation is
already present — a one-click confirm, not a re-translation). The generated
`src/content/docs/<lang>/*.mdx` are build artifacts (gitignore them); Starlight
serves them as its locale tree.

## Honest caveats (the "fuzzy", not "re-translate", bucket)

- **`:ref:` with translated link text.** The demo transform mangled one case
  (`[](#变量\\)`). Cross-references are also the biggest feature-parity gap
  (`FEATURE-MAP.md`) and need a custom remark plugin; that plugin should define
  the canonical MD cross-ref syntax, and `rstToMd()` should target it. Until
  then these surface as fuzzies.
- **Segmentation granularity.** Sphinx and po4a segment paragraphs almost
  identically, but lists/tables/admonitions can differ. Mismatches show up as
  fuzzies on first `msgmerge`, never as lost translations.
- **`migrate-gettext.mjs` is a scaffold**, proven on `first_order`. Before a full
  run, spot-check a couple of languages and tighten the `:ref:` rule alongside
  the cross-ref plugin.

## Net

The existing human translation work is **fully reused** — zero re-translation.
The cost is a one-time mechanical migration + a fuzzy-confirm pass, after which
the team keeps working in exactly today's gettext `.po` workflow, now targeting
Markdown. This is **platform-independent** across MDX frameworks (Docusaurus,
Astro, Nextra) — po4a is the bridge regardless.
