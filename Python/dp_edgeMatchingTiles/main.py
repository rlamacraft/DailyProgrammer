#WIP

from enum import Enum

class Colour(Enum):
    c = 0
    y = 1
    m = 2
    k = 3
    C = 4
    Y = 5
    M = 6
    K = 7

class Tile:
    name = ""
    edges = []

    def __init__(self, name, edges):
        self.edges = edges
        self.name = name

def colourInput(input):
    output = []
    for eachChar in input:
        output.append(Colour[eachChar])

gridSize = int(input("Enter the size of the grid: "))

grid = []
for i in range(gridSize):
    gridCol = []
    for j in range(gridSize):
        newCellName = chr((i*gridSize + j) + 65)
        newCellColours = colourInput(input())
        gridCol.append(Tile(newCellName,newCellColours))
    grid.append(gridCol)

