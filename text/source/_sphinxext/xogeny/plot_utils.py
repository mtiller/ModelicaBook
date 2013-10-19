from pylab import *
from dymat import DyMatFile
import os

def render_plot(name):
    import matplotlib.pyplot as plt
    import math

    # Location of results (relative to extention directory)
    resdir = os.path.abspath(os.path.join(os.path.dirname(__file__),
                                          "..", "..", "..", "results"))

    fn = os.path.join(resdir, name+"_res.mat")
    res = DyMatFile(fn)

    var = "x"
    t = res.abscissa(var, valuesOnly=True)
    x = res.data(var)
    plt.plot(t, x)
    plt.ylabel('x')
    plt.xlabel('t')

    show()
