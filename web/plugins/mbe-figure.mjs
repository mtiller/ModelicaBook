// MIC-84 vertical slice: the `mbe-figure` directive.
//
// Replaces the legacy Sphinx `.. plot::` + `:class: interactive` + nextgen
// `interactiveInjector` (which recovered the model id by string-slicing an
// image `src`). Here the figure carries a *structured* payload sourced from
// the build-generated `<id>-case.json` (model name, stopTime, tol, ncp, mods,
// vars) — the same data the old pipeline already produced and then threw away.
//
// The directive always renders the static plot (the progressive-enhancement
// base case). When `:interactive:` is set, it tags the figure with a
// sanitizer-safe `mbe-plot-<id>` class and validates that the structured
// contract (public/cases/<id>.json) exists. The client-side hydration into an
// "adjust parameters" affordance (public/mbe-island.js) requires a mystmd
// theme-component hook to load JS + serve the contract JSON — see web/README.md
// "Interactive island (next step)". Live re-simulation is out of scope for the
// slice (MIC-86).

import fs from 'node:fs';
import path from 'node:path';

// Canonical, committed contract: public/cases/<id>.json (in the real pipeline
// these are emitted by the specs DSL / _generate_casedata — MIC-87). They ship
// as static assets so the client island can fetch /cases/<id>.json at runtime.
function loadCase(id) {
  const p = path.join(process.cwd(), 'public', 'cases', `${id}.json`);
  try {
    return JSON.parse(fs.readFileSync(p, 'utf-8'));
  } catch {
    return null;
  }
}


const mbeFigure = {
  name: 'mbe-figure',
  doc: 'A Modelica by Example figure: static plot, optionally interactive.',
  arg: { type: String, doc: 'Plot/case id (e.g. FO), matching content/_plots/<id>.svg' },
  options: {
    interactive: { type: Boolean, doc: 'Enable the interactive parameter island.' },
    caption: { type: String, doc: 'Figure caption.' },
  },
  run(data, vfile) {
    const id = data.arg;
    const interactive = Boolean(data.options?.interactive);
    const caption = data.options?.caption ?? '';

    // Static base case: a real MyST image node (path relative to the source
    // file) so mystmd copies/fingerprints the SVG and rewrites the URL.
    const image = {
      type: 'image',
      url: `_plots/${id}.svg`,
      alt: caption || id,
    };
    const figureChildren = [image];
    if (caption) {
      figureChildren.push({
        type: 'caption',
        children: [{ type: 'paragraph', children: [{ type: 'text', value: caption }] }],
      });
    }
    // Encode the interactive marker + plot id in the CSS class. mystmd's HTML
    // sanitizer strips arbitrary data-* attributes and <script> tags from raw
    // HTML, but class names survive — so the id rides in as `mbe-plot-<id>`,
    // and the client island (public/mbe-island.js) reads it from there and
    // fetches /cases/<id>.json. Full hydration also needs mbe-island.js loaded
    // on the page, which requires a mystmd theme-component hook (next step,
    // co-designed with Jony).
    if (interactive) {
      // Warn early if an interactive figure is missing its contract file.
      if (!loadCase(id)) {
        vfile?.message?.(`mbe-figure: no case data at public/cases/${id}.json`);
      }
    }
    const figure = {
      type: 'container',
      kind: 'figure',
      class: interactive
        ? `mbe-figure interactive mbe-plot-${id}`
        : 'mbe-figure',
      children: figureChildren,
    };
    return [figure];
  },
};

const plugin = { name: 'mbe-figure-plugin', directives: [mbeFigure] };
export default plugin;
