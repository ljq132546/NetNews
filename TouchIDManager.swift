//
//  TouchIDManager.swift
//  BodylogicalCompanion
//
//  Created by Jiqing J Liu on 3/28/17.
//  Copyright © 2017 jiqing. All rights reserved.
//

import UIKit
import LocalAuthentication




//创建TouchID的工具类
class TouchIDManager: NSObject {
    static let touchIdManager: TouchIDManager = TouchIDManager()
    
//    var touchIDisEnable: Bool = true
    //首先判断是否具有指纹识别
    //创建识别的上下文
    var context: LAContext? {
        let iosversion = UIDevice.current.systemVersion
        switch iosversion.compare("8.0.0", options:  .numeric) {
        case .orderedSame,.orderedDescending:
            return LAContext()
        case .orderedAscending:
            return nil
        
        }
    }
    /*
     LocalizedReason -
     Reason to use TouchID
     */
    var localizedReason:String?
    /*
     LocalizedFallbackTitle -
     Fallback button title in case touchID fails to detect fingerprint.
     Empty string for no fallback button.
     */
    var localizedFallbackTitle:String?
    //提取错误信息
    var errorMessage: NSError?
    
    func isTouchIdAvailableAndEnrolled() -> Bool {
//        var error: NSError?
        //验证设备支不支持touchID
        let touchAvailability = context?.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &errorMessage)
        if let av = touchAvailability {
            
            return av
        }else{
            
            return false
        }
    }
    /*
     Authenticates user
     Uses a completion block for handling after authentication is done.
     /*
     Completion block - (AuthSuccess, Error)
     */
     */
     func presentTouchIdOptionForAuth(localizedReason: String, localizedFailBack: String, completion: @escaping (_ isAuthSuccess: Bool, _ error: Error?)->Void) -> Void {
        
        if self.isTouchIdAvailableAndEnrolled() {
            self.context?.localizedFallbackTitle = localizedFallbackTitle
            self.context?.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason, reply: { (success, AuthFailError) in
                completion(success, AuthFailError)
                
            })
        }else{
            completion(false, errorMessage)
        }
    }
    
    

}
