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

class AuthServices {
    
    // Singleton
    static let instance = AuthServices()
    
    func registerUser (email: String, password: String, completion: @escaping CompletionHander) {
        
        let lowerCaseEmail = email.lowercased()
        
        let header = [
            "Content-type": "application/json; charset=utf-8"
        ]
        let body: [String: Any] = [
        "email": lowerCaseEmail,
        "password": password
        ]
        
        Alamofire.request(URL_ACCOUNT_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseString { (response) in
            
                if response.result.error == nil {
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
