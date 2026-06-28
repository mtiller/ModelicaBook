# Architecture

This document describes how the *Modelica by Example* project fits together: how
the book is built from source, how the examples are simulated and tested, how the
reading UI is produced, how content is injected into that UI, how interactive
simulation works, and how translations are handled.

It is a map for contributors and maintainers. For *how to run* the build, see
[`BUILD.md`](BUILD.md); for translation logistics see [`TRANSLATION.md`](TRANSLATION.md).

---

## 1. The big picture

The project has four cooperating parts:

1. **Source content** — the prose (Sphinx reStructuredText) and the Modelica
   example library (`ModelicaByExample/`).
2. **The build pipeline** (`text/`) — turns that source into simulation results,
   plots, and rendered book formats (HTML/JSON/ePub/PDF), using OpenModelica,
   DVC, and Sphinx.
3. **The reading UI** (`nextgen/`) — a Next.js app that consumes the Sphinx JSON
   output and renders the interactive book website.
4. **The simulation API** (`api/`) — a cloud service that runs the example
   simulations on demand for the UI's interactive figures.

```
   ┌──────────────────────────────────────────────────────────────────────┐
   │ SOURCE                                                                 │
   │   text/source/**.rst        ModelicaByExample/**.mo     text/specs.py  │
   │   (prose, Sphinx)           (Modelica examples)         (case+plot DSL)│
   └───────────────┬───────────────────┬──────────────────────────┬────────┘
                   │                    │                          │
                   │            ┌───────▼────────┐         ┌───────▼────────┐
                   │            │ OpenModelica   │  specs  │ generates:     │
                   │            │ via DVC        │◄────────│  .mos scripts  │
                   │            │ (make results) │         │  dvc.yaml      │
                   │            └───────┬────────┘         │  plots/*.py    │
                   │                    │                  │  *-case.json   │
                   │            _res.mat,_init.xml,        └────────────────┘
                   │            _info.json, executables
                   │                    │
          ┌────────▼────────────────────▼─────────┐
          │ Sphinx builders (make dirhtml/json/    │
          │  epub/mobi/latex→pdf)                  │
          │  + xogeny.sim extension                │
          │  + xogeny-semantic theme               │
          └───┬───────────────┬──────────────┬─────┘
              │ .fjson         │ dirhtml      │ epub/pdf
              │                │ (legacy      │ (downloadable
              ▼                │  static site)│  book formats)
   ┌──────────────────────┐    └──────────────┘
   │ nextgen/ (Next.js)   │
   │  copy_en_files →json/│           ┌─────────────────────────────┐
   │  Reactify + injectors│──────────►│ api/ (cloud sim service)    │
   │  lunr search         │  Siren    │ mbe-api.modelica.university │
   │  → static export     │  hypermedia│ runs OM executables on req │
   └──────────┬───────────┘           └─────────────────────────────┘
              │ deploy (ZEIT Now / static host)
              ▼
        mbe.modelica.university
```

---

## 2. Repository layout

| Path | Purpose |
|------|---------|
| `ModelicaByExample/` | The Modelica library of worked examples the book teaches from (a standard Modelica package; declares `uses(Modelica 3.2.2)`). |
| `text/` | The book build system: Sphinx sources, the simulation-spec generator, Makefiles, DVC pipeline, locales. |
| `text/source/` | Sphinx reStructuredText content (`behavior/`, `components/`, `advanced.rst`, `front/`, …), `conf.py`, custom extensions and theme. |
| `text/specs.py` | A Python DSL describing which models to simulate and which plots to produce. |
| `text/locale/` | gettext translation catalogs (`<lang>/LC_MESSAGES/*.po,*.mo`). |
| `nextgen/` | **(git submodule)** The current production reading UI — a Next.js/TypeScript app. |
| `api/` | The cloud simulation service that powers interactive figures. |
| `generator/` | **(git submodule)** An earlier `react-static` site generator that also consumes Sphinx `.fjson`; predecessor to `nextgen`. |
| `apps/` | **(git submodule)** Auxiliary Create-React-App apps. |
| `docker/` | Dockerfiles for the build toolchain (OpenModelica + Sphinx/LaTeX). See §8 for their current state. |
| `tools/` | Repo tooling, including `tools/check-models/` (model regression check, §5) and `tools/mobe/` (a Go helper). |
| `images/`, `sponsors/`, `org/` | Figures, sponsor assets, and project org material (translators, reviewers, art). |
| `retired/` | The previous (pre-DVC) build system; superseded, kept for reference. |
| `.dvc/` | DVC configuration and the local content-addressed result cache. |
| `Makefile` | Root orchestrator; mostly delegates into `text/` and `nextgen/` and is the entry point used by CI. |

