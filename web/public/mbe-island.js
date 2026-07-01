// MIC-84 vertical slice — interactive figure island (stub).
//
// Progressive enhancement: the static plot is already in the DOM and painted.
// This script finds interactive figures, reads the STRUCTURED case payload
// (model name + experiment params, straight from <id>-case.json), and adds an
// "Adjust parameters" affordance. Live re-simulation against the OpenModelica
// API is deliberately out of scope for the slice (MIC-86); the controls are
// present and bound to the real contract, but "Re-run" is disabled with a note.

(function () {
  function fmt(v) {
    return v === null || v === undefined ? '—' : String(v);
  }

  function buildPanel(fig, c) {
    const panel = document.createElement('div');
    panel.className = 'mbe-panel';

    const toggle = document.createElement('button');
    toggle.className = 'mbe-toggle';
    toggle.type = 'button';
    toggle.textContent = 'Adjust parameters';
    toggle.setAttribute('aria-expanded', 'false');

    const body = document.createElement('div');
    body.className = 'mbe-panel-body';
    body.hidden = true;

    const rows = [
      ['Model', c.name],
      ['Stop time', c.stopTime],
      ['Tolerance', c.tol],
      ['Intervals', c.ncp],
    ];
    const dl = document.createElement('dl');
    for (const [k, v] of rows) {
      const dt = document.createElement('dt');
      dt.textContent = k;
      const dd = document.createElement('dd');
      dd.textContent = fmt(v);
      dl.appendChild(dt);
      dl.appendChild(dd);
    }
    body.appendChild(dl);

    const rerun = document.createElement('button');
    rerun.className = 'mbe-rerun';
    rerun.type = 'button';
    rerun.textContent = 'Re-run simulation';
    rerun.disabled = true;
    rerun.title = 'Live simulation is not wired in this slice (MIC-86).';
    body.appendChild(rerun);

    const note = document.createElement('p');
    note.className = 'mbe-note';
    note.textContent =
      'Live re-simulation is deferred (MIC-86). These values come from the ' +
      'structured case payload — the same data the figure renders from.';
    body.appendChild(note);

    toggle.addEventListener('click', function () {
      const open = body.hidden;
      body.hidden = !open;
      toggle.setAttribute('aria-expanded', String(open));
    });

    panel.appendChild(toggle);
    panel.appendChild(body);
    return panel;
  }

  function plotIdFromClass(el) {
    // The directive encodes the id as `mbe-plot-<id>` (mystmd strips data-*
    // attrs from raw HTML, but class names survive sanitization).
    const m = /(?:^|\s)mbe-plot-([A-Za-z0-9_]+)(?:\s|$)/.exec(el.className);
    return m ? m[1] : null;
  }

  function hydrate() {
    const figs = document.querySelectorAll('.mbe-figure.interactive');
    figs.forEach(function (fig) {
      if (fig.dataset.hydrated) return;
      const id = plotIdFromClass(fig);
      if (!id) return;
      fig.dataset.hydrated = '1';
      // Fetch the structured contract published by the build plugin.
      fetch('/cases/' + id + '.json')
        .then(function (r) { return r.ok ? r.json() : null; })
        .then(function (c) {
          if (c) fig.appendChild(buildPanel(fig, c));
        })
        .catch(function () { /* static plot remains as the base case */ });
    });
  }

  // The built site hydrates as a React app; mount after `load` (post-hydration)
  // and retry a couple of times so we append to figures React has settled.
  function schedule() {
    hydrate();
    setTimeout(hydrate, 300);
    setTimeout(hydrate, 1200);
  }
  if (document.readyState === 'complete') {
    schedule();
  } else {
    window.addEventListener('load', schedule);
  }
})();
