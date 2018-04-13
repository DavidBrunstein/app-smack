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
        
        // Listen to the notification center
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUserInfo()
    }

    @IBAction func createChannelBtnPressed(_ sender: Any) {
        let createChannel = CreateChannelVC()
        createChannel.modalPresentationStyle = .custom
        present(createChannel, animated: true, completion: nil)
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
        }
    }
    
    // Channels Table View
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = channelsTableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath ) as? ChannelCell {
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
    
}
