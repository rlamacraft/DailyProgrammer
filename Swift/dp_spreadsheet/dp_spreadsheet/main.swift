//
//  main.swift
//  dp_spreadsheet
//
//  Created by Robert Lamacraft on 23/08/2014.
//  Copyright (c) 2014 Robert Lamacraft. All rights reserved.
//

import Foundation

func input(text:String) -> String {
    print(text)
    var keyboard = NSFileHandle.fileHandleWithStandardInput()
    var inputData = keyboard.availableData
    return NSString(data: inputData, encoding:NSUTF8StringEncoding)
}

extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = advance(self.startIndex, r.startIndex)
            let endIndex = advance(startIndex, r.endIndex - r.startIndex)
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
}

func helpText() {
    println("type 'quit' to exit")
    println("----Selecting cells----")
    println("Each operation requires cells to be selected before the equals (=)")
    println("This can be a single cell such as A5 or B12")
    println("Or a range of cells denoted with a colon e.g. A5:B12")
    println("A list of ranges, or single cells, can be selected by concatenting with ampersands (&)")
    println("Lastly, cells can be removed from the selection by placing them after a tilde (~)")
    println("A valid cells selection would be B1:B3&B4:E10&F1:G1&F4~C5:C8&B2, for example")
}

func printGrid() {
    for eachRow in grid! {
        for eachCell in eachRow {
            print(eachCell.value)
            print(",")
        }
        println()
    }
}

func printSelectedCells() {
    for eachRow in grid! {
        for eachCell in eachRow {
            if eachCell.selected == true {
                println(eachCell.value)
            }
        }
    }
}

func identifyCommand(userCommand:String) {
    //locate equals to split command into location and equation
    var equalsIndex = -1
    
    var index = 0
    for eachChar in userCommand {
        if eachChar == "=" {
            equalsIndex = index
        }
        index++
    }
    if equalsIndex >= 0 {
        let location = userCommand[0..equalsIndex]
        let equation = userCommand[equalsIndex+1..countElements(userCommand)]
        
        grid = cellSelectionMain(location)
        identifyEquation(equation)
    } else {
        let location = userCommand
        grid = cellSelectionMain(location)
        printSelectedCells()
    }
}

