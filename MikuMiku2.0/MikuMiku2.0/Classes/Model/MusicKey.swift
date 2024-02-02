//
//  MusicKey.swift
//  MikuMiku2.0
//
//  Created by XYoung on 2019/4/2.
//  Copyright © 2019 timedomAIn. All rights reserved.
//

import UIKit

// MARK: - 单个音乐键关联信息
class MusicKeyInfo: NSObject {
    /// 主键
    let mainKey: Int!
    
    /// 音高
    let pitch: String!
    
    /// frame
    var frame: CGRect = CGRect.init(x: 0, y: 0, width: 0, height: 0)
    
    init(mainKey: Int, pitch: String) {
        self.mainKey = mainKey
        self.pitch = pitch
        
        super.init()
    }
    
}
