import numpy as np
import matplotlib.pyplot as plt

from TargetFunction import f

interval = (0, 10)
data  = {"Intervalų pusiau \ndalinimo metodas" : 17, "Auskinio pjūvio metodas" : 24, "Niutono metodas" : 7}

if __name__ == "__main__":
    l, r = interval
    xvalues = np.linspace(0, 3, 100)
    yvalues = list(map(f, xvalues))
    plt.plot(xvalues, yvalues)
    plt.show()
    
    methods = list(data.keys())
    values = list(data.values())

    plt.bar(methods, values, width=0.4)
    plt.xlabel("Metodai")
    plt.ylabel("Iteracijų skaičius")
    plt.show()