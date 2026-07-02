#!/usr/bin/env node
// MIC-84 — RST → MDX converter (prose-preserving, route-aware).
//
// Emits prose VERBATIM (so existing gettext catalogs match on migration) while
// mapping the book's directive/role surface. Route-aware: computes .mo import
// depth from the output route and resolves :ref: cross-references against a
// global label map (same-page → #anchor; other page → /route/#anchor).
//
// CLI:   node tools/rst2mdx.mjs <in.rst> <out.mdx> [--route a/b/c] [--desc "..."]
// Module: import { convertRst } from './rst2mdx.mjs'

import fs from 'node:fs';

const UNDER = /^([-=^~"'`#*+.:])\1{2,}\s*$/;
const indentOf = (l) => l.match(/^(\s*)/)[1].length;
const slugRoute = (p) => p.replace(/\.rst$/, '').replace(/_/g, '-'); // RST path → route
export const varName = (p) => p.split('/').pop().replace(/\.mo$/, '').replace(/[^A-Za-z0-9]/g, '_').replace(/^(\d)/, '_$1');

// Scan a single RST for its labels → { anchor, isHeading, title } and page title.
export function scanLabels(text) {
  const lines = text.replace(/\r\n/g, '\n').split('\n');
  const labels = [];
  let pageTitle = null, pending = [];
  for (let i = 0; i < lines.length; i++) {
    const m = lines[i].match(/^\.\.\s+_([\w-]+):\s*$/);
    if (m) { pending.push(m[1]); continue; }
    if (lines[i].trim() && i + 1 < lines.length && UNDER.test(lines[i + 1]) && !lines[i].startsWith('..')) {
      const title = lines[i].trim();
      if (pageTitle === null) pageTitle = title;
      for (const l of pending) labels.push({ label: l, anchor: l, title });
      pending = [];
    } else if (lines[i].trim() && pending.length && !lines[i].startsWith('..')) {
      // label attached to non-heading block: keep anchor, title = pageTitle fallback later
      for (const l of pending) labels.push({ label: l, anchor: l, title: null });
      pending = [];
    }
  }
  return { pageTitle, labels };
}

export function convertRst(text, { route = '', desc = '', labels = new Map() } = {}) {
  const lines = text.replace(/\r\n/g, '\n').split('\n');
  const depth = 4 + (route ? route.split('/').length - 1 : 0); // docs/<route>.mdx → repo root
  const up = '../'.repeat(depth);

  // inline RST → MD, with cross-doc :ref: resolution
  const ref = (label, textOverride) => {
    const hit = labels.get(label);
    if (!hit) return textOverride ? `[${textOverride}](#${label})` : `[](#${label})`;
    const samePage = hit.route === route;
    const target = samePage ? `#${hit.anchor}` : `/${hit.route}/#${hit.anchor}`;
    const disp = textOverride || hit.title || '';
    return `[${disp}](${target})`;
  };
  const inline = (s) => {
    if (!s) return s;
    let o = s;
    o = o.replace(/:ref:`([^<`]+?)\s*<([^>]+?)>`/g, (_m, t, l) => ref(l.trim(), t.trim()));
    o = o.replace(/:ref:`([^`<]+?)`/g, (_m, l) => ref(l.trim(), null));
    o = o.replace(/:math:`([^`]+?)`/g, (_m, x) => `$${x}$`);
    o = o.replace(/`([^`<]+?)\s*<([^>]+?)>`_/g, (_m, t, u) => `[${t.trim()}](${u.trim()})`);
    o = o.replace(/\[([^\]]*)\]_/g, '');            // strip footnote refs (footnote bodies handled below)
    o = o.replace(/``([^`]+?)``/g, (_m, x) => `\`${x}\``);
    o = o.replace(/\\ /g, '');
    return o;
  };

  const imports = new Map();
  const usedVars = new Set();
  const uniqueVar = (p) => { let v = varName(p); let n = 2; while (usedVars.has(v)) v = `${varName(p)}_${n++}`; usedVars.add(v); return v; };
  const out = [];
  let title = null;
  const levelChars = [];
  let pendingLabels = [];
  const warnings = [];
  const headingLevel = (ch) => { let i = levelChars.indexOf(ch); if (i < 0) { levelChars.push(ch); i = levelChars.length - 1; } return i; };

  function collectIndented(i, base) {
    const body = []; let j = i;
    while (j < lines.length && lines[j].trim() === '') j++;
    const start = j; let ind = null;
    for (; j < lines.length; j++) {
      const l = lines[j];
      if (l.trim() === '') { body.push(''); continue; }
      if (indentOf(l) <= base) break;
      if (ind === null) ind = indentOf(l);
      body.push(l.slice(ind));
    }
    while (body.length && body[body.length - 1] === '') body.pop();
    return { body, next: start === j ? i : j };
  }

  let para = [];
  const flushPara = () => { if (!para.length) return; const t = para.join('\n').trim(); if (t) out.push(inline(t)); para = []; };

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];

    let m = line.match(/^\.\.\s+_([\w-]+):\s*$/);
    if (m) { flushPara(); pendingLabels.push(m[1]); continue; }

    if (line.trim() && i + 1 < lines.length && UNDER.test(lines[i + 1]) && !line.startsWith('..')) {
      flushPara();
      const lvl = headingLevel(lines[i + 1].trim()[0]);
      const anchor = pendingLabels.length ? ` {/* #${pendingLabels[0]} */}` : '';
      pendingLabels = [];
      if (lvl === 0 && title === null) title = line.trim();
      else out.push(`${'#'.repeat(Math.max(2, lvl + 1))} ${inline(line.trim())}${anchor}`);
      i++; continue;
    }

    m = line.match(/^\.\.\s+([a-z][a-z0-9_-]*)::?(.*)$/);
    if (m) {
      flushPara();
      const name = m[1], arg = m[2].trim(), base = indentOf(line);

      if (['index', 'toctree', 'todo', 'todolist'].includes(name)) { const c = collectIndented(i + 1, base); i = c.next - 1; pendingLabels = []; continue; }
      if (name === 'ifconfig') { const c = collectIndented(i + 1, base); i = c.next - 1; continue; } // build-conditional → drop on web
      if (name === 'raw') { const c = collectIndented(i + 1, base); i = c.next - 1; continue; }      // latex/html passthrough → drop on web (print handles)
      if (name === 'only') {
        const c = collectIndented(i + 1, base); i = c.next - 1;
        // keep html / not-latex content; drop latex-only
        if (/^html\b/.test(arg) || /^not\s+latex/.test(arg)) {
          const inner = c.body.join('\n').trim();
          if (inner) out.push(inline(inner));
        }
        continue;
      }
      if (name === 'math') {
        let expr; if (arg) expr = arg; else { const c = collectIndented(i + 1, base); expr = c.body.join('\n').trim(); i = c.next - 1; }
        const aligned = /(^|[^\\])&|\\\\/.test(expr) ? `\\begin{aligned}\n${expr}\n\\end{aligned}` : expr;
        out.push(`$$\n${aligned}\n$$`); continue;
      }
      if (name === 'literalinclude') {
        const c = collectIndented(i + 1, base); i = c.next - 1;
        const opts = {}; for (const b of c.body) { const om = b.match(/^:([\w-]+):\s*(.*)$/); if (om) opts[om[1]] = om[2].trim(); }
        if (!imports.has(arg)) imports.set(arg, uniqueVar(arg));
        const spec = opts.lines || '1-'; const fname = arg.split('/').pop();
        const mark = opts['emphasize-lines'] ? ` mark={[${opts['emphasize-lines'].split(',').map((x) => `'${x.trim()}'`).join(',')}]}` : '';
        out.push(`<Code code={lines(${imports.get(arg)}, '${spec}')} lang="text" title="${fname}"${mark} />`); continue;
      }
      if (['code-block', 'sourcecode', 'code'].includes(name)) {
        const c = collectIndented(i + 1, base); i = c.next - 1;
        out.push('```text\n' + c.body.join('\n').replace(/\s+$/, '') + '\n```'); continue;
      }
      if (['topic', 'note', 'warning', 'tip'].includes(name)) {
        const c = collectIndented(i + 1, base); i = c.next - 1;
        const kind = name === 'topic' ? 'note' : name;
        out.push(`:::${kind}[${inline(arg)}]\n${inline(c.body.join('\n').trim())}\n:::`); continue;
      }
      if (['plot', 'figure', 'image'].includes(name)) {
        const c = collectIndented(i + 1, base); i = c.next - 1;
        warnings.push(`${name} (asset pipeline / MIC-87): ${arg}`);
        out.push(`{/* TODO ${name}: ${arg} — pending asset pipeline (MIC-87) */}`); continue;
      }
      if (/^\.\.\s+[a-z]/.test(line)) { const c = collectIndented(i + 1, base); i = c.next - 1; warnings.push(`unhandled directive '${name}': ${arg}`); continue; }
    }

    if (/^\.\.\s/.test(line) && !line.match(/^\.\.\s+_/)) continue; // RST comment
    if (line.trim() === '') { flushPara(); continue; }
    para.push(line);
  }
  flushPara();

  const fmLines = ['---', `title: ${(title || route).replace(/"/g, "'")}`];
  if (desc) fmLines.push(`description: ${desc}`);
  fmLines.push('---', '');
  const importLines = [`import { Code } from '@astrojs/starlight/components';`, ...[...imports.entries()].map(([p, v]) => `import ${v} from '${up}${p.replace(/^\//, '')}?raw';`)];
  const helper = `\nexport const lines = (s, spec) => {\n  const L = s.split('\\n');\n  const m = spec.match(/^(\\d+)-(\\d*)$/);\n  const a = m ? +m[1] : 1, b = m && m[2] ? +m[2] : L.length;\n  return L.slice(a - 1, b).join('\\n').replace(/\\s+$/, '');\n};\n`;
  const mdx = `${fmLines.join('\n')}\n${importLines.join('\n')}\n${helper}\n${out.join('\n\n')}\n`;
  return { mdx, title, imports: imports.size, blocks: out.length, warnings };
}

// ---- CLI ----
if (import.meta.url === `file://${process.argv[1]}`) {
  const [, , inFile, outFile] = process.argv;
  const rIdx = process.argv.indexOf('--route'); const dIdx = process.argv.indexOf('--desc');
  if (!inFile || !outFile) { console.error('usage: rst2mdx.mjs <in.rst> <out.mdx> [--route a/b] [--desc "..."]'); process.exit(1); }
  const r = convertRst(fs.readFileSync(inFile, 'utf-8'), { route: rIdx >= 0 ? process.argv[rIdx + 1] : slugRoute(inFile.split('/source/').pop() || ''), desc: dIdx >= 0 ? process.argv[dIdx + 1] : '' });
  fs.writeFileSync(outFile, r.mdx);
  console.error(`wrote ${outFile}\n  imports:${r.imports} blocks:${r.blocks} warnings:${r.warnings.length}`);
  for (const w of r.warnings) console.error('   ⚠ ' + w);
}
