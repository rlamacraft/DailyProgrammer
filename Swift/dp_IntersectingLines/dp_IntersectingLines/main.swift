//  main.swift
//  dp_IntersectingLines
//
//  Created by Robert Lamacraft on 21/06/2014.
//  Copyright (c) 2014 Robert Lamacraft. All rights reserved.

import Foundation

class Point { //a single point
    var x: Float
    var y: Float
    
    init(x:Float, y:Float){
        self.x = x
        self.y = y
    }
}

class Line {
    var pointOne: Point
    var pointTwo: Point
    var name: String
    var equ: Equation
    
    init(name:String,ax:Float,ay:Float,bx:Float,by:Float){
        self.name = name
        pointOne = Point(x:ax,y:ay)
        pointTwo = Point(x:bx,y:by)
        equ = Equation()
    }
}

class Equation {
    var m: Float? //gradient
    var c: Float? //y offset
    var x: Float? //vertical lines
}

class meetPoint {
    var x: Float
    var y: Float
    var lineA: Line
    var lineB: Line
    init(x:Float,y:Float,lineA:Line,lineB:Line) {
        self.x = x
        self.y = y
        self.lineA = lineA
        self.lineB = lineB
    }
}

var lineA = Line(name:"A",ax:-2.5,ay:0.5,bx:3.5,by:0.5)
var lineB = Line(name:"B",ax:-2.23,ay:99.99,bx:-2.10,by:-56.23)
var lineC = Line(name:"C",ax:-1.23,ay:99.99,bx:-1.10,by:-56.23)
var lineD = Line(name:"D",ax:100.1,ay:1000.34,bx:2000.23,by:2100.23)
var lineE = Line(name:"E",ax:1.5,ay:-1,bx:1.5,by:1.0)
var lineF = Line(name:"F",ax:2.0,ay:2.0,bx:3.0,by:2.0)
var lineG = Line(name:"G",ax:2.5,ay:0.5,bx:2.5,by:2.0)
var data = [lineA,lineB,lineC,lineD,lineE,lineF,lineG]
var intersectionLines: meetPoint[] = []
var finalOutput: meetPoint[] = []

//create equation for each line
for eachLine in data {
    
    //find gradient
    var x1 = eachLine.pointOne.x
    var y1 = eachLine.pointOne.y
    var x2 = eachLine.pointTwo.x
    var y2 = eachLine.pointTwo.y
    
    if x1 == x2 { //x = c type
        eachLine.equ.x = x1
    } else { //y = mx + c type
        eachLine.equ.m = ((y1-y2) / (x1-x2))
        eachLine.equ.c = eachLine.pointOne.y - (eachLine.equ.m! * eachLine.pointOne.x)
    }
}

//compare equations
for i in 0..data.count {
    for j in i+1..data.count {
        let firstLine = data[i]
        let secondLine = data[j]
        if let firstLineX = firstLine.equ.x { //first line if vertical
            if let secondLineX = secondLine.equ.x { //second line is vertical
                if firstLineX == secondLineX { //identical lines
                    intersectionLines.append(meetPoint(x: firstLineX, y: 0, lineA: firstLine, lineB: secondLine))
                }
            } else { //first line vertical, second normal
                let CrossY = (secondLine.equ.m! * firstLine.equ.x!) + secondLine.equ.c!
                let CrossX = firstLine.equ.x!
                intersectionLines.append(meetPoint(x: CrossX, y:CrossY, lineA: firstLine, lineB: secondLine))
            }
        } else {
            if let secondLineX = secondLine.equ.x { //second line is vertical, first is normal
                let CrossY = (firstLine.equ.m! * secondLine.equ.x!) + firstLine.equ.c!
                let CrossX = secondLine.equ.x!
                intersectionLines.append(meetPoint(x: CrossX, y: CrossY, lineA: firstLine, lineB: secondLine))
            } else { //both normal
                if firstLine.equ.m != secondLine.equ.m { // not parallel lines
                    let xCoefficient = firstLine.equ.m! - secondLine.equ.m!
                    let constant = secondLine.equ.c! - firstLine.equ.c!
                    let CrossX = constant / xCoefficient
                    let CrossY = (firstLine.equ.m! * CrossX) + firstLine.equ.c!
                    intersectionLines.append(meetPoint(x: CrossX,y: CrossY,lineA: firstLine,lineB: secondLine))
                }
            }
        }
    }
}

//remove those outside the "boxes"
for eachMeet in intersectionLines {
    var passed: Bool = true
    
    //check meet point is within line one's "box"
    let firstLine = eachMeet.lineA
    var f_leftPoint = (firstLine.pointOne.x < firstLine.pointTwo.x ? firstLine.pointOne.x : firstLine.pointTwo.x)
    var f_rightPoint = (firstLine.pointOne.x > firstLine.pointTwo.x ? firstLine.pointOne.x : firstLine.pointTwo.x)
    var f_bottomPoint = (firstLine.pointOne.y < firstLine.pointTwo.y ? firstLine.pointOne.y : firstLine.pointTwo.y)
    var f_topPoint = (firstLine.pointOne.y > firstLine.pointTwo.y ? firstLine.pointOne.y : firstLine.pointTwo.y)
    if (eachMeet.x < f_leftPoint) || (eachMeet.x > f_rightPoint) {
        passed = false
    }
    if (eachMeet.y < f_bottomPoint || eachMeet.y > f_topPoint) {
        passed = false
    }
    
    let secondLine = eachMeet.lineB
    let s_leftPoint = (secondLine.pointOne.x < secondLine.pointTwo.x ? secondLine.pointOne.x : secondLine.pointTwo.x)
    let s_rightPoint = (secondLine.pointOne.x > secondLine.pointTwo.x ? secondLine.pointOne.x : secondLine.pointTwo.x)
    let s_bottomPoint = (secondLine.pointOne.y < secondLine.pointTwo.y ? secondLine.pointOne.y : secondLine.pointTwo.y)
    let s_topPoint = (secondLine.pointOne.y > secondLine.pointTwo.y ? secondLine.pointOne.y : secondLine.pointTwo.y)
    if (eachMeet.x < s_leftPoint) || (eachMeet.x > s_rightPoint) {
        passed = false
    }
    if (eachMeet.y < s_bottomPoint || eachMeet.y > s_topPoint) {
        passed = false
    }
    
    if passed {
        finalOutput.append(eachMeet)
    }
}


println("Intersecting Lines: ")
for eachMeetPoint in finalOutput {
    println("\(eachMeetPoint.lineA.name) \(eachMeetPoint.lineB.name) @ \(eachMeetPoint.x), \(eachMeetPoint.y)")
}