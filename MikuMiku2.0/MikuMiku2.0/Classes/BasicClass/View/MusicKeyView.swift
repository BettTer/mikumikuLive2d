//
//  MusicKeyView.swift
//  MikuMiku2.0
//
//  Created by XYoung on 2019/4/2.
//  Copyright © 2019 timedomAIn. All rights reserved.
//

import UIKit

class MusicKeyView: UIView {
    /// 主键
    let mainKey: Int!
    
    /// 音高
    let pitch: String!
    
    var currentStatus: MusicKeyStatus = .Unpressed {
        didSet {
            if currentStatus == .Pressed {
                self.makeSound()
                
            }else {
                self.stopMakingSound()
                
            }
            
            
        }
    }
    
    init(model: MusicKeyInfo) {
        self.mainKey = model.mainKey
        self.pitch = model.pitch
        
        super.init(frame: model.frame)
        self.backgroundColor = UIColor.white
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - 两种状态 ==============================
extension MusicKeyView {
    /// 发出声音
    func makeSound() -> Void {
        DispatchQueue.main.async {
            self.backgroundColor = UIColor.flatSkyBlue
            
        }

    }
    
    /// 停止发声
    func stopMakingSound() -> Void {
        DispatchQueue.main.async {
            self.backgroundColor = UIColor.white
            
        }
        

    }
    
}

// MARK: - 模型 ==============================
extension MusicKeyView {
    /// 按钮状态(按下 / 抬起 ...)
    public enum MusicKeyStatus: Int {
        case Pressed = 0
        case Unpressed = 1
    }
    
}
