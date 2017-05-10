//
//  NetworkManager.swift
//  AIAMobile_Swift
//
//  Created by Sonic Lin on 6/29/16.
//  Copyright © 2016 PricewaterhouseCoopers. All rights reserved.
//

import UIKit
//import AFNetworking
import XMLDictionary
import GRAESCrypt
import KeychainAccess

typealias Successed = (AFHTTPRequestOperation, AnyObject?) ->Void
typealias Failure = (AFHTTPRequestOperation, NSError) -> Void
let timeOut: NSTimeInterval = 180
class NetworkManager: NSObject {
    
    class func agentAuthentication(loginId:String, password:String, success:Successed, failed:Failure) -> Void {
        let loginSucceed = success
        let loginFialed = failed
        let soapMessage  = String(format: "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.ipos.aiahk/\">\n   <soapenv:Header/>\n   <soapenv:Body>\n      <ws:agentAuthentication>\n   <appID>com.aiahk.iverify</appID>\n    <deviceID>?</deviceID>\n      <deviceName>?</deviceName>\n         <deviceToken>?</deviceToken>\n   <lang>?</lang>\n            <loginId>%@</loginId>\n  <passWord>%@</passWord>\n <flag>?</flag>\n  </ws:agentAuthentication>\n   </soapenv:Body>\n</soapenv:Envelope>", loginId, password)
        
        let url = NSURL(string: Constants.RemoteHost.AIAHost)
        let request = NSMutableURLRequest(URL: url!)
        let messageLength = String(format: "%lu",soapMessage.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("agentAuthentication", forHTTPHeaderField: "SOAPAction")
        request.addValue(messageLength, forHTTPHeaderField: "Content-Length")
        request.HTTPMethod = "POST"
        request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        //设置为3分钟
//        request.timeoutInterval = timeOut
        let operation = AFHTTPRequestOperation(request: request)
        operation.responseSerializer = AFXMLParserResponseSerializer()
        operation.setCompletionBlockWithSuccess({ (operation, responseObject) in
            let responseDic = XMLDictionaryParser.sharedInstance().dictionaryWithParser(responseObject as! NSXMLParser)
            if let response = responseDic["env:Body"]!["ns2:agentAuthenticationResponse"]!!["return"] as? String {
                let responseDecrypted =  response.base64DecodedString().stringByReplacingOccurrencesOfString("\r", withString: "").stringByReplacingOccurrencesOfString("\n", withString: "")
                let j = XMLDictionaryParser.sharedInstance().dictionaryWithString(responseDecrypted)
                loginSucceed(operation, j)
            }
        }) { (operation, error) in
            loginFialed(operation, error)
        }
        
        operation.start()
    }
    
    /**
     agentcode 
     
     - parameter loginId:  <#loginId description#>
     - parameter password: <#password description#>
     - parameter success:  <#success description#>
     - parameter failed:   <#failed description#>
     */
    class func agentProfile(loginId:String, password:String, success:Successed, failed:Failure, wscConfirmation: Bool = false) -> Void {
        let loginSucceed = success
        let loginFialed = failed
        var soapMessage  = String(format: "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.ipos.aiahk/\"><soapenv:Header/><soapenv:Body><ws:agentProfile><loginId>%@</loginId><accessCode></accessCode><passWord>%@</passWord><version></version><flag>1</flag></ws:agentProfile></soapenv:Body></soapenv:Envelope>", loginId, password)
        if !wscConfirmation {
            let accessCode = NSUserDefaults.standardUserDefaults().objectForKey("B-accessCode") as? String
            let agentCode = NSUserDefaults.standardUserDefaults().objectForKey("B-agentCode") as? String
            
            if accessCode != nil && agentCode != nil {
                soapMessage  = String(format: "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.ipos.aiahk/\"><soapenv:Header/><soapenv:Body><ws:agentProfile><loginId>%@</loginId><accessCode>%@</accessCode><passWord>%@</passWord><version></version><flag>1</flag></ws:agentProfile></soapenv:Body></soapenv:Envelope>", agentCode!, accessCode!, password)
            }
        }
        let url = NSURL(string: Constants.RemoteHost.AIAHost)
        let request = NSMutableURLRequest(URL: url!)
        let messageLength = String(format: "%lu",soapMessage.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("agentProfile", forHTTPHeaderField: "SOAPAction")
        request.addValue(messageLength, forHTTPHeaderField: "Content-Length")
        request.HTTPMethod = "POST"
        request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        //设置为3分钟
//        request.timeoutInterval = timeOut
        let operation = AFHTTPRequestOperation(request: request)
        operation.responseSerializer = AFXMLParserResponseSerializer()
        operation.setCompletionBlockWithSuccess({ (operation, responseObject) in
            let responseDic = XMLDictionaryParser.sharedInstance().dictionaryWithParser(responseObject as!   NSXMLParser)
            if let response = responseDic["env:Body"]!["ns2:agentProfileResponse"]!!["return"] as? String {
                let responseString = AESCrypt.decrypt(response, password: password)
                XMLDictionaryParser.sharedInstance().stripEmptyNodes = false
                let j = XMLDictionaryParser.sharedInstance().dictionaryWithString(responseString)
                loginSucceed(operation, j)
            }
        }) { (operation, error) in
            loginFialed(operation, error)
        }
        
        operation.start()
    }
    
