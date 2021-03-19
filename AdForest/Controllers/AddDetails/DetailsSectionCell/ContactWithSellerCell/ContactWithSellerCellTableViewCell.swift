//
//  ContactWithSellerCellTableViewCell.swift
//  AdForest
//
//  Created by Glixen on 18/08/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ContactWithSellerCellTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
//    {
//        didSet{
//            containerView.addShadowToView()
//
//        }
//    }
    @IBOutlet weak var btnContactSeller: UIButton!
    @IBOutlet weak var imgViewMessage: UIImageView!
    @IBOutlet weak var lblSubHeading: UILabel!
    @IBOutlet weak var lblMainHeading: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgViewRound: UIImageView!{
        didSet{
            imgViewRound.makeRounded()
        }
    }
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
