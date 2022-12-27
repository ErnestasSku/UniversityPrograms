from math import sqrt
import numpy as np
import pandas as pd


alfa = 0.1
n = 3
gamma = 1.5
beta = 0.5
nu = -0.5
epslion = 10**-5

functionCalls = 0




def Simplex(f, xu, r):
    global functionCalls
    functionCalls = 0
    Iterations = 0    
    x = np.zeros((n, n+1))
    thetha1 = ((sqrt(n+1)+n-1)/(n*sqrt(n)))*alfa
    thetha2 = ((sqrt(n+1)-1)/(n*sqrt(n)))*alfa

    X1 = np.array([xu[0] + thetha2, xu[1] + thetha1, xu[2] + thetha1])
    X2 = np.array([xu[0] + thetha1, xu[1] + thetha2, xu[2] + thetha1])
    X3 = np.array([xu[0] + thetha1, xu[1] + thetha1, xu[2] + thetha2])

    x[:,0] = xu
    x[:,1] = X1
    x[:,2] = X2
    x[:,3] = X3

    while Iterations < 100:
        virsuniuF = []
        for i in range(n + 1):
            value = f.cf([x[0, i], x[1, i], x[2, i]], r)
            virsuniuF.append(value)
        
        indices = np.array(virsuniuF).ravel().argsort()
        x = x[:, indices]
        Xc4 = x[:,3]
        Xc3 = x[:,2]
        Xc2 = x[:,1]
        Xc1 = x[:,0]

        if (np.std([Xc1, Xc2, Xc3, Xc4]) <= epslion):
            break
        X_new = (Xc1 + Xc2 + Xc3) / n
        Xr = 2*X_new - Xc4

        if f.cf(Xc1, r) < f.cf(Xr, r) and f.cf(Xr, r) < f.cf(Xc3, r):
            x[:,3] = Xr
        elif f.cf(Xr, r) < f.cf(Xc1, r):
            Xe = X_new + gamma*(X_new - Xc4)
            if f.cf(Xe ,r ) < f.cf(Xr, r):
                x[:, n] = Xe
            else:
                x[:, n] = Xr 
        else:
            if f.cf(Xr, r) < f.cf(Xc4, r):
                Xs1 = X_new + beta*(Xr - Xc1)
                if f.cf(Xs1, r) < f.cf(Xr, r):
                    x[:, n] = Xs1
                else:
                    x[:, 1] = Xc1 + nu*(Xc2 - Xc1)
                    x[:, 2] = Xc1 + nu*(Xc3 - Xc1)
                    x[:, 3] = Xc1 + nu*(Xc4 - Xc1)
            else:
                Xs2 = X_new + beta*(Xc4 - X_new)
                if f.cf(Xs2, r) < f.cf(Xc4, r):
                    x[:, n] = Xs2
                else:
                    x[:,1] = Xc1 + nu*(Xc2 - Xc1)
                    x[:,2] = Xc1 + nu*(Xc3 - Xc1)
                    x[:,3] = Xc1 + nu*(Xc4 - Xc1)
        Iterations += 1
    
        
    Xc4 = x[:,3]
    Xc3 = x[:,2]
    Xc2 = x[:,1]
    Xc1 = x[:,0]
    return (Xc4, f.get_calls())

     
