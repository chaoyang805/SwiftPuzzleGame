//
//  File.swift
//  SwiftPuzzleGame
//
//  Created by chaoyang805 on 16/1/6.
//  Copyright © 2016年 com.jikexueyuan. All rights reserved.
//

import Foundation
class CardsMap<T> {
    let columns:Int
    let rows:Int
    
    var array:Array<T?>
    init(Rows rows:Int,Columns columns:Int){
        self.rows = rows
        self.columns = columns
        array = Array<T?>(count: self.columns * self.rows,repeatedValue: nil)
    }
    
    subscript (row:Int,column:Int)-> T? {
        get {
            return array[row * self.columns + column]
        }
        
        set(newValue) {
            array[row * self.columns + column] = newValue
        }
    }
    
}