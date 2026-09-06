# i18n pipeline verification (MIC-130)

End-to-end verification that the Astro build reuses the existing gettext
catalogs — no re-translation, no parallel hand-maintained MDX tree.

## Result: verified

- **All 8 locales build and route.** `dist/{cn,kr,ar,de,es,fr,it,pt_BR}/…` render;
  `<html lang>` is set per locale (e.g. `ko`, `zh`), Arabic is `dir="rtl"`.
- **Translated pages come from reused `.po` data**, applied onto the English MDX
  via `migrate-gettext.mjs` (RST-shaped → Markdown-shaped) + `apply-translation.mjs`.
  Chinese and Korean each render ~91 translated chapters; sparse locales fall back
  to English (Starlight i18n fallback).
- **Math, code-from-`.mo`, figures, and cross-references render identically** in
  translated pages (verified on `kr/behavior/arrays/state-space`).

## Reuse per language (full-corpus dry run)

| Lang | Translated units | Reuse ceiling |
|------|-----------------:|--------------:|
| cn   | 2,659            | 89%           |
| kr   | 2,422            | 78%           |
| es   | 502              | 17%           |
| ar   | 255              | 8%            |
| pt_BR| 31               | 1%            |
| fr/it| 7 each           | ~0%           |
| de   | 0                | 0%            |

Only cn/kr are substantially translated **in the source catalogs**; the rest is a
pre-existing content gap (see MIC-137), not a conversion loss. ~99% of *existing*
translated units migrate cleanly; residuals (footnotes, multi-line hyperlinks) are
handled by the migrator rules (MIC-131).

## Repeatable command sequence

```bash
# whole book, all locales (also runs on npm run build via prebuild):
npm run convert          # convert-book.mjs + build-cases.mjs + build-locales.mjs

# one chapter, one language, by hand:
node i18n/migrate-gettext.mjs ../text/locale/kr/LC_MESSAGES/behavior/equations/first_order.po --out i18n/po/kr/first-order.po
node i18n/apply-translation.mjs src/content/docs/behavior/equations/first-order.mdx i18n/po/kr/first-order.po src/content/docs/kr/behavior/equations/first-order.mdx
```

`build-locales.mjs` skips catalogs with zero real translations, so Starlight
serves the English page under the localized route for those.

## Coverage measured on the built site

- Korean: ~74–76% of prose blocks are Korean (near the 78% catalog ceiling); the
  remainder is untranslated **in the source catalog** (MIC-137 part 1).
- No page fails to build in any locale.