    class func getBookings(loginId:String, password:String, success:Successed, failed:Failure) -> Void {
        let loginSucceed = success
        let loginFialed = failed
        
        let soapMessage  = String(format: "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:fac=\"http://facade.service.iverify.pwc.com/\"><soapenv:Header/><soapenv:Body><fac:getBookings><booking><agentNo>%@</agentNo><password>%@</password></booking></fac:getBookings></soapenv:Body></soapenv:Envelope>", loginId, password)
        
        let url = NSURL(string: Constants.RemoteHost.PwCHost)
        let request = NSMutableURLRequest(URL: url!)
        let messageLength = String(format: "%lu",soapMessage.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("getBookings", forHTTPHeaderField: "SOAPAction")
        request.addValue(messageLength, forHTTPHeaderField: "Content-Length")
        request.HTTPMethod = "POST"
        request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        //设置为3分钟
//        request.timeoutInterval = timeOut
        let operation = AFHTTPRequestOperation(request: request)
        operation.responseSerializer = AFXMLParserResponseSerializer()
        operation.setCompletionBlockWithSuccess({ (operation, responseObject) in
            let responseDic = XMLDictionaryParser.sharedInstance().dictionaryWithParser(responseObject as! NSXMLParser)
            if let response = responseDic["soap:Body"]!["ns2:getBookingsResponse"]!!["return"] as? String {
                let responseDecrypted =  response.base64DecodedString().stringByReplacingOccurrencesOfString("\r", withString: "").stringByReplacingOccurrencesOfString("\n", withString: "")
                let j = XMLDictionaryParser.sharedInstance().dictionaryWithString(responseDecrypted)
                loginSucceed(operation, j)
            }
        }) { (operation, error) in
            loginFialed(operation, error)
        }
        
        operation.start()
    }
    
    
    
