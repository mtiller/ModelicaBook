// MIC-84 spike — post-build island injection.
//
// Why this exists: mystmd's book-theme (a) sanitizes raw HTML (strips data-*
// and <script>) and (b) offers no config hook to add a page script (only
// analytics_google/plausible). So the interactive figure island cannot be
// emitted from the directive. The two ways to get it onto the page are:
//
//   1. A custom mystmd theme (fork of @myst-theme/book) that registers a React
//      renderer for the figure node — robust, idiomatic, works in dev too, but
//      means owning/maintaining a theme package.
//   2. This: a post-build step that copies the island assets into the built
//      site and injects <link>/<script> into each page AFTER mystmd has run
//      (so it bypasses sanitization). Lightweight; works for the static build.
//      Caveat: the built site hydrates as a React app, so the island mounts
//      after `load` and appends to figure nodes React isn't re-rendering.
//
// This script implements (2) to demonstrate a working island for the slice.
// See web/SPIKE.md for the full findings + recommendation.

import fs from 'node:fs';
import path from 'node:path';

const HTML_DIR = path.resolve('_build/html');
const PUBLIC_DIR = path.resolve('public');

if (!fs.existsSync(HTML_DIR)) {
  console.error(`postbuild: ${HTML_DIR} not found — run \`myst build --html\` first.`);
  process.exit(1);
}

// 1. Copy public/ assets (cases/*.json, mbe-island.js, mbe-island.css) into the
//    built site root so they're served at /cases/... and /mbe-island.*
function copyDir(src, dst) {
  fs.mkdirSync(dst, { recursive: true });
  for (const entry of fs.readdirSync(src, { withFileTypes: true })) {
    const s = path.join(src, entry.name);
    const d = path.join(dst, entry.name);
    if (entry.isDirectory()) copyDir(s, d);
    else fs.copyFileSync(s, d);
  }
}
if (fs.existsSync(PUBLIC_DIR)) copyDir(PUBLIC_DIR, HTML_DIR);

// 2. Inject island asset tags into every built HTML page (idempotent).
const TAGS =
  '<link rel="stylesheet" href="/mbe-island.css">' +
  '<script src="/mbe-island.js" defer></script>';

function injectInto(file) {
  let html = fs.readFileSync(file, 'utf-8');
  if (html.includes('/mbe-island.js')) return false; // already injected
  if (html.includes('</head>')) {
    html = html.replace('</head>', `${TAGS}</head>`);
  } else {
    html = html + TAGS;
  }
  fs.writeFileSync(file, html);
  return true;
}

function walkHtml(dir) {
  let n = 0;
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, entry.name);
    if (entry.isDirectory()) n += walkHtml(p);
    else if (entry.name.endsWith('.html')) n += injectInto(p) ? 1 : 0;
  }
  return n;
}

const injected = walkHtml(HTML_DIR);
console.log(`postbuild: island assets copied; injected tags into ${injected} page(s).`);
