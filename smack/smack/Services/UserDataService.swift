//
//  UserDataService.swift
//  smack
//
//  Created by David Brunstein on 2018-04-09.
//  Copyright © 2018 David Brunstein. All rights reserved.
//

import Foundation

class UserDataService {
    
    // Singleton
    static let instance = UserDataService()
    
    public private(set) var id = ""
    public private(set) var backgroundColor = ""
    public private(set) var avatarImageName = ""
    public private(set) var userEmail = ""
    public private(set) var userName = ""
    
    func setUserData(id: String, backgroundColor: String, avatarImageName: String, userEmail: String, userName: String) {
        
        self.id = id
        self.backgroundColor = backgroundColor
        self.avatarImageName = avatarImageName
        self.userEmail = userEmail
        self.userName = userName
    }
    
    func setAvatarImageName(avatarImageName: String) {
        self.avatarImageName = avatarImageName
    }
    
}
