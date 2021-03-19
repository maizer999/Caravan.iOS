//
//  MarvelCategoryCollectionViewCell.swift
//  AdForest
//
//  Created by Charlie on 27/08/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MarvelCategoryCollectionViewCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var containerView: UIView!
        {
        didSet{
            containerView.marvelRoundCorners()
            }
    }
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var imgContainer: UIView!
    var btnFullAction: (()->())?
    var isAnimated : Bool!
    @IBAction func actionFullButton(_ sender: Any) {
        self.btnFullAction?()
    }
    
}
