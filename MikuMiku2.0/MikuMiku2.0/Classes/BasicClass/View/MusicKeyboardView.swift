//
//  MusicKeyboardView.swift
//  MikuMiku2.0
//
//  Created by XYoung on 2019/4/2.
//  Copyright © 2019 timedomAIn. All rights reserved.
//

import UIKit
import ChameleonFramework

class MusicKeyboardView: UIView {
    /// 音乐键数组
    private var musicKeyArray: [MusicKeyView] = []
    
    /// 触摸信号按钮
    private var touchList: [UITouch] = []
    
    private var effectiveKeyIndex: Int? = nil
    
    private var testArray: [AbstractTouch] = []
    
    init() {
        super.init(frame: CGRect.init(x: 0, y: 0,
                                      width: ToolClass.getScreenWidth(), height: ToolClass.getScreenHeight()))
        
        self.backgroundColor = UIColor.white
        self.isMultipleTouchEnabled = true
        
        for model in StaticData.MusicKeyInfoArray {
            let musicKey = MusicKeyView.init(model: model)
            
            musicKeyArray.append(musicKey)
            self.addSubview(musicKey)
            
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 重写Touch事件 ==============================
extension MusicKeyboardView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        for touch in touches {
            touch.currentStatus = .Began
            touch.produceTime = CACurrentMediaTime()
            
            touchList.append(touch)
        }
        
        self.decideEffectiveMove()

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        for touch in touches {
            
            for savedTouch in touchList {
                if savedTouch.movedPathID == touch.movedPathID {
                    savedTouch.currentStatus = .Moved
                    
                }
                
            }
            
            
        }
        
        self.decideEffectiveMove()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        for touch in touches {
            
            for savedTouch in touchList {
                if savedTouch.movedPathID == touch.movedPathID {
                    savedTouch.currentStatus = .Ended
                    
                }
                
            }
            
            
        }
        
        self.decideEffectiveMove()
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
         super.touchesCancelled(touches, with: event)
        
        touchList.removeAll()
        for musicKey in musicKeyArray {
            musicKey.backgroundColor = UIColor.white
            
        }
    }
    
    /// 决定哪个音有效
    private func decideEffectiveMove() -> Void {
        for index in 0 ..< self.musicKeyArray.count {
            DispatchQueue.main.async {
                self.musicKeyArray[index].currentStatus = .Unpressed
                
            }

        }
        
        var newTouchList: [UITouch] = []
        
        for savedTouch in self.touchList {
            if savedTouch.currentStatus != .Ended
                &&
                self.decideTouchMusicKey(savedTouch.location(in: self)) != nil {
                
                newTouchList.append(savedTouch)
                
            }
            
        }
        

        self.touchList = newTouchList
        
        if let effectiveTouch = self.touchList.last { // * 存在一个正在按的轨迹
            let keyIndex = self.decideTouchMusicKey(effectiveTouch.location(in: self))!
            
            DispatchQueue.main.async {
                self.musicKeyArray[keyIndex].currentStatus = .Pressed
                
            }
            
            if effectiveKeyIndex == nil {
                effectiveKeyIndex = keyIndex
                
                let model = AbstractTouch.init(keyIndex: keyIndex,
                                               isBelongToWindow: AboutAK.shared.decideIsBelongToWindow())
                testArray.append(model)
                print("↓: 音键" + String(model.keyIndex) + ", ID: " + testArray.last!.ID)
                print("===== ↓ =====")
                
                AboutAK.shared.updateAbstractTouchArray(model, ID: "")
                
            }else {
                
                if effectiveKeyIndex! != keyIndex {
                    effectiveKeyIndex = keyIndex
                    
                    print("↑: 音键" + String(testArray.last!.keyIndex) + ", 当前时间: " + String(CACurrentMediaTime() - AppDelegate.Sec))
                    AboutAK.shared.updateAbstractTouchArray(nil, ID: testArray.last!.ID)
                    print("===== ↑ =====")
                    
                    let model = AbstractTouch.init(keyIndex: keyIndex,
                                                   isBelongToWindow: AboutAK.shared.decideIsBelongToWindow())
                    
                    AboutAK.shared.updateAbstractTouchArray(model, ID: "")
                    testArray.append(model)
                    print("↓: 音键" + String(model.keyIndex) + ", ID: " + testArray.last!.ID)
                    print("===== ↓ =====")
                }
                
                
            }
            
            
        }else { // * 不存在一个新按的音
            effectiveKeyIndex = nil
            
            print("↑: 音键" + String(testArray.last!.keyIndex) + ", 当前时间: " + String(CACurrentMediaTime() - AppDelegate.Sec))
            AboutAK.shared.updateAbstractTouchArray(nil, ID: testArray.last!.ID)
            print("===== ↑ =====")
        }
        


    }
    
}

// MARK: - 相关 ==============================
extension MusicKeyboardView {
    /// 判断点击了哪个键
    private func decideTouchMusicKey(_ touchPoint: CGPoint) -> Int? {
        for musicKeyIndex in 0 ..< musicKeyArray.count {
            let musicKey = musicKeyArray[musicKeyIndex]
            
            if musicKey.frame.contains(touchPoint) {
                return musicKeyIndex
                
            }
            
        }
        
        return nil
    }// funcEnd
    
}


