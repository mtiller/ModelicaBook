#!/usr/bin/python
from pylab import *
import matplotlib.pyplot as plt
import math
t = list(map(lambda v: v*0.1, range(0,101)))
x = list(map(lambda v: 1-math.exp(-v), t))
plt.plot(t, x)
plt.ylabel('x')
plt.xlabel('t')

show()
