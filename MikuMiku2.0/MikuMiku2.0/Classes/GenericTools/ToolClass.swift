//
//  ToolClass.swift
//  BirthdayManager
//
//  Created by X Young. on 2017/10/31.
//  Copyright © 2017年 X Young. All rights reserved.
//

import UIKit

public class ToolClass: NSObject {
    /// 上下安全区数组
    static private var TopBottomPaddingArray: [CGFloat] = []
    
    /// 屏幕宽高数组
    static private var ScreenWidthHeightArray: [CGFloat] = []
    
    /// App信息数组
    static let AppinfoDictionary = Bundle.main.infoDictionary!
    
    /// 获取版本号
    static func getAppVersionNumString() -> String {
        return AppinfoDictionary["CFBundleShortVersionString"]! as! String
        
    }
    
    /// 获取Build号
    static func getAppBuildNumString() -> String {
        return AppinfoDictionary["CFBundleVersion"]! as! String
        
    }
    
    /// 获取状态栏高度
    static func getStatusBarHeight() -> CGFloat {
        var result: CGFloat!
        
        DispatchQueue.main.async {
            result = UIApplication.shared.statusBarFrame.size.height
            
        }
        
        return result
    }
    
    /// 获取屏幕宽
    static func getScreenWidth() -> CGFloat {
        if ScreenWidthHeightArray.count == 0 {
            ScreenWidthHeightArray = [UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height]
            
        }
        
        return ScreenWidthHeightArray[0]
    }
    
    /// 获取屏幕高
    static func getScreenHeight() -> CGFloat {
        if ScreenWidthHeightArray.count == 0 {
            ScreenWidthHeightArray = [UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height]
            
        }
        
        return ScreenWidthHeightArray[1]
    }
    
    /// 获取安全区距离Top与Bottom的间距数组
    static func getTopBottomPaddingArray() -> [CGFloat] {
        if TopBottomPaddingArray.count == 0 {
            var tmpArray: [CGFloat] = []
            
            autoreleasepool {
                let window = UIWindow.init(frame: CGRect.init(x: 0, y: 0,
                                                              width: ToolClass.getScreenWidth(),
                                                              height: ToolClass.getScreenHeight()))
                
                if #available(iOS 11.0, *) {
                    tmpArray = [window.safeAreaInsets.top, window.safeAreaInsets.bottom]
                    
                }else {
                    tmpArray = [self.getStatusBarHeight(), 0]
                    
                }
                
            }
            
            if tmpArray[0] == 0 {
                tmpArray[0] = 20
                
            }
            
            TopBottomPaddingArray = tmpArray
        }
        
