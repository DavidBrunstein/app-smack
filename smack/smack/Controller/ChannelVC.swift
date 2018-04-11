//
//  ChannelVC.swift
//  smack
//
//  Created by David Brunstein on 2017-12-27.
//  Copyright © 2017 David Brunstein. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    // Outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    @IBOutlet weak var userProfileAvatarImg: SmackCircleImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
        // Listen to the notification center
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
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
}
