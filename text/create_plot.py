#!/usr/bin/env python

import argparse
import os

parser = argparse.ArgumentParser(prog='create_plot.py')

parser.add_argument("models", nargs="+")
parser.add_argument("-r", "--root", default=os.path.abspath(".."),
                    help="Location of ModelicaByExample package",
                    required=False)

args = parser.parse_args()

preamble = """
loadModel(ModelicaServices);
loadModel(Modelica);
setModelicaPath(getModelicaPath()+":"+"%s");
loadModel(ModelicaByExample);
""" % (args.root,)

cmd = preamble

for model in args.models:
    cmd = cmd+"""
simulate(ModelicaByExample.%s, tolerance=1e-3, numberOfIntervals=500, fileNamePrefix="%s");
""" % (model,model.replace(".", "_"))

print cmd
