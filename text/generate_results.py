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
    data = model.split(":")
    if len(data)==1:
        dotname = model
        dashname = model.replace(".", "_")
        stop_time = None
    elif len(data)==2:
        dotname = data[0]
        stop_time = data[1]
    dashname = dotname.replace(".", "_")

    if stop_time==None:
        cmd = cmd+"""
simulate(ModelicaByExample.%s, tolerance=1e-3, numberOfIntervals=500, fileNamePrefix="%s");
""" % (dotname,dashname)
    else:
        cmd = cmd+"""
simulate(ModelicaByExample.%s, stopTime=%s, tolerance=1e-3, numberOfIntervals=500, fileNamePrefix="%s");
""" % (dotname, stop_time, dashname)

print cmd
