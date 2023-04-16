# Modified version of Golden Section
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import scipy.constants 


tau = scipy.constants.golden - 1


iterations = 0
functionCalls = 0
epsilon = 10**-6

class OptimizationResults:
    def __init__(self):
        self.iterations = 0
        self.result = []

L_func = lambda l, r : r - l


def start_golden_section(func, interval):
    l, r = interval
    
    L = L_func(l, r)
    x1 = r - tau * L
    x2 = l + tau * L
    f1 = func(x1)
    f2 = func(x2)
    # print('f1 f2', f1, f2)
    return golden_section(func, interval, f1, f2)

def golden_section(func, current_interval, f1, f2):
    global iterations
    iterations += 1

    l, r = current_interval
    # print(current_interval)
    L = L_func(l, r)
    x1 = r - tau * L
    x2 = l + tau * L

    if (f2 < f1):
        l = x1
        L = L_func(l, r)
        x1 = x2
        f1 = f2
        x2 = l + tau * L
        f2 = func(x2)
    else:
        r = x2
        L = L_func(l, r)
        x2 = x1
        f2 = f1
        x1 = r - tau * L
        f1 = func(x1)

    if (L < epsilon):
        return np.array([l, r])
    else:
        return golden_section(func, (l, r), f1, f2)



def getResults(func, interval):
    global iterations

    resClass = OptimizationResults()

    resClass.result = start_golden_section(func, interval)
    resClass.iterations = iterations

    iterations = 0
    return resClass

