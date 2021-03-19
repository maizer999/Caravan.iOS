//
//  SimilarAdsCell.swift
//  AdForest
//
//  Created by apple on 4/10/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class SimilarAdsCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblPrice: UILabel! {
        didSet {
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                lblPrice.textColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    
    //MARK:- Properties
    
    var btnActionFull: (()->())?
    
    @IBAction func actionBigbutton(_ sender: Any) {
        self.btnActionFull?()
    }
}
