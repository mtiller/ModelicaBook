# The image the wasm stages of the book build run in.
#
# Its base carries an OpenModelica built from master with the Rust backend
# (OM_OMC_ENABLE_RUST=ON), which is what provides `--simCodeTarget=wasm-jit`.
# That build is not in any published image: OM_OMC_ENABLE_RUST defaults OFF, and
# Docker Hub's openmodelica/openmodelica carries release tags only, all of them
# pre-wasm. Producing the base is a ~72 minute from-source build documented in
# MIC-178; this layer only adds what the book build needs on top of it, so it
# rebuilds in seconds.
#
# Base contents (see ~/Source/om-wasm-artifacts/<sha>/README.md):
#   /opt/openmodelica   install prefix, OPENMODELICAHOME, omc on PATH
#   /opt/om-web         OpenModelica's staged browser bundle, whose
#                       fmi-simulator/vendor/ holds the jco transpiler the
#                       ahead-of-time step runs under Node.
ARG BASE=mbe/omc-wasm:3998b1f8
FROM ${BASE}

# Links the ghcr package to this repository, so the workflow's GITHUB_TOKEN can
# pull it without a separate credential.
LABEL org.opencontainers.image.source=https://github.com/mtiller/ModelicaBook
LABEL org.opencontainers.image.description="OpenModelica with the wasm-jit backend, plus the toolchain the Modelica by Example wasm build stages need"

# python3 + jinja2 drive `make specs`; dvc reproduces the pipeline stages; node
# runs the AOT transpile; unzip reads the component out of an FMU; git is what
# dvc keys its cache against. Ubuntu 26.04 marks its python externally managed,
# so the pip installs go in a venv rather than fighting PEP 668.
#
# clang and lld are not optional. A model with `external "C"` whose functions
# have no wasm implementation (IIEV's interpolateVectorTable, for one) makes omc
# compile the `Include` C sources to a wasm library itself, with
# `clang --target=wasm32-wasip1 -fPIC -shared`. Without them that case fails with
# "`clang` could not be run to compile the `Include` C sources". The wasi sysroot
# it compiles against, libclang_rt.builtins-wasm32.a included, already ships in
# the base at $OPENMODELICAHOME/lib/wasm32-wasi/omc.
RUN apt-get update && apt-get install -y --no-install-recommends \
        python3 python3-venv python3-pip nodejs unzip zip git make ca-certificates \
        clang lld \
    && python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir --upgrade pip \
    && /opt/venv/bin/pip install --no-cache-dir jinja2 'dvc>=3' \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PATH=/opt/venv/bin:$PATH
ENV OM_WEB_VENDOR=/opt/om-web/fmi-simulator/vendor

# The Modelica Standard Library, which the base deliberately left out. omc
# resolves it from ~/.openmodelica/libraries, so without this anything past a
# self-contained loadString model fails with "Failed to load package Modelica".
#
# 3.2.3+maint.om is not a new decision: it is what tools/check-models already
# pins, and it builds all 98 book cases. The library declares uses(Modelica
# 3.2.2); the open 3.2.2 -> 4.0 migration question is untouched by this.
COPY install-msl.mos /tmp/install-msl.mos
RUN omc /tmp/install-msl.mos \
    && test -d "/root/.openmodelica/libraries/Modelica 3.2.3+maint.om" \
    && rm /tmp/install-msl.mos

# Fail the build rather than ship an image that cannot do the one thing it is for.
RUN omc --version && omc --help=simCodeTarget | grep -q wasm-jit \
    && node --version && dvc --version && python3 -c 'import jinja2' \
    && test -f "$OM_WEB_VENDOR/js-component-bindgen-component.js"

WORKDIR /work