    class func saveClientInfo(clients:[[String : AnyObject]], success:Successed, failed:Failure, loginID: String) -> Void {
        //        print("\(clients)")
        let keyChian = Keychain(service: "com.pwcsdc.AIAMobile")
        //create by and update by
        var updataBy: String?
        //create agentcode
        var agent_code: String?
        var staff_agent_code: String?
        var agentProfileD: AnyObject?
        let user_Type: String = SingleProperty.sharedInstance.userType == nil ? "" : SingleProperty.sharedInstance.userType!.uppercaseString
        var access_Token: String?
        let userDefault = NSUserDefaults.standardUserDefaults()
        let bookingId = userDefault.objectForKey("BookingId") as! String
        var brokerAccessCode: String?
        var brokerAgentCode: String?
        //获取agentCode
        
        
        do{
            let agentProfileData = try keyChian.getData("agentProfile")
            if agentProfileData != nil {
                
                let agentProfileDic = NSKeyedUnarchiver.unarchiveObjectWithData(agentProfileData!)
                agentProfileD = agentProfileDic
                agent_code = agentProfileDic?["AGENT_CODE"] as? String == nil ? "" : agentProfileDic?["AGENT_CODE"] as! String
                
                agent_code = agent_code?.uppercaseString
                access_Token = agentProfileDic?["accessToken"] as? String == nil ? "" : agentProfileDic?["accessToken"] as! String
                //--------------------
                staff_agent_code = agentProfileDic?["AGENT_CODE"] as? String == nil ? "" : agentProfileDic?["AGENT_CODE"] as! String
                staff_agent_code = staff_agent_code?.uppercaseString
                
                if SingleProperty.sharedInstance.userType?.lowercaseString == "staff" {
                    let agentCode = agentProfileDic?.objectForKey("USER_ID") as? String
                    updataBy = agentCode?.uppercaseString
                }else if SingleProperty.sharedInstance.userType?.lowercaseString == "broker" {
                    //updataBy = userDefault.objectForKey("WSCStaffCode") as? String == nil ? (agentProfileDic?["AGENT_CODE"] as? String)?.uppercaseString : (userDefault.objectForKey("WSCStaffCode") as! String).uppercaseString
                    
                    //Changed: for broker updateBy should be Broker AgentCode_AceessCode (same as Login ID)
                    updataBy = userDefault.objectForKey("WSCStaffCode") as? String == nil ? SingleProperty.sharedInstance.loginId?.uppercaseString : (userDefault.objectForKey("WSCStaffCode") as! String).uppercaseString
                    agent_code = SingleProperty.sharedInstance.loginId?.uppercaseString
                    staff_agent_code = SingleProperty.sharedInstance.loginId?.uppercaseString
                    
                }else{
                  updataBy = userDefault.objectForKey("WSCStaffCode") as? String == nil ? (agentProfileDic?["AGENT_CODE"] as? String)?.uppercaseString : (userDefault.objectForKey("WSCStaffCode") as! String).uppercaseString
                }
                
//                if let userType =  agentProfileDic?["USER_GROUP"] as? String
//                {
//                    //问题一: 是否这个也是要
//                    staff_agent_code = agentProfileDic?["AGENT_CODE"] as? String == nil ? "" : agentProfileDic?["AGENT_CODE"] as! String
//                    staff_agent_code = staff_agent_code?.uppercaseString
//                    
//                    //
//                    if userType.lowercaseString == "staff" {
//                        let agentCode = agentProfileDic?.objectForKey("USER_ID") as? String
//                        updataBy = agentCode?.uppercaseString
//                        
////                        user_Type = "staff"
//                    }else{
//
//                        updataBy = userDefault.objectForKey("WSCStaffCode") as? String == nil ? (agentProfileDic?["AGENT_CODE"] as? String)?.uppercaseString : (userDefault.objectForKey("WSCStaffCode") as! String).uppercaseString
//                    }
//                }
                
            }}catch let error {
                print("key chain error:\(error)")
        }
        
        
        let loginSucceed = success
        let loginFialed  = failed
        var clientsString = String()
        let currentData = HelperClass.getcurrentDateTime()
        let signAt = SingleProperty.sharedInstance.isMaucao ? "Macau" : "HongKong"

