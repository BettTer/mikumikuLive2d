//
//  AboutAK.swift
//  MikuMiku2.0
//
//  Created by XYoung on 2019/4/2.
//  Copyright © 2019 timedomAIn. All rights reserved.
//

import UIKit
import AudioKit

class AboutAK: NSObject {
    static var shared: AboutAK!
    
    #warning("=== 非量化区间长长度 ===")
    private let SpecialDuration: Double = 10
    
    private let AllDuration: Double = 32
    
    // MARK: - 代理及传入 =========================
    /// Note列表
    private let NoteInfoList: [NoteInfoModel] = {
        var tmpArray: [NoteInfoModel] = []
        
        for pitch in StaticData.MusicKeyPitchArray {
            let model = NoteInfoModel.init(pitch: pitch)
            
            tmpArray.append(model)
            
        }
        
        return tmpArray
    }()
    
    /// 记录的抽象触摸信号
    private var AbstractTouchArray: [AbstractTouch] = []
    
    private var PlayingAbstractTouch: AbstractTouch? = nil
    
    private var RecordAbstractTouchCount = 0
    
    /// 每个Beat的开始时间
    private var EveryBeatMoment: Double = 0
    
    /// 当前Beat索引
    private var currentBeatIndex = 0
    
    // MARK: - 工具 =========================
    /// 线程字典
    private let QueueDict: [QueueDictKeys: DispatchQueue] = {
        var tmpQueueDict: [QueueDictKeys: DispatchQueue] = [: ]
        
        for keyType in QueueDictKeys.allCases {
            tmpQueueDict[keyType] = DispatchQueue.init(label: keyType.rawValue, qos: .userInteractive, autoreleaseFrequency: .workItem)
            
        }
        
        return tmpQueueDict
    }()
    
    // MARK: - 基本组件 =========================
    /// 主节拍器
    private let mainMetronome = AKMetronome.init()
    
    /// 伴奏播放器
    private var accompanyPlayer: AKPlayer!
    
    /// Sampler
    private var mainSampler = AKAppleSampler.init()
    
    /// 主混合器
    private var mainMixer = AKMixer.init()

    override init(){
        super.init()
        
        self.setMainSampler()
        AKSettings.enableLogging = true
        AKSettings.bufferLength = .medium
        AudioKit.output = mainMixer
        
        try! AudioKit.start()
        
        self.setMetronome()
        mainMixer.connect(input: mainMetronome)
        
        AboutAK.shared = self
    }
}



// MARK: - 接口 =========================
extension AboutAK {
    
    /// 更新抽象触摸数组
    func updateAbstractTouchArray(_ model: AbstractTouch?, ID: String) -> Void {
        if let abstractTouch = model {
            
            if abstractTouch.isBelongToWindow == true { // * 属于窗口
                
                if PlayingAbstractTouch != nil { // * 当前有播放的音
                    
                    print("窗口被键" + String(PlayingAbstractTouch!.keyIndex) + "占, ID: " + String(PlayingAbstractTouch!.ID))
                    
                    if PlayingAbstractTouch!.getAlreadyPlayedBeat() >= 1 { // * 当前播放的音算是长音
                        self.stopMainSampler(PlayingAbstractTouch!) // * 停止播放的长音
                        
                        print("⏹停止播放当前的音, ID: " + PlayingAbstractTouch!.ID + ", 停止时间: " + String(CACurrentMediaTime() - AppDelegate.Sec))
                        print("===== ⏹ =====")
                        
                        abstractTouch.playChannel = .Window
                        self.playMainSampler(abstractTouch) // * 重新播放的特殊音
                        PlayingAbstractTouch = abstractTouch // * 重新记录
                        
                        print("⏯播放新音, ID: " + PlayingAbstractTouch!.ID + ", 播放时间: " + String(CACurrentMediaTime() - AppDelegate.Sec) + ", 播放渠道: " + PlayingAbstractTouch!.playChannel!.rawValue)
                        
                    }else {
                        AbstractTouchArray.append(abstractTouch) // * 进入量化
                        
                    }
                    
                }else {
                    print("窗口没有被占")
                    
                    abstractTouch.playChannel = .Window
                    self.playMainSampler(abstractTouch)
                    PlayingAbstractTouch = abstractTouch
                    
                    print("⏯播放新音, ID: " + PlayingAbstractTouch!.ID + ", 播放时间: " + String(CACurrentMediaTime() - AppDelegate.Sec) + ", 播放渠道: " + PlayingAbstractTouch!.playChannel!.rawValue)
                    print("===== ⏯ =====")
                    
                }
                
            }else {
                AbstractTouchArray.append(abstractTouch)
                
            }
            
        }else {
            
            var doesAssignLast = true
            
            if PlayingAbstractTouch == nil { // * 当前没有正在播放的音
                print("窗口没有被占")
                
            }else {
                
                print("窗口被键" + String(PlayingAbstractTouch!.keyIndex) + "占, ID: " + String(PlayingAbstractTouch!.ID))
                
                if PlayingAbstractTouch!.ID == ID { // * 若ID相等则确认是一致的人
                    
                    if PlayingAbstractTouch!.isTriggered == true {
                        PlayingAbstractTouch!.isTriggered = false
                        
                        if PlayingAbstractTouch!.playChannel == .Window {
                            doesAssignLast = false
                            
                        }
                        
                        
                    }
                    
                }
                
            }
            
            if doesAssignLast == true {
                AbstractTouchArray.last!.isTriggered = false
                
            }
            
            
        }
        
    }
    
