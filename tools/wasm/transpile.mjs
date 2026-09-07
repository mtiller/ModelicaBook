#!/usr/bin/env node
//
// Ahead-of-time jco transpile for a wasm FMU's component.
//
// A browser cannot instantiate a WebAssembly *Component*; `WebAssembly.instantiate`
// takes core modules. OpenModelica's own fmi-simulator page therefore ships jco's
// transpiler (~9.3 MB) and converts Component -> core modules + JS glue in the page,
// which measured 1424 ms of a 1598 ms first load. It has to: it accepts FMUs it has
// never seen.
//
// The book's model set is known at build time, so the same conversion runs here once
// per case instead. That drops the reader's shared download from ~11.5 MB to the
// 2.2 MB driver alone, and the load from ~1598 ms to ~169 ms. See MIC-178.
//
// Usage:
//   node transpile.mjs --fmu <path/to/case.fmu> --out <dir> [--vendor <dir>]
//
// --vendor points at OpenModelica's staged web bundle
// (share/omc/web/fmi-simulator/vendor). Defaults to $OM_WEB_VENDOR, else
// /opt/om-web/fmi-simulator/vendor, which is where the omc-wasm image keeps it.

import { execFileSync } from 'node:child_process';
import { existsSync, mkdirSync, readFileSync, rmSync, symlinkSync, writeFileSync } from 'node:fs';
import { basename, join, resolve } from 'node:path';
import { tmpdir } from 'node:os';
import { pathToFileURL } from 'node:url';

function arg(name, fallback) {
  const i = process.argv.indexOf(name);
  if (i >= 0 && i + 1 < process.argv.length) return process.argv[i + 1];
  if (fallback !== undefined) return fallback;
  console.error(`transpile.mjs: missing required argument ${name}`);
  process.exit(2);
}

const fmuPath = resolve(arg('--fmu'));
const outDir = resolve(arg('--out'));
const vendor = resolve(arg('--vendor', process.env.OM_WEB_VENDOR || '/opt/om-web/fmi-simulator/vendor'));

if (!existsSync(vendor)) {
  console.error(`transpile.mjs: no jco vendor bundle at ${vendor}\n` +
    `Set --vendor or $OM_WEB_VENDOR to OpenModelica's share/omc/web/fmi-simulator/vendor.`);
  process.exit(1);
}

// The component the FMU carries. fmi-ls-wasm puts it at binaries/wasm32-wasip2/.
// (The dylink form has no component at all -- that is the point of it -- so this
// step only applies to the component export.)
const entries = execFileSync('unzip', ['-Z1', fmuPath], { encoding: 'utf8' }).split('\n');
const entry = entries.find((n) => n.startsWith('binaries/wasm32-wasip2/') && n.endsWith('.wasm'));
if (!entry) {
  console.error(`transpile.mjs: ${basename(fmuPath)} has no binaries/wasm32-wasip2/*.wasm.\n` +
    `Only the component export can be transpiled; a dylink export is linked by its host instead.`);
  process.exit(1);
}
const component = new Uint8Array(execFileSync('unzip', ['-p', fmuPath, entry], { maxBuffer: 1 << 30 }));

// jco's own bundle imports @bytecodealliance/preview2-shim by bare specifier, which
// resolves under Node only from a node_modules tree the staged bundle does not have.
// The browser page rewrites those specifiers to URLs (fmu-core.js:34); do the same,
// into a staging directory whose siblings are the two core modules the bundle loads
// relative to its own import.meta.url.
const stage = join(tmpdir(), 'mbe-jco-node');
const bindgen = join(stage, 'js-component-bindgen-component.js');
if (!existsSync(bindgen)) {
  rmSync(stage, { recursive: true, force: true });
  mkdirSync(stage, { recursive: true });
  for (const core of ['js-component-bindgen-component.core.wasm', 'js-component-bindgen-component.core2.wasm']) {
    symlinkSync(join(vendor, core), join(stage, core));
  }
  const src = readFileSync(join(vendor, 'js-component-bindgen-component.js'), 'utf8');
  writeFileSync(bindgen, src.replace(
    /(['"])@bytecodealliance\/preview2-shim\/(\w+)\1/g,
    (_, q, name) => JSON.stringify(pathToFileURL(join(vendor, 'preview2-shim', `${name}.js`)).href)));
}

const t0 = performance.now();
const jco = await import(pathToFileURL(bindgen).href);
await jco.$init;

// The same options the page passes in fmu-core.js, so the generated glue is
// byte-identical to what the in-page transpile would have produced.
const gen = jco.generate(component, {
  name: 'fmu', map: [], instantiation: { tag: 'async' },
  validLiftingOptimization: false, tracing: false, noNodejsCompat: true,
  noTypescript: true, tlaCompat: false, base64Cutoff: 0,
  noNamespacedExports: false, multiMemory: false,
});

rmSync(outDir, { recursive: true, force: true });
mkdirSync(outDir, { recursive: true });
let bytes = 0;
for (const [name, content] of gen.files) {
  writeFileSync(join(outDir, name), content);
  bytes += content.length;
}
// Required, not optional: the loader reads gen.exports to enumerate the FMU's
// interfaces and gen.imports to filter native imports. Without them the page
// fails with "Cannot read properties of undefined (reading 'some')".
writeFileSync(join(outDir, 'manifest.json'),
  JSON.stringify({ imports: gen.imports, exports: gen.exports }, null, 2));

console.log(`${basename(fmuPath)}: ${gen.files.length} files, ${bytes.toLocaleString()} bytes, ` +
  `${gen.imports.length} imports, ${gen.exports.length} exports in ${(performance.now() - t0).toFixed(0)} ms`);
