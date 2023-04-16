from math import sqrt
import pandas as pd
import numpy as np
import matplotlib as mpl
import matplotlib.cm as cm
import matplotlib.pyplot as plt
import sympy as sp
import sys
import statistics

from TargetFunction import *

X0 = [0, 0]
X1 = [1, 1]
XN = [4/10, 9/10]

Iterations = 0

alpha = 0.6
beta = 2
gamma = 0.5
nu = -0.5
n = 2

paklaida = 10**-5

# TODO: add function memorization
function_memo = {}

class Simplex():
    def __init__(self, X, alpha):
        # x0, y0 = X
        # self.X = X
        # self.Y = (x0, y0 + alpha)
        # self.Z = self.getThird(self.X, self.Y)
        self.best = None
        self.simplex_co = alpha
        self.create_simplex(X, alpha)
        pass

    def triangle(self, plt):
        plt.plot([self.X[0], self.Y[0], self.Z[0], self.X[0]], [self.X[1], self.Y[1], self.Z[1], self.X[1]])

    # def getThird(self, XP, YP) -> (float, float):
    #     X, Y = np.array(XP), np.array(YP)
    #     M = (X + Y) / 2
    #     O = (X - M) * 3**0.5
    #     t = np.array([[0, -1], [1, 0]])   # 90 degree transformation matrix
    #     ls = (M + O @ t.T).tolist()

    #     return tuple(ls)

    def create_simplex(self, X, alpha):
        theta1 = lambda alfa: ((sqrt(n+1)+n-1)/(n*sqrt(n)))*alfa
        theta2 = lambda alfa: ((sqrt(n+1)-1)/(n*sqrt(n)))*alfa

        ls = []
        for i in range (2):
            temp = []
            for j in range(2):
                if (i == j):
                    # print(alpha, theta2(alpha))
                    temp.append(X[j] + theta2(alpha))
                else:
                    temp.append(X[j] + theta1(alpha))
                # temp.append((X[j-1] + theta2(j, alpha) if (i == j)  else X[j-1] + theta2(j, alpha)))
            ls.append(temp)
        self.X = X
        self.Y, self.Z = ls

        # print(ls)

    def new_calc():

        pass
        

    def vals():
        return sorted([self.X, self.Y, self.Z])

rev = lambda sub : (sub[1], sub[0]) 

def deformed_simplex(target: TargetFunction, alpha: float, X):
    global Iterations

    plot_x = np.arange(-0.1, 1, 0.01)
    plot_y = np.arange(-0.2, 1, 0.01)
    plot_X, plot_Y = np.meshgrid(plot_x, plot_y)
    plot_Z = np.exp(-(plot_X*plot_Y*(1-plot_X-plot_Y))/8)

    fig, ax = plt.subplots()
    CS = ax.contour(plot_X, plot_Y, plot_Z)
    # plt.plot()

    simplex = Simplex(X, alpha)
    # plt.plot([simplex.X[0], simplex.Y[0], simplex.Z[0], simplex.X[0]], [simplex.X[1], simplex.Y[1], simplex.Z[1], simplex.X[1]])

    continueCalculation = True
    oldSimplexes = set()
    oldSimplexes.add(simplex.vals)
    
    while continueCalculation:
        
        if (simplex.best is not None):
            simplex.create_simplex(simplex.best, simplex.simplex_co)
        simplex.triangle(plt)
        # xl, xg, xh = sorted([target.fp(simplex.X), target.fp(simplex.Y), target.fp(simplex.Z)])
        xl, xg, xh = map(lambda x: x[1], sorted([(target.fp(simplex.X), simplex.X), (target.fp(simplex.Y), simplex.Y), (target.fp(simplex.Z), simplex.Z)], key=lambda i : i[0]))
        print(xl, xh, xh)
        print("\n")


        # if (statistics.stdev([xl, xg, xh]) <= paklaida):
            # break
        xc = tuple(((pd.Series(xl) + pd.Series(xg)) / n).tolist())

        # reflection
        xr = tuple((2*pd.Series(xc) - pd.Series(xh)).tolist())
        if (target.fp(xl) <= target.fp(xr) and target.fp(xr) < target.fp(xg)):
            simplex.Z = xr
        # expansion
        elif (target.fp(xr) < target.fp(xl)):
            xe = tuple((pd.Series(xc) + gamma*(pd.Series(xc) - pd.Series(xh))).tolist())
            simplex.simplex_co *= gamma
            if (target.fp(xe) < target.fp(xr)):
                simplex.Z = xe
            else:
                simplex.Z = xr
        else:
            execute_shrink = False
            # contraction
            if (target.fp(xr) < target.fp(xh)):
                xc1 = tuple((pd.Series(xc) + beta*(pd.Series(xr) - pd.Series(xc))).tolist())
                if (target.fp(xc1) < target.fp(xr)):
                    simplex.Z = xc1
                else:
                    # shrinking
                    simplex.Y = tuple((pd.Series(xl) + nu*(pd.Series(xg) - pd.Series(xl))).tolist())
                    simplex.simplex_co *= nu
                    # ?
            else:
                xc2 = tuple((pd.Series(xc) + beta*(pd.Series(xh) - pd.Series(xc))).tolist())
                if(target.fp(xc2) < target.fp(xh)):
                    simplex.Z = xc2
                else:
                    # shrink
                    simplex.Y = tuple((pd.Series(xl) + nu*(pd.Series(xg) - pd.Series(xl))).tolist())
                    simplex.simplex_co *= nu
                # 

        simplex.best = xc
        Iterations += 1
        # Check the condition
        if Iterations > 100:
            continueCalculation = False

    plt.show()


if __name__ == "__main__":
    target = TargetFunction()
    deformed_simplex(target, alpha, XN)

    # simplex = Simplex(XN, alpha)