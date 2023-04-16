import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import scipy.constants 

from TargetFunction import f
from Utilities import show_table

tau = scipy.constants.golden - 1


iterations = 0
functionCalls = 0
interval = (1, 10)
epsilon = 10**-4

def callFunction(x):
    global functionCalls
    functionCalls += 1
    return f(x)

L_func = lambda l, r : r - l
resultFunc = lambda l, r, i : (l, r, f(l), f(r)) 


def start_golden_section():
    l, r = interval
    
    L = L_func(l, r)
    x1 = r - tau * L
    x2 = l + tau * L
    f1 = callFunction(x1)
    f2 = callFunction(x2)
    return [resultFunc(l, r, iterations)] + golden_section(interval, f1, f2)

def golden_section(current_interval, f1, f2):
    global iterations
    iterations += 1

    l, r = current_interval
    L = L_func(l, r)
    x1 = r - tau * L
    x2 = l + tau * L

    if (f2 < f1):
        l = x1
        L = L_func(l, r)
        x1 = x2
        f1 = f2
        x2 = l + tau * L
        f2 = callFunction(x2)
    else:
        r = x2
        L = L_func(l, r)
        x2 = x1
        f2 = f1
        x1 = r - tau * L
        f1 = callFunction(x1)

    if (L < epsilon):
        return [resultFunc(l, r, iterations)]
    else:
        return [resultFunc(l, r, iterations)] + golden_section((l, r), f1, f2)


results = start_golden_section()
print('Itterations ', end=' ')
print(iterations)

print('Function calls ')
print(functionCalls)

# Table
show_table(results)