        var iverifyID: String?
        var clientID: String?
        
        
        
       
        for (index,clientDic) in clients.enumerate() {
            var clientDocuments = String()
            iverifyID = clientDic["iverifyID"] as? String
            guard let _ = iverifyID else{
                return
            }
            iverifyID = HelperClass.changeIvertyID(iverifyID!)
            iverifyID = "\(iverifyID!)-\(index + 1)"
            
            clientID = "\(index + 1)"
            
            if let documents = clientDic["Documents"] as? [[String: AnyObject]] {
                
                 let signDate = documents[14]["signDate"] as? String ?? HelperClass.getcurrentDateTime()
                
                for documentDic in documents {
                    if !documentDic.isEmpty {
                        if let seq = documentDic["docSeq"] as? String where seq == "11" {
                            if let binary = documentDic["binary"] as? String {
                                if binary.characters.count == 0 {
                                    continue
                                }
                            }
                        }
                        
                        let soapDocument = String(format: " <documents><binary>%@</binary><clientID>%@</clientID><createdBy>%@</createdBy><createdDateTime>%@</createdDateTime><docID>%@</docID><docSeq>%@</docSeq><docType>%@</docType><fileName>%@</fileName><iverifyID>%@</iverifyID><lastUpdateDateTime>%@</lastUpdateDateTime><pageNo>%@</pageNo><signAt>%@</signAt><signDate>%@</signDate><signStatus>%@</signStatus><updatedBy>%@</updatedBy></documents>",documentDic["binary"] as? String == nil ? "" : documentDic["binary"] as! String,clientID!
                            , documentDic["createdBy"] as? String == nil ? updataBy! : documentDic["createdBy"] as! String,
                              documentDic["createdDateTime"] as? String == nil ? currentData : documentDic["createdDateTime"] as! String,
                              documentDic["docID"] as? String == nil ? "" : documentDic["docID"] as! String,
                              documentDic["docSeq"] as? String == nil ? "" : documentDic["docSeq"] as! String,
                              documentDic["docType"] as? String == nil ? "IMAGE" : documentDic["docType"] as! String,
                              documentDic["fileName"] as? String == nil ? "" : documentDic["fileName"] as! String,
                              iverifyID!,
                              documentDic["lastUpdateDateTime"] as? String == nil ? currentData : documentDic["lastUpdateDateTime"] as! String,
                              documentDic["pageNo"] as? String == nil ? "" : documentDic["pageNo"] as! String,
                              documentDic["signAt"] as? String == nil ? signAt : documentDic["signAt"] as! String,
                              signDate,
                              documentDic["signStatus"] as? String == nil ? "Y" : documentDic["signStatus"] as! String,
                              documentDic["updatedBy"] as? String == nil ? updataBy! : documentDic["updatedBy"] as! String
                        )
                        //            print("\(documentDic["createdDateTime"] as? String)\(documentDic["lastUpdateDateTime"] as? String)")
                        clientDocuments += soapDocument
                    }
                }
            }
            
            //Changed : for broker tr, change the T_PRC_CLIENT agent_Cdoe and Acces_code
//            let brokerAccessCode = NSUserDefaults.standardUserDefaults().objectForKey("B-accessCode") as? String
//            let brokerAgentCode = NSUserDefaults.standardUserDefaults().objectForKey("B-agentCode") as? String
//            
//            if brokerAccessCode != nil && brokerAgentCode != nil {
//                agent_code = brokerAgentCode
//            }
            if agent_code!.containsString("-") {
                
                let range = (agent_code! as NSString).rangeOfString("-")
                
                brokerAgentCode = (agent_code! as NSString).substringToIndex(range.location)
                brokerAccessCode = (agent_code! as NSString).substringFromIndex(range.location + range.length)
                agent_code = brokerAgentCode
            }
            //change End
            
            let soapClient = String(format: " <clientList><accessCode>%@</accessCode><agentCode>%@</agentCode><clientID>%@</clientID><createdBy>%@</createdBy><createdDateTime>%@</createdDateTime><dob>%@</dob>%@<firstName>%@</firstName><idNo>%@</idNo><idType>%@</idType><iverifyID>%@</iverifyID><iverifyInd>%@</iverifyInd><lastName>%@</lastName><lastUpdateDateTime>%@</lastUpdateDateTime> <status>%@</status> <updatedBy>%@</updatedBy></clientList>",
                                    //clientDic["accessCode"] as? String == nil ? "" : clientDic["accessCode"] as! String,
                                    //changed
                                    brokerAccessCode == nil ? (clientDic["accessCode"] as? String ?? "") : brokerAccessCode!,
                                    //end changed
                                    clientDic["agentCode"] as? String == nil ? "" : agent_code!,
                                    clientID!,
                                    clientDic["createdBy"] as? String == nil ? updataBy! : clientDic["createdBy"] as!String,
                                    clientDic["createdDateTime"] as? String == nil ? currentData : clientDic["createdDateTime"] as! String,
                                    clientDic["dob"] as? String == nil ? "" : clientDic["dob"] as! String,
                                    clientDocuments.isEmpty ? "" : clientDocuments,
                                    clientDic["firstName"] as? String == nil ? "" : (clientDic["firstName"] as! String).uppercaseString,
                                    clientDic["idNo"] as? String == nil ? "" : clientDic["idNo"] as! String,
                                    HelperClass.changeTheContentOfIdtype(clientDic["idType"] as! String),
                                    iverifyID!,
                                    clientDic["iverifyInd"] as? String == nil ? "" : clientDic["iverifyInd"] as! String,
                                    clientDic["lastName"] as? String == nil ? "" : (clientDic["lastName"] as! String).uppercaseString,
                                    clientDic["lastUpdateDateTime"] as? String == nil ? currentData : clientDic["lastUpdateDateTime"] as! String,
                                    clientDic["status"] as? String == nil ? "" : clientDic["status"] as! String,
                                    clientDic["updatedBy"] as? String == nil ? updataBy! : clientDic["updatedBy"] as! String)
            clientsString += soapClient
        }
        
