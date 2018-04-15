//
//  ChatVC.swift
//  smack
//
//  Created by David Brunstein on 2017-12-27.
//  Copyright © 2017 David Brunstein. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    // Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        // Observer the user data has changed
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
        
        // Observer the channel has been selected
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelHasBeenSelected(_:)), name: NOTIFICATION_CHANNEL_SELECTED, object: nil)

        if AuthServices.instance.isLoggedIn {
            AuthServices.instance.findUserByEmail { (sucesss) in
                // Send the notification out
                NotificationCenter.default.post(name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
            }
        }
        
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthServices.instance.isLoggedIn {
            onLoginGetMessages()
            
        } else {
            channelNameLbl.text = "Please Log In"
        }
    }
    func onLoginGetMessages() {
        MessageService.instance.findAllChannels { (success) in
            if success {
                // Check if there is any channel already created
                if MessageService.instance.channels.count > 0 {
                    // We are selecting the first from the list
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    // there are no channels yet
                    self.channelNameLbl.text = "No channels yet!"
                }
            }
        }
    }

    @objc func channelHasBeenSelected(_ notif: Notification) {
        updateWithChannel()
    }
    
    func updateWithChannel() {
        // update the title label with the name of the selected channel
        let channelName = MessageService.instance.selectedChannel?.channelName ?? ""
        channelNameLbl.text = "#\(channelName)"
        
        // Get the messages for the selected channel
        self.getMessages()
    }
    
    func getMessages() {
        guard let channelId = MessageService.instance.selectedChannel?.channelId else { return }
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (success) in
            if success {
                
            }
        }
    }
}
