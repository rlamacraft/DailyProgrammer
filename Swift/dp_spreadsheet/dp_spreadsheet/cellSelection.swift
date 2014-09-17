//
//  cellSelection.swift
//  dp_cellSelection
//
//  Created by Robert Lamacraft on 21/08/2014.
//  Copyright (c) 2014 Robert Lamacraft. All rights reserved.
//

import Foundation

var prevGrid:Array<Array<Cell>> = Array<Array<Cell>>()
var newGrid:Array<Array<Cell>> = Array<Array<Cell>>()

func reverseString(input:String) -> String {
    var output:String = ""
    var inputArray:Character[] = []
    for eachChar in input {
        inputArray.append(eachChar)
    }
    for var index = inputArray.count-1;index >= 0;index-- {
        output += inputArray[index]
    }
    return output
}

func decToBase26(input:Int) -> String {
    var n = input
    var ret = ""
    while(n>0) {
        n--
        for eachChar in "A".unicodeScalars {
            var test = Int(eachChar.value)
            test += (n % 26)
            ret += Character(UnicodeScalar(test))
        }
        n/=26
    }
    ret = reverseString(ret)
    return ret
}

func base26ToDec(input:String) -> Int {
    var number = input.uppercaseString
    
    var uniNum:Int[] = []
    for eachChar in number.unicodeScalars {
        uniNum.append(Int(eachChar.value))
    }
    
    var decimalValue = 0
    for (var i = countElements(number) - 1;i>=0;i--) {
        decimalValue *= 26
        decimalValue += (uniNum[i] - 64)
    }
    return decimalValue
}

func identifyCells(selectionString:String) -> Cell[] {
    var ret:Cell[] = []
    var lowerBound = 0
    var upperBound  = -1
    var index = 0
    for eachChar in selectionString {
        if (eachChar == ":") || (eachChar == "&") || (eachChar == "~") || (eachChar == " ") {
            lowerBound = upperBound + 1
            upperBound = index
            let cellDesc = selectionString[lowerBound..upperBound]
            
            var i = 0
            for eachComp in cellDesc {
                if !(eachComp + "").toInt() {
                    i++
                }
            }
            
            let x = base26ToDec(cellDesc[0..i]) - 1
            let y = cellDesc[i..countElements(cellDesc)].toInt()! - 1
            ret.append(Cell(x:x,y:y))
        }
        index++
    }
    return ret
}

//find maximum row in given selection range, i.e. y
func findMaxRow(input:Cell[]) -> Int {
    var maxValue:Int = input[0].rowI
    for eachCell in input {
        if eachCell.rowI > maxValue {
            maxValue = eachCell.rowI
        }
    }
    return maxValue
}

//find minimum row in given selection range, i.e. y
func findMinRow(input:Cell[]) -> Int {
    var minValue:Int = input[0].rowI
    for eachCell in input {
        if eachCell.rowI < minValue {
            minValue = eachCell.rowI
        }
    }
    return minValue
}

//find maximum col in given selection range, i.e. x
func findMaxCol(input:Cell[]) -> Int {
    var maxValue:Int = input[0].colI
    for eachCell in input {
        if eachCell.colI > maxValue {
            maxValue = eachCell.colI
        }
    }
    return maxValue
}

//find minimum col in given selection range, i.e. x
func findMinCol(input:Cell[]) -> Int {
    var minValue:Int = input[0].colI
    for eachCell in input {
        if eachCell.colI < minValue {
            minValue = eachCell.colI
        }
    }
    return minValue
}

func splitString(input:String) -> (pos:String,neg:String) {
    var splitIndex = 0
    var index = 0
    for eachChar in input {
        if eachChar == "~" {
            splitIndex = index
        }
        index++
    }
    if splitIndex == 0 {
        return (input,"")
    } else {
        return(input[0..splitIndex],input[splitIndex+1..countElements(input)])
    }
}

func components(input:String) -> String[] {
    var editedInput = input
    var ret:String[] = []
    var lowerIndex = 0
    var upperIndex = -1
    var index = 0
    for eachChar in editedInput {
        if eachChar == "&" {
            lowerIndex = upperIndex + 1
            upperIndex = index
            ret.append(editedInput[lowerIndex..upperIndex])
        }
        index++
    }
    
    lowerIndex = upperIndex + 1
    upperIndex = index
    ret.append(editedInput[lowerIndex..upperIndex])
    return ret
}

func makeSelection(components:String[],mode:Bool) {
    for eachComp in components {
        var splitIndex = 0
        var index = 0
        for eachChar in eachComp {
            if eachChar == ":" {
                splitIndex = index
            }
            index++
        }
        
        if splitIndex == 0 {
            //single cell
            let selectedCell = Cell(desc: eachComp)
            newGrid[selectedCell.rowI][selectedCell.colI].selected = mode
            
            //create cell
            //find cell in grid
            //set to mode i.e. select or deselect
        } else {
            //cell range
            //identify each cell
            //find co-ords
            //iterate through matrix setting to mode
            
            let firstCell = Cell(desc: eachComp[0..splitIndex])
            let secondCell = Cell(desc: eachComp[splitIndex+1..countElements(eachComp)])
            let leftPoint = firstCell.colI < secondCell.colI ? firstCell.colI : secondCell.colI
            let rightPoint = firstCell.colI > secondCell.colI ? firstCell.colI : secondCell.colI
            let topPoint = firstCell.rowI < secondCell.rowI ? firstCell.rowI : secondCell.rowI
            let bottomPoint = firstCell.rowI > secondCell.rowI ? firstCell.rowI : secondCell.rowI
            
            for i in topPoint...bottomPoint {
                for j in leftPoint...rightPoint {
                    newGrid[i][j].selected = mode
                }
            }
        }
    }
}

func cellSelectionMain(input:String) -> Array<Array<Cell>> {
    newGrid = Array<Array<Cell>>()
   
    var selectionString = input + "&"
    var identifiedCells:Cell[] = identifyCells(selectionString) //find cells user mentioned in selection string
    var maxRow:Int = findMaxRow(identifiedCells) //furthest down cell user selected
    var maxCol:Int = findMaxCol(identifiedCells) //furthest right cell user selected

    //only expand grid if new selection is larger than previous grid
    if let tmp = grid {
        if maxCol < countElements(tmp[0]) - 1 {
            maxCol = countElements(tmp[0]) - 1
        }
        if maxRow < countElements(tmp) - 1 {
            maxRow = countElements(tmp) - 1
        }
        prevGrid = tmp
    }
    
    //generate array of size specified by user
    for i in 0...maxRow {
        var newRow:Array<Cell> = Array<Cell>()
        for j in 0...maxCol {
            newRow.append(Cell(x:i,y:j))
        }
        newGrid.append(newRow)
    }
    
    var i = 0,j = 0
    for eachRow in prevGrid {
        for eachCell in eachRow {
            newGrid[i][j].value = eachCell.value
            j++
        }
        i++
        j = 0
    }

    //actually start processing
    let splitSelectionString = splitString(selectionString[0..countElements(selectionString)-1])

    let posComponents:String[] = components(splitSelectionString.pos)
    var negComponents:String[] = []
    if splitSelectionString.neg != "" {
        negComponents = components(splitSelectionString.neg)
    }

    makeSelection(posComponents,true)
    if countElements(negComponents) > 0 {
        makeSelection(negComponents,false)
    }
    
    return newGrid
}
