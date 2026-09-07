# Browser WASM case artifacts

Every case the book simulates is also exported as a WebAssembly-backed FMI 3.0
FMU, so that the interactive figures can eventually run in the reader's browser
instead of round-tripping to `mbe-api.modelica.university`. **Nothing consumes
these yet.** They are built, and kept building, ahead of the client work.

```sh
make wasm          # from the repo root; implies `make specs`
```

This reproduces only the `build-wasm-*` stages in `text/dvc.yaml`. The native
simulation sweep (`make results`) is untouched, and so is everything downstream
of it — plots, Sphinx, the ebooks, `exes.tar.gz`, `api/`. Each artifact is its
own DVC output, so unchanged cases come from the cache.

## What gets built

For each case, under `text/results/wasm/`:

| path | what it is |
|---|---|
| `dylink/<case>.fmu` | An unzipped FMU holding the model kernel and nothing else, at `binaries/wasm32-om-dylink/`. Median **16 KB**. Its host has to link it against a prebuilt adapter, which today means an OpenModelica importer — there is no browser host for this form. |
| `component/<case>.fmu` | A portable fmi-ls-wasm component at `binaries/wasm32-wasip2/`. About **2 MB** (710 KB zipped) because it carries the runtime with it. This is the form a browser can run today. |
| `aot/<case>/` | The component transpiled ahead of time into core modules + glue + `manifest.json`. See below. |
| `pack/` | The same AOT content, content-addressed so identical blobs are stored and served once. **This is the deployable layout.** |
| `index.json` | One entry per case: the model, its artifacts and their sizes, and the simulation settings an importer must apply. |

Both forms come out of a single `omc` run (`<case>-wasm.mos`); the only
difference is `--fmuDirectory`, which selects the host-linked artifact. Building
both costs about 0.7 s per case, so which one to *ship* stays an open question
rather than a build-time commitment.

## The ahead-of-time transpile

A browser cannot instantiate a WebAssembly *Component* — `WebAssembly.instantiate`
takes core modules. OpenModelica's own `fmi-simulator` page therefore ships jco's
transpiler (~9.3 MB) and converts Component → core modules in the page. Measured
on MIC-178, that transpile was 1424 ms of a 1598 ms first load.

The book's model set is known at build time, so `transpile.mjs` does the same
conversion once per case here instead. Measured end to end: `session.load()`
1598 ms → 169 ms, page-open-to-first-result 1854 ms → 364 ms, and the shared
download drops from ~11.5 MB to the 2.2 MB driver alone. It costs ~1.4 s per case
at build time.

`manifest.json` is not optional: the loader reads `exports` to enumerate the
FMU's interfaces and `imports` to filter native imports.

## Content-addressed packing

jco names its core modules positionally (`fmu.core.wasm`, `fmu.core2.wasm`, …)
and the numbering shifts from model to model, which hides how much the cases have
in common. By content they barely differ: across the 98 cases, **186 MB of core
modules is 12.8 MB of distinct bytes**, and 1.85 MB of that — the OpenModelica
runtime — is byte-identical in every single case. The glue is nearly shared too:
`fmu.js` is 747 KB but has only four distinct variants.

Laid out per case none of that can be shared, because each
`aot/<case>/fmu.core9.wasm` is its own URL. `pack.py` rewrites the tree so every
distinct blob has one content-addressed path:

```
pack/blobs/<sha256[:16]>.wasm    each distinct core module, once
pack/blobs/<sha256[:16]>.js      each distinct glue file, once
pack/cases/<case>.json           logical name -> blob path, + imports/exports
```

98 cases become **127 blobs, 16.3 MB** — 15.7x smaller — in under a second.
Blobs are hardlinked from the DVC outputs, so the packed tree costs no extra
space.

The logical names have to survive the rename, because that is what the glue asks
for: `fmu-core.js` builds `cores` as a `Map` keyed by jco's name and the
generated module calls `compile(name)` against it. The client may fetch those
bytes from any URL — it just needs the mapping, which is what
`pack/cases/<case>.json` is.

What this buys a reader, assuming the blobs are served at those shared paths:
about **0.75 MB gzipped for the first figure on a page** (runtime + glue + the
model's own core), then **~16 KB for each figure after it**. Laid out per case it
would be 0.75 MB every time.

## Simulation settings live beside the artifact, not inside it

`buildModelFMU` takes no simulation settings, so an exported FMU carries the
model's own `experiment` annotation as its `DefaultExperiment` — which for 74 of
97 cases is *not* the case's stopTime. Parameter modifications are the same
story: the native pipeline passes them to the runtime as `-override`, so the FMI
equivalent is `fmi3Set*` before initialization, not a compile-time setting.

Both therefore stay in `text/results/json/<case>-case.json` (already emitted by
`make specs`, already consumed by the astro slice) and are summarized per case in
`wasm/index.json`. An importer that ignores them will run the wrong experiment.

## The toolchain

`--simCodeTarget=wasm-jit` needs an OpenModelica built from master with
`OM_OMC_ENABLE_RUST=ON`. That option defaults to `OFF`, and Docker Hub's
`openmodelica/openmodelica` carries release tags only, all of them pre-wasm — so
**no published image has this compiler**. Building it is a ~72 minute from-source
build, documented on MIC-178.

`Dockerfile` here adds what the book build needs (python3 + jinja2, dvc, node,
unzip, git, and the MSL) on top of that base, and rebuilds in seconds:

```sh
tools/wasm/build-image.sh              # build
tools/wasm/build-image.sh --push       # build and push to ghcr.io
```

The result is `ghcr.io/mtiller/omc-wasm:<om-sha>`, which is what the
`generate_wasm` job in `.github/workflows/build.yaml` runs in. Pin the SHA; do
not track OpenModelica master.

### MSL version

The image installs **Modelica 3.2.3+maint.om**, which is what
`tools/check-models` already pins, and which builds all 98 cases. The library
declares `uses(Modelica 3.2.2)`; the open 3.2.2 → 4.0 migration question is
untouched by this choice.