The submodules (`nextgen`, `generator`, `apps`) live in their own repositories
(`mtiller/book-nextgen`, `book-generator`, `book-apps`). Run
`git submodule update --init` after cloning.

---

## 3. Source content

There are three distinct kinds of source:

- **Prose** — reStructuredText under `text/source/`, authored for Sphinx. This is
  the narrative of the book.
- **Examples** — Modelica models under `ModelicaByExample/`. The prose references
  these by name; they are the ground truth that gets compiled, simulated, and
  shown as source listings.
- **Simulation specs** — `text/specs.py`. Rather than hand-writing simulation
  scripts and plot definitions, the project *declares* them with a small DSL:

  ```python
  add_case(["SimpleExample", "FirstOrder$"], res="FO", stopTime=10)
  add_simple_plot(plot="FO", vars=[Var("x", legend=_("x"))],
                  title=_("Simulation of FirstOrder"))
  ```

  `add_case` registers a model to simulate (with stop time, tolerance,
  modifications, etc.); `add_simple_plot` / `add_compare_plot` declare the figures
  derived from those results. The `_( )` wrappers are gettext calls, so plot
  titles and legends are translatable (see §7). The generator backing this DSL is
  the `xogeny` package in `text/source/_sphinxext/`.

---

## 4. The build pipeline (`text/`)

The build is a chain of Make targets (`text/Makefile`, orchestrated by the root
`Makefile`). The stages:

### 4.1 `make specs` — expand the DSL

Runs `specs.py`, which emits everything downstream needs:

- per-result OpenModelica scripts (`text/results/<RES>.mos`) and an aggregate
  `allres.mos`;
- the **DVC pipeline** `text/dvc.yaml` (one "experiment" stage per case, declaring
  inputs and output artifacts);
- matplotlib plot scripts (`text/plots/*.py`);
- case/figure metadata (`text/results/*-case.json`, `models.json`).

### 4.2 `make results` — simulate, with DVC caching

`dvc repro` executes the generated pipeline. For each case, OpenModelica
(`omc`) compiles the model and simulates it, producing `_res.mat` (results),
`_init.xml` (the FMI model description), `_info.json`, and a native executable.

DVC keys these outputs by **content** (the model source, the `.mos` script, and
the platform recorded in `text/build-arch`) rather than timestamps, caching them
in `.dvc/cache`. If nothing relevant changed, results are fetched from cache
instead of re-simulated — important because a full simulation sweep is expensive.

`text/tojson.py` converts each `_init.xml` into a compact JSON description
(variables, default experiment, hierarchy) used by the interactive UI.

### 4.3 Images and icons

- `make images` renders the matplotlib plots; SVG figures are converted to PDF
  (`rsvg-convert`) for the print builds.
- `make icons` runs `GenerateIcons.mos` to render the Modelica model icons.

### 4.4 Sphinx builders — render the book

Sphinx (config in `text/source/conf.py`) renders multiple output formats from the
same source:

| Target | Builder | Output | Consumed by |
|--------|---------|--------|-------------|
| `make dirhtml` | `dirhtml` | self-contained static HTML | legacy direct hosting |
| `make json` / `json_kr` | `json` | `.fjson` per page | **`nextgen/` UI** |
| `make epub` (+ `mobi`) | `epub` | ePub / Mobi | downloadable ebook |
| `make latex` → `make pdf` | `latex` → `xelatex` | PDF (Letter + A4) | downloadable print |

