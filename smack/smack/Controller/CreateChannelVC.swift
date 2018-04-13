//
//  CreateChannelVC.swift
//  smack
//
//  Created by David Brunstein on 2018-04-13.
//  Copyright © 2018 David Brunstein. All rights reserved.
//

import UIKit

class CreateChannelVC: UIViewController {

    // Outlets
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var descriptionTxt: UITextField!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var channelView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }


    @IBAction func createChannelBtnPressed(_ sender: Any) {
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        // Allow the user to tap outside the view and close it
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(CreateChannelVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
        
        // Placeholder text color is purple
        nameTxt.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        descriptionTxt.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])

        channelView.layer.cornerRadius = 5.0
        channelView.clipsToBounds = true
   }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
