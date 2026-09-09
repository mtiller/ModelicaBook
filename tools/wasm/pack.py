#!/usr/bin/env python3
"""Pack the AOT output into a content-addressed tree, so identical core modules
are stored -- and served -- once.

jco names the core modules it emits positionally (fmu.core.wasm, fmu.core2.wasm,
...), and the numbering shifts from model to model, so the per-case directories
hide how much they have in common. By content, they barely differ: across the 98
cases, 186 MB of core modules is 12.8 MB of distinct bytes, and 1.85 MB of that
-- the OpenModelica runtime -- is byte-identical in every single case.

Laid out per case, none of that can be shared: each `aot/<case>/fmu.core9.wasm`
is its own URL, so a reader opening a second figure downloads the runtime again.
This rewrites the tree so every distinct blob has one content-addressed path:

    pack/blobs/<sha256[:16]>.wasm      each distinct core module, once
    pack/blobs/<sha256[:16]>.js        each distinct glue file, once
    pack/cases/<case>.json             logical name -> blob path, plus the
                                       imports/exports jco reported

The logical names have to survive, because that is what the glue asks for:
fmu-core.js builds `cores` as a Map keyed by jco's name and the generated module
calls `compile(name)` against it. The client is free to fetch those bytes from
any URL, which is the whole point -- it just needs the mapping.

Blobs are hardlinked from the DVC outputs where the filesystem allows it, so the
packed tree costs no extra space; it falls back to copying across devices.
"""

import hashlib
import json
import os
import shutil
import sys
import zipfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
RESULTS = os.path.join(ROOT, "text", "results")
WASM = os.path.join(RESULTS, "wasm")
AOT = os.path.join(WASM, "aot")
PACK = os.path.join(WASM, "pack")

DIGEST_CHARS = 16


def digest(path):
    h = hashlib.sha256()
    with open(path, "rb") as fp:
        for chunk in iter(lambda: fp.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()[:DIGEST_CHARS]


def link_or_copy(src, dst):
    if os.path.exists(dst):
        return
    try:
        os.link(src, dst)
    except OSError:
        shutil.copyfile(src, dst)


def main():
    spec_path = os.path.join(RESULTS, "cases.json")
    if not os.path.exists(spec_path):
        sys.exit("no %s -- run 'make specs' first" % spec_path)
    with open(spec_path) as fp:
        cases = sorted(json.load(fp))

    if not os.path.isdir(AOT):
        sys.exit("no %s -- run 'make wasm' first" % AOT)

    shutil.rmtree(PACK, ignore_errors=True)
    blobs_dir = os.path.join(PACK, "blobs")
    cases_dir = os.path.join(PACK, "cases")
    os.makedirs(blobs_dir)
    os.makedirs(cases_dir)

    # A model-description-only FMU per case.
    #
    # The driver reads the FMU archive itself (om_fmi_load) to get the model
    # description, the variable list and the resources -- but with an AOT
    # manifest it never needs the component binary, because the transpiled form
    # is already there. So the archive it is given can be the description alone:
    # about 2 KB, against ~710 KB for a component FMU carrying its own copy of
    # the runtime.
    desc_dir = os.path.join(PACK, "desc")
    os.makedirs(desc_dir)
    desc_bytes = 0

    blob_size = {}          # blob filename -> bytes
    blob_users = {}         # blob filename -> number of cases referencing it
    raw_total = 0

    for case in cases:
        src_dir = os.path.join(AOT, case)
        if not os.path.isdir(src_dir):
            sys.exit("missing AOT output for %s" % case)

        with open(os.path.join(src_dir, "manifest.json")) as fp:
            manifest = json.load(fp)

        md = os.path.join(WASM, "dylink", case + ".fmu", "modelDescription.xml")
        out_fmu = os.path.join(desc_dir, case + ".fmu")
        with zipfile.ZipFile(out_fmu, "w", zipfile.ZIP_DEFLATED) as z:
            z.write(md, "modelDescription.xml")
        desc_bytes += os.path.getsize(out_fmu)

        cores, glue = {}, None
        referenced = set()
        for name in sorted(os.listdir(src_dir)):
            if name == "manifest.json":
                continue
            src = os.path.join(src_dir, name)
            ext = os.path.splitext(name)[1]
            blob = "%s%s" % (digest(src), ext)
            link_or_copy(src, os.path.join(blobs_dir, blob))

            size = os.path.getsize(src)
            raw_total += size
            blob_size[blob] = size
            referenced.add(blob)

            if ext == ".wasm":
                cores[name] = "blobs/" + blob
            elif ext == ".js":
                glue = "blobs/" + blob

        for blob in referenced:
            blob_users[blob] = blob_users.get(blob, 0) + 1

        if glue is None:
            sys.exit("%s has no glue (.js) in its AOT output" % case)

        with open(os.path.join(cases_dir, case + ".json"), "w") as fp:
            json.dump({"glue": glue, "cores": cores,
                       "archive": "desc/" + case + ".fmu",
                       "imports": manifest["imports"],
                       "exports": manifest["exports"]},
                      fp, indent=2, sort_keys=True)
            fp.write("\n")

    unique = sum(blob_size.values())
    shared = sum(s for b, s in blob_size.items() if blob_users[b] == len(cases))
    print("packed %d cases: %d blobs, %.1f MB unique (from %.1f MB laid out per case, %.1fx)"
          % (len(cases), len(blob_size), unique / 1048576.0,
             raw_total / 1048576.0, raw_total / float(unique)))
    print("  %.2f MB of that is referenced by every case (fetched once)" % (shared / 1048576.0))
    print("  plus %d description-only FMUs, %.2f MB total (%.0f bytes each)"
          % (len(cases), desc_bytes / 1048576.0, desc_bytes / float(len(cases))))


if __name__ == "__main__":
    main()
