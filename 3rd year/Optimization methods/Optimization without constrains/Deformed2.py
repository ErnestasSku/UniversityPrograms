from math import sqrt
import pandas as pd
import numpy as np
import matplotlib as mpl
import matplotlib.cm as cm
import matplotlib.pyplot as plt
import sympy as sp
import sys
import statistics

# n, a, b, x = sp.symbols("n a b x")

x0 = np.array([0, 0])
x1 = np.array([1, 1])
xn = np.array([4/10, 9/10])

alfa = 0.1
n = 2
gamma = 1.5
beta = 0.5
nu = -0.5
paklaida = 10**-6


Iterations = 0
functionCalls = 0

# Target Function
def f(x):
    global functionCalls
    functionCalls += 1
    return -(x[0]*x[1]*(1-x[0]-x[1]))/8

# Target Function 1 (with2 variab;es)
def f1(a,b):
    global functionCalls
    functionCalls += 1
    return -(a*b*(1-a-b))/8;

# Function Point (takes (float, float) )
def fp(X):
    global functionCalls
    functionCalls += 1
    return -(X[0]*X[1]*(1-X[0]-X[1]))/8

# class Simplex():
#     def __init__(self):
#         pass

def deformed_simplex(xj):
    global Iterations
    plot_x = np.arange(0, 1, 0.01)
    plot_y = np.arange(0, 1, 0.01)
    plot_X, plot_Y = np.meshgrid(plot_x, plot_y)
    plot_Z = np.exp(-(plot_X*plot_Y*(1-plot_X-plot_Y))/8)

    fig, ax = plt.subplots()
    CS = ax.contour(plot_X, plot_Y, plot_Z)

    plt.title('Nelder-Mead simplekso metodas')
    plt.xlabel('a')
    plt.ylabel('b')

    x = np.zeros((n, n+1))
    theta1 = ((sqrt(n+1)+n-1)/(n*sqrt(n)))*alfa
    theta2 = ((sqrt(n+1)-1)/(n*sqrt(n)))*alfa

    # Create simplex points from initial point and alpha
    X1 = np.array([xj[0]+theta2, xj[1]+theta1])
    X2 = np.array([xj[0]+theta1, xj[1]+theta2])
    x[:,0] = xj
    x[:,1] = X1
    x[:,2] = X2


    while Iterations < 100:
        virsuniuF = []
        for i in range(n + 1):
            value = f1(x[0, i], x[1, i])
            virsuniuF.append(value)
            

        indices = np.array(virsuniuF).ravel().argsort()
        x = x[:,indices]
        Xl = x[:,2]
        Xg = x[:,1]
        Xh = x[:,0]

        # Check for termination
        if (np.std([Xh, Xg, Xl]) <= paklaida):
            break

        # Calculate new point
        X_new = (Xh + Xg) / n;
        # Reflection
        Xr = 2*X_new - Xl;
        if fp(Xh) <= fp(Xr) and fp(Xr) < fp(Xg):
            x[:,2] = Xr
        # expansion
        elif fp(Xr) < fp(Xh):
            Xe = X_new + gamma*(X_new - Xl)
            if fp(Xe) < fp(Xr):
                x[:, n] = Xe
            else:
                x[:, n] = Xr
        else:
            if fp(Xr) < fp(Xl):
                Xc1 = X_new + beta*(Xr-Xh)
                if fp(Xc1) < fp(Xr):
                    x[:, n] = Xc1
                else:
                    x[:, 1] = Xh + nu*(Xg - Xh)
                    x[:, 2] = Xh + nu*(Xl - Xh)
            else:
                Xc2 = X_new + beta*(Xl - X_new)
                if fp(Xc2) < fp(Xl):
                    x[:, n] = Xc2
                else:
                    x[:,1] = Xh + nu*(Xg - Xh)
                    x[:,2] = Xh + nu*(Xl - Xh)
        
        Iterations += 1

    Xl = x[:,2]
    Xg = x[:,1]
    Xh = x[:,0]
    plt.plot(Xl[0], Xl[1],'gx')
    print(Xl)
    print(fp(Xl))
    print(functionCalls)
    plt.show()

if __name__ == "__main__":
    deformed_simplex(xn)
    # print(Iterations)