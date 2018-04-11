//
//  CreateAccountVC.swift
//  smack
//
//  Created by David Brunstein on 2018-04-05.
//  Copyright © 2018 David Brunstein. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    // Outlets
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var profileDefaultImg: UIImageView!
    @IBOutlet weak var createAccountSpinner: UIActivityIndicatorView!
    
    // Variables
    var avatarImageName: String = "profileDefault"
    var backgroundColor: String = "[0.5, 0.5, 0.5, 1]"
    var avatarBackgroundColor : UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
   }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarImageName != "" {
            profileDefaultImg.image = UIImage(named: UserDataService.instance.avatarImageName)
            avatarImageName = UserDataService.instance.avatarImageName
            
            // Change the background of light avatars with no background color selected
            if avatarImageName.contains("light") && avatarBackgroundColor == nil {
                profileDefaultImg.backgroundColor = UIColor.lightGray
            }
        }
    }

    @IBAction func chooseAvatarBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    @IBAction func generateBackgroundColorBtnPressed(_ sender: Any) {
        // Randomly generated UIColor to use as the avatar image background
        
        let red : CGFloat = CGFloat(arc4random_uniform(255)) / 255
        let green : CGFloat = CGFloat(arc4random_uniform(255)) / 255
        let blue : CGFloat = CGFloat(arc4random_uniform(255)) / 255
        avatarBackgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        UIView.animate(withDuration: 0.2) {
            self.profileDefaultImg.backgroundColor = self.avatarBackgroundColor
        }
    }
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        
        // start the spinner
        createAccountSpinner.isHidden = false
        createAccountSpinner.startAnimating()
        
        guard let userName = userNameTxt.text, userNameTxt.text != "" else { return }
        guard let email = emailTxt.text, emailTxt.text != "" else { return }
        guard let password = passwordTxt.text, passwordTxt.text != "" else { return }
        
        AuthServices.instance.registerUser(email: email, password: password) { (success) in
            if success {
                print("account registered!")
                AuthServices.instance.loginUser(email: email, password: password, completion: { (success) in
                    
                    if success {
                        print("user logged in!", AuthServices.instance.authToken)
                        AuthServices.instance.createUser(userName: userName, userEmail: email, avatarImageName: self.avatarImageName, backgroundColor: self.backgroundColor, completion: { (success) in
                            
                            if success {
                                // stop the spinner
                                self.createAccountSpinner.isHidden = true
                                self.createAccountSpinner.stopAnimating()
                                
                                print(UserDataService.instance.userName, UserDataService.instance.avatarImageName)
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                                
                                // Send the notification out
                                NotificationCenter.default.post(name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
                            }
                        })
                    }
                })
            }
        }
    }
    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    func setupView() {
        // hide the create account spinner
        createAccountSpinner.isHidden = true
        
        // font color of the texts placeholder
        userNameTxt.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        
        // the keyboard disappears when tap outside the text fields
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        // makes the keyboard to disapear
        view.endEditing(true)
    }
    
}
