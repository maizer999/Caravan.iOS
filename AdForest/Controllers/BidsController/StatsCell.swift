//
//  StatsCell.swift
//  AdForest
//
//  Created by apple on 4/12/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class StatsCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.backgroundColor = UIColor.groupTableViewBackground
        }
    }
    @IBOutlet weak var imgProfile: UIImageView! {
        didSet {
            imgProfile.round()
        }
    }
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblNumber: UILabel!{
        didSet {
            lblNumber.round()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = UIColor.groupTableViewBackground
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
