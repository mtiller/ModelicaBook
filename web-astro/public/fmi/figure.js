// Run a book figure's model in the browser.
//
// Loaded on demand, the first time a reader presses Run on any figure: it pulls
// the 2.2 MB driver, which is then cached for every other figure on the site.
// Nothing here is fetched by a page that is only being read.
//
// Each figure gets its own worker. A run is one call into wasm that does not
// return until the simulation ends, so it cannot share the page's thread, and
// OpenModelica's Session holds one FMU per worker.

const WASM = '/wasm';
const sessions = new WeakMap();



// The static plot is lazy-loaded, so a figure that has only just come into view
// may still have no box when the first run finishes. Wait for it, because its
// box is what the canvas has to match.
function staticReady(fig) {
  const img = fig.querySelector('.mbe-figure__static');
  if (!img || img.complete) return Promise.resolve();
  return new Promise((resolve) => {
    const done = () => resolve();
    img.addEventListener('load', done, { once: true });
    img.addEventListener('error', done, { once: true });
    setTimeout(done, 2000);
  });
}

// The static figure's rendered box: what the canvas has to match. Falls back to
// the SVG's intrinsic aspect ratio, then to the container width, so a hidden or
// not-yet-decoded image still gives a sane size rather than 300x150.
function plotBox(canvas) {
  const fig = canvas.closest('.mbe-figure');
  const img = fig && fig.querySelector('.mbe-figure__static');
  const holder = canvas.parentElement || fig;
  if (img) {
    const r = img.getBoundingClientRect();
    if (r.width > 1 && r.height > 1) {
      // offsetLeft/offsetTop are measured against the same containing block an
      // absolutely positioned sibling resolves against, which viewport rects
      // are not: the difference is any padding or margin on the way down, and
      // it put the canvas 16 px low.
      return { width: r.width, height: r.height, left: img.offsetLeft, top: img.offsetTop };
    }
  }
  const width = Math.max(320, Math.round(holder.getBoundingClientRect().width || 640));
  const ratio = img && img.naturalWidth > 0 ? img.naturalHeight / img.naturalWidth : 0.62;
  return { width, height: Math.round(width * ratio), left: 0, top: 0 };
}

const PALETTE = ['#2563eb', '#dc2626', '#059669', '#d97706', '#7c3aed', '#0891b2'];

async function json(url) {
  const r = await fetch(url);
  if (!r.ok) throw new Error(`${url}: ${r.status} ${r.statusText}`);
  return r.json();
}

// Load the FMU into a worker, once per figure. The archive is the model
// description alone (~3 KB): with the transpiled component already on hand the
// driver never needs the binary, so it never has to be downloaded.
async function open(fig, id, onStatus) {
  if (sessions.has(fig)) return sessions.get(fig);
  onStatus('Loading the model…');
  const { Session } = await import(`${WASM}/../fmi/session.js`);
  const manifest = await json(`${WASM}/pack/cases/${id}.json`);
  const archive = await (await fetch(`${WASM}/pack/${manifest.archive}`)).arrayBuffer();
  const session = new Session({ onLog: () => {} });
  const info = await session.load(archive, { base: new URL(`${WASM}/pack/`, location.href).href, manifest });
  const state = { session, info };
  sessions.set(fig, state);
  return state;
}

// What the reader typed, addressed the way FMI addresses it.
function parameters(fig, spec) {
  const out = [];
  for (const p of spec.params || []) {
    if (!p.editable) continue;
    const input = fig.querySelector(`#p-${CSS.escape(fig.dataset.plotId)}-${CSS.escape(p.key)}`);
    const value = Number(input ? input.value : p.default);
    if (!Number.isFinite(value)) throw new Error(`${p.key}: “${input.value}” is not a number`);
    out.push({ vr: Number(p.valueReference), value });
  }
  return out;
}

