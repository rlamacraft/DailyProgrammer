//Simple program that calculates the (x,y) coorindates at
//which two lines, described as a pair of linear equations,
//intersect; implemented through algebraic manipulation
//Equations are defined on lines 67 and 68.

import Foundation

extension String {
    //returns a substring of self
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = advance(self.startIndex, r.startIndex)
            let endIndex = advance(startIndex, r.endIndex - r.startIndex)
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
    
    //retruns a single char of self
    subscript (index:Int) -> Character {
        let stringRet = self[index..index]
        return stringRet[stringRet.startIndex]
    }
    
    //returns index of first instance of a given char in self
    func indexOf(char:Character) -> Int {
        for (var i=0;i<countElements(self);i++) {
            if self[i] == char {
                return i
            }
        }
        return countElements(self)
    }
}

class Equation {
    //equation of form y=mx+c
    var m: Float
    var c: Float
    init(xCoefficient:Float,constant:Float) {
        m = xCoefficient
        c = constant
    }
}

func disectEquation(input:String) -> Equation {
    let indexOfX = input.indexOf("x")
    let m = NSString(string: input[2..indexOfX]).floatValue
    let c = NSString(string: input[indexOfX+1..countElements(input)]).floatValue
    
    let ret = Equation(xCoefficient:m,constant:c)
    return ret
}

func findX(firstEquation:Equation,secondEquation:Equation) -> Float {
    //uses algebraic manipulation to find the x coordinate
    let m = firstEquation.m - secondEquation.m
    let c = firstEquation.c - secondEquation.c
    let x = (c * -1 ) / m
    return x
}

func findY(equation:Equation,x:Float) -> Float {
    //uses algebraic manipulation to find the y coordinate
    return equation.m * x + equation.c
}

let firstInput = "y=0.5x+1.3"
let secondInput = "y=-1.4x-0.2"

let numericRegex = "(\\+|-)?[0-9]*\\.?[0-9]+"
let regex = "y=" + numericRegex + "x(" + numericRegex + ")?$"

if firstInput.rangeOfString(regex, options: .RegularExpressionSearch) && secondInput.rangeOfString(regex, options: .RegularExpressionSearch)
{
    //equations are valid
    let firstEquation = disectEquation(firstInput)
    let secondEquation = disectEquation(secondInput)
    let x:Float = findX(firstEquation,secondEquation)
    let y:Float = findY(firstEquation,x)
    let xOutput = String(format: "%.4f",x)
    let yOutput = String(format: "%.4f",y)
    print("(\(xOutput),\(yOutput))")
} else {
    //equations are invalid
    println("equations are invalid")
}
