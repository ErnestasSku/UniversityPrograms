from glob import glob
from TargetFunction import f
from Utilities import show_table

iterations = 0
functionCalls = 0

# Skaiciuoti kiek kartu kvieciama funckiją f(x)
def callFunction(x):
    global functionCalls
    functionCalls += 1
    return f(x)

interval = (0, 10)
epsilon = 10**-4


L_func = lambda l, r : r - l
mean = lambda l, r : (l + r) / 2
resultFunc = lambda l, r, i : (l, r, f(l), f(r))


def start_bisection():
    l, r = interval    
    x_m = (l + r) / 2
    fxm = callFunction(x_m)
    return [resultFunc(l, r, iterations)] + bisection(interval, x_m, fxm)

def bisection(current_interval, xm, fxm):
    global iterations
    iterations += 1
    
    l, r = current_interval
    L = L_func(l, r)
    x1 = l + L / 4
    x2 = r - L / 4


    fx1 = callFunction(x1)
    fx2 = callFunction(x2)

    if (fx1 < fxm):
        r = xm
        xm = x1
        fxm = fx1
    elif (fx2 < fxm):
        l = xm
        xm = x2
        fxm = fx2
    else:
        l = x1
        r = x2

    L = L_func(l, r)
    if (L < epsilon):
        return [resultFunc(l, r, iterations)]
    else:
        return [resultFunc(l, r, iterations)] + bisection((l,r), xm, fxm)

results = start_bisection()
print('Itterations ', end=' ')
print(iterations)

print('function calls ', end=' ')
print(functionCalls)


show_table(results)