//
//  CategoriesCollectionCell.swift
//  AdForest
//
//  Created by apple on 4/17/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class CategoriesCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var imgContainer: UIView! {
        didSet {
//            containerView.backgroundColor = UIColor.red
            containerView.layer.masksToBounds = true
            containerView.layer.cornerRadius = 10
            containerView.layer.borderWidth = 0.0
            containerView.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    
    var btnFullAction: (()->())?
    
    
    @IBAction func actionFullButton(_ sender: Any) {
        self.btnFullAction?()
    }
    
}
