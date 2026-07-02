#!/usr/bin/env node
// MIC-84 / MIC-85 — print pipeline preprocessor: MDX chapter → print Markdown.
//
// PDF/eBook do NOT come from Astro (a web renderer). They come from the same
// Markdown source via Pandoc. The only wrinkle is MDX components, which Pandoc
// doesn't understand — so this step lowers them to their print representation:
//
//   <SimFigure id="FO" caption="…"/>      →  ![caption](plots/FO.svg)
//        (the interactive island degrades to its static plot — exactly right for
//         print; the static plot was always the base case)
//   <Code code={body(firstOrder)} …/>     →  ```modelica … ```  (inlined from the
//        actual .mo file, so print stays sourced from the single source of truth)
//   {/* #id */} heading labels            →  Pandoc `{#id}` header attributes
//   :::note[Title] … :::                  →  Pandoc fenced div ::: {.note} …
//   import/export lines                    →  stripped
//
// Output feeds Pandoc (see print/README.md) for PDF (LaTeX/Typst) and EPUB.
// Cross-references keep their `#id` targets; final numbered/titled ref text in
// print is produced by pandoc-crossref (see README) — the web build uses the
// remark-xref plugin.

import fs from 'node:fs';
import path from 'node:path';

const inFile = process.argv[2];
const outFile = process.argv[3];
if (!inFile) {
  console.error('usage: build-print-md.mjs <chapter.mdx> [out.md]');
  process.exit(1);
}
const srcDir = path.dirname(path.resolve(inFile));
let text = fs.readFileSync(inFile, 'utf-8');

// --- frontmatter: keep the title as an H1, drop the rest ---
let title = '';
text = text.replace(/^---\n([\s\S]*?)\n---\n/, (_m, fm) => {
  const t = fm.match(/^title:\s*(.+)$/m);
  title = t ? t[1].trim() : '';
  return '';
});

// --- collect `import VAR from 'PATH?raw'` → resolve raw file contents ---
const rawImports = {};
text = text.replace(/^import\s+(\w+)\s+from\s+'([^']+?)\?raw';\s*$/gm, (_m, v, p) => {
  const abs = path.resolve(srcDir, p);
  rawImports[v] = fs.existsSync(abs) ? fs.readFileSync(abs, 'utf-8') : '';
  return '';
});
// drop any other import / export lines
text = text.replace(/^(import|export)\s.*$/gm, '');

// `body(x)` mirror of the MDX helper: drop first line, trim end
const body = (s) => s.split('\n').slice(1).join('\n').trimEnd();

// --- <Code code={body(VAR)} ... title="T" /> → fenced modelica block ---
text = text.replace(
  /<Code\s+code=\{body\((\w+)\)\}[^>]*?(?:title="([^"]*)")?[^>]*\/>/g,
  (_m, v, t) => {
    const code = body(rawImports[v] ?? '');
    const header = t ? `**${t}**\n\n` : '';
    return `${header}\`\`\`modelica\n${code}\n\`\`\``;
  },
);

// --- <SimFigure id="X" ... caption="Y" /> → static image (print form) ---
// Number figures and record id→"Figure N" so cross-references resolve (parity
// with the web remark-xref plugin). Image path is relative to the web-astro root
// (pandoc is run from there; resource-path in the defaults covers it).
const labels = {};
let figNo = 0;
text = text.replace(/<SimFigure\s+([^>]*)\/>/g, (_m, attrs) => {
  const id = (attrs.match(/id="([^"]+)"/) || [])[1] || '';
  const caption = (attrs.match(/caption="([^"]*)"/) || [])[1] || id;
  figNo += 1;
  if (id) labels[id] = `Figure ${figNo}`;
  return `![Figure ${figNo}. ${caption}](public/plots/${id}.svg){#${id}}`;
});

// --- heading labels {/* #id */} → Pandoc header attribute {#id} ---
text = text.replace(/^(#{1,6}\s+.*?)\s*\{\/\*\s*#([\w-]+)\s*\*\/\}\s*$/gm, '$1 {#$2}');
// record heading id→title for :ref:-style resolution
for (const m of text.matchAll(/^#{1,6}\s+(.*?)\s*\{#([\w-]+)\}\s*$/gm)) {
  labels[m[2]] = m[1].trim();
}
// resolve empty-text refs [](#id) → [title|"Figure N"](#id)
text = text.replace(/\[\]\(#([\w-]+)\)/g, (_m, id) => `[${labels[id] || id}](#${id})`);

// --- Starlight aside :::note[Title] ... ::: → Pandoc fenced div ---
text = text.replace(/^:::(\w+)(?:\[([^\]]*)\])?\s*$/gm, (_m, kind, ttl) =>
  `::: {.${kind}}\n${ttl ? `**${ttl}**\n` : ''}`);
// closing ::: already valid Pandoc fenced-div syntax

const out = `${title ? `# ${title}\n\n` : ''}${text.replace(/\n{3,}/g, '\n\n').trim()}\n`;
if (outFile) {
  fs.writeFileSync(outFile, out);
  console.log(`wrote ${outFile} (${out.length} bytes)`);
} else {
  process.stdout.write(out);
}
