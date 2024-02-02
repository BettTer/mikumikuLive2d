//
//  BaseExtensions.swift
//  MikuMiku2.0
//
//  Created by XYoung on 2019/4/2.
//  Copyright © 2019 timedomAIn. All rights reserved.
//

import UIKit

// MARK: - 最最基础 ==============================
extension NSObject{
    /// 获取对象所属类名
    public var nameOfClass: String{
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
        
    }
}

// MARK: - 控制器 ==============================
extension UIViewController {
    /// 获取当前控制器头部高度
    public func getStatusBarAndNaviBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.size.height + self.navigationController!.navigationBar.getHeight()
        
    }// funcEnd
    
    /// 从故事板中初始化一个控制器 [控制器名] -> UIViewController
    static public func createViewControllerOfStoryboard(_ viewControllerID: String) -> UIViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: viewControllerID)
        
    }// funcEnd
    
    /// 根据控制器类名&参数表(字典)创建控制器对象
    static public func createClassObjWithString(className: String!, classPropertyParam: Dictionary<String, Any>?) -> UIViewController {
        
        // * 动态获取命名空间
        let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        
        // * 注意工程中必须有相关的类，否则程序会崩
        let viewControllerClass: AnyClass = NSClassFromString(nameSpace + "." + className)!
        
        // * 告诉编译器它的真实类型
        guard let classType = viewControllerClass as? UIViewController.Type else{
            printWithMessage("无法获取到该控制器类型 在此跳出")
            return UIViewController()
        }
        
        let viewController = classType.init()
        if classPropertyParam != nil {
            viewController.setValuesForKeys(classPropertyParam!)
            
        }
        
        return viewController
    }
    
}

// MARK: - UIView相关 ==============================
extension UIView {
    /// 获取当前View的横坐标
    public func getX() -> CGFloat {
        return self.frame.origin.x
    }
    
    /// 获取当前View的纵坐标
    public func getY() -> CGFloat {
        return self.frame.origin.y
    }
    
    /// 获取当前View的宽
    public func getWidth() -> CGFloat {
        return self.frame.width
    }
    
    /// 获取当前View的高
    public func getHeight() -> CGFloat {
        return self.frame.height
    }
    
