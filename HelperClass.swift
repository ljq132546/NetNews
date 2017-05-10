//
//  HelperClass.swift
//  AIAMobile_Swift
//
//  Created by Sonic Lin on 6/29/16.
//  Copyright © 2016 PricewaterhouseCoopers. All rights reserved.
//

import UIKit
class HelperClass: NSObject {
    
    //2016-09-28 14:42:18.123
    class func converDataTime(dateString: String) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.AAZZZZZ"
        let date = formatter.dateFromString(dateString)
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.stringFromDate(date!)
    }
    
    class func convertBase64StringToData(baseStr: String) -> NSData {
        return NSData(base64EncodedString: baseStr, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
    }
    
    class func convertDataToBase64String(data: NSData) -> String {
        return data.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
    }
    
    class func currentDateForContract() -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = " MM     dd       YYYY"
        return formatter.stringFromDate(NSDate())
    }
    
    class func currentDate() -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        return formatter.stringFromDate(NSDate())
    }
    class func getcurrentDateTime() -> String{
        //MM/DD/YYYY HH:MM
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/YYYY HH:mm:ss"
        return formatter.stringFromDate(NSDate())
    }
    
    class func imageWithScaledToSize(image: UIImage, newSize: CGSize) -> UIImage{
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    class func getDocumentDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        //    print("\(documentsDirectory)")
        return documentsDirectory
    }
    
    class func resizeImage(image: UIImage, height: Float?, width: Float?) -> UIImage{
        var actualHeight = Float(image.size.height)
        var actualWidth = Float(image.size.width)
        
        var maxHeight = Float(300)
        var maxWidth = Float(400)
        if height != nil {
            maxHeight = height!
        }
        if width != nil {
            maxWidth = width!
        }
        var imageRatio = Float(actualWidth/actualHeight)
        let maxRatio = maxWidth/maxHeight
        let compressionQuality = 0.5
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if maxWidth < maxRatio {
                imageRatio = maxHeight / actualHeight
                actualWidth = imageRatio * actualHeight
                actualHeight = maxHeight
            }
            else if imageRatio > maxRatio {
                imageRatio = maxWidth / actualWidth
                actualHeight = imageRatio * actualHeight
                actualWidth = maxWidth
            }else{
                actualWidth = maxWidth
                actualHeight = maxHeight
            }
        }
        let rect = CGRectMake(0, 0, CGFloat(actualWidth), CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.drawInRect(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //    let imageData = UIImageJPEGRepresentation(image, CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return UIImage(data: UIImageJPEGRepresentation(image, CGFloat(compressionQuality))!)!
    }
    
    class func improveQualityOfImagePicker(image: UIImage, height: Float?, width: Float?) -> NSData? {
        
        
        var actualHeight = Float(image.size.height)
        var actualWidth = Float(image.size.width)
        var maxHeight = Float(300)
        var maxWidth = Float(400)
        if height != nil {
            maxHeight = height!
        }
        if width != nil {
            maxWidth = width!
        }
        var imageRatio = Float(actualWidth/actualHeight)
        let maxRatio = maxWidth/maxHeight
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imageRatio < maxRatio {
                imageRatio = maxHeight / actualHeight
                actualWidth = imageRatio * actualHeight
                actualHeight = maxHeight
            }
            else if imageRatio > maxRatio {
                imageRatio = maxWidth / actualWidth
                actualHeight = imageRatio * actualHeight
                actualWidth = maxWidth
            }else{
                actualWidth = maxWidth
                actualHeight = maxHeight
            }
        }
        
        let rect = CGRectMake(0, 0, CGFloat(actualWidth), CGFloat(actualHeight))
        //        let width = UIScreen.mainScreen().bounds.size.width
        //        let height = UIScreen.mainScreen().bounds.size.height
        //        let h = height/width * 250
        //        let rect = CGRectMake(0, 0, 250, h)
        print("\(rect)")
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        image.drawInRect(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImageJPEGRepresentation(image, 0.5)
        
        
        
        
    }
    
    
    class func clearCacheFromHomeDirectory() -> Void{
        let fileManager = NSFileManager.defaultManager()
        let documentPath = HelperClass.getDocumentDirectory()
        do{
            let fileArray = try fileManager.contentsOfDirectoryAtPath(documentPath as String)
            for filePath  in fileArray {
                if filePath.containsString("txt"){
                    let fullPath = HelperClass.getDocumentDirectory().stringByAppendingPathComponent(filePath)
                    if fileManager.fileExistsAtPath(fullPath) {
                        do{
                            try fileManager.removeItemAtPath(fullPath)
                        }catch{
                            
                        }
                    }
                }
            }
        }catch{
            
        }
    }
    
    class func clearFileFromHomeDirectory(fileName: String) -> Void{
        let fileManager = NSFileManager.defaultManager()
        let catchPath = HelperClass.getDocumentDirectory().stringByAppendingPathComponent(fileName)
        do{
            if fileManager.fileExistsAtPath(catchPath) {
                try fileManager.removeItemAtPath(catchPath)
            }
        }catch {
            print("delete file failed")
        }
    }
    
    class func getRangeFromString(normalString: String, markString: String) -> NSMutableAttributedString{
        let attrString = NSMutableAttributedString(string: normalString)
        let range = (normalString as NSString).rangeOfString(markString)
        attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: range)
        return attrString
    }
    class func getBottonInfo()->String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let infoDictionary = NSBundle.mainBundle().infoDictionary
        let majorVersion = infoDictionary!["CFBundleShortVersionString"] as? String
        let buildVersion = infoDictionary!["CFBundleVersion"] as? String
        //    print("\(infoDictionary)")
        return "<" + formatter.stringFromDate(NSDate()) + ">" + "  "  + "Ver." + majorVersion! + "." + buildVersion!
        //    return "<" + majorVersion! + ">"
    }
    
    class func getVersionInfo() -> String {
        let infoDictionary = NSBundle.mainBundle().infoDictionary
        let majorVersion = infoDictionary!["CFBundleShortVersionString"] as? String
        let buildVersion = infoDictionary!["CFBundleVersion"] as? String
        return majorVersion! + "." + buildVersion!
    }
    
    class func checkIdNo(idNo: String) -> Bool{
        if idNo.characters.count == 0 {
            return false
        }
//        let regex = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        let regex1 = "^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$"
        let regex2 = "^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$"
        let predicate1 = NSPredicate(format: "SELF MATCHES %@", regex1)
        let predicate2 = NSPredicate(format: "SELF MATCHES %@", regex2)
        if predicate1.evaluateWithObject(idNo) || predicate2.evaluateWithObject(idNo) {
            return true
        }else{
            return false
        }
//        return  predicate.evaluateWithObject(idNo)
        //    return predicate.
    }
    //日
    class func checkBirthDay(day: String) -> Bool {
        if day.characters.count == 0 {
            return false
        }
        let regex = "(([12][0-9])|(3[01])|(0?[1-9]))"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return  predicate.evaluateWithObject(day)
        
    }
    //月
    class func checkBirthMonth(month: String) -> Bool {
        if month.characters.count == 0 {
            return false
        }
        let regex = "((1[0-2])|(0?[1-9]))"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return  predicate.evaluateWithObject(month)
    }
    //年
    class func checkBirthYear(year: String) -> Bool {
        if year.characters.count == 0 {
            return false
        }
        let regex = "(\\d{4}|\\d{2})"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return  predicate.evaluateWithObject(year)
    }
    //check birthdate
    class func checkBirthDate(month: String, day: String,year: String?) -> Bool {
        if month == "" || day == "" {
            return true
        }
        switch Int(month)! {
        case 1,3,5,7,8,10,12:
            if Int(day)! > 31 {
                
                return false
            }
            return true
        case 2:
            if year != nil && year != "" {
                if Int(year!)!%4 == 0 {
                    if Int(day)! > 29 {
                        
                        return false
                        
                    }
                    return true
                }else{
                    if Int(day)! > 28{
                        
                        return false
                        
                    }
                    return true
                }
                
            }else{
                if Int(day)! > 29{
                    return false
                }
                return true
            }
            
            
        case 4,6,9,11:
            if Int(day)! > 30{
                
                return false
            }
            return true
            
        default:
            
            return false
            
        }
        
    }
    
    class func checkAgentNo(agentNumber: String) -> Bool {
        if agentNumber.characters.count == 0 {
            return false
        }
        let regex = "^[A-Za-z0-9_-]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return  predicate.evaluateWithObject(agentNumber)
    }
    class func getAccessCodeAndAgentCodeFromBroker(loginID: String) -> Void {
        HelperClass.clearAgentCodeAndAgentCodeFromBroker()
        if loginID.containsString("-") {
            
            let range = (loginID as NSString).rangeOfString("-")
            
            let agentCode = (loginID as NSString).substringToIndex(range.location)
            NSUserDefaults.standardUserDefaults().setObject(agentCode, forKey: "B-agentCode")
            let accessCode = (loginID as NSString).substringFromIndex(range.location + range.length)
            NSUserDefaults.standardUserDefaults().setObject(accessCode, forKey: "B-accessCode")
        }
    }
    
    class func clearAgentCodeAndAgentCodeFromBroker() -> Void {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("B-agentCode")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("B-accessCode")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func getAge(selectedDate: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([NSCalendarUnit.Year], fromDate: selectedDate, toDate:NSDate() , options: NSCalendarOptions.WrapComponents )
        return components.year
    }
    class func getBackgroundTime(enterBackgroundDate: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([NSCalendarUnit.Minute], fromDate: enterBackgroundDate, toDate:NSDate() , options: NSCalendarOptions.WrapComponents )
        return components.minute
    }
    //add method
    class func getRangeWhiteFromString(normalString: String, markString: String) -> NSMutableAttributedString{
        let attrString = NSMutableAttributedString(string: normalString)
        let range = (normalString as NSString).rangeOfString(markString)
        attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: range)
        return attrString
    }
    class func changeTextColorFromString(normalString: String, markString: String, markString2: String?) -> NSMutableAttributedString{
        let attrString = NSMutableAttributedString(string: normalString)
        let range = (normalString as NSString).rangeOfString(markString)
        attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: range)
        if markString2 != nil {
            let range2 = (normalString as NSString).rangeOfString(markString2!)
            attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: range2)
        }
        return attrString
    }
    
    class func getCurrentDate() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        return formatter.stringFromDate(NSDate())
    }
    
    class func changeIvertyID(normalString: String) -> String {
        
        let range = (normalString as NSString).rangeOfString("-", options: .BackwardsSearch)
        let ivertyString = (normalString as NSString).substringToIndex(range.location)
        
        return ivertyString
    }
    class func getBookingIdFromIverifyId(normalString: String) -> String {
        let range = (normalString as NSString).rangeOfString("-")
        let bookingID  = (normalString as NSString).substringToIndex(range.location)
        print("bookingID----------\(bookingID)")
        return bookingID
    }
    
    
    class func removeExpiredFile(bookingIdList: [String]?)-> Void {
        
        
        let fileManager = NSFileManager.defaultManager()
        let documentPath = HelperClass.getDocumentDirectory()
        do{
            var bookingIdpath: String?
            var bookingIdpath_pdf: String?
            var fullPath: String?
            let fileArray = try fileManager.contentsOfDirectoryAtPath(documentPath as String)
            print("\(fileArray)")
            //打印出每一个filePath
            for filePath  in fileArray {
                
                //拼接完整的路径
                fullPath = HelperClass.getDocumentDirectory().stringByAppendingPathComponent(filePath)
                
                if bookingIdList == nil {
                    do{
                        if fileManager.fileExistsAtPath(fullPath!) {
                            try fileManager.removeItemAtPath(fullPath!)
                        }
                    }catch{
                        print("delete file failed")
                    }
                }else{
                    var shouldShow: Bool = false
                    for bookingIds in bookingIdList!{
                        bookingIdpath = String(format: "%@.txt", bookingIds)
                        bookingIdpath_pdf = String(format: "%@.text", bookingIds)
                        if filePath == bookingIdpath || filePath == bookingIdpath_pdf {
                            shouldShow = true
                            
                        }
                    }
                    
                    if !shouldShow {
                        do{
                            if fileManager.fileExistsAtPath(fullPath!) {
                                try fileManager.removeItemAtPath(fullPath!)
                            }
                        }catch{
                            print("delete file failed")
                        }
                    }
                    
                    print("\(filePath)")
                }
                
                
                
                
            }
            
        }catch{
            
        }
    }
    class func  getTimeUptoMillisecond() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter.stringFromDate(NSDate())
    }
    
    class func getTimeToStandard() -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYMMdd"
        return formatter.stringFromDate(NSDate())
    }
    
    class func changeTheContentOfIdtype(idType: String) -> String {
        
        if idType == "ID Card" || idType == "中国身份证" || idType == "中國身份證" {
            return "ID Card"
        }else if idType == "Pass Card" || idType == "通行证" || idType == "通行證" {
            return "Pass Card"
        }else{
            return "Passport"
        }
  
        
        
    }
    
    class func changeDocSeq(docDic: [String: AnyObject]) -> Bool {
        
        if let docSeq = docDic["docSeq"] as? String where docSeq == "15" {
            return true
        }else{
            return false
        }
    }
    //系统iOS版本
    let systemVersion = UIDevice.currentDevice().systemVersion
    //当球版本got
    //ipad 型号
    //playfrom ipad got 
    //
    
    class func startUpgrade(targetUrl: String) -> Void {
        UIApplication.sharedApplication().openURL(NSURL(string: targetUrl)!)
    }
    
}

public extension UIDevice {
    
    
//    print(systemVersion)
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
            case "iPad1,1": return "iPad 1G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8", "iPad6,3", "iPad6,4":                      return "iPad Pro"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}