    /// 是否属于窗口
    func decideIsBelongToWindow() -> Bool {
        let presentMoment = CACurrentMediaTime() - AppDelegate.Sec
        print("\n当前时间: " + String(presentMoment) + ", 前Beat线时间: " + String(EveryBeatMoment) + ", 后Beat线时间: " + String(EveryBeatMoment + StaticData.currentAccompanySystem().beatDuration))
        let effectiveTime = StaticData.currentAccompanySystem().beatDuration * SpecialDuration / AllDuration
        
        if (presentMoment - EveryBeatMoment) < effectiveTime {
            print("在窗口内(特殊音符)")
            return true
            
        }else {
            print("在窗口外")
            return false
            
        }
    }
    
}

// MARK: - 循环相关方法 =========================
extension AboutAK {
    /// 设置节拍器与播放器
    private func setMetronome() -> Void {
        let triggerGroup = DispatchGroup.init()
        
        QueueDict[.Else]!.async(group: triggerGroup, execute: {
            self.mainMetronome.tempo = StaticData.currentAccompanySystem().tempoBPM * StaticData.currentAccompanySystem().beatCount / 4
            self.mainMetronome.subdivision = Int(StaticData.currentAccompanySystem().beatCount)
            // * 静音
            self.mainMetronome.frequency1 = 0
            self.mainMetronome.frequency2 = 0
            
            self.mainMetronome.callback = {
                self.QueueDict[.Cycle]!.async {
                    self.EveryBeatMoment = CACurrentMediaTime() - AppDelegate.Sec
                    self.loopAction()
                    self.currentBeatIndex += 1
                }
            }
        })
        
        triggerGroup.notify(queue: QueueDict[.Else]!) {
            self.setAccompanyPlayer(audioFileName: StaticData.currentAccompanySystem().accompanyFileName)
            
            self.mainMetronome.reset()
            self.mainMetronome.restart()
        }
        
    }
    
    
    private func loopAction() -> Void {
        
        
        // * 1. 核对伴奏
        let presentSec = CACurrentMediaTime() - AppDelegate.Sec
        
        if currentBeatIndex % StaticData.currentAccompanySystem().maxRecordBeatCount == 0 {
            currentBeatIndex = 0
            accompanyPlayer.volume = 0
        }
        
        if currentBeatIndex % StaticData.currentAccompanySystem().cycleBeatCount == 0 {
            accompanyPlayer.play(from: CACurrentMediaTime() - AppDelegate.Sec - presentSec)
            accompanyPlayer.volume = 1
        }
        
        
        // * 2. 播放?
        if let playingAbstractTouch = PlayingAbstractTouch {
            
            if playingAbstractTouch.isTriggered == false {
                self.stopMainSampler(playingAbstractTouch)
                
                print("⏹停止播放当前的音, ID: " + PlayingAbstractTouch!.ID + ", 停止时间: " + String(CACurrentMediaTime() - AppDelegate.Sec))
                print("===== ⏹ =====")
                
                PlayingAbstractTouch = nil
                
            }else {
                playingAbstractTouch.addAlreadyPlayedBeat()
                
            }
            
        }
        
        
        
        if PlayingAbstractTouch == nil && AbstractTouchArray.count > RecordAbstractTouchCount {
            
            if let lastAbstractTouch = AbstractTouchArray.last {
                var needPlayNew = false
                
                if lastAbstractTouch.isBelongToWindow == true && lastAbstractTouch.isTriggered != false {
                    needPlayNew = true
                    
                }else if lastAbstractTouch.isBelongToWindow == false {
                    needPlayNew = true
                    
                }
                
                if needPlayNew == true {
                    lastAbstractTouch.playChannel = .Metronome
                    self.playMainSampler(lastAbstractTouch)
                    PlayingAbstractTouch = lastAbstractTouch
                    print("⏯播放新音, ID: " + PlayingAbstractTouch!.ID + ", 播放时间: " + String(CACurrentMediaTime() - AppDelegate.Sec) + ", 播放渠道: " + PlayingAbstractTouch!.playChannel!.rawValue)
                    print("===== ⏯ =====")
                    
                }
                
            }
            
        }
        
        RecordAbstractTouchCount = AbstractTouchArray.count
        
    }
}


