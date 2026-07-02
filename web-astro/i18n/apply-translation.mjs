#!/usr/bin/env node
// Demo applicator: produce a translated MDX by substituting a language's
// (Markdown-shaped) .po translations into the English MDX — prose paragraphs and
// heading titles only; imports, JSX components, code, math and directives pass
// through untouched. In production po4a orchestrates this; this script sidesteps
// po4a's MDX-parsing wrinkles for a reliable, viewable demo build.
//
// Usage: apply-translation.mjs <english.mdx> <lang.po> <out.mdx>

import fs from 'node:fs';
import path from 'node:path';

// The translated file lands in a locale subdir (docs/<lang>/), one or more
// levels deeper than the English source. Relative import specifiers must be
// re-rooted by that depth or the build fails with UNRESOLVED_IMPORT.
function fixRelativeImports(text, fromMdx, toMdx) {
  const rel = path.relative(path.dirname(fromMdx), path.dirname(toMdx));
  if (!rel) return text;
  const parts = rel.split(path.sep);
  const depth = parts.filter((s) => s !== '..').length - parts.filter((s) => s === '..').length;
  if (depth <= 0) return text;
  const prefix = '../'.repeat(depth);
  return text.replace(/(\bfrom\s+['"]|\bimport\s+['"])(\.[^'"]+)(['"])/g,
    (_m, lead, spec, quote) => `${lead}${path.posix.normalize(prefix + spec)}${quote}`);
}

function unescape(s) {
  return s.replace(/\\n/g, '\n').replace(/\\t/g, '\t').replace(/\\"/g, '"').replace(/\\\\/g, '\\');
}
function parsePo(text) {
  const map = new Map();
  let id = null, str = null, field = null;
  const flush = () => { if (id) map.set(id, str || ''); id = null; str = null; field = null; };
  for (const raw of text.split('\n')) {
    const l = raw.replace(/\r$/, '');
    let m;
    if ((m = l.match(/^msgid\s+"((?:[^"\\]|\\.)*)"\s*$/))) { flush(); id = unescape(m[1]); str = ''; field = 'id'; }
    else if ((m = l.match(/^msgstr\s+"((?:[^"\\]|\\.)*)"\s*$/))) { str = unescape(m[1]); field = 'str'; }
    else if ((m = l.match(/^"((?:[^"\\]|\\.)*)"\s*$/)) && field) { if (field === 'id') id += unescape(m[1]); else str += unescape(m[1]); }
    else if (l.trim() === '') flush();
  }
  flush();
  return map;
}

const [, , mdxFile, poFile, outFile] = process.argv;
if (!mdxFile || !poFile || !outFile) {
  console.error('usage: apply-translation.mjs <english.mdx> <lang.po> <out.mdx>');
  process.exit(1);
}
const rawMap = parsePo(fs.readFileSync(poFile, 'utf-8'));
// Normalize whitespace (MDX prose is hard-wrapped; .po msgids are single-line).
const norm = (s) => s.replace(/\s+/g, ' ').trim();
const map = new Map();
for (const [k, v] of rawMap) map.set(norm(k), v);
const t = (s) => { const v = map.get(norm(s)); return v && v.trim() ? v : null; };
// FUZZY_FALLBACK: opt-in nearest-match for prose the source paraphrased away from the catalog.
const FUZZY = Number(process.env.FUZZY || 0); // e.g. 0.6; 0 disables
const _toks = (x)=>new Set(norm(x).toLowerCase().replace(/[^\p{L}\p{N}$`]+/gu,' ').split(' ').filter(Boolean));
const _entries=[...map.entries()].map(([k,v])=>[k,v,_toks(k)]);
let fuzzyHits=0;
const tf=(s)=>{const ex=t(s); if(ex)return {v:ex,fuzzy:false}; if(!FUZZY)return null;
  const A=_toks(s); if(!A.size)return null; let best=0,bv=null;
  for(const [,v,B] of _entries){let i=0;for(const x of A)if(B.has(x))i++;const j=i/(A.size+B.size-i); if(j>best){best=j;bv=v;}}
  if(best>=FUZZY&&bv&&bv.trim()){fuzzyHits++;return {v:bv,fuzzy:true};} return null; };

let src = fs.readFileSync(mdxFile, 'utf-8');
let frontmatter = '';
src = src.replace(/^(---\n[\s\S]*?\n---\n)/, (m) => { frontmatter = m; return ''; });
// translate the frontmatter title
frontmatter = frontmatter.replace(/^title:\s*(.+)$/m, (m, ti) => { const tv = t(ti); return tv ? `title: ${tv}` : m; });

let prose = 0, hit = 0;
const blocks = src.split(/\n\n+/);
const out = blocks.map((block) => {
  const b = block.trim();
  if (!b) return block;
  // headings: translate the title text, preserve level + {/* #id */}
  const h = b.match(/^(#{1,6})\s+(.*?)(\s*\{\/\*[^}]*\*\/\})?\s*$/);
  if (h) {
    prose++;
    const trh = tf(h[2]);
    if (trh) { hit++; return `${h[1]} ${trh.v}${h[3] || ''}`; }
    return block;
  }
  // skip non-prose: imports/exports, JSX, code fences, block math, directives, images, tables
  if (/^(import|export|<|```|\$\$|:::|!\[|\|)/.test(b)) return block;
  prose++;
  const trb = tf(b);
  if (trb) { hit++; return trb.fuzzy ? `{/* FUZZY: verify */}\n${trb.v}` : trb.v; }
  return block;
}).join('\n\n');

fs.writeFileSync(outFile, fixRelativeImports(frontmatter + out, mdxFile, outFile));
console.error(`${outFile}: prose/heading blocks ${prose} | translated ${hit} | left English ${prose - hit} | fuzzy ${fuzzyHits}`);