        var soapMessage: String?
        var agentNoSec: String = ""
        var firstNameSec: String = ""
        var lastNameSec: String = ""
        
        if let temData = userDefault.objectForKey("agentOptionProfile") as? NSData {
            let agentSecProfile = NSKeyedUnarchiver.unarchiveObjectWithData(temData) as! [String: AnyObject]
            agentNoSec = (agentSecProfile["AGENT_CODE"] as? String == nil ? "" : agentSecProfile["AGENT_CODE"] as! String).uppercaseString
            firstNameSec = (agentSecProfile["AGENT_FIRST_NAME"] as? String == nil ? "" : agentSecProfile["AGENT_FIRST_NAME"] as! String).uppercaseString
            lastNameSec = (agentSecProfile["AGENT_LAST_NAME"] as? String == nil ? "" : agentSecProfile["AGENT_LAST_NAME"] as! String).uppercaseString
        }
        
        
        
        let uptoMillSecond = HelperClass.getTimeUptoMillisecond()
        
        do {
            let agentInfoData = try keyChian.getData("agentInfo")
            let agentInfoDic = NSKeyedUnarchiver.unarchiveObjectWithData(agentInfoData!)
            _ = agentInfoDic!.objectForKey("UserName") as! String
            
            
            let firstClientInfo = clients.first! as [String: AnyObject]
//            let iverifyInd: String = String(format: "%@-%@-%@-1", bookingId,staff_agent_code!,uptoMillSecond)
            let iverifyInd: String = String(format: "%@-%@-1", bookingId,staff_agent_code!)
            print("\(staff_agent_code!)----\(agentNoSec == "" ? "是" : "否")")
            let customMessage = String(format: "<vcBooking4MobileBean><agentNo>%@</agentNo><agentNoSec>%@</agentNoSec><firstNameSec>%@</firstNameSec><lastNameSec>%@</lastNameSec><bookingID>%@</bookingID><centerId>VCHK</centerId><chineseName>%@</chineseName><currentStatusCode>6</currentStatusCode><docCheckStatus>Y</docCheckStatus><docSubmitStatus>Y</docSubmitStatus><endTime>%@</endTime><firstName>%@</firstName><iverifyInd>%@</iverifyInd><lastName>%@</lastName><pickedBy>%@</pickedBy><roomID>VCHK.001</roomID><startTime>%@</startTime><statusPreset></statusPreset><VCCompleteStatus>Y</VCCompleteStatus><agentSubmissionSuccess>%@</agentSubmissionSuccess></vcBooking4MobileBean>", staff_agent_code!,agentNoSec,firstNameSec,lastNameSec,bookingId,
                                       firstClientInfo["chineseName"] as? String==nil ? "" : firstClientInfo["chineseName"] as! String,uptoMillSecond,
                                       agentProfileD!["AGENT_FIRST_NAME"] as? String==nil ? "" : (agentProfileD!["AGENT_FIRST_NAME"] as! String).uppercaseString,iverifyInd,
                                       agentProfileD!["AGENT_LAST_NAME"] as? String==nil ? "" : (agentProfileD!["AGENT_LAST_NAME"] as! String).uppercaseString,
                                       updataBy!,
                                       uptoMillSecond,SingleProperty.sharedInstance.agentSubmissionSuccess)
            
            //access_Token!
            soapMessage = String(format: "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:fac=\"http://facade.service.iverify.pwc.com/\"><soapenv:Header/><soapenv:Body><fac:saveClientInfo><clients><accessToken>%@</accessToken><bookingID>%@</bookingID>%@<docSubmitStatus>Y</docSubmitStatus><loginId>%@</loginId><userType>%@</userType>%@</clients></fac:saveClientInfo></soapenv:Body></soapenv:Envelope>",access_Token!,bookingId, clientsString,loginID,user_Type,customMessage)
            
            
        }catch let error {
            print(error)
        }
        
        
        
       
        
        
        let url = NSURL(string: Constants.RemoteHost.PwCHost)
        let request = NSMutableURLRequest(URL: url!)
        let messageLength = String(format: "%lu",soapMessage!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("saveClientInfo", forHTTPHeaderField: "SOAPAction")
        request.addValue(messageLength, forHTTPHeaderField: "Content-Length")
        request.HTTPMethod = "POST"
        request.HTTPBody = soapMessage!.dataUsingEncoding(NSUTF8StringEncoding)
        //设置为3分钟
        request.timeoutInterval = timeOut

          
        let operation = AFHTTPRequestOperation(request: request)
        
        operation.responseSerializer = AFXMLParserResponseSerializer()
        operation.setCompletionBlockWithSuccess({ (operation, responseObject) in
            let responseDic = XMLDictionaryParser.sharedInstance().dictionaryWithParser(responseObject as! NSXMLParser)
            if let response = responseDic["soap:Body"]!["ns2:saveClientInfoResponse"]!!["return"] as? String {
                let responseDecrypted =  response.base64DecodedString().stringByReplacingOccurrencesOfString("\r", withString: "").stringByReplacingOccurrencesOfString("\n", withString: "")
                let j = XMLDictionaryParser.sharedInstance().dictionaryWithString(responseDecrypted)
                
                loginSucceed(operation, j)
            }
        }) { (operation, error) in
            loginFialed(operation, error)
        }
        operation.start()
       
    }
    