    /// 当前View截图 (是否不透明)
    public func normalShot(isOpaque: Bool, scale: CGFloat) -> UIImage {
        // 参数①：截屏区域  参数②：是否透明  参数③：清晰度
        UIGraphicsBeginImageContextWithOptions(self.frame.size, isOpaque, scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return image;
    }
    
    /// 特殊View(渲染类)截图
    public func offScreenshot(isOpaque: Bool, scale: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, isOpaque, scale)
        _ = self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    /// 可选部位圆角 corners: 需要实现为圆角的角，可传入多个 radii: 圆角半径
    public func optionalCorner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) -> Void {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        
    }
    
    
    public enum ViewSide {
        /// 上边
        case top
        /// 下边
        case bottom
        /// 左边
        case left
        /// 右边
        case right
    }
    /// 可选部位边框
    public func optionalBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) -> CALayer {
        
        switch side {
        case .top:
            // Bottom Offset Has No Effect
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                    y: 0 + topOffset,
                                                    width: self.frame.size.width - leftOffset - rightOffset,
                                                    height: thickness), color: color)
        case .right:
            // Left Has No Effect
            // Subtract bottomOffset from the height to get our end.
            return _getOneSidedBorder(frame: CGRect(x: self.frame.size.width - thickness - rightOffset,
                                                    y: 0 + topOffset,
                                                    width: thickness,
                                                    height: self.frame.size.height), color: color)
        case .bottom:
            // Top has No Effect
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                    y: self.frame.size.height-thickness-bottomOffset,
                                                    width: self.frame.size.width - leftOffset - rightOffset,
                                                    height: thickness), color: color)
        case .left:
            // Right Has No Effect
            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                    y: 0 + topOffset,
                                                    width: thickness,
                                                    height: self.frame.size.height - topOffset - bottomOffset), color: color)
        }
    }
    
    public func createViewBackedBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) -> UIView {
        
        switch side {
        case .top:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: 0 + topOffset,
                                                                            width: self.frame.size.width - leftOffset - rightOffset,
                                                                            height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            return border
            
        case .right:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
                                                                            y: 0 + topOffset, width: thickness,
                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            return border
            
        case .bottom:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: self.frame.size.height-thickness-bottomOffset,
                                                                            width: self.frame.size.width - leftOffset - rightOffset,
                                                                            height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            return border
            
        case .left:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: 0 + topOffset,
                                                                            width: thickness,
                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
            return border
        }
    }
    
    public func addBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
        
        switch side {
        case .top:
            // Add leftOffset to our X to get start X position.
            // Add topOffset to Y to get start Y position
            // Subtract left offset from width to negate shifting from leftOffset.
            // Subtract rightoffset from width to set end X and Width.
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                   y: 0 + topOffset,
                                                                   width: self.frame.size.width - leftOffset - rightOffset,
                                                                   height: thickness), color: color)
            self.layer.addSublayer(border)
        case .right:
            // Subtract the rightOffset from our width + thickness to get our final x position.
            // Add topOffset to our y to get our start y position.
            // Subtract topOffset from our height, so our border doesn't extend past teh view.
            // Subtract bottomOffset from the height to get our end.
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
                                                                   y: 0 + topOffset, width: thickness,
                                                                   height: self.frame.size.height - topOffset - bottomOffset), color: color)
            self.layer.addSublayer(border)
        case .bottom:
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                   y: self.frame.size.height-thickness-bottomOffset,
                                                                   width: self.frame.size.width - leftOffset - rightOffset, height: thickness), color: color)
            self.layer.addSublayer(border)
        case .left:
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                   y: 0 + topOffset,
                                                                   width: thickness,
                                                                   height: self.frame.size.height - topOffset - bottomOffset), color: color)
            self.layer.addSublayer(border)
        }
    }
    
    public func addViewBackedBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
        switch side {
        case .top:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: 0 + topOffset,
                                                                            width: self.frame.size.width - leftOffset - rightOffset,
                                                                            height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            self.addSubview(border)
            
        case .right:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
                                                                            y: 0 + topOffset, width: thickness,
                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            self.addSubview(border)
            
        case .bottom:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: self.frame.size.height-thickness-bottomOffset,
                                                                            width: self.frame.size.width - leftOffset - rightOffset,
                                                                            height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            self.addSubview(border)
        case .left:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: 0 + topOffset,
                                                                            width: thickness,
                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
            self.addSubview(border)
        }
        
    }

    fileprivate func _getOneSidedBorder(frame: CGRect, color: UIColor) -> CALayer {
        let border:CALayer = CALayer()
        border.frame = frame
        border.backgroundColor = color.cgColor
        return border
    }
    
    fileprivate func _getViewBackedOneSidedBorder(frame: CGRect, color: UIColor) -> UIView {
        let border:UIView = UIView.init(frame: frame)
        border.backgroundColor = color
        return border
    }
    
    /// 添加阴影
    private func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    /// 抖动方向
    public enum ShakeDirection: Int{
        /// 水平
        case horizontal
        /// 垂直
        case vertical
    }
    
    /// - Parameters:
    ///   - direction: 抖动方向（默认是水平方向）
    ///   - times: 抖动次数（默认5次）
    ///   - interval: 每次抖动时间（默认0.1秒）
    ///   - delta: 抖动偏移量（默认2）
    ///   - completion: 抖动动画结束后的回调
    /// UIView的抖动方法
    private func shake(direction: ShakeDirection = .horizontal, times: Int = 16, interval: TimeInterval = 0.01, delta: CGFloat = 3.5, completion: (() -> Void)? = nil)
    {
        UIView.animate(withDuration: interval, animations: {
            
            switch direction
            {
            case .horizontal:
                self.layer.setAffineTransform(CGAffineTransform(translationX: delta, y: 0))
            case .vertical:
                self.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: delta))
            }
        }) { (finish) in
            
            if times == 0
            {
                UIView.animate(withDuration: interval, animations: {
                    self.layer.setAffineTransform(CGAffineTransform.identity)
                }, completion: { (finish) in
                    completion?()
                })
            }
            else
            {
                self.shake(direction: direction, times: times - 1, interval: interval, delta: -delta, completion: completion)
            }
        }
    }
    
}

