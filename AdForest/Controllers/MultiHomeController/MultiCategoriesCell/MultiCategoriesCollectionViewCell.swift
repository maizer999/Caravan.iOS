//
//  MultiCategoriesCollectionViewCell.swift
//  AdForest
//
//  Created by Charlie on 12/10/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MultiCategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnCatImg: UIButton!
    @IBOutlet weak var imgCat: UIImageView!
    @IBOutlet weak var imgContainer: UIView!{
        didSet{
            imgContainer.layer.cornerRadius = imgContainer.frame.size.width/2
            imgContainer.clipsToBounds = true

            imgContainer.layer.borderColor = UIColor.white.cgColor
//            imgContainer.layer.borderWidth = 5.0
        }
    }
    @IBOutlet weak var lblCatName: UILabel!
    @IBOutlet weak var containerView: UIView!
    var btnFullAction: (()->())?
    var isAnimated : Bool!
    @IBAction func actionFullButton(_ sender: Any) {
        self.btnFullAction?()
    }
    
}
