//
//  Auth0Manager.swift
//  BodylogicalCompanion
//
//  Created by Jiqing J Liu on 3/30/17.
//  Copyright © 2017 jiqing. All rights reserved.
//

import UIKit
import Auth0
import SimpleKeychain
import Lock
class Auth0Manager: NSObject {
    
    //创建单利
    static let sharedInstance = Auth0Manager()
    
    let keychain = A0SimpleKeychain(service: "Auth0")
    
    //登陆接口
    class func Auth0Login(emailAddree: String, password: String, success: @escaping (_ credentials: Credentials)->Void, failure: @escaping (_ error: Error)->Void) -> Void {
        Auth0
            .authentication()
            .login(usernameOrEmail: emailAddree, password: password, connection: "mongo-sandbox", scope: "openid profile")
            .start { result in
                DispatchQueue.main.async {
                    
                    switch result {
                    case .success(let credentials):
                        print(credentials.idToken!)
                        print(credentials)
                        print(credentials.accessToken!)
                        success(credentials)
                    case .failure(let error):
                        failure(error)
                    }
                }
        }
        
        
    }
    //注册接口
    class func Auth0Register(emailAddress: String, password: String, zipCode: String, success: @escaping (_ credentials: Credentials)->Void, failure: @escaping (_ error: Error)->Void) -> Void {
        
        
        Auth0
            .authentication()
            .signUp(
                email: emailAddress,
                password: password,
                connection: "mongo-sandbox",
                userMetadata: ["zipCode": zipCode]
            )
            .start { result in
                DispatchQueue.main.async {
                    
                    switch result {
                    case .success(let credentials):
                        //                        print(credentials.idToken!)
                        //                        print(credentials)
                        //                        print(credentials.accessToken!)
                        success(credentials)
                    case .failure(let error):
                        failure(error)
                    }
                }
        }
    }
    
    //创建reset的接口文件
    class func Auth0ResetPassword(emailAddree: String, success: @escaping ((_ credentials: Credentials)->Void), failure: @escaping (_ error: Error)->Void) -> Void {
        //for test 
//        let emailAddree = "jiqing.j.liu@pwc.com"
        Auth0.authentication().resetPassword(email: emailAddree, connection: "mongo-sandbox").start { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(result:let response):
                    print(response)
                    break
                case .failure(error:let error):
                    print(error)
                    break
                }
               
            }
        }
//        let client1 =
//        let client = A0Lock.shared().apiClient()
//        let params = A0AuthParameters.newDefaultParams();
//        params[A0ParameterConnection] = "Username-Password-Authentication";
//        // Or your configured DB connection
//        client.requestChangePassword(forUsername: "<username>", parameters: params,
//                                     success: { _ in
//                                        print("Please check your email!")
//        }, failure: { error in
//            print("Oops something went wrong: \(error)")
//        })
    }
    
    
    
    
    
    
    
    
    
    func storeTheUserID(userID: String) -> Void {
        self.keychain.setString(userID, forKey: "id_token")
    }
    
    func getUserID() -> String? {
        return self.keychain.string(forKey: "id_token")
    }
    
}
