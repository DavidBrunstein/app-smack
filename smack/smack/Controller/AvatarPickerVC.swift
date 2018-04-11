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
    
    // Variables
    var avatarTone = AvatarTone.dark
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarPickerCollectionView.delegate = self
        avatarPickerCollectionView.dataSource = self
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = avatarPickerCollectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as? AvatarCell {
            cell.configureCell(index: indexPath.item, tone: avatarTone)
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Sets the number of columns depending on the iPhone screen size
        var numberOfColumns : CGFloat = 3
        if UIScreen.main.bounds.width > 320 {
            numberOfColumns = 4
        }
        
        let spaceBetweenCells : CGFloat = 10
        let leftAndRightPadding : CGFloat = 40
        let cellDimension : CGFloat = ( (avatarPickerCollectionView.bounds.width - leftAndRightPadding) -
                                        (spaceBetweenCells * (numberOfColumns - 1)) ) / numberOfColumns
        
        // It is a square
        return CGSize(width: cellDimension, height: cellDimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if avatarTone == .dark {
            UserDataService.instance.setAvatarImageName(avatarImageName: "dark\(indexPath.item)")
        } else {
            UserDataService.instance.setAvatarImageName(avatarImageName: "light\(indexPath.item)")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func darkOrLightSegmentedControlSelected(_ sender: Any) {
        if darkOrLightSegmentControl.selectedSegmentIndex == 0 {
            avatarTone = .dark
        } else {
            avatarTone = .light
        }
        avatarPickerCollectionView.reloadData()
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