func identifyEquation(equation:String) {
    let numericRegex = "[0-9]*\\.?[0-9]+$" //valid float number
    let referenceRegex = "[A-Z]+[0-9]+$" //valid cell refernce
    let alphanumericChar = "[A-Z0-9]$" //valid char that isn't an operand
    let infixEquationRegex = "(([0-9]*\\.?[0-9]+)|([A-Z]+[0-9]+))[-/+*%^](([0-9]*\\.?[0-9]+)|([A-Z]+[0-9]+))$" //valid infix equation
    let functionRegex = "[a-z]+\\([A-Z]+[0-9]+:[A-Z]+[0-9]+\\)$"
    
    //if the equation matches the form of an infix equation
    if !(equation.rangeOfString(infixEquationRegex, options: .RegularExpressionSearch).isEmpty) {
        
        //split equation into operands and operator
        var operatorIntIndex = countElements(equation)
        var index = 0
        for eachChar in equation {
            let alphanumericMatch = (eachChar+"").rangeOfString(alphanumericChar, options: .RegularExpressionSearch)
            if alphanumericMatch.isEmpty {
                operatorIntIndex = index
            }
            index++
        }
        let operator = equation[operatorIntIndex...operatorIntIndex]
        let firstOperand = equation[0..operatorIntIndex]
        var secondOperand = ""
        if operatorIntIndex < countElements(equation) { //might not be a second operand
            secondOperand = equation[operatorIntIndex+1..countElements(equation)]
        }
        var firstValue: Float = 0.0
        var secondValue: Float = 0.0
        
        //identify first value
        if !(firstOperand.rangeOfString(referenceRegex, options: .RegularExpressionSearch).isEmpty) { //as a refernce to a cell
            let tmpCell = Cell(desc: firstOperand)
            firstValue = grid![tmpCell.rowI][tmpCell.colI].value
        } else if !(firstOperand.rangeOfString(numericRegex, options: .RegularExpressionSearch).isEmpty) { //as literal number
            firstValue = NSString(string: firstOperand).floatValue
        }

        //identify second value
        if !secondOperand.isEmpty { //might not be a second operand if assigning value
            if !(secondOperand.rangeOfString(referenceRegex, options: .RegularExpressionSearch).isEmpty) { //as a refernce to a cell
                let tmpCell = Cell(desc: secondOperand)
                secondValue = grid![tmpCell.rowI][tmpCell.colI].value
            } else  if !(secondOperand.rangeOfString(numericRegex, options: .RegularExpressionSearch).isEmpty) { //as literal number
                secondValue = NSString(string: secondOperand).floatValue
            }
        }
        
        //complete expression
        switch(operator) {
            case "+" : setSelectedCellsTo(firstValue + secondValue)
            case "-" : setSelectedCellsTo(firstValue - secondValue)
            case "*" : setSelectedCellsTo(firstValue * secondValue)
            case "/" : setSelectedCellsTo(firstValue / secondValue)
            case "%" : setSelectedCellsTo(firstValue % secondValue)
            case "^" : setSelectedCellsTo(Float(pow(Double(firstValue),Double(secondValue))))
            default : setSelectedCellsTo(firstValue)
        }
        
    } else
        
    //setting numeric value
    if !(equation.rangeOfString(numericRegex, options: .RegularExpressionSearch).isEmpty) {
        setSelectedCellsTo(NSString(string: equation).floatValue)
    } else
    
    //setting refernce value
    if !(equation.rangeOfString(referenceRegex, options: .RegularExpressionSearch).isEmpty) {
        let tmpCell = Cell(desc: equation)
        setSelectedCellsTo(grid![tmpCell.rowI][tmpCell.colI].value)
    } else
    
    //setting function based value
    if !(equation.rangeOfString(functionRegex, options: .RegularExpressionSearch).isEmpty) {
        var openBracketIndex = 0
        var index = 0
        for eachChar in equation {
            if eachChar == "(" {
                openBracketIndex = index
            }
            index++
        }
        let functionName = equation[0..openBracketIndex]
        let cellRange = equation[openBracketIndex+1..countElements(equation)-1]
        
        var colonIndex:Int = 0
        var newIndex = 0
        for eachChar in cellRange {
            if eachChar == ":" {
                colonIndex = newIndex
            }
            newIndex++
        }
        let firstCell = Cell(desc: cellRange[0..colonIndex])
        let secondCell = Cell(desc: cellRange[colonIndex+1..countElements(cellRange)])
        let specifiedCells: Cell[] = [firstCell,secondCell]
        
        let minRow = findMinRow(specifiedCells)
        let minCol = findMinCol(specifiedCells)
        let maxRow = findMaxRow(specifiedCells)
        let maxCol = findMaxCol(specifiedCells)
        
        var result:Float = 0.0
        
        switch(functionName) {
            case "sum":
                for eachRow in minRow...maxRow {
                    for eachCol in minCol...maxCol {
                        result += grid![eachRow][eachCol].value
                    }
                }
            case "product":
                for eachRow in minRow...maxRow {
                    for eachCol in minCol...maxCol {
                        result *= grid![eachRow][eachCol].value
                    }
                }
            case "average":
                for eachRow in minRow...maxRow {
                    for eachCol in minCol...maxCol {
                        result += grid![eachRow][eachCol].value
                    }
                }
                let numOfCells = (maxRow-minRow+1)*(maxCol-minCol+1)
                result = result / Float(numOfCells)
            default:
                println("Invalid function")
        }
        setSelectedCellsTo(result)
    } else
    
    //report error
    {
        println("Invalid command")
    }
    
}

func setSelectedCellsTo(value:Float) {
    for eachRow in grid! {
        for eachCell in eachRow {
            if eachCell.selected == true {
                eachCell.value = value
            }
        }
    }
}

func userInput() -> String {
    var userCommand = input("Enter command: ")
    userCommand = userCommand[0..countElements(userCommand)-1]
    if userCommand == "help" {
        helpText()
    } else if userCommand != "quit" {
        identifyCommand(userCommand)
    }
    return userCommand
}

var grid:Array<Array<Cell>>? //initialize array
println("Type help for list of commands")
var userCommand = userInput()
while userCommand != "quit" {
    userCommand = userInput()
}