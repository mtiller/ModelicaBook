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
from xoutils import foo
from pylab import *
import matplotlib.pyplot as plt
import math
t = map(lambda v: v*0.1, range(0,101))
x = map(lambda v: 1-math.exp(-v), t)
plt.plot(t, x)
plt.ylabel('x')
plt.xlabel('t')

show()
""");

print cmd