    class func docCheck(docId:String, success:Successed, failed:Failure) -> Void{
        let loginSucceed = success
        let loginFialed = failed
        let soapMessage  = String(format: "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:fac=\"http://facade.service.iverify.pwc.com/\"><soapenv:Header/><soapenv:Body><fac:docCheck><docCheck><bookingID>%@</bookingID></docCheck></fac:docCheck> </soapenv:Body></soapenv:Envelope>", docId)
        
        let url = NSURL(string: Constants.RemoteHost.PwCHost)
        let request = NSMutableURLRequest(URL: url!)
        let messageLength = String(format: "%lu",soapMessage.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("docCheck", forHTTPHeaderField: "SOAPAction")
        request.addValue(messageLength, forHTTPHeaderField: "Content-Length")
        request.HTTPMethod = "POST"
        request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        request.timeoutInterval = timeOut
        let operation = AFHTTPRequestOperation(request: request)
        operation.responseSerializer = AFXMLParserResponseSerializer()
        operation.setCompletionBlockWithSuccess({ (operation, responseObject) in
            let responseDic = XMLDictionaryParser.sharedInstance().dictionaryWithParser(responseObject as! NSXMLParser)
            
            if let response = responseDic["soap:Body"]!["ns2:docCheckResponse"]!!["return"] as? String {
                let responseDecrypted =  response.base64DecodedString().stringByReplacingOccurrencesOfString("\r", withString: "").stringByReplacingOccurrencesOfString("\n", withString: "")
                let j = XMLDictionaryParser.sharedInstance().dictionaryWithString(responseDecrypted)
                loginSucceed(operation, j)
            }
        }) { (operation, error) in
            loginFialed(operation, error)
        }
        
        operation.start()
    }
    
    class func getVCURI(bookingID:String, success:Successed, failed:Failure) -> Void {
        let loginSucceed = success
        let loginFialed = failed
        let soapMessage  = String(format: "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:fac=\"http://facade.service.iverify.pwc.com/\"><soapenv:Header/><soapenv:Body><fac:getRoomURI> <bookingID>%@</bookingID></fac:getRoomURI></soapenv:Body></soapenv:Envelope>", bookingID)
        
        let url = NSURL(string: Constants.RemoteHost.PwCHost)
        let request = NSMutableURLRequest(URL: url!)
        let messageLength = String(format: "%lu",soapMessage.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("getRoomURI", forHTTPHeaderField: "SOAPAction")
        request.addValue(messageLength, forHTTPHeaderField: "Content-Length")
        request.HTTPMethod = "POST"
        request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
//        request.timeoutInterval = timeOut
        let operation = AFHTTPRequestOperation(request: request)
        operation.responseSerializer = AFXMLParserResponseSerializer()
        operation.setCompletionBlockWithSuccess({ (operation, responseObject) in
            let responseDic = XMLDictionaryParser.sharedInstance().dictionaryWithParser(responseObject as! NSXMLParser)
            if let response = responseDic["soap:Body"]!["ns2:getRoomURIResponse"]!!["return"] as? String {
                let responseDecrypted =  response.base64DecodedString().stringByReplacingOccurrencesOfString("\r", withString: "").stringByReplacingOccurrencesOfString("\n", withString: "")
                let j = XMLDictionaryParser.sharedInstance().dictionaryWithString(responseDecrypted)
                loginSucceed(operation, j)
            }
        }) { (operation, error) in
            loginFialed(operation, error)
        }
        
        operation.start()
    }
    
   
    class func saveEventlogInfo(success:Successed, failed:Failure) -> Void{
        let loginSucceed = success
        let loginFialed = failed
//        //获取本地存储的event信息
        var temporayString = String()
        let uploadTime = HelperClass.getTimeUptoMillisecond()
        let data = NSUserDefaults.standardUserDefaults().objectForKey("EVENTLISTS") as? NSData
        
