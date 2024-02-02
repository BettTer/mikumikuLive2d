//
//  LoadXml.swift
//  MikuMiku2.0
//
//  Created by XYoung on 2019/4/2.
//  Copyright © 2019 timedomAIn. All rights reserved.
//

import UIKit
import SwiftyXMLParser

class LoadXml: NSObject {
    /// 提取音乐键对应Pitch信息
    static func loadMusicKeyPitchInfo(_ XmlFileName: String) -> [String] {
        let xmlFilePath = Bundle.main.path(forResource: XmlFileName, ofType: nil)
        if xmlFilePath == nil {
            return []
            
        }
        
        let xml = try! XML.parse(Data.init(contentsOf: URL.init(fileURLWithPath: xmlFilePath!)))
        
        // * 将所有的行提取出来
        var rowElementArray: [XML.Element] = []
        
        for element in xml.element!.childElements.first!.childElements {
            if element.name == "Worksheet" {
                
                for childElement in element.childElements[0].childElements {
                    
                    if childElement.name == "Row" {
                        
                        rowElementArray.append(childElement)
                        
                    }
                }
            }
        }
        
        var resultArray: [String] = []
        
        for cell in rowElementArray.first!.childElements {
            if let pitchElements = cell.childElements.first {
                resultArray.append(pitchElements.text!)
                
            }
            
            
            
        }
        
        return resultArray
    }
    
    /// 读取"伴奏表"并生成模型
    static func loadAccompanyXmlFile(fileName: String) -> [AccompanySystem] {
        let xmlFilePath = Bundle.main.path(forResource: fileName, ofType: nil)
        if xmlFilePath == nil {
            return []
            
        }
        
        let xml = try! XML.parse(Data.init(contentsOf: URL.init(fileURLWithPath: xmlFilePath!)))
        
        // * 将所有的行提取出来
        var rowElementArray: [XML.Element] = []
        
        for element in xml.element!.childElements.first!.childElements {
            if element.name == "Worksheet" {
                
                for childElement in element.childElements[0].childElements {
                    
                    if childElement.name == "Row" {
                        
                        rowElementArray.append(childElement)
                        
                    }
                }
            }
        }
        
        var tmpArray: [AccompanySystem] = []
        
        for rowElement in rowElementArray {
            if rowElement.childElements.count <= 2 {
                break
                
            }
            
            let accompanyFileNameColumnIndex = AccompanyInfoColumnIndexDict[.accompanyFileName]!
            let tempoBPMColumnIndex = AccompanyInfoColumnIndexDict[.tempoBPM]!
            let beatCountColumnIndex = AccompanyInfoColumnIndexDict[.beatCount]!
            let cycleBeatCountColumnIndex = AccompanyInfoColumnIndexDict[.cycleBeatCount]!
            let maxRecordBeatCountColumnIndex = AccompanyInfoColumnIndexDict[.maxRecordBeatCount]!
            let visualEffectColumnIndex = AccompanyInfoColumnIndexDict[.visualEffect]!
            
            if rowElement.childElements[accompanyFileNameColumnIndex].childElements.count == 0 {
                break
                
            }
            
            let model = AccompanySystem.init(
                accompanyFileName: rowElement.childElements[accompanyFileNameColumnIndex].childElements[0].text!,
                tempoBPM: Double(rowElement.childElements[tempoBPMColumnIndex].childElements[0].text!)!,
                beatCount: Double(rowElement.childElements[beatCountColumnIndex].childElements[0].text!)!,
                cycleBeatCount: Int(rowElement.childElements[cycleBeatCountColumnIndex].childElements[0].text!)!,
                maxRecordBeatCount: Int(rowElement.childElements[maxRecordBeatCountColumnIndex].childElements[0].text!)!,
                visualEffect: EnumSet.VisualEffects.init(rawValue: rowElement.childElements[visualEffectColumnIndex].childElements[0].text!)!,
                live2dKind: nil)
            
            tmpArray.append(model)
            
            
        }
        
        return tmpArray
        
    }
    
    /// 内容种类对应伴奏表列index字典
    static private let AccompanyInfoColumnIndexDict: [AccompanyXmlFileInfos: Int] = [
        .accompanyFileName: 0,
        .tempoBPM: 1,
        .beatCount: 2,
        .cycleBeatCount: 3,
        .maxRecordBeatCount: 4,
        .visualEffect: 5,
        ]
    
    /// 伴奏表包含的内容种类
    enum AccompanyXmlFileInfos: String {
        /// 伴奏名字
        case accompanyFileName = "accompanyFileName"
        /// 速度
        case tempoBPM = "tempoBPM"
        /// 单位小节内Beat数
        case beatCount = "beatCount"
        /// 循环Beat数
        case cycleBeatCount = "cycleBeatCount"
        /// 最大录制Beat数
        case maxRecordBeatCount = "maxRecordBeatCount"
        /// 配套视效
        case visualEffect = "visualEffect"
    }
}
