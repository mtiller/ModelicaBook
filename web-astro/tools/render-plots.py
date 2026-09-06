#!/usr/bin/env python3
# MIC-84 / MIC-87 — render the book's matplotlib plot scripts to SVG for Astro.
#
# The plot scripts (text/plots/<id>.py) call render_simple_plot/render_comp_plot
# from xogeny.plot_utils and end with plt.show() (Sphinx's plot directive used to
# capture that). Here we run each headless (Agg), intercept plt.show(), and
# savefig an SVG named by the plot id into web-astro/public/plots/<id>.svg —
# exactly what <SimFigure> loads (staticSrc = /plots/<id>.svg).
#
# Run inside the book-builder container, cwd = text/:
#   PYTHONPATH=source/_sphinxext python3 ../web-astro/tools/render-plots.py
import os, sys, glob, runpy, traceback
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

OUT = os.path.abspath(os.path.join(os.getcwd(), "..", "web-astro", "public", "plots"))
os.makedirs(OUT, exist_ok=True)
sys.path.insert(0, os.path.join(os.getcwd(), "source", "_sphinxext"))

scripts = sorted(glob.glob("plots/*.py"))
ok, fail = 0, 0
for s in scripts:
    pid = os.path.basename(s)[:-3]
    plt.close("all")
    saved = {"done": False}
    orig_show = plt.show
    def _save(*a, **k):
        plt.savefig(os.path.join(OUT, pid + ".svg"), format="svg", bbox_inches="tight")
        saved["done"] = True
    plt.show = _save
    try:
        runpy.run_path(s, run_name="__main__")
        if not saved["done"]:  # some scripts may not call show(); save current fig
            plt.savefig(os.path.join(OUT, pid + ".svg"), format="svg", bbox_inches="tight")
        ok += 1
    except Exception as e:
        fail += 1
        print(f"FAIL {pid}: {e}", file=sys.stderr)
    finally:
        plt.show = orig_show
print(f"rendered {ok} SVGs, {fail} failed -> {OUT}")
