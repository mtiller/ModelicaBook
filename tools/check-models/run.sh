#!/usr/bin/env bash
#
# Regression check for the ModelicaByExample library.
#
# Runs `checkModel` on every class in the library under a modern OpenModelica
# (in Docker) and fails if any class breaks that is not already listed in
# known_failures.txt. Intended for local use and for CI (see Phase 2 / MIC-75).
#
# Configurable via environment variables:
#   OMC_IMAGE    Docker image providing omc   (default: openmodelica/openmodelica:v1.24.0-minimal)
#   MSL_VERSION  Modelica Standard Library     (default: 3.2.3)
#   OMC_LIBS     Host dir caching installed MSL (default: ~/.cache/mbe-omc-libs)
#
# Requires: docker (e.g. Docker Desktop or colima) and python3 on the host.
set -euo pipefail

OMC_IMAGE="${OMC_IMAGE:-openmodelica/openmodelica:v1.24.0-minimal}"
MSL_VERSION="${MSL_VERSION:-3.2.3}"
HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$HERE/../.." && pwd)"
LIBS="${OMC_LIBS:-$HOME/.cache/mbe-omc-libs}"
# Keep the work dir under $HOME so it is shared into the Docker VM. colima only
# mounts the home directory by default, so a /tmp or /var/folders mktemp dir
# would show up empty inside the container.
CACHE_BASE="${XDG_CACHE_HOME:-$HOME/.cache}"
mkdir -p "$CACHE_BASE" "$LIBS"
WORK="$(mktemp -d "$CACHE_BASE/mbe-check.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT

# 1. Install the target MSL into the (persistent) cache if it isn't there yet.
if ! ls -d "$LIBS"/Modelica\ * >/dev/null 2>&1; then
  echo "Installing Modelica $MSL_VERSION into $LIBS ..."
  printf 'installPackage(Modelica, "%s", exactMatch=false); getErrorString();\n' \
    "$MSL_VERSION" > "$WORK/install.mos"
  docker run --rm \
    -v "$LIBS":/root/.openmodelica/libraries \
    -v "$WORK":/mos \
    "$OMC_IMAGE" omc /mos/install.mos
fi

# 2. Render the check script from its template and run the sweep.
sed "s/@MSL_VERSION@/$MSL_VERSION/g" "$HERE/check_all.mos.in" > "$WORK/check_all.mos"
echo "Checking all models with $OMC_IMAGE (MSL $MSL_VERSION) ..."
docker run --rm \
  -v "$REPO":/work \
  -v "$LIBS":/root/.openmodelica/libraries \
  -v "$WORK":/mos \
  "$OMC_IMAGE" omc /mos/check_all.mos > "$WORK/sweep.out" 2>&1

# 3. Verdict the sweep against the known-failures allowlist.
python3 "$HERE/parse.py" "$WORK/sweep.out"
