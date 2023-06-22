# Ernestas Škudzinskas
# 3 kursas 4 grupė
# 2016049

import numpy as np
import sympy as sp
import matplotlib.pyplot as plt

# Dictionary to easily turn on/off the output of tasks
printable = {
    '1' :  False,
    '2' :  False,
    '3' :  False,
    '4' :  False,
    '5' :  False,
    '6' :  False,
    '7' :  False,
    '8' :  False,
    '9' :  False,
    '10' : False,
    '11' : False,
    '12' : True,
}

# 1.
equal64 = np.linspace(-1.3, 2.5, 64)

if (printable['1']):
    print('1', equal64)

# 2.
array_to_repeat = [1,2,3,4]
N2 = 3
repeated = array_to_repeat * N2;

if (printable['2']):
    print('2', repeated)

# 3.
given_number = 3
N3 = 4
repeated3 = np.repeat(given_number, N3)
repeated3_2 = [given_number for x in range(N3)]

if (printable['3']):
    print('3', end=' ')
    print(repeated3)
    print(repeated3_2)

# 4.
# array4 = np.ones((10, 10))

array4_1 = np.zeros((9,9))
padded = np.pad(array4_1, (1, 1), 'constant', constant_values=(1, 1))

if (printable['4']):
    print('4', end=' ')
    # print(array4)
    print(padded)

# 5.

checkboard = [[(j + i) % 2 for j in range(8)] for i in range(8)]

if (printable['5']):
    print('5', checkboard)

# 6.

sums = [[(j + i) for j in range(8)] for i in range(8)]
if (printable['6']):
    print('6', sums)

# 7.
ran = np.random.rand(5,5)
# ran_sorted = np.sort(ran, axis=1)
ran_sorted = np.sort(ran, axis=1)

if printable['7']:
    print('7', end=' ')
    print(ran)
    print('--------------')
    print(ran_sorted)

# 8.
matrix = [[1, 2, 3],
          [4, 5, 6],
          [7, 8, 9]]

# eigenvalue - tikrinė reikšmė
eig_value, eig_vector = np.linalg.eig(matrix); 
if printable['8']:
    print(f'8 tikriniės reikšmės: {eig_value}, \ntikrinis vektorius: {eig_vector}')

# 9.
x = sp.symbols('x')
f = 0.5*x**2 + 5*x + 4
poly = np.poly1d([0.5, 5, 4])
derivative_1 = np.polyder(poly)
derivative_2 = np.polyder(poly, 2)

# sympy method
derivative_1_sp = sp.diff(f, x)
derivative_2_sp = sp.diff(f, x, 2)

if printable['9']:
    print(f'9 \npirma išvestinė: {derivative_1} \nantra išvestinė: {derivative_2} \n\
naudojant sympy: išvestinė: {derivative_1_sp} \nantra išvestinė: {derivative_2_sp}')

# 10.

x = sp.symbols('x')
f = sp.exp(-x)

a, b = 0, 1
integral_a = sp.integrate(sp.exp(-x), (x, 0, 1))

integral_n = sp.integrate(f, x)

if printable['10']:
    print(f'10. integralas (apib): {integral_a.evalf()} \nIntegralas (neap): {integral_n}')

# 11.
a = 1
theta = np.linspace(0, 2*np.pi, 200)
x = a * (2*np.cos(theta) - np.cos(2*theta))
y = a * (2*np.sin(theta) - np.sin(2*theta))

if printable['11']:
    plt.plot(x, y)
    plt.axis('equal')
    plt.title('Kardioidė')
    plt.show()

# 12.
V = 10
D = 5
x = np.random.normal(V, D, 1000)

if printable['12']:
    plt.hist(x, bins=30, density=True, alpha=0.7, color='blue')
    plt.xlabel('x')
    plt.ylabel('Dažnis')
    plt.title('Atsitiktiniai skaičiai iš normalaus pasiskirstymo')
    plt.show()