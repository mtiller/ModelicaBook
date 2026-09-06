#!/usr/bin/env node
// MIC-84 / MIC-130 — generate per-language MDX for the whole book by reusing the
// existing gettext catalogs. For each language × chapter with a non-empty
// catalog: migrate the RST-shaped .po → Markdown-shaped, then apply it onto the
// English MDX → src/content/docs/<lang>/<route>.mdx. Chapters with no/empty
// translation are skipped — Starlight i18n falls back to the English page.
//
// Run after the English tree exists (npm run convert). Usage: node tools/build-locales.mjs
import fs from 'node:fs';
import path from 'node:path';
import { execSync } from 'node:child_process';

const LANGS = ['ar', 'cn', 'de', 'es', 'fr', 'it', 'kr', 'pt_BR'];
const SRC = '../text/source';
const LOCALE = (l) => `../text/locale/${l}/LC_MESSAGES`;
const DOCS = 'src/content/docs';

const rel = (f) => f.slice(SRC.length + 1);
const routeOf = (f) => rel(f).replace(/\.rst$/, '').replace(/_/g, '-');
const catalogOf = (f) => rel(f).replace(/\.rst$/, '');   // keeps underscores (matches locale tree)
const all = execSync(`find ${SRC} -name '*.rst'`, { encoding: 'utf8' }).trim().split('\n').filter(Boolean).sort();

// Count REAL translated units (skip the header entry whose msgid is ""), so
// near-empty catalogs (de/fr/it/pt_BR) don't spawn all-English duplicate pages —
// Starlight falls back to English for those instead.
const translatedCount = (po) => {
  const t = fs.readFileSync(po, 'utf8');
  let n = 0;
  for (const e of t.split(/\n\n+/)) {
    const idm = e.match(/^msgid\s+"((?:[^"\\]|\\.)*)"/m);
    if (!idm || idm[1] === '') continue;
    const sm = e.match(/^msgstr\s+"((?:[^"\\]|\\.)*)"((?:\n"(?:[^"\\]|\\.)*")*)/m);
    if (!sm) continue;
    const val = (sm[1] + (sm[2] || '').replace(/\n"|"/g, '')).trim();
    if (val) n++;
  }
  return n;
};
const hasTranslation = (po) => translatedCount(po) > 0;

const summary = {};
for (const lang of LANGS) {
  let made = 0, skipped = 0;
  for (const f of all) {
    const route = routeOf(f);
    const eng = path.join(DOCS, route + '.mdx');
    if (!fs.existsSync(eng)) { continue; }               // section index or non-page
    const po = path.join(LOCALE(lang), catalogOf(f) + '.po');
    if (!fs.existsSync(po) || !hasTranslation(po)) { skipped++; continue; }
    const mpo = path.join('i18n/po', lang, route + '.po');
    fs.mkdirSync(path.dirname(mpo), { recursive: true });
    const out = path.join(DOCS, lang, route + '.mdx');
    fs.mkdirSync(path.dirname(out), { recursive: true });
    try {
      execSync(`node i18n/migrate-gettext.mjs ${JSON.stringify(po)} --out ${JSON.stringify(mpo)}`, { stdio: 'ignore' });
      execSync(`node i18n/apply-translation.mjs ${JSON.stringify(eng)} ${JSON.stringify(mpo)} ${JSON.stringify(out)}`, { stdio: 'ignore' });
      made++;
    } catch (e) { skipped++; }
  }
  summary[lang] = { made, skipped };
}
console.log('per-language pages generated (rest fall back to English):');
for (const [l, s] of Object.entries(summary)) console.log(`  ${l.padEnd(6)} ${s.made} pages`);
