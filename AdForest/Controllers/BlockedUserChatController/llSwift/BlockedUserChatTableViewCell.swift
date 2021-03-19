//
//  BlockedUserChatTableViewCell.swift
//  AdForest
//
//  Created by apple on 9/4/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class BlockedUserChatTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgProfile: UIImageView!{
        didSet {
            imgProfile.round()
        }
    }
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var oltUnBlock: UIButton!
    
    
    let defaults = UserDefaults.standard
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        oltUnBlock.backgroundColor = UIColor(hex: defaults.string(forKey: "mainColor")!)
        oltUnBlock.roundCornors()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
