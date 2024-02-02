//
//  MikuButton.swift
//  MikuMiku2.0
//
//  Created by XYoung on 2019/4/1.
//  Copyright © 2019 timedomAIn. All rights reserved.
//

import UIKit

class MikuButton: UIButton {
    /// 点击时间
    private var clickAction: (() -> ()) = {}
    
    /// 点击状态
    private var clickControlEvents: UIControl.Event!
    
    /// 大小变化
    private let scale: CGFloat = 1.25
    
    private var originalFrame: CGRect!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.originalFrame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func addTargetWithIconAction(_ target: Any?, clickAction: @escaping () -> (), for controlEvents: UIControl.Event) -> Void {
        self.clickAction = clickAction
        self.clickControlEvents = controlEvents
        
        switch controlEvents {
        case .touchDown:
            self.addTarget(target, action: #selector(self.touchDownButtonAction), for: .touchDown)
            self.addTarget(target, action: #selector(self.touchUpInsideButtonAction), for: .touchUpInside)
            
        case .touchUpInside:
            self.addTarget(target, action: #selector(self.touchDownButtonAction), for: .touchDown)
            self.addTarget(target, action: #selector(self.touchUpInsideButtonAction), for: .touchUpInside)
            
        default:
            self.addTarget(target, action: #selector(self.originalAction), for: controlEvents)
            self.addTarget(target, action: #selector(self.touchDownButtonAction), for: .touchDown)
            self.addTarget(target, action: #selector(self.touchUpInsideButtonAction), for: .touchUpInside)
            
        }
    }
    
    @objc func originalAction() -> Void {
        clickAction()
        
    }
    
    /// 按下的时候
    @objc func touchDownButtonAction() -> Void {
        UIView.animate(
            withDuration: 0.125,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0,
            options: [
                .layoutSubviews,            // * 子视图一起动
                .curveEaseIn,               // * 动画逐渐变慢
                .allowAnimatedContent       // * 动画过程中允许交互
            ],
            animations: {
                self.frame = CGRect.init(x: self.getX() - (self.scale - 1) * self.getWidth(),
                                         y: self.getY() - (self.scale - 1) * self.getHeight(),
                                         width: self.getWidth() * self.scale,
                                         height: self.getHeight() * self.scale)
                
        }) { (finished) in
            if self.clickControlEvents == .touchDown {
                self.clickAction()
                
            }
            
        }
        
    }
    
    /// 松手的时候
    @objc func touchUpInsideButtonAction() -> Void {
        UIView.animate(
            withDuration: 0.125,
            delay: 0,
            usingSpringWithDamping: 0,
            initialSpringVelocity: 0,
            options: [
                .layoutSubviews,            // * 子视图一起动
                .curveEaseIn,               // * 动画逐渐变慢
            ],
            animations: {
                self.frame = self.originalFrame
                
        }) { (finished) in
            if self.clickControlEvents == .touchUpInside {
                self.clickAction()
                
            }
            
        }
        
    }


}
