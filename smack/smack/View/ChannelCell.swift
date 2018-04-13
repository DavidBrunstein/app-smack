//
//  ChannelCell.swift
//  smack
//
//  Created by David Brunstein on 2018-04-13.
//  Copyright © 2018 David Brunstein. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var channelName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            // set the background color to whyte with low opacity
            self.layer.backgroundColor = UIColor(white: 1.0, alpha: 0.20).cgColor
        } else {
            // set the background color to normal with low opacity
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func configureCell(channel: Channel) {
        let name = channel.channelName
        channelName.text = "#\(name)"
    }

}
