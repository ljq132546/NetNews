//
//  MultLanguageTool.swift
//  AIAMobile_Swift
//
//  Created by Sonic Lin on 7/4/16.
//  Copyright © 2016 PricewaterhouseCoopers. All rights reserved.
//

import UIKit
protocol MultLanguageProtocol: NSObjectProtocol {
    func reloadInterface()
    
}

class MultLanguageTool: NSObject {
    var language:String
    var bundle:NSBundle?
    weak var delegate:MultLanguageProtocol?
    class func shareInstance() -> MultLanguageTool
    {
        struct Singleton{
            static var onceToken : dispatch_once_t = 0
            static var single:MultLanguageTool?
        }
        dispatch_once(&Singleton.onceToken,{
            Singleton.single = MultLanguageTool()
            
            }
        )
        return Singleton.single!
    }
    private override init() {
        let tmp = NSUserDefaults.standardUserDefaults().objectForKey("languageset") as? String
        if tmp == nil
        {
            self.language = "en"
            
        }
        else
        {
            self.language = tmp!
        }
        let path = NSBundle.mainBundle().pathForResource(self.language, ofType: "lproj")
        self.bundle = NSBundle.init(path: path!)
    }
    
    func changeLanguage(lang:String) ->NSBundle?
    {
        if self.language == lang
        {
            return nil
        }
        let path = NSBundle.mainBundle().pathForResource(lang, ofType: "lproj")
        self.bundle = NSBundle.init(path: path!)!
        self.language = lang
        NSUserDefaults.standardUserDefaults().setObject(self.language, forKey: "languageset")
        NSUserDefaults.standardUserDefaults().synchronize()
        NSNotificationCenter.defaultCenter().postNotificationName("ReloadInterFace", object: nil)
        return self.bundle!
    }
    
    
}

class SingleProperty: NSObject {
    var isSelfLogin: Bool = true
    var contractImagePath: String?
    var agentSubmissionSuccess: String = ""
    static let sharedInstance: SingleProperty = {
        
        let instance = SingleProperty()
        let image_path = NSBundle.mainBundle().pathForResource("Declare", ofType: "png")
        if let path = image_path {
            instance.contractImagePath = path
        }
        
        return instance
        
    }()
    
    var agentProfile: [String: AnyObject]?{
        didSet{
            accesscode = agentProfile?["ACCESS_CODE"] as? String == nil ? "" : agentProfile?["ACCESS_CODE"] as! String
            agentcode = agentProfile?["AGENT_CODE"] as? String == nil ? "" : agentProfile?["AGENT_CODE"] as! String
           
            if let user_Type =  agentProfile?["USER_GROUP"] as? String where user_Type == "STAFF" {
                userType = "staff"
            }else{
                if let agent_type = agentProfile?["CHANNEL_NAME"] as? String where agent_type == "agent"{
                    userType = "agent"
                    
                }else{
                    userType = "broker"
                }
            }
        }
        
        
        
    }
    
    //设置是否是澳门登陆
    var isMaucao: Bool = false
    
    var counter: String = ""
//    var shouldShowActivityView: Bool = false
    var agentInfo: [String: String]?
    var singleImage: NSData?
    var isStaff: Bool = false
    var loginId: String?
    var accesscode: String?
    var agentcode: String?
    var userType: String?
    var clientName: String?
//    var isSameSession: Bool = true
    
    func clearData() -> Void{
        agentProfile = nil
        agentInfo = nil
        loginId = nil
        accesscode = nil
        agentcode = nil
        userType = nil
        agentSubmissionSuccess = ""
        counter = ""
        isMaucao = false
        clientName = nil
    }
    
 
    
    
    
}
