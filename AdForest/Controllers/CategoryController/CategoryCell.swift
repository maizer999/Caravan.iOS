//
//  CategoryCell.swift
//  AdForest
//
//  Created by apple on 4/18/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblPath: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblPrice: UILabel!{
        didSet {
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                self.lblPrice.textColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

}
