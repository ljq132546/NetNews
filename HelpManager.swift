//
//  HelpManager.swift
//  BodylogicalCompanion
//
//  Created by Jiqing J Liu on 3/23/17.
//  Copyright © 2017 jiqing. All rights reserved.
//

import UIKit

enum UnitType: Int {
    case cmToIn = 0
    case inToCm = 1
    case other
}

class HelpManager: NSObject {
    
    static let sharedManager: HelpManager = HelpManager()
    
    var timeRangeBefore1Day: (TimeInterval,TimeInterval) = (0.0,0.0)
    var timeRangeBefore2Day: (TimeInterval,TimeInterval) = (0.0,0.0)
    var timeRangeBefore3Day: (TimeInterval,TimeInterval) = (0.0,0.0)
    var timeRangeBefore4Day: (TimeInterval,TimeInterval) = (0.0,0.0)
    var timeRangeBefore5Day: (TimeInterval,TimeInterval) = (0.0,0.0)
    var timeRangeBefore6Day: (TimeInterval,TimeInterval) = (0.0,0.0)
    var timeRangeBefore7Day: (TimeInterval,TimeInterval) = (0.0,0.0)
    
    class  func backToContinueInterface() -> Void {
        
    }
    
    
    class func getAgeFromDate(date: Date) -> Int? {
     let day = Date()
        let components: Set<Calendar.Component> = [Calendar.Component.year]
        let diff = Calendar.current.dateComponents(components, from: date, to: day)
        return diff.year
    }
    
    class func getDateStrignFrom(date: Date) -> String {
//        let day = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        return dateFormatter.string(from: date)
    }
    class func getTimeStringFrom(date: Date) -> String {
        let dateFormatter = DateFormatter()
//        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "hh:mm aa"
//        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: date)
    }
    
    //验证邮箱
    class func validationEmailFormatter(email: String) -> Bool {
        if email.characters.count == 0 {
            return false
        }
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
    
    //验证密码
    class func validationPassword(password: String) -> Bool {
        if password.characters.count == 0{
            return false
        }
        let regex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,28}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }
    class func validationzipCode(zipcode: String) -> Bool {
        if zipcode.characters.count == 0{
            return false
        }
        let regex = "[0-9]{5,7}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: zipcode)
    }
    
