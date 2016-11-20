//
//  BombAreaModel.swift
//  GZMIneSweeper
//
//  Created by armada on 2016/11/19.
//  Copyright © 2016年 com.zlot.gz. All rights reserved.
//

import UIKit

struct Point {
    var value: Int //负责表示周围雷数
    var hidden: Bool //表示是否隐藏
}

class BombAreaModel: NSObject {
    
    var bombArr: [Point] //雷区
    var bombTotals: Int //雷数
    var rows: Int //行数
    var columns: Int //列数
    var level: Int //游戏等级
    
    //下标脚本
    subscript(row: Int, column: Int)->Point{
        get {
            return bombArr[row*self.rows+column]
        }
    
        set {
            bombArr[row*self.rows+column] = newValue
        }
    }
    
    init(level:Int) {
        
        self.level = level
        self.bombTotals = level*10
        self.rows  = 6+level*3
        self.columns = self.rows;
        self.bombArr = [Point].init(repeating: Point.init(value: 0, hidden: true), count: self.rows*self.columns)
        super.init()
        self.setBombInLocation() //设置雷区
    }
    
    //设置雷区
    func setBombInLocation() {
        
        for _ in 0...self.bombTotals {
            
            var row = 0
            var col = 0
            repeat {
                row = Int(arc4random_uniform(UInt32(self.rows)))
                col = Int(arc4random_uniform(UInt32(self.columns)))
            }while self[row,col].value < 0
            
            self[row,col].value = -100
            
            //左
            if col-1 >= 0 {
                for i in row-1...row + 1{
                    if i<0 || i>=self.rows{
                        continue
                    }
                    
                    self[i,col-1].value += 1
                }
            }
            
            //上
            if row-1 >= 0{
                self[row-1,col].value += 1
            }
            
            
            //右
            if col+1<self.columns {
                for i in row-1...row+1{
                    if i < 0 || i >= self.rows{
                        continue
                    }
                    self[i,col+1].value += 1
                }
            }
            
            //下
            if row+1<self.rows {
                self[row+1,col].value += 1
            }
        }
        

    }
}


