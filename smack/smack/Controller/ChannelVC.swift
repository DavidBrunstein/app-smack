//
//  ChannelVC.swift
//  smack
//
//  Created by David Brunstein on 2017-12-27.
//  Copyright © 2017 David Brunstein. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    @IBOutlet weak var userProfileAvatarImg: SmackCircleImage!
    @IBOutlet weak var channelsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        channelsTableView.delegate = self
        channelsTableView.dataSource = self

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
        // Listen to the notification user data changes
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)

        // Listen to the notification the channels are loaded
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.channelsLoaded(_:)), name: NOTIFICATION_CHANNELS_LOADED, object: nil)

        // Get any new channel from the server
        SocketService.instance.getChannel { (success) in
            if success {
                self.channelsTableView.reloadData()
            }
        }
        
        // Get new messages from other users
        SocketService.instance.getMessage { (newMessage) in
            if newMessage.channelId != MessageService.instance.selectedChannel?.channelId && AuthServices.instance.isLoggedIn {
                MessageService.instance.unreadChannels.append(newMessage.channelId)
                self.channelsTableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUserInfo()
    }

    @IBAction func createChannelBtnPressed(_ sender: Any) {
        // Check if we are logged before presenting the create channel modal page
        if AuthServices.instance.isLoggedIn {
            let createChannel = CreateChannelVC()
            createChannel.modalPresentationStyle = .custom
            present(createChannel, animated: true, completion: nil)
        }
    }
    @IBAction func loginBtnPressed(_ sender: Any) {
        if AuthServices.instance.isLoggedIn {
            // Show the profile page (XIB file)
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
            
        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    
    @objc func userDataDidChange(_ notif: Notification) {
        // This function is called when the notification is broadcasted (posted)
        // We are going to update the UI
        setupUserInfo()
     }
    func setupUserInfo() {
        if AuthServices.instance.isLoggedIn {
            loginBtn.setTitle(UserDataService.instance.userName, for: .normal)
            userProfileAvatarImg.image = UIImage(named: UserDataService.instance.avatarImageName)
            userProfileAvatarImg.backgroundColor = UserDataService.instance.stringToUIColor(colorComponents: UserDataService.instance.backgroundColor)
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userProfileAvatarImg.image = UIImage(named: "menuProfileIcon")
            userProfileAvatarImg.backgroundColor = UIColor.clear
            channelsTableView.reloadData()
        }
    }
    
    @objc func channelsLoaded(_ notif: Notification) {
        // This function is called when the notification is broadcasted (posted)
        // We are going to update the UI
        channelsTableView.reloadData()
    }
    
    // Channels Table View
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = channelsTableView.dequeueReusableCell(withIdentifier: "ChannelCell", for: indexPath ) as? ChannelCell {
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Save the selected channel into the MessageService variable when we select a row
        // Then send out the nofitification. The ChatVC will be notified the channel has been selected
        // Then we dismiss the menu to go back to the ChatVC page
        
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        
        // Check the unread messages in the channels
        if MessageService.instance.unreadChannels.count > 0 {
            MessageService.instance.unreadChannels = MessageService.instance.unreadChannels.filter{ $0 != channel.channelId }
        }
        let index:IndexPath = IndexPath(row: indexPath.row, section: 0)
        channelsTableView.reloadRows(at: [index], with: .none)
        channelsTableView.selectRow(at: index, animated: false, scrollPosition: .none)
        
        
        // Send the notification out
        NotificationCenter.default.post(name: NOTIFICATION_CHANNEL_SELECTED, object: nil)
        
        // Reveeal Toggle is to switch back and forth the menu
        self.revealViewController().rightRevealToggle(animated: true)

    }
    
}
