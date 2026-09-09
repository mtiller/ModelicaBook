import matplotlib.pyplot as plt
import numpy as np
x = [0, 2, 4, 6, 8]
y = [0, 0, 2, 0, 0]
plt.plot(x,y)
plt.axis([0, 8, -1, 3])
plt.title("Interpolated Function")
plt.show()
