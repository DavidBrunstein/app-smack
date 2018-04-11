//
//  ProrfileVCViewController.swift
//  smack
//
//  Created by David Brunstein on 2018-04-11.
//  Copyright © 2018 David Brunstein. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    // Outlets
    @IBOutlet weak var profileUserAvatarImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
     }

    @IBAction func logoutBtnPressed(_ sender: Any) {
        UserDataService.instance.logoutUser()
        
        // Send the notification out
        NotificationCenter.default.post(name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func setupView() {
        profileUserAvatarImg.image = UIImage(named: UserDataService.instance.avatarImageName)
        userNameLbl.text = UserDataService.instance.userName
        userEmailLbl.text = UserDataService.instance.userEmail
        profileUserAvatarImg.backgroundColor = UserDataService.instance.stringToUIColor(colorComponents: UserDataService.instance.backgroundColor)
        
        // If tap outside the profile will dismiss the profile page
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.closeTap(_:)))
        backgroundView.addGestureRecognizer(closeTouch)
        
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
