import Foundation

//provides substring extension to String through subscript ranges
extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = advance(self.startIndex, r.startIndex)
            let endIndex = advance(startIndex, r.endIndex - r.startIndex)
            
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
}

func hexToBin(hex: String) -> String {
    var output: String = ""
    var hexValues = ["1": "0001", "2": "0010", "3": "0011", "4": "0100", "5": "0101", "6": "0110", "7": "0111", "8": "1000", "9": "1001", "A": "1010", "B": "1011", "C": "1100", "D": "1101", "E": "1110", "F": "1111"]
    
    for eachChar in hex {
        output += String(hexValues[String(eachChar)]!)
    }
    
    return output
}

class Cell {
    var value: Bool
    
    init(input: Bool) {
        value = input
    }
}

class Row {
    var hex: String
    var bin: String
    var cells: Cell[] = []
    
    init(input: String) {
        hex = input
        bin = hexToBin(hex)
        for eachChar in bin {
            if eachChar == "1" {
                cells.append(Cell(input: true))
            } else {
                cells.append(Cell(input: false))
            }
        }
    }
    
    init() {
        hex = ""
        bin = ""
    }
}

func storeData(input:String) -> Row[]{
    var rows: Row[] = []
    var lowerIndex = 0
    var upperIndex = -1
    var counter = 0
    
    for eachChar in input {
        if (eachChar == " ") {
            lowerIndex = upperIndex + 1
            upperIndex = counter
            
            let tmp = input[lowerIndex..upperIndex]
            rows.append(Row(input: String(tmp)))
        }
        if (counter == countElements(input) - 1) {
            lowerIndex = upperIndex + 1
            upperIndex = countElements(input)
            
            let tmp = input[lowerIndex..upperIndex]
            rows.append(Row(input: String(tmp)))
        }
        counter++
    }
    
    return rows
}

func printImage(image: Row[]) {
    for eachRow in image {
        var output = ""
        for eachCell in eachRow.cells {
            if eachCell.value == true {
                output += "X"
            } else {
                output += " "
            }
        }
        println(output)
    }
}

func rotate(input:Row[],direction:String) -> Row[] {
    
    var  newGrid: Row[] = []
    
    //fill with emptiness
    for eachRow in input {
        var newRow = Row()
        for eachCell in eachRow.cells {
            newRow.cells.append(Cell(input: false))
        }
        newGrid.append(newRow)
    }
    
    if direction == "clockwise" {
        var rowCounter = countElements(input) - 1
        var columnCounter = 0
        
        for eachRow in newGrid {
            rowCounter = countElements(input) - 1
            for eachCell in eachRow.cells {
                eachCell.value = input[rowCounter].cells[columnCounter].value
                rowCounter--
            }
            columnCounter++
        }
    } else if direction == "counterclockwise" || direction == "anticlockwise" {
        var rowCounter = 0
        var columnCounter = 7
        
        for eachRow in newGrid {
            rowCounter = 0
            for eachCell in eachRow.cells {
                eachCell.value = input[rowCounter].cells[columnCounter].value
                rowCounter++
            }
            columnCounter--
        }
    } else {
        println("Invalid direction")
    }
    
    return newGrid
}

func zoom(input:Row[]) -> Row[] {
    
    var newGrid: Row[] = []
    for eachRow in input {
        
        var newRow: Row = Row()
        for eachCell in eachRow.cells {
            newRow.cells.append(eachCell)
            newRow.cells.append(eachCell)
        }
        newGrid.append(newRow)
        
        newRow = Row()
        for eachCell in eachRow.cells {
            newRow.cells.append(eachCell)
            newRow.cells.append(eachCell)
        }
        newGrid.append(newRow)
    }
    
    return newGrid
}

func invert(input:Row[]) -> Row[] {
    
    var newGrid: Row[] = []
    for eachRow in input {
        var newRow = Row()
        for eachCell in eachRow.cells {
            newRow.cells.append(Cell(input: !eachCell.value))
        }
        newGrid.append(newRow)
    }

    return newGrid
}

func performAction(input: Row[],action:String,direction:String?) -> Row[] {
    switch action {
    case "invert":
        return(invert(input))
    case "rotate":
        return(rotate(input,direction!))
    case "zoom":
        return(zoom(input))
    default:
        print("invalid action")
        return []
    }
}

var testInput = storeData("18 3C 7E 7E 18 18 18 18")
printImage(testInput)
println()
println()


testInput = performAction(testInput, "zoom", nil)
testInput = performAction(testInput, "zoom", nil)
testInput = performAction(testInput, "rotate", "clockwise")
testInput = performAction(testInput, "zoom", nil)
testInput = performAction(testInput, "zoom", nil)
testInput = performAction(testInput, "invert", nil)
testInput = performAction(testInput, "zoom", nil)
testInput = performAction(testInput, "zoom", nil)


/*testInput = performAction(testInput, "zoom", nil)
testInput = performAction(testInput, "rotate", "clockwise")*/

printImage(testInput)








//var action = "rotate" //enter rotate, zoom or invert

/*switch action {
    case "invert":
    printImage(invert(testInput))
    case "rotate":
    var direction = "anticlockwise"
    printImage(rotate(testInput,direction))
    case "zoom":
    printImage(zoom(testInput))
    default:
    print("invalid action")
}*/

