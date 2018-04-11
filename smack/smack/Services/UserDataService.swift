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
    
    func stringToUIColor(colorComponents: String) -> UIColor {
        
        let defaultColor = UIColor.lightGray
        
        let colorScanner = Scanner(string: colorComponents)
        let skipped = CharacterSet(charactersIn: "[], ")
        let separator = CharacterSet(charactersIn: ",")
        colorScanner.charactersToBeSkipped = skipped
        
        var red, green, blue, alpha : NSString?
        colorScanner.scanUpToCharacters(from: separator, into: &red)
        colorScanner.scanUpToCharacters(from: separator, into: &green)
        colorScanner.scanUpToCharacters(from: separator, into: &blue)
        colorScanner.scanUpToCharacters(from: separator, into: &alpha)

        guard let redUnwrapped = red else { return defaultColor }
        guard let greenUnwrapped = green else { return defaultColor }
        guard let blueUnwrapped = blue else { return defaultColor }
        guard let alphaUnwrapped = alpha else { return defaultColor }
        
        let redFloat = CGFloat(redUnwrapped.doubleValue)
        let greenFloat = CGFloat(greenUnwrapped.doubleValue)
        let blueFloat = CGFloat(blueUnwrapped.doubleValue)
        let alphaFloat = CGFloat(alphaUnwrapped.doubleValue)

        let newUIColor = UIColor(red: redFloat, green: greenFloat, blue: blueFloat, alpha: alphaFloat)
        return newUIColor
    }
    
}
