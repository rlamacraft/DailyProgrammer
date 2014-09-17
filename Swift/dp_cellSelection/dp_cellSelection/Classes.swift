//
//  Classes.swift
//  dp_cellSelection
//
//  Created by Robert Lamacraft on 19/08/2014.
//  Copyright (c) 2014 Robert Lamacraft. All rights reserved.
//

import Foundation

class Cell {
    var value: Double = 0.0
    var selected:Bool = false
    var row:Int
    var rowI:Int
    var col:String
    var colI:Int
    var desc:String
    
    init(x:Int,y:Int) {
        rowI = y
        row = y + 1
        colI = x
        col = decToBase26(x + 1)
        desc = "\(col)\(row)"
    }
    
    init(desc:String) {
        self.desc = desc
        var index = 0
        for eachChar in desc {
            if !(eachChar + "").toInt() {
                index++
            }
        }
        
        col = desc[0..index]
        if let checkedDesc = desc[index..countElements(desc)].toInt() {
            row = checkedDesc
        } else {
            println("desc = '\(desc[index..countElements(desc)])'")
            row = 0
        }
        
        colI = base26ToDec(col) - 1
        rowI = row - 1
    }
}