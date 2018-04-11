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
let TO_AVATAR_PICKER = "toAvatarPicker"
let UNWIND = "unwindToChannel"

// Colors
let smackPurplePlaceholder = #colorLiteral(red: 0.3254901961, green: 0.4196078431, blue: 0.7764705882, alpha: 0.5)


// Notification constants
let NOTIFICATION_USER_DATA_DID_CHANGE = Notification.Name("notificationUserDataChanged")

// Users default
let LOGGED_IN_KEY = "loggedIn"
let TOKEN_KEY = "token"
let USER_EMAIL_KEY = "userEmail"

// API URL Constants
let BASE_URL: String = "https://chatforchatters.herokuapp.com/v1/"
let URL_ACCOUNT_REGISTER: String = "\(BASE_URL)account/register"
let URL_LOGIN: String = "\(BASE_URL)account/login"
let URL_USER_ADD: String = "\(BASE_URL)user/add"


let API_HEADER = [
    "Content-type": "application/json; charset=utf-8"
]
