//
//  EnumSet.swift
//  Miku
//
//  Created by XYoung on 2019/1/18.
//  Copyright © 2019 XYoung. All rights reserved.
//

import UIKit

class EnumSet: NSObject {
    /// 图片文件名集合
    enum ImageName: String {
        /// 按钮_播放
        case play = "play"
        
    }
    
    /// 根据枚举获取图片
    static func loadImageFrom(_ imageEnum: ImageName) -> UIImage {
        let image = UIImage.init(named: imageEnum.rawValue)!
        
        return image
    }
    
    /// Live2D
    enum Live2DSpecies: String {
        /// 初音
        case miku = "miku"
        
        /// hiyori
        case hiyori = "hiyori"
        
    }
    
    /// 视觉特效名字
    enum VisualEffects: String {
        /// 黑色系
        case black = "black"
        
        /// 浅色系
        case white = "white"
    }
    
    /// 按钮状态(按下 / 抬起 ...)
    enum KeyStatus: Int {
        case Pressed = 0
        case Unpressed = 1
    }
    
    /// live2d嘴唇状态
    enum LipStatus {
        /// 要张开
        case ToOpen
        /// 不变
        case constant
    }
    
}

// MARK: - UM ==============================
extension EnumSet {
    /// 友盟事件ID枚举
    enum UMEventID: String {
        /// 切换歌曲
        case ChangeMusic = "ChangeMusic"
        
        /// 打开/关闭伴奏
        case SetAccompanyStatus = "SetAccompanyStatus"
        
        /// 编辑歌词
        case EditLyric = "EditLyric"
        
        /// 屏幕录制
        case RecordVideo = "RecordVideo"
        
        /// 屏幕录制失败
        case FailedRecord = "FailedRecord"
        
        /// 播放
        case PlayedVideo = "PlayedVideo"
        
        /// 分享
        case SharedVideo = "SharedVideo"
        
    }
    
    /// 友盟事件属性Key
    enum UMEventAttributesKey: String {
        /// 当前歌曲
        case CurrentMusicName = "CurrentMusicName"
        
        /// 歌曲播放时长
        case MusicDuration = "MusicDuration"
        
        /// 歌词内容
        case LyricContent = "LyricContent"
        
        /// 开始屏幕录制
        case BeginRecording = "BeginRecording"
        
//        /// 打开/关闭伴奏
//        case SetAccompanyStatus = "SetAccompanyStatus"
//
//

//
//        /// 播放
//        case PlayedVideo = "PlayedVideo"
//
//        /// 分享
//        case SharedVideo = "SharedVideo"
    }
    
    
}
