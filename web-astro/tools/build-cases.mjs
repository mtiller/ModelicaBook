#!/usr/bin/env node
// MIC-84 / MIC-87 — adapt the pipeline's per-case metadata into <SimFigure>'s
// case contract. text/results/json/<res>-case.json is already ~exactly the Astro
// schema (from the specs DSL); we just add params:[] and emit src/cases/<res>.json.
//
// This is a REFRESH step, not a build step: its input (text/results/) is DVC
// output that is absent from a clean clone, while its output (src/cases/*.json)
// is committed precisely because it cannot be rebuilt here. So it is NOT wired
// into predev/prebuild — run it after a DVC pull + `make results`, then commit
// the result:
//
//     npm run refresh:cases
//
// The registry that <SimFigure> consumes (src/cases/index.ts) is hand-written
// and derives itself from the *.json on disk via import.meta.glob. This script
// deliberately does not write it — an earlier version did, and on any checkout
// without text/results/ it silently overwrote it with an empty registry,
// disabling every interactive figure with a green build.
import fs from 'node:fs';
import path from 'node:path';

const SRC = '../text/results/json';
const OUT = 'src/cases';
// Parameters come from the wasm build, which reads them out of each FMU's
// modelDescription.xml -- the only place they exist. It is a separate DVC
// pipeline (`make wasm`), so treat it as optional: without it the contracts
// keep params:[] and every figure falls back to its static plot, which is
// exactly what SimFigure already does.
const WASM_INDEX = '../text/results/wasm/index.json';

if (!fs.existsSync(SRC)) {
  console.error(
    `build-cases: ${SRC} not found.\n` +
    `  It is DVC output — run a DVC pull and \`make results\` first.\n` +
    `  The committed src/cases/*.json are left untouched.`,
  );
  process.exit(1);
}

fs.mkdirSync(OUT, { recursive: true });

let wasmCases = {};
if (fs.existsSync(WASM_INDEX)) {
  wasmCases = JSON.parse(fs.readFileSync(WASM_INDEX, 'utf8')).cases ?? {};
} else {
  console.warn(
    `build-cases: ${WASM_INDEX} not found — figures will keep params:[] and stay static.\n` +
    `  Run \`make wasm\` at the repo root to populate them.`,
  );
}

// The FMU calls a parameter by its Modelica name, which is the name the book's
// prose uses too, so that is the label. `description` rides along for a tooltip.
function toParam(p) {
  const out = {
    key: p.name,
    label: p.name,
    default: p.default,
    editable: p.editable,
    type: p.type,
    // What fmi3Set* needs to address it, so a client never has to re-parse the
    // model description at runtime.
    valueReference: p.valueReference,
  };
  for (const k of ['description', 'unit', 'displayUnit', 'min', 'max', 'overridden']) {
    if (p[k] !== undefined) out[k] = p[k];
  }
  return out;
}

const files = fs.readdirSync(SRC).filter((f) => f.endsWith('-case.json'));
const ids = [];
let withParams = 0;
for (const f of files) {
  const j = JSON.parse(fs.readFileSync(path.join(SRC, f), 'utf8'));
  const id = j.res || f.replace(/-case\.json$/, '');
  j.params = (wasmCases[id]?.parameters ?? []).map(toParam);
  if (j.params.some((p) => p.editable)) withParams++;
  fs.writeFileSync(path.join(OUT, `${id}.json`), JSON.stringify(j, null, 2) + '\n');
  ids.push(id);
}

// Assert on the output, not the input: "wrote an empty registry" is the actual
// failure mode, and a present-but-empty SRC reaches it too.
if (ids.length === 0) {
  console.error(
    `build-cases: ${SRC} exists but contains no *-case.json — refusing to leave ` +
    `src/cases/ without case data.`,
  );
  process.exit(1);
}

const unique = new Set(ids);
console.log(
  `wrote ${unique.size} case JSONs to ${OUT}/ ` +
  `(${withParams} with editable parameters; index.ts is hand-written, untouched)`,
);
