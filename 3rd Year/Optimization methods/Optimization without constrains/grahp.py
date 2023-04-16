import pandas as pd
import numpy as np
import matplotlib as mpl
import matplotlib.cm as cm
import matplotlib.pyplot as plt
import sympy as sp
import scipy.optimize as sopt
import sys
import math
from mpl_toolkits.mplot3d import Axes3D

def sf(x):
    print(x)
    if x > 0:
        return np.sqrt(np.abs(x))
    else:
        0

def f(a, b):
    ans = np.abs((a*b*(1-a-b))/8)
    return np.sqrt(ans)
    # return np.ndarray([np.sqrt(x) for x in ans])
    # return ans

if __name__ == "__main__":
    
    x = np.arange(0, 1.0, 0.1)
    y = np.arange(0, 1.0, 0.1)
    
    X, Y = np.meshgrid(x, y)
    Z = f(X, Y)

    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    ax.plot_surface(X, Y, Z)

    plt.xlabel('x')
    plt.ylabel('y')

    plt.show()
