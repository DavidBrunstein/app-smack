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
    
    // Variables
    var avatarImageName: String = "profileDefault"
    var backgroundColor: String = "[0.5, 0.5, 0.5, 1]"
    
    override func viewDidLoad() {
        super.viewDidLoad()
   }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarImageName != "" {
            profileDefaultImg.image = UIImage(named: UserDataService.instance.avatarImageName)
            avatarImageName = UserDataService.instance.avatarImageName
        }
    }

    @IBAction func chooseAvatarBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    @IBAction func generateBackgroundColorBtnPressed(_ sender: Any) {
    }
    @IBAction func createAccountBtnPressed(_ sender: Any) {
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
                                print(UserDataService.instance.userName, UserDataService.instance.avatarImageName)
                                
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
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
    
}
