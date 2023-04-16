import sympy as sp

a, b = sp.symbols("a b")

# a = xy/2; b = xz/2; c = yz/2
# S = a+b+c = 1
# V² = (xyz)²
# V² = xy xz yz
# V² = abc/8
# c = 1 - a - b

class TargetFunction():
    def __init__(self):
        self.functionCalls = 0
        self.gradientCalls = 0
        self.funcMemo = {}
        self.gradMemo = {}

    def f(self, a, b):
        if not (a, b) in self.funcMemo: 
            self.functionCalls += 1
            self.funcMemo[(a, b)] = -(a*b*(1-a-b))/8
        return self.funcMemo[(a, b)]

    # f uncounted
    def fu(self, a, b): 
        return -(a*b*(1-a-b))/8

    # f point
    def fp(self, X):
        if not X in self.funcMemo: 
            self.functionCalls += 1
            self.funcMemo[X] =  -(X[0]*X[1]*(1-X[0]-X[1]))/8
        return self.funcMemo[X]

    # f gradient
    def grad(self, x, y):
        self.gradientCalls += 1
        return [-((y*(-2*x-y+1))/8), -((x*(-2*y-x+1))/8)]
