#!/usr/bin/env node
// MIC-84 — first-cut RST → MDX converter (prose-preserving).
//
// Design goal: emit prose VERBATIM (so the existing gettext catalogs match on
// migration — see i18n/), while mechanically mapping the directive/role surface
// the book actually uses (inventory: math, literalinclude, code-block, plot,
// figure, topic/note, index, toctree, :ref:, :math:). Unknown/raw constructs are
// passed through as a flagged HTML comment for human review rather than dropped
// silently.
//
// Usage: node tools/rst2mdx.mjs <in.rst> <out.mdx> [--title "Desc"]

import fs from 'node:fs';

const [, , inFile, outFile] = process.argv;
const descIdx = process.argv.indexOf('--title');
const desc = descIdx >= 0 ? process.argv[descIdx + 1] : '';
if (!inFile || !outFile) { console.error('usage: rst2mdx.mjs <in.rst> <out.mdx> [--title <desc>]'); process.exit(1); }

// ---- inline RST → MD (mirrors i18n/migrate-gettext rstToMd, + hyperlinks) ----
function inline(s) {
  if (!s) return s;
  let o = s;
  o = o.replace(/:ref:`([^<`]+?)\s*<([^>]+?)>`/g, (_m, t, l) => `[${t.trim()}](#${l.trim()})`);
  o = o.replace(/:ref:`([^`<]+?)`/g, (_m, l) => `[](#${l.trim()})`);
  o = o.replace(/:math:`([^`]+?)`/g, (_m, x) => `$${x}$`);
  o = o.replace(/`([^`<]+?)\s*<([^>]+?)>`_/g, (_m, t, u) => `[${t.trim()}](${u.trim()})`); // `text <url>`_
  o = o.replace(/``([^`]+?)``/g, (_m, x) => `\`${x}\``);
  o = o.replace(/\\ /g, '');
  return o;
}
const varName = (p) => {
  const base = p.split('/').pop().replace(/\.mo$/, '');
  return base.replace(/[^A-Za-z0-9]/g, '_').replace(/^(\d)/, '_$1');
};

const raw = fs.readFileSync(inFile, 'utf-8').replace(/\r\n/g, '\n');
const lines = raw.split('\n');
const UNDER = /^([-=^~"'`#*+.:])\1{2,}\s*$/;

const imports = new Map(); // path -> varName
const out = [];            // body blocks
let title = null;
const levelChars = [];     // underline char order → heading level
let pendingLabels = [];
const warnings = [];

function headingLevel(ch) {
  let idx = levelChars.indexOf(ch);
  if (idx < 0) { levelChars.push(ch); idx = levelChars.length - 1; }
  return idx; // 0 = page title
}
const indentOf = (l) => (l.match(/^(\s*)/)[1].length);

// collect a directive's indented body (lines more indented than `base`), skipping a blank gap
function collectIndented(i, base) {
  const body = [];
  let j = i;
  while (j < lines.length && lines[j].trim() === '') j++; // allow leading blank
  const start = j;
  let ind = null;
  for (; j < lines.length; j++) {
    const l = lines[j];
    if (l.trim() === '') { body.push(''); continue; }
    if (indentOf(l) <= base) break;
    if (ind === null) ind = indentOf(l);
    body.push(l.slice(ind));
  }
  // trim trailing blanks
  while (body.length && body[body.length - 1] === '') body.pop();
  return { body, next: start === j ? i : j };
}

let para = [];
function flushPara() {
  if (!para.length) return;
  const text = para.join('\n').trim();
  if (text) out.push(inline(text));
  para = [];
}

for (let i = 0; i < lines.length; i++) {
  const line = lines[i];

  // label: .. _name:
  let m = line.match(/^\.\.\s+_([\w-]+):\s*$/);
  if (m) { flushPara(); pendingLabels.push(m[1]); continue; }

  // heading: text on this line, underline on the next
  if (line.trim() && i + 1 < lines.length && UNDER.test(lines[i + 1]) && !line.startsWith('..')) {
    flushPara();
    const lvl = headingLevel(lines[i + 1].trim()[0]);
    const anchor = pendingLabels.length ? ` {/* #${pendingLabels[0]} */}` : '';
    pendingLabels = [];
    if (lvl === 0 && title === null) { title = line.trim(); }
    else { out.push(`${'#'.repeat(Math.max(2, lvl + 1))} ${inline(line.trim())}${anchor}`); }
    i++; // consume underline
    continue;
  }

  // directive: .. name:: arg   (also tolerate the malformed ".. index: x")
  m = line.match(/^\.\.\s+([a-z][a-z0-9_-]*)::?(.*)$/);
  if (m) {
    flushPara();
    const name = m[1], arg = m[2].trim();
    const base = indentOf(line);

    if (name === 'index' || name === 'toctree' || name === 'todo' || name === 'todolist') {
      const { next } = collectIndented(i + 1, base); i = next - 1; pendingLabels = []; continue;
    }
    if (name === 'math') {
      let expr;
      if (arg) { expr = arg; }
      else { const c = collectIndented(i + 1, base); expr = c.body.join('\n').trim(); i = c.next - 1; }
      const aligned = /(^|[^\\])&|\\\\/.test(expr) ? `\\begin{aligned}\n${expr}\n\\end{aligned}` : expr;
      out.push(`$$\n${aligned}\n$$`);
      continue;
    }
    if (name === 'literalinclude') {
      const c = collectIndented(i + 1, base); i = c.next - 1;
      const opts = {};
      for (const b of c.body) { const om = b.match(/^:([\w-]+):\s*(.*)$/); if (om) opts[om[1]] = om[2].trim(); }
      const v = varName(arg);
      if (!imports.has(arg)) imports.set(arg, v);
      const spec = opts.lines || '1-';
      const fname = arg.split('/').pop();
      const mark = opts['emphasize-lines'] ? ` mark={[${opts['emphasize-lines'].split(',').map((x) => x.trim()).join(',')}]}` : '';
      out.push(`<Code code={lines(${imports.get(arg)}, '${spec}')} lang="text" title="${fname}"${mark} />`);
      continue;
    }
    if (name === 'code-block' || name === 'sourcecode' || name === 'code') {
      const c = collectIndented(i + 1, base); i = c.next - 1;
      out.push('```text\n' + c.body.join('\n').replace(/\s+$/, '') + '\n```');
      continue;
    }
    if (name === 'topic' || name === 'note' || name === 'warning' || name === 'tip') {
      const c = collectIndented(i + 1, base); i = c.next - 1;
      const kind = name === 'topic' ? 'note' : name;
      out.push(`:::${kind}[${inline(arg)}]\n${inline(c.body.join('\n').trim())}\n:::`);
      continue;
    }
    if (name === 'plot' || name === 'figure' || name === 'image') {
      const c = collectIndented(i + 1, base); i = c.next - 1;
      warnings.push(`${name} (asset pipeline / MIC-87): ${arg}`);
      out.push(`{/* TODO ${name}: ${arg} — pending asset pipeline (MIC-87) */}`);
      continue;
    }
    // comment or unknown directive → passthrough flag
    if (/^\.\.\s+[a-z]/.test(line)) {
      const c = collectIndented(i + 1, base); i = c.next - 1;
      if (name !== 'index') warnings.push(`unhandled directive '${name}': ${arg}`);
      continue;
    }
  }

  // plain RST comment ".. something" (no ::) → drop
  if (/^\.\.\s/.test(line) && !line.match(/^\.\.\s+_/)) { continue; }

  if (line.trim() === '') { flushPara(); continue; }
  para.push(line);
}
flushPara();

// ---- assemble MDX ----
const fm = [`---`, `title: ${title || inFile}`, desc ? `description: ${desc}` : '', `---`, ''].filter((x, idx) => !(x === '' && idx === 2)).join('\n');
const importLines = [
  `import { Code } from '@astrojs/starlight/components';`,
  ...[...imports.entries()].map(([p, v]) => `import ${v} from '../../../..${p}?raw';`),
];
const helper = `\nexport const lines = (s, spec) => {\n  const L = s.split('\\n');\n  const m = spec.match(/^(\\d+)-(\\d*)$/);\n  const a = m ? +m[1] : 1, b = m && m[2] ? +m[2] : L.length;\n  return L.slice(a - 1, b).join('\\n').replace(/\\s+$/, '');\n};\n`;
fs.writeFileSync(outFile, `${fm}\n${importLines.join('\n')}\n${helper}\n${out.join('\n\n')}\n`);
console.error(`wrote ${outFile}\n  headings:${levelChars.length - 1} imports:${imports.size} blocks:${out.length} warnings:${warnings.length}`);
for (const w of warnings) console.error('   ⚠ ' + w);
