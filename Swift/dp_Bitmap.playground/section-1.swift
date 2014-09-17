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
}

var hexInput = "93 93 93 F3 F3 93 93 93"
var rows: Row[] = []

var lowerIndex = 0
var upperIndex = -1
var counter = 0
println(countElements(hexInput))

//process  data
for eachChar in hexInput {
    if (eachChar == " ") {
        lowerIndex = upperIndex + 1
        upperIndex = counter
        
        let tmp = hexInput[lowerIndex..upperIndex]
        println(tmp)
        rows.append(Row(input: String(tmp)))
    }
    if (counter == countElements(hexInput) - 1) {
        lowerIndex = upperIndex + 1
        upperIndex = countElements(hexInput)
        
        let tmp = hexInput[lowerIndex..upperIndex]
        println(tmp)
        rows.append(Row(input: String(tmp)))
    }
    counter++
}

//output as image
for eachRow in rows {
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

