#!/usr/bin/env python3
"""Write text/results/wasm/index.json: one entry per case, naming its wasm
artifacts and the simulation settings an importer has to apply to reproduce the
book's figure.

The case list comes from results/cases.json, which specs.py emits. Deliberately
not from json/*-case.json: those are keyed by plot, and a case can have several
plots (CC1 and CC1_Q) or none.

buildModelFMU takes no simulation settings, so an exported FMU carries the
model's own `experiment` annotation as its DefaultExperiment, not the case's
stopTime/tolerance/interval count -- for 74 of 97 cases those differ. Parameter
modifications are the same story: the native pipeline passes them to the
*runtime* as `-override`, and the FMI equivalent is fmi3Set* before
initialization. Both therefore belong beside the artifact rather than inside it,
and specs.py already emits them to results/json/<case>-case.json.

Deterministic by construction: no timestamps, sorted keys.
"""

import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
RESULTS = os.path.join(ROOT, "text", "results")
WASM = os.path.join(RESULTS, "wasm")


def tree_size(path):
    if os.path.isfile(path):
        return os.path.getsize(path)
    total = 0
    for dirpath, _, filenames in os.walk(path):
        for name in filenames:
            total += os.path.getsize(os.path.join(dirpath, name))
    return total


def main():
    if not os.path.isdir(WASM):
        sys.exit("no %s -- run 'make wasm' first" % WASM)

    spec_path = os.path.join(RESULTS, "cases.json")
    if not os.path.exists(spec_path):
        sys.exit("no %s -- run 'make specs' first" % spec_path)
    with open(spec_path) as fp:
        specs = json.load(fp)

    cases = {}
    missing = []
    for res in sorted(specs):
        case = specs[res]

        artifacts = {}
        for form, rel in (("dylink", os.path.join("dylink", res + ".fmu")),
                          ("component", os.path.join("component", res + ".fmu")),
                          ("aot", os.path.join("aot", res))):
            full = os.path.join(WASM, rel)
            if os.path.exists(full):
                artifacts[form] = {"path": rel.replace(os.sep, "/"),
                                   "bytes": tree_size(full)}
            else:
                missing.append("%s/%s" % (res, form))

        cases[res] = {
            "model": case["name"],
            # What the native run passes as stopTime/tolerance/numberOfIntervals
            # and -override; an importer must apply these itself.
            "stopTime": case["stopTime"],
            "tolerance": case["tol"],
            "intervals": case["ncp"],
            "overrides": case.get("mods", {}),
            "artifacts": artifacts,
        }

    if missing:
        sys.exit("missing wasm artifacts: %s" % ", ".join(missing))

    out = os.path.join(WASM, "index.json")
    with open(out, "w") as fp:
        json.dump({"cases": cases}, fp, indent=2, sort_keys=True)
        fp.write("\n")
    print("wrote %s (%d cases)" % (out, len(cases)))


if __name__ == "__main__":
    main()
