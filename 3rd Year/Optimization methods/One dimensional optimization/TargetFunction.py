def f(x):
    y = (((x**2 - 4)**2) / 9) - 1  
    return y 

def fd1(x):
    y =  (x * (x**2 - 4)) * 4 / 9 
    return y

def fd2(x):
    y = (3 * x**2 - 4)  * 4 / 9
    return y