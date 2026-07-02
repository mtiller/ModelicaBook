#!/usr/bin/env node
// MIC-84 / MIC-92 — one-time gettext migration: RST-shaped .po → Markdown-shaped .po
//
// Why this exists: the existing translations were extracted by Sphinx FROM RST,
// so every `msgid` (and many `msgstr`s) carry RST inline markup — `:math:`x``,
// double-backtick ``literals``, `:ref:`label``, and RST `\ ` null-escapes. po4a
// extracts translation units FROM the Markdown source, so its msgids use MD
// markup ($x$, `code`, [text](#label)). If we did nothing, the msgids wouldn't
// match and every string would look "untranslated."
//
// This script rewrites the RST markup inside both msgid and msgstr to the
// Markdown forms po4a produces. After this pass:
//   • prose units already matched and still match (untouched);
//   • marked-up units now match po4a's MD msgids (exactly, or close → fuzzy);
//   • the translated TEXT is fully preserved — zero human re-translation.
// The output .po is then reconciled against the po4a-generated .pot with
// `msgmerge` (see i18n/README.md). Fuzzies are auto-flagged for a quick confirm,
// not re-translation.
//
// Usage:  node migrate-gettext.mjs <in.po> [--out <out.po>] [--stats]

import fs from 'node:fs';

// ---- RST inline markup → Markdown ----------------------------------------
function rstToMd(s) {
  if (!s) return s;
  let out = s;
  // :ref:`text <label>`  →  [text](#label)
  out = out.replace(/:ref:`([^<`]+?)\s*<([^>]+?)>`/g, (_m, t, l) => `[${t.trim()}](#${l.trim()})`);
  // :ref:`label`         →  [](#label)   (title resolved later by the xref plugin)
  out = out.replace(/:ref:`([^`<]+?)`/g, (_m, l) => `[](#${l.trim()})`);
  // :math:`X`            →  $X$
  out = out.replace(/:math:`([^`]+?)`/g, (_m, x) => `$${x}$`);
  // `text <url>`_        →  [text](url)   (RST external hyperlink)
  out = out.replace(/`([^`<]+?)\s*<([^>]+?)>`_/g, (_m, t, u) => `[${t.trim()}](${u.trim()})`);
  // ``literal``          →  `code`
  out = out.replace(/``([^`]+?)``/g, (_m, x) => `\`${x}\``);
  // RST null-escape `\ ` (used to butt markup against text) → nothing
  out = out.replace(/\\ /g, '');
  return out;
}

// ---- Minimal .po parse / serialize ---------------------------------------
function unescape(str) {
  return str.replace(/\\n/g, '\n').replace(/\\t/g, '\t').replace(/\\"/g, '"').replace(/\\\\/g, '\\');
}
function escape(str) {
  return str.replace(/\\/g, '\\\\').replace(/"/g, '\\"').replace(/\n/g, '\\n').replace(/\t/g, '\\t');
}

// Parse into ordered entries: { comments:[], msgid, msgstr }
function parsePo(text) {
  const entries = [];
  let cur = { comments: [], msgid: null, msgstr: null };
  let field = null; // 'msgid' | 'msgstr'
  const flush = () => {
    if (cur.msgid !== null || cur.comments.length) entries.push(cur);
    cur = { comments: [], msgid: null, msgstr: null };
    field = null;
  };
  for (const raw of text.split('\n')) {
    const line = raw.replace(/\r$/, '');
    if (line.startsWith('#')) { if (field) flush(); cur.comments.push(line); continue; }
    const mId = line.match(/^msgid\s+"((?:[^"\\]|\\.)*)"\s*$/);
    const mStr = line.match(/^msgstr\s+"((?:[^"\\]|\\.)*)"\s*$/);
    const mCont = line.match(/^"((?:[^"\\]|\\.)*)"\s*$/);
    if (mId) { if (field === 'msgstr') flush(), (cur = entries.length ? cur : cur); cur.msgid = unescape(mId[1]); field = 'msgid'; }
    else if (mStr) { cur.msgstr = unescape(mStr[1]); field = 'msgstr'; }
    else if (mCont && field) { cur[field] += unescape(mCont[1]); }
    else if (line.trim() === '') { if (cur.msgid !== null) flush(); }
  }
  if (cur.msgid !== null || cur.comments.length) entries.push(cur);
  return entries;
}

function serializePo(entries) {
  const out = [];
  for (const e of entries) {
    for (const c of e.comments) out.push(c);
    if (e.msgid !== null) out.push(`msgid "${escape(e.msgid)}"`);
    if (e.msgstr !== null) out.push(`msgstr "${escape(e.msgstr)}"`);
    out.push('');
  }
  return out.join('\n');
}

// ---- Main -----------------------------------------------------------------
const args = process.argv.slice(2);
const inFile = args.find((a) => !a.startsWith('--'));
const outIdx = args.indexOf('--out');
const outFile = outIdx >= 0 ? args[outIdx + 1] : null;
const stats = args.includes('--stats');
if (!inFile) {
  console.error('usage: migrate-gettext.mjs <in.po> [--out <out.po>] [--stats]');
  process.exit(1);
}

const entries = parsePo(fs.readFileSync(inFile, 'utf-8'));
let units = 0, translated = 0, idChanged = 0, strChanged = 0;
for (const e of entries) {
  if (e.msgid === null || e.msgid === '') continue; // skip header / blanks
  units++;
  const newId = rstToMd(e.msgid);
  if (newId !== e.msgid) idChanged++;
  e.msgid = newId;
  if (e.msgstr) {
    translated++;
    const newStr = rstToMd(e.msgstr);
    if (newStr !== e.msgstr) strChanged++;
    e.msgstr = newStr;
  }
}

const result = serializePo(entries);
if (outFile) {
  fs.writeFileSync(outFile, result);
  console.log(`wrote ${outFile}`);
}
if (stats || !outFile) {
  console.error(
    `\n${inFile}\n  units: ${units} | translated: ${translated} | ` +
    `msgids rewritten (had RST markup): ${idChanged} | ` +
    `msgstrs rewritten: ${strChanged} | ` +
    `prose units unchanged (already matched): ${units - idChanged}`,
  );
}
