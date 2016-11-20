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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.automaticallyAdjustsScrollViewInsets = false
        self.prepareForLayout()
    }
    
    private func prepareForLayout() {
        
        self.bgImgView = UIImageView.init(image: UIImage.init(named: "background3")!)
        self.bgImgView.frame = self.view.bounds
        self.view.addSubview(self.bgImgView)
        
        self.bombModel = BombAreaModel.init(level: 3)
        self.bombView = BombAreaView.init(frame: CGRect.init(x: 0, y: 0, width: 350, height: 350), bombAreaModel: self.bombModel)
        self.bombView.center = self.view.center
        self.bombView.delegate = self
        self.view.addSubview(self.bombView)
        
        let restartBtn =  UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        restartBtn.center.x = self.view.center.x
        restartBtn.center.y = 100
        restartBtn.setImage(UIImage.init(named: "restart.jpg"), for: UIControlState.normal)
        restartBtn.addTarget(self, action:#selector(restart), for: UIControlEvents.touchUpInside)
        restartBtn.layer.cornerRadius = restartBtn.frame.size.width/2
        restartBtn.layer.masksToBounds = true
        self.view.addSubview(restartBtn)
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
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

