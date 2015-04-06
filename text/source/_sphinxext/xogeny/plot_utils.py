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
import xogeny.locales as xlocales
_ = xlocales.create_gettext('plot_utils')

def render_twoup_plot(name, spec1, spec2):
    pass

def render_comp_plot(name1, vars1, name2, vars2, title, legloc, ylabel):
    import matplotlib.pyplot as plt
    import math
    xlocales.set_matplotlib()

    if len(vars1)!=len(vars2):
        raise BaseException("Mismatch in variable arrays, %d vs %s" % (len(vars1), len(vars2)))

    # Location of results (relative to extention directory)
    resdir = os.path.abspath(os.path.join(os.path.dirname(__file__),
                                          "..", "..", "..", "results"))
    fn1 = os.path.join(resdir, name1+"_res.mat")
    res1 = DyMatFile(fn1)

    fn2 = os.path.join(resdir, name2+"_res.mat")
    res2 = DyMatFile(fn2)

    fig, ax = plt.subplots()

    # Set background to be transparent
    #fig.patch.set_facecolor('none')
    #fig.patch.set_alpha(0.0);
    #ax.patch.set_facecolor('none')
    #ax.patch.set_alpha(0.0);

    var0name = vars1[0]["name"]

    t1 = res1.abscissa(vars1[0]["name"], valuesOnly=True)
    t2 = res2.abscissa(vars2[0]["name"], valuesOnly=True)

    for i in range(0,len(vars1)):
        v1 = vars1[i]
        v2 = vars2[i]
        x1 = res1.data(v1["name"])
        x2 = res2.data(v2["name"])
        l1 = v1["legend"]
        l2 = v2["legend"]

        if len(x1)==2:
            x1 = [x1[0]]*len(t1)
        if len(x2)==2:
            x2 = [x2[0]]*len(t2)

        ax.plot(t1, x1, "-", label=l1)
        ax.plot(t2, x2, v2.get("style", "-."), label=l2)

    legend = ax.legend(loc=legloc, shadow=True)

    if title==None:
        title = name1.replace("_", ".")
    plt.title(title)
    plt.ylabel(ylabel)
    plt.xlabel(_('Time [s]'))

    plt.show()


def render_simple_plot(name, vars, title, legloc, ylabel, ncols=1, ymin=None, ymax=None):
    import matplotlib.pyplot as plt
    import math
    xlocales.set_matplotlib()

    # Location of results (relative to extention directory)
    resdir = os.path.abspath(os.path.join(os.path.dirname(__file__),
                                          "..", "..", "..", "results"))

    var0name = vars[0]["name"]

    fn = os.path.join(resdir, name+"_res.mat")
    res = DyMatFile(fn)

    fig, ax = plt.subplots()

    # Set background to be transparent
    #fig.patch.set_facecolor('none')
    #fig.patch.set_alpha(0.0);
    #ax.patch.set_facecolor('none')
    #ax.patch.set_alpha(0.0);

    try:
        t = res.abscissa(var0name, valuesOnly=True)
        print "len(t) = "+str(len(t))
    except KeyError as e:
        raise NameError("Unknown key: "+var0name+" among "+str(res.names()))

    for var in vars:
        varname = var["name"]
        scale = var["scale"]
        legend = var["legend"]
        style = var["style"]
        try:
            x = res.data(varname)
        except KeyError as e:
            raise NameError("Unknown key: "+varname+" among "+str(res.names()))
        if len(x)==2:
            xv = x[0]
            print "xv = "+str(xv)
            x = [xv]*len(t)

        x = map(lambda y: y*scale, x)
        print "len("+varname+") = "+str(len(x))
        ax.plot(t, x, style, label=legend)

    #legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
    legend = ax.legend(shadow=True, ncol=ncols, loc=legloc)

    if title==None:
        title = name.replace("_", ".")
    plt.title(title)
    plt.ylabel(ylabel)
    plt.xlabel(_('Time [s]'))
    if ymax!=None:
        plt.axis(ymax=ymax)
    if ymin!=None:
        plt.axis(ymin=ymin)

    plt.show()
