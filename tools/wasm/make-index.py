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
import xml.etree.ElementTree as ET

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
RESULTS = os.path.join(ROOT, "text", "results")
WASM = os.path.join(RESULTS, "wasm")


# Parameter element tags whose value a panel can sensibly edit. String
# parameters are reported but not marked editable: fmi3SetString is a different
# call and none of the book's figures turn on one.
NUMERIC = {"Float64", "Float32", "Int8", "UInt8", "Int16", "UInt16",
           "Int32", "UInt32", "Int64", "UInt64"}


def parameters(res, mods):
    """The case's settable parameters, read out of its FMU's modelDescription.

    Read from the dylink export because that one is an unzipped directory, so
    the XML is just a file; the component export has the same modelDescription
    inside a zip.

    `editable` is a UI hint, not a statement about FMI: every one of these can
    be set through fmi3Set*. It marks the ones worth putting in a figure's
    panel -- the model's own parameters and those of its direct components
    (`spring1.c`, `power_supply.C`), but not the third-level MSL internals.
    Without that cut Harm alone would offer 363 inputs; with it, 48, which is
    honest for a model with 24 pendulums.
    """
    md = os.path.join(WASM, "dylink", res + ".fmu", "modelDescription.xml")
    if not os.path.exists(md):
        return []

    variables = ET.parse(md).getroot().find("ModelVariables")
    if variables is None:
        return []

    out = []
    for v in variables:
        if v.get("causality") != "parameter":
            continue
        name = v.get("name")
        array = v.find("Dimension") is not None
        param = {
            "name": name,
            "type": v.tag,
            # What the FMU itself starts from. The case may override it below.
            "start": v.get("start"),
            "valueReference": v.get("valueReference"),
            "editable": (not array
                         and (v.tag in NUMERIC or v.tag == "Boolean")
                         and (name.count(".") <= 1 or name in mods)),
        }
        for attr in ("description", "unit", "displayUnit", "min", "max", "nominal"):
            if v.get(attr) is not None:
                param[attr] = v.get(attr)
        if array:
            param["array"] = True
        # The case's own value, which is what its figure in the book was drawn
        # with -- `-override` on the native path, fmi3Set* here. buildModelFMU
        # cannot bake it in, so it has to travel beside the artifact.
        if name in mods:
            param["default"] = mods[name]
            param["overridden"] = True
        else:
            param["default"] = v.get("start")
        out.append(param)
    return out


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
    blob_users = {}
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

        pack_manifest = os.path.join(WASM, "pack", "cases", res + ".json")
        if os.path.exists(pack_manifest):
            with open(pack_manifest) as fp:
                packed = json.load(fp)
            blobs = set(packed["cores"].values()) | {packed["glue"]}
            artifacts["pack"] = {
                "path": "pack/cases/%s.json" % res,
                # What this case references. Most of it is shared with every
                # other case, so it is not what shipping one more figure costs.
                "bytes": sum(os.path.getsize(os.path.join(WASM, "pack", b)) for b in blobs),
            }
            for b in blobs:
                blob_users[b] = blob_users.get(b, 0) + 1
        else:
            missing.append("%s/pack" % res)

        cases[res] = {
            "model": case["name"],
            # What the native run passes as stopTime/tolerance/numberOfIntervals
            # and -override; an importer must apply these itself.
            "stopTime": case["stopTime"],
            "tolerance": case["tol"],
            "intervals": case["ncp"],
            "overrides": case.get("mods", {}),
            "parameters": parameters(res, case.get("mods") or {}),
            "artifacts": artifacts,
        }

    if missing:
        sys.exit("missing wasm artifacts: %s" % ", ".join(missing))

    # The packed tree is the one that answers "what does a reader download",
    # because it is the only layout in which identical blobs share a URL.
    blob_bytes = {b: os.path.getsize(os.path.join(WASM, "pack", b)) for b in blob_users}
    pack = {
        "blobs": len(blob_users),
        "bytes": sum(blob_bytes.values()),
        "sharedByEveryCase": sum(s for b, s in blob_bytes.items()
                                 if blob_users[b] == len(cases)),
    }

    out = os.path.join(WASM, "index.json")
    with open(out, "w") as fp:
        json.dump({"cases": cases, "pack": pack}, fp, indent=2, sort_keys=True)
        fp.write("\n")
    n_par = sum(len(c["parameters"]) for c in cases.values())
    n_ed = sum(1 for c in cases.values() for p in c["parameters"] if p["editable"])
    print("wrote %s (%d cases; %d blobs, %.1f MB, %.2f MB shared by every case; "
          "%d parameters, %d editable)"
          % (out, len(cases), pack["blobs"], pack["bytes"] / 1048576.0,
             pack["sharedByEveryCase"] / 1048576.0, n_par, n_ed))


if __name__ == "__main__":
    main()
