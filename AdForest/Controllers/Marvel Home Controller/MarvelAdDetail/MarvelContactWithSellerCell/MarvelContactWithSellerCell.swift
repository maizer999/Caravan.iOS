//
//  MarvelContactWithSellerCell.swift
//  AdForest
//
//  Created by Charlie on 05/10/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MarvelContactWithSellerCell: UITableViewCell {
    @IBOutlet weak var lblMainHeading: UILabel!
    
    @IBOutlet weak var btnClickNow: UIButton!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                btnClickNow.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var lblSubHeading: UILabel!
    @IBOutlet weak var imgViewContact: UIImageView!
    @IBOutlet weak var imgViewRound: UIImageView!{
        didSet{
            imgViewRound.makeRounded()
        }
    }
    @IBOutlet weak var containerView: UIView!
    
    var ContactSeller : (()->())?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func ContactSellerAction(_ sender: Any) {
        self.ContactSeller?()
    }
    
    
}
