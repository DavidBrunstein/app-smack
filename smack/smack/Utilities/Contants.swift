//
//  Contants.swift
//  smack
//
//  Created by David Brunstein on 2017-12-29.
//  Copyright © 2017 David Brunstein. All rights reserved.
//

import Foundation

typealias CompletionHander = (_ Success: Bool) -> ()


// Segues
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"


// Users default
let LOGGED_IN_KEY = "loggedIn"
let TOKEN_KEY = "token"
let USER_EMAIL_KEY = "userEmail"

// API URL Constants
let BASE_URL: String = "https://chatforchatters.herokuapp.com/v1/"
let URL_ACCOUNT_REGISTER: String = "\(BASE_URL)account/register"
