#!/usr/bin/env bash
#
# Build (and optionally push) the image the wasm build stages run in.
#
#   tools/wasm/build-image.sh [--push] [--base <image>] [--tag <sha>]
#
# The base must already exist locally: it is an OpenModelica built from master
# with OM_OMC_ENABLE_RUST=ON, which no published image provides. See
# tools/wasm/README.md and MIC-178 for how it is produced.
set -euo pipefail

BASE="${BASE:-mbe/omc-wasm:3998b1f8}"
TAG="${TAG:-3998b1f8}"
IMAGE="${IMAGE:-ghcr.io/mtiller/omc-wasm}"
PUSH=0

while [ $# -gt 0 ]; do
  case "$1" in
    --push) PUSH=1; shift ;;
    --base) BASE="$2"; shift 2 ;;
    --tag)  TAG="$2"; shift 2 ;;
    *) echo "unknown argument: $1" >&2; exit 2 ;;
  esac
done

here="$(cd "$(dirname "$0")" && pwd)"

if ! docker image inspect "$BASE" >/dev/null 2>&1; then
  echo "base image $BASE is not present locally." >&2
  echo "It is the ~72 minute from-source OpenModelica build; see tools/wasm/README.md." >&2
  exit 1
fi

docker build --build-arg "BASE=$BASE" -t "$IMAGE:$TAG" -t "$IMAGE:latest" "$here"

if [ "$PUSH" = 1 ]; then
  # Needs a token with write:packages; `gh auth refresh -s write:packages,read:packages`
  # then `gh auth token | docker login ghcr.io -u <user> --password-stdin`.
  docker push "$IMAGE:$TAG"
  docker push "$IMAGE:latest"
fi
