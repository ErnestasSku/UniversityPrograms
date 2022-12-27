import pandas as pd
import numpy as np
import matplotlib as mpl
import matplotlib.cm as cm
import matplotlib.pyplot as plt
import sympy as sp
import scipy.optimize as sopt
import sys

from TargetFunction import *
from GoldenSection import getResults

X0 = [0, 0]
X1 = [1, 1]
XN = [4/10, 9/10]

# rate = 2.7

termination = 10**-5
gnorm = sys.maxsize
dxmin = 10**-5
dx = sys.maxsize
iterations = 0

def resetGlobals():
    global termination
    global gnorm
    global dxmin
    global dx
    global iterations

    termination = 10**-5
    gnorm = sys.maxsize
    dxmin = 10**-5
    dx = sys.maxsize
    iterations = 0

rate = 1



def minSigma(g, x, target):
    def innerSigma(z):
        return target.f(x[0] +  z * g[0], x[1] + z * g[1])
    return innerSigma




def steepest_descent(xn, target: TargetFunction):
    plot_x = np.arange(0.3, 1, 0.01)
    plot_y = np.arange(0.3, 1, 0.01)
    plot_X, plot_Y = np.meshgrid(plot_x, plot_y)
    plot_Z = np.exp(-(plot_X*plot_Y*(1-plot_X-plot_Y))/8)

    fig, ax = plt.subplots()
    CS = ax.contour(plot_X, plot_Y, plot_Z)

    plt.plot()

    global dx
    global gnorm
    global iterations
    global rate

    while gnorm >= termination and dx >= dxmin:
        g = target.grad(xn[0], xn[1])
        g = list(map((lambda x: -1*x), g))
        gnorm = np.linalg.norm(g)
        
        rate = getResults(minSigma(g, xn, target), (0, 2))
        # print(rate.result)
        
        xi = (pd.Series(xn) + np.linalg.norm(rate.result) * pd.Series(g)).tolist()
        dx = np.linalg.norm( (pd.Series(xn) - pd.Series(xi)).tolist() )

        # plot
        plt.plot([xn[0], xi[0]], [xn[1], xi[1]])
        if iterations < 3 or iterations % 6 == 0:
        # if iterations % 3 == 0:
            plt.text(xn[0], xn[1], '#%d' % (iterations) )
        xn = xi
        iterations = iterations + 1

    plt.plot(xn[0], xn[1], 'rx')  
    # print(xn[0], xn[1])  
    plt.show()
        

if __name__ == "__main__":
    t1 = TargetFunction()
    t2 = TargetFunction()
    t3 = TargetFunction()
    resetGlobals()
    steepest_descent(X0, t1)
    print('iter - ', iterations, 'func - ', t1.gradientCalls, t1.functionCalls)
    resetGlobals()
    steepest_descent(X1, t2)
    print('iter - ', iterations, 'func - ', t2.gradientCalls, t2.functionCalls)
    resetGlobals()
    steepest_descent(XN, t3)
    print('iter - ', iterations, 'func - ', t3.gradientCalls, t3.functionCalls)
