//
//  BaseTableViewController.swift
//  MikuMiku2.0
//
//  Created by XYoung on 2019/4/3.
//  Copyright © 2019 timedomAIn. All rights reserved.
//

import UIKit
import Hero

class BaseTableViewController: UITableViewController {
    
    init(modalAnimationType: HeroDefaultAnimationType) {
        super.init(nibName: nil, bundle: nil)
        
        self.hero.isEnabled = true
        self.hero.modalAnimationType = modalAnimationType
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let naviController = navigationController {
            naviController.isNavigationBarHidden = true
            
        }
    }

}

extension BaseTableViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.hero.modalAnimationType = HeroDefaultAnimationType.autoReverse(presenting: self.hero.modalAnimationType)
        
        super.dismiss(animated: flag, completion: completion)
    }
    
    
    
}

