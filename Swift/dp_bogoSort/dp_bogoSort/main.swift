//
//  main.swift
//  dp_bogoSort
//
//  Created by Robert Lamacraft on 12/08/2014.
//  Copyright (c) 2014 Robert Lamacraft. All rights reserved.
//

import Foundation

extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = advance(self.startIndex, r.startIndex)
            let endIndex = advance(startIndex, r.endIndex - r.startIndex)
            
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
}

func input(desc:String) -> String {
    print(desc)
    let keyboard = NSFileHandle.fileHandleWithStandardInput()
    let inputData = keyboard.availableData
    return NSString(data: inputData, encoding:NSUTF8StringEncoding)
}

func bogoSort(inputString:String) -> String {
    
    //convert string to array
    var inputArray: Character[] = []
    for eachChar in inputString {
        inputArray.append(eachChar)
    }
    
    //randomly arrange into new array
    var outputArray: Character[] = []
    while countElements(inputArray) > 0 {
        let remainingUnsorted = countElements(inputArray)
        let randNum = Int(arc4random_uniform(UInt32(remainingUnsorted)))
        outputArray.append(inputArray[randNum])
        inputArray.removeAtIndex(randNum)
    }
    
    //convert back to string
    var outputString = ""
    for eachChar in outputArray {
        outputString += eachChar
    }
    
    return outputString
}

var iterations = 0

let inputString = input("> ")
var beginString = ""
var endString = ""

//split input
var lowerBound = 0
var upperBound = 0
var i = 0
var splitIndex = 0

for eachChar in inputString {
    if eachChar == "\"" {
        lowerBound = upperBound + 1
        upperBound = i
        if splitIndex <= 1 {
            beginString = inputString[lowerBound..upperBound]
        } else {
            endString = inputString[lowerBound..upperBound]
        }
        splitIndex++
    }
    i++
}

//run algorithm
var algString = beginString

while algString != endString {
    algString = bogoSort(algString)
    iterations++
}

println("\(iterations) iterations")