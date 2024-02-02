//
//  MusicConverter.swift
//  SoundsFilter
//
//  Created by X Young. on 2018/10/12.
//  Copyright © 2018 X Young. All rights reserved.
//

import UIKit

// MARK: - 频率相关
class MusicConverter: NSObject {
    
}

// MARK: - 音符相关
extension MusicConverter {
    /// 给定一个音阶与八度信息 返回音高midi音符数字
    static private func getMidiNote(_ scaleName: String, octaveCount: Int, isRising: Bool?) -> UInt8 {
        var tmpScale: UInt8 = 0
        let tmpOctaveCount = UInt8(octaveCount)
        
        
        switch scaleName {
        case "A":
            tmpScale = 9
            
        case "B":
            tmpScale = 11
            
        case "C":
            tmpScale = 0
            
        case "D":
            tmpScale = 2
            
        case "E":
            tmpScale = 4
            
        case "F":
            tmpScale = 5
            
        case "G":
            tmpScale = 7
            
        default:
            return 0
        }
        
        if isRising != true {
            return tmpScale + (tmpOctaveCount + 2) * 12
            
        }else {
            return tmpScale + (tmpOctaveCount + 2) * 12 + 1
            
        }
        
    }// funcEnd
    
    /// 通过一个音符字符串("C4")获取音高
    static func getMidiNoteFromString(_ noteString: String) -> UInt8 {
        let scale = ToolClass.cutStringWithPlaces(
            noteString, startPlace: 0, endPlace: 1
        )
        
        let octaveCountString = ToolClass.cutStringWithPlaces(
            noteString, startPlace: noteString.count - 1, endPlace: noteString.count
        )
        
        let isRising: Bool = {
            if noteString.range(of: "#") == nil {
                return false
                
            }
            
            return true
            
        }()
        
        return self.getMidiNote(scale, octaveCount: Int(octaveCountString)!, isRising: isRising)
        
    }
    
    /// 通过一个音高数字("38")获取音高字符串
    static func getMidiNoteStringFromNum(_ noteNum: UInt8) -> String {
        let noteNumInt = Int(noteNum)
        
        let pitchNameIndex = noteNumInt % 12
        
        let octaveCount = (noteNumInt - pitchNameIndex) / 12 - 2
        
        
        return StaticData.NoteNamesWithSharps[pitchNameIndex] + String(octaveCount)

    }
    
}
