import string
from graph import Graph
# global variables
fileNumber = 3
inputFile = "input{fileNumber}.txt"
outputFile = "output{fileNumber}.txt"

def main():
    global inputFile, fileNumber
    readFile(inputFile)
    return

def readFile(inputFile):
    global fileNumber
    fi = open(inputFile.format(fileNumber = fileNumber), "r")
    fo = open(outputFile.format(fileNumber = fileNumber), "w")
    beginWriteFile(fo)
    n = int(fi.readline())
    m = int(fi.readline())

    fo.write("\n\nI dalis - pradiniai duomenys\n")
    # fo.write("Pradžios taškas  Pabaigos taškas  Svoris\n")
    graph = Graph(n)
    for i in range(m):
        line = fi.readline()
        r = [int(x) for x in line.split()]
        # print(len(r))
        fo.write("\t%c <-> %c | %d\n" % (chr(ord("A") + r[0]), chr(ord("A") + r[1]), r[2]))
        graph.addEdge(r[0], r[1], r[2])
    
    fo.write("\n\nII dalis - vykdymas\n")
    # graph.append()
    graph.kruskal(fo=fo)
    
    fo.write("\n\nIII dalis - resultatai")
    fo.write("\n\tMinimalaus medžio svoris %d" % graph.weight)


def beginWriteFile(fo):
    fo.write("Ernestas Škudzinskas 4 grupė\n15 variantas. Iš duoto grafo su svoriais suformuoti minimalų medį. Minimalus medis yra iš grafo suformuotas medis, \nkurio bendras briaunų svoris yra minimalus. (Grafo realizacija grindžiama kaimynystės matrica.)\n")
    fo.write("Realizacijos detalės: naudojamas kruskalo algoritmas, viršūnės žymimos raidėmis.\nAlgorimo paaiškinimas: pradedame paieška nuo viršūnių, kurių svoris yra mažiausias.")

if __name__ == "__main__":
    main()