// MARK: - 伴奏相关方法 =========================
extension AboutAK {
    /// 设置伴奏播放器
    private func setAccompanyPlayer(audioFileName: String) -> Void {
        mainMixer.disconnectInput(bus: 10)
        
        let audioFile = try! AKAudioFile.init(readFileName: audioFileName)
        accompanyPlayer = AKPlayer.init(audioFile: audioFile)
        accompanyPlayer.buffering = .always
        mainMixer.connect(input: accompanyPlayer, bus: 10)
        
        accompanyPlayer.isLooping = false
        
        // * 暂时将伴奏静音 防止切换伴奏时提前响的问题
        accompanyPlayer.volume = 0
        
        
    }
}

// MARK: - Sampler =========================
extension AboutAK {
    private func setMainSampler() -> Void {
        var fileArray: [AKAudioFile] = []
        
        let triggerGroup = DispatchGroup.init()
        
        for pitchindex in 0 ..< StaticData.MusicKeyPitchArray.count {
            QueueDict[.mainSampler]!.async(group: triggerGroup, execute: {
                let initialFile = try! AKAudioFile.init(readFileName: "deng" + "_cut_\(StaticData.MusicKeyPitchArray[pitchindex]).mp3")
                
                fileArray.append(initialFile)
                
            })
        }
        
        triggerGroup.notify(queue: QueueDict[.mainSampler]!) {
            try! self.mainSampler.loadAudioFiles(fileArray)
            fileArray.removeAll()
        }
        
        let reverb1 = AKReverb.init(mainSampler, dryWetMix: 1)
        let delay = AKDelay.init(reverb1, time: 0.015, feedback: 0.1, dryWetMix: 1)
        let mixture1 = AKDryWetMixer(delay, mainSampler, balance: 0.72)
        
        mainMixer.connect(input: mixture1)
    }
    
    func playMainSampler(_ touchModel: AbstractTouch) -> Void {
        try! mainSampler.play(noteNumber: MIDINoteNumber(NoteInfoList[touchModel.keyIndex].midiNum - 12))
        
    }
    
    func stopMainSampler(_ touchModel: AbstractTouch) -> Void {
        try! mainSampler.stop(noteNumber: MIDINoteNumber(NoteInfoList[touchModel.keyIndex].midiNum - 12))
        
    }
    
}

// MARK: - 线程标识 ==============================
extension AboutAK {
    enum QueueDictKeys: String, CaseIterable {
        /// 循环
        case Cycle = "Cycle"
        
        /// Sampler
        case mainSampler = "LoadSampler"
        
        /// Else
        case Else = "Else"
    }
    
}


class SpecialPlayInfoModel: NSObject {
    /// 正在播放的Index
    var playingIndex: Int?
    
}

class NormalPlayInfoModel: NSObject {
    /// 正在播放的Index
    var playingIndex: Int?
    /// 正在播放的是否需要结束
    var playingNeedEnd: Bool? = false
    
    /// 将要播放的Index
    var willPlayIndex: Int?
    /// 将要播放的是否需要结束
    var willPlayNeedEnd = false
}

