//
//  AuthServices.swift
//  smack
//
//  Created by David Brunstein on 2018-04-09.
//  Copyright © 2018 David Brunstein. All rights reserved.
//

// This class handle all the user managements via calls to the API

import Foundation
import Alamofire
import SwiftyJSON

class AuthServices {
    
    // Singleton
    static let instance = AuthServices()
    
    func registerUser (email: String, password: String, completion: @escaping CompletionHander) {
        
        let lowerCaseEmail = email.lowercased()
        

        let body: [String: Any] = [
        "email": lowerCaseEmail,
        "password": password
        ]
        
        Alamofire.request(URL_ACCOUNT_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: API_HEADER).responseString { (response) in
            
                if response.result.error == nil {
                    completion(true)
                } else {
                    completion(false)
                    debugPrint(response.result.error as Any)
                }
        }
    }
    
    func loginUser (email: String, password: String, completion: @escaping CompletionHander) {
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
            Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: API_HEADER).responseJSON { (response) in
                
                if response.result.error == nil {
                    
                    //                if let json = response.result.value as? Dictionary<String, Any> {
                    //                    if let userEmail = json["user"] as? String {
                    //                        self.userEmail = userEmail
                    //                    }
                    //                    if let token = json["token"] as? String {
                    //                        self.authToken = token
                    //                    }
                    //                }
                    
                    // Using SwiftyJSON
                    guard let data = response.data else { return }
                    let jsonData = JSON(data)
                    self.userEmail = jsonData["user"].stringValue
                    self.authToken = jsonData["token"].stringValue

                    self.isLoggedIn = true
                    completion(true)
                    
                } else {
                    completion(false)
                    debugPrint(response.result.error as Any)
                }
                
            }
    }
    
    func createUser(userName: String, userEmail: String, avatarImageName: String, backgroundColor: String, completion: @escaping CompletionHander) {
        
        let lowerCaseEmail = userEmail.lowercased()
        
        let header = [
            "Authorization" : "Bearer \(self.authToken)",
            "Content-type": "application/json; charset=utf-8"
        ]
        let body: [String: Any] = [
            "name" : userName,
            "email": lowerCaseEmail,
            "avatarName" : avatarImageName,
            "avatarColor" : backgroundColor
        ]
        
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else { return }
                let jsonData = JSON(data)
                let id = jsonData["_id"].stringValue
                let backgroundColor = jsonData["avatarColor"].stringValue
                let avatarImageName = jsonData["avatarName"].stringValue
                let userEmail = jsonData["email"].stringValue
                let userName = jsonData["name"].stringValue
                
                UserDataService.instance.setUserData(id: id, backgroundColor: backgroundColor, avatarImageName: avatarImageName, userEmail: userEmail, userName: userName)
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }

    }
    
    
    // User defaults persisted between app runs
    let defaults = UserDefaults.standard
    
    var isLoggedIn : Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL_KEY)
        }
    }
    
            
}