        return TopBottomPaddingArray
    }
    
    /// 将相册的视频文件存储在沙盒
    static func copyVideoToSandBoxTmp(videoURL: URL) -> URL? {
        let videoData = NSData.init(contentsOf: videoURL)!
        
        let copyVideoURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(String.random(10) + ".mp4")
        
        do {
            try videoData.write(to: copyVideoURL, options: .atomic)
            
        } catch {
            print(error)
            return nil
            
        }
        
        return copyVideoURL
    }
    
    
    /// 清理TmpDirectory
    static func clearTmpDirectory() {
        let fileManager = FileManager.default
        do {
            let tmpDirectory = try fileManager.contentsOfDirectory(atPath: NSTemporaryDirectory())
            try tmpDirectory.forEach {[unowned fileManager] file in
                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                try fileManager.removeItem(atPath: path)
            }
            
        } catch {
            print(error)
            
        }
    }
    
    /// 清理DocumentDirectory
    static func clearDirectory(_ searchPath: FileManager.SearchPathDirectory, folderName: String?) {
        let fileManager = FileManager.default
        var directoryPath = ""
        
        guard let directory = try? FileManager.default.url(for: searchPath, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            
            return
        }
        
        directoryPath = directory.path!
        
        if let folder = folderName {
            directoryPath += "/" + folder
        }
        
        
        
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: directoryPath)
            for filePath in filePaths {
                if filePath.first! != "." {
                    try fileManager.removeItem(atPath: directoryPath + "/" + filePath)
                    
                }
            }
            
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
    
    /// 秒转换成00:00:00格式
    static func getFormatPlayTime(secounds:TimeInterval)->String{
        if secounds.isNaN{
            return "00:00"
        }
        var Min = Int(secounds / 60)
        let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
        var Hour = 0
        if Min>=60 {
            Hour = Int(Min / 60)
            Min = Min - Hour*60
            return String(format: "%02d:%02d:%02d", Hour, Min, Sec)
        }
        return String(format: "00:%02d:%02d", Min, Sec)
    }
    
    
    /// 根据00:00:00时间格式，转换成秒
    static func getSecondsFromTimeStr(timeStr:String) -> Double {
        if timeStr.isEmpty {
            return 0
        }
        
        var timeArray = timeStr.replacingOccurrences(of: "：", with: ":").components(separatedBy: ":")
        var seconds: Double = 0
        
        switch timeArray.count {
        case 2:
            seconds = Double(timeArray[0])! * 60 + Double(timeArray[1])!
            
        case 3:
            seconds = Double(timeArray[0])! * 60 * 60 + Double(timeArray[1])! * 60 + Double(timeArray[2])!
            
            
        default:
            seconds = Double(timeStr)!
        }
        
        
        return seconds
        
    }
    
    static func isPurnDouble(string: String) -> Bool {
        
        let scan: Scanner = Scanner(string: string)
        
        var val:Double = 0
        
        return scan.scanDouble(&val) && scan.isAtEnd
        
    }
    
    
    
    /// 求两点间距离
    static func getDistance(point1: CGPoint, point2: CGPoint) -> CGFloat {
        return sqrt(pow((point1.x - point2.x), 2) + pow((point1.y - point2.y), 2))
        
    }
    
    /// 给定两个点 获得该直线方程
    static func getEquationFrom(point1: CGPoint, point2: CGPoint) -> [CGFloat] {
        
        // y = a * x + b
        let a = (point1.y - point2.y) / (point1.x - point2.x)
        
        let b = point1.y - a * point1.x
        
        return [a, b]
    }
    
    /// 给定两个点和一个View 获得两点所连线段是否过View
    static func judgeTwoPointsSegmentIsPassView(point1: CGPoint, point2: CGPoint, view: UIView) -> Bool {
        // 系数数组 [a, b]
        let coefficientArray = self.getEquationFrom(point1: point1, point2: point2)
        let a = coefficientArray[0]
        let b = coefficientArray[1]
        
        // view的上宽和下宽的Y
        let y1 = view.frame.origin.y
        let y2 = y1 + view.frame.height
        
        // 获得解
        let x1 = (y1 - b) / a
        let x2 = (y2 - b) / a
        
        var tmpPoint1: CGPoint
        var tmpPoint2: CGPoint
        
        
        if point1.x > point2.x {
            tmpPoint1 = point2
            tmpPoint2 = point1
            
        }else {
            tmpPoint1 = point1
            tmpPoint2 = point2
            
        }
        
        // View的x区间
        let minX = view.frame.origin.x
        let maxX = minX + view.frame.width
        
        if (x1 >= minX && x1 <= maxX && x1 >= tmpPoint1.x && x1 <= tmpPoint2.x)
            ||
            (x2 >= minX && x2 <= maxX && x2 >= tmpPoint1.x && x2 <= tmpPoint2.x ) {
            
            return true
            
        }else if view.frame.contains(point1) || view.frame.contains(point2) {
            return true
            
        }else {
            return false
            
        }
        
        
        
    }
    
    
    /// 3.2 字符串的剪切与拼接
    static func cutStringWithPlaces(_ dealString: String, startPlace: Int, endPlace: Int) -> String {
        if dealString == "" {
            return ""
            
        }else {
            let startIndex = dealString.index(dealString.startIndex, offsetBy: startPlace)
            let endIndex = dealString.index(startIndex, offsetBy: endPlace - startPlace)
            
            return String(dealString[startIndex ..< endIndex])
        }
        
    }
    
    // MARK: - GCD相关
    /// 1.GCD回到主线程
    static func GCDMain() -> Void {
        // 1.GCD回到主线程
        DispatchQueue.main.async {
            
        }
        
    }
    
    /// 2.Dispatch Group的使用
    static func dispatchGroup() -> Void {
        let queueGroup = DispatchGroup.init()
        
        for i in 0 ..< 9 {
            let basicQueue = DispatchQueue(label: "basicQueue")
            basicQueue.async(group: queueGroup, execute: {
                // 进行操作
                printWithMessage("这是\(i)")
            })
        }
        
        queueGroup.notify(queue: DispatchQueue.main) {
            printWithMessage("最后一步")
        }
        
    }
    
    /// 3.Dispatch Barrier的使用
    static func dispatchBarrier() -> Void {
        let growUpQueue = DispatchQueue(label: "growUpQueue")
        growUpQueue.async {
            printWithMessage("1")
        }
        
        growUpQueue.async(group: nil, qos: .default, flags: .barrier) {
            printWithMessage("虎落平阳")
        }
        
        growUpQueue.async {
            printWithMessage("东山再起")
        }
    }
    
    /// 4.Dispatch Semaphore的使用
    static func dispatchSemaphore() -> Void {
        let queueGroup = DispatchGroup.init()
        let testSemaphore = DispatchSemaphore.init(value: 10)
        let globalQueue = DispatchQueue.global()
        
        for i in 0 ..< 50 {
            testSemaphore.wait()
            globalQueue.async(group: queueGroup, execute: DispatchWorkItem.init(block: {
                printWithMessage("这是第\(i)个")
                sleep(3)
                testSemaphore.signal()
            }))
        }
        
    }
    
    
    /// 获取本地语言
    static func getCurrentLanguage() -> String {
        
        let preferredLang = Bundle.main.preferredLocalizations.first! as NSString
        
        switch String(describing: preferredLang) {
        case "en-US", "en-CN":
            return "en"//英文
        case "zh-Hans-US","zh-Hans-CN","zh-Hant-CN","zh-TW","zh-HK","zh-Hans":
            return "cn"//中文
        default:
            return "en"
        }
    }
    
    

    
    /// JSON转字典
    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try (((JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])))
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    ///  线程锁
    static func synchronizedLock(needLockObject:AnyObject, closure:()->()) -> Void{
        objc_sync_enter(needLockObject)
        closure()
        objc_sync_exit(needLockObject)
    }
    
    /// 动画类
    static func baseAnimationWithKeyPath(_ path : String , fromValue : Any? , toValue : Any?, duration : CFTimeInterval, repeatCount : Float? , timingFunction : String?) -> CABasicAnimation{
        
        let animate = CABasicAnimation(keyPath: path)
        //起始值
        animate.fromValue = fromValue;
        
        //变成什么，或者说到哪个值
        animate.toValue = toValue
        
        //所改变属性的起始改变量 比如旋转360°，如果该值设置成为0.5 那么动画就从180°开始
        //        animate.byValue =
        
        //动画结束是否停留在动画结束的位置
        animate.isRemovedOnCompletion = true
        
        //动画时长
        animate.duration = duration
        
        //重复次数 Float.infinity 一直重复 OC：HUGE_VALF
        animate.repeatCount = repeatCount ?? 0
        
        //设置动画在该时间内重复
        //        animate.repeatDuration = 5
        
        //延时动画开始时间，使用CACurrentMediaTime() + 秒(s)
        //        animate.beginTime = CACurrentMediaTime() + 2;
        
        //设置动画的速度变化
        /*
         kCAMediaTimingFunctionLinear: String        匀速
         kCAMediaTimingFunctionEaseIn: String        先慢后快
         kCAMediaTimingFunctionEaseOut: String       先快后慢
         kCAMediaTimingFunctionEaseInEaseOut: String 两头慢，中间快
         kCAMediaTimingFunctionDefault: String       默认效果和上面一个效果极为类似，不易区分
         */
        
        if timingFunction == nil {
            animate.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)
            
        }else {
            animate.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.init(rawValue: timingFunction!))
            
        }
        
        
        
        
        
        //动画在开始和结束的时候的动作
        /*
         kCAFillModeForwards    保持在最后一帧，如果想保持在最后一帧，那么isRemovedOnCompletion应该设置为false
         kCAFillModeBackwards   将会立即执行第一帧，无论是否设置了beginTime属性
         kCAFillModeBoth        该值是上面两者的组合状态
         kCAFillModeRemoved     默认状态，会恢复原状
         */
        animate.fillMode = CAMediaTimingFillMode.both
        
        //动画结束时，是否执行逆向动画
        //        animate.autoreverses = true
        
        return animate
        
    }
    
    
    //MARK: - 获取IP
    static func getIPAddresses() -> String? {
        var addresses = [String]()
        
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first
    }
    
}