extension UILabel {
    /// 设置Label为动态行高
    public func setAutoFitHeight(x: CGFloat, y: CGFloat, width: CGFloat) -> CGFloat {
        self.numberOfLines = 0
        self.lineBreakMode = NSLineBreakMode.byWordWrapping
        let autoSize: CGSize = self.sizeThatFits(CGSize.init(width: width, height: CGFloat(MAXFLOAT)))
        self.frame = CGRect.init(x: x, y: y, width: width, height: autoSize.height)
        return autoSize.height
    }
    
    /// 设置Label为动态宽
    public func setAutoFitWidth(x: CGFloat, y: CGFloat, height: CGFloat) -> CGFloat {
        self.numberOfLines = 0
        self.lineBreakMode = NSLineBreakMode.byWordWrapping
        let autoSize: CGSize = self.sizeThatFits(CGSize.init(width: CGFloat(MAXFLOAT), height: height))
        self.frame = CGRect.init(x: x, y: y, width: autoSize.width, height: height)
        return autoSize.width
    }
}

extension UITextView {
    /// 设置UITextView为动态高 [内容, 字体大小, 宽度] -> 动态高
    public func setAutoFitHeight(text: String, fontSize: CGFloat, fixedWidth: CGFloat) -> CGFloat {
        
        self.text = text
        self.font = UIFont.systemFont(ofSize: fontSize)
        
        let size = CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
        let constraint = self.sizeThatFits(size)
        return constraint.height
    }// funcEnd
}

extension UITouch {
    public enum TouchStatus {
        /// 开始
        case Began
        /// 滑动
        case Moved
        /// 结束
        case Ended
        /// 取消
        case Cancel
        /// 初始化
        case Init
    }
    
    /// 触摸状态
    var currentStatus: TouchStatus {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.touchStatusKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
        
        get {
            if let status = objc_getAssociatedObject(self, &AssociatedKey.touchStatusKey) as? TouchStatus {
                return status
                
            }
            
            return .Init
        }
    }
    
    /// 滑动轨迹ID
    var movedPathID: String {
        get {
            return String(format: "%p",  self)
            
        }
    }
    
    /// 创建时间
    var produceTime: Double {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.produceTouchTime, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.produceTouchTime) as! Double
        }
        
    }
    
}

extension UIButton {
    /// 设置Button为动态宽
    public func setAutoFitWidth(x: CGFloat, y: CGFloat, height: CGFloat) -> CGFloat {
        let w = self.titleLabel?.setAutoFitWidth(x: x, y: y, height: height)
        self.frame = CGRect.init(x: x, y: y, width: w!, height: height)
        return w!
    }
    
}

