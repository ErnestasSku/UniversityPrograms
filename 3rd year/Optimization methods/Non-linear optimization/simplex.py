import numpy as np

iterations = 0

C = np.array([2, -3, 0 , -5])
constraints = np.array([[-1, 1, -1, -1], [2, 4, 0, 0], [0, 0, 1, 1]])
# values = np.array([[-3], [0], [1]])
values = np.array([[0], [4], [9]])

s = np.eye(len(constraints))
A = np.hstack((values, constraints, s))

topRow = np.zeros(len(A[1]))
topRow[1:5] = C
table = np.vstack((topRow, A))


# B = np.array([len(A[1]) - 3, len(A[1]) - 2, len(A[0]) - 1])
B = np.array([len(A[1]) - 4, len(A[1]) - 3, len(A[0]) - 2])

while True:
    print('Iteracija ', iterations)
    print(table)
    
    minVal = np.min(table[0,:])
    minCol = np.argmin(table[0,:])
    
    if minVal >= 0:
        vals = np.zeros(len(table[0]))
        solCol = table[:, 0]
        f, solCol = solCol[0], solCol[1:]
        vals[B] = solCol

        BP = list(map(lambda x: x+1, B))
        print('Vektoriaus bazė ', BP[0:3])
        print('Minimumo tašas ', vals[0:4])
        print('f(x)=', -1*f, 'iteracijos ', iterations)
        break;

    iterations += 1
    sol = table[:,0]
    column = table[:, minCol]
    if np.all(column <= 0):
        print("Error")
        break

    baseCalc = np.zeros(4)
    for i in range(0, len(column)):
        if column[i] > 0:
            baseCalc[i] = sol[i] / column[i]
        else:
            baseCalc[i] = np.inf
    minBase = np.min(baseCalc)
    baseRow = np.argmin(baseCalc)

    pivotKey = table[baseRow, minCol]
    B[baseRow-1] = minCol - 1
    table[baseRow, :] = table[baseRow, :] / pivotKey
    
    for i in range(0, len(table)):
        if i != baseRow:
            table[i,:] = table[i,:] - table[i, minCol]*table[baseRow, :]
    