Two custom Sphinx pieces matter:

- **`xogeny.sim` extension** (`text/source/_sphinxext/xogeny/sim.py`) — adds the
  directives that mark *where dynamic/interactive content* belongs in a page. At
  render time these leave a placeholder node (carrying a model id) in the HTML;
  the UI later replaces it with a live widget (§6.2).
- **`xogeny-semantic` theme** (`text/source/_themes/`) — the book's custom Sphinx
  HTML theme.

The root `make all` target chains the whole thing: `specs results json ebooks pdfs`.

---

## 5. Testing & verification

The project's correctness rests on the examples actually compiling and
simulating, so most "testing" is exercising the models:

- **Model regression check** — `tools/check-models/run.sh` runs `checkModel` over
  every class in `ModelicaByExample` under a pinned modern OpenModelica (in
  Docker) and fails if any class breaks that is not listed in
  `known_failures.txt`. It is the fast gate that answers "does the book still
  compile?" and is intended to run in CI. See `tools/check-models/README.md`.
- **Simulation sweep** — `make results` (DVC) is itself a strong check: every
  figure in the book comes from a simulation that must succeed to build. The
  generated `allres.mos` / `text/simall.mos` scripts simulate the example set.
- **DVC as a consistency layer** — because results are content-addressed, a
  changed model that alters its outputs is visible as a cache miss / changed
  artifact, surfacing unintended numerical changes.

---

## 6. The reading UI (`nextgen/`)

`nextgen/` is a **Next.js + TypeScript** application. It does not re-render the
book; it ingests Sphinx's JSON output and presents it as an interactive website.

### 6.1 Content ingestion

`make json` writes `.fjson` files to `text/build/json`. The UI's
`make copy_en_files` (or `copy_kr_files`) copies these into `nextgen/json/` and
relocates `_images` and sponsor assets into `static/`. Each `.fjson` contains the
page's rendered HTML body plus metadata.

At request/render time, Next.js page components load this data via
`src/data.ts` (`getInitialPageProps` → `parseFJSon`), which deserializes the
`.fjson` for the page, the global navigation data, and titles.

`yarn index` (`buildIndex.js`) builds a client-side **lunr** full-text search
index from the `.fjson` corpus, so search runs entirely in the browser.

### 6.2 Content injection: from static HTML to live components

The Sphinx body is HTML, but the UI needs to splice React components into it.
This is done by **`Reactify`** (`components/reactify.tsx`), which parses the HTML
string with `html-to-react` and applies a list of **injectors**
(`nextgen/injectors/`):

- **`interactiveInjector`** — when it sees a node marked `class="interactive"`
  (the placeholder left by the `xogeny.sim` directive), it extracts the model id
  from the node and replaces the node with an `<Interactive>` component.
- **`sourceViewInjector`** — injects a source-code viewer for example listings.

So the pipeline is: *Sphinx directive → HTML marker node → injector → React
component*. Everything not matched by an injector is rendered as ordinary HTML.

### 6.3 Interactive simulation

The `<Interactive>` component (`components/interactive.tsx`) is the live figure.
It talks to the simulation API (§7) as a **Siren hypermedia** client
(`siren-nav` / `siren-types`):

1. follow a `template` link on the API root to locate the model by id;
2. `GET` the model's data (parameters, variables) to render a `ParameterPanel`;
3. on "run", `POST` the chosen parameter modifications via the model's `run`
   action; the API simulates and returns results;
4. results are charted with **recharts** (`components/results.tsx`).

Math is rendered with `mathjax-node-page`; general UI uses `@blueprintjs/core`.

### 6.4 Build & deploy of the UI

`yarn now-build` (`next build && next export -o dist`) produces a fully static
export. The historical hosting target is **ZEIT Now** (`now.json`,
`@now/static-build`), with `now alias` scripts pointing the deployment at
`mbe.modelica.university` (release), `book.xogeny.com`, and `beta`/`preview`
aliases. (See §8 — the deploy target is mid-migration.)

