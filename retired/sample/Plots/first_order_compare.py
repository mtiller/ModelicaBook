#!/usr/bin/python
from pylab import *
import matplotlib.pyplot as plt
import math

t = map(lambda v: v*0.1, range(0,101))
x1 = map(lambda v: 1-math.exp(-v), t)
x2 = map(lambda v: 0.99-math.exp(-v), t)
plt.plot(t, x2)
plt.plot(t, x1)
plt.ylabel('x')
plt.xlabel('t')

show()
