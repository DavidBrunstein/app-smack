//
//  AvatarPickerVC.swift
//  smack
//
//  Created by David Brunstein on 2018-04-10.
//  Copyright © 2018 David Brunstein. All rights reserved.
//

import UIKit

class AvatarPickerVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // Outlets
    
    @IBOutlet weak var avatarPickerCollectionView: UICollectionView!
    @IBOutlet weak var darkOrLightSegmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarPickerCollectionView.delegate = self
        avatarPickerCollectionView.dataSource = self
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = avatarPickerCollectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as? AvatarCell {
            return cell
        }
        return UICollectionViewCell()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    
    @IBAction func darkOrLightSegmentedControlSelected(_ sender: Any) {
        
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
