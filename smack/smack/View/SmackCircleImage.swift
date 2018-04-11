//
//  SmackCircleImage.swift
//  smack
//
//  Created by David Brunstein on 2018-04-11.
//  Copyright © 2018 David Brunstein. All rights reserved.
//

import UIKit

@IBDesignable
class SmackCircleImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setupView()
    }
    
    func setupView() {
        // assuming the image is a square
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
}
