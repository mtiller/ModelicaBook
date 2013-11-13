from pylab import *
from dymat import DyMatFile
import os

# fig, ax = plt.subplots()
# ax.plot(a, c, 'k--', label='Model length')
# ax.plot(a, d, 'k:', label='Data length')
# ax.plot(a, c+d, 'k', label='Total message length')

# # Now add the legend with some customizations.
# legend = ax.legend(loc='upper center', shadow=True)

# # The frame is matplotlib.patches.Rectangle instance surrounding the legend.
# frame  = legend.get_frame()
# frame.set_facecolor('0.90')

# # Set the fontsize
# for label in legend.get_texts():
#     label.set_fontsize('large')

# for label in legend.get_lines():
#     label.set_linewidth(1.5)  # the legend line width
# plt.show()

def render_twoup_plot(name, spec1, spec2):
    pass

def render_comp_plot(name1, vars1, name2, vars2):
    raise BaseException("Need to implement handling of comparison plots")

def render_simple_plot(name, vars, title=None, legloc="lower right"):
    import matplotlib.pyplot as plt
    import math

    styles = [""]

    # Location of results (relative to extention directory)
    resdir = os.path.abspath(os.path.join(os.path.dirname(__file__),
                                          "..", "..", "..", "results"))

    var0name = vars[0]["name"]

    fn = os.path.join(resdir, name+"_res.mat")
    res = DyMatFile(fn)

    fig, ax = plt.subplots()

    t = res.abscissa(var0name, valuesOnly=True)
    print "len(t) = "+str(len(t))

    for var in vars:
        varname = var["name"]
        legend = var["legend"]
        style = var["style"]
        x = res.data(varname)
        if len(x)==2:
            xv = x[0]
            print "xv = "+str(xv)
            x = [xv]*len(t)
        print "len("+varname+") = "+str(len(x))
        ax.plot(t, x, style, label=legend)

    legend = ax.legend(loc=legloc, shadow=True)

    if title==None:
        title = name.replace("_", ".")
    plt.title(title)
    #plt.ylabel(var)
    plt.xlabel('Time [s]')

    plt.show()
