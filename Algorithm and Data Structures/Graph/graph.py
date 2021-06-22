
class Graph:
    def __init__(self, vertices):
        self.V = vertices
        self.graph = []
        self.weight = 0
        # self.outputFile = open(outputFile, "a")

    def addEdge(self, u, v, w):
        self.graph.append([u, v, w])

    def find(self, parent, i):
        if (parent[i] == i):
            return i
        return self.find(parent, parent[i])
    
    def applyUnion(self, parent, rank, x, y):
        xRoot = self.find(parent, x)
        yRoot = self.find(parent, y)
        if (rank[xRoot] < rank[yRoot]):
            parent[xRoot] = yRoot
        elif (rank[xRoot] > rank[yRoot]):
            parent[yRoot] = xRoot
        else:
            parent[yRoot] = xRoot
            rank[xRoot] += 1
    
    # def append(self):
    #     fo = open(outputFile, "a")

    def kruskal(self, fo):
        result = []
        i, e = 0, 0
        self.graph = sorted(self.graph, key = lambda item: item[2])
        parent = []
        rank = []
        for node in range(self.V):
            parent.append(node)
            rank.append(0)
        # print("Graph size %d" % len(self.graph))

        while e < self.V - 1 and i < len(self.graph):
            print(len(self.graph), i)
            u, v, w = self.graph[i]
            i = i + 1
            x = self.find(parent, u)
            y = self.find(parent, v)
            # fo.write()
            fo.write("\nIteracija: %d\n\tImame primą briauną su mažiausiu svoriu: %c <-> %c, svoris %d." % (i, chr(ord("A") + u), chr(ord("A") + v), w))
            if (x != y):
                e = e + 1
                # fo.write("\n\tPridedam %c <-> %c su svoriu %d į minimalų medį\n" % ( chr(ord("A") + u), chr(ord("A") + v), w))
                fo.write("\n\tPridedam %c <-> %c į minimalų medį" % (chr(ord("A") + u), chr(ord("A") + v)))
                self.weight += w
                result.append([u, v, w])
                self.applyUnion(parent, rank, x, y)
            else: 
                fo.write("\n\tNetinka: nes susidaro ciklas\n")
        fo.write("\tAlgoritmas baigia darbą - minimalus medis suformuotas")
        # for u, v, weight in result:
        #     print("%d-%d: %d" % (u, v, weight))