// MARK: - 线程类;
/// 延时执行类
public class DelayTask: NSObject {
    
    static var workItemDict: [String: DispatchWorkItem] = [: ]
    
    /// 创建一个延时执行任务 [任务内容, 延时时间] -> Void
    static func createTaskWith(Id: String, taskClosure: @escaping ()->(), delayTime: TimeInterval) -> Void {
        
        let workItem = DispatchWorkItem.init {
            taskClosure()
            
        }
        
        self.workItemDict[Id] = workItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
            workItem.perform()
            self.workItemDict.removeValue(forKey: Id)
        }
        
        
        
    }// funcEnd
    
    /// 取消该任务
    static func cancelTask(Id: String) -> Void {
        if let workItem = self.workItemDict[Id] {
            workItem.cancel()
            self.workItemDict.removeValue(forKey: Id)
        }
        
    }
    
}

/// 打印对象及信息
public func printWithMessage<T>(_ printObj: T,
                                file: String = #file,
                                method: String = #function,
                                line: Int = #line) -> Void {
    #if DEBUG
    let fileString: String = file as String
    let index = fileString.range(of: "/", options: .backwards, range: nil, locale: nil)?.upperBound
    let newStr = fileString[index!...]
    print("打印信息汇总:{\n  所属文件:\(newStr)\n  该方法名:\(method)\n  所在行数:\(line)\n  对象内容:\(printObj)\n}")
    #endif
}

public func shuffle(toShuffle: [Int]) -> [Int] {
    var list = toShuffle
    for index in 0..<list.count {
        let newIndex = Int(arc4random_uniform(UInt32(list.count-index))) + index
        if index != newIndex {
            list.swapAt(index, newIndex)
        }
    }
    return list
}



