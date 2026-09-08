// Copy the built wasm artifacts into the site output, so the book and the
// models it simulates are served from one origin as plain static files.
//
// Only pack/ is staged. It carries the same content as text/results/wasm/aot/
// with the duplicates removed (257 MB -> 16.3 MB), which is the layout that
// makes the shared runtime a single cached download instead of one per figure.
import { cp, mkdir, readdir, stat } from 'node:fs/promises';
import { existsSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const repo = join(here, '..', '..');
const src = join(repo, 'text', 'results', 'wasm');
const dst = join(here, '..', 'dist', 'wasm');

if (!existsSync(join(src, 'pack'))) {
  console.error(`no ${join(src, 'pack')} -- run \`make wasm\` at the repo root first`);
  process.exit(1);
}

await mkdir(dst, { recursive: true });
await cp(join(src, 'pack'), join(dst, 'pack'), { recursive: true });
await cp(join(src, 'index.json'), join(dst, 'index.json'));

let files = 0, bytes = 0;
async function walk(d) {
  for (const e of await readdir(d, { withFileTypes: true })) {
    const p = join(d, e.name);
    if (e.isDirectory()) await walk(p);
    else { files++; bytes += (await stat(p)).size; }
  }
}
await walk(dst);
console.log(`staged ${files} files, ${(bytes / 1048576).toFixed(1)} MB into dist/wasm/`);
