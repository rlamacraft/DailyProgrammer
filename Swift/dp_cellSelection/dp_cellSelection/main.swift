//
//  main.swift
//  dp_cellSelection
//
//  Created by Robert Lamacraft on 19/08/2014.
//  Copyright (c) 2014 Robert Lamacraft. All rights reserved.
//

import Foundation

func input(text:String) -> String {
    print(text)
    var keyboard = NSFileHandle.fileHandleWithStandardInput()
    var inputData = keyboard.availableData
    return NSString(data: inputData, encoding:NSUTF8StringEncoding)
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
    }
}

func identifyEquation(equation:String) {
    let numericRegex = "[0-9]*\\.?[0-9]+"
    let referenceRegex = "[A-Z]+[0-9]+"
    let mathRegex = "(" + numericRegex + "|" + referenceRegex + ")[+,/,-,*,^](" + numericRegex + "|" + referenceRegex + ")"
    //let mathRegex = "(([A-Z)+[0-9]+)|([0-9]*\\.?[0-9]+))[+,/,-,*,^](([A-Z)+[0-9]+)|([0-9]*\\.?[0-9]+))"
    
    let numericMatch = equation.rangeOfString(numericRegex+"$", options: .RegularExpressionSearch)
    if !numericMatch.isEmpty {
        setSelectedCellsTo(NSString(string: equation).doubleValue)
    }
    
    let referenceMatch = equation.rangeOfString(referenceRegex+"$", options: .RegularExpressionSearch)
    if !referenceMatch.isEmpty {
        let tmpCell = Cell(desc:equation)
        if tmpCell.rowI > countElements(grid!) || tmpCell.colI > countElements(grid![0]) {
            setSelectedCellsTo(0)
        } else {
            setSelectedCellsTo(grid![tmpCell.colI][tmpCell.rowI].value)
        }
    }
    
    let mathMatch = equation.rangeOfString(mathRegex+"$", options: .RegularExpressionSearch)
    if !mathMatch.isEmpty {
        println("we have an math expression")
    }
}

func setSelectedCellsTo(value:Double) {
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
printGrid()
println("*****")
while userCommand != "quit" {
    userCommand = userInput()
    printGrid()
    println("*****")
}