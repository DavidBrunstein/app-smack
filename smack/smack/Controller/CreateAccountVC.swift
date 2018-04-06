//
//  CreateAccountVC.swift
//  smack
//
//  Created by David Brunstein on 2018-04-05.
//  Copyright © 2018 David Brunstein. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
   }

    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
}
