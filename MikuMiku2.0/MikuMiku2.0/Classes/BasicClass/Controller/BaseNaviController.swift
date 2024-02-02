//
//  BaseNaviController.swift
//  MikuMiku2.0
//
//  Created by XYoung on 2019/4/5.
//  Copyright © 2019 timedomAIn. All rights reserved.
//

import UIKit
import Hero

class BaseNaviController: UINavigationController {
    /// 默认push动画类型
    var defultPushAniType: HeroDefaultAnimationType = .pageIn(direction: .left)
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        self.hero.isEnabled = true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.hero.isEnabled = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.hero.navigationAnimationType = defultPushAniType
        
        super.pushViewController(viewController, animated: animated)
        
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        self.hero.navigationAnimationType = HeroDefaultAnimationType.autoReverse(presenting: defultPushAniType)
        
        return super.popViewController(animated: animated)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        self.hero.navigationAnimationType = .zoomOut
        
        return popToRootViewController(animated: animated)
    }
    
    

}