---

## 7. The simulation API (`api/`)

`api/` is a Node/TypeScript service that runs the example simulations in the
cloud. Per `api/README.md`, this replaced an earlier approach where simulations
were **cross-compiled to JavaScript and run in the browser** — elegant but
fragile (unstable toolchain, heavy on memory for mobile). Moving simulation
server-side traded more moving parts for reliable, CI-friendly builds.

How it is assembled:

- `make -C api deps` unpacks the compiled example executables
  (`text/results/exes.tar.gz`) into `api/models/`, alongside the shared runtime
  libraries in `api/libs/`.
- `make -C api image` builds a `linux/amd64` Docker image and `deploy` pushes it
  to Google Artifact Registry (`us-central1-docker.pkg.dev/simulate-book-models/…`),
  from which it is served as `mbe-api.modelica.university`.

The service exposes each model as a Siren resource with a `run` action; that is
the contract the UI's `<Interactive>` component drives.

---

## 8. Translations / internationalization

Translation is handled with **gettext**, integrated through Sphinx and the specs
DSL:

- **Catalogs** live in `text/locale/<lang>/LC_MESSAGES/*.po` (with compiled
  `*.mo`). Languages present include `ar`, `cn`, `de`, `es`, `fr`, `it`, `kr`,
  `pt_BR`, plus the `pot` templates. `conf.py` sets `locale_dirs=['../locale/']`
  and `gettext_compact=False`.
- **Prose** is translated by building Sphinx with a language, e.g.
  `make json_kr` runs the JSON builder with `-D language=kr`; there are parallel
  `dirhtml_cn/kr/ar/es` HTML targets.
- **Generated figures** are translated too: `specs.py` wraps plot titles/legends
  in gettext, and the build sets `BOOK_LANG` (e.g. `make specs_cn`) so the
  generated plots come out in the target language.
- **UI delivery**: `copy_kr_files` swaps the Korean `.fjson` into `nextgen/json`
  before building; HTML deploys are pushed under language path prefixes
  (`/cn`, `/kr`, `/ar`, …).
- `sphinx-intl` manages the `.po`/`.mo` lifecycle. `TRANSLATION.md` documents the
  contributor workflow and licensing.

---

## 9. Deployment targets

| Artifact | Built by | Hosted at |
|----------|----------|-----------|
| Interactive book site | `nextgen/` static export | `mbe.modelica.university` (and `book.xogeny.com`) |
| Simulation API | `api/` Docker image | `mbe-api.modelica.university` (Google Cloud) |
| ePub / Mobi / PDF | `text/` Sphinx builders | downloadable files (historically an S3 `files.*` bucket) |
| Per-language sites | language Sphinx builds | path prefixes under the main site |

CI is intended to drive these via the root `Makefile` and the `docker/` images so
that a build is reproducible on any machine with Docker.

---

## 10. Known rough edges (state as of this writing)

These are documented so newcomers aren't surprised; the live task list is the
Linear project *"Modelica by Example — Maintenance & Modernization."*

- **Toolchain images are stale.** `docker/OM` and `docker/MBE` are built on
  Ubuntu 14.04 against an OpenModelica apt repo that no longer exists, and pin
  Sphinx 1.3 / docutils 0.12 / Python 2. A modern OpenModelica image is needed to
  reproduce the build; `tools/check-models/` already uses the official
  `openmodelica/openmodelica` image as a template for this.
- **MSL version.** The library declares `uses(Modelica 3.2.2)`; current
  OpenModelica reports 3.2.3 as compatible, but the default modern MSL is 4.0,
  which would require a migration pass.
- **UI deploy target is mid-migration.** `nextgen` still references ZEIT Now
  (`now.json`, `now-build`, `now alias`), which has since become Vercel; the
  intended current host should be confirmed.
- **Two generators exist.** `generator/` (react-static) predates `nextgen/`
  (Next.js); `nextgen/` is the current one.