    class func createAttrString(string: String) -> NSAttributedString {
//        let string = "Email address"
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttributes([NSForegroundColorAttributeName: UIColor("#000000", alpha: 0.54)!,NSFontAttributeName: UIFont.init(name: "Helvetica", size: 16.0)!], range: NSRange(location: 0, length: (string as NSString).length))
//        self.emailAddress_txf.placeholder = attrString
        return attrString
    }
    class func createAttrStringWithAtt(orginalS: String, attr: [String: Any], range: NSRange) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: orginalS)
        attrString.addAttributes(attr, range: range)
        //        self.emailAddress_txf.placeholder = attrString
        return attrString
    }
    
    class func subErrorString(errorMe: String) -> String {
        let sr = errorMe as NSString
        let csRange = sr.range(of: "\"message\"")
        let startloc = csRange.location + csRange.length
        let csrange2 = sr.range(of: "]")
        let length = csrange2.location - startloc
        return sr.substring(with: NSMakeRange(startloc, length))
        
    }
    
    class func getAge(selectedDate: Date) -> Int {
        let calendar = NSCalendar.current
        let components = (calendar as NSCalendar).components(.year, from: selectedDate, to: Date(), options: .wrapComponents)
//        let components = calendar.components([NSCalendar.Unit.Year], fromDate: selectedDate, toDate:NSDate() , options: NSCalendar.Options.WrapComponents )
        return components.year!
    }
    
    class func dealWithMaxLengthOfInput(_ textField: UITextField, range: NSRange, replaceString: String, maxlength: Int) -> Bool{
        let toBeString = (textField.text! as NSString).replacingCharacters(in: range, with: replaceString) as NSString
        if toBeString.length > maxlength && range.length != 1  {
            textField.text = toBeString.substring(to: maxlength)
            return false
        }
        return true
    }
    
    //单位转换
    class func convertTheUnit(type: UnitType, value: Double) -> String {
        ////转换 1英寸（in）=2.54厘米（cm）
        //let factheight = selectOptionOne! * 100 + selectOptionTwo!
        //1厘米（cm）=0.394英寸（in
        //let factheight = (selectOptionOne * 12 + selectOptionTwo) * 2.54
        switch type {
        case .cmToIn:
            let i_n = Int(value / 2.54)
            let f_t = i_n / 12
            let fa_in = i_n % 12
            return "\(f_t)ft \(fa_in)in"
           
        case .inToCm:
            let c_m = Int(value * 2.54)
            return "\(c_m)cm"
        default:
            return ""
        }
        
    }
  
    
    
    //获取7天前的时间
    class func getOldTimeWithTimeInterval(days: Int) -> Date {
        let currenD = Date()
        let calendar = NSCalendar(calendarIdentifier: .gregorian)
        let date = calendar!.startOfDay(for: currenD)
        
        let actualT = date.timeIntervalSince1970 - Double(days * 24 * 60 * 60)
        return Date(timeIntervalSince1970: actualT)
    }
    
    func getTimeWith7Days() -> Void {
        let currenD = Date()
        
        let currentCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        
        let startDateOfCurrentDay = currentCalendar.startOfDay(for: currenD)
        let t = startDateOfCurrentDay.timeIntervalSince1970
        self.timeRangeBefore1Day = (t - 3*3600 , t + 11*3600 )
        self.timeRangeBefore2Day = (t - 3*3600 - 1*24*3600, t + 11*3600 - 1*24*3600)
        self.timeRangeBefore3Day = (t - 3*3600 - 2*24*3600, t + 11*3600 - 2*24*3600)
        self.timeRangeBefore4Day = (t - 3*3600 - 3*24*3600, t + 11*3600 - 3*24*3600)
        self.timeRangeBefore5Day = (t - 3*3600 - 4*24*3600, t + 11*3600 - 4*24*3600)
        self.timeRangeBefore6Day = (t - 3*3600 - 5*24*3600, t + 11*3600 - 5*24*3600)
        self.timeRangeBefore7Day = (t - 3*3600 - 6*24*3600, t + 11*3600 - 6*24*3600)
    }
    //获取当前的小时
    
    class func gethourFromDate(date: Date) -> Int {
        
        let dateComponnets = NSCalendar(calendarIdentifier: .gregorian)!.component(.hour, from: date)
        return dateComponnets
    }
    
    //获取当前的分钟
    class func getMinutesFromDate(date: Date) -> Int {
        let dateComponnets = NSCalendar(calendarIdentifier: .gregorian)!.component(.minute, from: date)
        return dateComponnets
    }
    
    //单位装换
    class func convertUnitKG2LB(isKg: Bool, sourceValue: Double) -> Double {
        if isKg {
            //kg -> lb
            return sourceValue * 2.205
        }else{
            //lb -> kg 
            return sourceValue * 0.454
        }
    }
    
    class func setAttributesString(sourceString: String, range: NSRange) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: sourceString)
        attrString.addAttributes([NSFontAttributeName: UIFont.init(name: "Helvetica-Bold", size: 16.0)!], range: range)
        //        self.emailAddress_txf.placeholder = attrString
        return attrString
    }
    
    class func setMultiAttributesString(sourceString: String, rangeOne: NSRange,rangeTwo: NSRange, rangeThree: NSRange) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: sourceString)
        attrString.addAttributes([NSFontAttributeName: UIFont.init(name: "Helvetica-Bold", size: 16.0)!], range: rangeOne)
        attrString.addAttributes([NSFontAttributeName: UIFont.init(name: "Helvetica-Bold", size: 16.0)!], range: rangeTwo)
        attrString.addAttributes([NSFontAttributeName: UIFont.init(name: "Helvetica-Bold", size: 16.0)!], range: rangeThree)
        //        self.emailAddress_txf.placeholder = attrString
        return attrString
    }
    

}
