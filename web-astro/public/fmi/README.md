# Vendored OpenModelica FMI browser driver

From OpenModelica master `3998b1f8b814aaf68514fcdc6fc83cfab7d6ed1c`, built with
`-DOM_OMC_WASM=ON -DRUST_OMC_WASM_MODE=web-release` and staged from
`share/omc/web/fmi-simulator/`. See MIC-178.

| file | what it is |
|---|---|
| `openmodelica_fmi_web.wasm` | the driver: FMI masters, DASSL/CVODE/IDA/gbode/euler/rungekutta, result writer. 2.2 MB, downloaded once for the whole book. |
| `driver.js` | binds that module to a WASI filesystem and the FMU's core exports |
| `fmu-core.js` | reaches the component's *core* exports past jco's wrappers (238 ns vs 7684 ns per `fmi3SetTime`) |
| `fmu.js`, `wasi.js` | the FMI call surface and the WASI shim binding |
| `session.js`, `fmi-worker.js` | one worker per figure; a run is a single call into wasm and cannot share the UI thread |
| `vendor/preview2-shim/` | the WASI preview2 shim the component imports. 120 KB. |

## Local changes

Four small patches, all to support ahead-of-time transpiling. Upstream loads
jco's 8.9 MB transpiler and converts the component in the page; the book does
that at build time (`tools/wasm/transpile.mjs`), so:

- `fmu-core.js` — `loadComponent()` takes an optional `aot` manifest and fetches
  the pre-generated core modules and glue instead of calling `generate()`.
  Everything downstream is the same code on the same bytes.
- `driver.js` — carries the manifest, and skips `om_fmi_select_component` when
  it has one. That is what lets the FMU archive be a model description alone.
- `fmi-worker.js`, `session.js` — thread the manifest from the page to the driver.

`session.js` also already carries upstream's `warm()` fix (MIC-178).

**Not vendored:** `vendor/js-component-bindgen-*` (8.9 MB). Removing it from the
reader's download is the entire point of the AOT step.