        if let _ = data {
            if let temList = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? [[String: String]] {
                for dict in temList {
                    let event = String(format: "<eventlogList><accesscode>%@</accesscode><agentcode>%@</agentcode><createdby>%@</createdby><createddatetime>%@</createddatetime><datetime>%@</datetime><devicemodel>%@</devicemodel><deviceosversion>%@</deviceosversion><event>%@</event><loginid>%@</loginid><platform>ipad</platform><systemversion>%@</systemversion><usertype>%@</usertype><specialcolumn1>%@</specialcolumn1><specialcolumn2>%@</specialcolumn2></eventlogList>", dict["accesscode"]==nil ? "" : dict["accesscode"]!,
                                       dict["agentcode"]==nil ? "" : dict["agentcode"]!,
                                       dict["createdby"]==nil ? "" : dict["createdby"]!,
                                       uploadTime,
                                       dict["createddatetime"]==nil ? "" : dict["createddatetime"]!,
                                       dict["devicemodel"]==nil ? "" : dict["devicemodel"]!,
                                       dict["deviceosversion"]==nil ? "" : dict["deviceosversion"]!,
                                       dict["event"]==nil ? "" : dict["event"]!,
                                       dict["loginid"]==nil ? "" : dict["loginid"]!,
                                       dict["systemversion"]==nil ? "" : dict["systemversion"]!,
                                       dict["usertype"]==nil ? "" : dict["usertype"]!
                        ,dict["detailInfo"] == nil ? "" : dict["detailInfo"]!,
                         dict["clientName"] == nil ? "" : dict["clientName"]!)
                    temporayString += event
                }
            }else{

                temporayString = ""
            }
        }else{
            temporayString = ""
        }

        
        print("\(SingleProperty.sharedInstance.loginId!)")
        let loginID = SingleProperty.sharedInstance.isStaff == true ? "" : SingleProperty.sharedInstance.loginId!
        //<version>\(HelperClass.getVersionInfo())</version>
        var soapMessage = "<agentNo>\(loginID)</agentNo>\(temporayString)<version>\(HelperClass.getVersionInfo())</version>"
        
         soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:fac=\"http://facade.service.iverify.pwc.com/\"><soapenv:Header/><soapenv:Body><fac:saveEventlogInfo><events>\(soapMessage)</events></fac:saveEventlogInfo></soapenv:Body></soapenv:Envelope>"
        
        
        let url = NSURL(string: Constants.RemoteHost.PwCHost)
        let request = NSMutableURLRequest(URL: url!)
        let messageLength = String(format: "%lu",soapMessage.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("saveEventlogInfo", forHTTPHeaderField: "SOAPAction")
        request.addValue(messageLength, forHTTPHeaderField: "Content-Length")
        request.HTTPMethod = "POST"
        request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
//        request.timeoutInterval = timeOut
        let operation = AFHTTPRequestOperation(request: request)
        operation.responseSerializer = AFXMLParserResponseSerializer()
        operation.setCompletionBlockWithSuccess({ (operation, responseObject) in
            let responseDic = XMLDictionaryParser.sharedInstance().dictionaryWithParser(responseObject as! NSXMLParser)
            if let response = responseDic["soap:Body"]!["ns2:saveEventlogInfoResponse"]!!["return"] as? String {
                let responseDecrypted =  response.base64DecodedString().stringByReplacingOccurrencesOfString("\r", withString: "").stringByReplacingOccurrencesOfString("\n", withString: "")
                let j = XMLDictionaryParser.sharedInstance().dictionaryWithString(responseDecrypted)
                loginSucceed(operation, j)
            }
        }) { (operation, error) in
            loginFialed(operation, error)
        }
        
        operation.start()
        
        
        
    }
}
