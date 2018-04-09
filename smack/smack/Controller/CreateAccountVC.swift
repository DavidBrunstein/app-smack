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
    
    override func viewDidLoad() {
        super.viewDidLoad()
   }

    @IBAction func chooseAvatarBtnPressed(_ sender: Any) {
    }
    
    @IBAction func generateBackgroundColorBtnPressed(_ sender: Any) {
    }
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        guard let email = emailTxt.text, emailTxt.text != "" else { return }
        guard let password = passwordTxt.text, passwordTxt.text != "" else { return }
        
        AuthServices.instance.registerUser(email: email, password: password) { (success) in
            if success {
                print("account registered!")
                AuthServices.instance.loginUser(email: email, password: password, completion: { (success) in
                    
                    if success {
                        print("user logged in!", AuthServices.instance.authToken)
                    }
                })
            }
        }
    }
    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
}
