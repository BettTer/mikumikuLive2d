//
//  Accompany.swift
//  MikuMiku2.0
//
//  Created by XYoung on 2019/4/3.
//  Copyright © 2019 timedomAIn. All rights reserved.
//

import UIKit

class AccompanySystem: NSObject {
    /// 伴奏文件名
    let accompanyFileName: String!
    
    /// 速度
    let tempoBPM: Double!
    
    /// 单位小节内Beat数
    let beatCount: Double!
    
    /// 每个Beat的持续时间
    var beatDuration: Double!
    
    
    /// 循环Beat数
    let cycleBeatCount: Int!
    
    /// 最大录制Beat数
    let maxRecordBeatCount: Int!
    
    /// 配套视效
    let visualEffect: EnumSet.VisualEffects!
    
    /// Live2D模型名
    let live2dKind: EnumSet.Live2DSpecies!
    
    /// 文字起始位置
    var startPosition: CGRect!
    
    /// 文字结束位置
    var endPositionArray: [CGRect]!
    
    init(accompanyFileName: String,
         tempoBPM: Double,
         beatCount: Double,
         cycleBeatCount: Int,
         maxRecordBeatCount: Int,
         visualEffect: EnumSet.VisualEffects,
         live2dKind: EnumSet.Live2DSpecies?) {
        
        self.accompanyFileName = accompanyFileName
        self.tempoBPM = tempoBPM
        self.beatCount = beatCount
        beatDuration = 240 / tempoBPM / beatCount
        
        self.cycleBeatCount = cycleBeatCount
        self.maxRecordBeatCount = maxRecordBeatCount
        
        self.visualEffect = visualEffect
        
        if let existLive2dKind = live2dKind {
            self.live2dKind = existLive2dKind
            
        }else {
            self.live2dKind = .miku
            
        }
        
        super.init()
    }
    
}