// MARK: - 视觉 ==============================
extension UIColor{
    /// 十六进制字符串初始化颜色
    static public func hexadecimalColor(_ hexadecimal: String) -> UIColor {
        var cstr = hexadecimal.trimmingCharacters(in:  CharacterSet.whitespacesAndNewlines).uppercased() as NSString;
        if(cstr.length < 6){
            return UIColor.clear;
        }
        if(cstr.hasPrefix("0X")){
            cstr = cstr.substring(from: 2) as NSString
        }
        if(cstr.hasPrefix("#")){
            cstr = cstr.substring(from: 1) as NSString
        }
        if(cstr.length != 6){
            return UIColor.clear;
        }
        var range = NSRange.init()
        range.location = 0
        range.length = 2
        //r
        let rStr = cstr.substring(with: range);
        //g
        range.location = 2;
        let gStr = cstr.substring(with: range)
        //b
        range.location = 4;
        let bStr = cstr.substring(with: range)
        var r :UInt32 = 0x0;
        var g :UInt32 = 0x0;
        var b :UInt32 = 0x0;
        Scanner.init(string: rStr).scanHexInt32(&r);
        Scanner.init(string: gStr).scanHexInt32(&g);
        Scanner.init(string: bStr).scanHexInt32(&b);
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1);
        
    }
    
    /// 创造一张纯色图片
    public func creatImage() -> UIImage {
        let rect = CGRect(x:0,y:0,width:1,height:1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

// MARK: - Data ==============================
extension Date {
    /// 获得现在的毫秒数
    static func getCurrentMSec() -> Int {
        return Int((Date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 1)) * 1000)
        
    }
}

extension String {
    public func cutWithPlaces(startPlace: Int, endPlace: Int) -> String {
        if self == "" {
            return ""
            
        }else {
            let startIndex = self.index(self.startIndex, offsetBy: startPlace)
            let endIndex = self.index(startIndex, offsetBy: endPlace - startPlace)
            
            return String(self[startIndex ..< endIndex])
        }
        
    }
    
    /// 生成一个随机字符串
    static public func random(_ count: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        var ranStr = ""
        for _ in 0 ..< count {
            let index = Int.random(in: 0 ..< characters.count)
            ranStr.append(characters[characters.index(characters.startIndex, offsetBy: index)])
            
        }
        
        return ranStr
    }// funcEnd
    
    /// 使用正则表达式替换
    public func pregReplace(pattern: String?, with: String,
                     options: NSRegularExpression.Options = []) -> String {
        
        /// 只留汉字的正则表达式
        let OnlyChinesePattern = "[^\\u4E00-\\u9FA5]"
        
        var regex: NSRegularExpression!
        
        if let beingPattern = pattern {
            regex = try! NSRegularExpression(pattern: beingPattern, options: options)
            
        }else {
            regex = try! NSRegularExpression(pattern: OnlyChinesePattern, options: options)
            
        }
        
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSMakeRange(0, self.count),
                                              withTemplate: with)
    }
    
    /// 去除Emoji表情
    public func stringByRemovingEmoji() -> String {
        return String(self.filter { !$0.isEmoji() })
    }
}

extension Character {
    fileprivate func isEmoji() -> Bool {
        return Character(UnicodeScalar(UInt32(0x1d000))!) <= self && self <= Character(UnicodeScalar(UInt32(0x1f77f))!)
            || Character(UnicodeScalar(UInt32(0x2100))!) <= self && self <= Character(UnicodeScalar(UInt32(0x26ff))!)
    }
}

extension Double {
    /// 保留X位小数
    public func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}



// MARK: - 杂类 ==============================
extension UIImage {
    /// 把文件存储到沙盒
    public func saveToSandBox(fileName: String, searchPath: FileManager.SearchPathDirectory, folderName: String?) -> String? {
        guard let imageData = self.jpegData(compressionQuality: 1) else {
            return nil
            
        }
        
        guard let directory = try? FileManager.default.url(for: searchPath, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return nil
        }
        
        
        do {
            var finalURL: URL!
            
            if let folder = folderName {
                let tmpURL = directory.appendingPathComponent(folder, isDirectory: true)
                finalURL = tmpURL!.appendingPathComponent(fileName + ".JPEG")
                
            }else {
                finalURL = directory.appendingPathComponent(fileName + ".JPEG")!
                
            }
            
            try imageData.write(to: finalURL)
            
            return finalURL.path
            
        } catch {
            print(error.localizedDescription)
            
            return nil
        }
    }
    
    /// 从沙盒读取文件
    static public func load(filePath: String) -> UIImage? {
        let fileURL = URL.init(fileURLWithPath: filePath)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
}

extension FileManager{
    /// 创建文件夹
    public func creatFilePath(path: String){
        
        do{
            // 创建文件夹   1，路径 2 是否补全中间的路劲 3 属性
            try self.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            
        } catch{
            
            print("creat false")
        }
        
        
    }
    
}

extension UIDevice {
    
    
    /// 当前设备型号
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
}

/// 扩展属性关联Key
private struct AssociatedKey {
    /// 当前touch状态Key
    static var touchStatusKey = "touchStatusKey"
    /// touch产生时间
    static var produceTouchTime = "produceTouchTime"
}

// MARK: - 辅助数据 ==============================


class BaseExtensions: NSObject {

    
}

