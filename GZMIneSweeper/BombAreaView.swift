//
//  BombAreaView.swift
//  GZMIneSweeper
//
//  Created by armada on 2016/11/19.
//  Copyright © 2016年 com.zlot.gz. All rights reserved.
//

import UIKit

class BombAreaView: UIView {
    
    var model: BombAreaModel
    
    var btnWidth:CGFloat {
        get {
            return self.frame.size.width/CGFloat(model.columns)
        }
    }
    
    var btnHeight:CGFloat {
        get {
            return self.frame.size.height/CGFloat(model.rows)
        }
    }
    
    weak var delegate: ViewController!
    
    init(frame: CGRect, bombAreaModel: BombAreaModel) {
        self.model = bombAreaModel
        super.init(frame: frame)
        self.createBombAreaBtns()
    }
    
    private func createBombAreaBtns() {
        
        for j in 0..<self.model.rows {
            
            for i in 0..<self.model.columns {
                
                let btn = UIButton(frame: CGRect.init(x:CGFloat(i)*btnWidth, y: CGFloat(j)*btnHeight, width: self.btnWidth, height: self.btnHeight))
                btn.tag = 100 + j*self.model.columns+i
                btn.setImage(UIImage.init(named: "unknown.png"), for: UIControlState.normal)
                
                switch self.model[j,i].value {
                
                    case 0: btn.setImage(UIImage.init(named: "blank.png"), for: UIControlState.disabled)
                    case 1: btn.setImage(UIImage.init(named: "1.png"), for: UIControlState.disabled)
                    case 2: btn.setImage(UIImage.init(named: "2.png"), for: UIControlState.disabled)
                    case 3: btn.setImage(UIImage.init(named: "3.png"), for: UIControlState.disabled)
                    case 4: btn.setImage(UIImage.init(named: "4.png"), for: UIControlState.disabled)
                    case 5: btn.setImage(UIImage.init(named: "5.png"), for: UIControlState.disabled)
                    case 6: btn.setImage(UIImage.init(named: "6.png"), for: UIControlState.disabled)
                    case 7: btn.setImage(UIImage.init(named: "7.png"), for: UIControlState.disabled)
                    case 8: btn.setImage(UIImage.init(named: "8.png"), for: UIControlState.disabled)
                    default: btn.setImage(UIImage.init(named: "mine.png"), for: UIControlState.disabled)
                }
                btn.addTarget(self, action: #selector(BombAreaView.btnClickAction), for: UIControlEvents.touchUpInside)
                self.addSubview(btn)
            }
        }
    }
    
    //点击触发事件
    func btnClickAction(sender:UIButton) {
        
        let clickIndex = sender.tag - 100
        
        let col = clickIndex%self.model.columns
        let row = clickIndex/self.model.columns
        
        stepOn(col: col, row: row)
        
    }
    
    func stepOn(col:Int,row:Int)->Void{
        //传入的row col表示要踩的点
        
        //如果该位置不是隐藏状态,本函数立即返回fale
        if self.model[row,col].hidden == false {
            return
        }
        
        if self.model[row,col].value < 0{
            //如果踩中雷,全部翻开,即isHidden设置为假
            
            let tag = 100 + row*self.model.columns + col
            let btn = self.viewWithTag(tag) as! UIButton
            btn.setImage(UIImage.init(named: "selectedmine"), for: UIControlState.disabled)
            
            for i in 0...self.model.rows-1{
                for j in 0...self.model.columns-1{
                    let tag = 100 + i*self.model.columns + j
                    let btn = self.viewWithTag(tag) as! UIButton
                    btn.isEnabled = false
                }
            }
            
            let alertController = UIAlertController.init(title: "很遗憾", message: "你输了,请再接再厉", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil);
            alertController.addAction(alertAction)
            
            if let timer = self.delegate.timer {
                timer.invalidate()
                self.delegate.timer = nil
            }
            self.delegate.present(alertController, animated: true, completion: nil)
            
        }else if self.model[row,col].value > 0{
            
            self.model[row,col].hidden = false
            let tag = 100 + row*self.model.columns + col
            let btn = self.viewWithTag(tag) as! UIButton
            btn.isEnabled = false
            checkConditionOfWin()
            
        }else{//如果等于0,要把一圈反过来
    
            openArea(inRow:row,inCol: col)
        }
    }
    
    private func openArea(inRow row:Int, inCol col:Int){
        
        self.model[row,col].hidden = false
        let tag = 100 + row*self.model.columns + col
        let btn = self.viewWithTag(tag) as! UIButton
        btn.isEnabled = false
        
        if col-1 >= 0 {
            for i in row-1...row + 1{
                if i<0 || i>=self.model.rows{
                    continue
                }else if self.model[i,col-1].value == 0 && self.model[i,col-1].hidden == true{
                    self.model[i,col-1].hidden = false
                    
                    let tag = 100 + i*self.model.columns + (col-1)
                    let btn = self.viewWithTag(tag) as! UIButton
                    btn.isEnabled = false
                    
                    openArea(inRow:i,inCol:col-1)
                }else if self.model[i,col-1].value>0 {
                    self.model[i,col-1].hidden = false
                    
                    let tag = 100 + i*self.model.columns + (col-1)
                    let btn = self.viewWithTag(tag) as! UIButton
                    btn.isEnabled = false
                }
                
            }
        }
        
        if row-1>=0 {
            if self.model[row-1,col].value == 0 && self.model[row-1,col].hidden == true{
                self.model[row-1,col].hidden = false
                
                let tag = 100 + (row-1)*self.model.columns + (col)
                let btn = self.viewWithTag(tag) as! UIButton
                btn.isEnabled = false
                
                openArea(inRow:row-1,inCol:col)
            }else if self.model[row-1,col].value > 0{
                self.model[row-1,col].hidden = false
                
                let tag = 100 + (row-1)*self.model.columns + (col)
                let btn = self.viewWithTag(tag) as! UIButton
                btn.isEnabled = false
            }
        }
        
        if col+1<self.model.columns{
            for i in row-1...row+1{
                if i<0 || i>=self.model.rows{
                    continue
                }else if self.model[i,col+1].value == 0 && self.model[i,col+1].hidden == true{
                    self.model[i,col+1].hidden = false
                    btn.isEnabled = false
                    
                    let tag = 100 + i*self.model.columns + (col+1)
                    let btn = self.viewWithTag(tag) as! UIButton
                    btn.isEnabled = false
                    
                    openArea(inRow:i,inCol:col+1)
                }else if self.model[i,col+1].value>0 {
                    self.model[i,col+1].hidden = false
                    
                    let tag = 100 + i*self.model.columns + (col+1)
                    let btn = self.viewWithTag(tag) as! UIButton
                    btn.isEnabled = false
                }
                
            }
        }
        
        if row+1<self.model.rows {
            if self.model[row+1,col].value == 0 && self.model[row+1,col].hidden == true{
                self.model[row+1,col].hidden = false
                
                let tag = 100 + (row+1)*self.model.columns + (col)
                let btn = self.viewWithTag(tag) as! UIButton
                btn.isEnabled = false
                
                openArea(inRow:row+1,inCol:col)
            }else if self.model[row+1,col].value > 0{
                self.model[row+1,col].hidden = false
                
                let tag = 100 + (row+1)*self.model.columns + (col)
                let btn = self.viewWithTag(tag) as! UIButton
                btn.isEnabled = false
            }
        }
        
        checkConditionOfWin()
    }

    func checkConditionOfWin() -> Void{
        
        var leftHidden = 0
        for point in self.model.bombArr {
            
            if(point.hidden){
                leftHidden += 1
            }
        }

        if leftHidden == self.model.bombTotals {
            let alert = UIAlertController.init(title: "恭喜你", message: "你赢了", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(alertAction)
            self.delegate.present(alert, animated: true, completion: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
