import pandas as pd
from simplex import Simplex

class Function_Wrapper:
    def __init__(self, f):
        self.f = f
        self.f_calls = 0
        self.memo = {}
    
    def cf(self, X, r):
        if (tuple(X), r) not in self.memo:
            self.f_calls += 1
            self.memo[(tuple(X), r)] = self.f(X, r)
        return self.memo[(tuple(X), r)]

    def get_calls(self):
        return self.f_calls

def f(X):
    x = X[0]
    y = X[1]
    z = X[2]
    return -x*y*z

def g(X):
    x = X[0]
    y = X[1]
    z = X[2]
    return 2*x*y + 2*x*z + 2*y*z - 1

def h(x):
    return -x

def hh(X):
    return (h(X[0]), h(X[1]), h(X[2]))

def b(X):
    x = X[0]
    y = X[1]
    z = X[2]
    return max(0, h(x))**2 + \
           max(0, h(y))**2 + \
           max(0, h(z))**2 + \
           g(X)**2

def B(X, r):
    return f(X) + (1/r)*b(X)

point_to_str = lambda X : (ptsh(X[0]), ptsh(X[1]), ptsh(X[2]))
ptsh = lambda x : float(str(x)[:8])

x0 = [0, 0, 0]
x1 = [1, 1, 1]
xn = [0, 0.4, 0.9]
r_base = 3
r = r_base
rn = 0.5
epslilon = 10**-5
itterations = 0

change = 1000
oldValue = None

optimize = True
x_base = x0
x_name = 'x0'
if __name__ == "__main__":
    if optimize:
        for inx, i in enumerate([x0, x1, xn]):
            r = r_base
            itterations = 0
            change = 1000
            full_table = []
            xu = i
            oldValue = B(xu, r)
            fclass = Function_Wrapper(B)    
            while change >= epslilon:
                Res, ft = Simplex(fclass, xu, r)
                xu = Res
                newValue = B(Res, r)
                full_table.append([point_to_str(Res), (f(Res)), r, B(Res, r)])
                change = abs(oldValue - newValue)
                oldValue = newValue
                r *= rn
                itterations += 1
            print(itterations, fclass.get_calls())
            df = pd.DataFrame(full_table)
            df.to_excel(excel_writer=f"data-{inx}.xlsx", header=["(x,y,z,)", "f(x, y, z)", "r", "B(x, y, z, r)"])
    else:
        print(f(x0), '\t', f(x1), '\t', f(xn))
        print(g(x0), '\t', g(x1), '\t', g(xn))
        print(hh(x0), '\t', hh(x1), '\t', hh(xn))
        

