//
//  LoopComponent.swift
//  MikuMiku2.0
//
//  Created by XYoung on 2019/4/2.
//  Copyright © 2019 timedomAIn. All rights reserved.
//

import UIKit

class LoopComponent: NSObject {
    /// 循环事件
    private var loopAction: () -> Void = {}
    
    /// 循环间隔
    private var duration: Double!
    
    /// 循环次数
    private var time = 0
    
    @objc public init(every dur: Double, action: @escaping () -> Void) {
        duration = dur
        loopAction = action
        super.init()
        self.update()
    }
    
    /// 获取次数
    func getTimeCount() -> Int {
        return time
        
    }
    
    /// Callback function
    @objc public func update() {
        self.loopAction()
        time += 1
        self.perform(#selector(update),
                     with: nil,
                     afterDelay: duration,
                     inModes: [RunLoop.Mode.common])
    }
    
    
}
