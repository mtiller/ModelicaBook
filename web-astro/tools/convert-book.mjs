#!/usr/bin/env node
// MIC-84 / MIC-131 — whole-book orchestrator.
//   1. scan every .rst → global label map (label → {route, anchor, title})
//   2. convert every chapter → src/content/docs/<route>.mdx (route-aware)
//   3. parse toctrees → Starlight sidebar → tools/sidebar.gen.json
//
// Usage: node tools/convert-book.mjs [--dry]  (--dry = don't write MDX/sidebar)

import fs from 'node:fs';
import path from 'node:path';
import { execSync } from 'node:child_process';
import { convertRst, scanLabels } from './rst2mdx.mjs';

const SRC = '../text/source';
const DOCS = 'src/content/docs';
const dry = process.argv.includes('--dry');

const rel = (f) => f.slice(SRC.length + 1);                       // behavior/equations/first_order.rst
const routeOf = (f) => rel(f).replace(/\.rst$/, '').replace(/_/g, '-'); // behavior/equations/first-order
const all = execSync(`find ${SRC} -name '*.rst'`, { encoding: 'utf8' }).trim().split('\n').filter(Boolean).sort();

// index.rst is not a content page (toctrees/raw only); it drives the sidebar.
const isIndexRoot = (f) => rel(f) === 'index.rst';

// 1) global label map + page titles
const labels = new Map();
const titleByRoute = new Map();
for (const f of all) {
  const txt = fs.readFileSync(f, 'utf8');
  const { pageTitle, labels: ls } = scanLabels(txt);
  const route = routeOf(f);
  if (pageTitle) titleByRoute.set(route, pageTitle);
  for (const l of ls) if (!labels.has(l.label)) labels.set(l.label, { route, anchor: l.anchor, title: l.title || pageTitle });
}

// 2) convert every page
let converted = 0, warned = 0; const warnAgg = {};
for (const f of all) {
  if (isIndexRoot(f)) continue;
  const route = routeOf(f);
  const r = convertRst(fs.readFileSync(f, 'utf8'), { route, labels });
  if (r.warnings.length) { warned++; for (const w of r.warnings) { const k = w.split(':')[0].replace(/'.*/, '').trim(); warnAgg[k] = (warnAgg[k] || 0) + 1; } }
  if (!dry) {
    const outPath = path.join(DOCS, route + '.mdx');
    fs.mkdirSync(path.dirname(outPath), { recursive: true });
    fs.writeFileSync(outPath, r.mdx);
  }
  converted++;
}

// 3) toctree → sidebar
const readLines = (f) => fs.readFileSync(f, 'utf8').replace(/\r\n/g, '\n').split('\n');
const UNDER = /^([-=^~"'`#*+.:])\1{2,}\s*$/;
// return ordered [{ heading, entries:[route...] }] for a file
function toctrees(f) {
  const L = readLines(f); const dir = path.dirname(rel(f)); const groups = [];
  let lastHeading = null;
  for (let i = 0; i < L.length; i++) {
    // track most recent heading (underline or over+underline)
    if (L[i].trim() && i + 1 < L.length && UNDER.test(L[i + 1]) && !L[i].startsWith('..')) lastHeading = L[i].trim();
    const m = L[i].match(/^(\s*)\.\.\s+toctree::/);
    if (!m) continue;
    const base = m[1].length; const entries = []; let j = i + 1;
    for (; j < L.length; j++) {
      const t = L[j];
      if (t.trim() === '') { if (entries.length) { /* allow trailing blank then stop */ } continue; }
      if (t.match(/^\s+:[\w-]+:/)) continue;               // option line
      if (t.length - t.trimStart().length <= base) break;   // dedent → end
      const e = t.trim();
      // resolve relative entry → route
      const abs = path.normalize(path.join(dir, e)).replace(/_/g, '-');
      entries.push(abs);
    }
    groups.push({ heading: lastHeading, entries }); i = j - 1;
  }
  return groups;
}
const labelFor = (route) => titleByRoute.get(route) || route.split('/').pop().replace(/-/g, ' ');
// does this route correspond to a section-index file (has its own toctree)?
const fileForRoute = (route) => all.find((f) => routeOf(f) === route);

function buildItems(entries) {
  const items = [];
  for (const route of entries) {
    const f = fileForRoute(route);
    const sub = f ? toctrees(f) : [];
    if (sub.length) {
      // section index → nested group; flatten its toctree groups' entries
      const children = [];
      for (const g of sub) children.push(...buildItems(g.entries));
      items.push({ label: labelFor(route), items: children });
    } else {
      items.push({ label: labelFor(route), slug: route });
    }
  }
  return items;
}

// top level from index.rst
const idx = all.find(isIndexRoot);
const topGroups = toctrees(idx).filter((g) => g.entries.length);
const sidebar = topGroups.map((g) => ({ label: g.heading || 'Book', items: buildItems(g.entries) }));

if (!dry) fs.writeFileSync('tools/sidebar.gen.json', JSON.stringify(sidebar, null, 2) + '\n');

const count = (n) => JSON.stringify(n).match(/"slug"/g)?.length || 0;
console.log(`converted:${converted} warned:${warned} labels:${labels.size}`);
console.log('warning categories:', warnAgg);
console.log(`sidebar: ${sidebar.length} top groups, ${count(sidebar)} leaf pages`);
console.log(dry ? '(dry run — nothing written)' : 'wrote MDX tree + tools/sidebar.gen.json');
