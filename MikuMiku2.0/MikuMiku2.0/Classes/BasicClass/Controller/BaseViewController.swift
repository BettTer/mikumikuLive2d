//
//  BaseViewController.swift
//  MikuMiku2.0
//
//  Created by XYoung on 2019/4/3.
//  Copyright © 2019 timedomAIn. All rights reserved.
//

import UIKit
import Hero

class BaseViewController: UIViewController {
    /// 模态跳转动画类型
    private var modalAnimationType: HeroDefaultAnimationType?
    
    init(modalAnimationType: HeroDefaultAnimationType?) {
        super.init(nibName: nil, bundle: nil)
        
        if let beingModalAnimationType = modalAnimationType {
            self.modalAnimationType = beingModalAnimationType
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hero.isEnabled = true
    }
    
}
