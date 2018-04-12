//
//  LoginVC.swift
//  smack
//
//  Created by David Brunstein on 2018-04-05.
//  Copyright © 2018 David Brunstein. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    // Outlets
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        
        // start the spinner
        loginSpinner.isHidden = false
        loginSpinner.startAnimating()
        
        guard let userName = userNameTxt.text, userNameTxt.text != "" else { return }
        guard let password = passwordTxt.text, passwordTxt.text != "" else { return }

        AuthServices.instance.loginUser(email: userName, password: password) { (success) in
            if success {
                AuthServices.instance.findUserByEmail(completion: { (success) in
                    if success {
                        // the user data is already repopulated
                        
                        // stop the spinner
                        self.loginSpinner.isHidden = true
                        self.loginSpinner.stopAnimating()

                        // Send the notification out
                        NotificationCenter.default.post(name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
        
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
    func setupView() {
        // hide the login spinner
        loginSpinner.isHidden = true
        
        // font color of the texts placeholder
        userNameTxt.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
    }
}