// The book's own plot: the variables its figure shows, over the case's horizon.
function draw(canvas, spec, result) {
  const stride = result.stride;
  const wanted = (spec.vars || []).map((v) => ({
    ...v, index: result.columns.findIndex((c) => c.name === v.name),
  })).filter((v) => v.index >= 0);
  if (!wanted.length) throw new Error('the result has none of the variables this figure plots');

  const time = new Float64Array(result.rows);
  for (let r = 0; r < result.rows; r++) time[r] = result.values[r * stride];
  const series = wanted.map((v) => {
    const y = new Float64Array(result.rows);
    for (let r = 0; r < result.rows; r++) y[r] = result.values[r * stride + v.index + 1] * (v.scale ?? 1);
    return { legend: v.legend || v.name, y };
  });

  // Take exactly the box the static plot occupies, so swapping one for the
  // other moves nothing on the page. The image is measured while it is still
  // laid out; once it is hidden its rect is zero.
  // Take exactly the box the static plot occupies and sit on top of it, so the
  // swap changes what is drawn and nothing else: same size, same position, no
  // reflow of the page around it.
  const dpr = window.devicePixelRatio || 1;
  const { width: W, height: H, left, top } = plotBox(canvas);
  Object.assign(canvas.style, {
    position: 'absolute', left: `${left}px`, top: `${top}px`,
    width: `${W}px`, height: `${H}px`,
  });
  canvas.width = Math.round(W * dpr); canvas.height = Math.round(H * dpr);
  const g = canvas.getContext('2d');
  g.setTransform(dpr, 0, 0, dpr, 0, 0);
  g.clearRect(0, 0, W, H);

  const pad = { l: 52, r: 12, t: 10, b: 28 };
  const x0 = time[0], x1 = time[time.length - 1];
  let y0 = Infinity, y1 = -Infinity;
  for (const s of series) for (const v of s.y) { if (v < y0) y0 = v; if (v > y1) y1 = v; }
  if (!(y1 > y0)) { y0 -= 1; y1 += 1; }
  const m = (y1 - y0) * 0.06; y0 -= m; y1 += m;
  const px = (t) => pad.l + (t - x0) / (x1 - x0 || 1) * (W - pad.l - pad.r);
  const py = (v) => H - pad.b - (v - y0) / (y1 - y0) * (H - pad.t - pad.b);

  const ink = getComputedStyle(canvas).color || '#444';
  g.strokeStyle = ink; g.globalAlpha = 0.25; g.lineWidth = 1;
  g.beginPath(); g.moveTo(pad.l, pad.t); g.lineTo(pad.l, H - pad.b); g.lineTo(W - pad.r, H - pad.b); g.stroke();
  g.globalAlpha = 0.6; g.fillStyle = ink;
  g.font = '11px system-ui, sans-serif'; g.textAlign = 'right'; g.textBaseline = 'middle';
  for (const v of [y0, (y0 + y1) / 2, y1]) g.fillText(v.toPrecision(3), pad.l - 6, py(v));
  g.textAlign = 'center'; g.textBaseline = 'top';
  for (const t of [x0, (x0 + x1) / 2, x1]) g.fillText(String(+t.toPrecision(4)), px(t), H - pad.b + 6);
  g.globalAlpha = 1;

  series.forEach((s, i) => {
    g.strokeStyle = PALETTE[i % PALETTE.length]; g.lineWidth = 1.75;
    g.beginPath();
    for (let r = 0; r < result.rows; r++) {
      const X = px(time[r]), Y = py(s.y[r]);
      r ? g.lineTo(X, Y) : g.moveTo(X, Y);
    }
    g.stroke();
  });

  // Legend, top-left inside the axes.
  g.font = '11px system-ui, sans-serif'; g.textAlign = 'left'; g.textBaseline = 'middle';
  series.forEach((s, i) => {
    const y = pad.t + 10 + i * 14;
    g.strokeStyle = PALETTE[i % PALETTE.length]; g.lineWidth = 2;
    g.beginPath(); g.moveTo(pad.l + 8, y); g.lineTo(pad.l + 26, y); g.stroke();
    g.fillStyle = ink; g.fillText(s.legend, pad.l + 32, y);
  });
}

export async function simulate(fig, onStatus) {
  const id = fig.dataset.plotId;
  const spec = JSON.parse(fig.dataset.case);
  const t0 = performance.now();
  const { session, info } = await open(fig, id, onStatus);
  const tLoaded = performance.now();
  onStatus('Simulating…');

  // The case's own experiment, so a run with untouched inputs reproduces the
  // figure the book prints. `stepSize` is the output interval, not the solver's.
  const stopTime = spec.stopTime ?? info.defaultExperiment?.stopTime ?? 1;
  const intervals = spec.ncp || 500;
  const result = await session.run({
    interface: info.modelExchange ? 'me' : 'cs',
    solver: 'dassl',
    startTime: 0,
    stopTime,
    stepSize: stopTime / intervals,
    tolerance: spec.tol ?? 1e-6,
    parameters: parameters(fig, spec),
  });

  const canvas = fig.querySelector('.mbe-figure__canvas');
  await staticReady(fig);
  draw(canvas, spec, result);
  canvas.hidden = false;
  const img = fig.querySelector('.mbe-figure__static');
  // Keep the image in the layout rather than removing it: `visibility` holds the
  // box open, so the swap is a redraw and not a reflow of the whole page.
  if (img) img.style.visibility = 'hidden';   // keeps the box; the canvas covers it
  fig.dataset.state = 'live';

  const load = Math.round(tLoaded - t0), run = Math.round(performance.now() - tLoaded);
  onStatus(`${result.rows} points in ${run} ms${load > 20 ? ` (first load ${load} ms)` : ''}`);
}

// Load and warm a figure's model before the reader asks for it.
//
// The first run used to carry the whole cost -- fetching a 2.2 MB driver,
// compiling it, instantiating the component -- which measured ~2.2 s on the
// deployed site. Doing it when the figure scrolls into view moves that off the
// button press: `warm()` instantiates the interface the run will use, so
// pressing Run is only the solve.
export async function prepare(fig, onStatus = () => {}) {
  const id = fig.dataset.plotId;
  if (!id || fig.dataset.prepared) return;
  fig.dataset.prepared = 'pending';
  try {
    const { session, info } = await open(fig, id, () => {});
    await session.warm(info.modelExchange ? 'me' : 'cs');
    fig.dataset.prepared = 'ready';
    onStatus('Ready — press Run');
  } catch (e) {
    // A figure that cannot be prepared is not broken: it still has its plot, and
    // Run will try again and report properly.
    delete fig.dataset.prepared;
  }
}
