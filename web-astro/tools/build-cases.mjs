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

if (!fs.existsSync(SRC)) {
  console.error(
    `build-cases: ${SRC} not found.\n` +
    `  It is DVC output — run a DVC pull and \`make results\` first.\n` +
    `  The committed src/cases/*.json are left untouched.`,
  );
  process.exit(1);
}

fs.mkdirSync(OUT, { recursive: true });

const files = fs.readdirSync(SRC).filter((f) => f.endsWith('-case.json'));
const ids = [];
for (const f of files) {
  const j = JSON.parse(fs.readFileSync(path.join(SRC, f), 'utf8'));
  const id = j.res || f.replace(/-case\.json$/, '');
  if (!j.params) j.params = [];              // Astro schema adds editable params (none by default)
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
console.log(`wrote ${unique.size} case JSONs to ${OUT}/ (index.ts is hand-written, untouched)`);
