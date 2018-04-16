//
//  ChatVC.swift
//  smack
//
//  Created by David Brunstein on 2017-12-27.
//  Copyright © 2017 David Brunstein. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messagesTableView: UITableView!
    
    @IBOutlet weak var messageTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messagesTableView.estimatedRowHeight = 80
        messagesTableView.rowHeight = UITableViewAutomaticDimension
        
        // bindToKeyboard is an extension of UIView.
        // It makes the view to scroll up when the keyboard appears from the bottom of the page
        view.bindToKeyboard()
        
        // Adding a tap gesture so the view scrolls down to the original position when the keyboard is dismissed
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)

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
    

    @IBAction func sendMessageBtnPressed(_ sender: Any) {
        if AuthServices.instance.isLoggedIn {
            guard let channelId = MessageService.instance.selectedChannel?.channelId else { return }
            guard let messageText = messageTxt.text else { return }

            SocketService.instance.addMessage(messageText: messageText, userId: UserDataService.instance.id, channelId: channelId) { (success) in
                if success {
                    // Blank the message text
                    self.messageTxt.text = ""
                    // dismiss the keyboard
                    self.messageTxt.resignFirstResponder()
                }
            }
        }
        
    }
    func getMessages() {
        guard let channelId = MessageService.instance.selectedChannel?.channelId else { return }
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (success) in
            if success {
                // Once we retrieve the messages, let's reload the table data
                self.messagesTableView.reloadData()
            } else {
                print("error getting the messages!")
            }
        }
    }
    
    @objc func handleTap() {
        // Tapping outside the text field will end the editting and dismiss the keyboard
        view.endEditing(true)
    }
    
    // Messages table view methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = messagesTableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell {
            
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
}
