calculations = 0
foundSolutions = 0
correctLists = []

shortOutput = open("trumpas1.txt", "w")
longOutput = open("ilgas1.txt", "w")

def readFile(fileName):

    f = open(fileName, "r")
   
    n = int(f.readline())
    m = int(f.readline())
    requiredSum = int(f.readline())

    line = f.readline()
    numberList = [int(x) for x in line.split()]

    return n, m, requiredSum, numberList

def search(n, m, reqSum, curSum, numberList, currList, index, depth):


    global longOutput, calculations, correctLists, foundSolutions
    calculations += 1

    longOutput.write("\t%d) %s Skaičiai: %s. Suma: %d. " % (calculations, (depth * '-'), [item for item in currList], curSum ) )

    if depth >= m and curSum == reqSum:
        longOutput.write("Gauta\n")
        temp = currList.copy()
        correctLists.append(temp)
        foundSolutions += 1
    else:
        longOutput.write("Negauta\n")

    if depth >= m:
        return

    for i in range(index, len(numberList)):

        currList.append(numberList[i])
        search(n, m, reqSum, curSum + numberList[i], numberList, currList, i + 1, depth + 1)
        currList.pop()


def printFirst(f, n, m, requiredSum, numbers):
    f.write("""Ernestas Škudzinskas, 4 grupė\nAntroji užduotis. Variantas 1. Iš duotų N natūrinių skaičių išrinkti M skaičių taip, kad jų suma
būtų lygi S. Vartotojas nurodo failą, iš kurio  programa įveda pradinius N skaičių, bei skaičius M ir S. \nMaksimali n reikšme ne didesnė nei 30\n\n""")

    f.write("I Dalis - duomenys\n")
    f.write("N = %d\n" % n)
    f.write("M = %d\n" % m)
    f.write("S = %d\n" % requiredSum)
    f.write("Pradiniai skaiciai - %s\n" % [item for item in numbers]  )
    
def PrintEnd(f):
    global calculations, foundSolutions, correctLists
    f.write("\nIII Dalis - rezultatai\n")
    f.write("Atlikta bandymų: %d\n" % calculations)
    f.write("Rasta teisingų variantų: %d\n" % foundSolutions)
    f.write("Teisingi variantai: \n\n")

    for i in range(foundSolutions):
        f.write("%d) Skaičiai: %s\n" % (i + 1, [item for item in correctLists[i]]))

def printCancel():
    global shortOutput, longOutput

    shortOutput.write("\nDarbas nutraukiamas.\nPriežastis: skaičiai yra per dideli")
    longOutput.write("\nDarbas nutraukiamas.\nPriežastis: skaičiai yra per dideli")

def main():

    numbers = []
    fileName = input("Iveskite failo pavadinma ")
    n , m, requiredSum, numbers = readFile(fileName)

    data = list(range(m))
    global shortOutput, longOutput

    printFirst(longOutput, n, m, requiredSum, numbers)
    printFirst(shortOutput, n, m, requiredSum, numbers)

    if n > 30:
        printCancel()
        return

    longOutput.write("\nII dalis- vykdymas\n")
    search(n, m, requiredSum, 0, numbers, [], 0, 0)

    global calculations, foundSolutions, correctLists

    PrintEnd(longOutput)
    PrintEnd(shortOutput)

main()