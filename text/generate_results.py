#!/usr/bin/env python

import argparse
import os

parser = argparse.ArgumentParser(prog='create_plot.py')

parser.add_argument("models", nargs="+")
parser.add_argument("-m", "--path", default=os.path.abspath(".."),
                    help="Location of ModelicaByExample package",
                    required=False)
parser.add_argument("-r", "--results", default=os.path.abspath("./results"),
                    help="Location to place generated python scripts",
                    required=False)


args = parser.parse_args()

preamble = """
loadModel(ModelicaServices);
loadModel(Modelica);
setModelicaPath(getModelicaPath()+":"+"%s");
loadModel(ModelicaByExample);
""" % (args.path,)

cmd = preamble

for model in args.models:
    dashname = model.replace(".", "_")
    cmd = cmd+"""
simulate(ModelicaByExample.%s, tolerance=1e-3, numberOfIntervals=500, fileNamePrefix="%s");
""" % (model,dashname)
    with open(os.path.join(args.results, dashname+".py"), "w") as fp:
        fp.write("""
from xogeny.plot_utils import render_plot
render_plot("%s",
            resdir="%s")
""" % (dashname, args.results));

print cmd
