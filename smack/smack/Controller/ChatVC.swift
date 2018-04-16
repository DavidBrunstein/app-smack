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
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var messageTxt: UITextField!
    @IBOutlet weak var typingUsersLbl: UILabel!
    
    // Variables
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messagesTableView.estimatedRowHeight = 80
        messagesTableView.rowHeight = UITableViewAutomaticDimension
        
        sendBtn.isHidden = true
        
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

        SocketService.instance.getMessage { (success) in
            if success {
                self.messagesTableView.reloadData()
                if MessageService.instance.messages.count > 0 {
                    let endIndex: IndexPath = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                    self.messagesTableView.scrollToRow(at: endIndex, at: .bottom, animated: true)
                }
            }
        }
        
        // Update the Typing... label text when other users are typing
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.channelId else { return }
            var userNames = ""
            var numberOfUsersTyping = 0
            
            for (typingUser, channel) in typingUsers {
                // Check if the typing user is not us and the channel the user is typing on is the selected channel
                if typingUser != UserDataService.instance.userName && channel == channelId {
                    if userNames == "" {
                        // First person
                        userNames = typingUser
                    } else {
                        userNames = "\(userNames), \(typingUser)"
                    }
                    numberOfUsersTyping += 1
                }
            }
            
            if numberOfUsersTyping > 0 && AuthServices.instance.isLoggedIn {
                var textWording = "is"
                if numberOfUsersTyping > 1 {
                    textWording = "are"
                }
                self.typingUsersLbl.text = "\(userNames) \(textWording) typing a message..."
            } else {
                self.typingUsersLbl.text = ""
            }
        }
        
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
            messagesTableView.reloadData()
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
    


    
    @IBAction func messageTxtEditing(_ sender: Any) {
        if messageTxt.text == "" {
            isTyping = false
            sendBtn.isHidden = true
            SocketService.instance.stopTyping()
        } else {
            if !isTyping {
                sendBtn.isHidden = false
                SocketService.instance.startTyping()
            }
            isTyping = true
        }
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
                    
                    // Let all know the user stopped typing
                    SocketService.instance.stopTyping()
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
