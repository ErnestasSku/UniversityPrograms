import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from TargetFunction import f, fd1, fd2
from Utilities import show_table

iterations = 0
max = False

x0 = 0.7
step_size = 10**-4

resultFunc = lambda x, y, it : (x, y)

class OptimizationResults:
    def __init__(self):
        self.iterations = 0
        self.result = []


def start_newton():
    return [resultFunc(x0, f(x0), iterations)] + newton(x0)

def newton(xi):
    global iterations
    global max

    iterations += 1


    d1 = fd1(xi)
    d2 = fd2(xi)
    print(d1, d2)
    # If antros eilės išvestinė yra mažiau už 0, tai rastas maksimumas.
    if (d2 < 0):
        max = True
        print('rastas maximumas')
        return []

    xin = xi - d1/d2
    if (step_size > abs(xin - xi)):
        return [resultFunc(xin, f(xin), iterations)]
    else:
        return [resultFunc(xin, f(xin), iterations)] + newton(xin)

print(max, iterations)
if (max):
    print("Rastas funkcijos maksimumas")
else:
    results = start_newton()
    print(results)
    # show_table(results, list('xy'))


