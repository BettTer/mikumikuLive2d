//
//  Note.swift
//  MikuMiku2.0
//
//  Created by XYoung on 2019/4/2.
//  Copyright © 2019 timedomAIn. All rights reserved.
//

import UIKit

class NoteInfoModel: NSObject {
    var pinyin = "deng"
    
    let pitch: String!
    var midiNum: UInt8!

    init(pitch: String) {
        self.pitch = pitch
        
        super.init()
        
        self.midiNum = MusicConverter.getMidiNoteFromString(pitch)
    }
}

class AbstractTouch: NSObject {
    /// 键的索引
    let keyIndex: Int!
    
    /// 是否属于窗口
    let isBelongToWindow: Bool!
    
    /// 赋予ID
    let ID = String.random(25)
    
    /// true: 触发, false: 停止, nil: 初始化
    var isTriggered: Bool = true
    
    var playChannel: PlayChannel? = nil
    
    /// 已经播放Beat次数
    private var alreadyPlayedBeat: Int = 0
    
    init(keyIndex: Int, isBelongToWindow: Bool) {
        self.keyIndex = keyIndex
        self.isBelongToWindow = isBelongToWindow
        
        super.init()
    }
    
    func addAlreadyPlayedBeat() -> Void {
        alreadyPlayedBeat += 1
    }
    
    func getAlreadyPlayedBeat() -> Int {
        return alreadyPlayedBeat
    }
    
    
    enum PlayChannel: String {
        /// 通过量化
        case Metronome = "Metronome"
        
        /// 通过窗口
        case Window = "Window"
    }
    
    
}
