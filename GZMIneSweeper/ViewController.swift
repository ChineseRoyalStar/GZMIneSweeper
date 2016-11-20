//
//  ViewController.swift
//  GZMIneSweeper
//
//  Created by armada on 2016/11/19.
//  Copyright © 2016年 com.zlot.gz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var bombModel: BombAreaModel!
    
    private var bombView: BombAreaView!
    
    private var bgImgView: UIImageView! //背景图
    
    private var timerLabel: UILabel!
    
    var timer: Timer! //定时器
    
    private var currentCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.automaticallyAdjustsScrollViewInsets = false
        self.prepareForLayout()
    }
    
    private func prepareForLayout() {
        //创建背景图
        self.bgImgView = UIImageView.init(image: UIImage.init(named: "background3")!)
        self.bgImgView.frame = self.view.bounds
        self.view.addSubview(self.bgImgView)
        
        //生成雷区
        self.bombModel = BombAreaModel.init(level: 3)
        self.bombView = BombAreaView.init(frame: CGRect.init(x: 0, y: 0, width: 350, height: 350), bombAreaModel: self.bombModel)
        self.bombView.center = self.view.center
        self.bombView.delegate = self
        self.view.addSubview(self.bombView)
        
        //创建计时器
        
        self.timerLabel = UILabel.init(frame:CGRect.init(x: 0, y: 0, width: 70, height: 40))
        self.timerLabel.backgroundColor = UIColor.black
        self.timerLabel.center.x = self.view.center.x-100
        self.timerLabel.center.y = 100
        self.timerLabel.textColor = UIColor.red
        self.timerLabel.font = UIFont.init(name: "LcdD", size: 35)
        self.timerLabel.text = "000"
        self.timerLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(self.timerLabel)
        
        //创建重新开始按钮
        let restartBtn =  UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        restartBtn.center.x = self.view.center.x
        restartBtn.center.y = 100
        restartBtn.setImage(UIImage.init(named: "restart.jpg"), for: UIControlState.normal)
        restartBtn.addTarget(self, action:#selector(restart), for: UIControlEvents.touchUpInside)
        restartBtn.layer.cornerRadius = restartBtn.frame.size.width/2
        restartBtn.layer.masksToBounds = true
        self.view.addSubview(restartBtn)
        
        //创建定时器,并启动
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCount), userInfo: nil, repeats: true)
    }
    
    func timerCount() {
        self.currentCount += 1
        self.timerLabel.text = String(format: "%.3d", self.currentCount)
    }
    
    @objc private func restart() {
        
        self.bombView.removeFromSuperview()
        self.bombView = nil
        self.bombModel = nil
        
        self.bombModel = BombAreaModel.init(level: 3)
        self.bombView = BombAreaView.init(frame: CGRect.init(x: 0, y: 0, width: 350, height: 350), bombAreaModel: self.bombModel)
        self.bombView.center = self.view.center
        self.bombView.delegate = self
        self.view.addSubview(self.bombView)
        
        self.currentCount = 0
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCount), userInfo: nil, repeats: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

