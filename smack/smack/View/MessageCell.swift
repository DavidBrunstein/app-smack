//
//  MessageCell.swift
//  smack
//
//  Created by David Brunstein on 2018-04-16.
//  Copyright © 2018 David Brunstein. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    // Outlets
    
    @IBOutlet weak var userAvatarImg: SmackCircleImage!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var messageTextLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(message: Message) {
        messageTextLbl.text = message.messageText
        userNameLbl.text = message.userName
        userAvatarImg.image = UIImage(named: message.userAvatar)
        userAvatarImg.backgroundColor = UserDataService.instance.stringToUIColor(colorComponents: message.userAvatarColor)
        
        // Time label requires date conversion
    }
}
