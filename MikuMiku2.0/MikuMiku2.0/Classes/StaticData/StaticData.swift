//
//  StaticData.swift
//  MikuMiku2.0
//
//  Created by XYoung on 2019/4/2.
//  Copyright © 2019 timedomAIn. All rights reserved.
//

import UIKit

class StaticData: NSObject {
    

}

// MARK: - 伴奏相关 ==============================
extension StaticData {
    /// 伴奏系数组
    static let AccompanySystemArray: [AccompanySystem] = LoadXml.loadAccompanyXmlFile(fileName: "伴奏表.xml")
    
    #warning("=== 当前曲目编号(参考伴奏表) ===")
    static private let currentAccompanySystemIndex = 3
    
    static func currentAccompanySystem() -> AccompanySystem {
        return AccompanySystemArray[currentAccompanySystemIndex]
        
    }
    
}

// MARK: - 音乐键相关 ==============================
extension StaticData {
    /// 音乐键对应Pitch数组
    static let MusicKeyPitchArray: [String] = LoadXml.loadMusicKeyPitchInfo("音乐键对应Pitch.xml")
    
    /// 音乐键InfoArray
    static let MusicKeyInfoArray: [MusicKeyInfo] = {
        var tmpArray: [MusicKeyInfo]  = []
        
        let w = ToolClass.getScreenWidth()
        let h = ToolClass.getScreenHeight() / CGFloat(MusicKeyPitchArray.count)
        for index in 0 ..< MusicKeyPitchArray.count {
            let model = MusicKeyInfo.init(mainKey: index, pitch: MusicKeyPitchArray[index])
            
            model.frame = CGRect.init(x: 0,
                                      y: CGFloat(MusicKeyPitchArray.count - 1 - index) * h,
                                      width: w,
                                      height: h)
            
            tmpArray.append(model)
            
        }
        
        return tmpArray
        
    }()
    
}

// MARK: - 绝对静态
extension StaticData {
    /// 音阶表
    static let NoteNamesWithSharps: [String] = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    
    /// 十二大调音阶序列
    static let MajorScaleDict: [String: [String]] = [
        "C": ["C", "D", "E", "F", "G", "A", "B"],
        "C#": ["C#", "D#", "F", "F#", "G#", "A#", "C"],
        "D": ["D", "E", "F#", "G", "A", "B", "C#"],
        "D#": ["D#", "F", "G", "G#", "A#", "C", "D"],
        "E": ["E", "F#", "G#", "A", "B", "C#", "D#"],
        "F": ["F", "G", "A", "A#", "C", "D", "E"],
        "F#": ["F#", "G#", "A#", "B", "C#", "D#", "F"],
        "G": ["G", "A", "B", "C", "D", "E", "F#"],
        "G#": ["G#", "A#", "C", "C#", "D#", "F", "G"],
        "A": ["A", "B", "C#", "D", "E", "F#", "G#"],
        "A#": ["A#", "C", "D", "D#", "F", "G", "A"],
        "B": ["B", "C#", "D#", "E", "F#", "G#", "A#"]
    ]
    
    /// 所有循环韵母数组
    static let VowelArray: [String] = [
        "a", "o", "e", "i", "u", "v",
        "ai", "ei", "ui",
        "ao", "ou",
        "iu", "ie",
        "ve", "er",
        "an", "en", "in", "un", "vn",
        "ang", "ong", "eng", "ing",
        ]
    
}
