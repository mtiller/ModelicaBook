from pylab import *
from dymat import DyMatFile
import os

def render_twoup_plot(name, spec1, spec2):
    pass

def render_simple_plot(name, var):
    import matplotlib.pyplot as plt
    import math

    # Location of results (relative to extention directory)
    resdir = os.path.abspath(os.path.join(os.path.dirname(__file__),
                                          "..", "..", "..", "results"))

    fn = os.path.join(resdir, name+"_res.mat")
    res = DyMatFile(fn)

    t = res.abscissa(var, valuesOnly=True)
    x = res.data(var)
    plt.plot(t, x)
    dotname = name.replace("_", ".")
    plt.title(dotname)
    plt.ylabel(var)
    plt.xlabel('Time [s]')

    show()
