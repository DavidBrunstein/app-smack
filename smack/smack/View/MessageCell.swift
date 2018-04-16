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
        // We have to remove the millisec
        guard let isoDate = message.timeStamp else { return }
        let end = isoDate.index(isoDate.endIndex, offsetBy: -5)
        let correctIsoDate = isoDate[..<end]
        
        let isoFormatter = ISO8601DateFormatter()
        let timeStamp = isoFormatter.date(from: correctIsoDate.appending("Z"))
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMM d, h:mm a"
        if let finalDate = timeStamp {
            let finalDate = newFormatter.string(from: finalDate)
            self.timeStampLbl.text = finalDate
        }
        
    }
}
